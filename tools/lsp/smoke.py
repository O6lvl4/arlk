#!/usr/bin/env python3
"""Drive `arlk lsp` through a session: open a good file (no diagnostics),
change it to a wrong proof (a diagnostic on that line), hover a constant
(its type), shut down.

    python3 tools/lsp/smoke.py ARLK
"""
import json, os, subprocess, sys

arlk = sys.argv[1]
root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
p = subprocess.Popen([arlk, "lsp"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, cwd=root)

def send(msg):
    body = json.dumps(msg).encode()
    p.stdin.write(b"Content-Length: %d\r\n\r\n" % len(body) + body)
    p.stdin.flush()

def receive():
    length = None
    while True:
        line = p.stdout.readline().decode().strip()
        if line == "":
            break
        if line.lower().startswith("content-length:"):
            length = int(line.split(":")[1])
    return json.loads(p.stdout.read(length))

fails = 0
def expect(name, ok, detail=""):
    global fails
    print(("pass  " if ok else "FAIL  ") + name + ("" if ok else ": " + detail))
    fails += 0 if ok else 1

send({"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {"rootUri": "file://" + root}})
r = receive()
expect("initialize", r.get("result", {}).get("capabilities", {}).get("hoverProvider") is True, json.dumps(r))
send({"jsonrpc": "2.0", "method": "initialized", "params": {}})

path = os.path.join(root, "examples/std/wf.arlk")
uri = "file://" + path
text = open(path).read()
send({"jsonrpc": "2.0", "method": "textDocument/didOpen", "params": {"textDocument": {"uri": uri, "languageId": "arlk", "version": 1, "text": text}}})
d = receive()
expect("a good file has no diagnostics", d["method"] == "textDocument/publishDiagnostics" and d["params"]["diagnostics"] == [], json.dumps(d)[:400])

lines = text.split("\n")
at = next(i for i, l in enumerate(lines) if l.startswith("theorem seven_div_two"))
bad = text.replace("theorem seven_div_two: Eq(Nat, div(n7, n2), n3)", "theorem seven_div_two: Eq(Nat, div(n7, n2), n4)")
send({"jsonrpc": "2.0", "method": "textDocument/didChange", "params": {"textDocument": {"uri": uri, "version": 2}, "contentChanges": [{"text": bad}]}})
d = receive()
diags = d["params"]["diagnostics"]
expect("a wrong proof is reported on its line", len(diags) == 1 and diags[0]["range"]["start"]["line"] == at and "type mismatch" in diags[0]["message"], json.dumps(diags)[:400])

col = lines[at].index("div(") + 1
send({"jsonrpc": "2.0", "id": 2, "method": "textDocument/hover", "params": {"textDocument": {"uri": uri}, "position": {"line": at, "character": col}}})
h = receive()
value = (h.get("result") or {}).get("contents", {}).get("value", "")
expect("hover shows a constant's type", "wfdemo.div: (n: nat.Nat, d: nat.Nat) -> nat.Nat" in value, json.dumps(h)[:400])

send({"jsonrpc": "2.0", "id": 3, "method": "shutdown"})
receive()
send({"jsonrpc": "2.0", "method": "exit"})
p.wait(timeout=30)
expect("exit", p.returncode == 0, str(p.returncode))
sys.exit(1 if fails else 0)
