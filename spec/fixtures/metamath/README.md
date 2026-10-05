# Metamath fixtures for distinct-variable conditions

`base.mm` declares a tiny logic with `$d` conditions (`ax-5`: x apart from ph;
`ax-dv`: x apart from y) and an axiom whose hypothesis forces a dummy variable
(`ax-drop`). Each other file includes it and adds theorems:

| File | Expected | What it covers |
|---|---|---|
| good.mm | accepted | a mandatory `$d` pair as an explicit obligation (normal and compressed proofs); setvars named with punctuation (`.a`, `.b`) staying distinct; a dummy variable chosen fresh, apart from `ps` (normal and compressed) |
| missing.mm | rejected | the theorem lacks the `$d` its proof needs |
| collapse.mm | rejected | a use identifies two variables that must be distinct |
| dummy.mm | rejected | a dummy variable that must stay apart from `ps`, with nothing saying so |

The expectations were cross-checked with the reference verifier
[mmverify.py](https://github.com/david-a-wheeler/mmverify.py) at commit `63a2aa3815cd`
(Python 3.14.6):

```
python3 mmverify.py good.mm       # no output: verified
python3 mmverify.py missing.mm    # MMError: Disjoint variable violation: ps , x
python3 mmverify.py collapse.mm   # MMError: Disjoint variable violation: .a , .a
python3 mmverify.py dummy.mm      # MMError: Disjoint variable violation: ps , z
```

This checks the fixtures' expected verdicts, not the translation as a whole. The tests are in
`spec/metamath_test.almd`.
