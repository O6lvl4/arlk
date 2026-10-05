#!/usr/bin/env python3
# Lexical tokens of Arlk/Bend sources, as #17 counts them: line comments
# removed, then [A-Za-z_][A-Za-z_0-9.]*|[0-9]+|->|=>|==|<>|[^\s]. These are
# lexical tokens, not model tokens or a measure of human effort.
#
#   tools/tokens.py FILE...        prints "tokens lines FILE" per file
import re, sys
TOKEN = re.compile(r"[A-Za-z_][A-Za-z_0-9.]*|[0-9]+|->|=>|==|<>|[^\s]")
for path in sys.argv[1:]:
    text = open(path, encoding="utf-8").read()
    comment = "#" if path.endswith(".bend") else "//"
    lines = [l.split(comment, 1)[0] for l in text.splitlines()]
    code = [l for l in lines if l.strip()]
    print(len(TOKEN.findall("\n".join(lines))), len(code), path)
