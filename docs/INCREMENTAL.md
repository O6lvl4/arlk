# Incremental checking

`arlk session STEP_DIR...` checks a sequence of source states in one process. A step is a
directory whose `files.txt` lists its sources in checking order. The first step is checked in full.
After that, each step checks again only what an edit could have affected, and reuses the rest from
the previous step. Each step reports how many units were checked and reused, and *why* each
checked unit was checked. It then prints a digest of the result, which a fresh process must
reproduce: `arlk check FILE... --digest`.

## What may be reused

A unit is one top-level declaration. Its key is the hash of its text and of the room header it is
checked under. A unit is reused, meaning its additions are copied from the previous step's
environment without being checked, only when all of these hold:

1. **Same unit.** A unit with the same key succeeded in the previous step. A unit that failed is
   always checked again.
2. **Same place.** It is checked in the same room, and that room sees the same rooms.
3. **Its dependencies exist.** Everything its elaborated statement and proof mention is declared at
   this point, so a dependency that moved after it is noticed.
4. **Nothing it rests on changed.** A name changed if its meaning to users differs. Here "meaning"
   is its kind, room, statement, a definition's body, universe parameters, implicit arguments, the
   rewrite rules on it, and declared irrelevance. A name also changed if anything it rests on
   changed, transitively through statements, definition bodies and rule right-hand sides. A
   theorem's proof is opaque to its users: editing a proof without changing its statement does not
   change the theorem. Also counted as changed:
   - names an edited or failing unit no longer declares;
   - the heads of rules added, removed or edited.
5. **Names resolve as before.** No identifier it is written with matches a declaration that appeared
   or disappeared before it.
6. **It is not always checked.** Room headers, rules, irrelevance declarations, views, compositions,
   translations and directives are always checked. They are cheap, or they depend on the whole
   environment.

Everything else is checked by the ordinary checker, in order, into a new environment. The previous
environment is replaced only when the step is done. So a failing or interrupted edit never leaves a
partly updated accepted state, and reverting an edit restores the earlier result: the test checks
that the digest is identical. Reused entries come only from successful checks earlier in the same
session. Nothing is loaded from disk except sources, so no cached "passed" flag, hash or serialized
environment can stand in for a check. `arlk replay` is unchanged and always checks from scratch.
The kernel and checker semantics are fixed for a process (`arlk-kernel-1`). There are no checking
options that change what is accepted, so a semantics change means a new process and a full check.

## Checked against a fresh process

[tools/session_check.py](../tools/session_check.py), run by CI, runs a deterministic sequence of 29
edits through one session. The program is the native library, the reverse client, a room with
symbols, rules and a record type, and the views example. After every edit it compares the
session's digest with a fresh `arlk check --digest` of the same files. The digest covers:

- each unit's outcome and printed lines;
- every declared name's statement;
- a hash of every proof or body;
- a hash of every assumption inventory;
- every diagnostic.

The edits cover:

- a proof edit, which reuses its users;
- a false statement, with its users checked again and rejected, then reverted;
- a definition body;
- a type's constructors;
- a positivity violation;
- universe parameters;
- a rewrite rule added, then removed;
- irrelevance declared;
- a room header seeing less;
- a view image changed to an equal term, and to a wrong one;
- a declaration added that later identifiers may resolve to;
- files reordered;
- a declaration renamed away.

Every step is also compared with its expected reasons, failures and reuse.

## Measured

A chain of N theorems, each using the previous one and computing with `add`. Times are in ms, one
session process per size, Apple M4 Pro, advisory. "Checked" counts units checked again: room
headers are always checked, plus whatever the edit affected.

| N | fresh check | no-op | (checked) | proof edit | (checked) | `add` edited | (checked) |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 100 | 27 | 4 | 1 | 4 | 2 | 26 | 102 |
| 200 | 49 | 8 | 1 | 8 | 2 | 51 | 202 |
| 400 | 97 | 18 | 1 | 18 | 2 | 104 | 402 |
| 800 | 183 | 41 | 1 | 43 | 2 | 213 | 802 |

What remains of a no-op is mostly reading and parsing the sources. An edit to a shared definition
checks everything that rests on it again, at about the cost of a fresh check. While building this,
the measurements found three quadratic costs in the session itself: copying the previous step in a
comparison, walking the record list for every unit, and copying lists to take their tails. All
three are fixed.
