$( This is the Metamath database set.mm. $)

$( Metamath is a formal language and associated computer program for
   archiving, verifying, and studying mathematical proofs, created by Norman
   Dwight Megill (1950--2021).  For more information, visit
   https://us.metamath.org and
   https://github.com/metamath/set.mm, and feel free to ask questions at
   https://groups.google.com/g/metamath. $)

$( New users may want to read https://us.metamath.org/mpeuni/conventions.html
   to understand the label naming conventions used in set.mm.  See also the
   Metamath program command "MM> HELP VERIFY MARKUP" for markup conventions. $)

$( To break this file into smaller modules, in the Metamath program type
   "MM> READ set.mm" followed by "MM> WRITE SOURCE set.mm / SPLIT".  To
   recombine, omit "/ SPLIT". $)

$( The database set.mm was created by Norman Megill on 30-Sep-1992 and has
   been continuously enriched since then (list of contributors below). $)


$( !
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
  Metamath source file for logic and set theory
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#

                           ~~ PUBLIC DOMAIN ~~
This work is waived of all rights, including copyright, according to the CC0
Public Domain Dedication.  https://creativecommons.org/publicdomain/zero/1.0/

Currently active maintainers: See the list in the CONTRIBUTING.md file of
https://github.com/metamath/set.mm.

Contributor list:

DA  David Abernethy
SA  Stefan Allan
TA  Thierry Arnoux
JA  Juha Arpiainen
JB  Jonathan Ben-Naim
GB  Gregory Bush
MC  Mario Carneiro
FC  Filip Cernatescu
PC  Paul Chapman
DF  Drahflow
AD  Adrian Ducourtial
GD  Georgy Dunaev
SF  Scott Fenton
GG  Gino Giotto
JGH Jeff Hankins
AH  Anthony Hart
DH  David Harvey
CH  Chen-Pang He
JH  Jeff Hoffman
II  Igor Ieskov
AI  Asger C. Ipsen
JJ  Jerry James
SJ  Szymon Jaroszewicz
BJ  Benoit Jubin
JK  Jim Kingdon
ML  M L
WL  Wolf Lammen
GL  Gerard Lang
BL  Brendan Leahy
LL  Larry Lesyna
RL  Raph Levien
FL  Frederic Line
RFL Roy F. Longton
TM  T M
TVM Thomas van Maaren
JPM Jeffrey P. Machado
JM  Jeff Madsen
GM  Giovanni Mascellani
PM  Peter Mazsa
RM  Rodolfo Medina
NM  Norman Megill
MKU metakunt
DM  David Moews
MM  Mykola Mostovenko
LM  Luke Murphy
SN  Steven Nguyen
MO  Mel L. O'Cat
OAI OpenAI
SO  Stefan O'Rear
JO  Jason Orendorff
KP  K P
NP  Noam Pasman
JPP Jon Pennant
RP  Richard Penner
SP  Stanislas Polu
JP  Josh Purinton
RMI Remi
RR  Rohan Ridenour
SR  Steve Rodriguez
ATS Andrew Salmon
AS  Alan Sare
ES  Eric Schmidt
GS  Glauco Siliprandi
SS  Saveliy Skresanov
BTT BTernaryTau
ET  Ender Ting
JU  Jarvin Udandy
ADH Stijn "Adhemar" Vandamme
AV  Alexander van der Vekens
JV  Jannik Vierling
ZW  Zhi Wang
EW  Emmett Weisz
DAW David A. Wheeler
RW  Roger Witte
KW  Kyle Wyonch
JY  Jonathan Yan
MY  Mingli Yuan
FZ  Fan Zheng
KZ  Kunhao Zheng

HTML code for accented names:
  BJ Beno&icirc;t Jubin
  GL G&eacute;rard Lang
  FL Fr&eacute;d&eacute;ric Lin&eacute;

$)


$( See "MM> HELP VERIFY MARKUP" for help with modularization tags. $)
$( Begin $[ set-header.mm $] $)
$( !
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Contents of this header
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

* Quick "How To"
* Bibliography
* Metamath syntax summary
* Other notes


=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Quick "How To"
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

How to use this file under Windows 95/98/NT/2K/XP/Vista/7/10:

1. Download the Metamath program metamath.exe following the instructions on the
   Metamath home page (https://us.metamath.org) and put it in the same
   directory as this file.
2. In Windows Explorer, double-click on metamath.exe.
3. Type "read set.mm" and press Enter.
4. Type "help" for a list of help topics, and "help demo" for some
   command examples.


=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Bibliography
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Bibliographical references are made by bracketing an identifier in a theorem's
comment, such as [RussellWhitehead].  These refer to HTML tags on the following
web pages:

  Logic and set theory - see https://us.metamath.org/mpeuni/mmset.html#bib
  Hilbert space - see https://us.metamath.org/mpeuni/mmhil.html#ref

A bracketed reference must be preceded by a theorem number, etc. and followed
by a page number.  See "MM> HELP WRITE BIBLIOGRAPHY" for details.


=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Metamath syntax summary
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

The HELP LANGUAGE command in the Metamath program will give you a quick
overview of Metamath.  The specification is found on pp. 111--114 of the
Metamath book.  The following syntax summary is provided for convenience
but may omit some details.

A Metamath database (set of one or more ASCII source files) is a sequence of
_tokens_, which are normally separated by spaces or line breaks.  The only
tokens that are built into the Metamath language are those (two-character
sequences) beginning with $, shown in the following. These tokens are called
_keywords_:

          $c ... $. - Constant declaration
          $v ... $. - Variable declaration
          $d ... $. - Disjoint (distinct) variable restriction
  <label> $f ... $. - "Floating" hypothesis (i.e. variable type declaration)
  <label> $e ... $. - "Essential" hypothesis (i.e. a logical assumption for a
                      theorem or axiom)
  <label> $a ... $. - Axiom or definition or syntax construction
  <label> $p ... $= ... $. - Theorem and its proof
          ${ ... $} - Block for defining the scope of the above statements
                      (except $a, $p which are forever active)
$)        $( ... $)
$(                  - Comments (may not be nested); see HELP LANGUAGE
                      for markup features.
          $[ ... $] - Include a file

The above two-character sequences beginning with "$" are the only primitives
built into the Metamath language.  The only "logic" Metamath uses in its proof
verification algorithm is the substitution of expressions for variables while
checking for distinct variable violations.  Everything else, including the
axioms for logic, is defined in this database file.

All other tokens are user-defined, and their names are arbitrary.  There are
two kinds of user-defined tokens, called math symbols (or just symbols) and
labels.  A _symbol_ may contain any non-whitespace printable character except
"$".  A _label_ may contain only alphanumeric characters and the characters "."
(period), "-" (hyphen), and "_" (underscore).  Symbols and labels are
case-sensitive.  All labels (except in proofs) must be distinct.  A label may
not have the same name as a symbol (to simplify the coding of certain parsers
and translators).

Here is some more detail about the syntax:

  $c <symbollist> $.
      <symbollist> is a (whitespace-separated) list of distinct symbols that
      haven't been used before.
  $v <symbollist> $.
      <symbollist> is a list of distinct symbols that haven't been used yet
      in the current scope (see ${ ... $} below).
  $d <symbollist> $.
      <symbollist> is a (whitespace-separated) list of distinct symbols
      previously declared with $v in current scope.  It means that
      substitutions into these symbols may not have variables in common.
  <label> $f <symbollist> $.
      <symbollist> is a list of 2 symbols, the first of which must be
      previously declared with $c in the current scope.
  <label> $e <symbollist> $.
      <symbollist> is a list of 2 or more symbols, the first of which must be
      previously declared with $c in the current scope.
  <label> $a <symbollist> $.
      <symbollist> is a list of 2 or more symbols, the first of which must be
      previously declared with $c in the current scope.
  <label> $p <symbollist> $= <proof> $.
      <symbollist> is a list of 2 or more symbols, the first of which must be
      previously declared with $c in the current scope.  <proof> is either a
      whitespace-delimited sequence of previous labels (created by
      SAVE PROOF <label> /NORMAL) or a compressed proof (created by
      SAVE PROOF <label> /COMPRESSED).  After using SAVE PROOF, use
      WRITE SOURCE to save the database file to disk.
  ${ ... $}
      Block for scoping the above statements (except $a, $p which are forever
      active).  Currently, $c may not occur inside of a block.
$)
  $( <any text> $)
$(    Comment.  Note: <any text> may not contain adjacent "$" and ")"
      characters.  The comment opening and closing delimiters must be
      surrounded by whitespace (space, tab, CR, LF, or FF).
  $[ <filename> $]
      Insert contents of <filename> at this point.  If <filename> is current
      file or has been already been inserted, it will not be inserted again.

Inside of comments, it is recommended that labels be preceded with a tilde (~)
and math symbol tokens be enclosed in grave accents, also known as backticks
(` `). These tildes, tokens, math symbols and backticks should be surrounded by
spaces.  This way the LaTeX and HTML rendition of comments will be accurate,
and tools to globally change labels and math symbols will also change them in
comments.  Note that inside of backticks a pair of backticks is interpreted as
a single backtick.  A special comment containing $ t (with no space after the
dollar sign) defines LaTeX and HTML symbols.  See HELP LANGUAGE and HELP HTML
for other markup features in comments.

The proofs in this file are in "compressed" format for storage efficiency.  The
Metamath program reads the compressed format directly.  This format is
described in Appendix B of the Metamath book.  It is not intended to be read by
humans.  For viewing proofs you should use the various SHOW PROOF commands
described in the Metamath book (or the online HELP).

The Metamath program does not normally affect any content of this file other
than proofs, i.e., the text between "$=" and "$." (and some rewrapping).  All
other content is user-created.  Proofs are created or modified with the PROVE
command.


=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Other notes
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

1.  It is recommended that you be familiar with Chapters 2 and 4 of the
Metamath book to understand the Metamath language.  Chapters 2, 3 and 5 explain
how to use the Metamath program.  Chapter 3 gives an informal overview of what
this source file is all about.  Appendix A gives the standard mathematical
symbols corresponding to some of the ASCII tokens used in this file.

The ASCII tokens may seem cryptic at first, even if you are familiar with set
theory, but a review of the definition summary in Chapter 3 should quickly
enable you to see the correspondence to standard mathematical notation.  To
easily find the definition of a token, search for the first occurrences of the
token surrounded by spaces.  Some odd-looking ones include "-." for "not", and
"C_" for "is a subset of".  The Metamath program "MM> HELP TEX" command
explains how to obtain a LaTeX output to see the real mathematical symbols.
Let us know if you have better suggestions for naming ASCII tokens.

2.  Theorems can be written in different forms, including "closed form",
"deduction form", and "inference form" (for details, see ~ conventions ).  For
basic theorems, all three forms are generally given, but for more advanced
theorems, we prefer to use the deduction form, since it permits to write proofs
in the "deduction style", and we do not add theorems in inference form unless
there are reasonable grounds for it (for instance, shortening sufficiently many
proofs to counterbalance their addition).

3.  On providing new definitions and theorems, the conventions provided in the
comment of ~ conventions should be obeyed.

4.  For a chronological list of changes to label names and label deletions, see
the changes-set.txt file.  This should help if you have a proof not checked
into the main repository and want to update it for recent changes.

$)

$( End $[ set-header.mm $] $)


$( Begin $[ set-main.mm $] $)
$( Begin $[ set-pred.mm $] $)

$( The following header is the first to appear in the Theorem List contents,
   because higher-level headers suppress all previous same-level or
   lower-level headers in the same comment area between $a and $p statements.
   See "MM> HELP WRITE THEOREM_LIST" for information about headers. $)


$(
###############################################################################
  CLASSICAL FIRST-ORDER LOGIC WITH EQUALITY
###############################################################################

  Logic can be defined as the "study of the principles of correct reasoning"
  (Merrilee H. Salmon's 1991 "Informal Reasoning and Informal Logic" in
  _Informal Reasoning and Education_) or as "a formal system using symbolic
  techniques and mathematical methods to establish truth-values" (the Oxford
  English Dictionary).

  This section formally defines the logic system we will use.  In particular,
  it defines symbols for declaring truthful statements, along with rules for
  deriving truthful statements from other truthful statements.  The system
  defined here is classical first-order logic (often abbreviated as FOL) with
  equality and no terms (the most common logic system used by mathematicians).

  We begin with a few housekeeping items in pre-logic, and then introduce
  propositional calculus (both its axioms and important theorems that can be
  derived from them).  Propositional calculus deals with general truths about
  well-formed formulas (wffs) regardless of how they are constructed.  This is
  followed by proofs that other axiomatizations of classical propositional
  calculus can be derived from the axioms we have chosen to use.

  We then define predicate calculus, which adds additional symbols and rules
  useful for discussing objects (beyond simply true or false).  In particular,
  it introduces the symbols ` = ` ("equals"), ` e. ` ("is a member of"), and
  ` A. ` ("for all").  The first two are called "predicates".  A predicate
  specifies a true or false relationship between its two arguments.

$)


$(
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
  Pre-logic
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#

  This section includes a few "housekeeping" mechanisms before we begin
  defining the basics of logic.

$)

  $( Declare the primitive constant symbols for propositional calculus. $)
  $c ( $.  $( Left parenthesis $)
  $c ) $.  $( Right parenthesis $)
  $c -> $.  $( Right arrow (read:  "implies") $)
  $c -. $.  $( Right handle (read:  "not") $)
  $c wff $.  $( Well-formed formula symbol (read:  "the following symbol
                sequence is a wff") $)
  $c |- $.  $( Turnstile (read:  "the following symbol sequence is provable" or
               "a proof exists for") $)

  $( Define the syntax and logical typecodes, and declare that our grammar is
     unambiguous (verifiable using the KLR parser, with compositing depth 5).
     (This $ j comment need not be read by verifiers, but is useful for parsers
     like mmj2.) $)
  $( $j
    syntax 'wff';
    syntax '|-' as 'wff';
    unambiguous 'klr 5';
  $)

  $( Declare the color of wff variables. $)
  $( $j
    varcolorcode "wff" as "0000FF";
    altvarcolorcode "wff" as "337DFF";
  $)

  $( Declare typographical constant symbols that are not directly used in the
     formalism but are useful to explain it in comments. $)

  $c & $.  $( Ampersand (read: "and"). $)
  $c => $.  $( Double right arrow (read: "implies"). $)

  $( wff variable sequence:  ph ps ch th ta et ze si rh mu la ka $)
  $( Introduce some variable names we will use to represent well-formed
     formulas (wff's). $)
  $v ph $.  $( Greek phi $)
  $v ps $.  $( Greek psi $)
  $v ch $.  $( Greek chi $)
  $v th $.  $( Greek theta $)
  $v ta $.  $( Greek tau $)
  $v et $.  $( Greek eta $)
  $v ze $.  $( Greek zeta $)
  $v si $.  $( Greek sigma $)
  $v rh $.  $( Greek rho $)
  $v mu $.  $( Greek mu $)
  $v la $.  $( Greek lambda $)
  $v ka $.  $( Greek kappa $)

  $( Specify some variables that we will use to represent wff's.
     The fact that a variable represents a wff is relevant only to a theorem
     referring to that variable, so we may use $f hypotheses.  The symbol
     ` wff ` specifies that the variable that follows it represents a wff. $)
  $( Let variable ` ph ` be a wff. $)
  wph $f wff ph $.
  $( Let variable ` ps ` be a wff. $)
  wps $f wff ps $.
  $( Let variable ` ch ` be a wff. $)
  wch $f wff ch $.
  $( Let variable ` th ` be a wff. $)
  wth $f wff th $.
  $( Let variable ` ta ` be a wff. $)
  wta $f wff ta $.
  $( Let variable ` et ` be a wff. $)
  wet $f wff et $.
  $( Let variable ` ze ` be a wff. $)
  wze $f wff ze $.
  $( Let variable ` si ` be a wff. $)
  wsi $f wff si $.
  $( Let variable ` rh ` be a wff. $)
  wrh $f wff rh $.
  $( Let variable ` mu ` be a wff. $)
  wmu $f wff mu $.
  $( Let variable ` la ` be a wff. $)
  wla $f wff la $.
  $( Let variable ` ka ` be a wff. $)
  wka $f wff ka $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Inferences for assisting proof development
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  The inference rules in this section will normally never appear in a completed
  proof.  They can be ignored if you are using this database to assist learning
  logic - please start with the statement ~ wn instead.

$)

  ${
    idi.1 $e |- ph $.
    $( (_Note_:  This inference rule and the next one, ~ a1ii , will normally
       never appear in a completed proof.  They can be ignored if you are using
       this database to assist learning logic; please start with the statement
       ~ wn instead.)

       This inference says "if ` ph ` is true then ` ph ` is true".  This
       inference requires no axioms for its proof, and is useful as a
       copy-paste mechanism during proof development in mmj2.  It is normally
       not referenced in the final version of a proof, since it is always
       redundant.  You can remove this using the metamath-exe (Metamath
       program) Proof Assistant using the "MM-PA> MINIMIZE__WITH *" command.
       This is the inference associated with ~ id , hence its name.
       (Contributed by Alan Sare, 31-Dec-2011.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    idi $p |- ph $=
      (  ) B $.
  $}

  ${
    a1ii.1 $e |- ph $.
    a1ii.2 $e |- ps $.
    $( (_Note_:  This inference rule and the previous one, ~ idi , will
       normally never appear in a completed proof.)

       This is a technical inference to assist proof development.  It provides
       a temporary way to add an independent subproof to a proof under
       development, for later assignment to a normal proof step.

       The Metamath (Metamath-exe) program Proof Assistant requires proofs to
       be developed backwards from the conclusion with no gaps, and it has no
       mechanism that lets the user work on isolated subproofs.  This inference
       provides a workaround for this limitation.  It can be inserted at any
       point in a proof to allow an independent subproof to be developed on the
       side, for later use as part of the final proof.

       _Instructions_:
       <HTML><ol><li>Assign this inference to any unknown step in the proof.
       Typically, the last unknown step is the most convenient, since
       <code>MM-PA&gt; ASSIGN LAST</code> can be used.  This step will be
       replicated in hypothesis a1ii.1, from where the development of the main
       proof can continue.</li><li>Develop the independent subproof backwards
       from hypothesis a1ii.2.  If desired, use a
       <code>MM-PA&gt; LET STEP</code>
       command to pre-assign the conclusion of the independent subproof to
       a1ii.2.</li><li>After the independent subproof is complete, use
       <code>MM-PA&gt; IMPROVE ALL</code>
       to assign it automatically to an unknown
       step in the main proof that matches it.</li><li>After the entire proof
       is complete, use <code>MM-PA> MINIMIZE_WITH *</code> to clean up
       (discard) all ~ a1ii references automatically.</ol></HTML>

       This can also be used to apply subproofs from other theorems.  In step
       2, simply assign the theorem to a1ii.2, and run
       <HTML><code>MM-PA&gt; EXPAND &lt;theorem&gt;</code></HTML>
       to "import" a subproof
       from another theorem.

       This inference was originally designed to assist importing partially
       completed Proof Worksheets from the mmj2 Proof Assistant GUI, but it can
       also be useful on its own.  Interestingly, no axioms are required for
       its proof.  It is the inference associated with ~ a1i .  (Contributed by
       NM, 7-Feb-2006.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    a1ii $p |- ph $=
      (  ) C $.
  $}


$(
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
  Propositional calculus
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#

  Propositional calculus deals with general truths about well-formed formulas
  (wffs) regardless of how they are constructed.  The simplest propositional
  truth is ` ( ph -> ph ) ` , which can be read "if something is true, then it
  is true" - rather trivial and obvious, but nonetheless it must be proved from
  the axioms (see Theorem ~ id ).

  Our system of propositional calculus consists of three basic axioms and
  another axiom that defines the modus-ponens inference rule.  It is attributed
  to Jan Lukasiewicz (pronounced woo-kah-SHAY-vitch) and was popularized by
  Alonzo Church, who called it system P2.  (Thanks to Ted Ulrich for this
  information.)  These axioms are ~ ax-1 , ~ ax-2 , ~ ax-3 , and (for modus
  ponens) ~ ax-mp . Some closely followed texts include [Margaris] for the
  axioms and [WhiteheadRussell] for the theorems.

  The propositional calculus used here is the classical system widely used by
  mathematicians.  In particular, this logic system accepts the "law of the
  excluded middle" as proven in ~ exmid , which says that a logical statement
  is either true or not true.  This is an essential distinction of classical
  logic and is not a theorem of intuitionistic logic.

  All 194 axioms, definitions, and theorems for propositional calculus in
  _Principia Mathematica_ (specifically *1.2 through *5.75) are axioms or
  formally proven.  See the Bibliographic Cross-References at ~ mmbiblio.html
  for a complete cross-reference from sources used to its formalization in the
  Metamath Proof Explorer.

$)


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Recursively define primitive wffs for propositional calculus
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( If ` ph ` is a wff, so is ` -. ph ` or "not ` ph ` ".  Part of the
     recursive definition of a wff (well-formed formula).  In classical logic
     (which is our logic), a wff is interpreted as either true or false.  So if
     ` ph ` is true, then ` -. ph ` is false; if ` ph ` is false, then
     ` -. ph ` is true.  Traditionally, Greek letters are used to represent
     wffs, and we follow this convention.  In propositional calculus, we define
     only wffs built up from other wffs, i.e. there is no starting or "atomic"
     wff.  Later, in predicate calculus, we will extend the basic wff
     definition by including atomic wffs ( ~ weq and ~ wel ). $)
  wn $a wff -. ph $.

  $( Register negation '-.' as a primitive expression (lacking a
     definition). $)
  $( $j primitive 'wn'; $)

  $( If ` ph ` and ` ps ` are wff's, so is ` ( ph -> ps ) ` or " ` ph ` implies
     ` ps ` ".  Part of the recursive definition of a wff.  The resulting wff
     is (interpreted as) false when ` ph ` is true and ` ps ` is false; it is
     true otherwise.  Think of the truth table for an OR gate with input ` ph `
     connected through an inverter.  After we state the axioms of propositional
     calculus ( ~ ax-1 , ~ ax-2 , ~ ax-3 , and ~ ax-mp ) and define the
     biconditional ( ~ df-bi ), the constant true ` T. ` ( ~ df-tru ), and the
     constant false ` F. ` ( ~ df-fal ), we will be able to prove these truth
     table values: ` ( ( T. -> T. ) <-> T. ) ` ( ~ truimtru ),
     ` ( ( T. -> F. ) <-> F. ) ` ( ~ truimfal ), ` ( ( F. -> T. ) <-> T. ) `
     ( ~ falimtru ), and ` ( ( F. -> F. ) <-> T. ) ` ( ~ falimfal ).  These
     have straightforward meanings, for example, ` ( ( T. -> T. ) <-> T. ) `
     just means "the value of ` ( T. -> T. ) ` is ` T. ` ".

     The left-hand wff is called the antecedent, and the right-hand wff is
     called the consequent.  In the case of ` ( ph -> ( ps -> ch ) ) ` , the
     middle ` ps ` may be informally called either an antecedent or part of the
     consequent depending on context.  Contrast with ` <-> ` ( ~ df-bi ),
     ` /\ ` ( ~ df-an ), and ` \/ ` ( ~ df-or ).

     This is called "material implication" and the arrow is usually read as
     "implies".  However, material implication is not identical to the meaning
     of "implies" in natural language.  For example, the word "implies" may
     suggest a causal relationship in natural language.  Material implication
     does not require any causal relationship.  Also, note that in material
     implication, if the consequent is true then the wff is always true (even
     if the antecedent is false).  Thus, if "implies" means material
     implication, it is true that "if the moon is made of green cheese that
     implies that 5=5" (because 5=5).  Similarly, if the antecedent is false,
     the wff is always true.  Thus, it is true that, "if the moon is made of
     green cheese that implies that 5=7" (because the moon is not actually made
     of green cheese).  A contradiction implies anything ( ~ pm2.21i ).  In
     short, material implication has a very specific technical definition, and
     misunderstandings of it are sometimes called "paradoxes of logical
     implication". $)
  wi $a wff ( ph -> ps ) $.

  $( Register implication '->' as a primitive expression (lacking a
     definition). $)
  $( $j primitive 'wi'; $)


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  The axioms of propositional calculus
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  Propositional calculus (Axioms ~ ax-1 through ~ ax-3 and rule ~ ax-mp ) can
  be thought of as asserting formulas that are universally "true" when their
  variables are replaced by any combination of "true" and "false".
  Propositional calculus was first formalized by Frege in 1879, using as his
  axioms (in addition to rule ~ ax-mp ) the wffs ~ ax-1 , ~ ax-2 , ~ pm2.04 ,
  ~ con3 , ~ notnot , and ~ notnotr .  Around 1930, Lukasiewicz simplified the
  system by eliminating the third (which follows from the first two, as you can
  see by looking at the proof of ~ pm2.04 ) and replacing the last three with
  our ~ ax-3 .  (Thanks to Ted Ulrich for this information.)

  The theorems of propositional calculus are also called _tautologies_.
  Tautologies can be proved very simply using truth tables, based on the
  true/false interpretation of propositional calculus.  To do this, we assign
  all possible combinations of true and false to the wff variables and verify
  that the result (using the rules described in ~ wi and ~ wn ) always
  evaluates to true.  This is called the _semantic_ approach.  Our approach is
  called the _syntactic_ approach, in which everything is derived from axioms.
  A metatheorem called the Completeness Theorem for Propositional Calculus
  shows that the two approaches are equivalent and even provides an algorithm
  for automatically generating syntactic proofs from a truth table.  Those
  proofs, however, tend to be long, since truth tables grow exponentially with
  the number of variables, and the much shorter proofs that we show here were
  found manually.

$)

  ${
    $( Minor premise for modus ponens. $)
    min $e |- ph $.
    $( Major premise for modus ponens. $)
    maj $e |- ( ph -> ps ) $.
    $( Rule of Modus Ponens.  The postulated inference rule of propositional
       calculus.  See, e.g., Rule 1 of [Hamilton] p. 73.  The rule says, "if
       ` ph ` is true, and ` ph ` implies ` ps ` , then ` ps ` must also be
       true".  This rule is sometimes called "detachment", since it detaches
       the minor premise from the major premise.  "Modus ponens" is short for
       "modus ponendo ponens", a Latin phrase that means "the mode that by
       affirming affirms" - remark in [Sanford] p. 39.  This rule is similar to
       the rule of modus tollens ~ mto .

       Note:  In some web page displays such as the Statement List, the
       symbols " ` & ` " and " ` => ` " informally indicate the relationship
       between the hypotheses and the assertion (conclusion), abbreviating the
       English words "and" and "implies".  They are not part of the formal
       language.  (Contributed by NM, 30-Sep-1992.) $)
    ax-mp $a |- ps $.
  $}

  $( Axiom _Simp_.  Axiom A1 of [Margaris] p. 49.  One of the 3 axioms of
     propositional calculus.  The 3 axioms are also given as Definition 2.1 of
     [Hamilton] p. 28.  This axiom is called _Simp_ or "the principle of
     simplification" in _Principia Mathematica_ (Theorem *2.02 of
     [WhiteheadRussell] p. 100) because "it enables us to pass from the joint
     assertion of ` ph ` and ` ps ` to the assertion of ` ph ` simply".  It is
     Proposition 1 of [Frege1879] p. 26, its first axiom.  (Contributed by NM,
     30-Sep-1992.) $)
  ax-1 $a |- ( ph -> ( ps -> ph ) ) $.

  $( Axiom _Frege_.  Axiom A2 of [Margaris] p. 49.  One of the 3 axioms of
     propositional calculus.  It "distributes" an antecedent over two
     consequents.  This axiom was part of Frege's original system and is known
     as _Frege_ in the literature; see Proposition 2 of [Frege1879] p. 26.  It
     is also proved as Theorem *2.77 of [WhiteheadRussell] p. 108.  The other
     direction of this axiom also turns out to be true, as demonstrated by
     ~ pm5.41 .  (Contributed by NM, 30-Sep-1992.) $)
  ax-2 $a |- ( ( ph -> ( ps -> ch ) ) -> ( ( ph -> ps ) -> ( ph -> ch ) ) ) $.

  $( Axiom _Transp_.  Axiom A3 of [Margaris] p. 49.  One of the 3 axioms of
     propositional calculus.  It swaps or "transposes" the order of the
     consequents when negation is removed.  An informal example is that the
     statement "if there are no clouds in the sky, it is not raining" implies
     the statement "if it is raining, there are clouds in the sky".  This axiom
     is called _Transp_ or "the principle of transposition" in _Principia
     Mathematica_ (Theorem *2.17 of [WhiteheadRussell] p. 103).  We will also
     use the term "contraposition" for this principle, although the reader is
     advised that in the field of philosophical logic, "contraposition" has a
     different technical meaning.  (Contributed by NM, 30-Sep-1992.)  Use its
     alias ~ con4 instead.  (New usage is discouraged.) $)
  ax-3 $a |- ( ( -. ph -> -. ps ) -> ( ps -> ph ) ) $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical implication
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  The results in this section are based on implication only, and avoid ~ ax-3 ,
  so are intuitionistic.  The system { ~ ax-mp , ~ ax-1 , ~ ax-2 } axiomatizes
  what is sometimes called "intuitionistic implicational calculus" or "minimal
  implicational calculus".

  In an implication, the wff before the arrow is called the "antecedent" and
  the wff after the arrow is called the "consequent".

$)

  ${
    mp2.1 $e |- ph $.
    mp2.2 $e |- ps $.
    mp2.3 $e |- ( ph -> ( ps -> ch ) ) $.
    $( A double modus ponens inference.  (Contributed by NM, 5-Apr-1994.) $)
    mp2 $p |- ch $=
      ( wi ax-mp ) BCEABCGDFHH $.
  $}

  ${
    mp2b.1 $e |- ph $.
    mp2b.2 $e |- ( ph -> ps ) $.
    mp2b.3 $e |- ( ps -> ch ) $.
    $( A double modus ponens inference.  (Contributed by Mario Carneiro,
       24-Jan-2013.) $)
    mp2b $p |- ch $=
      ( ax-mp ) BCABDEGFG $.
  $}

  ${
    a1i.1 $e |- ph $.
    $( Inference introducing an antecedent.  Inference associated with ~ ax-1 .
       Its associated inference is ~ a1ii .  See ~ conventions for a definition
       of "associated inference".  (Contributed by NM, 29-Dec-1992.) $)
    a1i $p |- ( ps -> ph ) $=
      ( wi ax-1 ax-mp ) ABADCABEF $.
  $}

  ${
    2a1i.1 $e |- ph $.
    $( Inference introducing two antecedents.  Two applications of ~ a1i .
       Inference associated with ~ 2a1 .  (Contributed by Jeff Hankins,
       4-Aug-2009.) $)
    2a1i $p |- ( ps -> ( ch -> ph ) ) $=
      ( wi a1i ) CAEBACDFF $.
  $}

  $( Weakening of ~ ax-1 .  As a consequence, its associated inference is an
     instance (where we allow extra hypotheses) of ~ ax-1 .  Its commuted form
     is ~ 2a1 (but ~ ax1w does not require ~ ax-2 ).  (Contributed by BJ,
     11-Aug-2020.) $)
  ax1w $p |- ( ph -> ( ps -> ( ch -> ps ) ) ) $=
    ( wi ax-1 a1i ) BCBDDABCEF $.
    $( $j usage 'ax1w' avoids 'ax-2' 'ax-3'; $)

  ${
    mp1i.1 $e |- ph $.
    mp1i.2 $e |- ( ph -> ps ) $.
    $( Inference detaching an antecedent and introducing a new one.
       (Contributed by Stefan O'Rear, 29-Jan-2015.) $)
    mp1i $p |- ( ch -> ps ) $=
      ( ax-mp a1i ) BCABDEFG $.
  $}

  ${
    a2i.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Inference distributing an antecedent.  Inference associated with
       ~ ax-2 .  Its associated inference is ~ mpd .  (Contributed by NM,
       29-Dec-1992.) $)
    a2i $p |- ( ( ph -> ps ) -> ( ph -> ch ) ) $=
      ( wi ax-2 ax-mp ) ABCEEABEACEEDABCFG $.
  $}

  ${
    mpd.1 $e |- ( ph -> ps ) $.
    mpd.2 $e |- ( ph -> ( ps -> ch ) ) $.
    $( A modus ponens deduction.  A translation of natural deduction rule
       ` -> ` E ( ` -> ` elimination), see ~ natded .  Deduction form of
       ~ ax-mp .  Inference associated with ~ a2i .  Commuted form of ~ mpcom .
       (Contributed by NM, 29-Dec-1992.) $)
    mpd $p |- ( ph -> ch ) $=
      ( wi a2i ax-mp ) ABFACFDABCEGH $.
  $}

  ${
    imim2i.1 $e |- ( ph -> ps ) $.
    $( Inference adding common antecedents in an implication.  Inference
       associated with ~ imim2 .  Its associated inference is ~ syl .
       (Contributed by NM, 28-Dec-1992.) $)
    imim2i $p |- ( ( ch -> ph ) -> ( ch -> ps ) ) $=
      ( wi a1i a2i ) CABABECDFG $.
  $}

  ${
    $( First of 2 premises for ~ syl . $)
    syl.1 $e |- ( ph -> ps ) $.
    $( Second of 2 premises for ~ syl . $)
    syl.2 $e |- ( ps -> ch ) $.
    $( An inference version of the transitive laws for implication ~ imim2 and
       ~ imim1 (and ~ imim1i and ~ imim2i ), which Russell and Whitehead call
       "the principle of the syllogism ... because ... the syllogism in Barbara
       [[ ~ barbara ] is derived from [[ ~ syl ]" (quote after Theorem *2.06 of
       [WhiteheadRussell] p. 101).  Some authors call this law a "hypothetical
       syllogism".  Its associated inference is ~ mp2b .

       (A bit of trivia: this is the most commonly referenced assertion in our
       database (13449 times as of 22-Jul-2021).  In second place is ~ eqid
       (9597 times), followed by ~ adantr (8861 times), ~ syl2anc (7421 times),
       ~ adantl (6403 times), and ~ simpr (5829 times).  The Metamath program
       command 'show usage' shows the number of references.)

       (Contributed by NM, 30-Sep-1992.)  (Proof shortened by Mel L. O'Cat,
       20-Oct-2011.)  (Proof shortened by Wolf Lammen, 26-Jul-2012.) $)
    syl $p |- ( ph -> ch ) $=
      ( wi a1i mpd ) ABCDBCFAEGH $.
  $}

  ${
    3syl.1 $e |- ( ph -> ps ) $.
    3syl.2 $e |- ( ps -> ch ) $.
    3syl.3 $e |- ( ch -> th ) $.
    $( Inference chaining two syllogisms ~ syl .  Inference associated with
       ~ imim12i .  (Contributed by NM, 28-Dec-1992.) $)
    3syl $p |- ( ph -> th ) $=
      ( syl ) ACDABCEFHGH $.
  $}

  ${
    4syl.1 $e |- ( ph -> ps ) $.
    4syl.2 $e |- ( ps -> ch ) $.
    4syl.3 $e |- ( ch -> th ) $.
    4syl.4 $e |- ( th -> ta ) $.
    $( Inference chaining three syllogisms ~ syl .  (Contributed by BJ,
       14-Jul-2018.)  The use of this theorem is marked "discouraged" because
       it can cause the Metamath program "MM-PA> MINIMIZE__WITH *" command to
       have very long run times.  However, feel free to use "MM-PA>
       MINIMIZE__WITH 4syl / OVERRIDE" if you wish.  Remember to update the
       "discouraged" file if it gets used.  (New usage is discouraged.) $)
    4syl $p |- ( ph -> ta ) $=
      ( 3syl syl ) ADEABCDFGHJIK $.
  $}

  ${
    mpi.1 $e |- ps $.
    mpi.2 $e |- ( ph -> ( ps -> ch ) ) $.
    $( A nested modus ponens inference.  Inference associated with ~ com12 .
       (Contributed by NM, 29-Dec-1992.)  (Proof shortened by Stefan Allan,
       20-Mar-2006.) $)
    mpi $p |- ( ph -> ch ) $=
      ( a1i mpd ) ABCBADFEG $.
  $}

  ${
    mpisyl.1 $e |- ( ph -> ps ) $.
    mpisyl.2 $e |- ch $.
    mpisyl.3 $e |- ( ps -> ( ch -> th ) ) $.
    $( A syllogism combined with a modus ponens inference.  (Contributed by
       Alan Sare, 25-Jul-2011.) $)
    mpisyl $p |- ( ph -> th ) $=
      ( mpi syl ) ABDEBCDFGHI $.
  $}

  $( Principle of identity.  Theorem *2.08 of [WhiteheadRussell] p. 101.  For
     another version of the proof directly from axioms, see ~ idALT .  Its
     associated inference, ~ idi , requires no axioms for its proof, contrary
     to ~ id .  Note that the second occurrences of ` ph ` in Steps 1 and 2 may
     be simultaneously replaced by any wff ` ps ` , which may ease the
     understanding of the proof.  (Contributed by NM, 29-Dec-1992.)  (Proof
     shortened by Stefan Allan, 20-Mar-2006.) $)
  id $p |- ( ph -> ph ) $=
    ( wi ax-1 mpd ) AAABZAAACAECD $.

  $( Alternate proof of ~ id .  This version is proved directly from the axioms
     for demonstration purposes.  This proof is a popular example in the
     literature and is identical, step for step, to the proofs of Theorem 1 of
     [Margaris] p. 51, Example 2.7(a) of [Hamilton] p. 31, Lemma 10.3 of
     [BellMachover] p. 36, and Lemma 1.8 of [Mendelson] p. 36.  It is also "Our
     first proof" in Hirst and Hirst's _A Primer for Logic and Proof_ p. 17
     (PDF p. 23) at ~ http://www.appstate.edu/~~hirstjl/primer/hirst.pdf .
     Note that the second occurrences of ` ph ` in Steps 1 to 4 and the sixth
     in Step 3 may be simultaneously replaced by any wff ` ps ` , which may
     ease the understanding of the proof.  For a shorter version of the proof
     that takes advantage of previously proved theorems, see ~ id .
     (Contributed by NM, 30-Sep-1992.)  (Proof modification is discouraged.)
     Use ~ id instead.  (New usage is discouraged.) $)
  idALT $p |- ( ph -> ph ) $=
    ( wi ax-1 ax-2 ax-mp ) AAABZBZFAACAFABBGFBAFCAFADEE $.

  $( Principle of identity ~ id with antecedent.  (Contributed by NM,
     26-Nov-1995.) $)
  idd $p |- ( ph -> ( ps -> ps ) ) $=
    ( wi id a1i ) BBCABDE $.

  ${
    a1d.1 $e |- ( ph -> ps ) $.
    $( Deduction introducing an embedded antecedent.  Deduction form of ~ ax-1
       and ~ a1i .  (Contributed by NM, 5-Jan-1993.)  (Proof shortened by
       Stefan Allan, 20-Mar-2006.) $)
    a1d $p |- ( ph -> ( ch -> ps ) ) $=
      ( wi ax-1 syl ) ABCBEDBCFG $.
  $}

  ${
    2a1d.1 $e |- ( ph -> ps ) $.
    $( Deduction introducing two antecedents.  Two applications of ~ a1d .
       Deduction associated with ~ 2a1 and ~ 2a1i .  (Contributed by BJ,
       10-Aug-2020.) $)
    2a1d $p |- ( ph -> ( ch -> ( th -> ps ) ) ) $=
      ( wi a1d ) ADBFCABDEGG $.
  $}

  ${
    a1i13.1 $e |- ( ps -> th ) $.
    $( Add two antecedents to a wff.  (Contributed by Jeff Hankins,
       4-Aug-2009.) $)
    a1i13 $p |- ( ph -> ( ps -> ( ch -> th ) ) ) $=
      ( wi a1d a1i ) BCDFFABDCEGH $.
  $}

  $( A double form of ~ ax-1 .  Its associated inference is ~ 2a1i .  Its
     associated deduction is ~ 2a1d .  (Contributed by BJ, 10-Aug-2020.)
     (Proof shortened by Wolf Lammen, 1-Sep-2020.) $)
  2a1 $p |- ( ph -> ( ps -> ( ch -> ph ) ) ) $=
    ( id 2a1d ) AABCADE $.

  ${
    a2d.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( Deduction distributing an embedded antecedent.  Deduction form of
       ~ ax-2 .  (Contributed by NM, 23-Jun-1994.) $)
    a2d $p |- ( ph -> ( ( ps -> ch ) -> ( ps -> th ) ) ) $=
      ( wi ax-2 syl ) ABCDFFBCFBDFFEBCDGH $.
  $}

  ${
    sylcom.1 $e |- ( ph -> ( ps -> ch ) ) $.
    sylcom.2 $e |- ( ps -> ( ch -> th ) ) $.
    $( Syllogism inference with commutation of antecedents.  (Contributed by
       NM, 29-Aug-2004.)  (Proof shortened by Mel L. O'Cat, 2-Feb-2006.)
       (Proof shortened by Stefan Allan, 23-Feb-2006.) $)
    sylcom $p |- ( ph -> ( ps -> th ) ) $=
      ( wi a2i syl ) ABCGBDGEBCDFHI $.
  $}

  ${
    syl5com.1 $e |- ( ph -> ps ) $.
    syl5com.2 $e |- ( ch -> ( ps -> th ) ) $.
    $( Syllogism inference with commuted antecedents.  (Contributed by NM,
       24-May-2005.) $)
    syl5com $p |- ( ph -> ( ch -> th ) ) $=
      ( a1d sylcom ) ACBDABCEGFH $.
  $}

  ${
    com12.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Inference that swaps (commutes) antecedents in an implication.
       Inference associated with ~ pm2.04 .  Its associated inference is
       ~ mpi .  (Contributed by NM, 29-Dec-1992.)  (Proof shortened by Wolf
       Lammen, 4-Aug-2012.) $)
    com12 $p |- ( ps -> ( ph -> ch ) ) $=
      ( id syl5com ) BBACBEDF $.
  $}

  ${
    syl11.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl11.2 $e |- ( th -> ph ) $.
    $( A syllogism inference.  Commuted form of an instance of ~ syl .
       (Contributed by BJ, 25-Oct-2021.) $)
    syl11 $p |- ( ps -> ( th -> ch ) ) $=
      ( wi syl com12 ) DBCDABCGFEHI $.
  $}

  ${
    syl5.1 $e |- ( ph -> ps ) $.
    syl5.2 $e |- ( ch -> ( ps -> th ) ) $.
    $( A syllogism rule of inference.  The first premise is used to replace the
       second antecedent of the second premise.  (Contributed by NM,
       27-Dec-1992.)  (Proof shortened by Wolf Lammen, 25-May-2013.) $)
    syl5 $p |- ( ch -> ( ph -> th ) ) $=
      ( syl5com com12 ) ACDABCDEFGH $.
  $}

  ${
    syl6.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl6.2 $e |- ( ch -> th ) $.
    $( A syllogism rule of inference.  The second premise is used to replace
       the consequent of the first premise.  (Contributed by NM, 5-Jan-1993.)
       (Proof shortened by Wolf Lammen, 30-Jul-2012.) $)
    syl6 $p |- ( ph -> ( ps -> th ) ) $=
      ( wi a1i sylcom ) ABCDECDGBFHI $.
  $}

  ${
    syl56.1 $e |- ( ph -> ps ) $.
    syl56.2 $e |- ( ch -> ( ps -> th ) ) $.
    syl56.3 $e |- ( th -> ta ) $.
    $( Combine ~ syl5 and ~ syl6 .  (Contributed by NM, 14-Nov-2013.) $)
    syl56 $p |- ( ch -> ( ph -> ta ) ) $=
      ( syl6 syl5 ) ABCEFCBDEGHIJ $.
  $}

  ${
    syl6com.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl6com.2 $e |- ( ch -> th ) $.
    $( Syllogism inference with commuted antecedents.  (Contributed by NM,
       25-May-2005.) $)
    syl6com $p |- ( ps -> ( ph -> th ) ) $=
      ( syl6 com12 ) ABDABCDEFGH $.
  $}

  ${
    mpcom.1 $e |- ( ps -> ph ) $.
    mpcom.2 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Modus ponens inference with commutation of antecedents.  Commuted form
       of ~ mpd .  (Contributed by NM, 17-Mar-1996.) $)
    mpcom $p |- ( ps -> ch ) $=
      ( com12 mpd ) BACDABCEFG $.
  $}

  ${
    syli.1 $e |- ( ps -> ( ph -> ch ) ) $.
    syli.2 $e |- ( ch -> ( ph -> th ) ) $.
    $( Syllogism inference with common nested antecedent.  (Contributed by NM,
       4-Nov-2004.) $)
    syli $p |- ( ps -> ( ph -> th ) ) $=
      ( com12 sylcom ) BACDECADFGH $.
  $}

  ${
    syl2im.1 $e |- ( ph -> ps ) $.
    syl2im.2 $e |- ( ch -> th ) $.
    syl2im.3 $e |- ( ps -> ( th -> ta ) ) $.
    $( Replace two antecedents.  Implication-only version of ~ syl2an .
       (Contributed by Wolf Lammen, 14-May-2013.) $)
    syl2im $p |- ( ph -> ( ch -> ta ) ) $=
      ( wi syl5 syl ) ABCEIFCDBEGHJK $.

    $( A commuted version of ~ syl2im .  Implication-only version of
       ~ syl2anr .  (Contributed by BJ, 20-Oct-2021.) $)
    syl2imc $p |- ( ch -> ( ph -> ta ) ) $=
      ( syl2im com12 ) ACEABCDEFGHIJ $.
  $}

  $( This theorem, sometimes called "Assertion" or "Pon" (for "ponens"), can be
     thought of as a closed form of modus ponens ~ ax-mp .  Theorem *2.27 of
     [WhiteheadRussell] p. 104.  (Contributed by NM, 15-Jul-1993.) $)
  pm2.27 $p |- ( ph -> ( ( ph -> ps ) -> ps ) ) $=
    ( wi id com12 ) ABCZABFDE $.

  ${
    mpdd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    mpdd.2 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( A nested modus ponens deduction.  Double deduction associated with
       ~ ax-mp .  Deduction associated with ~ mpd .  (Contributed by NM,
       12-Dec-2004.) $)
    mpdd $p |- ( ph -> ( ps -> th ) ) $=
      ( wi a2d mpd ) ABCGBDGEABCDFHI $.
  $}

  ${
    mpid.1 $e |- ( ph -> ch ) $.
    mpid.2 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( A nested modus ponens deduction.  Deduction associated with ~ mpi .
       (Contributed by NM, 14-Dec-2004.) $)
    mpid $p |- ( ph -> ( ps -> th ) ) $=
      ( a1d mpdd ) ABCDACBEGFH $.
  $}

  ${
    mpdi.1 $e |- ( ps -> ch ) $.
    mpdi.2 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( A nested modus ponens deduction.  (Contributed by NM, 16-Apr-2005.)
       (Proof shortened by Mel L. O'Cat, 15-Jan-2008.) $)
    mpdi $p |- ( ph -> ( ps -> th ) ) $=
      ( wi a1i mpdd ) ABCDBCGAEHFI $.
  $}

  ${
    mpii.1 $e |- ch $.
    mpii.2 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( A doubly nested modus ponens inference.  (Contributed by NM,
       31-Dec-1993.)  (Proof shortened by Wolf Lammen, 31-Jul-2012.) $)
    mpii $p |- ( ph -> ( ps -> th ) ) $=
      ( a1i mpdi ) ABCDCBEGFH $.
  $}

  ${
    syld.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syld.2 $e |- ( ph -> ( ch -> th ) ) $.
    $( Syllogism deduction.  Deduction associated with ~ syl .  See
       ~ conventions for the meaning of "associated deduction" or "deduction
       form".  (Contributed by NM, 5-Aug-1993.)  (Proof shortened by Mel L.
       O'Cat, 19-Feb-2008.)  (Proof shortened by Wolf Lammen, 3-Aug-2012.) $)
    syld $p |- ( ph -> ( ps -> th ) ) $=
      ( wi a1d mpdd ) ABCDEACDGBFHI $.

    $( Syllogism deduction.  Commuted form of ~ syld .  (Contributed by BJ,
       25-Oct-2021.) $)
    syldc $p |- ( ps -> ( ph -> th ) ) $=
      ( syld com12 ) ABDABCDEFGH $.
  $}

  ${
    mp2d.1 $e |- ( ph -> ps ) $.
    mp2d.2 $e |- ( ph -> ch ) $.
    mp2d.3 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( A double modus ponens deduction.  Deduction associated with ~ mp2 .
       (Contributed by NM, 23-May-2013.)  (Proof shortened by Wolf Lammen,
       23-Jul-2013.) $)
    mp2d $p |- ( ph -> th ) $=
      ( mpid mpd ) ABDEABCDFGHI $.
  $}

  ${
    a1dd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Double deduction introducing an antecedent.  Deduction associated with
       ~ a1d .  Double deduction associated with ~ ax-1 and ~ a1i .
       (Contributed by NM, 17-Dec-2004.)  (Proof shortened by Mel L. O'Cat,
       15-Jan-2008.) $)
    a1dd $p |- ( ph -> ( ps -> ( th -> ch ) ) ) $=
      ( wi ax-1 syl6 ) ABCDCFECDGH $.
  $}

  ${
    2a1dd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Double deduction introducing two antecedents.  Two applications of
       ~ 2a1dd .  Deduction associated with ~ 2a1d .  Double deduction
       associated with ~ 2a1 and ~ 2a1i .  (Contributed by Jeff Hankins,
       5-Aug-2009.) $)
    2a1dd $p |- ( ph -> ( ps -> ( th -> ( ta -> ch ) ) ) ) $=
      ( wi a1dd ) ABECGDABCEFHH $.
  $}

  ${
    pm2.43i.1 $e |- ( ph -> ( ph -> ps ) ) $.
    $( Inference absorbing redundant antecedent.  Inference associated with
       ~ pm2.43 .  (Contributed by NM, 10-Jan-1993.)  (Proof shortened by Mel
       L. O'Cat, 28-Nov-2008.) $)
    pm2.43i $p |- ( ph -> ps ) $=
      ( id mpd ) AABADCE $.
  $}

  ${
    pm2.43d.1 $e |- ( ph -> ( ps -> ( ps -> ch ) ) ) $.
    $( Deduction absorbing redundant antecedent.  Deduction associated with
       ~ pm2.43 and ~ pm2.43i .  (Contributed by NM, 18-Aug-1993.)  (Proof
       shortened by Mel L. O'Cat, 28-Nov-2008.) $)
    pm2.43d $p |- ( ph -> ( ps -> ch ) ) $=
      ( id mpdi ) ABBCBEDF $.
  $}

  ${
    pm2.43a.1 $e |- ( ps -> ( ph -> ( ps -> ch ) ) ) $.
    $( Inference absorbing redundant antecedent.  (Contributed by NM,
       7-Nov-1995.)  (Proof shortened by Mel L. O'Cat, 28-Nov-2008.) $)
    pm2.43a $p |- ( ps -> ( ph -> ch ) ) $=
      ( id mpid ) BABCBEDF $.
  $}

  ${
    pm2.43b.1 $e |- ( ps -> ( ph -> ( ps -> ch ) ) ) $.
    $( Inference absorbing redundant antecedent.  (Contributed by NM,
       31-Oct-1995.) $)
    pm2.43b $p |- ( ph -> ( ps -> ch ) ) $=
      ( pm2.43a com12 ) BACABCDEF $.
  $}

  $( Absorption of redundant antecedent.  Also called the "Contraction" or
     "Hilbert" axiom.  Theorem *2.43 of [WhiteheadRussell] p. 106.
     (Contributed by NM, 10-Jan-1993.)  (Proof shortened by Mel L. O'Cat,
     15-Aug-2004.) $)
  pm2.43 $p |- ( ( ph -> ( ph -> ps ) ) -> ( ph -> ps ) ) $=
    ( wi pm2.27 a2i ) AABCBABDE $.

  ${
    imim2d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction adding nested antecedents.  Deduction associated with ~ imim2
       and ~ imim2i .  (Contributed by NM, 10-Jan-1993.) $)
    imim2d $p |- ( ph -> ( ( th -> ps ) -> ( th -> ch ) ) ) $=
      ( wi a1d a2d ) ADBCABCFDEGH $.
  $}

  $( A closed form of syllogism (see ~ syl ).  Theorem *2.05 of
     [WhiteheadRussell] p. 100.  Its associated inference is ~ imim2i .  Its
     associated deduction is ~ imim2d .  An alternate proof from more basic
     results is given by ~ ax-1 followed by ~ a2d .  (Contributed by NM,
     29-Dec-1992.)  (Proof shortened by Wolf Lammen, 6-Sep-2012.) $)
  imim2 $p |- ( ( ph -> ps ) -> ( ( ch -> ph ) -> ( ch -> ps ) ) ) $=
    ( wi id imim2d ) ABDZABCGEF $.

  ${
    embantd.1 $e |- ( ph -> ps ) $.
    embantd.2 $e |- ( ph -> ( ch -> th ) ) $.
    $( Deduction embedding an antecedent.  (Contributed by Wolf Lammen,
       4-Oct-2013.) $)
    embantd $p |- ( ph -> ( ( ps -> ch ) -> th ) ) $=
      ( wi imim2d mpid ) ABCGBDEACDBFHI $.
  $}

  ${
    3syld.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3syld.2 $e |- ( ph -> ( ch -> th ) ) $.
    3syld.3 $e |- ( ph -> ( th -> ta ) ) $.
    $( Triple syllogism deduction.  Deduction associated with ~ 3syld .
       (Contributed by Jeff Hankins, 4-Aug-2009.) $)
    3syld $p |- ( ph -> ( ps -> ta ) ) $=
      ( syld ) ABDEABCDFGIHI $.
  $}

  ${
    sylsyld.1 $e |- ( ph -> ps ) $.
    sylsyld.2 $e |- ( ph -> ( ch -> th ) ) $.
    sylsyld.3 $e |- ( ps -> ( th -> ta ) ) $.
    $( A double syllogism inference.  (Contributed by Alan Sare,
       20-Apr-2011.) $)
    sylsyld $p |- ( ph -> ( ch -> ta ) ) $=
      ( wi syl syld ) ACDEGABDEIFHJK $.
  $}

  ${
    imim12i.1 $e |- ( ph -> ps ) $.
    imim12i.2 $e |- ( ch -> th ) $.
    $( Inference joining two implications.  Inference associated with
       ~ imim12 .  Its associated inference is ~ 3syl .  (Contributed by NM,
       12-Mar-1993.)  (Proof shortened by Mel L. O'Cat, 29-Oct-2011.) $)
    imim12i $p |- ( ( ps -> ch ) -> ( ph -> th ) ) $=
      ( wi imim2i syl5 ) ABBCGDECDBFHI $.
  $}

  ${
    imim1i.1 $e |- ( ph -> ps ) $.
    $( Inference adding common consequents in an implication, thereby
       interchanging the original antecedent and consequent.  Inference
       associated with ~ imim1 .  Its associated inference is ~ syl .
       (Contributed by NM, 28-Dec-1992.)  (Proof shortened by Wolf Lammen,
       4-Aug-2012.) $)
    imim1i $p |- ( ( ps -> ch ) -> ( ph -> ch ) ) $=
      ( id imim12i ) ABCCDCEF $.
  $}

  ${
    imim3i.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Inference adding three nested antecedents.  (Contributed by NM,
       19-Dec-2006.) $)
    imim3i $p |- ( ( th -> ph ) -> ( ( th -> ps ) -> ( th -> ch ) ) ) $=
      ( wi imim2i a2d ) DAFDBCABCFDEGH $.
  $}

  ${
    sylc.1 $e |- ( ph -> ps ) $.
    sylc.2 $e |- ( ph -> ch ) $.
    sylc.3 $e |- ( ps -> ( ch -> th ) ) $.
    $( A syllogism inference combined with contraction.  (Contributed by NM,
       4-May-1994.)  (Revised by NM, 13-Jul-2013.) $)
    sylc $p |- ( ph -> th ) $=
      ( syl2im pm2.43i ) ADABACDEFGHI $.
  $}

  ${
    syl3c.1 $e |- ( ph -> ps ) $.
    syl3c.2 $e |- ( ph -> ch ) $.
    syl3c.3 $e |- ( ph -> th ) $.
    syl3c.4 $e |- ( ps -> ( ch -> ( th -> ta ) ) ) $.
    $( A syllogism inference combined with contraction.  (Contributed by Alan
       Sare, 7-Jul-2011.) $)
    syl3c $p |- ( ph -> ta ) $=
      ( wi sylc mpd ) ADEHABCDEJFGIKL $.
  $}

  ${
    syl6mpi.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl6mpi.2 $e |- th $.
    syl6mpi.3 $e |- ( ch -> ( th -> ta ) ) $.
    $( A syllogism inference.  (Contributed by Alan Sare, 8-Jul-2011.)  (Proof
       shortened by Wolf Lammen, 13-Sep-2012.) $)
    syl6mpi $p |- ( ph -> ( ps -> ta ) ) $=
      ( mpi syl6 ) ABCEFCDEGHIJ $.
  $}

  ${
    mpsyl.1 $e |- ph $.
    mpsyl.2 $e |- ( ps -> ch ) $.
    mpsyl.3 $e |- ( ph -> ( ch -> th ) ) $.
    $( Modus ponens combined with a syllogism inference.  (Contributed by Alan
       Sare, 20-Apr-2011.) $)
    mpsyl $p |- ( ps -> th ) $=
      ( a1i sylc ) BACDABEHFGI $.
  $}

  ${
    mpsylsyld.1 $e |- ph $.
    mpsylsyld.2 $e |- ( ps -> ( ch -> th ) ) $.
    mpsylsyld.3 $e |- ( ph -> ( th -> ta ) ) $.
    $( Modus ponens combined with a double syllogism inference.  (Contributed
       by Alan Sare, 22-Jul-2012.) $)
    mpsylsyld $p |- ( ps -> ( ch -> ta ) ) $=
      ( a1i sylsyld ) BACDEABFIGHJ $.
  $}

  ${
    syl6c.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl6c.2 $e |- ( ph -> ( ps -> th ) ) $.
    syl6c.3 $e |- ( ch -> ( th -> ta ) ) $.
    $( Inference combining ~ syl6 with contraction.  (Contributed by Alan Sare,
       2-May-2011.) $)
    syl6c $p |- ( ph -> ( ps -> ta ) ) $=
      ( wi syl6 mpdd ) ABDEGABCDEIFHJK $.
  $}

  ${
    syl6ci.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl6ci.2 $e |- ( ph -> th ) $.
    syl6ci.3 $e |- ( ch -> ( th -> ta ) ) $.
    $( A syllogism inference combined with contraction.  (Contributed by Alan
       Sare, 18-Mar-2012.) $)
    syl6ci $p |- ( ph -> ( ps -> ta ) ) $=
      ( a1d syl6c ) ABCDEFADBGIHJ $.
  $}

  ${
    syldd.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    syldd.2 $e |- ( ph -> ( ps -> ( th -> ta ) ) ) $.
    $( Nested syllogism deduction.  Deduction associated with ~ syld .  Double
       deduction associated with ~ syl .  (Contributed by NM, 12-Dec-2004.)
       (Proof shortened by Wolf Lammen, 11-May-2013.) $)
    syldd $p |- ( ph -> ( ps -> ( ch -> ta ) ) ) $=
      ( wi imim2 syl6c ) ABDEHCDHCEHGFDECIJ $.
  $}

  ${
    syl5d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl5d.2 $e |- ( ph -> ( th -> ( ch -> ta ) ) ) $.
    $( A nested syllogism deduction.  Deduction associated with ~ syl5 .
       (Contributed by NM, 14-May-1993.)  (Proof shortened by Josh Purinton,
       29-Dec-2000.)  (Proof shortened by Mel L. O'Cat, 2-Feb-2006.) $)
    syl5d $p |- ( ph -> ( th -> ( ps -> ta ) ) ) $=
      ( wi a1d syldd ) ADBCEABCHDFIGJ $.
  $}

  ${
    syl7.1 $e |- ( ph -> ps ) $.
    syl7.2 $e |- ( ch -> ( th -> ( ps -> ta ) ) ) $.
    $( A syllogism rule of inference.  The first premise is used to replace the
       third antecedent of the second premise.  (Contributed by NM,
       12-Jan-1993.)  (Proof shortened by Wolf Lammen, 3-Aug-2012.) $)
    syl7 $p |- ( ch -> ( th -> ( ph -> ta ) ) ) $=
      ( wi a1i syl5d ) CABDEABHCFIGJ $.
  $}

  ${
    syl6d.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    syl6d.2 $e |- ( ph -> ( th -> ta ) ) $.
    $( A nested syllogism deduction.  Deduction associated with ~ syl6 .
       (Contributed by NM, 11-May-1993.)  (Proof shortened by Josh Purinton,
       29-Dec-2000.)  (Proof shortened by Mel L. O'Cat, 2-Feb-2006.) $)
    syl6d $p |- ( ph -> ( ps -> ( ch -> ta ) ) ) $=
      ( wi a1d syldd ) ABCDEFADEHBGIJ $.
  $}

  ${
    syl8.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    syl8.2 $e |- ( th -> ta ) $.
    $( A syllogism rule of inference.  The second premise is used to replace
       the consequent of the first premise.  (Contributed by NM, 1-Aug-1994.)
       (Proof shortened by Wolf Lammen, 3-Aug-2012.) $)
    syl8 $p |- ( ph -> ( ps -> ( ch -> ta ) ) ) $=
      ( wi a1i syl6d ) ABCDEFDEHAGIJ $.
  $}

  ${
    syl9.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl9.2 $e |- ( th -> ( ch -> ta ) ) $.
    $( A nested syllogism inference with different antecedents.  (Contributed
       by NM, 13-May-1993.)  (Proof shortened by Josh Purinton,
       29-Dec-2000.) $)
    syl9 $p |- ( ph -> ( th -> ( ps -> ta ) ) ) $=
      ( wi a1i syl5d ) ABCDEFDCEHHAGIJ $.
  $}

  ${
    syl9r.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl9r.2 $e |- ( th -> ( ch -> ta ) ) $.
    $( A nested syllogism inference with different antecedents.  (Contributed
       by NM, 14-May-1993.) $)
    syl9r $p |- ( th -> ( ph -> ( ps -> ta ) ) ) $=
      ( wi syl9 com12 ) ADBEHABCDEFGIJ $.
  $}

  ${
    syl10.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl10.2 $e |- ( ph -> ( ps -> ( th -> ta ) ) ) $.
    syl10.3 $e |- ( ch -> ( ta -> et ) ) $.
    $( A nested syllogism inference.  (Contributed by Alan Sare,
       17-Jul-2011.) $)
    syl10 $p |- ( ph -> ( ps -> ( th -> et ) ) ) $=
      ( wi syl6 syldd ) ABDEFHABCEFJGIKL $.
  $}

  ${
    a1ddd.1 $e |- ( ph -> ( ps -> ( ch -> ta ) ) ) $.
    $( Triple deduction introducing an antecedent to a wff.  Deduction
       associated with ~ a1dd .  Double deduction associated with ~ a1d .
       Triple deduction associated with ~ ax-1 and ~ a1i .  (Contributed by
       Jeff Hankins, 4-Aug-2009.) $)
    a1ddd $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      ( wi ax-1 syl8 ) ABCEDEGFEDHI $.
  $}

  ${
    imim12d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    imim12d.2 $e |- ( ph -> ( th -> ta ) ) $.
    $( Deduction combining antecedents and consequents.  Deduction associated
       with ~ imim12 and ~ imim12i .  (Contributed by NM, 7-Aug-1994.)  (Proof
       shortened by Mel L. O'Cat, 30-Oct-2011.) $)
    imim12d $p |- ( ph -> ( ( ch -> th ) -> ( ps -> ta ) ) ) $=
      ( wi imim2d syl5d ) ABCCDHEFADECGIJ $.
  $}

  ${
    imim1d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction adding nested consequents.  Deduction associated with ~ imim1
       and ~ imim1i .  (Contributed by NM, 3-Apr-1994.)  (Proof shortened by
       Wolf Lammen, 12-Sep-2012.) $)
    imim1d $p |- ( ph -> ( ( ch -> th ) -> ( ps -> th ) ) ) $=
      ( idd imim12d ) ABCDDEADFG $.
  $}

  $( A closed form of syllogism (see ~ syl ).  Theorem *2.06 of
     [WhiteheadRussell] p. 100.  Its associated inference is ~ imim1i .
     (Contributed by NM, 29-Dec-1992.)  (Proof shortened by Wolf Lammen,
     25-May-2013.) $)
  imim1 $p |- ( ( ph -> ps ) -> ( ( ps -> ch ) -> ( ph -> ch ) ) ) $=
    ( wi id imim1d ) ABDZABCGEF $.

  $( Theorem *2.83 of [WhiteheadRussell] p. 108.  Closed form of ~ syld .
     (Contributed by NM, 3-Jan-2005.) $)
  pm2.83 $p |- ( ( ph -> ( ps -> ch ) )
      -> ( ( ph -> ( ch -> th ) ) -> ( ph -> ( ps -> th ) ) ) ) $=
    ( wi imim1 imim3i ) BCECDEBDEABCDFG $.

  $( Over minimal implicational calculus, Peirce's axiom ~ peirce implies an
     axiom sometimes called "Roll",
     ` ( ( ( ph -> ps ) -> ch ) -> ( ( ch -> ph ) -> ph ) ) ` , of which
     ~ looinv is a special instance.  The converse also holds: substitute
     ` ( ph -> ps ) ` for ` ch ` in Roll and use ~ id and ~ ax-mp .
     (Contributed by BJ, 15-Jun-2021.) $)
  peirceroll $p |- ( ( ( ( ph -> ps ) -> ph ) -> ph )
                   -> ( ( ( ph -> ps ) -> ch ) -> ( ( ch -> ph ) -> ph ) ) ) $=
    ( wi imim1 id syl9r ) ABDZCDCADHADZIADZAHCAEJFG $.

  ${
    com3.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( Commutation of antecedents.  Swap 2nd and 3rd.  Deduction associated
       with ~ com12 .  (Contributed by NM, 27-Dec-1992.)  (Proof shortened by
       Wolf Lammen, 4-Aug-2012.) $)
    com23 $p |- ( ph -> ( ch -> ( ps -> th ) ) ) $=
      ( wi pm2.27 syl9 ) ABCDFCDECDGH $.

    $( Commutation of antecedents.  Rotate right.  (Contributed by NM,
       25-Apr-1994.) $)
    com3r $p |- ( ch -> ( ph -> ( ps -> th ) ) ) $=
      ( wi com23 com12 ) ACBDFABCDEGH $.

    $( Commutation of antecedents.  Swap 1st and 3rd.  (Contributed by NM,
       25-Apr-1994.)  (Proof shortened by Wolf Lammen, 28-Jul-2012.) $)
    com13 $p |- ( ch -> ( ps -> ( ph -> th ) ) ) $=
      ( com3r com23 ) CABDABCDEFG $.

    $( Commutation of antecedents.  Rotate left.  (Contributed by NM,
       25-Apr-1994.)  (Proof shortened by Wolf Lammen, 28-Jul-2012.) $)
    com3l $p |- ( ps -> ( ch -> ( ph -> th ) ) ) $=
      ( com3r ) CABDABCDEFF $.
  $}

  $( Swap antecedents.  Theorem *2.04 of [WhiteheadRussell] p. 100.  This was
     the third axiom in Frege's logic system, specifically Proposition 8 of
     [Frege1879] p. 35.  Its associated inference is ~ com12 .  (Contributed by
     NM, 27-Dec-1992.)  (Proof shortened by Wolf Lammen, 12-Sep-2012.) $)
  pm2.04 $p |- ( ( ph -> ( ps -> ch ) ) -> ( ps -> ( ph -> ch ) ) ) $=
    ( wi id com23 ) ABCDDZABCGEF $.

  ${
    com4.1 $e |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $.
    $( Commutation of antecedents.  Swap 3rd and 4th.  Deduction associated
       with ~ com23 .  Double deduction associated with ~ com12 .  (Contributed
       by NM, 25-Apr-1994.) $)
    com34 $p |- ( ph -> ( ps -> ( th -> ( ch -> ta ) ) ) ) $=
      ( wi pm2.04 syl6 ) ABCDEGGDCEGGFCDEHI $.

    $( Commutation of antecedents.  Rotate left.  (Contributed by NM,
       25-Apr-1994.)  (Proof shortened by Mel L. O'Cat, 15-Aug-2004.) $)
    com4l $p |- ( ps -> ( ch -> ( th -> ( ph -> ta ) ) ) ) $=
      ( wi com3l com34 ) BCADEABCDEGFHI $.

    $( Commutation of antecedents.  Rotate twice.  (Contributed by NM,
       25-Apr-1994.) $)
    com4t $p |- ( ch -> ( th -> ( ph -> ( ps -> ta ) ) ) ) $=
      ( com4l ) BCDAEABCDEFGG $.

    $( Commutation of antecedents.  Rotate right.  (Contributed by NM,
       25-Apr-1994.) $)
    com4r $p |- ( th -> ( ph -> ( ps -> ( ch -> ta ) ) ) ) $=
      ( com4t com4l ) CDABEABCDEFGH $.

    $( Commutation of antecedents.  Swap 2nd and 4th.  Deduction associated
       with ~ com13 .  (Contributed by NM, 25-Apr-1994.)  (Proof shortened by
       Wolf Lammen, 28-Jul-2012.) $)
    com24 $p |- ( ph -> ( th -> ( ch -> ( ps -> ta ) ) ) ) $=
      ( wi com4t com13 ) CDABEGABCDEFHI $.

    $( Commutation of antecedents.  Swap 1st and 4th.  (Contributed by NM,
       25-Apr-1994.)  (Proof shortened by Wolf Lammen, 28-Jul-2012.) $)
    com14 $p |- ( th -> ( ps -> ( ch -> ( ph -> ta ) ) ) ) $=
      ( wi com4l com3r ) BCDAEGABCDEFHI $.
  $}

  ${
    com5.1 $e |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $.
    $( Commutation of antecedents.  Swap 4th and 5th.  Deduction associated
       with ~ com34 .  Double deduction associated with ~ com23 .  Triple
       deduction associated with ~ com12 .  (Contributed by Jeff Hankins,
       28-Jun-2009.) $)
    com45 $p |- ( ph -> ( ps -> ( ch -> ( ta -> ( th -> et ) ) ) ) ) $=
      ( wi pm2.04 syl8 ) ABCDEFHHEDFHHGDEFIJ $.

    $( Commutation of antecedents.  Swap 3rd and 5th.  Deduction associated
       with ~ com24 .  Double deduction associated with ~ com13 .  (Contributed
       by Jeff Hankins, 28-Jun-2009.) $)
    com35 $p |- ( ph -> ( ps -> ( ta -> ( th -> ( ch -> et ) ) ) ) ) $=
      ( wi com34 com45 ) ABDECFHABDCEFABCDEFHGIJI $.

    $( Commutation of antecedents.  Swap 2nd and 5th.  Deduction associated
       with ~ com14 .  (Contributed by Jeff Hankins, 28-Jun-2009.) $)
    com25 $p |- ( ph -> ( ta -> ( ch -> ( th -> ( ps -> et ) ) ) ) ) $=
      ( wi com24 com45 ) ADCEBFHADCBEFABCDEFHGIJI $.

    $( Commutation of antecedents.  Rotate left.  (Contributed by Jeff Hankins,
       28-Jun-2009.)  (Proof shortened by Wolf Lammen, 29-Jul-2012.) $)
    com5l $p |- ( ps -> ( ch -> ( th -> ( ta -> ( ph -> et ) ) ) ) ) $=
      ( wi com4l com45 ) BCDAEFABCDEFHGIJ $.

    $( Commutation of antecedents.  Swap 1st and 5th.  (Contributed by Jeff
       Hankins, 28-Jun-2009.)  (Proof shortened by Wolf Lammen,
       29-Jul-2012.) $)
    com15 $p |- ( ta -> ( ps -> ( ch -> ( th -> ( ph -> et ) ) ) ) ) $=
      ( wi com5l com4r ) BCDEAFHABCDEFGIJ $.

    $( Commutation of antecedents.  Rotate left twice.  (Contributed by Jeff
       Hankins, 28-Jun-2009.) $)
    com52l $p |- ( ch -> ( th -> ( ta -> ( ph -> ( ps -> et ) ) ) ) ) $=
      ( com5l ) BCDEAFABCDEFGHH $.

    $( Commutation of antecedents.  Rotate right twice.  (Contributed by Jeff
       Hankins, 28-Jun-2009.) $)
    com52r $p |- ( th -> ( ta -> ( ph -> ( ps -> ( ch -> et ) ) ) ) ) $=
      ( com52l com5l ) CDEABFABCDEFGHI $.

    $( Commutation of antecedents.  Rotate right.  (Contributed by Wolf Lammen,
       29-Jul-2012.) $)
    com5r $p |- ( ta -> ( ph -> ( ps -> ( ch -> ( th -> et ) ) ) ) ) $=
      ( com52l ) CDEABFABCDEFGHH $.
  $}

  $( Closed form of ~ imim12i and of ~ 3syl .  (Contributed by BJ,
     16-Jul-2019.) $)
  imim12 $p |- ( ( ph -> ps ) ->
                      ( ( ch -> th ) -> ( ( ps -> ch ) -> ( ph -> th ) ) ) ) $=
    ( wi imim2 imim1 syl9r ) CDEBCEBDEABEADECDBFABDGH $.

  $( Elimination of a nested antecedent.  Sometimes called "Syll-Simp" since it
     is a syllogism applied to ~ ax-1 ("Simplification").  (Contributed by Wolf
     Lammen, 9-May-2013.) $)
  jarr $p |- ( ( ( ph -> ps ) -> ch ) -> ( ps -> ch ) ) $=
    ( wi ax-1 imim1i ) BABDCBAEF $.

  ${
    jarri.1 $e |- ( ( ph -> ps ) -> ch ) $.
    $( Inference associated with ~ jarr .  Partial converse of ~ ja (the other
       partial converse being ~ jarli ).  (Contributed by Wolf Lammen,
       20-Sep-2013.) $)
    jarri $p |- ( ps -> ch ) $=
      ( wi ax-1 syl ) BABECBAFDG $.
  $}

  ${
    pm2.86d.1 $e |- ( ph -> ( ( ps -> ch ) -> ( ps -> th ) ) ) $.
    $( Deduction associated with ~ pm2.86 .  (Contributed by NM, 29-Jun-1995.)
       (Proof shortened by Wolf Lammen, 3-Apr-2013.) $)
    pm2.86d $p |- ( ph -> ( ps -> ( ch -> th ) ) ) $=
      ( wi ax-1 syl5 com23 ) ACBDCBCFABDFCBGEHI $.
  $}

  $( Converse of Axiom ~ ax-2 .  Theorem *2.86 of [WhiteheadRussell] p. 108.
     (Contributed by NM, 25-Apr-1994.)  (Proof shortened by Wolf Lammen,
     3-Apr-2013.) $)
  pm2.86 $p |- ( ( ( ph -> ps ) -> ( ph -> ch ) ) ->
                                                    ( ph -> ( ps -> ch ) ) ) $=
    ( wi id pm2.86d ) ABDACDDZABCGEF $.

  ${
    pm2.86i.1 $e |- ( ( ph -> ps ) -> ( ph -> ch ) ) $.
    $( Inference associated with ~ pm2.86 .  (Contributed by NM, 5-Aug-1993.)
       (Proof shortened by Wolf Lammen, 3-Apr-2013.) $)
    pm2.86i $p |- ( ph -> ( ps -> ch ) ) $=
      ( wi jarri com12 ) BACABACEDFG $.
  $}

  $( The Linearity Axiom of the infinite-valued sentential logic (L-infinity)
     of Lukasiewicz.  See ~ loowoz for an alternate axiom.  (Contributed by Mel
     L. O'Cat, 12-Aug-2004.) $)
  loolin $p |- ( ( ( ph -> ps ) -> ( ps -> ph ) ) -> ( ps -> ph ) ) $=
    ( wi jarr pm2.43d ) ABCBACZCBAABFDE $.

  $( An alternate for the Linearity Axiom of the infinite-valued sentential
     logic (L-infinity) of Lukasiewicz ~ loolin , due to Barbara Wozniakowska,
     _Reports on Mathematical Logic_ 10, 129-137 (1978).  (Contributed by Mel
     L. O'Cat, 8-Aug-2004.) $)
  loowoz $p |- ( ( ( ph -> ps ) -> ( ph -> ch ) )
      -> ( ( ps -> ph ) -> ( ps -> ch ) ) ) $=
    ( wi jarr a2d ) ABDACDZDBACABGEF $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical negation
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  This section makes our first use of the third axiom of propositional
  calculus, ~ ax-3 .  It introduces logical negation.

$)

  $( Alias for ~ ax-3 to be used instead of it for labeling consistency.  Its
     associated inference is ~ con4i and its associated deduction is ~ con4d .
     (Contributed by BJ, 24-Dec-2020.) $)
  con4 $p |- ( ( -. ph -> -. ps ) -> ( ps -> ph ) ) $=
    ( ax-3 ) ABC $.

  ${
    con4i.1 $e |- ( -. ph -> -. ps ) $.
    $( Inference associated with ~ con4 .  Its associated inference is ~ mt4 .

       Remark: this can also be proved using ~ notnot followed by ~ nsyl2 ,
       giving a shorter proof but depending on more axioms (namely, ~ ax-1 and
       ~ ax-2 ).  (Contributed by NM, 29-Dec-1992.) $)
    con4i $p |- ( ps -> ph ) $=
      ( wn wi con4 ax-mp ) ADBDEBAECABFG $.
    $( $j usage 'con4i' avoids 'ax-1' 'ax-2'; $)
  $}

  ${
    con4d.1 $e |- ( ph -> ( -. ps -> -. ch ) ) $.
    $( Deduction associated with ~ con4 .  (Contributed by NM, 26-Mar-1995.) $)
    con4d $p |- ( ph -> ( ch -> ps ) ) $=
      ( wn wi con4 syl ) ABECEFCBFDBCGH $.
  $}

  ${
    mt4.1 $e |- ph $.
    mt4.2 $e |- ( -. ps -> -. ph ) $.
    $( The rule of modus tollens.  Inference associated with ~ con4i .
       (Contributed by Wolf Lammen, 12-May-2013.) $)
    mt4 $p |- ps $=
      ( con4i ax-mp ) ABCBADEF $.
  $}

  ${
    mt4d.1 $e |- ( ph -> ps ) $.
    mt4d.2 $e |- ( ph -> ( -. ch -> -. ps ) ) $.
    $( Modus tollens deduction.  Deduction form of ~ mt4 .  (Contributed by NM,
       9-Jun-2006.) $)
    mt4d $p |- ( ph -> ch ) $=
      ( con4d mpd ) ABCDACBEFG $.
  $}

  ${
    mt4i.1 $e |- ch $.
    mt4i.2 $e |- ( ph -> ( -. ps -> -. ch ) ) $.
    $( Modus tollens inference.  (Contributed by Wolf Lammen, 12-May-2013.) $)
    mt4i $p |- ( ph -> ps ) $=
      ( a1i mt4d ) ACBCADFEG $.
  $}

  ${
    pm2.21i.1 $e |- -. ph $.
    $( A contradiction implies anything.  Inference associated with ~ pm2.21 .
       Its associated inference is ~ pm2.24ii .  (Contributed by NM,
       16-Sep-1993.) $)
    pm2.21i $p |- ( ph -> ps ) $=
      ( wn a1i con4i ) BAADBDCEF $.
  $}

  ${
    pm2.24ii.1 $e |- ph $.
    pm2.24ii.2 $e |- -. ph $.
    $( A contradiction implies anything.  Inference associated with ~ pm2.21i
       and ~ pm2.24i .  (Contributed by NM, 27-Feb-2008.) $)
    pm2.24ii $p |- ps $=
      ( pm2.21i ax-mp ) ABCABDEF $.
    $( $j usage 'pm2.24ii' avoids 'ax-2'; $)
  $}

  ${
    pm2.21d.1 $e |- ( ph -> -. ps ) $.
    $( A contradiction implies anything.  Deduction associated with ~ pm2.21 .
       (Contributed by NM, 10-Feb-1996.) $)
    pm2.21d $p |- ( ph -> ( ps -> ch ) ) $=
      ( wn a1d con4d ) ACBABECEDFG $.
  $}

  ${
    pm2.21ddALT.1 $e |- ( ph -> ps ) $.
    pm2.21ddALT.2 $e |- ( ph -> -. ps ) $.
    $( Alternate proof of ~ pm2.21dd .  (Contributed by Mario Carneiro,
       9-Feb-2017.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    pm2.21ddALT $p |- ( ph -> ch ) $=
      ( pm2.21d mpd ) ABCDABCEFG $.
  $}

  $( From a wff and its negation, anything follows.  Theorem *2.21 of
     [WhiteheadRussell] p. 104.  Also called the Duns Scotus law.  Its commuted
     form is ~ pm2.24 and its associated inference is ~ pm2.21i .  (Contributed
     by NM, 29-Dec-1992.)  (Proof shortened by Wolf Lammen, 14-Sep-2012.) $)
  pm2.21 $p |- ( -. ph -> ( ph -> ps ) ) $=
    ( wn id pm2.21d ) ACZABFDE $.

  $( Theorem *2.24 of [WhiteheadRussell] p. 104.  Its associated inference is
     ~ pm2.24i .  Commuted form of ~ pm2.21 .  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.24 $p |- ( ph -> ( -. ph -> ps ) ) $=
    ( wn pm2.21 com12 ) ACABABDE $.

  $( Elimination of a nested antecedent.  (Contributed by Wolf Lammen,
     10-May-2013.) $)
  jarl $p |- ( ( ( ph -> ps ) -> ch ) -> ( -. ph -> ch ) ) $=
    ( wn wi pm2.21 imim1i ) ADABECABFG $.

  ${
    jarli.1 $e |- ( ( ph -> ps ) -> ch ) $.
    $( Inference associated with ~ jarl .  Partial converse of ~ ja (the other
       partial converse being ~ jarri ).  (Contributed by Wolf Lammen,
       4-Oct-2013.) $)
    jarli $p |- ( -. ph -> ch ) $=
      ( wn wi pm2.21 syl ) AEABFCABGDH $.
  $}

  ${
    pm2.18d.1 $e |- ( ph -> ( -. ps -> ps ) ) $.
    $( Deduction form of the Clavius law ~ pm2.18 .  (Contributed by FL,
       12-Jul-2009.)  (Proof shortened by Andrew Salmon, 7-May-2011.)  Shorten
       ~ pm2.18 .  (Revised by Wolf Lammen, 17-Nov-2023.) $)
    pm2.18d $p |- ( ph -> ps ) $=
      ( id wn pm2.21 sylcom mt4d ) AABADABEBAEZCBIFGH $.
  $}

  $( Clavius law, or "consequentia mirabilis" ("admirable consequence").  If a
     formula is implied by its negation, then it is true.  Can be used in
     proofs by contradiction.  Theorem *2.18 of [WhiteheadRussell] p. 103.  See
     also the weak Clavius law ~ pm2.01 .  (Contributed by NM, 29-Dec-1992.)
     (Proof shortened by Wolf Lammen, 17-Nov-2023.) $)
  pm2.18 $p |- ( ( -. ph -> ph ) -> ph ) $=
    ( wn wi id pm2.18d ) ABACZAFDE $.

  ${
    pm2.18i.1 $e |- ( -. ph -> ph ) $.
    $( Inference associated with the Clavius law ~ pm2.18 .  (Contributed by
       BJ, 30-Mar-2020.) $)
    pm2.18i $p |- ph $=
      ( wn wi pm2.18 ax-mp ) ACADABAEF $.
  $}

  $( Double negation elimination.  Converse of ~ notnot and one implication of
     ~ notnotb .  Theorem *2.14 of [WhiteheadRussell] p. 102.  This was the
     fifth axiom of Frege, specifically Proposition 31 of [Frege1879] p. 44.
     In classical logic (our logic) this is always true.  In intuitionistic
     logic this is not always true, and formulas for which it is true are
     called "stable".  (Contributed by NM, 29-Dec-1992.)  (Proof shortened by
     David Harvey, 5-Sep-1999.)  (Proof shortened by Josh Purinton,
     29-Dec-2000.) $)
  notnotr $p |- ( -. -. ph -> ph ) $=
    ( wn pm2.18 jarli ) ABAAACD $.

  ${
    notnotri.1 $e |- -. -. ph $.
    $( Inference associated with ~ notnotr .  For a shorter proof using
       ~ ax-2 , see ~ notnotriALT .  (Contributed by NM, 27-Feb-2008.)  (Proof
       shortened by Wolf Lammen, 15-Jul-2021.)  Remove dependency on ~ ax-2 .
       (Revised by Steven Nguyen, 27-Dec-2022.) $)
    notnotri $p |- ph $=
      ( wn pm2.21i mt4 ) ACZCZABFGCBDE $.
    $( $j usage 'notnotri' avoids 'ax-2'; $)

    $( Alternate proof of ~ notnotri .  The proof via ~ notnotr and ~ ax-mp
       also has three essential steps, but has a total number of steps equal to
       8, instead of the present 7, because it has to construct the formula
       ` ph ` twice and the formula ` -. -. ph ` once, whereas the present
       proof has to construct the formula ` ph ` twice and the formula
       ` -. ph ` once, and therefore makes only one use of ~ wn instead of two.
       This can be checked by running the Metamath command "MM> SHOW PROOF
       notnotri / NORMAL".  (Contributed by NM, 27-Feb-2008.)  (Proof shortened
       by Wolf Lammen, 15-Jul-2021.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    notnotriALT $p |- ph $=
      ( wn pm2.21i pm2.18i ) AACABDE $.
  $}

  ${
    notnotrd.1 $e |- ( ph -> -. -. ps ) $.
    $( Deduction associated with ~ notnotr and ~ notnotri .  Double negation
       elimination rule.  A translation of the natural deduction rule ` -. -. `
       C , ` _G |- -. -. ps => _G |- ps ` ; see ~ natded .  This is Definition
       NNC in [Pfenning] p. 17.  This rule is valid in classical logic (our
       logic), but not in intuitionistic logic.  (Contributed by DAW,
       8-Feb-2017.) $)
    notnotrd $p |- ( ph -> ps ) $=
      ( wn notnotr syl ) ABDDBCBEF $.
  $}

  ${
    con2d.1 $e |- ( ph -> ( ps -> -. ch ) ) $.
    $( A contraposition deduction.  (Contributed by NM, 19-Aug-1993.) $)
    con2d $p |- ( ph -> ( ch -> -. ps ) ) $=
      ( wn notnotr syl5 con4d ) ABEZCIEBACEBFDGH $.
  $}

  $( Contraposition.  Theorem *2.03 of [WhiteheadRussell] p. 100.  (Contributed
     by NM, 29-Dec-1992.)  (Proof shortened by Wolf Lammen, 12-Feb-2013.) $)
  con2 $p |- ( ( ph -> -. ps ) -> ( ps -> -. ph ) ) $=
    ( wn wi id con2d ) ABCDZABGEF $.

  ${
    mt2d.1 $e |- ( ph -> ch ) $.
    mt2d.2 $e |- ( ph -> ( ps -> -. ch ) ) $.
    $( Modus tollens deduction.  (Contributed by NM, 4-Jul-1994.) $)
    mt2d $p |- ( ph -> -. ps ) $=
      ( wn con2d mpd ) ACBFDABCEGH $.
  $}

  ${
    mt2i.1 $e |- ch $.
    mt2i.2 $e |- ( ph -> ( ps -> -. ch ) ) $.
    $( Modus tollens inference.  (Contributed by NM, 26-Mar-1995.)  (Proof
       shortened by Wolf Lammen, 15-Sep-2012.) $)
    mt2i $p |- ( ph -> -. ps ) $=
      ( a1i mt2d ) ABCCADFEG $.
  $}

  ${
    nsyl3.1 $e |- ( ph -> -. ps ) $.
    nsyl3.2 $e |- ( ch -> ps ) $.
    $( A negated syllogism inference.  (Contributed by NM, 1-Dec-1995.) $)
    nsyl3 $p |- ( ch -> -. ph ) $=
      ( wn wi a1i mt2d ) CABEABFGCDHI $.
  $}

  ${
    con2i.a $e |- ( ph -> -. ps ) $.
    $( A contraposition inference.  Its associated inference is ~ mt2 .
       (Contributed by NM, 10-Jan-1993.)  (Proof shortened by Mel L. O'Cat,
       28-Nov-2008.)  (Proof shortened by Wolf Lammen, 13-Jun-2013.) $)
    con2i $p |- ( ps -> -. ph ) $=
      ( id nsyl3 ) ABBCBDE $.
  $}

  ${
    nsyl.1 $e |- ( ph -> -. ps ) $.
    nsyl.2 $e |- ( ch -> ps ) $.
    $( A negated syllogism inference.  (Contributed by NM, 31-Dec-1993.)
       (Proof shortened by Wolf Lammen, 2-Mar-2013.) $)
    nsyl $p |- ( ph -> -. ch ) $=
      ( nsyl3 con2i ) CAABCDEFG $.
  $}

  ${
    nsyl2.1 $e |- ( ph -> -. ps ) $.
    nsyl2.2 $e |- ( -. ch -> ps ) $.
    $( A negated syllogism inference.  (Contributed by NM, 26-Jun-1994.)
       (Proof shortened by Wolf Lammen, 14-Nov-2023.) $)
    nsyl2 $p |- ( ph -> ch ) $=
      ( wn nsyl3 con4i ) CAABCFDEGH $.
  $}

  $( Double negation introduction.  Converse of ~ notnotr and one implication
     of ~ notnotb .  Theorem *2.12 of [WhiteheadRussell] p. 101.  This was the
     sixth axiom of Frege, specifically Proposition 41 of [Frege1879] p. 47.
     (Contributed by NM, 28-Dec-1992.)  (Proof shortened by Wolf Lammen,
     2-Mar-2013.) $)
  notnot $p |- ( ph -> -. -. ph ) $=
    ( wn id con2i ) ABZAECD $.

  ${
    notnoti.1 $e |- ph $.
    $( Inference associated with ~ notnot .  (Contributed by NM,
       27-Feb-2008.) $)
    notnoti $p |- -. -. ph $=
      ( wn notnot ax-mp ) AACCBADE $.
  $}

  ${
    notnotd.1 $e |- ( ph -> ps ) $.
    $( Deduction associated with ~ notnot and ~ notnoti .  (Contributed by
       Jarvin Udandy, 2-Sep-2016.)  Avoid biconditional.  (Revised by Wolf
       Lammen, 27-Mar-2021.) $)
    notnotd $p |- ( ph -> -. -. ps ) $=
      ( wn notnot syl ) ABBDDCBEF $.
  $}

  ${
    con1d.1 $e |- ( ph -> ( -. ps -> ch ) ) $.
    $( A contraposition deduction.  (Contributed by NM, 27-Dec-1992.) $)
    con1d $p |- ( ph -> ( -. ch -> ps ) ) $=
      ( wn notnot syl6 con4d ) ABCEZABECIEDCFGH $.
  $}

  $( Contraposition.  Theorem *2.15 of [WhiteheadRussell] p. 102.  Its
     associated inference is ~ con1i .  (Contributed by NM, 29-Dec-1992.)
     (Proof shortened by Wolf Lammen, 12-Feb-2013.) $)
  con1 $p |- ( ( -. ph -> ps ) -> ( -. ps -> ph ) ) $=
    ( wn wi id con1d ) ACBDZABGEF $.

  ${
    con1i.1 $e |- ( -. ph -> ps ) $.
    $( A contraposition inference.  Inference associated with ~ con1 .  Its
       associated inference is ~ mt3 .  (Contributed by NM, 3-Jan-1993.)
       (Proof shortened by Mel L. O'Cat, 28-Nov-2008.)  (Proof shortened by
       Wolf Lammen, 19-Jun-2013.) $)
    con1i $p |- ( -. ps -> ph ) $=
      ( wn id nsyl2 ) BDZBAGECF $.
  $}

  ${
    mt3d.1 $e |- ( ph -> -. ch ) $.
    mt3d.2 $e |- ( ph -> ( -. ps -> ch ) ) $.
    $( Modus tollens deduction.  (Contributed by NM, 26-Mar-1995.) $)
    mt3d $p |- ( ph -> ps ) $=
      ( wn con1d mpd ) ACFBDABCEGH $.
  $}

  ${
    mt3i.1 $e |- -. ch $.
    mt3i.2 $e |- ( ph -> ( -. ps -> ch ) ) $.
    $( Modus tollens inference.  (Contributed by NM, 26-Mar-1995.)  (Proof
       shortened by Wolf Lammen, 15-Sep-2012.) $)
    mt3i $p |- ( ph -> ps ) $=
      ( wn a1i mt3d ) ABCCFADGEH $.
  $}

  ${
    pm2.24i.1 $e |- ph $.
    $( Inference associated with ~ pm2.24 .  Its associated inference is
       ~ pm2.24ii .  (Contributed by NM, 20-Aug-2001.) $)
    pm2.24i $p |- ( -. ph -> ps ) $=
      ( wn a1i con1i ) BAABDCEF $.
  $}

  ${
    pm2.24d.1 $e |- ( ph -> ps ) $.
    $( Deduction form of ~ pm2.24 .  (Contributed by NM, 30-Jan-2006.) $)
    pm2.24d $p |- ( ph -> ( -. ps -> ch ) ) $=
      ( wn a1d con1d ) ACBABCEDFG $.
  $}

  ${
    con3d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( A contraposition deduction.  Deduction form of ~ con3 .  (Contributed by
       NM, 10-Jan-1993.) $)
    con3d $p |- ( ph -> ( -. ch -> -. ps ) ) $=
      ( wn notnotr syl5 con1d ) ABEZCIEBACBFDGH $.
  $}

  $( Contraposition.  Theorem *2.16 of [WhiteheadRussell] p. 103.  This was the
     fourth axiom of Frege, specifically Proposition 28 of [Frege1879] p. 43.
     Its associated inference is ~ con3i .  (Contributed by NM, 29-Dec-1992.)
     (Proof shortened by Wolf Lammen, 13-Feb-2013.) $)
  con3 $p |- ( ( ph -> ps ) -> ( -. ps -> -. ph ) ) $=
    ( wi id con3d ) ABCZABFDE $.

  ${
    con3i.a $e |- ( ph -> ps ) $.
    $( A contraposition inference.  Inference associated with ~ con3 .  Its
       associated inference is ~ mto .  (Contributed by NM, 3-Jan-1993.)
       (Proof shortened by Wolf Lammen, 20-Jun-2013.) $)
    con3i $p |- ( -. ps -> -. ph ) $=
      ( wn id nsyl ) BDZBAGECF $.
  $}

  ${
    con3rr3.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Rotate through consequent right.  (Contributed by Wolf Lammen,
       3-Nov-2013.) $)
    con3rr3 $p |- ( -. ch -> ( ph -> -. ps ) ) $=
      ( wn con3d com12 ) ACEBEABCDFG $.
  $}

  ${
    nsyld.1 $e |- ( ph -> ( ps -> -. ch ) ) $.
    nsyld.2 $e |- ( ph -> ( ta -> ch ) ) $.
    $( A negated syllogism deduction.  (Contributed by NM, 9-Apr-2005.) $)
    nsyld $p |- ( ph -> ( ps -> -. ta ) ) $=
      ( wn con3d syld ) ABCGDGEADCFHI $.
  $}

  ${
    nsyli.1 $e |- ( ph -> ( ps -> ch ) ) $.
    nsyli.2 $e |- ( th -> -. ch ) $.
    $( A negated syllogism inference.  (Contributed by NM, 3-May-1994.) $)
    nsyli $p |- ( ph -> ( th -> -. ps ) ) $=
      ( wn con3d syl5 ) DCGABGFABCEHI $.
  $}

  ${
    nsyl4.1 $e |- ( ph -> ps ) $.
    nsyl4.2 $e |- ( -. ph -> ch ) $.
    $( A negated syllogism inference.  (Contributed by NM, 15-Feb-1996.) $)
    nsyl4 $p |- ( -. ch -> ps ) $=
      ( wn con1i syl ) CFABACEGDH $.

    $( A negated syllogism inference.  (Contributed by Wolf Lammen,
       20-May-2024.) $)
    nsyl5 $p |- ( -. ps -> ch ) $=
      ( nsyl4 con1i ) CBABCDEFG $.
  $}

  $( Theorem *3.2 of [WhiteheadRussell] p. 111, expressed with primitive
     connectives (see ~ pm3.2 ).  (Contributed by NM, 29-Dec-1992.)  (Proof
     shortened by Josh Purinton, 29-Dec-2000.) $)
  pm3.2im $p |- ( ph -> ( ps -> -. ( ph -> -. ps ) ) ) $=
    ( wn wi pm2.27 con2d ) AABCZDBAGEF $.

  ${
    jc.1 $e |- ( ph -> ps ) $.
    jc.2 $e |- ( ph -> ch ) $.
    $( Deduction joining the consequents of two premises.  A deduction
       associated with ~ pm3.2im .  (Contributed by NM, 28-Dec-1992.) $)
    jc $p |- ( ph -> -. ( ps -> -. ch ) ) $=
      ( wn wi pm3.2im sylc ) ABCBCFGFDEBCHI $.
  $}

  $( Theorem joining the consequents of two premises.  Theorem 8 of [Margaris]
     p. 60.  (Contributed by NM, 5-Aug-1993.)  (Proof shortened by Josh
     Purinton, 29-Dec-2000.) $)
  jcn $p |- ( ph -> ( -. ps -> -. ( ph -> ps ) ) ) $=
    ( wi pm2.27 con3d ) AABCBABDE $.

  ${
    jcnd.1 $e |- ( ph -> ps ) $.
    jcnd.2 $e |- ( ph -> -. ch ) $.
    $( Deduction joining the consequents of two premises.  (Contributed by
       Glauco Siliprandi, 11-Dec-2019.)  (Proof shortened by Wolf Lammen,
       10-Apr-2024.) $)
    jcnd $p |- ( ph -> -. ( ps -> ch ) ) $=
      ( wn wi jcn sylc ) ABCFBCGFDEBCHI $.
  $}

  ${
    impi.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( An importation inference.  (Contributed by NM, 29-Dec-1992.)  (Proof
       shortened by Wolf Lammen, 20-Jul-2013.) $)
    impi $p |- ( -. ( ph -> -. ps ) -> ch ) $=
      ( wn wi con3rr3 con1i ) CABEFABCDGH $.
  $}

  ${
    expi.1 $e |- ( -. ( ph -> -. ps ) -> ch ) $.
    $( An exportation inference.  (Contributed by NM, 29-Dec-1992.)  (Proof
       shortened by Mel L. O'Cat, 28-Nov-2008.) $)
    expi $p |- ( ph -> ( ps -> ch ) ) $=
      ( wn wi pm3.2im syl6 ) ABABEFECABGDH $.
  $}

  $( Simplification.  Similar to Theorem *3.27 (Simp) of [WhiteheadRussell]
     p. 112.  (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 13-Nov-2012.) $)
  simprim $p |- ( -. ( ph -> -. ps ) -> ps ) $=
    ( idd impi ) ABBABCD $.

  $( Simplification.  Similar to Theorem *3.26 (Simp) of [WhiteheadRussell]
     p. 112.  (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 21-Jul-2012.) $)
  simplim $p |- ( -. ( ph -> ps ) -> ph ) $=
    ( wi pm2.21 con1i ) AABCABDE $.

  $( General instance of Theorem *2.5 of [WhiteheadRussell] p. 107.
     (Contributed by NM, 3-Jan-2005.)  (Proof shortened by Wolf Lammen,
     9-Oct-2012.) $)
  pm2.5g $p |- ( -. ( ph -> ps ) -> ( -. ph -> ch ) ) $=
    ( wi wn simplim pm2.24d ) ABDEACABFG $.

  $( Theorem *2.5 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.5 $p |- ( -. ( ph -> ps ) -> ( -. ph -> ps ) ) $=
    ( pm2.5g ) ABBC $.

  $( Contrapositive of ~ ax-1 .  (Contributed by BJ, 28-Oct-2023.) $)
  conax1 $p |- ( -. ( ph -> ps ) -> -. ps ) $=
    ( wi ax-1 con3i ) BABCBADE $.

  $( Weakening of ~ conax1 .  General instance of ~ pm2.51 and of ~ pm2.52 .
     (Contributed by BJ, 28-Oct-2023.) $)
  conax1k $p |- ( -. ( ph -> ps ) -> ( ch -> -. ps ) ) $=
    ( wi wn conax1 a1d ) ABDEBECABFG $.

  $( Theorem *2.51 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.51 $p |- ( -. ( ph -> ps ) -> ( ph -> -. ps ) ) $=
    ( conax1k ) ABAC $.

  $( Theorem *2.52 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 8-Oct-2012.) $)
  pm2.52 $p |- ( -. ( ph -> ps ) -> ( -. ph -> -. ps ) ) $=
    ( wn conax1k ) ABACD $.

  $( A general instance of Theorem *2.521 of [WhiteheadRussell] p. 107.
     (Contributed by BJ, 28-Oct-2023.) $)
  pm2.521g $p |- ( -. ( ph -> ps ) -> ( ps -> ch ) ) $=
    ( wi wn conax1 pm2.21d ) ABDEBCABFG $.

  $( A general instance of Theorem *2.521 of [WhiteheadRussell] p. 107.
     (Contributed by NM, 3-Jan-2005.)  (Proof shortened by Wolf Lammen,
     8-Oct-2012.) $)
  pm2.521g2 $p |- ( -. ( ph -> ps ) -> ( ch -> ph ) ) $=
    ( wi wn simplim a1d ) ABDEACABFG $.

  $( Theorem *2.521 of [WhiteheadRussell] p. 107.  Instance of ~ pm2.521g and
     of ~ pm2.521g2 .  (Contributed by NM, 3-Jan-2005.) $)
  pm2.521 $p |- ( -. ( ph -> ps ) -> ( ps -> ph ) ) $=
    ( pm2.521g ) ABAC $.

  $( Exportation theorem ~ pm3.3 (closed form of ~ ex ) expressed with
     primitive connectives.  (Contributed by NM, 28-Dec-1992.)  (Proof
     shortened by Garrett Katz, 25-May-2026.) $)
  expt $p |- ( ( -. ( ph -> -. ps ) -> ch ) -> ( ph -> ( ps -> ch ) ) ) $=
    ( wn wi pm3.2im id syl9r ) ABABDEDZICEZCABFJGH $.

  $( Obsolete version of ~ expt as of 25-May-2026.  Exportation theorem ~ pm3.3
     (closed form of ~ ex ) expressed with primitive connectives.  (Contributed
     by NM, 28-Dec-1992.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  exptOLD $p |- ( ( -. ( ph -> -. ps ) -> ch ) -> ( ph -> ( ps -> ch ) ) ) $=
    ( wn wi pm3.2im imim1d com12 ) AABDEDZCEBCEABICABFGH $.

  $( Importation theorem ~ pm3.1 (closed form of ~ imp ) expressed with
     primitive connectives.  (Contributed by NM, 25-Apr-1994.)  (Proof
     shortened by Wolf Lammen, 20-Jul-2013.) $)
  impt $p |- ( ( ph -> ( ps -> ch ) ) -> ( -. ( ph -> -. ps ) -> ch ) ) $=
    ( wi wn simprim simplim imim1i mpdi ) ABCDZDABEZDEZBCABFLAJAKGHI $.

  ${
    pm2.61d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    pm2.61d.2 $e |- ( ph -> ( -. ps -> ch ) ) $.
    $( Deduction eliminating an antecedent.  (Contributed by NM, 27-Apr-1994.)
       (Proof shortened by Wolf Lammen, 12-Sep-2013.) $)
    pm2.61d $p |- ( ph -> ch ) $=
      ( wn con1d syld pm2.18d ) ACACFBCABCEGDHI $.
  $}

  ${
    pm2.61d1.1 $e |- ( ph -> ( ps -> ch ) ) $.
    pm2.61d1.2 $e |- ( -. ps -> ch ) $.
    $( Inference eliminating an antecedent.  (Contributed by NM,
       15-Jul-2005.) $)
    pm2.61d1 $p |- ( ph -> ch ) $=
      ( wn wi a1i pm2.61d ) ABCDBFCGAEHI $.
  $}

  ${
    pm2.61d2.1 $e |- ( ph -> ( -. ps -> ch ) ) $.
    pm2.61d2.2 $e |- ( ps -> ch ) $.
    $( Inference eliminating an antecedent.  (Contributed by NM,
       18-Aug-1993.) $)
    pm2.61d2 $p |- ( ph -> ch ) $=
      ( wi a1i pm2.61d ) ABCBCFAEGDH $.
  $}

  ${
    pm2.61i.1 $e |- ( ph -> ps ) $.
    pm2.61i.2 $e |- ( -. ph -> ps ) $.
    $( Inference eliminating an antecedent.  (Contributed by NM, 5-Apr-1994.)
       (Proof shortened by Wolf Lammen, 19-Nov-2023.) $)
    pm2.61i $p |- ps $=
      ( nsyl4 pm2.18i ) BABBCDEF $.
  $}

  ${
    pm2.61ii.1 $e |- ( -. ph -> ( -. ps -> ch ) ) $.
    pm2.61ii.2 $e |- ( ph -> ch ) $.
    pm2.61ii.3 $e |- ( ps -> ch ) $.
    $( Inference eliminating two antecedents.  (Contributed by NM, 4-Jan-1993.)
       (Proof shortened by Josh Purinton, 29-Dec-2000.) $)
    pm2.61ii $p |- ch $=
      ( wn pm2.61d2 pm2.61i ) ACEAGBCDFHI $.
  $}

  ${
    pm2.61nii.1 $e |- ( ph -> ( ps -> ch ) ) $.
    pm2.61nii.2 $e |- ( -. ph -> ch ) $.
    pm2.61nii.3 $e |- ( -. ps -> ch ) $.
    $( Inference eliminating two antecedents.  (Contributed by NM,
       13-Jul-2005.)  (Proof shortened by Andrew Salmon, 25-May-2011.)  (Proof
       shortened by Wolf Lammen, 13-Nov-2012.) $)
    pm2.61nii $p |- ch $=
      ( pm2.61d1 pm2.61i ) ACABCDFGEH $.
  $}

  ${
    pm2.61iii.1 $e |- ( -. ph -> ( -. ps -> ( -. ch -> th ) ) ) $.
    pm2.61iii.2 $e |- ( ph -> th ) $.
    pm2.61iii.3 $e |- ( ps -> th ) $.
    pm2.61iii.4 $e |- ( ch -> th ) $.
    $( Inference eliminating three antecedents.  (Contributed by NM,
       2-Jan-2002.)  (Proof shortened by Wolf Lammen, 22-Sep-2013.) $)
    pm2.61iii $p |- th $=
      ( wn wi a1d pm2.61ii pm2.61i ) CDHABCIZDJEADNFKBDNGKLM $.
  $}

  ${
    ja.1 $e |- ( -. ph -> ch ) $.
    ja.2 $e |- ( ps -> ch ) $.
    $( Inference joining the antecedents of two premises.  For partial
       converses, see ~ jarri and ~ jarli .  (Contributed by NM, 24-Jan-1993.)
       (Proof shortened by Mel L. O'Cat, 19-Feb-2008.) $)
    ja $p |- ( ( ph -> ps ) -> ch ) $=
      ( wi imim2i pm2.61d1 ) ABFACBCAEGDH $.
  $}

  ${
    jad.1 $e |- ( ph -> ( -. ps -> th ) ) $.
    jad.2 $e |- ( ph -> ( ch -> th ) ) $.
    $( Deduction form of ~ ja .  (Contributed by Scott Fenton, 13-Dec-2010.)
       (Proof shortened by Andrew Salmon, 17-Sep-2011.) $)
    jad $p |- ( ph -> ( ( ps -> ch ) -> th ) ) $=
      ( wi wn com12 ja ) BCGADBCADGABHDEIACDFIJI $.
  $}

  $( Weak Clavius law.  If a formula implies its negation, then it is false.  A
     form of "reductio ad absurdum", which can be used in proofs by
     contradiction.  Theorem *2.01 of [WhiteheadRussell] p. 100.  Provable in
     minimal calculus, contrary to the Clavius law ~ pm2.18 .  (Contributed by
     NM, 18-Aug-1993.)  (Proof shortened by Mel L. O'Cat, 21-Nov-2008.)  (Proof
     shortened by Wolf Lammen, 31-Oct-2012.) $)
  pm2.01 $p |- ( ( ph -> -. ph ) -> -. ph ) $=
    ( wn id ja ) AABZEECZFD $.

  ${
    pm2.01i.1 $e |- ( ph -> -. ph ) $.
    $( Inference associated with the weak Clavius law ~ pm2.01 .  (Contributed
       by BJ, 30-Mar-2020.) $)
    pm2.01i $p |- -. ph $=
      ( wn wi pm2.01 ax-mp ) AACZDGBAEF $.
  $}

  ${
    pm2.01d.1 $e |- ( ph -> ( ps -> -. ps ) ) $.
    $( Deduction based on reductio ad absurdum.  (Contributed by NM,
       18-Aug-1993.)  (Proof shortened by Wolf Lammen, 5-Mar-2013.) $)
    pm2.01d $p |- ( ph -> -. ps ) $=
      ( wn id pm2.61d1 ) ABBDZCGEF $.
  $}

  $( Theorem *2.6 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.6 $p |- ( ( -. ph -> ps ) -> ( ( ph -> ps ) -> ps ) ) $=
    ( wn wi id idd jad ) ACBDZABBHEHBFG $.

  $( Theorem *2.61 of [WhiteheadRussell] p. 107.  Useful for eliminating an
     antecedent.  (Contributed by NM, 4-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 22-Sep-2013.) $)
  pm2.61 $p |- ( ( ph -> ps ) -> ( ( -. ph -> ps ) -> ps ) ) $=
    ( wn wi pm2.6 com12 ) ACBDABDBABEF $.

  $( Theorem *2.65 of [WhiteheadRussell] p. 107.  Proof by contradiction.
     (Contributed by NM, 21-Jun-1993.)  (Proof shortened by Wolf Lammen,
     8-Mar-2013.) $)
  pm2.65 $p |- ( ( ph -> ps ) -> ( ( ph -> -. ps ) -> -. ph ) ) $=
    ( wi wn idd con3 jad ) ABCZABDADZHIEABFG $.

  ${
    pm2.65i.1 $e |- ( ph -> ps ) $.
    pm2.65i.2 $e |- ( ph -> -. ps ) $.
    $( Inference for proof by contradiction.  (Contributed by NM, 18-May-1994.)
       (Proof shortened by Wolf Lammen, 11-Sep-2013.)  (Proof shortened by
       Garrett Katz, 7-Jun-2026.) $)
    pm2.65i $p |- -. ph $=
      ( nsyl3 pm2.01i ) AABADCEF $.

    $( Obsolete version of ~ pm2.65i as of 7-Jun-2026.  Inference for proof by
       contradiction.  (Contributed by NM, 18-May-1994.)  (Proof shortened by
       Wolf Lammen, 11-Sep-2013.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    pm2.65iOLD $p |- -. ph $=
      ( wn con2i con3i pm2.61i ) BAEABDFABCGH $.
  $}

  ${
    pm2.21dd.1 $e |- ( ph -> ps ) $.
    pm2.21dd.2 $e |- ( ph -> -. ps ) $.
    $( A contradiction implies anything.  Deduction from ~ pm2.21 .
       (Contributed by Mario Carneiro, 9-Feb-2017.)  (Proof shortened by Wolf
       Lammen, 22-Jul-2019.) $)
    pm2.21dd $p |- ( ph -> ch ) $=
      ( pm2.65i pm2.21i ) ACABDEFG $.
  $}

  ${
    pm2.65d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    pm2.65d.2 $e |- ( ph -> ( ps -> -. ch ) ) $.
    $( Deduction for proof by contradiction.  (Contributed by NM, 26-Jun-1994.)
       (Proof shortened by Wolf Lammen, 26-May-2013.) $)
    pm2.65d $p |- ( ph -> -. ps ) $=
      ( nsyld pm2.01d ) ABABCBEDFG $.
  $}

  ${
    mto.1 $e |- -. ps $.
    mto.2 $e |- ( ph -> ps ) $.
    $( The rule of modus tollens.  The rule says, "if ` ps ` is not true, and
       ` ph ` implies ` ps ` , then ` ph ` must also be not true".  Modus
       tollens is short for "modus tollendo tollens", a Latin phrase that means
       "the mode that by denying denies" - remark in [Sanford] p. 39.  It is
       also called denying the consequent.  Modus tollens is closely related to
       modus ponens ~ ax-mp .  Note that this rule is also valid in
       intuitionistic logic.  Inference associated with ~ con3i .  (Contributed
       by NM, 19-Aug-1993.)  (Proof shortened by Wolf Lammen, 11-Sep-2013.) $)
    mto $p |- -. ph $=
      ( wn a1i pm2.65i ) ABDBEACFG $.
  $}

  ${
    mtod.1 $e |- ( ph -> -. ch ) $.
    mtod.2 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Modus tollens deduction.  (Contributed by NM, 3-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 11-Sep-2013.) $)
    mtod $p |- ( ph -> -. ps ) $=
      ( wn a1d pm2.65d ) ABCEACFBDGH $.
  $}

  ${
    mtoi.1 $e |- -. ch $.
    mtoi.2 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Modus tollens inference.  (Contributed by NM, 5-Jul-1994.)  (Proof
       shortened by Wolf Lammen, 15-Sep-2012.) $)
    mtoi $p |- ( ph -> -. ps ) $=
      ( wn a1i mtod ) ABCCFADGEH $.
  $}

  ${
    mt2.1 $e |- ps $.
    mt2.2 $e |- ( ph -> -. ps ) $.
    $( A rule similar to modus tollens.  Inference associated with ~ con2i .
       (Contributed by NM, 19-Aug-1993.)  (Proof shortened by Wolf Lammen,
       10-Sep-2013.) $)
    mt2 $p |- -. ph $=
      ( a1i pm2.65i ) ABBACEDF $.
  $}

  ${
    mt3.1 $e |- -. ps $.
    mt3.2 $e |- ( -. ph -> ps ) $.
    $( A rule similar to modus tollens.  Inference associated with ~ con1i .
       (Contributed by NM, 18-May-1994.)  (Proof shortened by Wolf Lammen,
       11-Sep-2013.) $)
    mt3 $p |- ph $=
      ( wn mto notnotri ) AAEBCDFG $.
  $}

  $( Peirce's axiom.  A non-intuitionistic implication-only statement.  Added
     to intuitionistic (implicational) propositional calculus, it gives
     classical (implicational) propositional calculus.  For another
     non-intuitionistic positive statement, see ~ curryax .  When ` F. ` is
     substituted for ` ps ` , then this becomes the Clavius law ~ pm2.18 .
     (Contributed by NM, 29-Dec-1992.)  (Proof shortened by Wolf Lammen,
     9-Oct-2012.) $)
  peirce $p |- ( ( ( ph -> ps ) -> ph ) -> ph ) $=
    ( wi simplim id ja ) ABCAAABDAEF $.

  $( The Inversion Axiom of the infinite-valued sentential logic (L-infinity)
     of Lukasiewicz.  Using ~ dfor2 , we can see that this essentially
     expresses "disjunction is commutative".  Theorem *2.69 of
     [WhiteheadRussell] p. 108.  It is a special instance of the axiom "Roll",
     see ~ peirceroll .  (Contributed by NM, 12-Aug-2004.) $)
  looinv $p |- ( ( ( ph -> ps ) -> ps ) -> ( ( ps -> ph ) -> ph ) ) $=
    ( wi imim1 peirce syl6 ) ABCZBCBACGACAGBADABEF $.

  $( A self-implication (see ~ id ) does not imply its own negation.  The
     justification theorem ~ bijust is one of its instances.  (Contributed by
     NM, 11-May-1999.)  (Proof shortened by Josh Purinton, 29-Dec-2000.)
     Extract ~ bijust0 from proof of ~ bijust .  (Revised by BJ,
     19-Mar-2020.) $)
  bijust0 $p |- -. ( ( ph -> ph ) -> -. ( ph -> ph ) ) $=
    ( wi wn id pm2.01 mt2 ) AABZGCBGADGEF $.

  $( Theorem used to justify the definition of the biconditional ~ df-bi .
     Instance of ~ bijust0 .  (Contributed by NM, 11-May-1999.) $)
  bijust $p |- -. ( ( -. ( ( ph -> ps ) -> -. ( ps -> ph ) )
                   -> -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) )
              -> -. ( -. ( ( ph -> ps ) -> -. ( ps -> ph ) )
                   -> -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) ) ) $=
    ( wi wn bijust0 ) ABCBACDCDE $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical equivalence
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  Definition ~ df-bi in this section is our first definition, which
  introduces and defines the biconditional connective ` <-> ` used to denote
  logical equivalence.  We define a wff of the form ` ( ph <-> ps ) ` as an
  abbreviation for ` -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) ` .

  Unlike most traditional developments, we have chosen not to have a separate
  symbol such as "Df." to mean "is defined as".  Instead, we will later use the
  biconditional connective for this purpose ( ~ df-an is its first use), as it
  allows to use logic to manipulate definitions directly.  This greatly
  simplifies many proofs since it eliminates the need for a separate mechanism
  for introducing and eliminating definitions.

  A note on definitions: definitions are required to be eliminable (that is, a
  theorem stated in terms of the defined symbol can also be stated without it)
  and conservative (that is, a theorem whose statement does not contain the
  defined symbol can be proved without using that definition).  This means that
  a definition does not increase the expressive power nor the deductive power,
  respectively, of a theory.  On the other hand, definitions are often useful
  to write shorter proofs, so in (i)set.mm we will generally not try to avoid
  them.  This is why, for instance, some theorems which do not contain
  disjunction in their statement are placed after the section on disjunction
  because a shorter proof using disjunction is possible.

$)

  $( Declare the biconditional connective. $)
  $c <-> $.  $( Bidirectional arrow (read:  "if and only if" or
                "is logically equivalent to") $)

  $( Extend wff definition to include the biconditional connective. $)
  wb $a wff ( ph <-> ps ) $.

  $( Define the biconditional (logical "iff" or "if and only if"), also called
     biimplication.

     Definition ~ df-bi in this section is our first definition, which
     introduces and defines the biconditional connective ` <-> ` .  We define a
     wff of the form ` ( ph <-> ps ) ` as an abbreviation for
     ` -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) ` .

     Unlike most traditional developments, we have chosen not to have a
     separate symbol such as "Df." to mean "is defined as".  Instead, we will
     later use the biconditional connective for this purpose ( ~ df-an is its
     first use), as it allows to use logic to manipulate definitions directly.
     This greatly simplifies many proofs since it eliminates the need for a
     separate mechanism for introducing and eliminating definitions.  Of
     course, we cannot use this mechanism to define the biconditional itself,
     since it hasn't been introduced yet.  Instead, we use a more general form
     of definition, described as follows.

     In its most general form, a definition is simply an assertion that
     introduces a new symbol (or a new combination of existing symbols, as in
     ~ df-3an ) that is eliminable and does not strengthen the existing
     language.  The latter requirement means that the set of provable
     statements not containing the new symbol (or new combination) should
     remain exactly the same after the definition is introduced.  Our
     definition of the biconditional may look unusual compared to most
     definitions, but it strictly satisfies these requirements.

     The justification for our definition is that if we mechanically replace
     ` ( ph <-> ps ) ` (the definiendum i.e. the thing being defined) with
     ` -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) ` (the definiens i.e. the
     defining expression) in the definition, the definition becomes the
     previously proved theorem ~ bijust .  It is impossible to use ~ df-bi to
     prove any statement expressed in the original language that can't be
     proved from the original axioms, because if we simply replace each
     instance of ~ df-bi in the proof with the corresponding ~ bijust instance,
     we will end up with a proof from the original axioms.

     Note that from Metamath's point of view, a definition is just another
     axiom - i.e. an assertion we claim to be true - but from our high level
     point of view, we are not strengthening the language.  To indicate this
     fact, we prefix definition labels with "df-" instead of "ax-".  (This
     prefixing is an informal convention that means nothing to the Metamath
     proof verifier; it is just a naming convention for human readability.)

     After we define the constant true ` T. ` ( ~ df-tru ) and the constant
     false ` F. ` ( ~ df-fal ), we will be able to prove these truth table
     values: ` ( ( T. <-> T. ) <-> T. ) ` ( ~ trubitru ),
     ` ( ( T. <-> F. ) <-> F. ) ` ( ~ trubifal ), ` ( ( F. <-> T. ) <-> F. ) `
     ( ~ falbitru ), and ` ( ( F. <-> F. ) <-> T. ) ` ( ~ falbifal ).

     See ~ dfbi1 , ~ dfbi2 , and ~ dfbi3 for theorems suggesting typical
     textbook definitions of ` <-> ` , showing that our definition has the
     properties we expect.  Theorem ~ dfbi1 is particularly useful if we want
     to eliminate ` <-> ` from an expression to convert it to primitives.
     Theorem ~ dfbi shows this definition rewritten in an abbreviated form
     after conjunction is introduced, for easier understanding.

     Contrast with ` \/ ` ( ~ df-or ), ` -> ` ( ~ wi ), ` -/\ ` ( ~ df-nan ),
     and ` \/_ ` ( ~ df-xor ).  In some sense ` <-> ` returns true if two truth
     values are equal; ` = ` ( ~ df-cleq ) returns true if two classes are
     equal.  (Contributed by NM, 27-Dec-1992.) $)
  df-bi $a |- -. ( ( ( ph <-> ps ) -> -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) )
        -> -. ( -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) -> ( ph <-> ps ) ) ) $.

  $( $j justification 'bijust' for 'df-bi'; $)

  $( Property of the biconditional connective.  (Contributed by NM,
     11-May-1999.) $)
  impbi $p |- ( ( ph -> ps ) -> ( ( ps -> ph ) -> ( ph <-> ps ) ) ) $=
    ( wi wb wn df-bi simprim ax-mp expi ) ABCZBACZABDZLJKECEZCZMLCZECEOABFNOGHI
    $.

  ${
    impbii.1 $e |- ( ph -> ps ) $.
    impbii.2 $e |- ( ps -> ph ) $.
    $( Infer an equivalence from an implication and its converse.  Inference
       associated with ~ impbi .  (Contributed by NM, 29-Dec-1992.) $)
    impbii $p |- ( ph <-> ps ) $=
      ( wi wb impbi mp2 ) ABEBAEABFCDABGH $.
  $}

  ${
    impbidd.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    impbidd.2 $e |- ( ph -> ( ps -> ( th -> ch ) ) ) $.
    $( Deduce an equivalence from two implications.  Double deduction
       associated with ~ impbi and ~ impbii .  Deduction associated with
       ~ impbid .  (Contributed by Rodolfo Medina, 12-Oct-2010.) $)
    impbidd $p |- ( ph -> ( ps -> ( ch <-> th ) ) ) $=
      ( wi wb impbi syl6c ) ABCDGDCGCDHEFCDIJ $.
  $}

  ${
    impbid21d.1 $e |- ( ps -> ( ch -> th ) ) $.
    impbid21d.2 $e |- ( ph -> ( th -> ch ) ) $.
    $( Deduce an equivalence from two implications.  (Contributed by Wolf
       Lammen, 12-May-2013.) $)
    impbid21d $p |- ( ph -> ( ps -> ( ch <-> th ) ) ) $=
      ( wi wb impbi syl2imc ) BCDGADCGCDHEFCDIJ $.
  $}

  ${
    impbid.1 $e |- ( ph -> ( ps -> ch ) ) $.
    impbid.2 $e |- ( ph -> ( ch -> ps ) ) $.
    $( Deduce an equivalence from two implications.  Deduction associated with
       ~ impbi and ~ impbii .  (Contributed by NM, 24-Jan-1993.)  Prove it from
       ~ impbid21d .  (Revised by Wolf Lammen, 3-Nov-2012.) $)
    impbid $p |- ( ph -> ( ps <-> ch ) ) $=
      ( wb impbid21d pm2.43i ) ABCFAABCDEGH $.
  $}

  $( Relate the biconditional connective to primitive connectives.  See
     ~ dfbi1ALT for an unusual version proved directly from axioms.
     (Contributed by NM, 29-Dec-1992.) $)
  dfbi1 $p |- ( ( ph <-> ps ) <-> -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) ) $=
    ( wb wi wn df-bi impbi con3rr3 mt3 ) ABCZABDBADEDEZCZJKDZKJDZEDABFMNLJKGHI
    $.

  $( Alternate proof of ~ dfbi1 .  This proof, discovered by Gregory Bush on
     8-Mar-2004, has several curious properties.  First, it has only 17 steps
     directly from the axioms and ~ df-bi , compared to over 800 steps were the
     proof of ~ dfbi1 expanded into axioms.  Second, step 2 demands only the
     property of "true"; any axiom (or theorem) could be used.  It might be
     thought, therefore, that it is in some sense redundant, but in fact no
     proof is shorter than this (measured by number of steps).  Third, it
     illustrates how intermediate steps can "blow up" in size even in short
     proofs.  Fourth, the compressed proof is only 182 bytes (or 17 bytes in
     D-proof notation), but the generated web page is over 200kB with
     intermediate steps that are essentially incomprehensible to humans (other
     than Gregory Bush).  If there were an obfuscated code contest for proofs,
     this would be a contender.  This "blowing up" and incomprehensibility of
     the intermediate steps vividly demonstrate the advantages of using many
     layered intermediate theorems, since each theorem is easier to understand.
     (Contributed by Gregory Bush, 10-Mar-2004.)  (New usage is discouraged.)
     (Proof modification is discouraged.) $)
  dfbi1ALT $p |-
                ( ( ph <-> ps ) <-> -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) ) $=
    ( wch wth wb wi wn df-bi ax-1 ax-mp ax-3 ax-2 ) ABEZABFBAFGFGZFNMFGFGZMNEZA
    BHCDCFFZOPFZCDIRGZQGZFZQRFSPOFZSFZFZUASUBISUCTFZFZUDUAFUEUFTGZUCGZFZUEUHUIM
    NHUHUGIJTUCKJUESIJSUCTLJJRQKJJJ $.

  $( Property of the biconditional connective.  (Contributed by NM,
     11-May-1999.) $)
  biimp $p |- ( ( ph <-> ps ) -> ( ph -> ps ) ) $=
    ( wb wi wn df-bi simplim ax-mp syl ) ABCZABDZBADEZDEZKJMDZMJDEZDENABFNOGHKL
    GI $.

  ${
    biimpi.1 $e |- ( ph <-> ps ) $.
    $( Infer an implication from a logical equivalence.  Inference associated
       with ~ biimp .  (Contributed by NM, 29-Dec-1992.) $)
    biimpi $p |- ( ph -> ps ) $=
      ( wb wi biimp ax-mp ) ABDABECABFG $.
  $}

  ${
    sylbi.1 $e |- ( ph <-> ps ) $.
    sylbi.2 $e |- ( ps -> ch ) $.
    $( A mixed syllogism inference from a biconditional and an implication.
       Useful for substituting an antecedent with a definition.  (Contributed
       by NM, 3-Jan-1993.) $)
    sylbi $p |- ( ph -> ch ) $=
      ( biimpi syl ) ABCABDFEG $.
  $}

  ${
    sylib.1 $e |- ( ph -> ps ) $.
    sylib.2 $e |- ( ps <-> ch ) $.
    $( A mixed syllogism inference from an implication and a biconditional.
       (Contributed by NM, 3-Jan-1993.) $)
    sylib $p |- ( ph -> ch ) $=
      ( biimpi syl ) ABCDBCEFG $.
  $}

  ${
    sylbb.1 $e |- ( ph <-> ps ) $.
    sylbb.2 $e |- ( ps <-> ch ) $.
    $( A mixed syllogism inference from two biconditionals.  (Contributed by
       BJ, 30-Mar-2019.) $)
    sylbb $p |- ( ph -> ch ) $=
      ( biimpi sylbi ) ABCDBCEFG $.
  $}

  $( Property of the biconditional connective.  (Contributed by NM,
     11-May-1999.)  (Proof shortened by Wolf Lammen, 11-Nov-2012.) $)
  biimpr $p |- ( ( ph <-> ps ) -> ( ps -> ph ) ) $=
    ( wb wi wn dfbi1 simprim sylbi ) ABCABDZBADZEDEJABFIJGH $.

  $( Commutative law for the biconditional.  (Contributed by Wolf Lammen,
     10-Nov-2012.) $)
  bicom1 $p |- ( ( ph <-> ps ) -> ( ps <-> ph ) ) $=
    ( wb biimpr biimp impbid ) ABCBAABDABEF $.

  $( Commutative law for the biconditional.  Theorem *4.21 of
     [WhiteheadRussell] p. 117.  (Contributed by NM, 11-May-1993.) $)
  bicom $p |- ( ( ph <-> ps ) <-> ( ps <-> ph ) ) $=
    ( wb bicom1 impbii ) ABCBACABDBADE $.

  ${
    bicomd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Commute two sides of a biconditional in a deduction.  (Contributed by
       NM, 14-May-1993.) $)
    bicomd $p |- ( ph -> ( ch <-> ps ) ) $=
      ( wb bicom sylib ) ABCECBEDBCFG $.
  $}

  ${
    bicomi.1 $e |- ( ph <-> ps ) $.
    $( Inference from commutative law for logical equivalence.  (Contributed by
       NM, 3-Jan-1993.) $)
    bicomi $p |- ( ps <-> ph ) $=
      ( wb bicom1 ax-mp ) ABDBADCABEF $.
  $}

  ${
    impbid1.1 $e |- ( ph -> ( ps -> ch ) ) $.
    impbid1.2 $e |- ( ch -> ps ) $.
    $( Infer an equivalence from two implications.  (Contributed by NM,
       6-Mar-2007.) $)
    impbid1 $p |- ( ph -> ( ps <-> ch ) ) $=
      ( wi a1i impbid ) ABCDCBFAEGH $.
  $}

  ${
    impbid2.1 $e |- ( ps -> ch ) $.
    impbid2.2 $e |- ( ph -> ( ch -> ps ) ) $.
    $( Infer an equivalence from two implications.  (Contributed by NM,
       6-Mar-2007.)  (Proof shortened by Wolf Lammen, 27-Sep-2013.) $)
    impbid2 $p |- ( ph -> ( ps <-> ch ) ) $=
      ( impbid1 bicomd ) ACBACBEDFG $.
  $}

  ${
    impcon4bid.1 $e |- ( ph -> ( ps -> ch ) ) $.
    impcon4bid.2 $e |- ( ph -> ( -. ps -> -. ch ) ) $.
    $( A variation on ~ impbid with contraposition.  (Contributed by Jeff
       Hankins, 3-Jul-2009.) $)
    impcon4bid $p |- ( ph -> ( ps <-> ch ) ) $=
      ( con4d impbid ) ABCDABCEFG $.
  $}

  ${
    biimpri.1 $e |- ( ph <-> ps ) $.
    $( Infer a converse implication from a logical equivalence.  Inference
       associated with ~ biimpr .  (Contributed by NM, 29-Dec-1992.)  (Proof
       shortened by Wolf Lammen, 16-Sep-2013.) $)
    biimpri $p |- ( ps -> ph ) $=
      ( bicomi biimpi ) BAABCDE $.
  $}

  ${
    biimpd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduce an implication from a logical equivalence.  Deduction associated
       with ~ biimp and ~ biimpi .  (Contributed by NM, 11-Jan-1993.) $)
    biimpd $p |- ( ph -> ( ps -> ch ) ) $=
      ( wb wi biimp syl ) ABCEBCFDBCGH $.
  $}

  ${
    mpbi.min $e |- ph $.
    mpbi.maj $e |- ( ph <-> ps ) $.
    $( An inference from a biconditional, related to modus ponens.
       (Contributed by NM, 11-May-1993.) $)
    mpbi $p |- ps $=
      ( biimpi ax-mp ) ABCABDEF $.
  $}

  ${
    mpbir.min $e |- ps $.
    mpbir.maj $e |- ( ph <-> ps ) $.
    $( An inference from a biconditional, related to modus ponens.
       (Contributed by NM, 28-Dec-1992.) $)
    mpbir $p |- ph $=
      ( biimpri ax-mp ) BACABDEF $.
  $}

  ${
    mpbid.min $e |- ( ph -> ps ) $.
    mpbid.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( A deduction from a biconditional, related to modus ponens.  (Contributed
       by NM, 21-Jun-1993.) $)
    mpbid $p |- ( ph -> ch ) $=
      ( biimpd mpd ) ABCDABCEFG $.
  $}

  ${
    mpbii.min $e |- ps $.
    mpbii.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( An inference from a nested biconditional, related to modus ponens.
       (Contributed by NM, 16-May-1993.)  (Proof shortened by Wolf Lammen,
       25-Oct-2012.) $)
    mpbii $p |- ( ph -> ch ) $=
      ( a1i mpbid ) ABCBADFEG $.
  $}

  ${
    sylibr.1 $e |- ( ph -> ps ) $.
    sylibr.2 $e |- ( ch <-> ps ) $.
    $( A mixed syllogism inference from an implication and a biconditional.
       Useful for substituting a consequent with a definition.  (Contributed by
       NM, 3-Jan-1993.) $)
    sylibr $p |- ( ph -> ch ) $=
      ( biimpri syl ) ABCDCBEFG $.
  $}

  ${
    sylbir.1 $e |- ( ps <-> ph ) $.
    sylbir.2 $e |- ( ps -> ch ) $.
    $( A mixed syllogism inference from a biconditional and an implication.
       (Contributed by NM, 3-Jan-1993.) $)
    sylbir $p |- ( ph -> ch ) $=
      ( biimpri syl ) ABCBADFEG $.
  $}

  ${
    sylbbr.1 $e |- ( ph <-> ps ) $.
    sylbbr.2 $e |- ( ps <-> ch ) $.
    $( A mixed syllogism inference from two biconditionals.

       Note on the various syllogism-like statements in set.mm.  The
       hypothetical syllogism ~ syl infers an implication from two implications
       (and there are ~ 3syl and ~ 4syl for chaining more inferences).  There
       are four inferences inferring an implication from one implication and
       one biconditional: ~ sylbi , ~ sylib , ~ sylbir , ~ sylibr ; four
       inferences inferring an implication from two biconditionals: ~ sylbb ,
       ~ sylbbr , ~ sylbb1 , ~ sylbb2 ; four inferences inferring a
       biconditional from two biconditionals: ~ bitri , ~ bitr2i , ~ bitr3i ,
       ~ bitr4i (and more for chaining more biconditionals).  There are also
       closed forms and deduction versions of these, like, among many others,
       ~ syld , ~ syl5 , ~ syl6 , ~ mpbid , ~ bitrd , ~ bitrid , ~ bitrdi and
       variants.  (Contributed by BJ, 21-Apr-2019.) $)
    sylbbr $p |- ( ch -> ph ) $=
      ( biimpri sylibr ) CBABCEFDG $.
  $}

  ${
    sylbb1.1 $e |- ( ph <-> ps ) $.
    sylbb1.2 $e |- ( ph <-> ch ) $.
    $( A mixed syllogism inference from two biconditionals.  (Contributed by
       BJ, 21-Apr-2019.) $)
    sylbb1 $p |- ( ps -> ch ) $=
      ( biimpri sylib ) BACABDFEG $.
  $}

  ${
    sylbb2.1 $e |- ( ph <-> ps ) $.
    sylbb2.2 $e |- ( ch <-> ps ) $.
    $( A mixed syllogism inference from two biconditionals.  (Contributed by
       BJ, 21-Apr-2019.) $)
    sylbb2 $p |- ( ph -> ch ) $=
      ( biimpri sylbi ) ABCDCBEFG $.
  $}

  ${
    sylibd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    sylibd.2 $e |- ( ph -> ( ch <-> th ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 3-Aug-1994.) $)
    sylibd $p |- ( ph -> ( ps -> th ) ) $=
      ( biimpd syld ) ABCDEACDFGH $.
  $}

  ${
    sylbid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    sylbid.2 $e |- ( ph -> ( ch -> th ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 3-Aug-1994.) $)
    sylbid $p |- ( ph -> ( ps -> th ) ) $=
      ( biimpd syld ) ABCDABCEGFH $.
  $}

  ${
    mpbidi.min $e |- ( th -> ( ph -> ps ) ) $.
    mpbidi.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( A deduction from a biconditional, related to modus ponens.  (Contributed
       by NM, 9-Aug-1994.) $)
    mpbidi $p |- ( th -> ( ph -> ch ) ) $=
      ( biimpd sylcom ) DABCEABCFGH $.
  $}

  ${
    biimtrid.1 $e |- ( ph <-> ps ) $.
    biimtrid.2 $e |- ( ch -> ( ps -> th ) ) $.
    $( A mixed syllogism inference from a nested implication and a
       biconditional.  Useful for substituting an embedded antecedent with a
       definition.  (Contributed by NM, 12-Jan-1993.) $)
    biimtrid $p |- ( ch -> ( ph -> th ) ) $=
      ( biimpi syl5 ) ABCDABEGFH $.
  $}

  ${
    biimtrrid.1 $e |- ( ps <-> ph ) $.
    biimtrrid.2 $e |- ( ch -> ( ps -> th ) ) $.
    $( A mixed syllogism inference from a nested implication and a
       biconditional.  (Contributed by NM, 21-Jun-1993.) $)
    biimtrrid $p |- ( ch -> ( ph -> th ) ) $=
      ( biimpri syl5 ) ABCDBAEGFH $.
  $}

  ${
    imbitrid.1 $e |- ( ph -> ps ) $.
    imbitrid.2 $e |- ( ch -> ( ps <-> th ) ) $.
    $( A mixed syllogism inference.  (Contributed by NM, 12-Jan-1993.) $)
    imbitrid $p |- ( ch -> ( ph -> th ) ) $=
      ( biimpd syl5 ) ABCDECBDFGH $.

    $( A mixed syllogism inference.  (Contributed by NM, 19-Jun-2007.) $)
    syl5ibcom $p |- ( ph -> ( ch -> th ) ) $=
      ( imbitrid com12 ) CADABCDEFGH $.
  $}

  ${
    imbitrrid.1 $e |- ( ph -> th ) $.
    imbitrrid.2 $e |- ( ch -> ( ps <-> th ) ) $.
    $( A mixed syllogism inference.  (Contributed by NM, 3-Apr-1994.) $)
    imbitrrid $p |- ( ch -> ( ph -> ps ) ) $=
      ( bicomd imbitrid ) ADCBECBDFGH $.

    $( A mixed syllogism inference.  (Contributed by NM, 20-Jun-2007.) $)
    syl5ibrcom $p |- ( ph -> ( ch -> ps ) ) $=
      ( imbitrrid com12 ) CABABCDEFGH $.
  $}

  ${
    biimprd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduce a converse implication from a logical equivalence.  Deduction
       associated with ~ biimpr and ~ biimpri .  (Contributed by NM,
       11-Jan-1993.)  (Proof shortened by Wolf Lammen, 22-Sep-2013.) $)
    biimprd $p |- ( ph -> ( ch -> ps ) ) $=
      ( id imbitrrid ) CBACCEDF $.
  $}

  ${
    biimpcd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduce a commuted implication from a logical equivalence.  (Contributed
       by NM, 3-May-1994.)  (Proof shortened by Wolf Lammen, 22-Sep-2013.) $)
    biimpcd $p |- ( ps -> ( ph -> ch ) ) $=
      ( id syl5ibcom ) BBACBEDF $.

    $( Deduce a converse commuted implication from a logical equivalence.
       (Contributed by NM, 3-May-1994.)  (Proof shortened by Wolf Lammen,
       20-Dec-2013.) $)
    biimprcd $p |- ( ch -> ( ph -> ps ) ) $=
      ( id syl5ibrcom ) CBACCEDF $.
  $}

  ${
    imbitrdi.1 $e |- ( ph -> ( ps -> ch ) ) $.
    imbitrdi.2 $e |- ( ch <-> th ) $.
    $( A mixed syllogism inference from a nested implication and a
       biconditional.  (Contributed by NM, 21-Jun-1993.) $)
    imbitrdi $p |- ( ph -> ( ps -> th ) ) $=
      ( biimpi syl6 ) ABCDECDFGH $.
  $}

  ${
    imbitrrdi.1 $e |- ( ph -> ( ps -> ch ) ) $.
    imbitrrdi.2 $e |- ( th <-> ch ) $.
    $( A mixed syllogism inference from a nested implication and a
       biconditional.  Useful for substituting an embedded consequent with a
       definition.  (Contributed by NM, 5-Aug-1993.) $)
    imbitrrdi $p |- ( ph -> ( ps -> th ) ) $=
      ( biimpri syl6 ) ABCDEDCFGH $.
  $}

  ${
    biimtrdi.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    biimtrdi.2 $e |- ( ch -> th ) $.
    $( A mixed syllogism inference.  (Contributed by NM, 2-Jan-1994.) $)
    biimtrdi $p |- ( ph -> ( ps -> th ) ) $=
      ( biimpd syl6 ) ABCDABCEGFH $.
  $}

  ${
    biimtrrdi.1 $e |- ( ph -> ( ch <-> ps ) ) $.
    biimtrrdi.2 $e |- ( ch -> th ) $.
    $( A mixed syllogism inference.  (Contributed by NM, 18-May-1994.) $)
    biimtrrdi $p |- ( ph -> ( ps -> th ) ) $=
      ( biimprd syl6 ) ABCDACBEGFH $.
  $}

  ${
    syl7bi.1 $e |- ( ph <-> ps ) $.
    syl7bi.2 $e |- ( ch -> ( th -> ( ps -> ta ) ) ) $.
    $( A mixed syllogism inference from a doubly nested implication and a
       biconditional.  (Contributed by NM, 14-May-1993.) $)
    syl7bi $p |- ( ch -> ( th -> ( ph -> ta ) ) ) $=
      ( biimpi syl7 ) ABCDEABFHGI $.
  $}

  ${
    syl8ib.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    syl8ib.2 $e |- ( th <-> ta ) $.
    $( A syllogism rule of inference.  The second premise is used to replace
       the consequent of the first premise.  (Contributed by NM,
       1-Aug-1994.) $)
    syl8ib $p |- ( ph -> ( ps -> ( ch -> ta ) ) ) $=
      ( biimpi syl8 ) ABCDEFDEGHI $.
  $}

  ${
    mpbird.min $e |- ( ph -> ch ) $.
    mpbird.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( A deduction from a biconditional, related to modus ponens.  (Contributed
       by NM, 5-Aug-1993.) $)
    mpbird $p |- ( ph -> ps ) $=
      ( biimprd mpd ) ACBDABCEFG $.
  $}

  ${
    mpbiri.min $e |- ch $.
    mpbiri.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( An inference from a nested biconditional, related to modus ponens.
       (Contributed by NM, 21-Jun-1993.)  (Proof shortened by Wolf Lammen,
       25-Oct-2012.) $)
    mpbiri $p |- ( ph -> ps ) $=
      ( a1i mpbird ) ABCCADFEG $.
  $}

  ${
    sylibrd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    sylibrd.2 $e |- ( ph -> ( th <-> ch ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 3-Aug-1994.) $)
    sylibrd $p |- ( ph -> ( ps -> th ) ) $=
      ( biimprd syld ) ABCDEADCFGH $.
  $}

  ${
    sylbird.1 $e |- ( ph -> ( ch <-> ps ) ) $.
    sylbird.2 $e |- ( ph -> ( ch -> th ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 3-Aug-1994.) $)
    sylbird $p |- ( ph -> ( ps -> th ) ) $=
      ( biimprd syld ) ABCDACBEGFH $.
  $}

  $( Principle of identity for logical equivalence.  Theorem *4.2 of
     [WhiteheadRussell] p. 117.  This is part of Frege's eighth axiom per
     Proposition 54 of [Frege1879] p. 50; see also ~ eqid .  (Contributed by
     NM, 2-Jun-1993.) $)
  biid $p |- ( ph <-> ph ) $=
    ( id impbii ) AAABZDC $.

  $( Principle of identity with antecedent.  (Contributed by NM,
     25-Nov-1995.) $)
  biidd $p |- ( ph -> ( ps <-> ps ) ) $=
    ( wb biid a1i ) BBCABDE $.

  $( Two propositions are equivalent if they are both true.  Closed form of
     ~ 2th .  Equivalent to a ~ biimp -like version of the xor-connective.
     This theorem stays true, no matter how you permute its operands.  This is
     evident from its sharper version ` ( ph <-> ( ps <-> ( ph <-> ps ) ) ) ` .
     (Contributed by Wolf Lammen, 12-May-2013.) $)
  pm5.1im $p |- ( ph -> ( ps -> ( ph <-> ps ) ) ) $=
    ( ax-1 impbid21d ) ABABBACABCD $.

  ${
    2th.1 $e |- ph $.
    2th.2 $e |- ps $.
    $( Two truths are equivalent.  (Contributed by NM, 18-Aug-1993.) $)
    2th $p |- ( ph <-> ps ) $=
      ( a1i impbii ) ABBADEABCEF $.
  $}

  ${
    2thd.1 $e |- ( ph -> ps ) $.
    2thd.2 $e |- ( ph -> ch ) $.
    $( Two truths are equivalent.  Deduction form.  (Contributed by NM,
       3-Jun-2012.) $)
    2thd $p |- ( ph -> ( ps <-> ch ) ) $=
      ( wb pm5.1im sylc ) ABCBCFDEBCGH $.
  $}

  $( Two self-implications (see ~ id ) are equivalent.  This theorem, rather
     trivial in our axiomatization, is (the biconditional form of) a standard
     axiom for monothetic BCI logic.  This is the most general theorem of which
     ~ trujust is an instance.  Relatedly, this would be the justification
     theorem if the definition of ` T. ` were ~ dftru2 .  (Contributed by BJ,
     7-Sep-2022.) $)
  monothetic $p |- ( ( ph -> ph ) <-> ( ps -> ps ) ) $=
    ( wi id 2th ) AACBBCADBDE $.

  ${
    ibi.1 $e |- ( ph -> ( ph <-> ps ) ) $.
    $( Inference that converts a biconditional implied by one of its arguments,
       into an implication.  (Contributed by NM, 17-Oct-2003.) $)
    ibi $p |- ( ph -> ps ) $=
      ( id mpbid ) AABADCE $.
  $}

  ${
    ibir.1 $e |- ( ph -> ( ps <-> ph ) ) $.
    $( Inference that converts a biconditional implied by one of its arguments,
       into an implication.  (Contributed by NM, 22-Jul-2004.) $)
    ibir $p |- ( ph -> ps ) $=
      ( bicomd ibi ) ABABACDE $.
  $}

  ${
    ibd.1 $e |- ( ph -> ( ps -> ( ps <-> ch ) ) ) $.
    $( Deduction that converts a biconditional implied by one of its arguments,
       into an implication.  Deduction associated with ~ ibi .  (Contributed by
       NM, 26-Jun-2004.) $)
    ibd $p |- ( ph -> ( ps -> ch ) ) $=
      ( wb biimp syli ) BABCECDBCFG $.
  $}

  $( Distribution of implication over biconditional.  Theorem *5.74 of
     [WhiteheadRussell] p. 126.  (Contributed by NM, 1-Aug-1994.)  (Proof
     shortened by Wolf Lammen, 11-Apr-2013.) $)
  pm5.74 $p |- ( ( ph -> ( ps <-> ch ) ) <->
               ( ( ph -> ps ) <-> ( ph -> ch ) ) ) $=
    ( wb wi biimp imim3i biimpr impbid pm2.86d impbidd impbii ) ABCDZEZABEZACEZ
    DZNOPMBCABCFGMCBABCHGIQABCQABCOPFJQACBOPHJKL $.

  ${
    pm5.74i.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Distribution of implication over biconditional (inference form).
       (Contributed by NM, 1-Aug-1994.) $)
    pm5.74i $p |- ( ( ph -> ps ) <-> ( ph -> ch ) ) $=
      ( wb wi pm5.74 mpbi ) ABCEFABFACFEDABCGH $.
  $}

  ${
    pm5.74ri.1 $e |- ( ( ph -> ps ) <-> ( ph -> ch ) ) $.
    $( Distribution of implication over biconditional (reverse inference form).
       (Contributed by NM, 1-Aug-1994.) $)
    pm5.74ri $p |- ( ph -> ( ps <-> ch ) ) $=
      ( wb wi pm5.74 mpbir ) ABCEFABFACFEDABCGH $.
  $}

  ${
    pm5.74d.1 $e |- ( ph -> ( ps -> ( ch <-> th ) ) ) $.
    $( Distribution of implication over biconditional (deduction form).
       (Contributed by NM, 21-Mar-1996.) $)
    pm5.74d $p |- ( ph -> ( ( ps -> ch ) <-> ( ps -> th ) ) ) $=
      ( wb wi pm5.74 sylib ) ABCDFGBCGBDGFEBCDHI $.
  $}

  ${
    pm5.74rd.1 $e |- ( ph -> ( ( ps -> ch ) <-> ( ps -> th ) ) ) $.
    $( Distribution of implication over biconditional (deduction form).
       (Contributed by NM, 19-Mar-1997.) $)
    pm5.74rd $p |- ( ph -> ( ps -> ( ch <-> th ) ) ) $=
      ( wi wb pm5.74 sylibr ) ABCFBDFGBCDGFEBCDHI $.
  $}

  ${
    bitri.1 $e |- ( ph <-> ps ) $.
    bitri.2 $e |- ( ps <-> ch ) $.
    $( An inference from transitive law for logical equivalence.  (Contributed
       by NM, 3-Jan-1993.)  (Proof shortened by Wolf Lammen, 13-Oct-2012.) $)
    bitri $p |- ( ph <-> ch ) $=
      ( sylbb sylbbr impbii ) ACABCDEFABCDEGH $.
  $}

  ${
    bitr2i.1 $e |- ( ph <-> ps ) $.
    bitr2i.2 $e |- ( ps <-> ch ) $.
    $( An inference from transitive law for logical equivalence.  (Contributed
       by NM, 12-Mar-1993.) $)
    bitr2i $p |- ( ch <-> ph ) $=
      ( bitri bicomi ) ACABCDEFG $.
  $}

  ${
    bitr3i.1 $e |- ( ps <-> ph ) $.
    bitr3i.2 $e |- ( ps <-> ch ) $.
    $( An inference from transitive law for logical equivalence.  (Contributed
       by NM, 2-Jun-1993.) $)
    bitr3i $p |- ( ph <-> ch ) $=
      ( bicomi bitri ) ABCBADFEG $.
  $}

  ${
    bitr4i.1 $e |- ( ph <-> ps ) $.
    bitr4i.2 $e |- ( ch <-> ps ) $.
    $( An inference from transitive law for logical equivalence.  (Contributed
       by NM, 3-Jan-1993.) $)
    bitr4i $p |- ( ph <-> ch ) $=
      ( bicomi bitri ) ABCDCBEFG $.
  $}

  $( Register '<->' as an equality for its type (wff). $)
  $( $j
    equality 'wb' from 'biid' 'bicomi' 'bitri';
    definition 'dfbi1' for 'wb';
  $)

  ${
    bitrd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitrd.2 $e |- ( ph -> ( ch <-> th ) ) $.
    $( Deduction form of ~ bitri .  (Contributed by NM, 12-Mar-1993.)  (Proof
       shortened by Wolf Lammen, 14-Apr-2013.) $)
    bitrd $p |- ( ph -> ( ps <-> th ) ) $=
      ( wi pm5.74i bitri pm5.74ri ) ABDABGACGADGABCEHACDFHIJ $.
  $}

  ${
    bitr2d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitr2d.2 $e |- ( ph -> ( ch <-> th ) ) $.
    $( Deduction form of ~ bitr2i .  (Contributed by NM, 9-Jun-2004.) $)
    bitr2d $p |- ( ph -> ( th <-> ps ) ) $=
      ( bitrd bicomd ) ABDABCDEFGH $.
  $}

  ${
    bitr3d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitr3d.2 $e |- ( ph -> ( ps <-> th ) ) $.
    $( Deduction form of ~ bitr3i .  (Contributed by NM, 14-May-1993.) $)
    bitr3d $p |- ( ph -> ( ch <-> th ) ) $=
      ( bicomd bitrd ) ACBDABCEGFH $.
  $}

  ${
    bitr4d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitr4d.2 $e |- ( ph -> ( th <-> ch ) ) $.
    $( Deduction form of ~ bitr4i .  (Contributed by NM, 30-Jun-1993.) $)
    bitr4d $p |- ( ph -> ( ps <-> th ) ) $=
      ( bicomd bitrd ) ABCDEADCFGH $.
  $}

  ${
    bitrid.1 $e |- ( ph <-> ps ) $.
    bitrid.2 $e |- ( ch -> ( ps <-> th ) ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       12-Mar-1993.) $)
    bitrid $p |- ( ch -> ( ph <-> th ) ) $=
      ( wb a1i bitrd ) CABDABGCEHFI $.
  $}

  ${
    bitr2id.1 $e |- ( ph <-> ps ) $.
    bitr2id.2 $e |- ( ch -> ( ps <-> th ) ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       1-Aug-1993.) $)
    bitr2id $p |- ( ch -> ( th <-> ph ) ) $=
      ( bitrid bicomd ) CADABCDEFGH $.
  $}

  ${
    bitr3id.1 $e |- ( ps <-> ph ) $.
    bitr3id.2 $e |- ( ch -> ( ps <-> th ) ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       5-Aug-1993.) $)
    bitr3id $p |- ( ch -> ( ph <-> th ) ) $=
      ( bicomi bitrid ) ABCDBAEGFH $.
  $}

  ${
    bitr3di.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitr3di.2 $e |- ( ps <-> th ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       25-Nov-1994.) $)
    bitr3di $p |- ( ph -> ( ch <-> th ) ) $=
      ( bicomi bitr2id ) DBACBDFGEH $.
  $}

  ${
    bitrdi.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitrdi.2 $e |- ( ch <-> th ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       12-Mar-1993.) $)
    bitrdi $p |- ( ph -> ( ps <-> th ) ) $=
      ( wb a1i bitrd ) ABCDECDGAFHI $.
  $}

  ${
    bitr2di.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitr2di.2 $e |- ( ch <-> th ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       5-Aug-1993.) $)
    bitr2di $p |- ( ph -> ( th <-> ps ) ) $=
      ( bitrdi bicomd ) ABDABCDEFGH $.
  $}

  ${
    bitr4di.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitr4di.2 $e |- ( th <-> ch ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       12-Mar-1993.) $)
    bitr4di $p |- ( ph -> ( ps <-> th ) ) $=
      ( bicomi bitrdi ) ABCDEDCFGH $.
  $}

  ${
    bitr4id.2 $e |- ( ps <-> ch ) $.
    bitr4id.1 $e |- ( ph -> ( th <-> ch ) ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       25-Nov-1994.) $)
    bitr4id $p |- ( ph -> ( ps <-> th ) ) $=
      ( bicomi bitr2di ) ADCBFBCEGH $.
  $}

  ${
    3imtr3.1 $e |- ( ph -> ps ) $.
    3imtr3.2 $e |- ( ph <-> ch ) $.
    3imtr3.3 $e |- ( ps <-> th ) $.
    $( A mixed syllogism inference, useful for removing a definition from both
       sides of an implication.  (Contributed by NM, 10-Aug-1994.) $)
    3imtr3i $p |- ( ch -> th ) $=
      ( sylbir sylib ) CBDCABFEHGI $.
  $}

  ${
    3imtr4.1 $e |- ( ph -> ps ) $.
    3imtr4.2 $e |- ( ch <-> ph ) $.
    3imtr4.3 $e |- ( th <-> ps ) $.
    $( A mixed syllogism inference, useful for applying a definition to both
       sides of an implication.  (Contributed by NM, 3-Jan-1993.) $)
    3imtr4i $p |- ( ch -> th ) $=
      ( sylbi sylibr ) CBDCABFEHGI $.
  $}

  ${
    3imtr3d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3imtr3d.2 $e |- ( ph -> ( ps <-> th ) ) $.
    3imtr3d.3 $e |- ( ph -> ( ch <-> ta ) ) $.
    $( More general version of ~ 3imtr3i .  Useful for converting conditional
       definitions in a formula.  (Contributed by NM, 8-Apr-1996.) $)
    3imtr3d $p |- ( ph -> ( th -> ta ) ) $=
      ( sylibd sylbird ) ADBEGABCEFHIJ $.
  $}

  ${
    3imtr4d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3imtr4d.2 $e |- ( ph -> ( th <-> ps ) ) $.
    3imtr4d.3 $e |- ( ph -> ( ta <-> ch ) ) $.
    $( More general version of ~ 3imtr4i .  Useful for converting conditional
       definitions in a formula.  (Contributed by NM, 26-Oct-1995.) $)
    3imtr4d $p |- ( ph -> ( th -> ta ) ) $=
      ( sylibrd sylbid ) ADBEGABCEFHIJ $.
  $}

  ${
    3imtr3g.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3imtr3g.2 $e |- ( ps <-> th ) $.
    3imtr3g.3 $e |- ( ch <-> ta ) $.
    $( More general version of ~ 3imtr3i .  Useful for converting definitions
       in a formula.  (Contributed by NM, 20-May-1996.)  (Proof shortened by
       Wolf Lammen, 20-Dec-2013.) $)
    3imtr3g $p |- ( ph -> ( th -> ta ) ) $=
      ( biimtrrid imbitrdi ) ADCEDBACGFIHJ $.
  $}

  ${
    3imtr4g.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3imtr4g.2 $e |- ( th <-> ps ) $.
    3imtr4g.3 $e |- ( ta <-> ch ) $.
    $( More general version of ~ 3imtr4i .  Useful for converting definitions
       in a formula.  (Contributed by NM, 20-May-1996.)  (Proof shortened by
       Wolf Lammen, 20-Dec-2013.) $)
    3imtr4g $p |- ( ph -> ( th -> ta ) ) $=
      ( biimtrid imbitrrdi ) ADCEDBACGFIHJ $.
  $}

  ${
    3bitri.1 $e |- ( ph <-> ps ) $.
    3bitri.2 $e |- ( ps <-> ch ) $.
    3bitri.3 $e |- ( ch <-> th ) $.
    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 3-Jan-1993.) $)
    3bitri $p |- ( ph <-> th ) $=
      ( bitri ) ABDEBCDFGHH $.

    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 4-Aug-2006.) $)
    3bitrri $p |- ( th <-> ph ) $=
      ( bitr2i bitr3i ) DCAGABCEFHI $.
  $}

  ${
    3bitr2i.1 $e |- ( ph <-> ps ) $.
    3bitr2i.2 $e |- ( ch <-> ps ) $.
    3bitr2i.3 $e |- ( ch <-> th ) $.
    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 4-Aug-2006.) $)
    3bitr2i $p |- ( ph <-> th ) $=
      ( bitr4i bitri ) ACDABCEFHGI $.

    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 4-Aug-2006.) $)
    3bitr2ri $p |- ( th <-> ph ) $=
      ( bitr4i bitr2i ) ACDABCEFHGI $.
  $}

  ${
    3bitr3i.1 $e |- ( ph <-> ps ) $.
    3bitr3i.2 $e |- ( ph <-> ch ) $.
    3bitr3i.3 $e |- ( ps <-> th ) $.
    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 19-Aug-1993.) $)
    3bitr3i $p |- ( ch <-> th ) $=
      ( bitr3i bitri ) CBDCABFEHGI $.

    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 21-Jun-1993.) $)
    3bitr3ri $p |- ( th <-> ch ) $=
      ( bitr3i ) DBCGBACEFHH $.
  $}

  ${
    3bitr4i.1 $e |- ( ph <-> ps ) $.
    3bitr4i.2 $e |- ( ch <-> ph ) $.
    3bitr4i.3 $e |- ( th <-> ps ) $.
    $( A chained inference from transitive law for logical equivalence.  This
       inference is frequently used to apply a definition to both sides of a
       logical equivalence.  (Contributed by NM, 3-Jan-1993.) $)
    3bitr4i $p |- ( ch <-> th ) $=
      ( bitr4i bitri ) CADFABDEGHI $.

    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 2-Sep-1995.) $)
    3bitr4ri $p |- ( th <-> ch ) $=
      ( bitr4i bitr2i ) CADFABDEGHI $.
  $}

  ${
    3bitrd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3bitrd.2 $e |- ( ph -> ( ch <-> th ) ) $.
    3bitrd.3 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Deduction from transitivity of biconditional.  (Contributed by NM,
       13-Aug-1999.) $)
    3bitrd $p |- ( ph -> ( ps <-> ta ) ) $=
      ( bitrd ) ABDEABCDFGIHI $.

    $( Deduction from transitivity of biconditional.  (Contributed by NM,
       4-Aug-2006.) $)
    3bitrrd $p |- ( ph -> ( ta <-> ps ) ) $=
      ( bitr2d bitr3d ) ADEBHABCDFGIJ $.
  $}

  ${
    3bitr2d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3bitr2d.2 $e |- ( ph -> ( th <-> ch ) ) $.
    3bitr2d.3 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Deduction from transitivity of biconditional.  (Contributed by NM,
       4-Aug-2006.) $)
    3bitr2d $p |- ( ph -> ( ps <-> ta ) ) $=
      ( bitr4d bitrd ) ABDEABCDFGIHJ $.

    $( Deduction from transitivity of biconditional.  (Contributed by NM,
       4-Aug-2006.) $)
    3bitr2rd $p |- ( ph -> ( ta <-> ps ) ) $=
      ( bitr4d bitr2d ) ABDEABCDFGIHJ $.
  $}

  ${
    3bitr3d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3bitr3d.2 $e |- ( ph -> ( ps <-> th ) ) $.
    3bitr3d.3 $e |- ( ph -> ( ch <-> ta ) ) $.
    $( Deduction from transitivity of biconditional.  Useful for converting
       conditional definitions in a formula.  (Contributed by NM,
       24-Apr-1996.) $)
    3bitr3d $p |- ( ph -> ( th <-> ta ) ) $=
      ( bitr3d bitrd ) ADCEABDCGFIHJ $.

    $( Deduction from transitivity of biconditional.  (Contributed by NM,
       4-Aug-2006.) $)
    3bitr3rd $p |- ( ph -> ( ta <-> th ) ) $=
      ( bitr3d ) ACEDHABCDFGII $.
  $}

  ${
    3bitr4d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3bitr4d.2 $e |- ( ph -> ( th <-> ps ) ) $.
    3bitr4d.3 $e |- ( ph -> ( ta <-> ch ) ) $.
    $( Deduction from transitivity of biconditional.  Useful for converting
       conditional definitions in a formula.  (Contributed by NM,
       18-Oct-1995.) $)
    3bitr4d $p |- ( ph -> ( th <-> ta ) ) $=
      ( bitr4d bitrd ) ADBEGABCEFHIJ $.

    $( Deduction from transitivity of biconditional.  (Contributed by NM,
       4-Aug-2006.) $)
    3bitr4rd $p |- ( ph -> ( ta <-> th ) ) $=
      ( bitr4d ) AEBDAECBHFIGI $.
  $}

  ${
    3bitr3g.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3bitr3g.2 $e |- ( ps <-> th ) $.
    3bitr3g.3 $e |- ( ch <-> ta ) $.
    $( More general version of ~ 3bitr3i .  Useful for converting definitions
       in a formula.  (Contributed by NM, 4-Jun-1995.) $)
    3bitr3g $p |- ( ph -> ( th <-> ta ) ) $=
      ( bitr3id bitrdi ) ADCEDBACGFIHJ $.
  $}

  ${
    3bitr4g.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3bitr4g.2 $e |- ( th <-> ps ) $.
    3bitr4g.3 $e |- ( ta <-> ch ) $.
    $( More general version of ~ 3bitr4i .  Useful for converting definitions
       in a formula.  (Contributed by NM, 11-May-1993.) $)
    3bitr4g $p |- ( ph -> ( th <-> ta ) ) $=
      ( bitrid bitr4di ) ADCEDBACGFIHJ $.
  $}

  $( Double negation.  Theorem *4.13 of [WhiteheadRussell] p. 117.
     (Contributed by NM, 3-Jan-1993.) $)
  notnotb $p |- ( ph <-> -. -. ph ) $=
    ( wn notnot notnotr impbii ) AABBACADE $.

  $( A biconditional form of contraposition.  Theorem *4.1 of
     [WhiteheadRussell] p. 116.  (Contributed by NM, 11-May-1993.) $)
  con34b $p |- ( ( ph -> ps ) <-> ( -. ps -> -. ph ) ) $=
    ( wi wn con3 con4 impbii ) ABCBDADCABEBAFG $.

  ${
    con4bid.1 $e |- ( ph -> ( -. ps <-> -. ch ) ) $.
    $( A contraposition deduction.  (Contributed by NM, 21-May-1994.) $)
    con4bid $p |- ( ph -> ( ps <-> ch ) ) $=
      ( wn biimprd con4d biimpd impcon4bid ) ABCACBABEZCEZDFGAJKDHI $.
  $}

  ${
    notbid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduction negating both sides of a logical equivalence.  (Contributed by
       NM, 21-May-1994.) $)
    notbid $p |- ( ph -> ( -. ps <-> -. ch ) ) $=
      ( wn notnotb 3bitr3g con4bid ) ABEZCEZABCIEJEDBFCFGH $.
  $}

  $( Contraposition.  Theorem *4.11 of [WhiteheadRussell] p. 117.  (Contributed
     by NM, 21-May-1994.)  (Proof shortened by Wolf Lammen, 12-Jun-2013.) $)
  notbi $p |- ( ( ph <-> ps ) <-> ( -. ph <-> -. ps ) ) $=
    ( wb wn id notbid con4bid impbii ) ABCZADBDCZIABIEFJABJEGH $.

  ${
    notbii.1 $e |- ( ph <-> ps ) $.
    $( Negate both sides of a logical equivalence.  (Contributed by NM,
       3-Jan-1993.)  (Proof shortened by Wolf Lammen, 19-May-2013.) $)
    notbii $p |- ( -. ph <-> -. ps ) $=
      ( wb wn notbi mpbi ) ABDAEBEDCABFG $.

    $( Theorem notbii is the congruence law for negation. $)
    $( $j congruence 'notbii'; $)
  $}

  ${
    con4bii.1 $e |- ( -. ph <-> -. ps ) $.
    $( A contraposition inference.  (Contributed by NM, 21-May-1994.) $)
    con4bii $p |- ( ph <-> ps ) $=
      ( wb wn notbi mpbir ) ABDAEBEDCABFG $.
  $}

  ${
    mtbi.1 $e |- -. ph $.
    mtbi.2 $e |- ( ph <-> ps ) $.
    $( An inference from a biconditional, related to modus tollens.
       (Contributed by NM, 15-Nov-1994.)  (Proof shortened by Wolf Lammen,
       25-Oct-2012.) $)
    mtbi $p |- -. ps $=
      ( biimpri mto ) BACABDEF $.
  $}

  ${
    mtbir.1 $e |- -. ps $.
    mtbir.2 $e |- ( ph <-> ps ) $.
    $( An inference from a biconditional, related to modus tollens.
       (Contributed by NM, 15-Nov-1994.)  (Proof shortened by Wolf Lammen,
       14-Oct-2012.) $)
    mtbir $p |- -. ph $=
      ( bicomi mtbi ) BACABDEF $.
  $}

  ${
    mtbid.min $e |- ( ph -> -. ps ) $.
    mtbid.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( A deduction from a biconditional, similar to modus tollens.
       (Contributed by NM, 26-Nov-1995.) $)
    mtbid $p |- ( ph -> -. ch ) $=
      ( biimprd mtod ) ACBDABCEFG $.
  $}

  ${
    mtbird.min $e |- ( ph -> -. ch ) $.
    mtbird.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( A deduction from a biconditional, similar to modus tollens.
       (Contributed by NM, 10-May-1994.) $)
    mtbird $p |- ( ph -> -. ps ) $=
      ( biimpd mtod ) ABCDABCEFG $.
  $}

  ${
    mtbii.min $e |- -. ps $.
    mtbii.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( An inference from a biconditional, similar to modus tollens.
       (Contributed by NM, 27-Nov-1995.) $)
    mtbii $p |- ( ph -> -. ch ) $=
      ( biimprd mtoi ) ACBDABCEFG $.
  $}

  ${
    mtbiri.min $e |- -. ch $.
    mtbiri.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( An inference from a biconditional, similar to modus tollens.
       (Contributed by NM, 24-Aug-1995.) $)
    mtbiri $p |- ( ph -> -. ps ) $=
      ( biimpd mtoi ) ABCDABCEFG $.
  $}

  ${
    sylnib.1 $e |- ( ph -> -. ps ) $.
    sylnib.2 $e |- ( ps <-> ch ) $.
    $( A mixed syllogism inference from an implication and a biconditional.
       (Contributed by Wolf Lammen, 16-Dec-2013.) $)
    sylnib $p |- ( ph -> -. ch ) $=
      ( biimpri nsyl ) ABCDBCEFG $.
  $}

  ${
    sylnibr.1 $e |- ( ph -> -. ps ) $.
    sylnibr.2 $e |- ( ch <-> ps ) $.
    $( A mixed syllogism inference from an implication and a biconditional.
       Useful for substituting a consequent with a definition.  (Contributed by
       Wolf Lammen, 16-Dec-2013.) $)
    sylnibr $p |- ( ph -> -. ch ) $=
      ( bicomi sylnib ) ABCDCBEFG $.
  $}

  ${
    sylnbi.1 $e |- ( ph <-> ps ) $.
    sylnbi.2 $e |- ( -. ps -> ch ) $.
    $( A mixed syllogism inference from a biconditional and an implication.
       Useful for substituting an antecedent with a definition.  (Contributed
       by Wolf Lammen, 16-Dec-2013.) $)
    sylnbi $p |- ( -. ph -> ch ) $=
      ( wn notbii sylbi ) AFBFCABDGEH $.
  $}

  ${
    sylnbir.1 $e |- ( ps <-> ph ) $.
    sylnbir.2 $e |- ( -. ps -> ch ) $.
    $( A mixed syllogism inference from a biconditional and an implication.
       (Contributed by Wolf Lammen, 16-Dec-2013.) $)
    sylnbir $p |- ( -. ph -> ch ) $=
      ( bicomi sylnbi ) ABCBADFEG $.
  $}

  ${
    xchnxbi.1 $e |- ( -. ph <-> ps ) $.
    xchnxbi.2 $e |- ( ph <-> ch ) $.
    $( Replacement of a subexpression by an equivalent one.  (Contributed by
       Wolf Lammen, 27-Sep-2014.) $)
    xchnxbi $p |- ( -. ch <-> ps ) $=
      ( wn notbii bitr3i ) CFAFBACEGDH $.
  $}

  ${
    xchnxbir.1 $e |- ( -. ph <-> ps ) $.
    xchnxbir.2 $e |- ( ch <-> ph ) $.
    $( Replacement of a subexpression by an equivalent one.  (Contributed by
       Wolf Lammen, 27-Sep-2014.) $)
    xchnxbir $p |- ( -. ch <-> ps ) $=
      ( bicomi xchnxbi ) ABCDCAEFG $.
  $}

  ${
    xchbinx.1 $e |- ( ph <-> -. ps ) $.
    xchbinx.2 $e |- ( ps <-> ch ) $.
    $( Replacement of a subexpression by an equivalent one.  (Contributed by
       Wolf Lammen, 27-Sep-2014.) $)
    xchbinx $p |- ( ph <-> -. ch ) $=
      ( wn notbii bitri ) ABFCFDBCEGH $.
  $}

  ${
    xchbinxr.1 $e |- ( ph <-> -. ps ) $.
    xchbinxr.2 $e |- ( ch <-> ps ) $.
    $( Replacement of a subexpression by an equivalent one.  (Contributed by
       Wolf Lammen, 27-Sep-2014.) $)
    xchbinxr $p |- ( ph <-> -. ch ) $=
      ( bicomi xchbinx ) ABCDCBEFG $.
  $}

  ${
    imbi2i.1 $e |- ( ph <-> ps ) $.
    $( Introduce an antecedent to both sides of a logical equivalence.  This
       and the next three rules are useful for building up wff's around a
       definition, in order to make use of the definition.  (Contributed by NM,
       3-Jan-1993.)  (Proof shortened by Wolf Lammen, 6-Feb-2013.) $)
    imbi2i $p |- ( ( ch -> ph ) <-> ( ch -> ps ) ) $=
      ( wb a1i pm5.74i ) CABABECDFG $.
  $}

  ${
    bibi2i.1 $e |- ( ph <-> ps ) $.
    $( Inference adding a biconditional to the left in an equivalence.
       (Contributed by NM, 26-May-1993.)  (Proof shortened by Andrew Salmon,
       7-May-2011.)  (Proof shortened by Wolf Lammen, 16-May-2013.) $)
    bibi2i $p |- ( ( ch <-> ph ) <-> ( ch <-> ps ) ) $=
      ( wb id bitrdi bitr4di impbii ) CAEZCBEZJCABJFDGKCBAKFDHI $.

    $( Inference adding a biconditional to the right in an equivalence.
       (Contributed by NM, 26-May-1993.) $)
    bibi1i $p |- ( ( ph <-> ch ) <-> ( ps <-> ch ) ) $=
      ( wb bicom bibi2i 3bitri ) ACECAECBEBCEACFABCDGCBFH $.

    ${
      bibi12i.2 $e |- ( ch <-> th ) $.
      $( The equivalence of two equivalences.  (Contributed by NM,
         26-May-1993.) $)
      bibi12i $p |- ( ( ph <-> ch ) <-> ( ps <-> th ) ) $=
        ( wb bibi2i bibi1i bitri ) ACGADGBDGCDAFHABDEIJ $.
    $}
  $}

  ${
    imbid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduction adding an antecedent to both sides of a logical equivalence.
       (Contributed by NM, 11-May-1993.) $)
    imbi2d $p |- ( ph -> ( ( th -> ps ) <-> ( th -> ch ) ) ) $=
      ( wb a1d pm5.74d ) ADBCABCFDEGH $.

    $( Deduction adding a consequent to both sides of a logical equivalence.
       (Contributed by NM, 11-May-1993.)  (Proof shortened by Wolf Lammen,
       17-Sep-2013.) $)
    imbi1d $p |- ( ph -> ( ( ps -> th ) <-> ( ch -> th ) ) ) $=
      ( wi biimprd imim1d biimpd impbid ) ABDFCDFACBDABCEGHABCDABCEIHJ $.

    $( Deduction adding a biconditional to the left in an equivalence.
       (Contributed by NM, 11-May-1993.)  (Proof shortened by Wolf Lammen,
       19-May-2013.) $)
    bibi2d $p |- ( ph -> ( ( th <-> ps ) <-> ( th <-> ch ) ) ) $=
      ( wb wi pm5.74i bibi2i pm5.74 3bitr4i pm5.74ri ) ADBFZDCFZADGZABGZFOACGZF
      AMGANGPQOABCEHIADBJADCJKL $.

    $( Deduction adding a biconditional to the right in an equivalence.
       (Contributed by NM, 11-May-1993.) $)
    bibi1d $p |- ( ph -> ( ( ps <-> th ) <-> ( ch <-> th ) ) ) $=
      ( wb bibi2d bicom 3bitr4g ) ADBFDCFBDFCDFABCDEGBDHCDHI $.
  $}

  ${
    imbi12d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    imbi12d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Deduction joining two equivalences to form equivalence of implications.
       (Contributed by NM, 16-May-1993.) $)
    imbi12d $p |- ( ph -> ( ( ps -> th ) <-> ( ch -> ta ) ) ) $=
      ( wi imbi1d imbi2d bitrd ) ABDHCDHCEHABCDFIADECGJK $.

    $( Deduction joining two equivalences to form equivalence of
       biconditionals.  (Contributed by NM, 26-May-1993.) $)
    bibi12d $p |- ( ph -> ( ( ps <-> th ) <-> ( ch <-> ta ) ) ) $=
      ( wb bibi1d bibi2d bitrd ) ABDHCDHCEHABCDFIADECGJK $.
  $}

  $( Closed form of ~ imbi12i .  Was automatically derived from its "Virtual
     Deduction" version and the Metamath program "MM-PA> MINIMIZE__WITH *"
     command.  (Contributed by Alan Sare, 18-Mar-2012.) $)
  imbi12 $p |- ( ( ph <-> ps ) ->
                    ( ( ch <-> th ) -> ( ( ph -> ch ) <-> ( ps -> th ) ) ) ) $=
    ( wb wi wn simplim simprim imbi12d expi ) ABEZCDEZACFBDFELMGZFGABCDLNHLMIJK
    $.

  $( Theorem *4.84 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.) $)
  imbi1 $p |- ( ( ph <-> ps ) -> ( ( ph -> ch ) <-> ( ps -> ch ) ) ) $=
    ( wb id imbi1d ) ABDZABCGEF $.

  $( Theorem *4.85 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 19-May-2013.) $)
  imbi2 $p |- ( ( ph <-> ps ) -> ( ( ch -> ph ) <-> ( ch -> ps ) ) ) $=
    ( wb id imbi2d ) ABDZABCGEF $.

  ${
    imbi1i.1 $e |- ( ph <-> ps ) $.
    $( Introduce a consequent to both sides of a logical equivalence.
       (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf Lammen,
       17-Sep-2013.) $)
    imbi1i $p |- ( ( ph -> ch ) <-> ( ps -> ch ) ) $=
      ( wb wi imbi1 ax-mp ) ABEACFBCFEDABCGH $.
  $}

  ${
    imbi12i.1 $e |- ( ph <-> ps ) $.
    imbi12i.2 $e |- ( ch <-> th ) $.
    $( Join two logical equivalences to form equivalence of implications.
       (Contributed by NM, 1-Aug-1993.) $)
    imbi12i $p |- ( ( ph -> ch ) <-> ( ps -> th ) ) $=
      ( wb wi imbi12 mp2 ) ABGCDGACHBDHGEFABCDIJ $.

    $( Theorem imbi12i is the congruence law for implication. $)
    $( $j congruence 'imbi12i'; $)
  $}

  $( Theorem *4.86 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.) $)
  bibi1 $p |- ( ( ph <-> ps ) -> ( ( ph <-> ch ) <-> ( ps <-> ch ) ) ) $=
    ( wb id bibi1d ) ABDZABCGEF $.

  $( Closed nested implication form of ~ bitr3i .  Derived automatically from
     ~ bitr3VD .  (Contributed by Alan Sare, 31-Dec-2011.) $)
  bitr3 $p |- ( ( ph <-> ps ) -> ( ( ph <-> ch ) -> ( ps <-> ch ) ) ) $=
    ( wb bibi1 biimpd ) ABDACDBCDABCEF $.

  $( Contraposition.  Theorem *4.12 of [WhiteheadRussell] p. 117.  (Contributed
     by NM, 15-Apr-1995.)  (Proof shortened by Wolf Lammen, 3-Jan-2013.) $)
  con2bi $p |- ( ( ph <-> -. ps ) <-> ( ps <-> -. ph ) ) $=
    ( wn wb notbi notnotb bibi2i bicom 3bitr2i ) ABCZDACZJCZDKBDBKDAJEBLKBFGKBH
    I $.

  ${
    con2bid.1 $e |- ( ph -> ( ps <-> -. ch ) ) $.
    $( A contraposition deduction.  (Contributed by NM, 15-Apr-1995.) $)
    con2bid $p |- ( ph -> ( ch <-> -. ps ) ) $=
      ( wn wb con2bi sylibr ) ABCEFCBEFDCBGH $.
  $}

  ${
    con1bid.1 $e |- ( ph -> ( -. ps <-> ch ) ) $.
    $( A contraposition deduction.  (Contributed by NM, 9-Oct-1999.) $)
    con1bid $p |- ( ph -> ( -. ch <-> ps ) ) $=
      ( wn bicomd con2bid ) ABCEACBABECDFGF $.
  $}

  ${
    con1bii.1 $e |- ( -. ph <-> ps ) $.
    $( A contraposition inference.  (Contributed by NM, 12-Mar-1993.)  (Proof
       shortened by Wolf Lammen, 13-Oct-2012.) $)
    con1bii $p |- ( -. ps <-> ph ) $=
      ( wn notnotb xchbinx bicomi ) ABDAADBAECFG $.
  $}

  ${
    con2bii.1 $e |- ( ph <-> -. ps ) $.
    $( A contraposition inference.  (Contributed by NM, 12-Mar-1993.) $)
    con2bii $p |- ( ps <-> -. ph ) $=
      ( wn notnotb xchbinxr ) BBDABECF $.
  $}

  $( Contraposition.  Bidirectional version of ~ con1 .  (Contributed by NM,
     3-Jan-1993.) $)
  con1b $p |- ( ( -. ph -> ps ) <-> ( -. ps -> ph ) ) $=
    ( wn wi con1 impbii ) ACBDBCADABEBAEF $.

  $( Contraposition.  Bidirectional version of ~ con2 .  (Contributed by NM,
     12-Mar-1993.) $)
  con2b $p |- ( ( ph -> -. ps ) <-> ( ps -> -. ph ) ) $=
    ( wn wi con2 impbii ) ABCDBACDABEBAEF $.

  $( A wff is equivalent to itself with true antecedent.  (Contributed by NM,
     28-Jan-1996.) $)
  biimt $p |- ( ph -> ( ps <-> ( ph -> ps ) ) ) $=
    ( wi ax-1 pm2.27 impbid2 ) ABABCBADABEF $.

  $( Theorem *5.5 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.5 $p |- ( ph -> ( ( ph -> ps ) <-> ps ) ) $=
    ( wi biimt bicomd ) ABABCABDE $.

  ${
    a1bi.1 $e |- ph $.
    $( Inference introducing a theorem as an antecedent.  (Contributed by NM,
       5-Aug-1993.)  (Proof shortened by Wolf Lammen, 11-Nov-2012.) $)
    a1bi $p |- ( ps <-> ( ph -> ps ) ) $=
      ( wi wb biimt ax-mp ) ABABDECABFG $.
  $}

  ${
    mt2bi.1 $e |- ph $.
    $( A false consequent falsifies an antecedent.  (Contributed by NM,
       19-Aug-1993.)  (Proof shortened by Wolf Lammen, 12-Nov-2012.) $)
    mt2bi $p |- ( -. ps <-> ( ps -> -. ph ) ) $=
      ( wn wi a1bi con2b bitri ) BDZAIEBADEAICFABGH $.
  $}

  $( Modus-tollens-like theorem.  (Contributed by NM, 7-Apr-2001.)  (Proof
     shortened by Wolf Lammen, 12-Nov-2012.) $)
  mtt $p |- ( -. ph -> ( -. ps <-> ( ps -> ph ) ) ) $=
    ( wn wi biimt con34b bitr4di ) ACZBCZHIDBADHIEBAFG $.

  $( If a proposition is false, then implying it is equivalent to being false.
     One of four theorems that can be used to simplify an implication
     ` ( ph -> ps ) ` , the other ones being ~ ax-1 (true consequent), ~ pm2.21
     (false antecedent), ~ pm5.5 (true antecedent).  (Contributed by Mario
     Carneiro, 26-Apr-2019.)  (Proof shortened by Wolf Lammen, 26-May-2019.) $)
  imnot $p |- ( -. ps -> ( ( ph -> ps ) <-> -. ph ) ) $=
    ( wn wi mtt bicomd ) BCACABDBAEF $.

  $( Theorem *5.501 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.501 $p |- ( ph -> ( ps <-> ( ph <-> ps ) ) ) $=
    ( wb pm5.1im biimp com12 impbid ) ABABCZABDHABABEFG $.

  $( Implication in terms of implication and biconditional.  (Contributed by
     NM, 31-Mar-1994.)  (Proof shortened by Wolf Lammen, 24-Jan-2013.) $)
  ibib $p |- ( ( ph -> ps ) <-> ( ph -> ( ph <-> ps ) ) ) $=
    ( wb pm5.501 pm5.74i ) ABABCABDE $.

  $( Implication in terms of implication and biconditional.  (Contributed by
     NM, 29-Apr-2005.)  (Proof shortened by Wolf Lammen, 21-Dec-2013.) $)
  ibibr $p |- ( ( ph -> ps ) <-> ( ph -> ( ps <-> ph ) ) ) $=
    ( wb pm5.501 bicom bitrdi pm5.74i ) ABBACZABABCHABDABEFG $.

  ${
    tbt.1 $e |- ph $.
    $( A wff is equivalent to its equivalence with a truth.  (Contributed by
       NM, 18-Aug-1993.)  (Proof shortened by Andrew Salmon, 13-May-2011.) $)
    tbt $p |- ( ps <-> ( ps <-> ph ) ) $=
      ( wb ibibr pm5.74ri ax-mp ) ABBADZDCABHABEFG $.
  $}

  $( The negation of a wff is equivalent to the wff's equivalence to falsehood.
     (Contributed by Juha Arpiainen, 19-Jan-2006.)  (Proof shortened by Wolf
     Lammen, 28-Jan-2013.) $)
  nbn2 $p |- ( -. ph -> ( -. ps <-> ( ph <-> ps ) ) ) $=
    ( wn wb pm5.501 notbi bitr4di ) ACZBCZHIDABDHIEABFG $.

  $( Transfer negation via an equivalence.  (Contributed by NM, 3-Oct-2007.)
     (Proof shortened by Wolf Lammen, 28-Jan-2013.) $)
  bibif $p |- ( -. ps -> ( ( ph <-> ps ) <-> -. ph ) ) $=
    ( wn wb nbn2 bicom bitr2di ) BCACBADABDBAEBAFG $.

  ${
    nbn.1 $e |- -. ph $.
    $( The negation of a wff is equivalent to the wff's equivalence to
       falsehood.  (Contributed by NM, 21-Jun-1993.)  (Proof shortened by Wolf
       Lammen, 3-Oct-2013.) $)
    nbn $p |- ( -. ps <-> ( ps <-> ph ) ) $=
      ( wb wn bibif ax-mp bicomi ) BADZBEZAEIJDCBAFGH $.
  $}

  ${
    nbn3.1 $e |- ph $.
    $( Transfer falsehood via equivalence.  (Contributed by NM,
       11-Sep-2006.) $)
    nbn3 $p |- ( -. ps <-> ( ps <-> -. ph ) ) $=
      ( wn notnoti nbn ) ADBACEF $.
  $}

  $( Two propositions are equivalent if they are both false.  Closed form of
     ~ 2false .  Equivalent to a ~ biimpr -like version of the xor-connective.
     (Contributed by Wolf Lammen, 13-May-2013.) $)
  pm5.21im $p |- ( -. ph -> ( -. ps -> ( ph <-> ps ) ) ) $=
    ( wn wb nbn2 biimpd ) ACBCABDABEF $.

  ${
    2false.1 $e |- -. ph $.
    2false.2 $e |- -. ps $.
    $( Two falsehoods are equivalent.  (Contributed by NM, 4-Apr-2005.)  (Proof
       shortened by Wolf Lammen, 19-May-2013.) $)
    2false $p |- ( ph <-> ps ) $=
      ( wn 2th con4bii ) ABAEBECDFG $.
  $}

  ${
    2falsed.1 $e |- ( ph -> -. ps ) $.
    2falsed.2 $e |- ( ph -> -. ch ) $.
    $( Two falsehoods are equivalent (deduction form).  (Contributed by NM,
       11-Oct-2013.)  (Proof shortened by Wolf Lammen, 11-Apr-2024.) $)
    2falsed $p |- ( ph -> ( ps <-> ch ) ) $=
      ( wn 2thd con4bid ) ABCABFCFDEGH $.
  $}

  ${
    pm5.21ni.1 $e |- ( ph -> ps ) $.
    pm5.21ni.2 $e |- ( ch -> ps ) $.
    $( Two propositions implying a false one are equivalent.  (Contributed by
       NM, 16-Feb-1996.)  (Proof shortened by Wolf Lammen, 19-May-2013.) $)
    pm5.21ni $p |- ( -. ps -> ( ph <-> ch ) ) $=
      ( wn con3i 2falsed ) BFACABDGCBEGH $.

    ${
      pm5.21nii.3 $e |- ( ps -> ( ph <-> ch ) ) $.
      $( Eliminate an antecedent implied by each side of a biconditional.
         (Contributed by NM, 21-May-1999.) $)
      pm5.21nii $p |- ( ph <-> ch ) $=
        ( wb pm5.21ni pm2.61i ) BACGFABCDEHI $.
    $}
  $}

  ${
    pm5.21ndd.1 $e |- ( ph -> ( ch -> ps ) ) $.
    pm5.21ndd.2 $e |- ( ph -> ( th -> ps ) ) $.
    pm5.21ndd.3 $e |- ( ph -> ( ps -> ( ch <-> th ) ) ) $.
    $( Eliminate an antecedent implied by each side of a biconditional,
       deduction version.  (Contributed by Paul Chapman, 21-Nov-2012.)  (Proof
       shortened by Wolf Lammen, 6-Oct-2013.) $)
    pm5.21ndd $p |- ( ph -> ( ch <-> th ) ) $=
      ( wb wn con3d pm5.21im syl6c pm2.61d ) ABCDHZGABICIDINACBEJADBFJCDKLM $.
  $}

  ${
    bija.1 $e |- ( ph -> ( ps -> ch ) ) $.
    bija.2 $e |- ( -. ph -> ( -. ps -> ch ) ) $.
    $( Combine antecedents into a single biconditional.  This inference,
       reminiscent of ~ ja , is reversible:  The hypotheses can be deduced from
       the conclusion alone (see ~ pm5.1im and ~ pm5.21im ).  (Contributed by
       Wolf Lammen, 13-May-2013.) $)
    bija $p |- ( ( ph <-> ps ) -> ch ) $=
      ( wb biimpr syli wn biimp con3d pm2.61d ) ABFZBCBMACABGDHBIMAICMABABJKEHL
      $.
  $}

  $( Theorem *5.18 of [WhiteheadRussell] p. 124.  This theorem says that
     logical equivalence is the same as negated "exclusive or".  (Contributed
     by NM, 28-Jun-2002.)  (Proof shortened by Andrew Salmon, 20-Jun-2011.)
     (Proof shortened by Wolf Lammen, 15-Oct-2013.) $)
  pm5.18 $p |- ( ( ph <-> ps ) <-> -. ( ph <-> -. ps ) ) $=
    ( wb wn pm5.501 con1bid bitr2d nbn2 pm2.61i ) AABCZABDZCZDZCAMBJABLAKEFABEG
    ADZMKJNKLAKHFABHGI $.

  $( Two ways to express "exclusive or".  (Contributed by NM, 1-Jan-2006.) $)
  xor3 $p |- ( -. ( ph <-> ps ) <-> ( ph <-> -. ps ) ) $=
    ( wn wb pm5.18 con2bii bicomi ) ABCDZABDZCIHABEFG $.

  $( Move negation outside of biconditional.  Compare Theorem *5.18 of
     [WhiteheadRussell] p. 124.  (Contributed by NM, 27-Jun-2002.)  (Proof
     shortened by Wolf Lammen, 20-Sep-2013.)  (Proof shortened by Umit Teoman
     Dogan, 10-Jun-2026.) $)
  nbbn $p |- ( ( -. ph <-> ps ) <-> -. ( ph <-> ps ) ) $=
    ( wn wb pm5.18 notbi xchbinxr ) ACBDACBCDABDACBEABFG $.

  $( Obsolete version of ~ nbbn as of 10-Jun-2026.  (Contributed by NM,
     27-Jun-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  nbbnOLD $p |- ( ( -. ph <-> ps ) <-> -. ( ph <-> ps ) ) $=
    ( wb wn xor3 con2bi bicom 3bitrri ) ABCDABDCBADZCIBCABEABFBIGH $.

  $( Associative law for the biconditional.  An axiom of system DS in Vladimir
     Lifschitz, "On calculational proofs", Annals of Pure and Applied Logic,
     113:207-224, 2002,
     ~ http://www.cs.utexas.edu/users/ai-lab/pub-view.php?PubID=26805 .
     Interestingly, this law was not included in _Principia Mathematica_ but
     was apparently first noted by Jan Lukasiewicz circa 1923.  (Contributed by
     NM, 8-Jan-2005.)  (Proof shortened by Juha Arpiainen, 19-Jan-2006.)
     (Proof shortened by Wolf Lammen, 21-Sep-2013.) $)
  biass $p |- ( ( ( ph <-> ps ) <-> ch ) <-> ( ph <-> ( ps <-> ch ) ) ) $=
    ( wb pm5.501 bibi1d bitr3d wn nbbn nbn2 bitr3id pm2.61i ) AABDZCDZABCDZDZDA
    ONPABMCABEFAOEGAHZOHZNPRBHZCDQNBCIQSMCABJFKAOJGL $.

  $( Rotation of the arguments of the nested implication
     ` ( . <-> ( . <-> . ) ) ` (a general phenomenon for a commutative
     associative binary operation, see e.g., ~ inrot ) .  (Contributed by BJ,
     10-Aug-2026.) $)
  birot $p |- ( ( ph <-> ( ps <-> ch ) ) <-> ( ps <-> ( ch <-> ph ) ) ) $=
    ( wb bicom biass bitri ) ABCDZDHADBCADDAHEBCAFG $.

  $( Lukasiewicz's shortest axiom for equivalential calculus.  Storrs McCall,
     ed., _Polish Logic 1920-1939_ (Oxford, 1967), p. 96.  (Contributed by NM,
     10-Jan-2005.) $)
  biluk $p |- ( ( ph <-> ps ) <-> ( ( ch <-> ps ) <-> ( ph <-> ch ) ) ) $=
    ( wb bicom bibi1i biass bitri mpbi bitr4i ) ABDZCBACDZDZDZCBDLDKCDZMDKNDOBA
    DZCDMKPCABEFBACGHKCMGICBLGJ $.

  $( Theorem *5.19 of [WhiteheadRussell] p. 124.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.19 $p |- -. ( ph <-> -. ph ) $=
    ( wb wn biid pm5.18 mpbi ) AABAACBCADAAEF $.

  $( Logical equivalence of commuted antecedents.  Part of Theorem *4.87 of
     [WhiteheadRussell] p. 122.  (Contributed by NM, 11-May-1993.) $)
  bi2.04 $p |- ( ( ph -> ( ps -> ch ) ) <-> ( ps -> ( ph -> ch ) ) ) $=
    ( wi pm2.04 impbii ) ABCDDBACDDABCEBACEF $.

  $( Antecedent absorption implication.  Theorem *5.4 of [WhiteheadRussell]
     p. 125.  (Contributed by NM, 5-Aug-1993.) $)
  pm5.4 $p |- ( ( ph -> ( ph -> ps ) ) <-> ( ph -> ps ) ) $=
    ( wi pm5.5 pm5.74i ) AABCBABDE $.

  $( Distributive law for implication.  Compare Theorem *5.41 of
     [WhiteheadRussell] p. 125.  (Contributed by NM, 5-Aug-1993.) $)
  imdi $p |- ( ( ph -> ( ps -> ch ) ) <->
               ( ( ph -> ps ) -> ( ph -> ch ) ) ) $=
    ( wi ax-2 pm2.86 impbii ) ABCDDABDACDDABCEABCFG $.

  $( Theorem *5.41 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 12-Oct-2012.) $)
  pm5.41 $p |- ( ( ( ph -> ps ) -> ( ph -> ch ) ) <->
                ( ph -> ( ps -> ch ) ) ) $=
    ( wi imdi bicomi ) ABCDDABDACDDABCEF $.

  $( The antecedent of one side of a biconditional can be moved out of the
     biconditional to become the antecedent of the remaining biconditional.
     (Contributed by BJ, 1-Jan-2025.)  (Proof shortened by Wolf Lammen,
     5-Jan-2025.)  (Proof shortened by Garrett Katz, 15-Jun-2026.) $)
  imbibi $p |- ( ( ( ph -> ps ) <-> ch ) -> ( ph -> ( ps <-> ch ) ) ) $=
    ( wi wb bitr3 pm5.5 syl11 ) ABDZBEICEBCEAIBCFABGH $.

  $( Obsolete version of ~ imbibi as of 15-Jun-2026.  The antecedent of one
     side of a biconditional can be moved out of the biconditional to become
     the antecedent of the remaining biconditional.  (Contributed by BJ,
     1-Jan-2025.)  (Proof shortened by Wolf Lammen, 5-Jan-2025.)
     (New usage is discouraged.)  (Proof modification is discouraged.) $)
  imbibiOLD $p |- ( ( ( ph -> ps ) <-> ch ) -> ( ph -> ( ps <-> ch ) ) ) $=
    ( wi wb pm5.4 imbi2 bitr3id pm5.74rd ) ABDZCEZABCJAJDKACDABFJCAGHI $.

  $( Theorem *4.8 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.8 $p |- ( ( ph -> -. ph ) <-> -. ph ) $=
    ( wn wi pm2.01 ax-1 impbii ) AABZCGADGAEF $.

  $( A formula is equivalent to its negation implying it.  Theorem *4.81 of
     [WhiteheadRussell] p. 122.  Note that the second step, using ~ pm2.24 ,
     could also use ~ ax-1 .  (Contributed by NM, 3-Jan-2005.) $)
  pm4.81 $p |- ( ( -. ph -> ph ) <-> ph ) $=
    ( wn wi pm2.18 pm2.24 impbii ) ABACAADAAEF $.

  $( Simplify an implication between two implications when the antecedent of
     the first is a consequence of the antecedent of the second.  The reverse
     form is useful in producing the successor step in induction proofs.
     (Contributed by Paul Chapman, 22-Jun-2011.)  (Proof shortened by Wolf
     Lammen, 14-Sep-2013.) $)
  imim21b $p |- ( ( ps -> ph ) ->
           ( ( ( ph -> ch ) -> ( ps -> th ) ) <-> ( ps -> ( ch -> th ) ) ) ) $=
    ( wi bi2.04 wb pm5.5 imbi1d imim2i pm5.74d bitrid ) ACEZBDEEBMDEZEBAEZBCDEZ
    EMBDFOBNPANPGBAMCDACHIJKL $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical conjunction
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  This section defines conjunction of two formulas, denoted by infix " ` /\ ` "
  and read "and".  It is defined in terms of implication and negation, which is
  possible in classical logic (but not in intuitionistic logic: see iset.mm).

  After the definition, we briefly introduce conversion of simple expressions
  to and from conjunction.  Two simple operations called importation ( ~ imp )
  and exportation ( ~ ex ) follow.  In the propositions-as-types
  interpretation, they correspond to uncurrying and currying respectively. They
  are foundational for this section.  Most of the theorems proved here trace
  back to them, mostly indirectly, in a layered fashion, where more complex
  expressions are built from simpler ones.  Here are some of these successive
  layers:
  importation and exportation,
  commutativity and associativity laws,
  adding antecedents and simplifying,
  conjunction of consequents,
  syllogisms,
  etc.

  As indicated in the "note on definitions" in the section comment for logical
  equivalence, some theorems containing only implication, negation and
  conjunction are placed in the section after disjunction since theirs proofs
  use disjunction (although this is not required since definitions are
  conservative, see said section comment).

$)

  $( Declare connective for conjunction ("and"). $)
  $c /\ $.  $( Wedge (read:  "and") $)

  $( Extend wff definition to include conjunction ("and"). $)
  wa $a wff ( ph /\ ps ) $.

  $( Define conjunction (logical "and").  Definition of [Margaris] p. 49.  When
     both the left and right operand are true, the result is true; when either
     is false, the result is false.  For example, it is true that
     ` ( 2 = 2 /\ 3 = 3 ) ` .  After we define the constant true ` T. `
     ( ~ df-tru ) and the constant false ` F. ` ( ~ df-fal ), we will be able
     to prove these truth table values: ` ( ( T. /\ T. ) <-> T. ) `
     ( ~ truantru ), ` ( ( T. /\ F. ) <-> F. ) ` ( ~ truanfal ),
     ` ( ( F. /\ T. ) <-> F. ) ` ( ~ falantru ), and
     ` ( ( F. /\ F. ) <-> F. ) ` ( ~ falanfal ).

     This is our first use of the biconditional connective in a definition; we
     use the biconditional connective in place of the traditional "<=def=>",
     which means the same thing, except that we can manipulate the
     biconditional connective directly in proofs rather than having to rely on
     an informal definition substitution rule.  Note that if we mechanically
     substitute ` -. ( ph -> -. ps ) ` for ` ( ph /\ ps ) ` , we end up with an
     instance of previously proved theorem ~ biid .  This is the justification
     for the definition, along with the fact that it introduces a new symbol
     ` /\ ` .  Contrast with ` \/ ` ( ~ df-or ), ` -> ` ( ~ wi ), ` -/\ `
     ( ~ df-nan ), and ` \/_ ` ( ~ df-xor ).  (Contributed by NM,
     5-Jan-1993.) $)
  df-an $a |- ( ( ph /\ ps ) <-> -. ( ph -> -. ps ) ) $.

  $( Theorem *4.63 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.63 $p |- ( -. ( ph -> -. ps ) <-> ( ph /\ ps ) ) $=
    ( wa wn wi df-an bicomi ) ABCABDEDABFG $.

  $( Theorem *4.67 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.67 $p |- ( -. ( -. ph -> -. ps ) <-> ( -. ph /\ ps ) ) $=
    ( wn pm4.63 ) ACBD $.

  $( Express an implication in terms of a negated conjunction.  (Contributed by
     NM, 9-Apr-1994.) $)
  imnan $p |- ( ( ph -> -. ps ) <-> -. ( ph /\ ps ) ) $=
    ( wa wn wi df-an con2bii ) ABCABDEABFG $.

  ${
    imnani.1 $e |- -. ( ph /\ ps ) $.
    $( Infer an implication from a negated conjunction.  (Contributed by Mario
       Carneiro, 28-Sep-2015.) $)
    imnani $p |- ( ph -> -. ps ) $=
      ( wn wi wa imnan mpbir ) ABDEABFDCABGH $.
  $}

  $( Implication in terms of conjunction and negation.  Theorem 3.4(27) of
     [Stoll] p. 176.  (Contributed by NM, 12-Mar-1993.)  (Proof shortened by
     Wolf Lammen, 30-Oct-2012.) $)
  iman $p |- ( ( ph -> ps ) <-> -. ( ph /\ -. ps ) ) $=
    ( wi wn wa notnotb imbi2i imnan bitri ) ABCABDZDZCAJEDBKABFGAJHI $.

  $( Law of noncontradiction.  Theorem *3.24 of [WhiteheadRussell] p. 111 (who
     call it the "law of contradiction").  (Contributed by NM, 16-Sep-1993.)
     (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
  pm3.24 $p |- -. ( ph /\ -. ph ) $=
    ( wi wn wa id iman mpbi ) AABAACDCAEAAFG $.

  $( Express a conjunction in terms of a negated implication.  (Contributed by
     NM, 2-Aug-1994.) $)
  annim $p |- ( ( ph /\ -. ps ) <-> -. ( ph -> ps ) ) $=
    ( wi wn wa iman con2bii ) ABCABDEABFG $.

  $( Theorem *4.61 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.61 $p |- ( -. ( ph -> ps ) <-> ( ph /\ -. ps ) ) $=
    ( wn wa wi annim bicomi ) ABCDABECABFG $.

  $( Theorem *4.65 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.65 $p |- ( -. ( -. ph -> ps ) <-> ( -. ph /\ -. ps ) ) $=
    ( wn pm4.61 ) ACBD $.

  ${
    imp.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Importation inference.  (Contributed by NM, 3-Jan-1993.)  (Proof
       shortened by Eric Schmidt, 22-Dec-2006.) $)
    imp $p |- ( ( ph /\ ps ) -> ch ) $=
      ( wa wn wi df-an impi sylbi ) ABEABFGFCABHABCDIJ $.

    $( Importation inference with commuted antecedents.  (Contributed by NM,
       25-May-2005.) $)
    impcom $p |- ( ( ps /\ ph ) -> ch ) $=
      ( com12 imp ) BACABCDEF $.
  $}

  ${
    con3dimp.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Variant of ~ con3d with importation.  (Contributed by Jonathan Ben-Naim,
       3-Jun-2011.) $)
    con3dimp $p |- ( ( ph /\ -. ch ) -> -. ps ) $=
      ( wn con3d imp ) ACEBEABCDFG $.
  $}

  ${
    mpnanrd.1 $e |- ( ph -> ps ) $.
    mpnanrd.2 $e |- ( ph -> -. ( ps /\ ch ) ) $.
    $( Eliminate the right side of a negated conjunction in an implication.
       (Contributed by ML, 17-Oct-2020.) $)
    mpnanrd $p |- ( ph -> -. ch ) $=
      ( wn wa wi imnan sylibr mpd ) ABCFZDABCGFBLHEBCIJK $.
  $}

  ${
    impd.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( Importation deduction.  (Contributed by NM, 31-Mar-1994.) $)
    impd $p |- ( ph -> ( ( ps /\ ch ) -> th ) ) $=
      ( wa wi com3l imp com12 ) BCFADBCADGABCDEHIJ $.

    $( Importation deduction with commuted antecedents.  (Contributed by Peter
       Mazsa, 24-Sep-2022.)  (Proof shortened by Wolf Lammen, 22-Oct-2022.) $)
    impcomd $p |- ( ph -> ( ( ch /\ ps ) -> th ) ) $=
      ( com23 impd ) ACBDABCDEFG $.
  $}

  ${
    ex.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Exportation inference.  (This theorem used to be labeled "exp" but was
       changed to "ex" so as not to conflict with the math token "exp", per the
       June 2006 Metamath spec change.)  A translation of natural deduction
       rule ` -> ` I ( ` -> ` introduction), see ~ natded .  (Contributed by
       NM, 3-Jan-1993.)  (Proof shortened by Eric Schmidt, 22-Dec-2006.) $)
    ex $p |- ( ph -> ( ps -> ch ) ) $=
      ( wn wi wa df-an sylbir expi ) ABCABEFEABGCABHDIJ $.

    $( Exportation inference with commuted antecedents.  (Contributed by NM,
       25-May-2005.) $)
    expcom $p |- ( ps -> ( ph -> ch ) ) $=
      ( ex com12 ) ABCABCDEF $.
  $}

  ${
    expd.1 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( Commuted form of ~ expd .  (Contributed by Alan Sare, 18-Mar-2012.)
       Shorten ~ expd .  (Revised by Wolf Lammen, 28-Jul-2022.) $)
    expdcom $p |- ( ps -> ( ch -> ( ph -> th ) ) ) $=
      ( wi wa com12 ex ) BCADFABCGDEHI $.

    $( Exportation deduction.  (Contributed by NM, 20-Aug-1993.)  (Proof
       shortened by Wolf Lammen, 28-Jul-2022.) $)
    expd $p |- ( ph -> ( ps -> ( ch -> th ) ) ) $=
      ( expdcom com3r ) BCADABCDEFG $.
  $}

  ${
    expcomd.1 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( Deduction form of ~ expcom .  (Contributed by Alan Sare,
       22-Jul-2012.) $)
    expcomd $p |- ( ph -> ( ch -> ( ps -> th ) ) ) $=
      ( expd com23 ) ABCDABCDEFG $.
  $}

  ${
    imp31.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp31 $p |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $=
      ( wa wi imp ) ABFCDABCDGEHH $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp32 $p |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $=
      ( wa impd imp ) ABCFDABCDEGH $.
  $}

  ${
    exp31.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp31 $p |- ( ph -> ( ps -> ( ch -> th ) ) ) $=
      ( wi wa ex ) ABCDFABGCDEHH $.
  $}

  ${
    exp32.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp32 $p |- ( ph -> ( ps -> ( ch -> th ) ) ) $=
      ( wa ex expd ) ABCDABCFDEGH $.
  $}

  ${
    imp4.1 $e |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $.
    $( An importation inference.  (Contributed by NM, 26-Apr-1994.)  Shorten
       ~ imp4a .  (Revised by Wolf Lammen, 19-Jul-2021.) $)
    imp4b $p |- ( ( ph /\ ps ) -> ( ( ch /\ th ) -> ta ) ) $=
      ( wa wi imp impd ) ABGCDEABCDEHHFIJ $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 19-Jul-2021.) $)
    imp4a $p |- ( ph -> ( ps -> ( ( ch /\ th ) -> ta ) ) ) $=
      ( wa wi imp4b ex ) ABCDGEHABCDEFIJ $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp4c $p |- ( ph -> ( ( ( ps /\ ch ) /\ th ) -> ta ) ) $=
      ( wa wi impd ) ABCGDEABCDEHFII $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp4d $p |- ( ph -> ( ( ps /\ ( ch /\ th ) ) -> ta ) ) $=
      ( wa imp4a impd ) ABCDGEABCDEFHI $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp41 $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $=
      ( wa wi imp imp31 ) ABGCDEABCDEHHFIJ $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp42 $p |- ( ( ( ph /\ ( ps /\ ch ) ) /\ th ) -> ta ) $=
      ( wa wi imp32 imp ) ABCGGDEABCDEHFIJ $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp43 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) -> ta ) $=
      ( wa imp4b imp ) ABGCDGEABCDEFHI $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp44 $p |- ( ( ph /\ ( ( ps /\ ch ) /\ th ) ) -> ta ) $=
      ( wa imp4c imp ) ABCGDGEABCDEFHI $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp45 $p |- ( ( ph /\ ( ps /\ ( ch /\ th ) ) ) -> ta ) $=
      ( wa imp4d imp ) ABCDGGEABCDEFHI $.
  $}

  ${
    exp4b.1 $e |- ( ( ph /\ ps ) -> ( ( ch /\ th ) -> ta ) ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 23-Nov-2012.)  Shorten ~ exp4a .  (Revised by
       Wolf Lammen, 20-Jul-2021.) $)
    exp4b $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      ( wi wa expd ex ) ABCDEGGABHCDEFIJ $.
  $}

  ${
    exp4a.1 $e |- ( ph -> ( ps -> ( ( ch /\ th ) -> ta ) ) ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 20-Jul-2021.) $)
    exp4a $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      ( wa wi imp exp4b ) ABCDEABCDGEHFIJ $.
  $}

  ${
    exp4c.1 $e |- ( ph -> ( ( ( ps /\ ch ) /\ th ) -> ta ) ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp4c $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      ( wi wa expd ) ABCDEGABCHDEFII $.
  $}

  ${
    exp4d.1 $e |- ( ph -> ( ( ps /\ ( ch /\ th ) ) -> ta ) ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp4d $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      ( wa expd exp4a ) ABCDEABCDGEFHI $.
  $}

  ${
    exp41.1 $e |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp41 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      ( wi wa ex exp31 ) ABCDEGABHCHDEFIJ $.
  $}

  ${
    exp42.1 $e |- ( ( ( ph /\ ( ps /\ ch ) ) /\ th ) -> ta ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp42 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      ( wi wa exp31 expd ) ABCDEGABCHDEFIJ $.
  $}

  ${
    exp43.1 $e |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) -> ta ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp43 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      ( wa ex exp4b ) ABCDEABGCDGEFHI $.
  $}

  ${
    exp44.1 $e |- ( ( ph /\ ( ( ps /\ ch ) /\ th ) ) -> ta ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp44 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      ( wi wa exp32 expd ) ABCDEGABCHDEFIJ $.
  $}

  ${
    exp45.1 $e |- ( ( ph /\ ( ps /\ ( ch /\ th ) ) ) -> ta ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp45 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      ( wa exp32 exp4a ) ABCDEABCDGEFHI $.
  $}

  ${
    imp5.1 $e |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $.
    $( An importation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    imp5d $p |- ( ( ( ph /\ ps ) /\ ch ) -> ( ( th /\ ta ) -> et ) ) $=
      ( wa wi imp31 impd ) ABHCHDEFABCDEFIIGJK $.

    $( An importation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.)
       (Proof shortened by Wolf Lammen, 2-Aug-2022.) $)
    imp5a $p |- ( ph -> ( ps -> ( ch -> ( ( th /\ ta ) -> et ) ) ) ) $=
      ( wa wi imp5d exp31 ) ABCDEHFIABCDEFGJK $.

    $( An importation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    imp5g $p |- ( ( ph /\ ps ) -> ( ( ( ch /\ th ) /\ ta ) -> et ) ) $=
      ( wa wi imp4b impd ) ABHCDHEFABCDEFIGJK $.

    $( An importation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    imp55 $p |- ( ( ( ph /\ ( ps /\ ( ch /\ th ) ) ) /\ ta ) -> et ) $=
      ( wa wi imp4a imp42 ) ABCDHEFABCDEFIGJK $.

    $( An importation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    imp511 $p |- ( ( ph /\ ( ( ps /\ ( ch /\ th ) ) /\ ta ) ) -> et ) $=
      ( wa wi imp4a imp44 ) ABCDHEFABCDEFIGJK $.
  $}

  ${
    exp5c.1 $e |- ( ph -> ( ( ps /\ ch ) -> ( ( th /\ ta ) -> et ) ) ) $.
    $( An exportation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    exp5c $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      ( wi wa exp4a expd ) ABCDEFHHABCIDEFGJK $.
  $}

  ${
    exp5j.1 $e |- ( ph -> ( ( ( ( ps /\ ch ) /\ th ) /\ ta ) -> et ) ) $.
    $( An exportation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    exp5j $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      ( wi wa expd exp4c ) ABCDEFHABCIDIEFGJK $.
  $}

  ${
    exp5l.1 $e |- ( ph -> ( ( ( ps /\ ch ) /\ ( th /\ ta ) ) -> et ) ) $.
    $( An exportation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    exp5l $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      ( wa expd exp5c ) ABCDEFABCHDEHFGIJ $.
  $}

  ${
    exp53.1 $e |- ( ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) /\ ta ) -> et ) $.
    $( An exportation inference.  (Contributed by Jeff Hankins,
       30-Aug-2009.) $)
    exp53 $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      ( wi wa ex exp43 ) ABCDEFHABICDIIEFGJK $.
  $}

  $( Theorem *3.3 (Exp) of [WhiteheadRussell] p. 112.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 24-Mar-2013.) $)
  pm3.3 $p |- ( ( ( ph /\ ps ) -> ch ) -> ( ph -> ( ps -> ch ) ) ) $=
    ( wa wi id expd ) ABDCEZABCHFG $.

  $( Theorem *3.31 (Imp) of [WhiteheadRussell] p. 112.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 24-Mar-2013.) $)
  pm3.31 $p |- ( ( ph -> ( ps -> ch ) ) -> ( ( ph /\ ps ) -> ch ) ) $=
    ( wi id impd ) ABCDDZABCGEF $.

  $( Import-export theorem.  Part of Theorem *4.87 of [WhiteheadRussell]
     p. 122.  (Contributed by NM, 10-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 24-Mar-2013.) $)
  impexp $p |- ( ( ( ph /\ ps ) -> ch ) <-> ( ph -> ( ps -> ch ) ) ) $=
    ( wa wi pm3.3 pm3.31 impbii ) ABDCEABCEEABCFABCGH $.

  ${
    impancom.1 $e |- ( ( ph /\ ps ) -> ( ch -> th ) ) $.
    $( Mixed importation/commutation inference.  (Contributed by NM,
       22-Jun-2013.) $)
    impancom $p |- ( ( ph /\ ch ) -> ( ps -> th ) ) $=
      ( wi ex com23 imp ) ACBDFABCDABCDFEGHI $.
  $}

  ${
    expdimp.1 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( A deduction version of exportation, followed by importation.
       (Contributed by NM, 6-Sep-2008.) $)
    expdimp $p |- ( ( ph /\ ps ) -> ( ch -> th ) ) $=
      ( wi expd imp ) ABCDFABCDEGH $.
  $}

  ${
    expimpd.1 $e |- ( ( ph /\ ps ) -> ( ch -> th ) ) $.
    $( Exportation followed by a deduction version of importation.
       (Contributed by NM, 6-Sep-2008.) $)
    expimpd $p |- ( ph -> ( ( ps /\ ch ) -> th ) ) $=
      ( wi ex impd ) ABCDABCDFEGH $.
  $}

  ${
    impr.1 $e |- ( ( ph /\ ps ) -> ( ch -> th ) ) $.
    $( Import a wff into a right conjunct.  (Contributed by Jeff Hankins,
       30-Aug-2009.) $)
    impr $p |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $=
      ( wi ex imp32 ) ABCDABCDFEGH $.
  $}

  ${
    impl.1 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( Export a wff from a left conjunct.  (Contributed by Mario Carneiro,
       9-Jul-2014.) $)
    impl $p |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $=
      ( expd imp31 ) ABCDABCDEFG $.
  $}

  ${
    expr.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Export a wff from a right conjunct.  (Contributed by Jeff Hankins,
       30-Aug-2009.) $)
    expr $p |- ( ( ph /\ ps ) -> ( ch -> th ) ) $=
      ( wi exp32 imp ) ABCDFABCDEGH $.
  $}

  ${
    expl.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( Export a wff from a left conjunct.  (Contributed by Jeff Hankins,
       28-Aug-2009.) $)
    expl $p |- ( ph -> ( ( ps /\ ch ) -> th ) ) $=
      ( exp31 impd ) ABCDABCDEFG $.
  $}

  ${
    ancoms.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Inference commuting conjunction in antecedent.  (Contributed by NM,
       21-Apr-1994.) $)
    ancoms $p |- ( ( ps /\ ph ) -> ch ) $=
      ( expcom imp ) BACABCDEF $.
  $}

  $( Theorem *3.22 of [WhiteheadRussell] p. 111.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 13-Nov-2012.) $)
  pm3.22 $p |- ( ( ph /\ ps ) -> ( ps /\ ph ) ) $=
    ( wa id ancoms ) BABACZFDE $.

  $( Commutative law for conjunction.  Theorem *4.3 of [WhiteheadRussell]
     p. 118.  (Contributed by NM, 25-Jun-1998.)  (Proof shortened by Wolf
     Lammen, 4-Nov-2012.) $)
  ancom $p |- ( ( ph /\ ps ) <-> ( ps /\ ph ) ) $=
    ( wa pm3.22 impbii ) ABCBACABDBADE $.

  ${
    ancomd.1 $e |- ( ph -> ( ps /\ ch ) ) $.
    $( Commutation of conjuncts in consequent.  (Contributed by Jeff Hankins,
       14-Aug-2009.) $)
    ancomd $p |- ( ph -> ( ch /\ ps ) ) $=
      ( wa ancom sylib ) ABCECBEDBCFG $.
  $}

  ${
    biancomi.1 $e |- ( ph <-> ( ch /\ ps ) ) $.
    $( Commuting conjunction in a biconditional.  (Contributed by Peter Mazsa,
       17-Jun-2018.) $)
    biancomi $p |- ( ph <-> ( ps /\ ch ) ) $=
      ( wa ancom bitr4i ) ACBEBCEDBCFG $.
  $}

  ${
    biancomd.1 $e |- ( ph -> ( ps <-> ( th /\ ch ) ) ) $.
    $( Commuting conjunction in a biconditional, deduction form.  (Contributed
       by Peter Mazsa, 3-Oct-2018.) $)
    biancomd $p |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $=
      ( wa ancom bitrdi ) ABDCFCDFEDCGH $.
  $}

  $( Closed form of ~ ancoms .  (Contributed by Alan Sare, 31-Dec-2011.) $)
  ancomst $p |- ( ( ( ph /\ ps ) -> ch ) <-> ( ( ps /\ ph ) -> ch ) ) $=
    ( wa ancom imbi1i ) ABDBADCABEF $.

  ${
    ancomsd.1 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( Deduction commuting conjunction in antecedent.  (Contributed by NM,
       12-Dec-2004.) $)
    ancomsd $p |- ( ph -> ( ( ch /\ ps ) -> th ) ) $=
      ( expcomd impd ) ACBDABCDEFG $.
  $}

  ${
    anasss.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( Associative law for conjunction applied to antecedent (eliminates
       syllogism).  (Contributed by NM, 15-Nov-2002.) $)
    anasss $p |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $=
      ( exp31 imp32 ) ABCDABCDEFG $.
  $}

  ${
    anassrs.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Associative law for conjunction applied to antecedent (eliminates
       syllogism).  (Contributed by NM, 15-Nov-2002.) $)
    anassrs $p |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $=
      ( exp32 imp31 ) ABCDABCDEFG $.
  $}

  $( Associative law for conjunction.  Theorem *4.32 of [WhiteheadRussell]
     p. 118.  (Contributed by NM, 21-Jun-1993.)  (Proof shortened by Wolf
     Lammen, 24-Nov-2012.) $)
  anass $p |- ( ( ( ph /\ ps ) /\ ch ) <-> ( ph /\ ( ps /\ ch ) ) ) $=
    ( wa id anassrs anasss impbii ) ABDCDZABCDDZABCJJEFABCIIEGH $.

  $( Join antecedents with conjunction ("conjunction introduction").  Theorem
     *3.2 of [WhiteheadRussell] p. 111.  Its associated inference is ~ pm3.2i
     and its associated deduction is ~ jca (and the double deduction is
     ~ jcad ).  See ~ pm3.2im for a version using only implication and
     negation.  (Contributed by NM, 5-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 12-Nov-2012.) $)
  pm3.2 $p |- ( ph -> ( ps -> ( ph /\ ps ) ) ) $=
    ( wa id ex ) ABABCZFDE $.

  ${
    pm3.2i.1 $e |- ph $.
    pm3.2i.2 $e |- ps $.
    $( Infer conjunction of premises.  Inference associated with ~ pm3.2 .  Its
       associated deduction is ~ jca (and the double deduction is ~ jcad ).
       (Contributed by NM, 21-Jun-1993.) $)
    pm3.2i $p |- ( ph /\ ps ) $=
      ( wa pm3.2 mp2 ) ABABECDABFG $.
  $}

  $( Join antecedents with conjunction.  Theorem *3.21 of [WhiteheadRussell]
     p. 111.  (Contributed by NM, 5-Aug-1993.) $)
  pm3.21 $p |- ( ph -> ( ps -> ( ps /\ ph ) ) ) $=
    ( wa id expcom ) BABACZFDE $.

  $( Nested conjunction of antecedents.  (Contributed by NM, 4-Jan-1993.) $)
  pm3.43i $p |- ( ( ph -> ps )
      -> ( ( ph -> ch ) -> ( ph -> ( ps /\ ch ) ) ) ) $=
    ( wa pm3.2 imim3i ) BCBCDABCEF $.

  $( Theorem *3.43 (Comp) of [WhiteheadRussell] p. 113.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.43 $p |- ( ( ( ph -> ps ) /\ ( ph -> ch ) )
      -> ( ph -> ( ps /\ ch ) ) ) $=
    ( wi wa pm3.43i imp ) ABDACDABCEDABCFG $.

  $( A theorem similar to the standard definition of the biconditional.
     Definition of [Margaris] p. 49.  (Contributed by NM, 24-Jan-1993.) $)
  dfbi2 $p |- ( ( ph <-> ps ) <-> ( ( ph -> ps ) /\ ( ps -> ph ) ) ) $=
    ( wb wi wn wa dfbi1 df-an bitr4i ) ABCABDZBADZEDEJKFABGJKHI $.

  $( Definition ~ df-bi rewritten in an abbreviated form to help intuitive
     understanding of that definition.  Note that it is a conjunction of two
     implications; one which asserts properties that follow from the
     biconditional and one which asserts properties that imply the
     biconditional.  (Contributed by NM, 15-Aug-2008.) $)
  dfbi $p |- ( ( ( ph <-> ps ) -> ( ( ph -> ps ) /\ ( ps -> ph ) ) )
        /\ ( ( ( ph -> ps ) /\ ( ps -> ph ) ) -> ( ph <-> ps ) ) ) $=
    ( wb wi wa dfbi2 mpbi ) ABCZABDBADEZCHIDIHDEABFHIFG $.

  ${
    biimpa.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Importation inference from a logical equivalence.  (Contributed by NM,
       3-May-1994.) $)
    biimpa $p |- ( ( ph /\ ps ) -> ch ) $=
      ( biimpd imp ) ABCABCDEF $.

    $( Importation inference from a logical equivalence.  (Contributed by NM,
       3-May-1994.) $)
    biimpar $p |- ( ( ph /\ ch ) -> ps ) $=
      ( biimprd imp ) ACBABCDEF $.

    $( Importation inference from a logical equivalence.  (Contributed by NM,
       3-May-1994.) $)
    biimpac $p |- ( ( ps /\ ph ) -> ch ) $=
      ( biimpcd imp ) BACABCDEF $.

    $( Importation inference from a logical equivalence.  (Contributed by NM,
       3-May-1994.) $)
    biimparc $p |- ( ( ch /\ ph ) -> ps ) $=
      ( biimprcd imp ) CABABCDEF $.
  $}

  ${
    adantr.1 $e |- ( ph -> ps ) $.
    $( Inference adding a conjunct to the right of an antecedent.  (Contributed
       by NM, 30-Aug-1993.) $)
    adantr $p |- ( ( ph /\ ch ) -> ps ) $=
      ( a1d imp ) ACBABCDEF $.
  $}

  ${
    adantl.1 $e |- ( ph -> ps ) $.
    $( Inference adding a conjunct to the left of an antecedent.  (Contributed
       by NM, 30-Aug-1993.)  (Proof shortened by Wolf Lammen, 23-Nov-2012.) $)
    adantl $p |- ( ( ch /\ ph ) -> ps ) $=
      ( adantr ancoms ) ACBABCDEF $.
  $}

  $( Elimination of a conjunct.  Theorem *3.26 (Simp) of [WhiteheadRussell]
     p. 112.  (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 14-Jun-2022.) $)
  simpl $p |- ( ( ph /\ ps ) -> ph ) $=
    ( id adantr ) AABACD $.

  ${
    simpli.1 $e |- ( ph /\ ps ) $.
    $( Inference eliminating a conjunct.  (Contributed by NM, 15-Jun-1994.) $)
    simpli $p |- ph $=
      ( wa simpl ax-mp ) ABDACABEF $.
  $}

  $( Elimination of a conjunct.  Theorem *3.27 (Simp) of [WhiteheadRussell]
     p. 112.  (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 14-Jun-2022.) $)
  simpr $p |- ( ( ph /\ ps ) -> ps ) $=
    ( id adantl ) BBABCD $.

  ${
    simpri.1 $e |- ( ph /\ ps ) $.
    $( Inference eliminating a conjunct.  (Contributed by NM, 15-Jun-1994.) $)
    simpri $p |- ps $=
      ( wa simpr ax-mp ) ABDBCABEF $.
  $}

  ${
    intnan.1 $e |- -. ph $.
    $( Introduction of conjunct inside of a contradiction.  (Contributed by NM,
       16-Sep-1993.) $)
    intnan $p |- -. ( ps /\ ph ) $=
      ( wa simpr mto ) BADACBAEF $.

    $( Introduction of conjunct inside of a contradiction.  (Contributed by NM,
       3-Apr-1995.) $)
    intnanr $p |- -. ( ph /\ ps ) $=
      ( wa simpl mto ) ABDACABEF $.
  $}

  ${
    intnand.1 $e |- ( ph -> -. ps ) $.
    $( Introduction of conjunct inside of a contradiction.  (Contributed by NM,
       10-Jul-2005.) $)
    intnand $p |- ( ph -> -. ( ch /\ ps ) ) $=
      ( wa simpr nsyl ) ABCBEDCBFG $.

    $( Introduction of conjunct inside of a contradiction.  (Contributed by NM,
       10-Jul-2005.) $)
    intnanrd $p |- ( ph -> -. ( ps /\ ch ) ) $=
      ( wa simpl nsyl ) ABBCEDBCFG $.
  $}

  ${
    adantld.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction adding a conjunct to the left of an antecedent.  (Contributed
       by NM, 4-May-1994.)  (Proof shortened by Wolf Lammen, 20-Dec-2012.) $)
    adantld $p |- ( ph -> ( ( th /\ ps ) -> ch ) ) $=
      ( wa simpr syl5 ) DBFBACDBGEH $.
  $}

  ${
    adantrd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction adding a conjunct to the right of an antecedent.  (Contributed
       by NM, 4-May-1994.) $)
    adantrd $p |- ( ph -> ( ( ps /\ th ) -> ch ) ) $=
      ( wa simpl syl5 ) BDFBACBDGEH $.
  $}

  $( Theorem *3.41 of [WhiteheadRussell] p. 113.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.41 $p |- ( ( ph -> ch ) -> ( ( ph /\ ps ) -> ch ) ) $=
    ( wa simpl imim1i ) ABDACABEF $.

  $( Theorem *3.42 of [WhiteheadRussell] p. 113.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.42 $p |- ( ( ps -> ch ) -> ( ( ph /\ ps ) -> ch ) ) $=
    ( wa simpr imim1i ) ABDBCABEF $.

  ${
    simpld.1 $e |- ( ph -> ( ps /\ ch ) ) $.
    $( Deduction eliminating a conjunct.  A translation of natural deduction
       rule ` /\ ` EL ( ` /\ ` elimination left), see ~ natded .  (Contributed
       by NM, 26-May-1993.) $)
    simpld $p |- ( ph -> ps ) $=
      ( wa simpl syl ) ABCEBDBCFG $.
  $}

  ${
    simprd.1 $e |- ( ph -> ( ps /\ ch ) ) $.
    $( Deduction eliminating a conjunct.  (Contributed by NM, 14-May-1993.)  A
       translation of natural deduction rule ` /\ ` ER ( ` /\ ` elimination
       right), see ~ natded .  (Proof shortened by Wolf Lammen, 3-Oct-2013.) $)
    simprd $p |- ( ph -> ch ) $=
      ( ancomd simpld ) ACBABCDEF $.
  $}

  ${
    simplbi.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Deduction eliminating a conjunct.  (Contributed by NM, 27-May-1998.) $)
    simplbi $p |- ( ph -> ps ) $=
      ( wa biimpi simpld ) ABCABCEDFG $.
  $}

  ${
    simprbi.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Deduction eliminating a conjunct.  (Contributed by NM, 27-May-1998.) $)
    simprbi $p |- ( ph -> ch ) $=
      ( wa biimpi simprd ) ABCABCEDFG $.
  $}

  ${
    simplbda.1 $e |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $.
    $( Deduction eliminating a conjunct.  (Contributed by NM, 22-Oct-2007.) $)
    simprbda $p |- ( ( ph /\ ps ) -> ch ) $=
      ( wa biimpa simpld ) ABFCDABCDFEGH $.

    $( Deduction eliminating a conjunct.  (Contributed by NM, 22-Oct-2007.) $)
    simplbda $p |- ( ( ph /\ ps ) -> th ) $=
      ( wa biimpa simprd ) ABFCDABCDFEGH $.
  $}

  ${
    simplbi2.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Deduction eliminating a conjunct.  (Contributed by Alan Sare,
       31-Dec-2011.) $)
    simplbi2 $p |- ( ps -> ( ch -> ph ) ) $=
      ( wa biimpri ex ) BCAABCEDFG $.
  $}

  $( Closed form of ~ simplbi2com .  (Contributed by Alan Sare,
     22-Jul-2012.) $)
  simplbi2comt $p |- ( ( ph <-> ( ps /\ ch ) ) -> ( ch -> ( ps -> ph ) ) ) $=
    ( wa wb biimpr expcomd ) ABCDZEBCAAHFG $.

  ${
    simplbi2com.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( A deduction eliminating a conjunct, similar to ~ simplbi2 .
       (Contributed by Alan Sare, 22-Jul-2012.)  (Proof shortened by Wolf
       Lammen, 10-Nov-2012.) $)
    simplbi2com $p |- ( ch -> ( ps -> ph ) ) $=
      ( simplbi2 com12 ) BCAABCDEF $.
  $}

  ${
    birani.1 $e |- ( ph <-> ps ) $.
    $( Inference adding a conjunct to the left-hand side of a biconditional.
       (Contributed by Matthew House, 22-May-2026.) $)
    birani $p |- ( ( ph /\ ch ) -> ps ) $=
      ( biimpi adantr ) ABCABDEF $.

    $( Inference adding a conjunct to the left-hand side of a biconditional.
       (Contributed by Matthew House, 22-May-2026.) $)
    bilani $p |- ( ( ch /\ ph ) -> ps ) $=
      ( biimpi adantl ) ABCABDEF $.

    $( Inference adding a conjunct to the right-hand side of a biconditional.
       (Contributed by Matthew House, 22-May-2026.) $)
    biranri $p |- ( ( ps /\ ch ) -> ph ) $=
      ( biimpri adantr ) BACABDEF $.

    $( Inference adding a conjunct to the right-hand side of a biconditional.
       (Contributed by Matthew House, 22-May-2026.) $)
    bilanri $p |- ( ( ch /\ ps ) -> ph ) $=
      ( biimpri adantl ) BACABDEF $.
  $}

  ${
    simpl2im.1 $e |- ( ph -> ( ps /\ ch ) ) $.
    simpl2im.2 $e |- ( ch -> th ) $.
    $( Implication from an eliminated conjunct implied by the antecedent.
       (Contributed by BJ/AV, 5-Apr-2021.)  (Proof shortened by Wolf Lammen,
       26-Mar-2022.) $)
    simpl2im $p |- ( ph -> th ) $=
      ( simprd syl ) ACDABCEGFH $.
  $}

  ${
    simplbiim.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    simplbiim.2 $e |- ( ch -> th ) $.
    $( Implication from an eliminated conjunct equivalent to the antecedent.
       (Contributed by Jonathan Ben-Naim, 3-Jun-2011.)  (Proof shortened by
       Wolf Lammen, 26-Mar-2022.) $)
    simplbiim $p |- ( ph -> th ) $=
      ( simprbi syl ) ACDABCEGFH $.
  $}

  ${
    impel.1 $e |- ( ph -> ( ps -> ch ) ) $.
    impel.2 $e |- ( th -> ps ) $.
    $( An inference for implication elimination.  (Contributed by Giovanni
       Mascellani, 23-May-2019.)  (Proof shortened by Wolf Lammen,
       2-Sep-2020.) $)
    impel $p |- ( ( ph /\ th ) -> ch ) $=
      ( syl5 imp ) ADCDBACFEGH $.
  $}

  ${
    mpan9.1 $e |- ( ph -> ps ) $.
    mpan9.2 $e |- ( ch -> ( ps -> th ) ) $.
    $( Modus ponens conjoining dissimilar antecedents.  (Contributed by NM,
       1-Feb-2008.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
    mpan9 $p |- ( ( ph /\ ch ) -> th ) $=
      ( syl5 impcom ) CADABCDEFGH $.
  $}

  ${
    sylan9.1 $e |- ( ph -> ( ps -> ch ) ) $.
    sylan9.2 $e |- ( th -> ( ch -> ta ) ) $.
    $( Nested syllogism inference conjoining dissimilar antecedents.
       (Contributed by NM, 14-May-1993.)  (Proof shortened by Andrew Salmon,
       7-May-2011.) $)
    sylan9 $p |- ( ( ph /\ th ) -> ( ps -> ta ) ) $=
      ( wi syl9 imp ) ADBEHABCDEFGIJ $.
  $}

  ${
    sylan9r.1 $e |- ( ph -> ( ps -> ch ) ) $.
    sylan9r.2 $e |- ( th -> ( ch -> ta ) ) $.
    $( Nested syllogism inference conjoining dissimilar antecedents.
       (Contributed by NM, 14-May-1993.) $)
    sylan9r $p |- ( ( th /\ ph ) -> ( ps -> ta ) ) $=
      ( wi syl9r imp ) DABEHABCDEFGIJ $.
  $}

  ${
    sylan9bb.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    sylan9bb.2 $e |- ( th -> ( ch <-> ta ) ) $.
    $( Nested syllogism inference conjoining dissimilar antecedents.
       (Contributed by NM, 4-Mar-1995.) $)
    sylan9bb $p |- ( ( ph /\ th ) -> ( ps <-> ta ) ) $=
      ( wa wb adantr adantl bitrd ) ADHBCEABCIDFJDCEIAGKL $.
  $}

  ${
    sylan9bbr.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    sylan9bbr.2 $e |- ( th -> ( ch <-> ta ) ) $.
    $( Nested syllogism inference conjoining dissimilar antecedents.
       (Contributed by NM, 4-Mar-1995.) $)
    sylan9bbr $p |- ( ( th /\ ph ) -> ( ps <-> ta ) ) $=
      ( wb sylan9bb ancoms ) ADBEHABCDEFGIJ $.
  $}

  ${
    jca.1 $e |- ( ph -> ps ) $.
    jca.2 $e |- ( ph -> ch ) $.
    $( Deduce conjunction of the consequents of two implications ("join
       consequents with 'and'").  Deduction form of ~ pm3.2 and ~ pm3.2i .  Its
       associated deduction is ~ jcad .  Equivalent to the natural deduction
       rule ` /\ ` I ( ` /\ ` introduction), see ~ natded .  (Contributed by
       NM, 3-Jan-1993.)  (Proof shortened by Wolf Lammen, 25-Oct-2012.) $)
    jca $p |- ( ph -> ( ps /\ ch ) ) $=
      ( wa pm3.2 sylc ) ABCBCFDEBCGH $.
  $}

  ${
    jcad.1 $e |- ( ph -> ( ps -> ch ) ) $.
    jcad.2 $e |- ( ph -> ( ps -> th ) ) $.
    $( Deduction conjoining the consequents of two implications.  Deduction
       form of ~ jca and double deduction form of ~ pm3.2 and ~ pm3.2i .
       (Contributed by NM, 15-Jul-1993.)  (Proof shortened by Wolf Lammen,
       23-Jul-2013.) $)
    jcad $p |- ( ph -> ( ps -> ( ch /\ th ) ) ) $=
      ( wa pm3.2 syl6c ) ABCDCDGEFCDHI $.
  $}

  ${
    jca2.1 $e |- ( ph -> ( ps -> ch ) ) $.
    jca2.2 $e |- ( ps -> th ) $.
    $( Inference conjoining the consequents of two implications.  (Contributed
       by Rodolfo Medina, 12-Oct-2010.) $)
    jca2 $p |- ( ph -> ( ps -> ( ch /\ th ) ) ) $=
      ( wi a1i jcad ) ABCDEBDGAFHI $.
  $}

  ${
    jca31.1 $e |- ( ph -> ps ) $.
    jca31.2 $e |- ( ph -> ch ) $.
    jca31.3 $e |- ( ph -> th ) $.
    $( Join three consequents.  (Contributed by Jeff Hankins, 1-Aug-2009.) $)
    jca31 $p |- ( ph -> ( ( ps /\ ch ) /\ th ) ) $=
      ( wa jca ) ABCHDABCEFIGI $.

    $( Join three consequents.  (Contributed by FL, 1-Aug-2009.) $)
    jca32 $p |- ( ph -> ( ps /\ ( ch /\ th ) ) ) $=
      ( wa jca ) ABCDHEACDFGII $.
  $}

  ${
    jcai.1 $e |- ( ph -> ps ) $.
    jcai.2 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction replacing implication with conjunction.  (Contributed by NM,
       15-Jul-1993.) $)
    jcai $p |- ( ph -> ( ps /\ ch ) ) $=
      ( mpd jca ) ABCDABCDEFG $.
  $}

  $( Distributive law for implication over conjunction.  Compare Theorem *4.76
     of [WhiteheadRussell] p. 121.  (Contributed by NM, 3-Apr-1994.)  (Proof
     shortened by Wolf Lammen, 27-Nov-2013.) $)
  jcab $p |- ( ( ph -> ( ps /\ ch ) )
      <-> ( ( ph -> ps ) /\ ( ph -> ch ) ) ) $=
    ( wa wi simpl imim2i simpr jca pm3.43 impbii ) ABCDZEZABEZACEZDMNOLBABCFGLC
    ABCHGIABCJK $.

  $( Theorem *4.76 of [WhiteheadRussell] p. 121.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.76 $p |- ( ( ( ph -> ps ) /\ ( ph -> ch ) ) <->
                ( ph -> ( ps /\ ch ) ) ) $=
    ( wa wi jcab bicomi ) ABCDEABEACEDABCFG $.

  ${
    jctil.1 $e |- ( ph -> ps ) $.
    jctil.2 $e |- ch $.
    $( Inference conjoining a theorem to left of consequent in an implication.
       (Contributed by NM, 31-Dec-1993.) $)
    jctil $p |- ( ph -> ( ch /\ ps ) ) $=
      ( a1i jca ) ACBCAEFDG $.

    $( Inference conjoining a theorem to right of consequent in an implication.
       (Contributed by NM, 31-Dec-1993.) $)
    jctir $p |- ( ph -> ( ps /\ ch ) ) $=
      ( a1i jca ) ABCDCAEFG $.
  $}

  ${
    jccir.1 $e |- ( ph -> ps ) $.
    jccir.2 $e |- ( ps -> ch ) $.
    $( Inference conjoining a consequent of a consequent to the right of the
       consequent in an implication.  See also ~ ex-natded5.3i .  (Contributed
       by Mario Carneiro, 9-Feb-2017.)  (Revised by AV, 20-Aug-2019.) $)
    jccir $p |- ( ph -> ( ps /\ ch ) ) $=
      ( syl jca ) ABCDABCDEFG $.

    $( Inference conjoining a consequent of a consequent to the left of the
       consequent in an implication.  Remark:  One can also prove this theorem
       using ~ syl and ~ jca (as done in ~ jccir ), which would be 4 bytes
       shorter, but one step longer than the current proof.
       (Proof modification is discouraged.)  (Contributed by AV,
       20-Aug-2019.) $)
    jccil $p |- ( ph -> ( ch /\ ps ) ) $=
      ( jccir ancomd ) ABCABCDEFG $.
  $}

  ${
    jctl.1 $e |- ps $.
    $( Inference conjoining a theorem to the left of a consequent.
       (Contributed by NM, 31-Dec-1993.)  (Proof shortened by Wolf Lammen,
       24-Oct-2012.) $)
    jctl $p |- ( ph -> ( ps /\ ph ) ) $=
      ( id jctil ) AABADCE $.

    $( Inference conjoining a theorem to the right of a consequent.
       (Contributed by NM, 18-Aug-1993.)  (Proof shortened by Wolf Lammen,
       24-Oct-2012.) $)
    jctr $p |- ( ph -> ( ph /\ ps ) ) $=
      ( id jctir ) AABADCE $.
  $}

  ${
    jctild.1 $e |- ( ph -> ( ps -> ch ) ) $.
    jctild.2 $e |- ( ph -> th ) $.
    $( Deduction conjoining a theorem to left of consequent in an implication.
       (Contributed by NM, 21-Apr-2005.) $)
    jctild $p |- ( ph -> ( ps -> ( th /\ ch ) ) ) $=
      ( a1d jcad ) ABDCADBFGEH $.
  $}

  ${
    jctird.1 $e |- ( ph -> ( ps -> ch ) ) $.
    jctird.2 $e |- ( ph -> th ) $.
    $( Deduction conjoining a theorem to right of consequent in an implication.
       (Contributed by NM, 21-Apr-2005.) $)
    jctird $p |- ( ph -> ( ps -> ( ch /\ th ) ) ) $=
      ( a1d jcad ) ABCDEADBFGH $.
  $}

  $( Introduction of antecedent as conjunct.  Theorem *4.73 of
     [WhiteheadRussell] p. 121.  (Contributed by NM, 30-Mar-1994.) $)
  iba $p |- ( ph -> ( ps <-> ( ps /\ ph ) ) ) $=
    ( wa pm3.21 simpl impbid1 ) ABBACABDBAEF $.

  $( Introduction of antecedent as conjunct.  (Contributed by NM,
     5-Dec-1995.) $)
  ibar $p |- ( ph -> ( ps <-> ( ph /\ ps ) ) ) $=
    ( iba biancomd ) ABABABCD $.

  ${
    biantru.1 $e |- ph $.
    $( A wff is equivalent to its conjunction with truth.  (Contributed by NM,
       26-May-1993.) $)
    biantru $p |- ( ps <-> ( ps /\ ph ) ) $=
      ( wa wb iba ax-mp ) ABBADECABFG $.
  $}

  ${
    biantrur.1 $e |- ph $.
    $( A wff is equivalent to its conjunction with truth.  (Contributed by NM,
       3-Aug-1994.) $)
    biantrur $p |- ( ps <-> ( ph /\ ps ) ) $=
      ( biantru biancomi ) BABABCDE $.
  $}

  ${
    biantrud.1 $e |- ( ph -> ps ) $.
    $( A wff is equivalent to its conjunction with truth.  (Contributed by NM,
       2-Aug-1994.)  (Proof shortened by Wolf Lammen, 23-Oct-2013.) $)
    biantrud $p |- ( ph -> ( ch <-> ( ch /\ ps ) ) ) $=
      ( wa wb iba syl ) ABCCBEFDBCGH $.

    $( A wff is equivalent to its conjunction with truth.  (Contributed by NM,
       1-May-1995.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
    biantrurd $p |- ( ph -> ( ch <-> ( ps /\ ch ) ) ) $=
      ( wa wb ibar syl ) ABCBCEFDBCGH $.
  $}

  ${
    bianfi.1 $e |- -. ph $.
    $( A wff conjoined with falsehood is false.  (Contributed by NM,
       21-Jun-1993.)  (Proof shortened by Wolf Lammen, 26-Nov-2012.) $)
    bianfi $p |- ( ph <-> ( ps /\ ph ) ) $=
      ( wa intnan 2false ) ABADCABCEF $.
  $}

  ${
    bianfd.1 $e |- ( ph -> -. ps ) $.
    $( A wff conjoined with falsehood is false.  (Contributed by NM,
       27-Mar-1995.)  (Proof shortened by Wolf Lammen, 5-Nov-2013.) $)
    bianfd $p |- ( ph -> ( ps <-> ( ps /\ ch ) ) ) $=
      ( wa intnanrd 2falsed ) ABBCEDABCDFG $.
  $}

  ${
    baib.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Move conjunction outside of biconditional.  (Contributed by NM,
       13-May-1999.) $)
    baib $p |- ( ps -> ( ph <-> ch ) ) $=
      ( wa ibar bitr4id ) BABCECDBCFG $.

    $( Move conjunction outside of biconditional.  (Contributed by NM,
       11-Jul-1994.) $)
    baibr $p |- ( ps -> ( ch <-> ph ) ) $=
      ( baib bicomd ) BACABCDEF $.

    $( Move conjunction outside of biconditional.  (Contributed by Mario
       Carneiro, 11-Sep-2015.)  (Proof shortened by Wolf Lammen,
       19-Jan-2020.) $)
    rbaibr $p |- ( ch -> ( ps <-> ph ) ) $=
      ( biancomi baibr ) ACBACBDEF $.

    $( Move conjunction outside of biconditional.  (Contributed by Mario
       Carneiro, 11-Sep-2015.)  (Proof shortened by Wolf Lammen,
       19-Jan-2020.) $)
    rbaib $p |- ( ch -> ( ph <-> ps ) ) $=
      ( rbaibr bicomd ) CBAABCDEF $.
  $}

  ${
    baibd.1 $e |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $.
    $( Move conjunction outside of biconditional.  (Contributed by Mario
       Carneiro, 11-Sep-2015.) $)
    baibd $p |- ( ( ph /\ ch ) -> ( ps <-> th ) ) $=
      ( wa ibar bicomd sylan9bb ) ABCDFZCDECDJCDGHI $.

    $( Move conjunction outside of biconditional.  (Contributed by Mario
       Carneiro, 11-Sep-2015.) $)
    rbaibd $p |- ( ( ph /\ th ) -> ( ps <-> ch ) ) $=
      ( biancomd baibd ) ABDCABDCEFG $.
  $}

  ${
    bianabs.1 $e |- ( ph -> ( ps <-> ( ph /\ ch ) ) ) $.
    $( Absorb a hypothesis into the second member of a biconditional.
       (Contributed by FL, 15-Feb-2007.) $)
    bianabs $p |- ( ph -> ( ps <-> ch ) ) $=
      ( wa ibar bitr4d ) ABACECDACFG $.
  $}

  $( Theorem *5.44 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.44 $p |- ( ( ph -> ps ) -> ( ( ph -> ch ) <->
                ( ph -> ( ps /\ ch ) ) ) ) $=
    ( wa wi jcab baibr ) ABCDEABEACEABCFG $.

  $( Theorem *5.42 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.42 $p |- ( ( ph -> ( ps -> ch ) ) <->
                ( ph -> ( ps -> ( ph /\ ch ) ) ) ) $=
    ( wi wa ibar imbi2d pm5.74i ) ABCDBACEZDACIBACFGH $.

  $( Conjoin antecedent to left of consequent.  (Contributed by NM,
     15-Aug-1994.) $)
  ancl $p |- ( ( ph -> ps ) -> ( ph -> ( ph /\ ps ) ) ) $=
    ( wa pm3.2 a2i ) ABABCABDE $.

  $( Conjoin antecedent to left of consequent.  Theorem *4.7 of
     [WhiteheadRussell] p. 120.  (Contributed by NM, 25-Jul-1999.)  (Proof
     shortened by Wolf Lammen, 24-Mar-2013.) $)
  anclb $p |- ( ( ph -> ps ) <-> ( ph -> ( ph /\ ps ) ) ) $=
    ( wa ibar pm5.74i ) ABABCABDE $.

  $( Conjoin antecedent to right of consequent.  (Contributed by NM,
     15-Aug-1994.) $)
  ancr $p |- ( ( ph -> ps ) -> ( ph -> ( ps /\ ph ) ) ) $=
    ( wa pm3.21 a2i ) ABBACABDE $.

  $( Conjoin antecedent to right of consequent.  (Contributed by NM,
     25-Jul-1999.)  (Proof shortened by Wolf Lammen, 24-Mar-2013.) $)
  ancrb $p |- ( ( ph -> ps ) <-> ( ph -> ( ps /\ ph ) ) ) $=
    ( wa iba pm5.74i ) ABBACABDE $.

  ${
    ancli.1 $e |- ( ph -> ps ) $.
    $( Deduction conjoining antecedent to left of consequent.  (Contributed by
       NM, 12-Aug-1993.) $)
    ancli $p |- ( ph -> ( ph /\ ps ) ) $=
      ( id jca ) AABADCE $.
  $}

  ${
    ancri.1 $e |- ( ph -> ps ) $.
    $( Deduction conjoining antecedent to right of consequent.  (Contributed by
       NM, 15-Aug-1994.) $)
    ancri $p |- ( ph -> ( ps /\ ph ) ) $=
      ( id jca ) ABACADE $.
  $}

  ${
    ancld.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction conjoining antecedent to left of consequent in nested
       implication.  (Contributed by NM, 15-Aug-1994.)  (Proof shortened by
       Wolf Lammen, 1-Nov-2012.) $)
    ancld $p |- ( ph -> ( ps -> ( ps /\ ch ) ) ) $=
      ( idd jcad ) ABBCABEDF $.
  $}

  ${
    ancrd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction conjoining antecedent to right of consequent in nested
       implication.  (Contributed by NM, 15-Aug-1994.)  (Proof shortened by
       Wolf Lammen, 1-Nov-2012.) $)
    ancrd $p |- ( ph -> ( ps -> ( ch /\ ps ) ) ) $=
      ( idd jcad ) ABCBDABEF $.
  $}

  ${
    impac.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Importation with conjunction in consequent.  (Contributed by NM,
       9-Aug-1994.) $)
    impac $p |- ( ( ph /\ ps ) -> ( ch /\ ps ) ) $=
      ( wa ancrd imp ) ABCBEABCDFG $.
  $}

  $( Conjoin antecedent to left of consequent in nested implication.
     (Contributed by NM, 10-Aug-1994.)  (Proof shortened by Wolf Lammen,
     14-Jul-2013.) $)
  anc2l $p |- ( ( ph -> ( ps -> ch ) ) -> ( ph -> ( ps -> ( ph /\ ch ) ) ) ) $=
    ( wi wa pm5.42 biimpi ) ABCDDABACEDDABCFG $.

  $( Conjoin antecedent to right of consequent in nested implication.
     (Contributed by NM, 15-Aug-1994.) $)
  anc2r $p |- ( ( ph -> ( ps -> ch ) ) -> ( ph -> ( ps -> ( ch /\ ph ) ) ) ) $=
    ( wi wa pm3.21 imim2d a2i ) ABCDBCAEZDACIBACFGH $.

  ${
    anc2li.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction conjoining antecedent to left of consequent in nested
       implication.  (Contributed by NM, 10-Aug-1994.)  (Proof shortened by
       Wolf Lammen, 7-Dec-2012.) $)
    anc2li $p |- ( ph -> ( ps -> ( ph /\ ch ) ) ) $=
      ( id jctild ) ABCADAEF $.
  $}

  ${
    anc2ri.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction conjoining antecedent to right of consequent in nested
       implication.  (Contributed by NM, 15-Aug-1994.)  (Proof shortened by
       Wolf Lammen, 7-Dec-2012.) $)
    anc2ri $p |- ( ph -> ( ps -> ( ch /\ ph ) ) ) $=
      ( id jctird ) ABCADAEF $.
  $}

  $( Implication in terms of biconditional and conjunction.  Theorem *4.71 of
     [WhiteheadRussell] p. 120.  (Contributed by NM, 21-Jun-1993.)  (Proof
     shortened by Wolf Lammen, 2-Dec-2012.) $)
  pm4.71 $p |- ( ( ph -> ps ) <-> ( ph <-> ( ph /\ ps ) ) ) $=
    ( wa wi wb simpl biantru anclb dfbi2 3bitr4i ) AABCZDZLKADZCABDAKEMLABFGABH
    AKIJ $.

  $( Implication in terms of biconditional and conjunction.  Theorem *4.71 of
     [WhiteheadRussell] p. 120 (with conjunct reversed).  (Contributed by NM,
     25-Jul-1999.) $)
  pm4.71r $p |- ( ( ph -> ps ) <-> ( ph <-> ( ps /\ ph ) ) ) $=
    ( wi wa wb pm4.71 ancom bibi2i bitri ) ABCAABDZEABADZEABFJKAABGHI $.

  ${
    pm4.71i.1 $e |- ( ph -> ps ) $.
    $( Inference converting an implication to a biconditional with conjunction.
       Inference from Theorem *4.71 of [WhiteheadRussell] p. 120.  (Contributed
       by NM, 4-Jan-2004.) $)
    pm4.71i $p |- ( ph <-> ( ph /\ ps ) ) $=
      ( wi wa wb pm4.71 mpbi ) ABDAABEFCABGH $.
  $}

  ${
    pm4.71ri.1 $e |- ( ph -> ps ) $.
    $( Inference converting an implication to a biconditional with conjunction.
       Inference from Theorem *4.71 of [WhiteheadRussell] p. 120 (with conjunct
       reversed).  (Contributed by NM, 1-Dec-2003.) $)
    pm4.71ri $p |- ( ph <-> ( ps /\ ph ) ) $=
      ( pm4.71i biancomi ) ABAABCDE $.
  $}

  ${
    pm4.71rd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction converting an implication to a biconditional with conjunction.
       Deduction from Theorem *4.71 of [WhiteheadRussell] p. 120.  (Contributed
       by Mario Carneiro, 25-Dec-2016.) $)
    pm4.71d $p |- ( ph -> ( ps <-> ( ps /\ ch ) ) ) $=
      ( wi wa wb pm4.71 sylib ) ABCEBBCFGDBCHI $.

    $( Deduction converting an implication to a biconditional with conjunction.
       Deduction from Theorem *4.71 of [WhiteheadRussell] p. 120.  (Contributed
       by NM, 10-Feb-2005.) $)
    pm4.71rd $p |- ( ph -> ( ps <-> ( ch /\ ps ) ) ) $=
      ( pm4.71d biancomd ) ABCBABCDEF $.
  $}

  ${
    pm4.71da.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduction converting a biconditional to a biconditional with
       conjunction.  Variant of ~ pm4.71d .  (Contributed by Zhi Wang,
       30-Aug-2024.) $)
    pm4.71da $p |- ( ph -> ( ps <-> ( ps /\ ch ) ) ) $=
      ( biimpd pm4.71d ) ABCABCDEF $.
  $}

  $( Theorem *4.24 of [WhiteheadRussell] p. 117.  (Contributed by NM,
     11-May-1993.) $)
  pm4.24 $p |- ( ph <-> ( ph /\ ph ) ) $=
    ( id pm4.71i ) AAABC $.

  $( Idempotent law for conjunction.  (Contributed by NM, 8-Jan-2004.)  (Proof
     shortened by Wolf Lammen, 14-Mar-2014.) $)
  anidm $p |- ( ( ph /\ ph ) <-> ph ) $=
    ( wa pm4.24 bicomi ) AAABACD $.

  $( Conjunction idempotence with antecedent.  (Contributed by Roy F. Longton,
     8-Aug-2005.) $)
  anidmdbi $p |- ( ( ph -> ( ps /\ ps ) ) <-> ( ph -> ps ) ) $=
    ( wa anidm imbi2i ) BBCBABDE $.

  ${
    anidms.1 $e |- ( ( ph /\ ph ) -> ps ) $.
    $( Inference from idempotent law for conjunction.  (Contributed by NM,
       15-Jun-1994.) $)
    anidms $p |- ( ph -> ps ) $=
      ( ex pm2.43i ) ABAABCDE $.
  $}

  $( Distribution of implication with conjunction.  (Contributed by NM,
     31-May-1999.)  (Proof shortened by Wolf Lammen, 6-Dec-2012.) $)
  imdistan $p |- ( ( ph -> ( ps -> ch ) ) <->
                ( ( ph /\ ps ) -> ( ph /\ ch ) ) ) $=
    ( wi wa pm5.42 impexp bitr4i ) ABCDDABACEZDDABEIDABCFABIGH $.

  ${
    imdistani.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Distribution of implication with conjunction.  (Contributed by NM,
       1-Aug-1994.) $)
    imdistani $p |- ( ( ph /\ ps ) -> ( ph /\ ch ) ) $=
      ( wa anc2li imp ) ABACEABCDFG $.
  $}

  ${
    imdistanri.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Distribution of implication with conjunction.  (Contributed by NM,
       8-Jan-2002.) $)
    imdistanri $p |- ( ( ps /\ ph ) -> ( ch /\ ph ) ) $=
      ( com12 impac ) BACABCDEF $.
  $}

  ${
    imdistand.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( Distribution of implication with conjunction (deduction form).
       (Contributed by NM, 27-Aug-2004.) $)
    imdistand $p |- ( ph -> ( ( ps /\ ch ) -> ( ps /\ th ) ) ) $=
      ( wi wa imdistan sylib ) ABCDFFBCGBDGFEBCDHI $.
  $}

  ${
    imdistanda.1 $e |- ( ( ph /\ ps ) -> ( ch -> th ) ) $.
    $( Distribution of implication with conjunction (deduction version with
       conjoined antecedent).  (Contributed by Jeff Madsen, 19-Jun-2011.) $)
    imdistanda $p |- ( ph -> ( ( ps /\ ch ) -> ( ps /\ th ) ) ) $=
      ( wi ex imdistand ) ABCDABCDFEGH $.
  $}

  $( Theorem *5.3 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
  pm5.3 $p |- ( ( ( ph /\ ps ) -> ch ) <->
               ( ( ph /\ ps ) -> ( ph /\ ch ) ) ) $=
    ( wa simpl biantrurd pm5.74i ) ABDZCACDHACABEFG $.

  $( Distribution of implication over biconditional.  Theorem *5.32 of
     [WhiteheadRussell] p. 125.  (Contributed by NM, 1-Aug-1994.) $)
  pm5.32 $p |- ( ( ph -> ( ps <-> ch ) ) <->
               ( ( ph /\ ps ) <-> ( ph /\ ch ) ) ) $=
    ( wb wi wn wa notbi imbi2i pm5.74 3bitri df-an bibi12i bitr4i ) ABCDZEZABFZ
    EZFZACFZEZFZDZABGZACGZDPAQTDZERUADUCOUFABCHIAQTJRUAHKUDSUEUBABLACLMN $.

  ${
    pm5.32i.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Distribution of implication over biconditional (inference form).
       (Contributed by NM, 1-Aug-1994.) $)
    pm5.32i $p |- ( ( ph /\ ps ) <-> ( ph /\ ch ) ) $=
      ( wb wi wa pm5.32 mpbi ) ABCEFABGACGEDABCHI $.

    $( Distribution of implication over biconditional (inference form).
       (Contributed by NM, 12-Mar-1995.) $)
    pm5.32ri $p |- ( ( ps /\ ph ) <-> ( ch /\ ph ) ) $=
      ( wa pm5.32i ancom 3bitr4i ) ABEACEBAECAEABCDFBAGCAGH $.
  $}

  ${
    bianim.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    bianim.2 $e |- ( ch -> ( ps <-> th ) ) $.
    $( Exchanging conjunction in a biconditional.  (Contributed by Peter Mazsa,
       31-Jul-2023.) $)
    bianim $p |- ( ph <-> ( th /\ ch ) ) $=
      ( wa pm5.32ri bitri ) ABCGDCGECBDFHI $.
  $}

  ${
    pm5.32d.1 $e |- ( ph -> ( ps -> ( ch <-> th ) ) ) $.
    $( Distribution of implication over biconditional (deduction form).
       (Contributed by NM, 29-Oct-1996.) $)
    pm5.32d $p |- ( ph -> ( ( ps /\ ch ) <-> ( ps /\ th ) ) ) $=
      ( wb wi wa pm5.32 sylib ) ABCDFGBCHBDHFEBCDIJ $.

    $( Distribution of implication over biconditional (deduction form).
       (Contributed by NM, 25-Dec-2004.) $)
    pm5.32rd $p |- ( ph -> ( ( ch /\ ps ) <-> ( th /\ ps ) ) ) $=
      ( wa pm5.32d ancom 3bitr4g ) ABCFBDFCBFDBFABCDEGCBHDBHI $.
  $}

  ${
    pm5.32da.1 $e |- ( ( ph /\ ps ) -> ( ch <-> th ) ) $.
    $( Distribution of implication over biconditional (deduction form).
       (Contributed by NM, 9-Dec-2006.) $)
    pm5.32da $p |- ( ph -> ( ( ps /\ ch ) <-> ( ps /\ th ) ) ) $=
      ( wb ex pm5.32d ) ABCDABCDFEGH $.
  $}

  ${
    bian1d.1 $e |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $.
    $( Adding a superfluous conjunct in a biconditional.  (Contributed by
       Thierry Arnoux, 26-Feb-2017.)  (Proof shortened by Hongxiu Chen,
       29-Jun-2025.)  (Proof shortened by Peter Mazsa, 24-Feb-2026.) $)
    bian1d $p |- ( ph -> ( ( ch /\ ps ) <-> ( ch /\ th ) ) ) $=
      ( baibd pm5.32da ) ACBDABCDEFG $.
  $}

  ${
    sylan.1 $e |- ( ph -> ps ) $.
    sylan.2 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference.  (Contributed by NM, 21-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 22-Nov-2012.) $)
    sylan $p |- ( ( ph /\ ch ) -> th ) $=
      ( expcom mpan9 ) ABCDEBCDFGH $.
  $}

  ${
    sylanb.1 $e |- ( ph <-> ps ) $.
    sylanb.2 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference.  (Contributed by NM, 18-May-1994.) $)
    sylanb $p |- ( ( ph /\ ch ) -> th ) $=
      ( biimpi sylan ) ABCDABEGFH $.
  $}

  ${
    sylanbr.1 $e |- ( ps <-> ph ) $.
    sylanbr.2 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference.  (Contributed by NM, 18-May-1994.) $)
    sylanbr $p |- ( ( ph /\ ch ) -> th ) $=
      ( biimpri sylan ) ABCDBAEGFH $.
  $}

  ${
    sylanbrc.1 $e |- ( ph -> ps ) $.
    sylanbrc.2 $e |- ( ph -> ch ) $.
    sylanbrc.3 $e |- ( th <-> ( ps /\ ch ) ) $.
    $( Syllogism inference.  (Contributed by Jeff Madsen, 2-Sep-2009.) $)
    sylanbrc $p |- ( ph -> th ) $=
      ( wa jca sylibr ) ABCHDABCEFIGJ $.
  $}

  ${
    syl2anc.1 $e |- ( ph -> ps ) $.
    syl2anc.2 $e |- ( ph -> ch ) $.
    syl2anc.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( Syllogism inference combined with contraction.  (Contributed by NM,
       16-Mar-2012.) $)
    syl2anc $p |- ( ph -> th ) $=
      ( ex sylc ) ABCDEFBCDGHI $.
  $}

  ${
    syl2anc2.1 $e |- ( ph -> ps ) $.
    syl2anc2.2 $e |- ( ps -> ch ) $.
    syl2anc2.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( Double syllogism inference combined with contraction.  (Contributed by
       BTernaryTau, 29-Sep-2023.) $)
    syl2anc2 $p |- ( ph -> th ) $=
      ( syl syl2anc ) ABCDEABCEFHGI $.
  $}

  ${
    sylancl.1 $e |- ( ph -> ps ) $.
    sylancl.2 $e |- ch $.
    sylancl.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( Syllogism inference combined with modus ponens.  (Contributed by Jeff
       Madsen, 2-Sep-2009.) $)
    sylancl $p |- ( ph -> th ) $=
      ( a1i syl2anc ) ABCDECAFHGI $.
  $}

  ${
    sylancr.1 $e |- ps $.
    sylancr.2 $e |- ( ph -> ch ) $.
    sylancr.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( Syllogism inference combined with modus ponens.  (Contributed by Jeff
       Madsen, 2-Sep-2009.) $)
    sylancr $p |- ( ph -> th ) $=
      ( a1i syl2anc ) ABCDBAEHFGI $.
  $}

  ${
    sylancom.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    sylancom.2 $e |- ( ( ch /\ ps ) -> th ) $.
    $( Syllogism inference with commutation of antecedents.  (Contributed by
       NM, 2-Jul-2008.) $)
    sylancom $p |- ( ( ph /\ ps ) -> th ) $=
      ( wa simpr syl2anc ) ABGCBDEABHFI $.
  $}

  ${
    sylanblc.1 $e |- ( ph -> ps ) $.
    sylanblc.2 $e |- ch $.
    sylanblc.3 $e |- ( ( ps /\ ch ) <-> th ) $.
    $( Syllogism inference combined with a biconditional.  (Contributed by BJ,
       25-Apr-2019.) $)
    sylanblc $p |- ( ph -> th ) $=
      ( wa biimpi sylancl ) ABCDEFBCHDGIJ $.
  $}

  ${
    sylanblrc.1 $e |- ( ph -> ps ) $.
    sylanblrc.2 $e |- ch $.
    sylanblrc.3 $e |- ( th <-> ( ps /\ ch ) ) $.
    $( Syllogism inference combined with a biconditional.  (Contributed by BJ,
       25-Apr-2019.) $)
    sylanblrc $p |- ( ph -> th ) $=
      ( a1i sylanbrc ) ABCDECAFHGI $.
  $}

  ${
    syldan.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    syldan.2 $e |- ( ( ph /\ ch ) -> th ) $.
    $( A syllogism deduction with conjoined antecedents.  (Contributed by NM,
       24-Feb-2005.)  (Proof shortened by Wolf Lammen, 6-Apr-2013.) $)
    syldan $p |- ( ( ph /\ ps ) -> th ) $=
      ( wa simpl syl2anc ) ABGACDABHEFI $.
  $}

  ${
    sylbida.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    sylbida.2 $e |- ( ( ph /\ ch ) -> th ) $.
    $( A syllogism deduction.  (Contributed by SN, 16-Jul-2024.) $)
    sylbida $p |- ( ( ph /\ ps ) -> th ) $=
      ( biimpa syldan ) ABCDABCEGFH $.
  $}

  ${
    sylan2.1 $e |- ( ph -> ch ) $.
    sylan2.2 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference.  (Contributed by NM, 21-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 22-Nov-2012.) $)
    sylan2 $p |- ( ( ps /\ ph ) -> th ) $=
      ( adantl syldan ) BACDACBEGFH $.
  $}

  ${
    sylan2b.1 $e |- ( ph <-> ch ) $.
    sylan2b.2 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference.  (Contributed by NM, 21-Apr-1994.) $)
    sylan2b $p |- ( ( ps /\ ph ) -> th ) $=
      ( biimpi sylan2 ) ABCDACEGFH $.
  $}

  ${
    sylan2br.1 $e |- ( ch <-> ph ) $.
    sylan2br.2 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference.  (Contributed by NM, 21-Apr-1994.) $)
    sylan2br $p |- ( ( ps /\ ph ) -> th ) $=
      ( biimpri sylan2 ) ABCDCAEGFH $.
  $}

  ${
    syl2an.1 $e |- ( ph -> ps ) $.
    syl2an.2 $e |- ( ta -> ch ) $.
    syl2an.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A double syllogism inference.  For an implication-only version, see
       ~ syl2im .  (Contributed by NM, 31-Jan-1997.) $)
    syl2an $p |- ( ( ph /\ ta ) -> th ) $=
      ( sylan sylan2 ) EACDGABCDFHIJ $.

    $( A double syllogism inference.  For an implication-only version, see
       ~ syl2imc .  (Contributed by NM, 17-Sep-2013.) $)
    syl2anr $p |- ( ( ta /\ ph ) -> th ) $=
      ( syl2an ancoms ) AEDABCDEFGHIJ $.
  $}

  ${
    syl2anb.1 $e |- ( ph <-> ps ) $.
    syl2anb.2 $e |- ( ta <-> ch ) $.
    syl2anb.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A double syllogism inference.  (Contributed by NM, 29-Jul-1999.) $)
    syl2anb $p |- ( ( ph /\ ta ) -> th ) $=
      ( sylanb sylan2b ) EACDGABCDFHIJ $.
  $}

  ${
    syl2anbr.1 $e |- ( ps <-> ph ) $.
    syl2anbr.2 $e |- ( ch <-> ta ) $.
    syl2anbr.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A double syllogism inference.  (Contributed by NM, 29-Jul-1999.) $)
    syl2anbr $p |- ( ( ph /\ ta ) -> th ) $=
      ( sylanbr sylan2br ) EACDGABCDFHIJ $.
  $}

  ${
    sylancb.1 $e |- ( ph <-> ps ) $.
    sylancb.2 $e |- ( ph <-> ch ) $.
    sylancb.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference combined with contraction.  (Contributed by NM,
       3-Sep-2004.) $)
    sylancb $p |- ( ph -> th ) $=
      ( syl2anb anidms ) ADABCDAEFGHI $.
  $}

  ${
    sylancbr.1 $e |- ( ps <-> ph ) $.
    sylancbr.2 $e |- ( ch <-> ph ) $.
    sylancbr.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference combined with contraction.  (Contributed by NM,
       3-Sep-2004.) $)
    sylancbr $p |- ( ph -> th ) $=
      ( syl2anbr anidms ) ADABCDAEFGHI $.
  $}

  ${
    syldanl.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    syldanl.2 $e |- ( ( ( ph /\ ch ) /\ th ) -> ta ) $.
    $( A syllogism deduction with conjoined antecedents.  (Contributed by Jeff
       Madsen, 20-Jun-2011.) $)
    syldanl $p |- ( ( ( ph /\ ps ) /\ th ) -> ta ) $=
      ( wa ex imdistani sylan ) ABHACHDEABCABCFIJGK $.
  $}

  ${
    syland.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syland.2 $e |- ( ph -> ( ( ch /\ th ) -> ta ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 15-Dec-2004.) $)
    syland $p |- ( ph -> ( ( ps /\ th ) -> ta ) ) $=
      ( wi expd syld impd ) ABDEABCDEHFACDEGIJK $.
  $}

  ${
    sylani.1 $e |- ( ph -> ch ) $.
    sylani.2 $e |- ( ps -> ( ( ch /\ th ) -> ta ) ) $.
    $( A syllogism inference.  (Contributed by NM, 2-May-1996.) $)
    sylani $p |- ( ps -> ( ( ph /\ th ) -> ta ) ) $=
      ( wi a1i syland ) BACDEACHBFIGJ $.
  $}

  ${
    sylan2d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    sylan2d.2 $e |- ( ph -> ( ( th /\ ch ) -> ta ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 15-Dec-2004.) $)
    sylan2d $p |- ( ph -> ( ( th /\ ps ) -> ta ) ) $=
      ( ancomsd syland ) ABDEABCDEFADCEGHIH $.
  $}

  ${
    sylan2i.1 $e |- ( ph -> th ) $.
    sylan2i.2 $e |- ( ps -> ( ( ch /\ th ) -> ta ) ) $.
    $( A syllogism inference.  (Contributed by NM, 1-Aug-1994.) $)
    sylan2i $p |- ( ps -> ( ( ch /\ ph ) -> ta ) ) $=
      ( wi a1i sylan2d ) BADCEADHBFIGJ $.
  $}

  ${
    syl2ani.1 $e |- ( ph -> ch ) $.
    syl2ani.2 $e |- ( et -> th ) $.
    syl2ani.3 $e |- ( ps -> ( ( ch /\ th ) -> ta ) ) $.
    $( A syllogism inference.  (Contributed by NM, 3-Aug-1999.) $)
    syl2ani $p |- ( ps -> ( ( ph /\ et ) -> ta ) ) $=
      ( sylan2i sylani ) ABCFEGFBCDEHIJK $.
  $}

  ${
    syl2and.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl2and.2 $e |- ( ph -> ( th -> ta ) ) $.
    syl2and.3 $e |- ( ph -> ( ( ch /\ ta ) -> et ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 15-Dec-2004.) $)
    syl2and $p |- ( ph -> ( ( ps /\ th ) -> et ) ) $=
      ( sylan2d syland ) ABCDFGADECFHIJK $.
  $}

  ${
    anim12d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    anim12d.2 $e |- ( ph -> ( th -> ta ) ) $.
    $( Conjoin antecedents and consequents in a deduction.  (Contributed by NM,
       3-Apr-1994.)  (Proof shortened by Wolf Lammen, 18-Dec-2013.) $)
    anim12d $p |- ( ph -> ( ( ps /\ th ) -> ( ch /\ ta ) ) ) $=
      ( wa idd syl2and ) ABCDECEHZFGAKIJ $.
  $}

  ${
    anim12d1.1 $e |- ( ph -> ( ps -> ch ) ) $.
    anim12d1.2 $e |- ( th -> ta ) $.
    $( Variant of ~ anim12d where the second implication does not depend on the
       antecedent.  (Contributed by Rodolfo Medina, 12-Oct-2010.) $)
    anim12d1 $p |- ( ph -> ( ( ps /\ th ) -> ( ch /\ ta ) ) ) $=
      ( wi a1i anim12d ) ABCDEFDEHAGIJ $.
  $}

  ${
    anim1d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Add a conjunct to right of antecedent and consequent in a deduction.
       (Contributed by NM, 3-Apr-1994.) $)
    anim1d $p |- ( ph -> ( ( ps /\ th ) -> ( ch /\ th ) ) ) $=
      ( idd anim12d ) ABCDDEADFG $.

    $( Add a conjunct to left of antecedent and consequent in a deduction.
       (Contributed by NM, 14-May-1993.) $)
    anim2d $p |- ( ph -> ( ( th /\ ps ) -> ( th /\ ch ) ) ) $=
      ( idd anim12d ) ADDBCADFEG $.
  $}

  ${
    anim12i.1 $e |- ( ph -> ps ) $.
    anim12i.2 $e |- ( ch -> th ) $.
    $( Conjoin antecedents and consequents of two premises.  (Contributed by
       NM, 3-Jan-1993.)  (Proof shortened by Wolf Lammen, 14-Dec-2013.) $)
    anim12i $p |- ( ( ph /\ ch ) -> ( ps /\ th ) ) $=
      ( wa id syl2an ) ABDBDGZCEFJHI $.

    $( Variant of ~ anim12i with commutation.  (Contributed by Jonathan
       Ben-Naim, 3-Jun-2011.) $)
    anim12ci $p |- ( ( ph /\ ch ) -> ( th /\ ps ) ) $=
      ( wa anim12i ancoms ) CADBGCDABFEHI $.
  $}

  ${
    anim1i.1 $e |- ( ph -> ps ) $.
    $( Introduce conjunct to both sides of an implication.  (Contributed by NM,
       5-Aug-1993.) $)
    anim1i $p |- ( ( ph /\ ch ) -> ( ps /\ ch ) ) $=
      ( id anim12i ) ABCCDCEF $.

    $( Introduce conjunct to both sides of an implication.  (Contributed by
       Peter Mazsa, 24-Sep-2022.) $)
    anim1ci $p |- ( ( ph /\ ch ) -> ( ch /\ ps ) ) $=
      ( id anim12ci ) ABCCDCEF $.

    $( Introduce conjunct to both sides of an implication.  (Contributed by NM,
       3-Jan-1993.) $)
    anim2i $p |- ( ( ch /\ ph ) -> ( ch /\ ps ) ) $=
      ( id anim12i ) CCABCEDF $.
  $}

  ${
    anim12ii.1 $e |- ( ph -> ( ps -> ch ) ) $.
    anim12ii.2 $e |- ( th -> ( ps -> ta ) ) $.
    $( Conjoin antecedents and consequents in a deduction.  (Contributed by NM,
       11-Nov-2007.)  (Proof shortened by Wolf Lammen, 19-Jul-2013.) $)
    anim12ii $p |- ( ( ph /\ th ) -> ( ps -> ( ch /\ ta ) ) ) $=
      ( wi wa pm3.43 syl2an ) ABCHBEHBCEIHDFGBCEJK $.
  $}

  ${
    anim12dan.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    anim12dan.2 $e |- ( ( ph /\ th ) -> ta ) $.
    $( Conjoin antecedents and consequents in a deduction.  (Contributed by
       Jeff Madsen, 16-Jun-2011.) $)
    anim12dan $p |- ( ( ph /\ ( ps /\ th ) ) -> ( ch /\ ta ) ) $=
      ( wa ex anim12d imp ) ABDHCEHABCDEABCFIADEGIJK $.
  $}

  ${
    im2an9.1 $e |- ( ph -> ( ps -> ch ) ) $.
    im2an9.2 $e |- ( th -> ( ta -> et ) ) $.
    $( Deduction joining nested implications to form implication of
       conjunctions.  (Contributed by NM, 29-Feb-1996.) $)
    im2anan9 $p |- ( ( ph /\ th ) -> ( ( ps /\ ta ) -> ( ch /\ et ) ) ) $=
      ( wa adantrd adantld anim12ii ) ABEICDFABCEGJDEFBHKL $.

    $( Deduction joining nested implications to form implication of
       conjunctions.  (Contributed by NM, 29-Feb-1996.) $)
    im2anan9r $p |- ( ( th /\ ph ) -> ( ( ps /\ ta ) -> ( ch /\ et ) ) ) $=
      ( wa wi im2anan9 ancoms ) ADBEICFIJABCDEFGHKL $.
  $}

  $( Theorem *3.45 (Fact) of [WhiteheadRussell] p. 113.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.45 $p |- ( ( ph -> ps ) -> ( ( ph /\ ch ) -> ( ps /\ ch ) ) ) $=
    ( wi id anim1d ) ABDZABCGEF $.

  ${
    anbi.1 $e |- ( ph <-> ps ) $.
    $( Introduce a left conjunct to both sides of a logical equivalence.
       (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf Lammen,
       16-Nov-2013.) $)
    anbi2i $p |- ( ( ch /\ ph ) <-> ( ch /\ ps ) ) $=
      ( wb a1i pm5.32i ) CABABECDFG $.

    $( Introduce a right conjunct to both sides of a logical equivalence.
       (Contributed by NM, 12-Mar-1993.)  (Proof shortened by Wolf Lammen,
       16-Nov-2013.) $)
    anbi1i $p |- ( ( ph /\ ch ) <-> ( ps /\ ch ) ) $=
      ( wb a1i pm5.32ri ) CABABECDFG $.

    $( Variant of ~ anbi2i with commutation.  (Contributed by Jonathan
       Ben-Naim, 3-Jun-2011.)  (Proof shortened by Andrew Salmon,
       14-Jun-2011.) $)
    anbi2ci $p |- ( ( ph /\ ch ) <-> ( ch /\ ps ) ) $=
      ( wa anbi1i biancomi ) ACECBABCDFG $.

    $( Variant of ~ anbi1i with commutation.  (Contributed by Peter Mazsa,
       7-Mar-2020.) $)
    anbi1ci $p |- ( ( ch /\ ph ) <-> ( ps /\ ch ) ) $=
      ( wa anbi2i biancomi ) CAEBCABCDFG $.
  $}

  ${
    bianbi.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    bianbi.2 $e |- ( ps <-> th ) $.
    $( Exchanging conjunction in a biconditional.  (Contributed by Peter Mazsa,
       31-Jul-2023.) $)
    bianbi $p |- ( ph <-> ( th /\ ch ) ) $=
      ( wa anbi1i bitri ) ABCGDCGEBDCFHI $.
  $}

  ${
    anbi12.1 $e |- ( ph <-> ps ) $.
    anbi12.2 $e |- ( ch <-> th ) $.
    $( Conjoin both sides of two equivalences.  (Contributed by NM,
       12-Mar-1993.) $)
    anbi12i $p |- ( ( ph /\ ch ) <-> ( ps /\ th ) ) $=
      ( wa anbi2i bianbi ) ACGADBCDAFHEI $.

    $( Variant of ~ anbi12i with commutation.  (Contributed by Jonathan
       Ben-Naim, 3-Jun-2011.) $)
    anbi12ci $p |- ( ( ph /\ ch ) <-> ( th /\ ps ) ) $=
      ( wa anbi12i biancomi ) ACGDBABCDEFHI $.
  $}

  ${
    anbid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduction adding a left conjunct to both sides of a logical equivalence.
       (Contributed by NM, 11-May-1993.)  (Proof shortened by Wolf Lammen,
       16-Nov-2013.) $)
    anbi2d $p |- ( ph -> ( ( th /\ ps ) <-> ( th /\ ch ) ) ) $=
      ( wb a1d pm5.32d ) ADBCABCFDEGH $.

    $( Deduction adding a right conjunct to both sides of a logical
       equivalence.  (Contributed by NM, 11-May-1993.)  (Proof shortened by
       Wolf Lammen, 16-Nov-2013.) $)
    anbi1d $p |- ( ph -> ( ( ps /\ th ) <-> ( ch /\ th ) ) ) $=
      ( wb a1d pm5.32rd ) ADBCABCFDEGH $.
  $}

  ${
    anbi12d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    anbi12d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Deduction joining two equivalences to form equivalence of conjunctions.
       (Contributed by NM, 26-May-1993.) $)
    anbi12d $p |- ( ph -> ( ( ps /\ th ) <-> ( ch /\ ta ) ) ) $=
      ( wa anbi1d anbi2d bitrd ) ABDHCDHCEHABCDFIADECGJK $.
  $}

  $( Introduce a right conjunct to both sides of a logical equivalence.
     Theorem *4.36 of [WhiteheadRussell] p. 118.  (Contributed by NM,
     3-Jan-2005.) $)
  anbi1 $p |- ( ( ph <-> ps ) -> ( ( ph /\ ch ) <-> ( ps /\ ch ) ) ) $=
    ( wb id anbi1d ) ABDZABCGEF $.

  $( Introduce a left conjunct to both sides of a logical equivalence.
     (Contributed by NM, 16-Nov-2013.) $)
  anbi2 $p |- ( ( ph <-> ps ) -> ( ( ch /\ ph ) <-> ( ch /\ ps ) ) ) $=
    ( wb id anbi2d ) ABDZABCGEF $.

  ${
    anbi1cd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Introduce a proposition as left conjunct on the left-hand side and right
       conjunct on the right-hand side of an equivalence.  Deduction form.
       (Contributed by Peter Mazsa, 22-May-2021.) $)
    anbi1cd $p |- ( ph -> ( ( th /\ ps ) <-> ( ch /\ th ) ) ) $=
      ( wa anbi2d biancomd ) ADBFCDABCDEGH $.
  $}

  $( Double commutation in conjunction.  (Contributed by Peter Mazsa,
     27-Jun-2019.) $)
  an2anr $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) <->
                 ( ( ps /\ ph ) /\ ( th /\ ch ) ) ) $=
    ( wa ancom anbi12i ) ABEBAECDEDCEABFCDFG $.

  $( Theorem *4.38 of [WhiteheadRussell] p. 118.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.38 $p |- ( ( ( ph <-> ch ) /\ ( ps <-> th ) ) ->
                ( ( ph /\ ps ) <-> ( ch /\ th ) ) ) $=
    ( wb wa simpl simpr anbi12d ) ACEZBDEZFACBDJKGJKHI $.

  ${
    bi2an9.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bi2an9.2 $e |- ( th -> ( ta <-> et ) ) $.
    $( Deduction joining two equivalences to form equivalence of conjunctions.
       (Contributed by NM, 31-Jul-1995.) $)
    bi2anan9 $p |- ( ( ph /\ th ) -> ( ( ps /\ ta ) <-> ( ch /\ et ) ) ) $=
      ( wb wa pm4.38 syl2an ) ABCIEFIBEJCFJIDGHBECFKL $.

    $( Deduction joining two equivalences to form equivalence of conjunctions.
       (Contributed by NM, 19-Feb-1996.) $)
    bi2anan9r $p |- ( ( th /\ ph ) -> ( ( ps /\ ta ) <-> ( ch /\ et ) ) ) $=
      ( wa wb bi2anan9 ancoms ) ADBEICFIJABCDEFGHKL $.

    $( Deduction joining two biconditionals with different antecedents.
       (Contributed by NM, 12-May-2004.) $)
    bi2bian9 $p |- ( ( ph /\ th ) -> ( ( ps <-> ta ) <-> ( ch <-> et ) ) ) $=
      ( wa wb adantr adantl bibi12d ) ADIBCEFABCJDGKDEFJAHLM $.
  $}

  ${
    anbiim.1 $e |- ( ph -> ( ch -> th ) ) $.
    anbiim.2 $e |- ( ps -> ( th -> ch ) ) $.
    $( Adding biconditional when antecedents are conjuncted.  (Contributed by
       metakunt, 16-Apr-2024.)  (Proof shortened by Wolf Lammen, 7-May-2025.)
       (Proof shortened by Garrett Katz, 15-Jun-2026.) $)
    anbiim $p |- ( ( ph /\ ps ) -> ( ch <-> th ) ) $=
      ( wb impbid21d impcom ) BACDGBACDEFHI $.

    $( Obsolete version of ~ anbiim as of 15-Jun-2026.  Adding biconditional
       when antecedents are conjuncted.  (Contributed by metakunt,
       16-Apr-2024.)  (Proof shortened by Wolf Lammen, 7-May-2025.)
       (New usage is discouraged.)  (Proof modification is discouraged.) $)
    anbiimOLD $p |- ( ( ph /\ ps ) -> ( ch <-> th ) ) $=
      ( wa wi adantr adantl impbid ) ABGCDACDHBEIBDCHAFJK $.
  $}

  ${
    bianass.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( An inference to merge two lists of conjuncts.  (Contributed by Giovanni
       Mascellani, 23-May-2019.) $)
    bianass $p |- ( ( et /\ ph ) <-> ( ( et /\ ps ) /\ ch ) ) $=
      ( wa anbi2i anass bitr4i ) DAFDBCFZFDBFCFAJDEGDBCHI $.

    $( An inference to merge two lists of conjuncts.  (Contributed by Peter
       Mazsa, 24-Sep-2022.) $)
    bianassc $p |- ( ( et /\ ph ) <-> ( ( ps /\ et ) /\ ch ) ) $=
      ( wa bianass ancom bianbi ) DAFDBFCBDFABCDEGDBHI $.
  $}

  $( Swap two conjuncts.  (Contributed by Peter Mazsa, 18-Sep-2022.) $)
  an21 $p |- ( ( ( ph /\ ps ) /\ ch ) <-> ( ps /\ ( ph /\ ch ) ) ) $=
    ( wa biid bianassc bicomi ) BACDZDABDCDHACBHEFG $.

  $( Swap two conjuncts.  Note that the first digit (1) in the label refers to
     the outer conjunct position, and the next digit (2) to the inner conjunct
     position.  (Contributed by NM, 12-Mar-1995.)  (Proof shortened by Peter
     Mazsa, 18-Sep-2022.) $)
  an12 $p |- ( ( ph /\ ( ps /\ ch ) ) <-> ( ps /\ ( ph /\ ch ) ) ) $=
    ( wa ancom bianass biancomi ) ABCDZDBACDHCBABCEFG $.

  $( A rearrangement of conjuncts.  (Contributed by NM, 12-Mar-1995.)  (Proof
     shortened by Wolf Lammen, 25-Dec-2012.) $)
  an32 $p |- ( ( ( ph /\ ps ) /\ ch ) <-> ( ( ph /\ ch ) /\ ps ) ) $=
    ( wa an21 biancomi ) ABDCDACDBABCEF $.

  $( A rearrangement of conjuncts.  (Contributed by NM, 24-Jun-2012.)  (Proof
     shortened by Wolf Lammen, 31-Dec-2012.) $)
  an13 $p |- ( ( ph /\ ( ps /\ ch ) ) <-> ( ch /\ ( ps /\ ph ) ) ) $=
    ( wa an21 ancom bitr3i ) ABCDDBADZCDCHDBACEHCFG $.

  $( A rearrangement of conjuncts.  (Contributed by NM, 24-Jun-2012.)  (Proof
     shortened by Wolf Lammen, 31-Dec-2012.) $)
  an31 $p |- ( ( ( ph /\ ps ) /\ ch ) <-> ( ( ch /\ ps ) /\ ph ) ) $=
    ( wa an13 anass 3bitr4i ) ABCDDCBADDABDCDCBDADABCEABCFCBAFG $.

  ${
    an12s.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Swap two conjuncts in antecedent.  The label suffix "s" means that
       ~ an12 is combined with ~ syl (or a variant).  (Contributed by NM,
       13-Mar-1996.) $)
    an12s $p |- ( ( ps /\ ( ph /\ ch ) ) -> th ) $=
      ( wa an12 sylbi ) BACFFABCFFDBACGEH $.

    $( Inference commuting a nested conjunction in antecedent.  (Contributed by
       NM, 24-May-2006.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    ancom2s $p |- ( ( ph /\ ( ch /\ ps ) ) -> th ) $=
      ( wa pm3.22 sylan2 ) CBFABCFDCBGEH $.

    $( Swap two conjuncts in antecedent.  (Contributed by NM, 31-May-2006.) $)
    an13s $p |- ( ( ch /\ ( ps /\ ph ) ) -> th ) $=
      ( exp32 com13 imp32 ) CBADABCDABCDEFGH $.
  $}

  ${
    an32s.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( Swap two conjuncts in antecedent.  (Contributed by NM, 13-Mar-1996.) $)
    an32s $p |- ( ( ( ph /\ ch ) /\ ps ) -> th ) $=
      ( wa an32 sylbi ) ACFBFABFCFDACBGEH $.

    $( Inference commuting a nested conjunction in antecedent.  (Contributed by
       NM, 24-May-2006.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    ancom1s $p |- ( ( ( ps /\ ph ) /\ ch ) -> th ) $=
      ( wa pm3.22 sylan ) BAFABFCDBAGEH $.

    $( Swap two conjuncts in antecedent.  (Contributed by NM, 31-May-2006.) $)
    an31s $p |- ( ( ( ch /\ ps ) /\ ph ) -> th ) $=
      ( exp31 com13 imp31 ) CBADABCDABCDEFGH $.
  $}

  ${
    anass1rs.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Commutative-associative law for conjunction in an antecedent.
       (Contributed by Jeff Madsen, 19-Jun-2011.) $)
    anass1rs $p |- ( ( ( ph /\ ch ) /\ ps ) -> th ) $=
      ( anassrs an32s ) ABCDABCDEFG $.
  $}

  $( Rearrangement of 4 conjuncts.  (Contributed by NM, 10-Jul-1994.) $)
  an4 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) <->
              ( ( ph /\ ch ) /\ ( ps /\ th ) ) ) $=
    ( wa anass an12 bianass bitri ) ABECDEZEABJEZEACEBDEZEABJFKCLABCDGHI $.

  $( Rearrangement of 4 conjuncts.  (Contributed by NM, 7-Feb-1996.) $)
  an42 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) <->
                 ( ( ph /\ ch ) /\ ( th /\ ps ) ) ) $=
    ( wa an4 ancom anbi2i bitri ) ABECDEEACEZBDEZEJDBEZEABCDFKLJBDGHI $.

  $( Rearrangement of 4 conjuncts.  (Contributed by Rodolfo Medina,
     24-Sep-2010.)  (Proof shortened by Andrew Salmon, 29-Jun-2011.) $)
  an43 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) <->
               ( ( ph /\ th ) /\ ( ps /\ ch ) ) ) $=
    ( wa an42 bicomi ) ADEBCEEABECDEEADBCFG $.

  $( A rearrangement of conjuncts.  (Contributed by Rodolfo Medina,
     25-Sep-2010.) $)
  an3 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) -> ( ph /\ th ) ) $=
    ( wa an43 simplbi ) ABECDEEADEBCEABCDFG $.

  ${
    an4s.1 $e |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) -> ta ) $.
    $( Inference rearranging 4 conjuncts in antecedent.  (Contributed by NM,
       10-Aug-1995.) $)
    an4s $p |- ( ( ( ph /\ ch ) /\ ( ps /\ th ) ) -> ta ) $=
      ( wa an4 sylbi ) ACGBDGGABGCDGGEACBDHFI $.
  $}

  ${
    an41r3s.1 $e |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) -> ta ) $.
    $( Inference rearranging 4 conjuncts in antecedent.  (Contributed by NM,
       10-Aug-1995.) $)
    an42s $p |- ( ( ( ph /\ ch ) /\ ( th /\ ps ) ) -> ta ) $=
      ( wa an4s ancom2s ) ACGBDEABCDEFHI $.
  $}

  $( Absorption into embedded conjunct.  (Contributed by NM, 4-Sep-1995.)
     (Proof shortened by Wolf Lammen, 16-Nov-2013.) $)
  anabs1 $p |- ( ( ( ph /\ ps ) /\ ph ) <-> ( ph /\ ps ) ) $=
    ( wa simpl pm4.71i bicomi ) ABCZGACGAABDEF $.

  $( Absorption into embedded conjunct.  (Contributed by NM, 20-Jul-1996.)
     (Proof shortened by Wolf Lammen, 9-Dec-2012.) $)
  anabs5 $p |- ( ( ph /\ ( ph /\ ps ) ) <-> ( ph /\ ps ) ) $=
    ( wa ibar bicomd pm5.32i ) AABCZBABGABDEF $.

  $( Absorption into embedded conjunct.  (Contributed by NM, 20-Jul-1996.)
     (Proof shortened by Wolf Lammen, 17-Nov-2013.) $)
  anabs7 $p |- ( ( ps /\ ( ph /\ ps ) ) <-> ( ph /\ ps ) ) $=
    ( wa simpr pm4.71ri bicomi ) ABCZBGCGBABDEF $.

  ${
    anabsan.1 $e |- ( ( ( ph /\ ph ) /\ ps ) -> ch ) $.
    $( Absorption of antecedent with conjunction.  (Contributed by NM,
       24-Mar-1996.) $)
    anabsan $p |- ( ( ph /\ ps ) -> ch ) $=
      ( wa pm4.24 sylanb ) AAAEBCAFDG $.
  $}

  ${
    anabss1.1 $e |- ( ( ( ph /\ ps ) /\ ph ) -> ch ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       20-Jul-1996.)  (Proof shortened by Wolf Lammen, 31-Dec-2012.) $)
    anabss1 $p |- ( ( ph /\ ps ) -> ch ) $=
      ( an32s anabsan ) ABCABACDEF $.
  $}

  ${
    anabss4.1 $e |- ( ( ( ps /\ ph ) /\ ps ) -> ch ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       20-Jul-1996.) $)
    anabss4 $p |- ( ( ph /\ ps ) -> ch ) $=
      ( anabss1 ancoms ) BACBACDEF $.
  $}

  ${
    anabss5.1 $e |- ( ( ph /\ ( ph /\ ps ) ) -> ch ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       10-May-1994.)  (Proof shortened by Wolf Lammen, 1-Jan-2013.) $)
    anabss5 $p |- ( ( ph /\ ps ) -> ch ) $=
      ( anassrs anabsan ) ABCAABCDEF $.
  $}

  ${
    anabsi5.1 $e |- ( ph -> ( ( ph /\ ps ) -> ch ) ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       11-Jun-1995.)  (Proof shortened by Wolf Lammen, 18-Nov-2013.) $)
    anabsi5 $p |- ( ( ph /\ ps ) -> ch ) $=
      ( wa simpl mpcom ) AABECABFDG $.
  $}

  ${
    anabsi6.1 $e |- ( ph -> ( ( ps /\ ph ) -> ch ) ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       14-Aug-2000.) $)
    anabsi6 $p |- ( ( ph /\ ps ) -> ch ) $=
      ( ancomsd anabsi5 ) ABCABACDEF $.
  $}

  ${
    anabsi7.1 $e |- ( ps -> ( ( ph /\ ps ) -> ch ) ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       20-Jul-1996.)  (Proof shortened by Wolf Lammen, 18-Nov-2013.) $)
    anabsi7 $p |- ( ( ph /\ ps ) -> ch ) $=
      ( anabsi6 ancoms ) BACBACDEF $.
  $}

  ${
    anabsi8.1 $e |- ( ps -> ( ( ps /\ ph ) -> ch ) ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       26-Sep-1999.) $)
    anabsi8 $p |- ( ( ph /\ ps ) -> ch ) $=
      ( anabsi5 ancoms ) BACBACDEF $.
  $}

  ${
    anabss7.1 $e |- ( ( ps /\ ( ph /\ ps ) ) -> ch ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       20-Jul-1996.)  (Proof shortened by Wolf Lammen, 19-Nov-2013.) $)
    anabss7 $p |- ( ( ph /\ ps ) -> ch ) $=
      ( anassrs anabss4 ) ABCBABCDEF $.
  $}

  ${
    anabsan2.1 $e |- ( ( ph /\ ( ps /\ ps ) ) -> ch ) $.
    $( Absorption of antecedent with conjunction.  (Contributed by NM,
       10-May-2004.) $)
    anabsan2 $p |- ( ( ph /\ ps ) -> ch ) $=
      ( an12s anabss7 ) ABCABBCDEF $.
  $}

  ${
    anabss3.1 $e |- ( ( ( ph /\ ps ) /\ ps ) -> ch ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       20-Jul-1996.)  (Proof shortened by Wolf Lammen, 1-Jan-2013.) $)
    anabss3 $p |- ( ( ph /\ ps ) -> ch ) $=
      ( anasss anabsan2 ) ABCABBCDEF $.
  $}

  $( Distribution of conjunction over conjunction.  (Contributed by NM,
     14-Aug-1995.) $)
  anandi $p |- ( ( ph /\ ( ps /\ ch ) ) <->
               ( ( ph /\ ps ) /\ ( ph /\ ch ) ) ) $=
    ( wa anidm anbi1i an4 bitr3i ) ABCDZDAADZIDABDACDDJAIAEFAABCGH $.

  $( Distribution of conjunction over conjunction.  (Contributed by NM,
     24-Aug-1995.) $)
  anandir $p |- ( ( ( ph /\ ps ) /\ ch ) <->
               ( ( ph /\ ch ) /\ ( ps /\ ch ) ) ) $=
    ( wa anidm anbi2i an4 bitr3i ) ABDZCDICCDZDACDBCDDJCICEFABCCGH $.

  ${
    anandis.1 $e |- ( ( ( ph /\ ps ) /\ ( ph /\ ch ) ) -> ta ) $.
    $( Inference that undistributes conjunction in the antecedent.
       (Contributed by NM, 7-Jun-2004.) $)
    anandis $p |- ( ( ph /\ ( ps /\ ch ) ) -> ta ) $=
      ( wa an4s anabsan ) ABCFDABACDEGH $.
  $}

  ${
    anandirs.1 $e |- ( ( ( ph /\ ch ) /\ ( ps /\ ch ) ) -> ta ) $.
    $( Inference that undistributes conjunction in the antecedent.
       (Contributed by NM, 7-Jun-2004.) $)
    anandirs $p |- ( ( ( ph /\ ps ) /\ ch ) -> ta ) $=
      ( wa an4s anabsan2 ) ABFCDACBCDEGH $.
  $}

  ${
    sylanl1.1 $e |- ( ph -> ps ) $.
    sylanl1.2 $e |- ( ( ( ps /\ ch ) /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 10-Mar-2005.) $)
    sylanl1 $p |- ( ( ( ph /\ ch ) /\ th ) -> ta ) $=
      ( wa anim1i sylan ) ACHBCHDEABCFIGJ $.
  $}

  ${
    sylanl2.1 $e |- ( ph -> ch ) $.
    sylanl2.2 $e |- ( ( ( ps /\ ch ) /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 1-Jan-2005.) $)
    sylanl2 $p |- ( ( ( ps /\ ph ) /\ th ) -> ta ) $=
      ( adantl syldanl ) BACDEACBFHGI $.
  $}

  ${
    sylanr1.1 $e |- ( ph -> ch ) $.
    sylanr1.2 $e |- ( ( ps /\ ( ch /\ th ) ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 9-Apr-2005.) $)
    sylanr1 $p |- ( ( ps /\ ( ph /\ th ) ) -> ta ) $=
      ( wa anim1i sylan2 ) ADHBCDHEACDFIGJ $.
  $}

  ${
    sylanr2.1 $e |- ( ph -> th ) $.
    sylanr2.2 $e |- ( ( ps /\ ( ch /\ th ) ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 9-Apr-2005.) $)
    sylanr2 $p |- ( ( ps /\ ( ch /\ ph ) ) -> ta ) $=
      ( wa anim2i sylan2 ) CAHBCDHEADCFIGJ $.
  $}

  ${
    syl6an.1 $e |- ( ph -> ps ) $.
    syl6an.2 $e |- ( ph -> ( ch -> th ) ) $.
    syl6an.3 $e |- ( ( ps /\ th ) -> ta ) $.
    $( A syllogism deduction combined with conjoining antecedents.
       (Contributed by Alan Sare, 28-Oct-2011.) $)
    syl6an $p |- ( ph -> ( ch -> ta ) ) $=
      ( ex sylsyld ) ABCDEFGBDEHIJ $.
  $}

  ${
    syl2an2r.1 $e |- ( ph -> ps ) $.
    syl2an2r.2 $e |- ( ( ph /\ ch ) -> th ) $.
    syl2an2r.3 $e |- ( ( ps /\ th ) -> ta ) $.
    $( ~ syl2anr with antecedents in standard conjunction form.  (Contributed
       by Alan Sare, 27-Aug-2016.)  (Proof shortened by Wolf Lammen,
       28-Mar-2022.) $)
    syl2an2r $p |- ( ( ph /\ ch ) -> ta ) $=
      ( sylan syldan ) ACDEGABDEFHIJ $.
  $}

  ${
    syl2an2.1 $e |- ( ph -> ps ) $.
    syl2an2.2 $e |- ( ( ch /\ ph ) -> th ) $.
    syl2an2.3 $e |- ( ( ps /\ th ) -> ta ) $.
    $( ~ syl2an with antecedents in standard conjunction form.  (Contributed by
       Alan Sare, 27-Aug-2016.) $)
    syl2an2 $p |- ( ( ch /\ ph ) -> ta ) $=
      ( wa adantl syl2anc ) CAIBDEABCFJGHK $.
  $}

  ${
    mpdan.1 $e |- ( ph -> ps ) $.
    mpdan.2 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 23-May-1999.)
       (Proof shortened by Wolf Lammen, 22-Nov-2012.) $)
    mpdan $p |- ( ph -> ch ) $=
      ( id syl2anc ) AABCAFDEG $.
  $}

  ${
    mpancom.1 $e |- ( ps -> ph ) $.
    mpancom.2 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( An inference based on modus ponens with commutation of antecedents.
       (Contributed by NM, 28-Oct-2003.)  (Proof shortened by Wolf Lammen,
       7-Apr-2013.) $)
    mpancom $p |- ( ps -> ch ) $=
      ( id syl2anc ) BABCDBFEG $.
  $}

  ${
    mpidan.1 $e |- ( ph -> ch ) $.
    mpidan.2 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( A deduction which "stacks" a hypothesis.  (Contributed by Stanislas
       Polu, 9-Mar-2020.)  (Proof shortened by Wolf Lammen, 28-Mar-2021.) $)
    mpidan $p |- ( ( ph /\ ps ) -> th ) $=
      ( wa adantr mpdan ) ABGCDACBEHFI $.
  $}

  ${
    mpan.1 $e |- ph $.
    mpan.2 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 30-Aug-1993.)
       (Proof shortened by Wolf Lammen, 7-Apr-2013.) $)
    mpan $p |- ( ps -> ch ) $=
      ( a1i mpancom ) ABCABDFEG $.
  $}

  ${
    mpan2.1 $e |- ps $.
    mpan2.2 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 16-Sep-1993.)
       (Proof shortened by Wolf Lammen, 19-Nov-2012.) $)
    mpan2 $p |- ( ph -> ch ) $=
      ( a1i mpdan ) ABCBADFEG $.
  $}

  ${
    mp2an.1 $e |- ph $.
    mp2an.2 $e |- ps $.
    mp2an.3 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       13-Apr-1995.) $)
    mp2an $p |- ch $=
      ( mpan ax-mp ) BCEABCDFGH $.
  $}

  ${
    mp4an.1 $e |- ph $.
    mp4an.2 $e |- ps $.
    mp4an.3 $e |- ch $.
    mp4an.4 $e |- th $.
    mp4an.5 $e |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by Jeff Madsen,
       15-Jun-2010.) $)
    mp4an $p |- ta $=
      ( wa pm3.2i mp2an ) ABKCDKEABFGLCDHILJM $.
  $}

  ${
    mpan2d.1 $e |- ( ph -> ch ) $.
    mpan2d.2 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( A deduction based on modus ponens.  (Contributed by NM, 12-Dec-2004.) $)
    mpan2d $p |- ( ph -> ( ps -> th ) ) $=
      ( expd mpid ) ABCDEABCDFGH $.
  $}

  ${
    mpand.1 $e |- ( ph -> ps ) $.
    mpand.2 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( A deduction based on modus ponens.  (Contributed by NM, 12-Dec-2004.)
       (Proof shortened by Wolf Lammen, 7-Apr-2013.) $)
    mpand $p |- ( ph -> ( ch -> th ) ) $=
      ( ancomsd mpan2d ) ACBDEABCDFGH $.
  $}

  ${
    mpani.1 $e |- ps $.
    mpani.2 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 10-Apr-1994.)
       (Proof shortened by Wolf Lammen, 19-Nov-2012.) $)
    mpani $p |- ( ph -> ( ch -> th ) ) $=
      ( a1i mpand ) ABCDBAEGFH $.
  $}

  ${
    mpan2i.1 $e |- ch $.
    mpan2i.2 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 10-Apr-1994.)
       (Proof shortened by Wolf Lammen, 19-Nov-2012.) $)
    mpan2i $p |- ( ph -> ( ps -> th ) ) $=
      ( a1i mpan2d ) ABCDCAEGFH $.
  $}

  ${
    mp2ani.1 $e |- ps $.
    mp2ani.2 $e |- ch $.
    mp2ani.3 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       12-Dec-2004.) $)
    mp2ani $p |- ( ph -> th ) $=
      ( mpani mpi ) ACDFABCDEGHI $.
  $}

  ${
    mp2and.1 $e |- ( ph -> ps ) $.
    mp2and.2 $e |- ( ph -> ch ) $.
    mp2and.3 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( A deduction based on modus ponens.  (Contributed by NM, 12-Dec-2004.) $)
    mp2and $p |- ( ph -> th ) $=
      ( mpand mpd ) ACDFABCDEGHI $.
  $}

  ${
    mpanl1.1 $e |- ph $.
    mpanl1.2 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 16-Aug-1994.)
       (Proof shortened by Wolf Lammen, 7-Apr-2013.) $)
    mpanl1 $p |- ( ( ps /\ ch ) -> th ) $=
      ( wa jctl sylan ) BABGCDBAEHFI $.
  $}

  ${
    mpanl2.1 $e |- ps $.
    mpanl2.2 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 16-Aug-1994.)
       (Proof shortened by Andrew Salmon, 7-May-2011.) $)
    mpanl2 $p |- ( ( ph /\ ch ) -> th ) $=
      ( wa jctr sylan ) AABGCDABEHFI $.
  $}

  ${
    mpanl12.1 $e |- ph $.
    mpanl12.2 $e |- ps $.
    mpanl12.3 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       13-Jul-2005.) $)
    mpanl12 $p |- ( ch -> th ) $=
      ( mpanl1 mpan ) BCDFABCDEGHI $.
  $}

  ${
    mpanr1.1 $e |- ps $.
    mpanr1.2 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 3-May-1994.)
       (Proof shortened by Andrew Salmon, 7-May-2011.) $)
    mpanr1 $p |- ( ( ph /\ ch ) -> th ) $=
      ( anassrs mpanl2 ) ABCDEABCDFGH $.
  $}

  ${
    mpanr2.1 $e |- ch $.
    mpanr2.2 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 3-May-1994.)
       (Proof shortened by Andrew Salmon, 7-May-2011.)  (Proof shortened by
       Wolf Lammen, 7-Apr-2013.) $)
    mpanr2 $p |- ( ( ph /\ ps ) -> th ) $=
      ( wa jctr sylan2 ) BABCGDBCEHFI $.
  $}

  ${
    mpanr12.1 $e |- ps $.
    mpanr12.2 $e |- ch $.
    mpanr12.3 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       24-Jul-2009.) $)
    mpanr12 $p |- ( ph -> th ) $=
      ( mpanr1 mpan2 ) ACDFABCDEGHI $.
  $}

  ${
    mpanlr1.1 $e |- ps $.
    mpanlr1.2 $e |- ( ( ( ph /\ ( ps /\ ch ) ) /\ th ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 30-Dec-2004.)
       (Proof shortened by Wolf Lammen, 7-Apr-2013.) $)
    mpanlr1 $p |- ( ( ( ph /\ ch ) /\ th ) -> ta ) $=
      ( wa jctl sylanl2 ) CABCHDECBFIGJ $.
  $}

  ${
    mpbirand.1 $e |- ( ph -> ch ) $.
    mpbirand.2 $e |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $.
    $( Detach truth from conjunction in biconditional.  (Contributed by Glauco
       Siliprandi, 3-Mar-2021.) $)
    mpbirand $p |- ( ph -> ( ps <-> th ) ) $=
      ( wa biantrurd bitr4d ) ABCDGDFACDEHI $.
  $}

  ${
    mpbiran2d.1 $e |- ( ph -> th ) $.
    mpbiran2d.2 $e |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $.
    $( Detach truth from conjunction in biconditional.  Deduction form.
       (Contributed by Peter Mazsa, 24-Sep-2022.) $)
    mpbiran2d $p |- ( ph -> ( ps <-> ch ) ) $=
      ( biancomd mpbirand ) ABDCEABDCFGH $.
  $}

  ${
    mpbiran.1 $e |- ps $.
    mpbiran.2 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Detach truth from conjunction in biconditional.  (Contributed by NM,
       27-Feb-1996.) $)
    mpbiran $p |- ( ph <-> ch ) $=
      ( wa biantrur bitr4i ) ABCFCEBCDGH $.
  $}

  ${
    mpbiran2.1 $e |- ch $.
    mpbiran2.2 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Detach truth from conjunction in biconditional.  (Contributed by NM,
       22-Feb-1996.) $)
    mpbiran2 $p |- ( ph <-> ps ) $=
      ( biancomi mpbiran ) ACBDACBEFG $.
  $}

  ${
    mpbir2an.1 $e |- ps $.
    mpbir2an.2 $e |- ch $.
    mpbir2an.maj $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Detach a conjunction of truths in a biconditional.  (Contributed by NM,
       10-May-2005.) $)
    mpbir2an $p |- ph $=
      ( mpbiran mpbir ) ACEABCDFGH $.
  $}

  ${
    mpbi2and.1 $e |- ( ph -> ps ) $.
    mpbi2and.2 $e |- ( ph -> ch ) $.
    mpbi2and.3 $e |- ( ph -> ( ( ps /\ ch ) <-> th ) ) $.
    $( Detach a conjunction of truths in a biconditional.  (Contributed by NM,
       6-Nov-2011.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    mpbi2and $p |- ( ph -> th ) $=
      ( wa jca mpbid ) ABCHDABCEFIGJ $.
  $}

  ${
    mpbir2and.1 $e |- ( ph -> ch ) $.
    mpbir2and.2 $e |- ( ph -> th ) $.
    mpbir2and.3 $e |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $.
    $( Detach a conjunction of truths in a biconditional.  (Contributed by NM,
       6-Nov-2011.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    mpbir2and $p |- ( ph -> ps ) $=
      ( wa jca mpbird ) ABCDHACDEFIGJ $.
  $}

  ${
    adant2.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       4-May-1994.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    adantll $p |- ( ( ( th /\ ph ) /\ ps ) -> ch ) $=
      ( wa simpr sylan ) DAFABCDAGEH $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       4-May-1994.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    adantlr $p |- ( ( ( ph /\ th ) /\ ps ) -> ch ) $=
      ( wa simpl sylan ) ADFABCADGEH $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       4-May-1994.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    adantrl $p |- ( ( ph /\ ( th /\ ps ) ) -> ch ) $=
      ( wa simpr sylan2 ) DBFABCDBGEH $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       4-May-1994.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    adantrr $p |- ( ( ph /\ ( ps /\ th ) ) -> ch ) $=
      ( wa simpl sylan2 ) BDFABCBDGEH $.
  $}

  ${
    adantl2.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 2-Dec-2012.) $)
    adantlll $p |- ( ( ( ( ta /\ ph ) /\ ps ) /\ ch ) -> th ) $=
      ( wa simpr sylanl1 ) EAGABCDEAHFI $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantllr $p |- ( ( ( ( ph /\ ta ) /\ ps ) /\ ch ) -> th ) $=
      ( wa simpl sylanl1 ) AEGABCDAEHFI $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantlrl $p |- ( ( ( ph /\ ( ta /\ ps ) ) /\ ch ) -> th ) $=
      ( wa simpr sylanl2 ) EBGABCDEBHFI $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantlrr $p |- ( ( ( ph /\ ( ps /\ ta ) ) /\ ch ) -> th ) $=
      ( wa simpl sylanl2 ) BEGABCDBEHFI $.
  $}

  ${
    adantr2.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantrll $p |- ( ( ph /\ ( ( ta /\ ps ) /\ ch ) ) -> th ) $=
      ( wa simpr sylanr1 ) EBGABCDEBHFI $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantrlr $p |- ( ( ph /\ ( ( ps /\ ta ) /\ ch ) ) -> th ) $=
      ( wa simpl sylanr1 ) BEGABCDBEHFI $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantrrl $p |- ( ( ph /\ ( ps /\ ( ta /\ ch ) ) ) -> th ) $=
      ( wa simpr sylanr2 ) ECGABCDECHFI $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantrrr $p |- ( ( ph /\ ( ps /\ ( ch /\ ta ) ) ) -> th ) $=
      ( wa simpl sylanr2 ) CEGABCDCEHFI $.
  $}

  ${
    ad2ant.1 $e |- ( ph -> ps ) $.
    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       19-Oct-1999.)  (Proof shortened by Wolf Lammen, 20-Nov-2012.) $)
    ad2antrr $p |- ( ( ( ph /\ ch ) /\ th ) -> ps ) $=
      ( adantr adantlr ) ADBCABDEFG $.

    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       19-Oct-1999.)  (Proof shortened by Wolf Lammen, 20-Nov-2012.) $)
    ad2antlr $p |- ( ( ( ch /\ ph ) /\ th ) -> ps ) $=
      ( adantr adantll ) ADBCABDEFG $.

    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       19-Oct-1999.) $)
    ad2antrl $p |- ( ( ch /\ ( ph /\ th ) ) -> ps ) $=
      ( adantl adantrr ) CABDABCEFG $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       19-Oct-1999.) $)
    ad2antll $p |- ( ( ch /\ ( th /\ ph ) ) -> ps ) $=
      ( wa adantl ) DAFBCABDEGG $.

    $( Deduction adding three conjuncts to antecedent.  (Contributed by NM,
       28-Jul-2012.) $)
    ad3antrrr $p |- ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) -> ps ) $=
      ( wa adantr ad2antrr ) ACGBDEABCFHI $.

    $( Deduction adding three conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad3antlr $p |- ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) -> ps ) $=
      ( wa adantl ad2antrr ) CAGBDEABCFHI $.

    $( Deduction adding 4 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad4antr $p |- ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et ) -> ps ) $=
      ( wa adantr ad3antrrr ) ACHBDEFABCGIJ $.

    $( Deduction adding 4 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad4antlr $p |- ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et ) -> ps ) $=
      ( wa adantl ad3antrrr ) CAHBDEFABCGIJ $.

    $( Deduction adding 5 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad5antr $p |- ( ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et )
      /\ ze ) -> ps ) $=
      ( wa adantr ad4antr ) ACIBDEFGABCHJK $.

    $( Deduction adding 5 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad5antlr $p |- ( ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et )
      /\ ze ) -> ps ) $=
      ( wa adantl ad4antr ) CAIBDEFGABCHJK $.

    $( Deduction adding 6 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad6antr $p |- ( ( ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) -> ps ) $=
      ( wa adantr ad5antr ) ACJBDEFGHABCIKL $.

    $( Deduction adding 6 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad6antlr $p |- ( ( ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) -> ps ) $=
      ( wa adantl ad5antr ) CAJBDEFGHABCIKL $.

    $( Deduction adding 7 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad7antr $p |- ( ( ( ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) -> ps ) $=
      ( wa adantr ad6antr ) ACKBDEFGHIABCJLM $.

    $( Deduction adding 7 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad7antlr $p |- ( ( ( ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) -> ps ) $=
      ( wa adantl ad6antr ) CAKBDEFGHIABCJLM $.

    $( Deduction adding 8 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad8antr $p |- ( ( ( ( ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) /\ mu ) -> ps ) $=
      ( wa adantr ad7antr ) ACLBDEFGHIJABCKMN $.

    $( Deduction adding 8 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad8antlr $p |- ( ( ( ( ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) /\ mu ) -> ps ) $=
      ( wa adantl ad7antr ) CALBDEFGHIJABCKMN $.

    $( Deduction adding 9 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad9antr $p |- ( ( ( ( ( ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) -> ps ) $=
      ( wa adantr ad8antr ) ACMBDEFGHIJKABCLNO $.

    $( Deduction adding 9 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad9antlr $p |- ( ( ( ( ( ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) -> ps ) $=
      ( wa adantl ad8antr ) CAMBDEFGHIJKABCLNO $.

    $( Deduction adding 10 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad10antr $p |- ( ( ( ( ( ( ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) /\ ka ) -> ps ) $=
      ( wa adantr ad9antr ) ACNBDEFGHIJKLABCMOP $.

    $( Deduction adding 10 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad10antlr $p |- ( ( ( ( ( ( ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) /\ ka ) -> ps ) $=
      ( wa adantl ad9antr ) CANBDEFGHIJKLABCMOP $.
  $}

  ${
    ad2ant2.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       8-Jan-2006.) $)
    ad2ant2l $p |- ( ( ( th /\ ph ) /\ ( ta /\ ps ) ) -> ch ) $=
      ( wa adantrl adantll ) AEBGCDABCEFHI $.

    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       8-Jan-2006.) $)
    ad2ant2r $p |- ( ( ( ph /\ th ) /\ ( ps /\ ta ) ) -> ch ) $=
      ( wa adantrr adantlr ) ABEGCDABCEFHI $.

    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       23-Nov-2007.) $)
    ad2ant2lr $p |- ( ( ( th /\ ph ) /\ ( ps /\ ta ) ) -> ch ) $=
      ( wa adantrr adantll ) ABEGCDABCEFHI $.

    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       24-Nov-2007.) $)
    ad2ant2rl $p |- ( ( ( ph /\ th ) /\ ( ta /\ ps ) ) -> ch ) $=
      ( wa adantrl adantlr ) AEBGCDABCEFHI $.
  $}

  ${
    adantl3r.1 $e |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $.
    $( Deduction adding 1 conjunct to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.) $)
    adantl3r $p |- ( ( ( ( ( ph /\ et ) /\ ps ) /\ ch ) /\ th ) -> ta ) $=
      ( wa id adantlr sylanl1 ) AFHBHABHZCDEABLFLIJGK $.
  $}

  ${
    ad4ant2.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant13 $p |- ( ( ( ( ph /\ th ) /\ ps ) /\ ta ) -> ch ) $=
      ( wa adantr adantllr ) ABECDABGCEFHI $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant14 $p |- ( ( ( ( ph /\ th ) /\ ta ) /\ ps ) -> ch ) $=
      ( wa adantlr ) ADGBCEABCDFHH $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant23 $p |- ( ( ( ( th /\ ph ) /\ ps ) /\ ta ) -> ch ) $=
      ( wa adantr adantlll ) ABECDABGCEFHI $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant24 $p |- ( ( ( ( th /\ ph ) /\ ta ) /\ ps ) -> ch ) $=
      ( adantlr adantlll ) AEBCDABCEFGH $.
  $}

  ${
    adantl4r.1 $e |- ( ( ( ( ( ph /\ si ) /\ rh ) /\ mu ) /\ la ) -> ka ) $.
    $( Deduction adding 1 conjunct to antecedent.  (Contributed by Thierry
       Arnoux, 11-Feb-2018.) $)
    adantl4r $p |- ( ( ( ( ( ( ph /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la )
      -> ka ) $=
      ( wa wi ex adantl3r imp ) ABICIDIEIFGACDEFGJBACIDIEIFGHKLM $.
  $}

  ${
    ad5ant2.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant13 $p |- ( ( ( ( ( ph /\ th ) /\ ps ) /\ ta ) /\ et ) -> ch ) $=
      ( wa adantlr ad2antrr ) ADHBHCEFABCDGIJ $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant14 $p |- ( ( ( ( ( ph /\ th ) /\ ta ) /\ ps ) /\ et ) -> ch ) $=
      ( wa adantlr ad4ant13 ) ADHBCEFABCDGIJ $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant15 $p |- ( ( ( ( ( ph /\ th ) /\ ta ) /\ et ) /\ ps ) -> ch ) $=
      ( wa adantlr ad4ant14 ) ADHBCEFABCDGIJ $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant23 $p |- ( ( ( ( ( th /\ ph ) /\ ps ) /\ ta ) /\ et ) -> ch ) $=
      ( wa adantll ad2antrr ) DAHBHCEFABCDGIJ $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant24 $p |- ( ( ( ( ( th /\ ph ) /\ ta ) /\ ps ) /\ et ) -> ch ) $=
      ( wa adantll ad4ant13 ) DAHBCEFABCDGIJ $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant25 $p |- ( ( ( ( ( th /\ ph ) /\ ta ) /\ et ) /\ ps ) -> ch ) $=
      ( wa adantll ad4ant14 ) DAHBCEFABCDGIJ $.
  $}

  ${
    adantl5r.1 $e |- ( ( ( ( ( ( ph /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la )
      -> ka ) $.
    $( Deduction adding 1 conjunct to antecedent.  (Contributed by Thierry
       Arnoux, 11-Feb-2018.) $)
    adantl5r $p |- ( ( ( ( ( ( ( ph /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu )
      /\ la ) -> ka ) $=
      ( wa wi ex adantl4r imp ) ABJCJDJEJFJGHABCDEFGHKACJDJEJFJGHILMN $.
  $}

  ${
    adantl6r.1 $e |- ( ( ( ( ( ( ( ph /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu )
      /\ la ) -> ka ) $.
    $( Deduction adding 1 conjunct to antecedent.  (Contributed by Thierry
       Arnoux, 11-Feb-2018.) $)
    adantl6r $p |- ( ( ( ( ( ( ( ( ph /\ ta ) /\ et ) /\ ze ) /\ si ) /\ rh )
      /\ mu ) /\ la ) -> ka ) $=
      ( wa wi ex adantl5r imp ) ABKCKDKEKFKGKHIABCDEFGHILACKDKEKFKGKHIJMNO $.
  $}

  $( Theorem *3.33 (Syll) of [WhiteheadRussell] p. 112.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.33 $p |- ( ( ( ph -> ps ) /\ ( ps -> ch ) ) -> ( ph -> ch ) ) $=
    ( wi imim1 imp ) ABDBCDACDABCEF $.

  $( Theorem *3.34 (Syll) of [WhiteheadRussell] p. 112.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.34 $p |- ( ( ( ps -> ch ) /\ ( ph -> ps ) ) -> ( ph -> ch ) ) $=
    ( wi imim2 imp ) BCDABDACDBCAEF $.

  $( Simplification of a conjunction.  (Contributed by NM, 18-Mar-2007.) $)
  simpll $p |- ( ( ( ph /\ ps ) /\ ch ) -> ph ) $=
    ( id ad2antrr ) AABCADE $.

  ${
    simplld.1 $e |- ( ph -> ( ( ps /\ ch ) /\ th ) ) $.
    $( Deduction form of ~ simpll , eliminating a double conjunct.
       (Contributed by Glauco Siliprandi, 11-Dec-2019.) $)
    simplld $p |- ( ph -> ps ) $=
      ( wa simpld ) ABCABCFDEGG $.
  $}

  $( Simplification of a conjunction.  (Contributed by NM, 20-Mar-2007.) $)
  simplr $p |- ( ( ( ph /\ ps ) /\ ch ) -> ps ) $=
    ( id ad2antlr ) BBACBDE $.

  ${
    simplrd.1 $e |- ( ph -> ( ( ps /\ ch ) /\ th ) ) $.
    $( Deduction eliminating a double conjunct.  (Contributed by Glauco
       Siliprandi, 11-Dec-2019.) $)
    simplrd $p |- ( ph -> ch ) $=
      ( wa simpld simprd ) ABCABCFDEGH $.
  $}

  $( Simplification of a conjunction.  (Contributed by NM, 21-Mar-2007.) $)
  simprl $p |- ( ( ph /\ ( ps /\ ch ) ) -> ps ) $=
    ( id ad2antrl ) BBACBDE $.

  ${
    simprld.1 $e |- ( ph -> ( ps /\ ( ch /\ th ) ) ) $.
    $( Deduction eliminating a double conjunct.  (Contributed by Glauco
       Siliprandi, 11-Dec-2019.) $)
    simprld $p |- ( ph -> ch ) $=
      ( wa simprd simpld ) ACDABCDFEGH $.
  $}

  $( Simplification of a conjunction.  (Contributed by NM, 21-Mar-2007.) $)
  simprr $p |- ( ( ph /\ ( ps /\ ch ) ) -> ch ) $=
    ( id ad2antll ) CCABCDE $.

  ${
    simprrd.1 $e |- ( ph -> ( ps /\ ( ch /\ th ) ) ) $.
    $( Deduction form of ~ simprr , eliminating a double conjunct.
       (Contributed by Glauco Siliprandi, 11-Dec-2019.) $)
    simprrd $p |- ( ph -> th ) $=
      ( wa simprd ) ACDABCDFEGG $.
  $}

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.)  (Proof shortened by Wolf Lammen, 6-Apr-2022.) $)
  simplll $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ph ) $=
    ( id ad3antrrr ) AABCDAEF $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.)  (Proof shortened by Wolf Lammen, 6-Apr-2022.) $)
  simpllr $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ps ) $=
    ( id ad3antlr ) BBACDBEF $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.) $)
  simplrl $p |- ( ( ( ph /\ ( ps /\ ch ) ) /\ th ) -> ps ) $=
    ( wa simpl ad2antlr ) BCEBADBCFG $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.) $)
  simplrr $p |- ( ( ( ph /\ ( ps /\ ch ) ) /\ th ) -> ch ) $=
    ( wa simpr ad2antlr ) BCECADBCFG $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.) $)
  simprll $p |- ( ( ph /\ ( ( ps /\ ch ) /\ th ) ) -> ps ) $=
    ( wa simpl ad2antrl ) BCEBADBCFG $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.) $)
  simprlr $p |- ( ( ph /\ ( ( ps /\ ch ) /\ th ) ) -> ch ) $=
    ( wa simpr ad2antrl ) BCECADBCFG $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.) $)
  simprrl $p |- ( ( ph /\ ( ps /\ ( ch /\ th ) ) ) -> ch ) $=
    ( wa simpl ad2antll ) CDECABCDFG $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.) $)
  simprrr $p |- ( ( ph /\ ( ps /\ ( ch /\ th ) ) ) -> th ) $=
    ( wa simpr ad2antll ) CDEDABCDFG $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-4l $p |- ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta ) -> ph ) $=
    ( id ad4antr ) AABCDEAFG $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-4r $p |- ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta ) -> ps ) $=
    ( id ad4antlr ) BBACDEBFG $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-5l $p |- ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) -> ph ) $=
    ( id ad5antr ) AABCDEFAGH $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-5r $p |- ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) -> ps ) $=
    ( id ad5antlr ) BBACDEFBGH $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-6l $p |- ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) -> ph ) $=
    ( id ad6antr ) AABCDEFGAHI $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-6r $p |- ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) -> ps ) $=
    ( id ad6antlr ) BBACDEFGBHI $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-7l $p |- ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) -> ph ) $=
    ( id ad7antr ) AABCDEFGHAIJ $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-7r $p |- ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) -> ps ) $=
    ( id ad7antlr ) BBACDEFGHBIJ $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-8l $p |- ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) -> ph ) $=
    ( id ad8antr ) AABCDEFGHIAJK $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-8r $p |- ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) -> ps ) $=
    ( id ad8antlr ) BBACDEFGHIBJK $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-9l $p |- ( ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu ) -> ph ) $=
    ( id ad9antr ) AABCDEFGHIJAKL $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-9r $p |- ( ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu ) -> ps ) $=
    ( id ad9antlr ) BBACDEFGHIJBKL $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-10l $p |- ( ( ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) -> ph ) $=
    ( id ad10antr ) AABCDEFGHIJKALM $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-10r $p |- ( ( ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) -> ps ) $=
    ( id ad10antlr ) BBACDEFGHIJKBLM $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-11l $p |- ( ( ( ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) /\ ka ) -> ph ) $=
    ( wa simpl ad10antr ) ABMACDEFGHIJKLABNO $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-11r $p |- ( ( ( ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) /\ ka ) -> ps ) $=
    ( wa simpr ad10antr ) ABMBCDEFGHIJKLABNO $.

$( Restating theorems using conjunction. $)

  ${
    pm2.01da.1 $e |- ( ( ph /\ ps ) -> -. ps ) $.
    $( Deduction based on reductio ad absurdum.  See ~ pm2.01 .  (Contributed
       by Mario Carneiro, 9-Feb-2017.) $)
    pm2.01da $p |- ( ph -> -. ps ) $=
      ( wn ex pm2.01d ) ABABBDCEF $.
  $}

  ${
    pm2.18da.1 $e |- ( ( ph /\ -. ps ) -> ps ) $.
    $( Deduction based on reductio ad absurdum.  See ~ pm2.18 .  (Contributed
       by Mario Carneiro, 9-Feb-2017.) $)
    pm2.18da $p |- ( ph -> ps ) $=
      ( wn ex pm2.18d ) ABABDBCEF $.
  $}

  ${
    impbida.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    impbida.2 $e |- ( ( ph /\ ch ) -> ps ) $.
    $( Deduce an equivalence from two implications.  Variant of ~ impbid .
       (Contributed by NM, 17-Feb-2007.) $)
    impbida $p |- ( ph -> ( ps <-> ch ) ) $=
      ( ex impbid ) ABCABCDFACBEFG $.
  $}

  ${
    pm5.21nd.1 $e |- ( ( ph /\ ps ) -> th ) $.
    pm5.21nd.2 $e |- ( ( ph /\ ch ) -> th ) $.
    pm5.21nd.3 $e |- ( th -> ( ps <-> ch ) ) $.
    $( Eliminate an antecedent implied by each side of a biconditional.
       Variant of ~ pm5.21ndd .  (Contributed by NM, 20-Nov-2005.)  (Proof
       shortened by Wolf Lammen, 4-Nov-2013.) $)
    pm5.21nd $p |- ( ph -> ( ps <-> ch ) ) $=
      ( ex wb wi a1i pm5.21ndd ) ADBCABDEHACDFHDBCIJAGKL $.
  $}

  $( Conjunctive detachment.  Theorem *3.35 of [WhiteheadRussell] p. 112.
     Variant of ~ pm2.27 .  (Contributed by NM, 14-Dec-2002.) $)
  pm3.35 $p |- ( ( ph /\ ( ph -> ps ) ) -> ps ) $=
    ( wi pm2.27 imp ) AABCBABDE $.

  ${
    pm5.74da.1 $e |- ( ( ph /\ ps ) -> ( ch <-> th ) ) $.
    $( Distribution of implication over biconditional (deduction form).
       Variant of ~ pm5.74d .  (Contributed by NM, 4-May-2007.) $)
    pm5.74da $p |- ( ph -> ( ( ps -> ch ) <-> ( ps -> th ) ) ) $=
      ( wb ex pm5.74d ) ABCDABCDFEGH $.
  $}

  $( Theorem *4.22 of [WhiteheadRussell] p. 117. ~ bitri in closed form.
     (Contributed by NM, 3-Jan-2005.) $)
  bitr $p |- ( ( ( ph <-> ps ) /\ ( ps <-> ch ) ) -> ( ph <-> ch ) ) $=
    ( wb bibi1 biimpar ) ABDACDBCDABCEF $.

  $( A transitive law of equivalence.  Compare Theorem *4.22 of
     [WhiteheadRussell] p. 117.  (Contributed by NM, 18-Aug-1993.) $)
  biantr $p |- ( ( ( ph <-> ps ) /\ ( ch <-> ps ) ) -> ( ph <-> ch ) ) $=
    ( wb id bibi2d biimparc ) CBDZACDABDHCBAHEFG $.

  $( Theorem *4.14 of [WhiteheadRussell] p. 117.  Related to ~ con34b .
     (Contributed by NM, 3-Jan-2005.)  (Proof shortened by Wolf Lammen,
     23-Oct-2012.) $)
  pm4.14 $p |- ( ( ( ph /\ ps ) -> ch ) <-> ( ( ph /\ -. ch ) -> -. ps ) ) $=
    ( wi wn wa con34b imbi2i impexp 3bitr4i ) ABCDZDACEZBEZDZDABFCDALFMDKNABCGH
    ABCIALMIJ $.

  $( Theorem *3.37 (Transp) of [WhiteheadRussell] p. 112.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 23-Oct-2012.) $)
  pm3.37 $p |- ( ( ( ph /\ ps ) -> ch ) -> ( ( ph /\ -. ch ) -> -. ps ) ) $=
    ( wa wi wn pm4.14 biimpi ) ABDCEACFDBFEABCGH $.

  $( Conjoin antecedents and consequents of two premises.  This is the closed
     theorem form of ~ anim12d .  Theorem *3.47 of [WhiteheadRussell] p. 113.
     It was proved by Leibniz, and it evidently pleased him enough to call it
     _praeclarum theorema_ (splendid theorem).  (Contributed by NM,
     12-Aug-1993.)  (Proof shortened by Wolf Lammen, 7-Apr-2013.) $)
  anim12 $p |- ( ( ( ph -> ps ) /\ ( ch -> th ) )
              -> ( ( ph /\ ch ) -> ( ps /\ th ) ) ) $=
    ( wi id im2anan9 ) ABEZABCDEZCDHFIFG $.

$( Replacing conjunction. $)

  $( Conjunction implies implication.  Theorem *3.4 of [WhiteheadRussell]
     p. 113.  (Contributed by NM, 31-Jul-1995.) $)
  pm3.4 $p |- ( ( ph /\ ps ) -> ( ph -> ps ) ) $=
    ( wa simpr a1d ) ABCBAABDE $.

  ${
    exbiri.1 $e |- ( ( ph /\ ps ) -> ( ch <-> th ) ) $.
    $( Inference form of ~ exbir .  This proof is ~ exbiriVD automatically
       translated and minimized.  (Contributed by Alan Sare, 31-Dec-2011.)
       (Proof shortened by Wolf Lammen, 27-Jan-2013.) $)
    exbiri $p |- ( ph -> ( ps -> ( th -> ch ) ) ) $=
      ( wa biimpar exp31 ) ABDCABFCDEGH $.
  $}

$( Contradiction using conjunction. $)

  ${
    pm2.61ian.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    pm2.61ian.2 $e |- ( ( -. ph /\ ps ) -> ch ) $.
    $( Elimination of an antecedent.  (Contributed by NM, 1-Jan-2005.) $)
    pm2.61ian $p |- ( ps -> ch ) $=
      ( wi ex wn pm2.61i ) ABCFABCDGAHBCEGI $.
  $}

  ${
    pm2.61dan.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    pm2.61dan.2 $e |- ( ( ph /\ -. ps ) -> ch ) $.
    $( Elimination of an antecedent.  (Contributed by NM, 1-Jan-2005.) $)
    pm2.61dan $p |- ( ph -> ch ) $=
      ( ex wn pm2.61d ) ABCABCDFABGCEFH $.
  $}

  ${
    pm2.61ddan.1 $e |- ( ( ph /\ ps ) -> th ) $.
    pm2.61ddan.2 $e |- ( ( ph /\ ch ) -> th ) $.
    pm2.61ddan.3 $e |- ( ( ph /\ ( -. ps /\ -. ch ) ) -> th ) $.
    $( Elimination of two antecedents.  (Contributed by NM, 9-Jul-2013.) $)
    pm2.61ddan $p |- ( ph -> th ) $=
      ( wn wa adantlr anassrs pm2.61dan ) ABDEABHZICDACDMFJAMCHDGKLL $.
  $}

  ${
    pm2.61dda.1 $e |- ( ( ph /\ -. ps ) -> th ) $.
    pm2.61dda.2 $e |- ( ( ph /\ -. ch ) -> th ) $.
    pm2.61dda.3 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Elimination of two antecedents.  (Contributed by NM, 9-Jul-2013.) $)
    pm2.61dda $p |- ( ph -> th ) $=
      ( wa anassrs wn adantlr pm2.61dan ) ABDABHCDABCDGIACJDBFKLEL $.
  $}

  ${
    mtand.1 $e |- ( ph -> -. ch ) $.
    mtand.2 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( A modus tollens deduction.  (Contributed by Jeff Hankins,
       19-Aug-2009.) $)
    mtand $p |- ( ph -> -. ps ) $=
      ( ex mtod ) ABCDABCEFG $.
  $}

  ${
    pm2.65da.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    pm2.65da.2 $e |- ( ( ph /\ ps ) -> -. ch ) $.
    $( Deduction for proof by contradiction.  (Contributed by NM,
       12-Jun-2014.) $)
    pm2.65da $p |- ( ph -> -. ps ) $=
      ( ex wn pm2.65d ) ABCABCDFABCGEFH $.
  $}

  ${
    condan.1 $e |- ( ( ph /\ -. ps ) -> ch ) $.
    condan.2 $e |- ( ( ph /\ -. ps ) -> -. ch ) $.
    $( Proof by contradiction.  (Contributed by NM, 9-Feb-2006.)  (Proof
       shortened by Wolf Lammen, 19-Jun-2014.) $)
    condan $p |- ( ph -> ps ) $=
      ( wn pm2.65da notnotrd ) ABABFCDEGH $.
  $}

$( Relation of conjunction to biconditional. $)

  $( An implication is equivalent to the equivalence of some implied
     equivalence and some other equivalence involving a conjunction.  A utility
     lemma as illustrated in ~ biadanii and ~ elelb .  (Contributed by BJ,
     4-Mar-2023.)  (Proof shortened by Wolf Lammen, 8-Mar-2023.) $)
  biadan $p |- ( ( ph -> ps ) <->
                   ( ( ps -> ( ph <-> ch ) ) <-> ( ph <-> ( ps /\ ch ) ) ) ) $=
    ( wi wa wb pm4.71r bicom pm5.32 bibi12i biluk 3bitr4ri 3bitri ) ABDABAEZFNA
    FZBACFDZABCEZFZFZABGANHRPFQAFZNQFZFSORTPUAAQHBACIJPRHNAQKLM $.

  ${
    biadani.1 $e |- ( ph -> ps ) $.
    $( Inference associated with ~ biadan .  (Contributed by BJ,
       4-Mar-2023.) $)
    biadani $p |- ( ( ps -> ( ph <-> ch ) ) <-> ( ph <-> ( ps /\ ch ) ) ) $=
      ( wi wb wa biadan mpbi ) ABEBACFEABCGFFDABCHI $.

    $( Alternate proof of ~ biadani not using ~ biadan .  (Contributed by BJ,
       4-Mar-2023.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    biadaniALT $p |- ( ( ps -> ( ph <-> ch ) ) <-> ( ph <-> ( ps /\ ch ) ) ) $=
      ( wb wi wa pm5.32 pm4.71ri bibi1i bitr4i ) BACEFBAGZBCGZEAMEBACHALMABDIJK
      $.

    biadanii.2 $e |- ( ps -> ( ph <-> ch ) ) $.
    $( Inference associated with ~ biadani .  Add a conjunction to an
       equivalence.  (Contributed by Jeff Madsen, 20-Jun-2011.)  (Proof
       shortened by BJ, 4-Mar-2023.) $)
    biadanii $p |- ( ph <-> ( ps /\ ch ) ) $=
      ( wb wi wa biadani mpbi ) BACFGABCHFEABCDIJ $.
  $}

  ${
    biadanid.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    biadanid.2 $e |- ( ( ph /\ ch ) -> ( ps <-> th ) ) $.
    $( Deduction associated with ~ biadani .  Add a conjunction to an
       equivalence.  (Contributed by Thierry Arnoux, 16-Jun-2024.) $)
    biadanid $p |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $=
      ( wa biimpa an32s mpdan jca biimpar anasss impbida ) ABCDGABGZCDEOCDEACBD
      ACGZBDFHIJKACDBPBDFLMN $.
  $}

  $( Two propositions are equivalent if they are both true.  Theorem *5.1 of
     [WhiteheadRussell] p. 123.  (Contributed by NM, 21-May-1994.) $)
  pm5.1 $p |- ( ( ph /\ ps ) -> ( ph <-> ps ) ) $=
    ( wb pm5.501 biimpa ) ABABCABDE $.

  $( Two propositions are equivalent if they are both false.  Theorem *5.21 of
     [WhiteheadRussell] p. 124.  (Contributed by NM, 21-May-1994.) $)
  pm5.21 $p |- ( ( -. ph /\ -. ps ) -> ( ph <-> ps ) ) $=
    ( wn wb pm5.21im imp ) ACBCABDABEF $.

  $( Theorem *5.35 of [WhiteheadRussell] p. 125.  Closed form of ~ 2thd .
     (Contributed by NM, 3-Jan-2005.) $)
  pm5.35 $p |- ( ( ( ph -> ps ) /\ ( ph -> ch ) ) ->
                ( ph -> ( ps <-> ch ) ) ) $=
    ( wi wa pm5.1 pm5.74rd ) ABDZACDZEABCHIFG $.

  $( Introduce one conjunct as an antecedent to the other.  "abai" stands for
     "and, biconditional, and, implication".  (Contributed by NM, 12-Aug-1993.)
     (Proof shortened by Wolf Lammen, 7-Dec-2012.) $)
  abai $p |- ( ( ph /\ ps ) <-> ( ph /\ ( ph -> ps ) ) ) $=
    ( wi biimt pm5.32i ) ABABCABDE $.

  $( Introduce one conjunct as equivalent to the other.  "abab" stands for
     "and, biconditional, and, biconditional".  (Contributed by Wolf Lammen,
     4-Jun-2026.) $)
  abab $p |- ( ( ph /\ ps ) <-> ( ph /\ ( ph <-> ps ) ) ) $=
    ( wa wb simpl pm5.1 jca wi biimp anim2i abai sylibr impbii ) ABCZAABDZCZNAO
    ABEABFGPAABHZCNOQAABIJABKLM $.

  $( Conjunction with implication.  Compare Theorem *4.45 of [WhiteheadRussell]
     p. 119.  (Contributed by NM, 17-May-1998.) $)
  pm4.45im $p |- ( ph <-> ( ph /\ ( ps -> ph ) ) ) $=
    ( wi ax-1 pm4.71i ) ABACABDE $.

  $( An implication and its reverse are equivalent exactly when both operands
     are equivalent.  The right hand side resembles that of ~ dfbi2 , but
     ` <-> ` is a weaker operator than ` /\ ` .  Note that an implication and
     its reverse can never be simultaneously false, because of ~ pm2.521 .
     (Contributed by Wolf Lammen, 18-Dec-2023.) $)
  impimprbi $p |- ( ( ph <-> ps ) <-> ( ( ph -> ps ) <-> ( ps -> ph ) ) ) $=
    ( wb wi wa dfbi2 pm5.1 sylbi impbi wn pm2.521 pm2.24d bija impbii ) ABCZABD
    ZBADZCZOPQERABFPQGHPQOABIPJQOABKLMN $.

$( Moving subexpressions in/out of a conjunction. $)

  $( Theorem to move a conjunct in and out of a negation.  (Contributed by NM,
     9-Nov-2003.) $)
  nan $p |- ( ( ph -> -. ( ps /\ ch ) ) <-> ( ( ph /\ ps ) -> -. ch ) ) $=
    ( wa wn wi impexp imnan imbi2i bitr2i ) ABDCEZFABKFZFABCDEZFABKGLMABCHIJ $.

  $( Theorem *5.31 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.31 $p |- ( ( ch /\ ( ph -> ps ) ) -> ( ph -> ( ps /\ ch ) ) ) $=
    ( wi wa simpr simpl jctird ) CABDZEABCCIFCIGH $.

  $( Variant of ~ pm5.31 .  (Contributed by Rodolfo Medina, 15-Oct-2010.) $)
  pm5.31r $p |- ( ( ch /\ ( ph -> ps ) ) -> ( ph -> ( ch /\ ps ) ) ) $=
    ( wi ax-1 id anim12ii ) CACABDZBCAEHFG $.

  $( Theorem *4.15 of [WhiteheadRussell] p. 117.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 18-Nov-2012.) $)
  pm4.15 $p |- ( ( ( ph /\ ps ) -> -. ch ) <-> ( ( ps /\ ch ) -> -. ph ) ) $=
    ( wa wn wi con2b nan bitr2i ) BCDZAEFAJEFABDCEFJAGABCHI $.

  $( Theorem *5.36 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.36 $p |- ( ( ph /\ ( ph <-> ps ) ) <-> ( ps /\ ( ph <-> ps ) ) ) $=
    ( wb id pm5.32ri ) ABCZABFDE $.

$( Absorption in conjunction. $)

  $( A conjunction with a negated conjunction.  (Contributed by AV,
     8-Mar-2022.)  (Proof shortened by Wolf Lammen, 1-Apr-2022.) $)
  annotanannot $p |- ( ( ph /\ -. ( ph /\ ps ) ) <-> ( ph /\ -. ps ) ) $=
    ( wa wn ibar bicomd notbid pm5.32i ) AABCZDBDAIBABIABEFGH $.

  $( Theorem *5.33 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.33 $p |- ( ( ph /\ ( ps -> ch ) ) <->
                ( ph /\ ( ( ph /\ ps ) -> ch ) ) ) $=
    ( wi wa ibar imbi1d pm5.32i ) ABCDABEZCDABICABFGH $.

$( Miscellaneous theorems using conjunction. $)

  ${
    syl12anc.1 $e |- ( ph -> ps ) $.
    syl12anc.2 $e |- ( ph -> ch ) $.
    syl12anc.3 $e |- ( ph -> th ) $.
    ${
      syl12anc.4 $e |- ( ( ps /\ ( ch /\ th ) ) -> ta ) $.
      $( Syllogism combined with contraction.  (Contributed by Jeff Hankins,
         1-Aug-2009.) $)
      syl12anc $p |- ( ph -> ta ) $=
        ( wa jca syl2anc ) ABCDJEFACDGHKIL $.
    $}

    ${
      syl21anc.4 $e |- ( ( ( ps /\ ch ) /\ th ) -> ta ) $.
      $( Syllogism combined with contraction.  (Contributed by Jeff Hankins,
         1-Aug-2009.) $)
      syl21anc $p |- ( ph -> ta ) $=
        ( wa jca syl2anc ) ABCJDEABCFGKHIL $.
    $}

    ${
      syl22anc.4 $e |- ( ph -> ta ) $.
      syl22anc.5 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta ) ) -> et ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl22anc $p |- ( ph -> et ) $=
        ( wa jca syl12anc ) ABCLDEFABCGHMIJKN $.
    $}
  $}

  ${
    bibiad.1 $e |- ( ( ph /\ ps ) -> th ) $.
    bibiad.2 $e |- ( ( ph /\ ch ) -> th ) $.
    bibiad.3 $e |- ( ( ph /\ th ) -> ( ps <-> ch ) ) $.
    $( Eliminate an hypothesis ` th ` in a biconditional.  (Contributed by
       Thierry Arnoux, 4-May-2025.) $)
    bibiad $p |- ( ph -> ( ps <-> ch ) ) $=
      ( wa simpl simpr biimpa syl21anc biimpar impbida ) ABCABHADBCABIEABJADHZB
      CGKLACHADCBACIFACJOBCGMLN $.
  $}

  ${
    syl1111anc.1 $e |- ( ph -> ps ) $.
    syl1111anc.2 $e |- ( ph -> ch ) $.
    syl1111anc.3 $e |- ( ph -> th ) $.
    syl1111anc.4 $e |- ( ph -> ta ) $.
    syl1111anc.5 $e |- ( ( ( ( ps /\ ch ) /\ th ) /\ ta ) -> et ) $.
    $( Four-hypothesis elimination deduction for an assertion with a singleton
       virtual hypothesis collection.  Similar to ~ syl112anc except the
       unification theorem uses left-nested conjunction.  (Contributed by Alan
       Sare, 17-Oct-2017.) $)
    syl1111anc $p |- ( ph -> et ) $=
      ( wa jca syl21anc ) ABCLDEFABCGHMIJKN $.
  $}

  ${
    syldbl2.1 $e |- ( ( ph /\ ps ) -> ( ps -> th ) ) $.
    $( Stacked hypotheseis implies goal.  (Contributed by Stanislas Polu,
       9-Mar-2020.) $)
    syldbl2 $p |- ( ( ph /\ ps ) -> th ) $=
      ( wa com12 anabsi7 ) ABCABEBCDFG $.
  $}

  ${
    mpsyl4anc.1 $e |- ph $.
    mpsyl4anc.2 $e |- ps $.
    mpsyl4anc.3 $e |- ch $.
    mpsyl4anc.4 $e |- ( th -> ta ) $.
    mpsyl4anc.5 $e |- ( ( ( ( ph /\ ps ) /\ ch ) /\ ta ) -> et ) $.
    $( An elimination deduction.  (Contributed by Alan Sare, 17-Oct-2017.) $)
    mpsyl4anc $p |- ( th -> et ) $=
      ( a1i syl1111anc ) DABCEFADGLBDHLCDILJKM $.
  $}

  $( Theorem *4.87 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Eric Schmidt, 26-Oct-2006.) $)
  pm4.87 $p |- ( ( ( ( ( ph /\ ps ) -> ch ) <-> ( ph -> ( ps -> ch ) ) ) /\
                ( ( ph -> ( ps -> ch ) ) <-> ( ps -> ( ph -> ch ) ) ) ) /\
                ( ( ps -> ( ph -> ch ) ) <-> ( ( ps /\ ph ) -> ch ) ) ) $=
    ( wa wi wb impexp bi2.04 pm3.2i bicomi ) ABDCEABCEEZFZKBACEEZFZDMBADCEZFLNA
    BCGABCHIOMBACGJI $.

  $( Removal of conjunct from one side of an equivalence.  (Contributed by NM,
     21-Jun-1993.) $)
  bimsc1 $p |- ( ( ( ph -> ps ) /\ ( ch <-> ( ps /\ ph ) ) )
               -> ( ch <-> ph ) ) $=
    ( wa wb wi id simpr ancr impbid2 sylan9bbr ) CBADZEZCLABFZAMGNLABAHABIJK $.

  ${
    a2and.1 $e |- ( ph -> ( ( ps /\ rh ) -> ( ta -> th ) ) ) $.
    a2and.2 $e |- ( ph -> ( ( ps /\ rh ) -> ch ) ) $.
    $( Deduction distributing a conjunction as embedded antecedent.
       (Contributed by AV, 25-Oct-2019.)  (Proof shortened by Wolf Lammen,
       19-Jan-2020.) $)
    a2and $p |- ( ph -> ( ( ( ps /\ ch ) -> ta )
                            -> ( ( ps /\ rh ) -> th ) ) ) $=
      ( wa wi expd imdistand imim1 com3l syl6c com23 ) ABFIZBCIZEJZDAQEDJZRSDJG
      ABFCABFCHKLSTRDREDMNOP $.
  $}

  ${
    animpimp2impd.1 $e |- ( ( ps /\ ph ) -> ( ch -> ( th -> et ) ) ) $.
    animpimp2impd.2 $e |- ( ( ps /\ ( ph /\ th ) ) -> ( et -> ta ) ) $.
    $( Deduction deriving nested implications from conjunctions.  (Contributed
       by AV, 21-Aug-2022.) $)
    animpimp2impd $p |- ( ph -> ( ( ps -> ch ) -> ( ps -> ( th -> ta ) ) ) ) $=
      ( wi wa expr a2d syld expcom ) ABCDEIZBACOIBAJZCDFIOGPDFEBADFEIHKLMNL $.
  $}


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical disjunction
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  This section defines disjunction of two formulas, denoted by infix " ` \/ ` "
  and read "or".  It is defined in terms of implication and negation, which is
  possible in classical logic (but not in intuitionistic logic: see iset.mm).
  This section contains only theorems proved without ~ df-an (theorems that are
  proved using ~ df-an are deferred to the next section).  Basic theorems that
  help simplifying and applying disjunction are ~ olc , ~ orc , and ~ orcom .

  As mentioned in the "note on definitions" in the section comment for logical
  equivalence, all theorems in this and the previous section can be stated in
  terms of implication and negation only.  Additionally, in classical logic
  (but not in intuitionistic logic: see iset.mm), it is also possible to
  translate conjunction into disjunction and conversely via the De Morgan law
  ~ anor : conjunction and disjunction are dual connectives.  Either is
  sufficient to develop all propositional calculus of the logic (together with
  implication and negation).  In practice, conjunction is more efficient, its
  big advantage being the possibility to use it to group antecedents in a
  convenient way, using ~ imp and ~ ex as noted in the previous section.

  An illustration of the conservativity of ~ df-an is given by ~ orim12dALT ,
  which is an alternate proof of ~ orim12d not using ~ df-an .

$)

  $( Declare connectives for disjunction ("or"). $)
  $c \/ $.  $( Vee (read:  "or") $)

  $( Extend wff definition to include disjunction ("or"). $)
  wo $a wff ( ph \/ ps ) $.

  $( Define disjunction (logical "or").  Definition of [Margaris] p. 49.  When
     the left operand, right operand, or both are true, the result is true;
     when both sides are false, the result is false.  For example, it is true
     that ` ( 2 = 3 \/ 4 = 4 ) ` ( ~ ex-or ).  After we define the constant
     true ` T. ` ( ~ df-tru ) and the constant false ` F. ` ( ~ df-fal ), we
     will be able to prove these truth table values:
     ` ( ( T. \/ T. ) <-> T. ) ` ( ~ truortru ), ` ( ( T. \/ F. ) <-> T. ) `
     ( ~ truorfal ), ` ( ( F. \/ T. ) <-> T. ) ` ( ~ falortru ), and
     ` ( ( F. \/ F. ) <-> F. ) ` ( ~ falorfal ).

     Contrast with ` /\ ` ( ~ df-an ), ` -> ` ( ~ wi ), ` -/\ ` ( ~ df-nan ),
     and ` \/_ ` ( ~ df-xor ).  (Contributed by NM, 27-Dec-1992.) $)
  df-or $a |- ( ( ph \/ ps ) <-> ( -. ph -> ps ) ) $.

  $( Theorem *4.64 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.64 $p |- ( ( -. ph -> ps ) <-> ( ph \/ ps ) ) $=
    ( wo wn wi df-or bicomi ) ABCADBEABFG $.

  $( Theorem *4.66 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.66 $p |- ( ( -. ph -> -. ps ) <-> ( ph \/ -. ps ) ) $=
    ( wn pm4.64 ) ABCD $.

  $( Theorem *2.53 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.53 $p |- ( ( ph \/ ps ) -> ( -. ph -> ps ) ) $=
    ( wo wn wi df-or biimpi ) ABCADBEABFG $.

  $( Theorem *2.54 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.54 $p |- ( ( -. ph -> ps ) -> ( ph \/ ps ) ) $=
    ( wo wn wi df-or biimpri ) ABCADBEABFG $.

  $( Implication in terms of disjunction.  Theorem *4.6 of [WhiteheadRussell]
     p. 120.  (Contributed by NM, 3-Jan-1993.) $)
  imor $p |- ( ( ph -> ps ) <-> ( -. ph \/ ps ) ) $=
    ( wi wn wo notnotb imbi1i df-or bitr4i ) ABCADZDZBCJBEAKBAFGJBHI $.

  ${
    imori.1 $e |- ( ph -> ps ) $.
    $( Infer disjunction from implication.  (Contributed by NM,
       12-Mar-2012.) $)
    imori $p |- ( -. ph \/ ps ) $=
      ( wi wn wo imor mpbi ) ABDAEBFCABGH $.
  $}

  ${
    imorri.1 $e |- ( -. ph \/ ps ) $.
    $( Infer implication from disjunction.  (Contributed by Jonathan Ben-Naim,
       3-Jun-2011.) $)
    imorri $p |- ( ph -> ps ) $=
      ( wi wn wo imor mpbir ) ABDAEBFCABGH $.
  $}

  $( Theorem *4.62 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.62 $p |- ( ( ph -> -. ps ) <-> ( -. ph \/ -. ps ) ) $=
    ( wn imor ) ABCD $.

  ${
    jaoi.1 $e |- ( ph -> ps ) $.
    jaoi.2 $e |- ( ch -> ps ) $.
    $( Inference disjoining the antecedents of two implications.  (Contributed
       by NM, 5-Apr-1994.) $)
    jaoi $p |- ( ( ph \/ ch ) -> ps ) $=
      ( wo wn pm2.53 syl6 pm2.61d2 ) ACFZABKAGCBACHEIDJ $.
  $}

  ${
    jao1i.1 $e |- ( ps -> ( ch -> ph ) ) $.
    $( Add a disjunct in the antecedent of an implication.  (Contributed by
       Rodolfo Medina, 24-Sep-2010.) $)
    jao1i $p |- ( ( ph \/ ps ) -> ( ch -> ph ) ) $=
      ( wi ax-1 jaoi ) ACAEBACFDG $.
  $}

  ${
    jaod.1 $e |- ( ph -> ( ps -> ch ) ) $.
    jaod.2 $e |- ( ph -> ( th -> ch ) ) $.
    $( Deduction disjoining the antecedents of two implications.  (Contributed
       by NM, 18-Aug-1994.) $)
    jaod $p |- ( ph -> ( ( ps \/ th ) -> ch ) ) $=
      ( wo wi com12 jaoi ) BDGACBACHDABCEIADCFIJI $.

    jaod.3 $e |- ( ph -> ( ps \/ th ) ) $.
    $( Eliminate a disjunction in a deduction.  (Contributed by Mario Carneiro,
       29-May-2016.) $)
    mpjaod $p |- ( ph -> ch ) $=
      ( wo jaod mpd ) ABDHCGABCDEFIJ $.
  $}

  ${
    ori.1 $e |- ( ph \/ ps ) $.
    $( Infer implication from disjunction.  (Contributed by NM,
       11-Jun-1994.) $)
    ori $p |- ( -. ph -> ps ) $=
      ( wo wn wi df-or mpbi ) ABDAEBFCABGH $.
  $}

  ${
    orri.1 $e |- ( -. ph -> ps ) $.
    $( Infer disjunction from implication.  (Contributed by NM,
       11-Jun-1994.) $)
    orri $p |- ( ph \/ ps ) $=
      ( wo wn wi df-or mpbir ) ABDAEBFCABGH $.
  $}

  ${
    orrd.1 $e |- ( ph -> ( -. ps -> ch ) ) $.
    $( Deduce disjunction from implication.  (Contributed by NM,
       27-Nov-1995.) $)
    orrd $p |- ( ph -> ( ps \/ ch ) ) $=
      ( wn wi wo pm2.54 syl ) ABECFBCGDBCHI $.
  $}

  ${
    ord.1 $e |- ( ph -> ( ps \/ ch ) ) $.
    $( Deduce implication from disjunction.  (Contributed by NM,
       18-May-1994.) $)
    ord $p |- ( ph -> ( -. ps -> ch ) ) $=
      ( wo wn wi df-or sylib ) ABCEBFCGDBCHI $.
  $}

  ${
    orci.1 $e |- ph $.
    $( Deduction introducing a disjunct.  (Contributed by NM, 19-Jan-2008.)
       (Proof shortened by Wolf Lammen, 14-Nov-2012.) $)
    orci $p |- ( ph \/ ps ) $=
      ( pm2.24i orri ) ABABCDE $.

    $( Deduction introducing a disjunct.  (Contributed by NM, 19-Jan-2008.)
       (Proof shortened by Wolf Lammen, 14-Nov-2012.) $)
    olci $p |- ( ps \/ ph ) $=
      ( wn a1i orri ) BAABDCEF $.
  $}

  $( Introduction of a disjunct.  Theorem *2.2 of [WhiteheadRussell] p. 104.
     (Contributed by NM, 30-Aug-1993.) $)
  orc $p |- ( ph -> ( ph \/ ps ) ) $=
    ( pm2.24 orrd ) AABABCD $.

  $( Introduction of a disjunct.  Axiom *1.3 of [WhiteheadRussell] p. 96.
     (Contributed by NM, 30-Aug-1993.) $)
  olc $p |- ( ph -> ( ps \/ ph ) ) $=
    ( wn ax-1 orrd ) ABAABCDE $.

  $( Axiom *1.4 of [WhiteheadRussell] p. 96.  (Contributed by NM,
     3-Jan-2005.) $)
  pm1.4 $p |- ( ( ph \/ ps ) -> ( ps \/ ph ) ) $=
    ( wo olc orc jaoi ) ABACBABDBAEF $.

  $( Commutative law for disjunction.  Theorem *4.31 of [WhiteheadRussell]
     p. 118.  (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 15-Nov-2012.) $)
  orcom $p |- ( ( ph \/ ps ) <-> ( ps \/ ph ) ) $=
    ( wo pm1.4 impbii ) ABCBACABDBADE $.

  ${
    orcomd.1 $e |- ( ph -> ( ps \/ ch ) ) $.
    $( Commutation of disjuncts in consequent.  (Contributed by NM,
       2-Dec-2010.) $)
    orcomd $p |- ( ph -> ( ch \/ ps ) ) $=
      ( wo orcom sylib ) ABCECBEDBCFG $.
  $}

  ${
    orcoms.1 $e |- ( ( ph \/ ps ) -> ch ) $.
    $( Commutation of disjuncts in antecedent.  (Contributed by NM,
       2-Dec-2012.) $)
    orcoms $p |- ( ( ps \/ ph ) -> ch ) $=
      ( wo pm1.4 syl ) BAEABECBAFDG $.
  $}

  ${
    orcd.1 $e |- ( ph -> ps ) $.
    $( Deduction introducing a disjunct.  A translation of natural deduction
       rule ` \/ ` IR ( ` \/ ` insertion right), see ~ natded .  (Contributed
       by NM, 20-Sep-2007.) $)
    orcd $p |- ( ph -> ( ps \/ ch ) ) $=
      ( wo orc syl ) ABBCEDBCFG $.

    $( Deduction introducing a disjunct.  A translation of natural deduction
       rule ` \/ ` IL ( ` \/ ` insertion left), see ~ natded .  (Contributed by
       NM, 11-Apr-2008.)  (Proof shortened by Wolf Lammen, 3-Oct-2013.) $)
    olcd $p |- ( ph -> ( ch \/ ps ) ) $=
      ( orcd orcomd ) ABCABCDEF $.
  $}

  ${
    orcs.1 $e |- ( ( ph \/ ps ) -> ch ) $.
    $( Deduction eliminating disjunct. _Notational convention_:  We sometimes
       suffix with "s" the label of an inference that manipulates an
       antecedent, leaving the consequent unchanged.  The "s" means that the
       inference eliminates the need for a syllogism ( ~ syl ) -type inference
       in a proof.  (Contributed by NM, 21-Jun-1994.) $)
    orcs $p |- ( ph -> ch ) $=
      ( wo orc syl ) AABECABFDG $.
  $}

  ${
    olcs.1 $e |- ( ( ph \/ ps ) -> ch ) $.
    $( Deduction eliminating disjunct.  (Contributed by NM, 21-Jun-1994.)
       (Proof shortened by Wolf Lammen, 3-Oct-2013.) $)
    olcs $p |- ( ps -> ch ) $=
      ( orcoms orcs ) BACABCDEF $.
  $}

  ${
    olcnd.1 $e |- ( ph -> ( ps \/ ch ) ) $.
    olcnd.2 $e |- ( ph -> -. ch ) $.
    $( A lemma for Conjunctive Normal Form unit propagation, in deduction form.
       (Contributed by Giovanni Mascellani, 15-Sep-2017.)  (Proof shortened by
       Wolf Lammen, 13-Apr-2024.) $)
    olcnd $p |- ( ph -> ps ) $=
      ( ord mt3d ) ABCEABCDFG $.
  $}

  ${
    orcnd.1 $e |- ( ph -> ( ps \/ ch ) ) $.
    orcnd.2 $e |- ( ph -> -. ps ) $.
    $( A lemma for Conjunctive Normal Form unit propagation, in deduction form.
       (Contributed by Giovanni Mascellani, 15-Sep-2017.) $)
    orcnd $p |- ( ph -> ch ) $=
      ( orcomd olcnd ) ACBABCDFEG $.
  $}

  ${
    mtord.1 $e |- ( ph -> -. ch ) $.
    mtord.2 $e |- ( ph -> -. th ) $.
    mtord.3 $e |- ( ph -> ( ps -> ( ch \/ th ) ) ) $.
    $( A modus tollens deduction involving disjunction.  (Contributed by Jeff
       Hankins, 15-Jul-2009.) $)
    mtord $p |- ( ph -> -. ps ) $=
      ( wo wn pm2.53 syl6ci mtod ) ABDFABCDHCIDGECDJKL $.
  $}

  ${
    pm3.2ni.1 $e |- -. ph $.
    pm3.2ni.2 $e |- -. ps $.
    $( Infer negated disjunction of negated premises.  (Contributed by NM,
       4-Apr-1995.) $)
    pm3.2ni $p |- -. ( ph \/ ps ) $=
      ( wo id pm2.21i jaoi mto ) ABEACAABAFBADGHI $.
  $}

  $( Theorem *2.45 of [WhiteheadRussell] p. 106.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.45 $p |- ( -. ( ph \/ ps ) -> -. ph ) $=
    ( wo orc con3i ) AABCABDE $.

  $( Theorem *2.46 of [WhiteheadRussell] p. 106.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.46 $p |- ( -. ( ph \/ ps ) -> -. ps ) $=
    ( wo olc con3i ) BABCBADE $.

  $( Theorem *2.47 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.47 $p |- ( -. ( ph \/ ps ) -> ( -. ph \/ ps ) ) $=
    ( wo wn pm2.45 orcd ) ABCDADBABEF $.

  $( Theorem *2.48 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.48 $p |- ( -. ( ph \/ ps ) -> ( ph \/ -. ps ) ) $=
    ( wo wn pm2.46 olcd ) ABCDBDAABEF $.

  $( Theorem *2.49 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.49 $p |- ( -. ( ph \/ ps ) -> ( -. ph \/ -. ps ) ) $=
    ( wo wn pm2.46 olcd ) ABCDBDADABEF $.

  $( If neither of two propositions is true, then these propositions are
     equivalent.  (Contributed by BJ, 26-Apr-2019.) $)
  norbi $p |- ( -. ( ph \/ ps ) -> ( ph <-> ps ) ) $=
    ( wo orc olc pm5.21ni ) AABCBABDBAEF $.

  $( If two propositions are not equivalent, then at least one is true.
     (Contributed by BJ, 19-Apr-2019.)  (Proof shortened by Wolf Lammen,
     19-Jan-2020.) $)
  nbior $p |- ( -. ( ph <-> ps ) -> ( ph \/ ps ) ) $=
    ( wo wb norbi con1i ) ABCABDABEF $.

  $( Elimination of disjunction by denial of a disjunct.  Theorem *2.55 of
     [WhiteheadRussell] p. 107.  (Contributed by NM, 12-Aug-1994.)  (Proof
     shortened by Wolf Lammen, 21-Jul-2012.) $)
  orel1 $p |- ( -. ph -> ( ( ph \/ ps ) -> ps ) ) $=
    ( wo wn pm2.53 com12 ) ABCADBABEF $.

  $( Theorem *2.25 of [WhiteheadRussell] p. 104.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.25 $p |- ( ph \/ ( ( ph \/ ps ) -> ps ) ) $=
    ( wo wi orel1 orri ) AABCBDABEF $.

  $( Elimination of disjunction by denial of a disjunct.  Theorem *2.56 of
     [WhiteheadRussell] p. 107.  (Contributed by NM, 12-Aug-1994.)  (Proof
     shortened by Wolf Lammen, 5-Apr-2013.) $)
  orel2 $p |- ( -. ph -> ( ( ps \/ ph ) -> ps ) ) $=
    ( wn idd pm2.21 jaod ) ACZBBAGBDABEF $.

  $( Slight generalization of Theorem *2.67 of [WhiteheadRussell] p. 107.
     (Contributed by NM, 3-Jan-2005.) $)
  pm2.67-2 $p |- ( ( ( ph \/ ch ) -> ps ) -> ( ph -> ps ) ) $=
    ( wo orc imim1i ) AACDBACEF $.

  $( Theorem *2.67 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.67 $p |- ( ( ( ph \/ ps ) -> ps ) -> ( ph -> ps ) ) $=
    ( pm2.67-2 ) ABBC $.

  $( A non-intuitionistic positive statement, sometimes called a paradox of
     material implication.  Sometimes called Curry's axiom.  Similar to ~ exmid
     (obtained by substituting ` F. ` for ` ps ` ) but positive.  For another
     non-intuitionistic positive statement, see ~ peirce .  (Contributed by BJ,
     4-Apr-2021.) $)
  curryax $p |- ( ph \/ ( ph -> ps ) ) $=
    ( wi pm2.21 orri ) AABCABDE $.

  $( Law of excluded middle, also called the principle of _tertium non datur_.
     Theorem *2.11 of [WhiteheadRussell] p. 101.  It says that something is
     either true or not true; there are no in-between values of truth.  This is
     an essential distinction of our classical logic and is not a theorem of
     intuitionistic logic.  In intuitionistic logic, if this statement is true
     for some ` ph ` , then ` ph ` is decidable.  (Contributed by NM,
     29-Dec-1992.) $)
  exmid $p |- ( ph \/ -. ph ) $=
    ( wn id orri ) AABZECD $.

  $( Law of excluded middle in a context.  (Contributed by Mario Carneiro,
     9-Feb-2017.) $)
  exmidd $p |- ( ph -> ( ps \/ -. ps ) ) $=
    ( wn wo exmid a1i ) BBCDABEF $.

  $( Theorem *2.1 of [WhiteheadRussell] p. 101.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 23-Nov-2012.) $)
  pm2.1 $p |- ( -. ph \/ ph ) $=
    ( id imori ) AAABC $.

  $( Theorem *2.13 of [WhiteheadRussell] p. 101.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.13 $p |- ( ph \/ -. -. -. ph ) $=
    ( wn notnot orri ) AABZBBECD $.

  $( Theorem *2.621 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.621 $p |- ( ( ph -> ps ) -> ( ( ph \/ ps ) -> ps ) ) $=
    ( wi id idd jaod ) ABCZABBGDGBEF $.

  $( Theorem *2.62 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 13-Dec-2013.) $)
  pm2.62 $p |- ( ( ph \/ ps ) -> ( ( ph -> ps ) -> ps ) ) $=
    ( wi wo pm2.621 com12 ) ABCABDBABEF $.

  $( Theorem *2.68 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.68 $p |- ( ( ( ph -> ps ) -> ps ) -> ( ph \/ ps ) ) $=
    ( wi jarl orrd ) ABCBCABABBDE $.

  $( Logical 'or' expressed in terms of implication only.  Theorem *5.25 of
     [WhiteheadRussell] p. 124.  (Contributed by NM, 12-Aug-2004.)  (Proof
     shortened by Wolf Lammen, 20-Oct-2012.) $)
  dfor2 $p |- ( ( ph \/ ps ) <-> ( ( ph -> ps ) -> ps ) ) $=
    ( wo wi pm2.62 pm2.68 impbii ) ABCABDBDABEABFG $.

  $( Theorem *2.07 of [WhiteheadRussell] p. 101.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.07 $p |- ( ph -> ( ph \/ ph ) ) $=
    ( olc ) AAB $.

  $( Axiom *1.2 of [WhiteheadRussell] p. 96, which they call "Taut".
     (Contributed by NM, 3-Jan-2005.) $)
  pm1.2 $p |- ( ( ph \/ ph ) -> ph ) $=
    ( id jaoi ) AAAABZDC $.

  $( Idempotent law for disjunction.  Theorem *4.25 of [WhiteheadRussell]
     p. 117.  (Contributed by NM, 11-May-1993.)  (Proof shortened by Andrew
     Salmon, 16-Apr-2011.)  (Proof shortened by Wolf Lammen, 10-Mar-2013.) $)
  oridm $p |- ( ( ph \/ ph ) <-> ph ) $=
    ( wo pm1.2 pm2.07 impbii ) AABAACADE $.

  $( Theorem *4.25 of [WhiteheadRussell] p. 117.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.25 $p |- ( ph <-> ( ph \/ ph ) ) $=
    ( wo oridm bicomi ) AABAACD $.

  $( Theorem *2.4 of [WhiteheadRussell] p. 106.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.4 $p |- ( ( ph \/ ( ph \/ ps ) ) -> ( ph \/ ps ) ) $=
    ( wo orc id jaoi ) AABCZGABDGEF $.

  $( Theorem *2.41 of [WhiteheadRussell] p. 106.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.41 $p |- ( ( ps \/ ( ph \/ ps ) ) -> ( ph \/ ps ) ) $=
    ( wo olc id jaoi ) BABCZGBADGEF $.

  ${
    orim12i.1 $e |- ( ph -> ps ) $.
    orim12i.2 $e |- ( ch -> th ) $.
    $( Disjoin antecedents and consequents of two premises.  (Contributed by
       NM, 6-Jun-1994.)  (Proof shortened by Wolf Lammen, 25-Jul-2012.) $)
    orim12i $p |- ( ( ph \/ ch ) -> ( ps \/ th ) ) $=
      ( wo orcd olcd jaoi ) ABDGCABDEHCDBFIJ $.
  $}

  ${
    orim1i.1 $e |- ( ph -> ps ) $.
    $( Introduce disjunct to both sides of an implication.  (Contributed by NM,
       6-Jun-1994.) $)
    orim1i $p |- ( ( ph \/ ch ) -> ( ps \/ ch ) ) $=
      ( id orim12i ) ABCCDCEF $.

    $( Introduce disjunct to both sides of an implication.  (Contributed by NM,
       6-Jun-1994.) $)
    orim2i $p |- ( ( ch \/ ph ) -> ( ch \/ ps ) ) $=
      ( id orim12i ) CCABCEDF $.
  $}

  ${
    orim12dALT.1 $e |- ( ph -> ( ps -> ch ) ) $.
    orim12dALT.2 $e |- ( ph -> ( th -> ta ) ) $.
    $( Alternate proof of ~ orim12d which does not depend on ~ df-an .  This is
       an illustration of the conservativity of definitions (definitions do not
       permit to prove additional theorems whose statements do not contain the
       defined symbol).  (Contributed by Wolf Lammen, 8-Aug-2022.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    orim12dALT $p |- ( ph -> ( ( ps \/ th ) -> ( ch \/ ta ) ) ) $=
      ( wo wn wi pm2.53 con3d imim12d pm2.54 syl56 ) BDHBIZDJACIZEJCEHBDKAQPDEA
      BCFLGMCENO $.
  $}

  ${
    orbi2i.1 $e |- ( ph <-> ps ) $.
    $( Inference adding a left disjunct to both sides of a logical equivalence.
       (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf Lammen,
       12-Dec-2012.) $)
    orbi2i $p |- ( ( ch \/ ph ) <-> ( ch \/ ps ) ) $=
      ( wo biimpi orim2i biimpri impbii ) CAECBEABCABDFGBACABDHGI $.

    $( Inference adding a right disjunct to both sides of a logical
       equivalence.  (Contributed by NM, 3-Jan-1993.) $)
    orbi1i $p |- ( ( ph \/ ch ) <-> ( ps \/ ch ) ) $=
      ( wo orcom orbi2i 3bitri ) ACECAECBEBCEACFABCDGCBFH $.
  $}

  ${
    orbi12i.1 $e |- ( ph <-> ps ) $.
    orbi12i.2 $e |- ( ch <-> th ) $.
    $( Infer the disjunction of two equivalences.  (Contributed by NM,
       3-Jan-1993.) $)
    orbi12i $p |- ( ( ph \/ ch ) <-> ( ps \/ th ) ) $=
      ( wo orbi2i orbi1i bitri ) ACGADGBDGCDAFHABDEIJ $.
  $}

  ${
    bid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduction adding a left disjunct to both sides of a logical equivalence.
       (Contributed by NM, 21-Jun-1993.) $)
    orbi2d $p |- ( ph -> ( ( th \/ ps ) <-> ( th \/ ch ) ) ) $=
      ( wn wi wo imbi2d df-or 3bitr4g ) ADFZBGLCGDBHDCHABCLEIDBJDCJK $.

    $( Deduction adding a right disjunct to both sides of a logical
       equivalence.  (Contributed by NM, 21-Jun-1993.) $)
    orbi1d $p |- ( ph -> ( ( ps \/ th ) <-> ( ch \/ th ) ) ) $=
      ( wo orbi2d orcom 3bitr4g ) ADBFDCFBDFCDFABCDEGBDHCDHI $.
  $}

  $( Theorem *4.37 of [WhiteheadRussell] p. 118.  (Contributed by NM,
     3-Jan-2005.) $)
  orbi1 $p |- ( ( ph <-> ps ) -> ( ( ph \/ ch ) <-> ( ps \/ ch ) ) ) $=
    ( wb id orbi1d ) ABDZABCGEF $.

  ${
    bi12d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bi12d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Deduction joining two equivalences to form equivalence of disjunctions.
       (Contributed by NM, 21-Jun-1993.) $)
    orbi12d $p |- ( ph -> ( ( ps \/ th ) <-> ( ch \/ ta ) ) ) $=
      ( wo orbi1d orbi2d bitrd ) ABDHCDHCEHABCDFIADECGJK $.
  $}

  $( Axiom *1.5 (Assoc) of [WhiteheadRussell] p. 96.  (Contributed by NM,
     3-Jan-2005.) $)
  pm1.5 $p |- ( ( ph \/ ( ps \/ ch ) ) -> ( ps \/ ( ph \/ ch ) ) ) $=
    ( wo orc olcd olc orim2i jaoi ) ABACDZDBCDAJBACEFCJBCAGHI $.

  $( Swap two disjuncts.  (Contributed by NM, 5-Aug-1993.)  (Proof shortened by
     Wolf Lammen, 14-Nov-2012.) $)
  or12 $p |- ( ( ph \/ ( ps \/ ch ) ) <-> ( ps \/ ( ph \/ ch ) ) ) $=
    ( wo pm1.5 impbii ) ABCDDBACDDABCEBACEF $.

  $( Associative law for disjunction.  Theorem *4.33 of [WhiteheadRussell]
     p. 118.  (Contributed by NM, 5-Aug-1993.)  (Proof shortened by Andrew
     Salmon, 26-Jun-2011.) $)
  orass $p |- ( ( ( ph \/ ps ) \/ ch ) <-> ( ph \/ ( ps \/ ch ) ) ) $=
    ( wo orcom or12 orbi2i 3bitri ) ABDZCDCIDACBDZDABCDZDICECABFJKACBEGH $.

  $( Theorem *2.31 of [WhiteheadRussell] p. 104.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.31 $p |- ( ( ph \/ ( ps \/ ch ) ) -> ( ( ph \/ ps ) \/ ch ) ) $=
    ( wo orass biimpri ) ABDCDABCDDABCEF $.

  $( Theorem *2.32 of [WhiteheadRussell] p. 105.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.32 $p |- ( ( ( ph \/ ps ) \/ ch ) -> ( ph \/ ( ps \/ ch ) ) ) $=
    ( wo orass biimpi ) ABDCDABCDDABCEF $.

  $( Theorem *2.3 of [WhiteheadRussell] p. 104.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.3 $p |- ( ( ph \/ ( ps \/ ch ) ) -> ( ph \/ ( ch \/ ps ) ) ) $=
    ( wo pm1.4 orim2i ) BCDCBDABCEF $.

  $( A rearrangement of disjuncts.  (Contributed by NM, 18-Oct-1995.)  (Proof
     shortened by Andrew Salmon, 26-Jun-2011.) $)
  or32 $p |- ( ( ( ph \/ ps ) \/ ch ) <-> ( ( ph \/ ch ) \/ ps ) ) $=
    ( wo orass or12 orcom 3bitri ) ABDCDABCDDBACDZDIBDABCEABCFBIGH $.

  $( Rearrangement of 4 disjuncts.  (Contributed by NM, 12-Aug-1994.) $)
  or4 $p |- ( ( ( ph \/ ps ) \/ ( ch \/ th ) ) <->
                ( ( ph \/ ch ) \/ ( ps \/ th ) ) ) $=
    ( wo or12 orbi2i orass 3bitr4i ) ABCDEZEZEACBDEZEZEABEJEACELEKMABCDFGABJHAC
    LHI $.

  $( Rearrangement of 4 disjuncts.  (Contributed by NM, 10-Jan-2005.) $)
  or42 $p |- ( ( ( ph \/ ps ) \/ ( ch \/ th ) ) <->
                 ( ( ph \/ ch ) \/ ( th \/ ps ) ) ) $=
    ( wo or4 orcom orbi2i bitri ) ABECDEEACEZBDEZEJDBEZEABCDFKLJBDGHI $.

  $( Distribution of disjunction over disjunction.  (Contributed by NM,
     25-Feb-1995.) $)
  orordi $p |- ( ( ph \/ ( ps \/ ch ) ) <->
               ( ( ph \/ ps ) \/ ( ph \/ ch ) ) ) $=
    ( wo oridm orbi1i or4 bitr3i ) ABCDZDAADZIDABDACDDJAIAEFAABCGH $.

  $( Distribution of disjunction over disjunction.  (Contributed by NM,
     25-Feb-1995.) $)
  orordir $p |- ( ( ( ph \/ ps ) \/ ch ) <->
               ( ( ph \/ ch ) \/ ( ps \/ ch ) ) ) $=
    ( wo oridm orbi2i or4 bitr3i ) ABDZCDICCDZDACDBCDDJCICEFABCCGH $.

  $( Disjunction distributes over implication.  (Contributed by Wolf Lammen,
     5-Jan-2013.) $)
  orimdi $p |- ( ( ph \/ ( ps -> ch ) )
        <-> ( ( ph \/ ps ) -> ( ph \/ ch ) ) ) $=
    ( wn wi wo imdi df-or imbi12i 3bitr4i ) ADZBCEZEKBEZKCEZEALFABFZACFZEKBCGAL
    HOMPNABHACHIJ $.

  $( Theorem *2.76 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.76 $p |- ( ( ph \/ ( ps -> ch ) )
      -> ( ( ph \/ ps ) -> ( ph \/ ch ) ) ) $=
    ( wi wo orimdi biimpi ) ABCDEABEACEDABCFG $.

  $( Theorem *2.85 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 5-Jan-2013.) $)
  pm2.85 $p |- ( ( ( ph \/ ps ) -> ( ph \/ ch ) )
      -> ( ph \/ ( ps -> ch ) ) ) $=
    ( wi wo orimdi biimpri ) ABCDEABEACEDABCFG $.

  $( Theorem *2.75 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 4-Jan-2013.) $)
  pm2.75 $p |- ( ( ph \/ ps )
       -> ( ( ph \/ ( ps -> ch ) ) -> ( ph \/ ch ) ) ) $=
    ( wi wo pm2.76 com12 ) ABCDEABEACEABCFG $.

  $( Implication distributes over disjunction.  Theorem *4.78 of
     [WhiteheadRussell] p. 121.  (Contributed by NM, 3-Jan-2005.)  (Proof
     shortened by Wolf Lammen, 19-Nov-2012.) $)
  pm4.78 $p |- ( ( ( ph -> ps ) \/ ( ph -> ch ) ) <->
                ( ph -> ( ps \/ ch ) ) ) $=
    ( wn wo wi orordi imor orbi12i 3bitr4ri ) ADZBCEZEKBEZKCEZEALFABFZACFZEKBCG
    ALHOMPNABHACHIJ $.

  $( A disjunction with a true formula is equivalent to that true formula.
     (Contributed by NM, 23-May-1999.) $)
  biort $p |- ( ph -> ( ph <-> ( ph \/ ps ) ) ) $=
    ( wo id orc 2thd ) AAABCADABEF $.

  $( A wff is equivalent to its disjunction with falsehood.  Theorem *4.74 of
     [WhiteheadRussell] p. 121.  (Contributed by NM, 23-Mar-1995.)  (Proof
     shortened by Wolf Lammen, 18-Nov-2012.) $)
  biorf $p |- ( -. ph -> ( ps <-> ( ph \/ ps ) ) ) $=
    ( wn wo olc orel1 impbid2 ) ACBABDBAEABFG $.

  $( A wff is equivalent to its negated disjunction with falsehood.
     (Contributed by NM, 9-Jul-2012.) $)
  biortn $p |- ( ph -> ( ps <-> ( -. ph \/ ps ) ) ) $=
    ( wn wo wb notnot biorf syl ) AACZCBIBDEAFIBGH $.

  ${
    biorfi.1 $e |- -. ph $.
    $( The dual of ~ biorf is not ~ biantr but ~ iba (and ~ ibar ).  So there
       should also be a "biorfr".  (Note that these four statements can
       actually be strengthened to biconditionals.)  (Contributed by BJ,
       26-Oct-2019.) $)
    biorfi $p |- ( ps <-> ( ph \/ ps ) ) $=
      ( wn wo wb biorf ax-mp ) ADBABEFCABGH $.

    $( A wff is equivalent to its disjunction with falsehood.  (Contributed by
       NM, 23-Mar-1995.)  (Proof shortened by Wolf Lammen, 16-Jul-2021.)
       (Proof shortened by AV, 10-Aug-2025.) $)
    biorfri $p |- ( ps <-> ( ps \/ ph ) ) $=
      ( wo biorfi orcom bitri ) BABDBADABCEABFG $.
  $}

  $( Rewriting implication based theorems using disjunction. $)

  $( Theorem *2.26 of [WhiteheadRussell] p. 104.  See ~ pm2.27 .  (Contributed
     by NM, 3-Jan-2005.)  (Proof shortened by Wolf Lammen, 23-Nov-2012.) $)
  pm2.26 $p |- ( -. ph \/ ( ( ph -> ps ) -> ps ) ) $=
    ( wi pm2.27 imori ) AABCBCABDE $.

  $( Contradiction and disjunction. $)

  $( Theorem *2.63 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.63 $p |- ( ( ph \/ ps ) -> ( ( -. ph \/ ps ) -> ps ) ) $=
    ( wo wn pm2.53 idd jaod ) ABCZADBBABEHBFG $.

  $( Theorem *2.64 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.64 $p |- ( ( ph \/ ps ) -> ( ( ph \/ -. ps ) -> ph ) ) $=
    ( wn wo orel2 jao1i com12 ) ABCZDABDZAAHIBAEFG $.

  $( Theorem *2.42 of [WhiteheadRussell] p. 106.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.42 $p |- ( ( -. ph \/ ( ph -> ps ) ) -> ( ph -> ps ) ) $=
    ( wn wi pm2.21 id jaoi ) ACABDZHABEHFG $.

$( Some expressions connecting implication and disjunction. $)

  $( A general instance of Theorem *5.11 of [WhiteheadRussell] p. 123.
     (Contributed by NM, 3-Jan-2005.) $)
  pm5.11g $p |- ( ( ph -> ps ) \/ ( -. ph -> ch ) ) $=
    ( wi wn pm2.5g orri ) ABDAECDABCFG $.

  $( Theorem *5.11 of [WhiteheadRussell] p. 123.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.11 $p |- ( ( ph -> ps ) \/ ( -. ph -> ps ) ) $=
    ( pm5.11g ) ABBC $.

  $( Theorem *5.12 of [WhiteheadRussell] p. 123.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.12 $p |- ( ( ph -> ps ) \/ ( ph -> -. ps ) ) $=
    ( wi wn pm2.51 orri ) ABCABDCABEF $.

  $( Theorem *5.14 of [WhiteheadRussell] p. 123.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.14 $p |- ( ( ph -> ps ) \/ ( ps -> ch ) ) $=
    ( wi pm2.521g orri ) ABDBCDABCEF $.

  $( Theorem *5.13 of [WhiteheadRussell] p. 123.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 14-Nov-2012.) $)
  pm5.13 $p |- ( ( ph -> ps ) \/ ( ps -> ph ) ) $=
    ( pm5.14 ) ABAC $.

  $( Theorem *5.55 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 20-Jan-2013.) $)
  pm5.55 $p |- ( ( ( ph \/ ps ) <-> ph ) \/ ( ( ph \/ ps ) <-> ps ) ) $=
    ( wo wb biort bicomd wn biorf nsyl5 orri ) ABCZADZKBDZALMAAKABEFAGBKABHFIJ
    $.

  $( Implication in terms of biconditional and disjunction.  Theorem *4.72 of
     [WhiteheadRussell] p. 121.  (Contributed by NM, 30-Aug-1993.)  (Proof
     shortened by Wolf Lammen, 30-Jan-2013.) $)
  pm4.72 $p |- ( ( ph -> ps ) <-> ( ps <-> ( ph \/ ps ) ) ) $=
    ( wi wo wb olc pm2.621 impbid2 orc biimpr syl5 impbii ) ABCZBABDZEZMBNBAFAB
    GHANOBABIBNJKL $.

  $( Simplify an implication between implications.  (Contributed by Paul
     Chapman, 17-Nov-2012.)  (Proof shortened by Wolf Lammen, 3-Apr-2013.) $)
  imimorb $p |- ( ( ( ps -> ch ) -> ( ph -> ch ) ) <->
                  ( ph -> ( ps \/ ch ) ) ) $=
    ( wi wo bi2.04 dfor2 imbi2i bitr4i ) BCDZACDDAJCDZDABCEZDJACFLKABCGHI $.

  $( Absorption of disjunction into equivalence.  (Contributed by NM,
     6-Aug-1995.)  (Proof shortened by Wolf Lammen, 3-Nov-2013.) $)
  oibabs $p |- ( ( ( ph \/ ps ) -> ( ph <-> ps ) ) <-> ( ph <-> ps ) ) $=
    ( wo wb wi norbi id ja ax-1 impbii ) ABCZABDZELKLLABFLGHLKIJ $.

  $( Disjunction distributes over the biconditional.  An axiom of system DS in
     Vladimir Lifschitz, "On calculational proofs" (1998),
     ~ http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.25.3384 .
     (Contributed by NM, 8-Jan-2005.)  (Proof shortened by Wolf Lammen,
     4-Feb-2013.) $)
  orbidi $p |- ( ( ph \/ ( ps <-> ch ) ) <->
                ( ( ph \/ ps ) <-> ( ph \/ ch ) ) ) $=
    ( wn wb wi wo pm5.74 df-or bibi12i 3bitr4i ) ADZBCEZFLBFZLCFZEAMGABGZACGZEL
    BCHAMIPNQOABIACIJK $.

  $( Disjunction distributes over the biconditional.  Theorem *5.7 of
     [WhiteheadRussell] p. 125.  This theorem is similar to ~ orbidi .
     (Contributed by Roy F. Longton, 21-Jun-2005.) $)
  pm5.7 $p |- ( ( ( ph \/ ch ) <-> ( ps \/ ch ) ) <->
               ( ch \/ ( ph <-> ps ) ) ) $=
    ( wb wo orbidi orcom bibi12i bitr2i ) CABDECAEZCBEZDACEZBCEZDCABFJLKMCAGCBG
    HI $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Mixed connectives
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  This section gathers theorems of propositional calculus which use (either in
  their statement or proof) mixed connectives (at least conjunction and
  disjunction).

  As noted in the "note on definitions" in the section comment for logical
  equivalence, some theorem statements may contain for instance only
  conjunction or only disjunction, but both definitions are used in their
  proofs to make them shorter (this is exemplified in ~ orim12d versus
  ~ orim12dALT ).  These theorems are mostly grouped at the beginning of this
  section.

  The family of theorems starting with ~ animorl focus on the relation between
  conjunction and disjunction and can be seen as the starting point of mixed
  connectives in statements.  This sectioning is not rigorously true, since for
  instance the section begins with ~ jaao and related theorems.

$)

  ${
    jaao.1 $e |- ( ph -> ( ps -> ch ) ) $.
    jaao.2 $e |- ( th -> ( ta -> ch ) ) $.
    $( Inference conjoining and disjoining the antecedents of two implications.
       (Contributed by NM, 30-Sep-1999.) $)
    jaao $p |- ( ( ph /\ th ) -> ( ( ps \/ ta ) -> ch ) ) $=
      ( wa wi adantr adantl jaod ) ADHBCEABCIDFJDECIAGKL $.

    $( Inference disjoining and conjoining the antecedents of two implications.
       (Contributed by Stefan Allan, 1-Nov-2008.) $)
    jaoa $p |- ( ( ph \/ th ) -> ( ( ps /\ ta ) -> ch ) ) $=
      ( wa wi adantrd adantld jaoi ) ABEHCIDABCEFJDECBGKL $.
  $}

  ${
    jaoian.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    jaoian.2 $e |- ( ( th /\ ps ) -> ch ) $.
    $( Inference disjoining the antecedents of two implications.  (Contributed
       by NM, 23-Oct-2005.) $)
    jaoian $p |- ( ( ( ph \/ th ) /\ ps ) -> ch ) $=
      ( wo wi ex jaoi imp ) ADGBCABCHDABCEIDBCFIJK $.
  $}

  ${
    jaodan.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    jaodan.2 $e |- ( ( ph /\ th ) -> ch ) $.
    $( Deduction disjoining the antecedents of two implications.  (Contributed
       by NM, 14-Oct-2005.) $)
    jaodan $p |- ( ( ph /\ ( ps \/ th ) ) -> ch ) $=
      ( wo ex jaod imp ) ABDGCABCDABCEHADCFHIJ $.

    jaodan.3 $e |- ( ph -> ( ps \/ th ) ) $.
    $( Eliminate a disjunction in a deduction.  A translation of natural
       deduction rule ` \/ ` E ( ` \/ ` elimination), see ~ natded .
       (Contributed by Mario Carneiro, 29-May-2016.) $)
    mpjaodan $p |- ( ph -> ch ) $=
      ( wo jaodan mpdan ) ABDHCGABCDEFIJ $.
  $}

  $( Theorem *3.44 of [WhiteheadRussell] p. 113.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 3-Oct-2013.) $)
  pm3.44 $p |- ( ( ( ps -> ph ) /\ ( ch -> ph ) )
      -> ( ( ps \/ ch ) -> ph ) ) $=
    ( wi id jaao ) BADZBACADZCGEHEF $.

  $( Disjunction of antecedents.  Compare Theorem *3.44 of [WhiteheadRussell]
     p. 113.  (Contributed by NM, 5-Apr-1994.)  (Proof shortened by Wolf
     Lammen, 4-Apr-2013.) $)
  jao $p |- ( ( ph -> ps ) -> ( ( ch -> ps ) -> ( ( ph \/ ch ) -> ps ) ) ) $=
    ( wi wo pm3.44 ex ) ABDCBDACEBDBACFG $.

  $( Disjunction of antecedents.  Compare Theorem *4.77 of [WhiteheadRussell]
     p. 121.  (Contributed by NM, 30-May-1994.)  (Proof shortened by Wolf
     Lammen, 9-Dec-2012.) $)
  jaob $p |- ( ( ( ph \/ ch ) -> ps ) <-> ( ( ph -> ps ) /\ ( ch -> ps ) ) ) $=
    ( wo wi wa pm2.67-2 olc imim1i jca pm3.44 impbii ) ACDZBEZABEZCBEZFNOPABCGC
    MBCAHIJBACKL $.

  $( Theorem *4.77 of [WhiteheadRussell] p. 121.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.77 $p |- ( ( ( ps -> ph ) /\ ( ch -> ph ) ) <->
                ( ( ps \/ ch ) -> ph ) ) $=
    ( wo wi wa jaob bicomi ) BCDAEBAECAEFBACGH $.

  $( Theorem *3.48 of [WhiteheadRussell] p. 114.  (Contributed by NM,
     28-Jan-1997.) $)
  pm3.48 $p |- ( ( ( ph -> ps ) /\ ( ch -> th ) )
      -> ( ( ph \/ ch ) -> ( ps \/ th ) ) ) $=
    ( wi wo orc imim2i olc jaao ) ABEABDFZCDECBKABDGHDKCDBIHJ $.

  ${
    orim12d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    orim12d.2 $e |- ( ph -> ( th -> ta ) ) $.
    $( Disjoin antecedents and consequents in a deduction.  See ~ orim12dALT
       for a proof which does not depend on ~ df-an .  (Contributed by NM,
       10-May-1994.) $)
    orim12d $p |- ( ph -> ( ( ps \/ th ) -> ( ch \/ ta ) ) ) $=
      ( wi wo pm3.48 syl2anc ) ABCHDEHBDICEIHFGBCDEJK $.
  $}

  ${
    orim12da.1 $e |- ( ( ph /\ ps ) -> th ) $.
    orim12da.2 $e |- ( ( ph /\ ch ) -> ta ) $.
    orim12da.3 $e |- ( ph -> ( ps \/ ch ) ) $.
    $( Deduce a disjunction from another one.  Variation on ~ orim12d .
       (Contributed by Thierry Arnoux, 18-May-2025.) $)
    orim12da $p |- ( ph -> ( th \/ ta ) ) $=
      ( wo ex orim12d mpd ) ABCIDEIHABDCEABDFJACEGJKL $.
  $}

  ${
    orim1d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Disjoin antecedents and consequents in a deduction.  (Contributed by NM,
       23-Apr-1995.) $)
    orim1d $p |- ( ph -> ( ( ps \/ th ) -> ( ch \/ th ) ) ) $=
      ( idd orim12d ) ABCDDEADFG $.

    $( Disjoin antecedents and consequents in a deduction.  (Contributed by NM,
       23-Apr-1995.) $)
    orim2d $p |- ( ph -> ( ( th \/ ps ) -> ( th \/ ch ) ) ) $=
      ( idd orim12d ) ADDBCADFEG $.
  $}

  $( Axiom *1.6 (Sum) of [WhiteheadRussell] p. 97.  (Contributed by NM,
     3-Jan-2005.) $)
  orim2 $p |- ( ( ps -> ch ) -> ( ( ph \/ ps ) -> ( ph \/ ch ) ) ) $=
    ( wi id orim2d ) BCDZBCAGEF $.

  $( Theorem *2.38 of [WhiteheadRussell] p. 105.  (Contributed by NM,
     6-Mar-2008.) $)
  pm2.38 $p |- ( ( ps -> ch ) -> ( ( ps \/ ph ) -> ( ch \/ ph ) ) ) $=
    ( wi id orim1d ) BCDZBCAGEF $.

  $( Theorem *2.36 of [WhiteheadRussell] p. 105.  (Contributed by NM,
     6-Mar-2008.) $)
  pm2.36 $p |- ( ( ps -> ch ) -> ( ( ph \/ ps ) -> ( ch \/ ph ) ) ) $=
    ( wo wi pm1.4 pm2.38 syl5 ) ABDBADBCECADABFABCGH $.

  $( Theorem *2.37 of [WhiteheadRussell] p. 105.  (Contributed by NM,
     6-Mar-2008.) $)
  pm2.37 $p |- ( ( ps -> ch ) -> ( ( ps \/ ph ) -> ( ph \/ ch ) ) ) $=
    ( wi wo pm2.38 pm1.4 syl6 ) BCDBAECAEACEABCFCAGH $.

  $( Theorem *2.81 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.81 $p |- ( ( ps -> ( ch -> th ) )
      -> ( ( ph \/ ps ) -> ( ( ph \/ ch ) -> ( ph \/ th ) ) ) ) $=
    ( wi wo orim2 pm2.76 syl6 ) BCDEZEABFAJFACFADFEABJGACDHI $.

  $( Theorem *2.8 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 5-Jan-2013.) $)
  pm2.8 $p |- ( ( ph \/ ps ) -> ( ( -. ps \/ ch ) -> ( ph \/ ch ) ) ) $=
    ( wo wn pm2.53 con1d orim1d ) ABDZBEACIABABFGH $.

  $( Theorem *2.73 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.73 $p |- ( ( ph -> ps )
       -> ( ( ( ph \/ ps ) \/ ch ) -> ( ps \/ ch ) ) ) $=
    ( wi wo pm2.621 orim1d ) ABDABEBCABFG $.

  $( Theorem *2.74 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
  pm2.74 $p |- ( ( ps -> ph )
      -> ( ( ( ph \/ ps ) \/ ch ) -> ( ph \/ ch ) ) ) $=
    ( wi wo orel2 ax-1 ja orim1d ) BADABEZACBAJADBAFAJGHI $.

  $( Theorem *2.82 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.82 $p |- ( ( ( ph \/ ps ) \/ ch ) -> ( ( ( ph \/ -. ch ) \/ th )
      -> ( ( ph \/ ps ) \/ th ) ) ) $=
    ( wo wn pm2.24 orim2d jao1i orim1d ) ABEZCEACFZEZKDKCMCLBACBGHIJ $.

  $( Theorem *4.39 of [WhiteheadRussell] p. 118.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.39 $p |- ( ( ( ph <-> ch ) /\ ( ps <-> th ) ) ->
                ( ( ph \/ ps ) <-> ( ch \/ th ) ) ) $=
    ( wb wa simpl simpr orbi12d ) ACEZBDEZFACBDJKGJKHI $.

  $( Conjunction implies disjunction with one common formula (1/4).
     (Contributed by BJ, 4-Oct-2019.) $)
  animorl $p |- ( ( ph /\ ps ) -> ( ph \/ ch ) ) $=
    ( wa simpl orcd ) ABDACABEF $.

  $( Conjunction implies disjunction with one common formula (2/4).
     (Contributed by BJ, 4-Oct-2019.) $)
  animorr $p |- ( ( ph /\ ps ) -> ( ch \/ ps ) ) $=
    ( wa simpr olcd ) ABDBCABEF $.

  $( Conjunction implies disjunction with one common formula (3/4).
     (Contributed by BJ, 4-Oct-2019.) $)
  animorlr $p |- ( ( ph /\ ps ) -> ( ch \/ ph ) ) $=
    ( wa simpl olcd ) ABDACABEF $.

  $( Conjunction implies disjunction with one common formula (4/4).
     (Contributed by BJ, 4-Oct-2019.) $)
  animorrl $p |- ( ( ph /\ ps ) -> ( ps \/ ch ) ) $=
    ( wa simpr orcd ) ABDBCABEF $.

  $( Negated conjunction in terms of disjunction (De Morgan's law).  Theorem
     *4.51 of [WhiteheadRussell] p. 120.  (Contributed by NM, 14-May-1993.)
     (Proof shortened by Andrew Salmon, 13-May-2011.) $)
  ianor $p |- ( -. ( ph /\ ps ) <-> ( -. ph \/ -. ps ) ) $=
    ( wa wn wi wo imnan pm4.62 bitr3i ) ABCDABDZEADJFABGABHI $.

  $( Conjunction in terms of disjunction (De Morgan's law).  Theorem *4.5 of
     [WhiteheadRussell] p. 120.  (Contributed by NM, 3-Jan-1993.)  (Proof
     shortened by Wolf Lammen, 3-Nov-2012.) $)
  anor $p |- ( ( ph /\ ps ) <-> -. ( -. ph \/ -. ps ) ) $=
    ( wa wn wo notnotb ianor xchbinx ) ABCZIDADBDEIFABGH $.

  $( Negated disjunction in terms of conjunction (De Morgan's law).  Compare
     Theorem *4.56 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-1993.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
  ioran $p |- ( -. ( ph \/ ps ) <-> ( -. ph /\ -. ps ) ) $=
    ( wn wi wa wo pm4.65 pm4.64 xchnxbi ) ACZBDJBCEABFABGABHI $.

  $( Theorem *4.52 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 5-Nov-2012.) $)
  pm4.52 $p |- ( ( ph /\ -. ps ) <-> -. ( -. ph \/ ps ) ) $=
    ( wn wa wi wo annim imor xchbinx ) ABCDABEACBFABGABHI $.

  $( Theorem *4.53 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.53 $p |- ( -. ( ph /\ -. ps ) <-> ( -. ph \/ ps ) ) $=
    ( wn wo wa pm4.52 con2bii bicomi ) ACBDZABCEZCJIABFGH $.

  $( Theorem *4.54 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 5-Nov-2012.) $)
  pm4.54 $p |- ( ( -. ph /\ ps ) <-> -. ( ph \/ -. ps ) ) $=
    ( wn wa wi wo df-an pm4.66 xchbinx ) ACZBDJBCZEAKFJBGABHI $.

  $( Theorem *4.55 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.55 $p |- ( -. ( -. ph /\ ps ) <-> ( ph \/ -. ps ) ) $=
    ( wn wo wa pm4.54 con2bii bicomi ) ABCDZACBEZCJIABFGH $.

  $( Theorem *4.56 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.56 $p |- ( ( -. ph /\ -. ps ) <-> -. ( ph \/ ps ) ) $=
    ( wo wn wa ioran bicomi ) ABCDADBDEABFG $.

  $( Disjunction in terms of conjunction (De Morgan's law).  Compare Theorem
     *4.57 of [WhiteheadRussell] p. 120.  (Contributed by NM, 3-Jan-1993.)
     (Proof shortened by Andrew Salmon, 7-May-2011.) $)
  oran $p |- ( ( ph \/ ps ) <-> -. ( -. ph /\ -. ps ) ) $=
    ( wn wa wo pm4.56 con2bii ) ACBCDABEABFG $.

  $( Theorem *4.57 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.57 $p |- ( -. ( -. ph /\ -. ps ) <-> ( ph \/ ps ) ) $=
    ( wo wn wa oran bicomi ) ABCADBDEDABFG $.

  $( Theorem *3.1 of [WhiteheadRussell] p. 111.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.1 $p |- ( ( ph /\ ps ) -> -. ( -. ph \/ -. ps ) ) $=
    ( wa wn wo anor biimpi ) ABCADBDEDABFG $.

  $( Theorem *3.11 of [WhiteheadRussell] p. 111.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.11 $p |- ( -. ( -. ph \/ -. ps ) -> ( ph /\ ps ) ) $=
    ( wa wn wo anor biimpri ) ABCADBDEDABFG $.

  $( Theorem *3.12 of [WhiteheadRussell] p. 111.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.12 $p |- ( ( -. ph \/ -. ps ) \/ ( ph /\ ps ) ) $=
    ( wn wo wa pm3.11 orri ) ACBCDABEABFG $.

  $( Theorem *3.13 of [WhiteheadRussell] p. 111.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.13 $p |- ( -. ( ph /\ ps ) -> ( -. ph \/ -. ps ) ) $=
    ( wn wo wa pm3.11 con1i ) ACBCDABEABFG $.

  $( Theorem *3.14 of [WhiteheadRussell] p. 111.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.14 $p |- ( ( -. ph \/ -. ps ) -> -. ( ph /\ ps ) ) $=
    ( wa wn wo pm3.1 con2i ) ABCADBDEABFG $.

  $( Theorem *4.44 of [WhiteheadRussell] p. 119.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.44 $p |- ( ph <-> ( ph \/ ( ph /\ ps ) ) ) $=
    ( wa wo orc id simpl jaoi impbii ) AAABCZDAJEAAJAFABGHI $.

  $( Theorem *4.45 of [WhiteheadRussell] p. 119.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.45 $p |- ( ph <-> ( ph /\ ( ph \/ ps ) ) ) $=
    ( wo orc pm4.71i ) AABCABDE $.

  $( Absorption of redundant internal disjunct.  Compare Theorem *4.45 of
     [WhiteheadRussell] p. 119.  (Contributed by NM, 21-Jun-1993.)  (Proof
     shortened by Wolf Lammen, 28-Feb-2014.) $)
  orabs $p |- ( ph <-> ( ( ph \/ ps ) /\ ph ) ) $=
    ( wo orc pm4.71ri ) AABCABDE $.

  $( Absorb a disjunct into a conjunct.  (Contributed by Roy F. Longton,
     23-Jun-2005.)  (Proof shortened by Wolf Lammen, 10-Nov-2013.) $)
  oranabs $p |- ( ( ( ph \/ -. ps ) /\ ps ) <-> ( ph /\ ps ) ) $=
    ( wn wo biortn orcom bitr2di pm5.32ri ) BABCZDZABAIADJBAEIAFGH $.

  $( Theorem *5.61 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 30-Jun-2013.) $)
  pm5.61 $p |- ( ( ( ph \/ ps ) /\ -. ps ) <-> ( ph /\ -. ps ) ) $=
    ( wn wo orel2 orc impbid1 pm5.32ri ) BCZABDZAIJABAEABFGH $.

  $( Conjunction in antecedent versus disjunction in consequent.  Theorem *5.6
     of [WhiteheadRussell] p. 125.  (Contributed by NM, 8-Jun-1994.) $)
  pm5.6 $p |- ( ( ( ph /\ -. ps ) -> ch ) <-> ( ph -> ( ps \/ ch ) ) ) $=
    ( wn wa wi wo impexp df-or imbi2i bitr4i ) ABDZECFALCFZFABCGZFALCHNMABCIJK
    $.

  ${
    orcanai.1 $e |- ( ph -> ( ps \/ ch ) ) $.
    $( Change disjunction in consequent to conjunction in antecedent.
       (Contributed by NM, 8-Jun-1994.) $)
    orcanai $p |- ( ( ph /\ -. ps ) -> ch ) $=
      ( wn ord imp ) ABECABCDFG $.
  $}

  ${
    orsild.1 $e |- ( ph -> -. ( ps \/ ch ) ) $.
    $( A lemma for not-or-not elimination, in deduction form.  (Contributed by
       Giovanni Mascellani, 15-Sep-2017.) $)
    orsild $p |- ( ph -> -. ps ) $=
      ( wn wo wa ioran sylib simpld ) ABEZCEZABCFEKLGDBCHIJ $.

    $( A lemma for not-or-not elimination, in deduction form.  (Contributed by
       Giovanni Mascellani, 15-Sep-2017.) $)
    orsird $p |- ( ph -> -. ch ) $=
      ( wn wo wa ioran sylib simprd ) ABEZCEZABCFEKLGDBCHIJ $.
  $}

  $( Theorem *4.79 of [WhiteheadRussell] p. 121.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 27-Jun-2013.) $)
  pm4.79 $p |- ( ( ( ps -> ph ) \/ ( ch -> ph ) ) <->
                ( ( ps /\ ch ) -> ph ) ) $=
    ( wi wo wa id jaoa wn simplim pm3.3 syl5 orrd impbii ) BADZCADZEBCFADZOBAPC
    OGPGHQOPOIBQPBAJBCAKLMN $.

  $( Theorem *5.53 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.53 $p |- ( ( ( ( ph \/ ps ) \/ ch ) -> th ) <->
                ( ( ( ph -> th ) /\ ( ps -> th ) ) /\ ( ch -> th ) ) ) $=
    ( wo wi wa jaob bianbi ) ABEZCEDFJDFCDFADFBDFGJDCHADBHI $.

  $( Distributive law for disjunction.  Theorem *4.41 of [WhiteheadRussell]
     p. 119.  (Contributed by NM, 5-Jan-1993.)  (Proof shortened by Andrew
     Salmon, 7-May-2011.)  (Proof shortened by Wolf Lammen, 28-Nov-2013.) $)
  ordi $p |- ( ( ph \/ ( ps /\ ch ) ) <-> ( ( ph \/ ps ) /\ ( ph \/ ch ) ) ) $=
    ( wn wa wi wo jcab df-or anbi12i 3bitr4i ) ADZBCEZFLBFZLCFZEAMGABGZACGZELBC
    HAMIPNQOABIACIJK $.

  $( Distributive law for disjunction.  (Contributed by NM, 12-Aug-1994.) $)
  ordir $p |- ( ( ( ph /\ ps ) \/ ch ) <->
              ( ( ph \/ ch ) /\ ( ps \/ ch ) ) ) $=
    ( wa wo ordi orcom anbi12i 3bitr4i ) CABDZECAEZCBEZDJCEACEZBCEZDCABFJCGMKNL
    ACGBCGHI $.

  $( Distributive law for conjunction.  Theorem *4.4 of [WhiteheadRussell]
     p. 118.  (Contributed by NM, 21-Jun-1993.)  (Proof shortened by Wolf
     Lammen, 5-Jan-2013.) $)
  andi $p |- ( ( ph /\ ( ps \/ ch ) ) <-> ( ( ph /\ ps ) \/ ( ph /\ ch ) ) ) $=
    ( wo wa orc olc jaodan anim2i jaoi impbii ) ABCDZEZABEZACEZDZABPCNOFONGHNMO
    BLABCFICLACBGIJK $.

  $( Distributive law for conjunction.  (Contributed by NM, 12-Aug-1994.) $)
  andir $p |- ( ( ( ph \/ ps ) /\ ch ) <->
              ( ( ph /\ ch ) \/ ( ps /\ ch ) ) ) $=
    ( wo wa andi ancom orbi12i 3bitr4i ) CABDZECAEZCBEZDJCEACEZBCEZDCABFJCGMKNL
    ACGBCGHI $.

  $( Double distributive law for disjunction.  (Contributed by NM,
     12-Aug-1994.) $)
  orddi $p |- ( ( ( ph /\ ps ) \/ ( ch /\ th ) ) <->
              ( ( ( ph \/ ch ) /\ ( ph \/ th ) ) /\
              ( ( ps \/ ch ) /\ ( ps \/ th ) ) ) ) $=
    ( wa wo ordir ordi anbi12i bitri ) ABECDEZFAKFZBKFZEACFADFEZBCFBDFEZEABKGLN
    MOACDHBCDHIJ $.

  $( Double distributive law for conjunction.  (Contributed by NM,
     12-Aug-1994.) $)
  anddi $p |- ( ( ( ph \/ ps ) /\ ( ch \/ th ) ) <->
              ( ( ( ph /\ ch ) \/ ( ph /\ th ) ) \/
              ( ( ps /\ ch ) \/ ( ps /\ th ) ) ) ) $=
    ( wo wa andir andi orbi12i bitri ) ABECDEZFAKFZBKFZEACFADFEZBCFBDFEZEABKGLN
    MOACDHBCDHIJ $.

$( Theorems relating XOR to conjunction or disjunction. $)

  $( Theorem *5.17 of [WhiteheadRussell] p. 124.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 3-Jan-2013.) $)
  pm5.17 $p |- ( ( ( ph \/ ps ) /\ -. ( ph /\ ps ) ) <-> ( ph <-> -. ps ) ) $=
    ( wn wb wi wa wo bicom dfbi2 orcom df-or bitr2i imnan anbi12i 3bitrri ) ABC
    ZDPADPAEZAPEZFABGZABFCZFAPHPAIQSRTSBAGQABJBAKLABMNO $.

  $( Theorem *5.15 of [WhiteheadRussell] p. 124.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 15-Oct-2013.) $)
  pm5.15 $p |- ( ( ph <-> ps ) \/ ( ph <-> -. ps ) ) $=
    ( wb wn xor3 biimpi orri ) ABCZABDCZHDIABEFG $.

  $( Theorem *5.16 of [WhiteheadRussell] p. 124.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 17-Oct-2013.) $)
  pm5.16 $p |- -. ( ( ph <-> ps ) /\ ( ph <-> -. ps ) ) $=
    ( wb wn wi wa pm5.18 biimpi imnan mpbi ) ABCZABDCZDZEKLFDKMABGHKLIJ $.

  $( Two ways to express exclusive disjunction ( ~ df-xor ).  Theorem *5.22 of
     [WhiteheadRussell] p. 124.  (Contributed by NM, 3-Jan-2005.)  (Proof
     shortened by Wolf Lammen, 22-Jan-2013.) $)
  xor $p |- ( -. ( ph <-> ps ) <->
                ( ( ph /\ -. ps ) \/ ( ps /\ -. ph ) ) ) $=
    ( wn wa wo wb wi iman anbi12i dfbi2 ioran 3bitr4ri con1bii ) ABCDZBACDZEZAB
    FZABGZBAGZDNCZOCZDQPCRTSUAABHBAHIABJNOKLM $.

  $( Two ways to express "exclusive or".  (Contributed by NM, 3-Jan-2005.)
     (Proof shortened by Wolf Lammen, 24-Jan-2013.) $)
  nbi2 $p |- ( -. ( ph <-> ps ) <-> ( ( ph \/ ps ) /\ -. ( ph /\ ps ) ) ) $=
    ( wb wn wo wa xor3 pm5.17 bitr4i ) ABCDABDCABEABFDFABGABHI $.

  $( Conjunction distributes over exclusive-or, using ` -. ( ph <-> ps ) ` to
     express exclusive-or.  This is one way to interpret the distributive law
     of multiplication over addition in modulo 2 arithmetic.  This is not
     necessarily true in intuitionistic logic, though ~ anxordi does hold in
     it.  (Contributed by NM, 3-Oct-2008.) $)
  xordi $p |- ( ( ph /\ -. ( ps <-> ch ) ) <->
                -. ( ( ph /\ ps ) <-> ( ph /\ ch ) ) ) $=
    ( wb wn wa wi annim pm5.32 xchbinx ) ABCDZEFAKGABFACFDAKHABCIJ $.

  $( Theorem *5.54 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 7-Nov-2013.) $)
  pm5.54 $p |- ( ( ( ph /\ ps ) <-> ph ) \/ ( ( ph /\ ps ) <-> ps ) ) $=
    ( wa wb iba bicomd adantl pm5.21ni orri ) ABCZADZJBDJKBBKABAJBAEFZGLHI $.

  $( Theorem *5.62 of [WhiteheadRussell] p. 125.  (Contributed by Roy F.
     Longton, 21-Jun-2005.) $)
  pm5.62 $p |- ( ( ( ph /\ ps ) \/ -. ps ) <-> ( ph \/ -. ps ) ) $=
    ( wa wn wo exmid ordir mpbiran2 ) ABCBDZEAIEBIEBFABIGH $.

  $( Theorem *5.63 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 25-Dec-2012.) $)
  pm5.63 $p |- ( ( ph \/ ps ) <-> ( ph \/ ( -. ph /\ ps ) ) ) $=
    ( wn wa wo exmid ordi mpbiran bicomi ) AACZBDEZABEZKAJELAFAJBGHI $.

  ${
    niabn.1 $e |- ph $.
    $( Miscellaneous inference relating falsehoods.  (Contributed by NM,
       31-Mar-1994.) $)
    niabn $p |- ( -. ps -> ( ( ch /\ ps ) <-> -. ph ) ) $=
      ( wa wn simpr pm2.24i pm5.21ni ) CBEBAFCBGABDHI $.
  $}

  ${
    ninba.1 $e |- ph $.
    $( Miscellaneous inference relating falsehoods.  (Contributed by NM,
       31-Mar-1994.) $)
    ninba $p |- ( -. ps -> ( -. ph <-> ( ch /\ ps ) ) ) $=
      ( wn wa niabn bicomd ) BECBFAEABCDGH $.
  $}

  $( Theorem *4.43 of [WhiteheadRussell] p. 119.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 26-Nov-2012.) $)
  pm4.43 $p |- ( ph <-> ( ( ph \/ ps ) /\ ( ph \/ -. ps ) ) ) $=
    ( wn wa wo pm3.24 biorfri ordi bitri ) AABBCZDZEABEAJEDKABFGABJHI $.

  $( Theorem *4.82 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.82 $p |- ( ( ( ph -> ps ) /\ ( ph -> -. ps ) ) <-> -. ph ) $=
    ( wi wn wa pm2.65 imp pm2.21 jca impbii ) ABCZABDZCZEADZKMNABFGNKMABHALHIJ
    $.

  $( Theorem *4.83 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.83 $p |- ( ( ( ph -> ps ) /\ ( -. ph -> ps ) ) <-> ps ) $=
    ( wn wo wi wa exmid a1bi jaob bitr2i ) BAACZDZBEABEKBEFLBAGHABKIJ $.

  $( Negation inferred from embedded conjunct.  (Contributed by NM,
     20-Aug-1993.)  (Proof shortened by Wolf Lammen, 25-Nov-2012.) $)
  pclem6 $p |- ( ( ph <-> ( ps /\ -. ph ) ) -> -. ps ) $=
    ( wn wa wb ibar nbbn sylib con2i ) BABACZDZEZBJKELCBJFAKGHI $.

  $( Dijkstra-Scholten's Golden Rule for calculational proofs.  (Contributed by
     NM, 10-Jan-2005.) $)
  bigolden $p |- ( ( ( ph /\ ps ) <-> ph ) <-> ( ps <-> ( ph \/ ps ) ) ) $=
    ( wi wa wb wo pm4.71 pm4.72 bicom 3bitr3ri ) ABCAABDZEBABFEKAEABGABHAKIJ $.

  $( Theorem *5.71 of [WhiteheadRussell] p. 125.  (Contributed by Roy F.
     Longton, 23-Jun-2005.) $)
  pm5.71 $p |- ( ( ps -> -. ch ) -> ( ( ( ph \/ ps ) /\ ch ) <->
                ( ph /\ ch ) ) ) $=
    ( wn wo wa wb orel2 orc impbid1 anbi1d pm2.21 pm5.32rd ja ) BCDZABEZCFACFGB
    DZPACQPABAHABIJKOCPACPAGLMN $.

  $( Theorem *5.75 of [WhiteheadRussell] p. 126.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Andrew Salmon, 7-May-2011.)  (Proof
     shortened by Wolf Lammen, 23-Dec-2012.)  (Proof shortened by Kyle Wyonch,
     12-Feb-2021.) $)
  pm5.75 $p |- ( ( ( ch -> -. ps ) /\ ( ph <-> ( ps \/ ch ) ) )
      -> ( ( ph /\ -. ps ) <-> ch ) ) $=
    ( wo wb wn wa wi anbi1 biorf bicomd pm5.32ri bitrdi abai rbaib sylan9bbr )
    ABCDZEZABFZGZCSGZCSHZCRTQSGUAAQSISQCSCQBCJKLMUACUBCSNOP $.

  ${
    ecase2d.1 $e |- ( ph -> ps ) $.
    ecase2d.2 $e |- ( ph -> -. ( ps /\ ch ) ) $.
    ecase2d.3 $e |- ( ph -> -. ( ps /\ th ) ) $.
    ecase2d.4 $e |- ( ph -> ( ta \/ ( ch \/ th ) ) ) $.
    $( Deduction for elimination by cases.  (Contributed by NM, 21-Apr-1994.)
       (Proof shortened by Wolf Lammen, 19-Sep-2024.) $)
    ecase2d $p |- ( ph -> ta ) $=
      ( wn mpnanrd wo ord mtord notnotrd ) AEAEJCDABCFGKABDFHKAECDLIMNO $.
  $}

  ${
    ecase3.1 $e |- ( ph -> ch ) $.
    ecase3.2 $e |- ( ps -> ch ) $.
    ecase3.3 $e |- ( -. ( ph \/ ps ) -> ch ) $.
    $( Inference for elimination by cases.  (Contributed by NM, 23-Mar-1995.)
       (Proof shortened by Wolf Lammen, 26-Nov-2012.) $)
    ecase3 $p |- ch $=
      ( wo jaoi pm2.61i ) ABGCACBDEHFI $.
  $}

  ${
    ecase.1 $e |- ( -. ph -> ch ) $.
    ecase.2 $e |- ( -. ps -> ch ) $.
    ecase.3 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Inference for elimination by cases.  (Contributed by NM,
       13-Jul-2005.) $)
    ecase $p |- ch $=
      ( ex pm2.61nii ) ABCABCFGDEH $.
  $}

  ${
    ecase3d.1 $e |- ( ph -> ( ps -> th ) ) $.
    ecase3d.2 $e |- ( ph -> ( ch -> th ) ) $.
    ecase3d.3 $e |- ( ph -> ( -. ( ps \/ ch ) -> th ) ) $.
    $( Deduction for elimination by cases.  (Contributed by NM, 2-May-1996.)
       (Proof shortened by Andrew Salmon, 7-May-2011.) $)
    ecase3d $p |- ( ph -> th ) $=
      ( wo jaod pm2.61d ) ABCHDABDCEFIGJ $.
  $}

  ${
    ecased.1 $e |- ( ph -> ( -. ps -> th ) ) $.
    ecased.2 $e |- ( ph -> ( -. ch -> th ) ) $.
    ecased.3 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( Deduction for elimination by cases.  (Contributed by NM, 8-Oct-2012.) $)
    ecased $p |- ( ph -> th ) $=
      ( wn wo wa pm3.11 syl5 ecase3d ) ABHZCHZDEFNOIHBCJADBCKGLM $.
  $}

  ${
    ecase3ad.1 $e |- ( ph -> ( ps -> th ) ) $.
    ecase3ad.2 $e |- ( ph -> ( ch -> th ) ) $.
    ecase3ad.3 $e |- ( ph -> ( ( -. ps /\ -. ch ) -> th ) ) $.
    $( Deduction for elimination by cases.  (Contributed by NM, 24-May-2013.)
       (Proof shortened by Wolf Lammen, 20-Sep-2024.) $)
    ecase3ad $p |- ( ph -> th ) $=
      ( imp wn wa pm2.61ddan ) ABCDABDEHACDFHABICIJDGHK $.
  $}

  ${
    ccase.1 $e |- ( ( ph /\ ps ) -> ta ) $.
    ccase.2 $e |- ( ( ch /\ ps ) -> ta ) $.
    ccase.3 $e |- ( ( ph /\ th ) -> ta ) $.
    ccase.4 $e |- ( ( ch /\ th ) -> ta ) $.
    $( Inference for combining cases.  (Contributed by NM, 29-Jul-1999.)
       (Proof shortened by Wolf Lammen, 6-Jan-2013.) $)
    ccase $p |- ( ( ( ph \/ ch ) /\ ( ps \/ th ) ) -> ta ) $=
      ( wo jaoian jaodan ) ACJBEDABECFGKADECHIKL $.
  $}

  ${
    ccased.1 $e |- ( ph -> ( ( ps /\ ch ) -> et ) ) $.
    ccased.2 $e |- ( ph -> ( ( th /\ ch ) -> et ) ) $.
    ccased.3 $e |- ( ph -> ( ( ps /\ ta ) -> et ) ) $.
    ccased.4 $e |- ( ph -> ( ( th /\ ta ) -> et ) ) $.
    $( Deduction for combining cases.  (Contributed by NM, 9-May-2004.) $)
    ccased $p |- ( ph -> ( ( ( ps \/ th ) /\ ( ch \/ ta ) ) -> et ) ) $=
      ( wo wa wi com12 ccase ) BDKCEKLAFBCDEAFMABCLFGNADCLFHNABELFINADELFJNON
      $.
  $}

  ${
    ccase2.1 $e |- ( ( ph /\ ps ) -> ta ) $.
    ccase2.2 $e |- ( ch -> ta ) $.
    ccase2.3 $e |- ( th -> ta ) $.
    $( Inference for combining cases.  (Contributed by NM, 29-Jul-1999.) $)
    ccase2 $p |- ( ( ( ph \/ ch ) /\ ( ps \/ th ) ) -> ta ) $=
      ( adantr adantl ccase ) ABCDEFCEBGIDEAHJDECHJK $.
  $}

  ${
    4cases.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    4cases.2 $e |- ( ( ph /\ -. ps ) -> ch ) $.
    4cases.3 $e |- ( ( -. ph /\ ps ) -> ch ) $.
    4cases.4 $e |- ( ( -. ph /\ -. ps ) -> ch ) $.
    $( Inference eliminating two antecedents from the four possible cases that
       result from their true/false combinations.  (Contributed by NM,
       25-Oct-2003.) $)
    4cases $p |- ch $=
      ( pm2.61ian wn pm2.61i ) BCABCDFHABICEGHJ $.
  $}

  ${
    4casesdan.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    4casesdan.2 $e |- ( ( ph /\ ( ps /\ -. ch ) ) -> th ) $.
    4casesdan.3 $e |- ( ( ph /\ ( -. ps /\ ch ) ) -> th ) $.
    4casesdan.4 $e |- ( ( ph /\ ( -. ps /\ -. ch ) ) -> th ) $.
    $( Deduction eliminating two antecedents from the four possible cases that
       result from their true/false combinations.  (Contributed by NM,
       19-Mar-2013.) $)
    4casesdan $p |- ( ph -> th ) $=
      ( wi wa expcom wn 4cases ) BCADIABCJDEKABCLZJDFKABLZCJDGKAONJDHKM $.
  $}

  ${
    cases.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    cases.2 $e |- ( -. ph -> ( ps <-> th ) ) $.
    $( Case disjunction according to the value of ` ph ` .  (Contributed by NM,
       25-Apr-2019.) $)
    cases $p |- ( ps <-> ( ( ph /\ ch ) \/ ( -. ph /\ th ) ) ) $=
      ( wn wo wa exmid biantrur andir pm5.32i orbi12i 3bitri ) BAAGZHZBIABIZPBI
      ZHACIZPDIZHQBAJKAPBLRTSUAABCEMPBDFMNO $.
  $}

  $( Lemma for an alternate version of weak deduction theorem.  (Contributed by
     NM, 2-Apr-1994.)  (Proof shortened by Andrew Salmon, 7-May-2011.)  (Proof
     shortened by Wolf Lammen, 4-Dec-2012.) $)
  dedlem0a $p |- ( ph -> ( ps <-> ( ( ch -> ph ) -> ( ps /\ ph ) ) ) ) $=
    ( wa wi iba wb biimt jarri bitrd ) ABBADZCAEZKEZABFCAKMGLKHIJ $.

  $( Lemma for an alternate version of weak deduction theorem.  (Contributed by
     NM, 2-Apr-1994.) $)
  dedlem0b $p |- ( -. ph -> ( ps <-> ( ( ps -> ph ) -> ( ch /\ ph ) ) ) ) $=
    ( wn wi wa pm2.21 imim2d com23 simpr imim12i con1d com12 impbid ) ADZBBAEZC
    AFZEZOPBQOAQBAQGHIROBRBABDPQABAGCAJKLMN $.

  $( Lemma for weak deduction theorem.  See also ~ ifptru .  (Contributed by
     NM, 26-Jun-2002.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
  dedlema $p |- ( ph -> ( ps <-> ( ( ps /\ ph ) \/ ( ch /\ -. ph ) ) ) ) $=
    ( wa wn wo orc expcom wi simpl a1i pm2.24 adantld jaod impbid ) ABBADZCAEZD
    ZFZBASPRGHAPBRPBIABAJKAQBCABLMNO $.

  $( Lemma for weak deduction theorem.  See also ~ ifpfal .  (Contributed by
     NM, 15-May-1999.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
  dedlemb $p |- ( -. ph -> ( ch <-> ( ( ps /\ ph ) \/ ( ch /\ -. ph ) ) ) ) $=
    ( wn wa wo olc expcom pm2.21 adantld wi simpl a1i jaod impbid ) ADZCBAEZCPE
    ZFZCPSRQGHPQCRPACBACIJRCKPCPLMNO $.

  $( Case disjunction according to the value of ` ph ` .  (Contributed by BJ,
     6-Apr-2019.)  (Proof shortened by Wolf Lammen, 28-Feb-2022.) $)
  cases2 $p |- ( ( ( ph /\ ps ) \/ ( -. ph /\ ch ) )
                                   <-> ( ( ph -> ps ) /\ ( -. ph -> ch ) ) ) $=
    ( wa wn wo wi pm4.83 dedlema pm5.74i dedlemb anbi12i ancom orbi12i 3bitr4ri
    ) ABADZCAEZDZFZGZQSGZDSABGZQCGZDABDZQCDZFASHUBTUCUAABSABCIJQCSABCKJLUDPUERA
    BMQCMNO $.

  $( Alternate proof of ~ cases2 , not using ~ dedlema or ~ dedlemb .
     (Contributed by BJ, 6-Apr-2019.)  (Proof shortened by Wolf Lammen,
     2-Jan-2020.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  cases2ALT $p |- ( ( ( ph /\ ps ) \/ ( -. ph /\ ch ) )
                                   <-> ( ( ph -> ps ) /\ ( -. ph -> ch ) ) ) $=
    ( wa wn wo wi pm3.4 pm2.24 adantr pm2.21 jaoi pm2.27 imdistani orcd adantrr
    jca olcd adantrl pm2.61ian impbii ) ABDZAEZCDZFZABGZUCCGZDZUBUHUDUBUFUGABHA
    UGBACIJQUDUFUGUCUFCABKJUCCHQLAUHUEAUFUEUGAUFDUBUDAUFBABMNOPUCUGUEUFUCUGDUDU
    BUCUGCUCCMNRSTUA $.

  $( An alternate definition of the biconditional.  Theorem *5.23 of
     [WhiteheadRussell] p. 124.  (Contributed by NM, 27-Jun-2002.)  (Proof
     shortened by Wolf Lammen, 3-Nov-2013.)  (Proof shortened by NM,
     29-Oct-2021.) $)
  dfbi3 $p |- ( ( ph <-> ps ) <-> ( ( ph /\ ps ) \/ ( -. ph /\ -. ps ) ) ) $=
    ( wi wa wn wb wo con34b anbi2i dfbi2 cases2 3bitr4i ) ABCZBACZDMAEZBEZCZDAB
    FABDOPDGNQMBAHIABJABPKL $.

  $( Theorem *5.24 of [WhiteheadRussell] p. 124.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.24 $p |- ( -. ( ( ph /\ ps ) \/ ( -. ph /\ -. ps ) ) <->
                ( ( ph /\ -. ps ) \/ ( ps /\ -. ph ) ) ) $=
    ( wb wn wa wo xor dfbi3 xchnxbi ) ABCABDZEBADZEFABEKJEFABGABHI $.

  $( The disjunction of the four possible combinations of two wffs and their
     negations is always true.  A four-way excluded middle (see ~ exmid ).
     (Contributed by David Abernethy, 28-Jan-2014.)  (Proof shortened by NM,
     29-Oct-2021.) $)
  4exmid $p |- ( ( ( ph /\ ps ) \/ ( -. ph /\ -. ps ) )
              \/ ( ( ph /\ -. ps ) \/ ( ps /\ -. ph ) ) ) $=
    ( wa wn wo pm5.24 biimpi orri ) ABCADZBDZCEZAJCBICEZKDLABFGH $.

  $( The consensus theorem.  This theorem and its dual (with ` \/ ` and ` /\ `
     interchanged) are commonly used in computer logic design to eliminate
     redundant terms from Boolean expressions.  Specifically, we prove that the
     term ` ( ps /\ ch ) ` on the left-hand side is redundant.  (Contributed by
     NM, 16-May-2003.)  (Proof shortened by Andrew Salmon, 13-May-2011.)
     (Proof shortened by Wolf Lammen, 20-Jan-2013.) $)
  consensus $p |- ( ( ( ( ph /\ ps ) \/ ( -. ph /\ ch ) ) \/ ( ps /\ ch ) ) <->
                      ( ( ph /\ ps ) \/ ( -. ph /\ ch ) ) ) $=
    ( wa wn wo id orc adantrr olc adantrl pm2.61ian jaoi impbii ) ABDZAEZCDZFZB
    CDZFRRRSRGASRABRCOQHIPCRBQOJKLMRSHN $.

  $( Theorem *4.42 of [WhiteheadRussell] p. 119.  See also ~ ifpid .
     (Contributed by Roy F. Longton, 21-Jun-2005.) $)
  pm4.42 $p |- ( ph <-> ( ( ph /\ ps ) \/ ( ph /\ -. ps ) ) ) $=
    ( wa wn wo wb dedlema dedlemb pm2.61i ) BAABCABDCEFBAAGBAAHI $.

  ${
    prlem1.1 $e |- ( ph -> ( et <-> ch ) ) $.
    prlem1.2 $e |- ( ps -> -. th ) $.
    $( A specialized lemma for set theory (to derive the Axiom of Pairing).
       (Contributed by NM, 18-Oct-1995.)  (Proof shortened by Andrew Salmon,
       13-May-2011.)  (Proof shortened by Wolf Lammen, 5-Jan-2013.) $)
    prlem1 $p |- ( ph -> ( ps ->
                  ( ( ( ps /\ ch ) \/ ( th /\ ta ) ) -> et ) ) ) $=
      ( wa wo wi biimprd adantld pm2.21d adantrd jaao ex ) ABBCIZDEIZJFKARFBSAC
      FBAFCGLMBDFEBDFHNOPQ $.
  $}

  $( A specialized lemma for set theory (to derive the Axiom of Pairing).
     (Contributed by NM, 21-Jun-1993.)  (Proof shortened by Andrew Salmon,
     13-May-2011.)  (Proof shortened by Wolf Lammen, 9-Dec-2012.) $)
  prlem2 $p |- ( ( ( ph /\ ps ) \/ ( ch /\ th ) ) <->
              ( ( ph \/ ch ) /\ ( ( ph /\ ps ) \/ ( ch /\ th ) ) ) ) $=
    ( wa wo simpl orim12i pm4.71ri ) ABEZCDEZFACFJAKCABGCDGHI $.

  ${
    oplem1.1 $e |- ( ph -> ( ps \/ ch ) ) $.
    oplem1.2 $e |- ( ph -> ( th \/ ta ) ) $.
    oplem1.3 $e |- ( ps <-> th ) $.
    oplem1.4 $e |- ( ch -> ( th <-> ta ) ) $.
    $( A specialized lemma for set theory (ordered pair theorem).  (Contributed
       by NM, 18-Oct-1995.)  (Proof shortened by Wolf Lammen, 8-Dec-2012.) $)
    oplem1 $p |- ( ph -> ps ) $=
      ( wn wa notbii ord biimtrrid jcad biimpar syl6 pm2.18d sylibr ) ADBADADJZ
      CEKDATCETBJACBDHLABCFMNADEGMOCDEIPQRHS $.
  $}

  $( A single axiom for Boolean algebra known as DN_1.  See McCune, Veroff,
     Fitelson, Harris, Feist, Wos, _Short single axioms for Boolean algebra_,
     Journal of Automated Reasoning, 29(1):1--16, 2002.
     ( ~ https://www.cs.unm.edu/~~mccune/papers/basax/v12.pdf ).  (Contributed
     by Jeff Hankins, 3-Jul-2009.)  (Proof shortened by Andrew Salmon,
     13-May-2011.)  (Proof shortened by Wolf Lammen, 6-Jan-2013.) $)
  dn1 $p |- ( -. ( -. ( -. ( ph \/ ps ) \/ ch ) \/
            -. ( ph \/ -. ( -. ch \/ -. ( ch \/ th ) ) ) ) <-> ch ) $=
    ( wo wn wa pm2.45 imnan mpbi biorfri orcom ordir 3bitri pm4.45 bitri orbi2i
    wi anor anbi2i 3bitrri ) CABEFZCEZACEZGZUCACFCDEZFEFZEZGUCFUHFEFCCUBAGZEUIC
    EUEUICUBAFRUIFABHUBAIJKCUILUBACMNUDUHUCCUGACCUFGUGCDOCUFSPQTUCUHSUA $.

  $( A closed form of ~ mpbir , analogous to ~ pm2.27 (assertion).
     (Contributed by Jonathan Ben-Naim, 3-Jun-2011.)  (Proof shortened by Roger
     Witte, 17-Aug-2020.) $)
  bianir $p |- ( ( ph /\ ( ps <-> ph ) ) -> ps ) $=
    ( wb biimpr impcom ) BACABBADE $.

  ${
    jaoi2.1 $e |- ( ( ph \/ ( -. ph /\ ch ) ) -> ps ) $.
    $( Inference removing a negated conjunct in a disjunction of an antecedent
       if this conjunct is part of the disjunction.  (Contributed by Alexander
       van der Vekens, 3-Nov-2017.)  (Proof shortened by Wolf Lammen,
       21-Sep-2018.) $)
    jaoi2 $p |- ( ( ph \/ ch ) -> ps ) $=
      ( wo wn wa pm5.63 sylbi ) ACEAAFCGEBACHDI $.
  $}

  ${
    jaoi3.1 $e |- ( ph -> ps ) $.
    jaoi3.2 $e |- ( ( -. ph /\ ch ) -> ps ) $.
    $( Inference separating a disjunct of an antecedent.  (Contributed by
       Alexander van der Vekens, 25-May-2018.) $)
    jaoi3 $p |- ( ( ph \/ ch ) -> ps ) $=
      ( wn wa jaoi jaoi2 ) ABCABAFCGDEHI $.
  $}

  $( Selecting one statement from a disjunction if one of the disjuncted
     statements is false.  (Contributed by AV, 6-Sep-2018.)  (Proof shortened
     by AV, 13-Oct-2018.)  (Proof shortened by Wolf Lammen, 19-Jan-2020.) $)
  ornld $p |- ( ph -> ( ( ( ph -> ( th \/ ta ) ) /\ -. th ) -> ta ) ) $=
    ( wo wi wn wa pm3.35 ord expimpd ) AABCDZEZBFCALGBCAKHIJ $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  The conditional operator for propositions
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  This subsection introduces the conditional operator for propositions, denoted
  by ` if- ( ph , ps , ch ) ` (see ~ df-ifp ).  It is the analogue for
  propositions of the conditional operator for classes, denoted by
  ` if ( ph , A , B ) ` (see ~ df-if ).

$)

  $( Comma.  Also used later for adders, pairs, tuples, etc. $)
  $c , $.

  $( Symbol for the conditional operator for propositions. $)
  $c if- $.

  $( Extend wff notation to include the conditional operator for
     propositions. $)
  wif $a wff if- ( ph , ps , ch ) $.

  $( Definition of the conditional operator for propositions.  The expression
     ` if- ( ph , ps , ch ) ` is read "if ` ph ` then ` ps ` else ` ch ` ".
     See ~ dfifp2 , ~ dfifp3 , ~ dfifp4 , ~ dfifp5 , ~ dfifp6 and ~ dfifp7 for
     alternate definitions.

     This definition (in the form of ~ dfifp2 ) appears in Section II.24 of
     [Church] p. 129 (Definition D12 page 132), where it is called "conditioned
     disjunction".  Church's ` [ ps , ph , ch ] ` corresponds to our
     ` if- ( ph , ps , ch ) ` (note the permutation of the first two
     variables).

     This form was chosen as the definition rather than ~ dfifp2 for
     compatibility with intuitionistic logic development: with this form, it is
     clear that ` if- ( ph , ps , ch ) ` implies decidability of ` ph ` , which
     is most often what is wanted.

     Church uses the conditional operator as an intermediate step to prove
     completeness of some systems of connectives.  The first result is that the
     system ` { if- , T. , F. } ` is complete: for the induction step, consider
     a formula of n+1 variables; single out one variable, say ` ph ` ; when one
     sets ` ph ` to True (resp.  False), then what remains is a formula of n
     variables, so by the induction hypothesis it is equivalent to a formula
     using only the connectives ` if- , T. , F. ` , say ` ps ` (resp. ` ch ` );
     therefore, the formula ` if- ( ph , ps , ch ) ` is equivalent to the
     initial formula of n+1 variables.  Now, since ` { -> , -. } ` and similar
     systems suffice to express the connectives ` if- , T. , F. ` , they are
     also complete.

     (Contributed by BJ, 22-Jun-2019.) $)
  df-ifp $a |-
            ( if- ( ph , ps , ch ) <-> ( ( ph /\ ps ) \/ ( -. ph /\ ch ) ) ) $.

  $( Alternate definition of the conditional operator for propositions.  The
     value of ` if- ( ph , ps , ch ) ` is "if ` ph ` then ` ps ` , and if not
     ` ph ` then ` ch ` ".  This is the definition used in Section II.24 of
     [Church] p. 129 (Definition D12 page 132) (see comment of ~ df-ifp ).
     (Contributed by BJ, 22-Jun-2019.) $)
  dfifp2 $p |-
            ( if- ( ph , ps , ch ) <-> ( ( ph -> ps ) /\ ( -. ph -> ch ) ) ) $=
    ( wif wa wn wo wi df-ifp cases2 bitri ) ABCDABEAFZCEGABHLCHEABCIABCJK $.

  $( Alternate definition of the conditional operator for propositions.
     (Contributed by BJ, 30-Sep-2019.) $)
  dfifp3 $p |- ( if- ( ph , ps , ch ) <-> ( ( ph -> ps ) /\ ( ph \/ ch ) ) ) $=
    ( wif wi wn wa wo dfifp2 pm4.64 anbi2i bitri ) ABCDABEZAFCEZGMACHZGABCINOMA
    CJKL $.

  $( Alternate definition of the conditional operator for propositions.
     (Contributed by BJ, 30-Sep-2019.) $)
  dfifp4 $p |-
            ( if- ( ph , ps , ch ) <-> ( ( -. ph \/ ps ) /\ ( ph \/ ch ) ) ) $=
    ( wif wi wo wn dfifp3 imor bianbi ) ABCDABEACFAGBFABCHABIJ $.

  $( Alternate definition of the conditional operator for propositions.
     (Contributed by BJ, 2-Oct-2019.) $)
  dfifp5 $p |-
         ( if- ( ph , ps , ch ) <-> ( ( -. ph \/ ps ) /\ ( -. ph -> ch ) ) ) $=
    ( wif wi wn wo dfifp2 imor bianbi ) ABCDABEAFZCEKBGABCHABIJ $.

  $( Alternate definition of the conditional operator for propositions.
     (Contributed by BJ, 2-Oct-2019.) $)
  dfifp6 $p |-
            ( if- ( ph , ps , ch ) <-> ( ( ph /\ ps ) \/ -. ( ch -> ph ) ) ) $=
    ( wif wa wn wo wi df-ifp ancom annim bitri orbi2i ) ABCDABEZAFZCEZGNCAHFZGA
    BCIPQNPCOEQOCJCAKLML $.

  $( Alternate definition of the conditional operator for propositions.
     (Contributed by BJ, 2-Oct-2019.) $)
  dfifp7 $p |- ( if- ( ph , ps , ch ) <-> ( ( ch -> ph ) -> ( ph /\ ps ) ) ) $=
    ( wa wi wn wo wif orcom dfifp6 imor 3bitr4i ) ABDZCAEZFZGOMGABCHNMEMOIABCJN
    MKL $.

  $( Define the biconditional as conditional logic operator.  (Contributed by
     RP, 20-Apr-2020.)  (Proof shortened by Wolf Lammen, 30-Apr-2024.)  (Proof
     shortened by Garrett Katz, 25-Jun-2026.) $)
  ifpdfbi $p |- ( ( ph <-> ps ) <-> if- ( ph , ps , -. ps ) ) $=
    ( wb wa wn wo wif dfbi3 df-ifp bitr4i ) ABCABDAEBEZDFABKGABHABKIJ $.

  $( Obsolete version of ~ ifpdfbi as of 25-Jun-2026.  Define the biconditional
     as conditional logic operator.  (Contributed by RP, 20-Apr-2020.)  (Proof
     shortened by Wolf Lammen, 30-Apr-2024.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  ifpdfbiOLD $p |- ( ( ph <-> ps ) <-> if- ( ph , ps , -. ps ) ) $=
    ( wi wa wn wb wif con34b anbi2i dfbi2 dfifp2 3bitr4i ) ABCZBACZDMAEBEZCZDAB
    FABOGNPMBAHIABJABOKL $.

  $( The conditional operator is implied by the conjunction of its possible
     outputs.  Dual statement of ~ ifpor .  (Contributed by BJ,
     30-Sep-2019.) $)
  anifp $p |- ( ( ps /\ ch ) -> if- ( ph , ps , ch ) ) $=
    ( wa wn wo wif olc anim12i dfifp4 sylibr ) BCDAEZBFZACFZDABCGBMCNBLHCAHIABC
    JK $.

  $( The conditional operator implies the disjunction of its possible outputs.
     Dual statement of ~ anifp .  (Contributed by BJ, 1-Oct-2019.) $)
  ifpor $p |- ( if- ( ph , ps , ch ) -> ( ps \/ ch ) ) $=
    ( wif wa wn wo df-ifp simpr orim12i sylbi ) ABCDABEZAFZCEZGBCGABCHLBNCABIMC
    IJK $.

  $( Conditional operator for the negation of a proposition.  (Contributed by
     BJ, 30-Sep-2019.)  (Proof shortened by Wolf Lammen, 5-May-2024.) $)
  ifpn $p |- ( if- ( ph , ps , ch ) <-> if- ( -. ph , ch , ps ) ) $=
    ( wn wo wi wa wif ancom dfifp5 dfifp3 3bitr4i ) ADZBEZMCFZGONGABCHMCBHNOIAB
    CJMCBKL $.

  $( Value of the conditional operator for propositions when its first argument
     is true.  Analogue for propositions of ~ iftrue .  This is essentially
     ~ dedlema .  (Contributed by BJ, 20-Sep-2019.)  (Proof shortened by Wolf
     Lammen, 10-Jul-2020.) $)
  ifptru $p |- ( ph -> ( if- ( ph , ps , ch ) <-> ps ) ) $=
    ( wi wif biimt wo wa orc biantrud dfifp3 bitr4di bitr2d ) ABABDZABCEZABFANN
    ACGZHOAPNACIJABCKLM $.

  $( Value of the conditional operator for propositions when its first argument
     is false.  Analogue for propositions of ~ iffalse .  This is essentially
     ~ dedlemb .  (Contributed by BJ, 20-Sep-2019.)  (Proof shortened by Wolf
     Lammen, 25-Jun-2020.) $)
  ifpfal $p |- ( -. ph -> ( if- ( ph , ps , ch ) <-> ch ) ) $=
    ( wif wn ifpn ifptru bitrid ) ABCDAEZCBDICABCFICBGH $.

  $( Value of the conditional operator for propositions when the same
     proposition is returned in either case.  Analogue for propositions of
     ~ ifid .  This is essentially ~ pm4.42 .  (Contributed by BJ,
     20-Sep-2019.) $)
  ifpid $p |- ( if- ( ph , ps , ps ) <-> ps ) $=
    ( wif wb ifptru ifpfal pm2.61i ) AABBCBDABBEABBFG $.

  ${
    casesifp.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    casesifp.2 $e |- ( -. ph -> ( ps <-> th ) ) $.
    $( Version of ~ cases expressed using ` if- ` .  Case disjunction according
       to the value of ` ph ` .  One can see this as a proof that the two
       hypotheses characterize the conditional operator for propositions.  For
       the converses, see ~ ifptru and ~ ifpfal .  (Contributed by BJ,
       20-Sep-2019.) $)
    casesifp $p |- ( ps <-> if- ( ph , ch , th ) ) $=
      ( wa wn wo wif cases df-ifp bitr4i ) BACGAHDGIACDJABCDEFKACDLM $.
  $}

  ${
    ifpbi123d.1 $e |- ( ph -> ( ps <-> ta ) ) $.
    ifpbi123d.2 $e |- ( ph -> ( ch <-> et ) ) $.
    ifpbi123d.3 $e |- ( ph -> ( th <-> ze ) ) $.
    $( Equivalence deduction for conditional operator for propositions.
       (Contributed by AV, 30-Dec-2020.)  (Proof shortened by Wolf Lammen,
       17-Apr-2024.) $)
    ifpbi123d $p |- ( ph -> ( if- ( ps , ch , th )
                              <-> if- ( ta , et , ze ) ) ) $=
      ( wi wo wa wif imbi12d orbi12d anbi12d dfifp3 3bitr4g ) ABCKZBDLZMEFKZEGL
      ZMBCDNEFGNATUBUAUCABECFHIOABEDGHJPQBCDREFGRS $.
  $}

  ${
    ifpbi23d.1 $e |- ( ph -> ( ch <-> et ) ) $.
    ifpbi23d.2 $e |- ( ph -> ( th <-> ze ) ) $.
    $( Equivalence deduction for conditional operator for propositions.
       Convenience theorem for a frequent case.  (Contributed by Wolf Lammen,
       28-Apr-2024.) $)
    ifpbi23d $p |- ( ph -> ( if- ( ps , ch , th )
                              <-> if- ( ps , et , ze ) ) ) $=
      ( biidd ifpbi123d ) ABCDBEFABIGHJ $.
  $}

  ${
    ifpimpda.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    ifpimpda.2 $e |- ( ( ph /\ -. ps ) -> th ) $.
    $( Separation of the values of the conditional operator for propositions.
       (Contributed by AV, 30-Dec-2020.)  (Proof shortened by Wolf Lammen,
       27-Feb-2021.) $)
    ifpimpda $p |- ( ph -> if- ( ps , ch , th ) ) $=
      ( wi wn wif ex dfifp2 sylanbrc ) ABCGBHZDGBCDIABCEJAMDFJBCDKL $.
  $}

  ${
    1fpid3.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( The value of the conditional operator for propositions is its third
       argument if the first and second argument imply the third argument.
       (Contributed by AV, 4-Apr-2021.) $)
    1fpid3 $p |- ( if- ( ph , ps , ch ) -> ch ) $=
      ( wif wa wn wo df-ifp simpr jaoi sylbi ) ABCEABFZAGZCFZHCABCIMCODNCJKL $.
  $}


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  The weak deduction theorem for propositional calculus
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  This subsection contains a few results related to the weak deduction theorem
  in propositional calculus.  For the weak deduction theorem in set theory, see
  the section beginning with ~ dedth .  For more information on the weak
  deduction theorem, see the Weak Deduction Theorem page ~ mmdeduction.html .

$)

  ${
    elimh.1 $e |- ( ( if- ( ch , ph , ps ) <-> ph ) -> ( ta <-> ch ) ) $.
    elimh.2 $e |- ( ( if- ( ch , ph , ps ) <-> ps ) -> ( ta <-> th ) ) $.
    elimh.3 $e |- th $.
    $( Hypothesis builder for the weak deduction theorem.  For more
       information, see the Weak Deduction Theorem page ~ mmdeduction.html .
       (Contributed by NM, 26-Jun-2002.)  Revised to use the conditional
       operator.  (Revised by BJ, 30-Sep-2019.)  Commute consequent.  (Revised
       by Steven Nguyen, 27-Apr-2023.) $)
    elimh $p |- ta $=
      ( wif wb ifptru syl ibir wn ifpfal mpbiri pm2.61i ) CECECCABIZAJECJCABKFL
      MCNZEDHSRBJEDJCABOGLPQ $.
  $}

  ${
    dedt.1 $e |- ( ( if- ( ch , ph , ps ) <-> ph ) -> ( ta <-> th ) ) $.
    dedt.2 $e |- ta $.
    $( The weak deduction theorem.  For more information, see the Weak
       Deduction Theorem page ~ mmdeduction.html .  (Contributed by NM,
       26-Jun-2002.)  Revised to use the conditional operator.  (Revised by BJ,
       30-Sep-2019.)  Commute consequent.  (Revised by Steven Nguyen,
       27-Apr-2023.) $)
    dedt $p |- ( ch -> th ) $=
      ( wif wb ifptru mpbii syl ) CCABHAIZDCABJMEDGFKL $.
  $}

  $( Proof of ~ con3 from its associated inference ~ con3i that illustrates the
     use of the weak deduction theorem ~ dedt .  (Contributed by NM,
     27-Jun-2002.)  Revised to use the conditional operator.  (Revised by BJ,
     30-Sep-2019.)  Revised ~ dedt and ~ elimh .  (Revised by Steven Nguyen,
     27-Apr-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  con3ALT $p |- ( ( ph -> ps ) -> ( -. ps -> -. ph ) ) $=
    ( wi wn wif wb id notbid imbi1d imbi2 elimh con3i dedt ) BAABCZBDZADZCNBAEZ
    DZPCQBFZROPSQBSGHIAQBANAACAQCQBAJQAAJAGKLM $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Abbreviated conjunction and disjunction of three wff's
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( Extend wff definition to include three-way disjunction ('or'). $)
  w3o $a wff ( ph \/ ps \/ ch ) $.
  $( Extend wff definition to include three-way conjunction ('and'). $)
  w3a $a wff ( ph /\ ps /\ ch ) $.

  $( These abbreviations help eliminate parentheses to aid readability. $)

  $( Define disjunction ('or') of three wff's.  Definition *2.33 of
     [WhiteheadRussell] p. 105.  This abbreviation reduces the number of
     parentheses and emphasizes that the order of bracketing is not important
     by virtue of the associative law ~ orass .  (Contributed by NM,
     8-Apr-1994.) $)
  df-3or $a |- ( ( ph \/ ps \/ ch ) <-> ( ( ph \/ ps ) \/ ch ) ) $.

  $( Define conjunction ('and') of three wff's.  Definition *4.34 of
     [WhiteheadRussell] p. 118.  This abbreviation reduces the number of
     parentheses and emphasizes that the order of bracketing is not important
     by virtue of the associative law ~ anass .  (Contributed by NM,
     8-Apr-1994.) $)
  df-3an $a |- ( ( ph /\ ps /\ ch ) <-> ( ( ph /\ ps ) /\ ch ) ) $.

  $( Associative law for triple disjunction.  (Contributed by NM,
     8-Apr-1994.) $)
  3orass $p |- ( ( ph \/ ps \/ ch ) <-> ( ph \/ ( ps \/ ch ) ) ) $=
    ( w3o wo df-3or orass bitri ) ABCDABECEABCEEABCFABCGH $.

  $( Partial elimination of a triple disjunction by denial of a disjunct.
     (Contributed by Scott Fenton, 26-Mar-2011.) $)
  3orel1 $p |- ( -. ph -> ( ( ph \/ ps \/ ch ) -> ( ps \/ ch ) ) ) $=
    ( w3o wo wn 3orass orel1 biimtrid ) ABCDABCEZEAFJABCGAJHI $.

  $( Rotation law for triple disjunction.  (Contributed by NM, 4-Apr-1995.) $)
  3orrot $p |- ( ( ph \/ ps \/ ch ) <-> ( ps \/ ch \/ ph ) ) $=
    ( wo w3o orcom 3orass df-3or 3bitr4i ) ABCDZDJADABCEBCAEAJFABCGBCAHI $.

  $( Commutation law for triple disjunction.  (Contributed by Mario Carneiro,
     4-Sep-2016.) $)
  3orcoma $p |- ( ( ph \/ ps \/ ch ) <-> ( ps \/ ph \/ ch ) ) $=
    ( wo w3o or12 3orass 3bitr4i ) ABCDDBACDDABCEBACEABCFABCGBACGH $.

  $( Commutation law for triple disjunction.  (Contributed by Scott Fenton,
     20-Apr-2011.)  (Proof shortened by Wolf Lammen, 8-Apr-2022.) $)
  3orcomb $p |- ( ( ph \/ ps \/ ch ) <-> ( ph \/ ch \/ ps ) ) $=
    ( w3o 3orcoma 3orrot bitri ) ABCDBACDACBDABCEBACFG $.

  $( Associative law for triple conjunction.  (Contributed by NM,
     8-Apr-1994.) $)
  3anass $p |- ( ( ph /\ ps /\ ch ) <-> ( ph /\ ( ps /\ ch ) ) ) $=
    ( w3a wa df-3an anass bitri ) ABCDABECEABCEEABCFABCGH $.

  $( Convert triple conjunction to conjunction, then commute.  (Contributed by
     Jonathan Ben-Naim, 3-Jun-2011.)  (Proof shortened by Andrew Salmon,
     14-Jun-2011.)  (Revised to shorten ~ 3ancoma by Wolf Lammen,
     5-Jun-2022.) $)
  3anan12 $p |- ( ( ph /\ ps /\ ch ) <-> ( ps /\ ( ph /\ ch ) ) ) $=
    ( w3a wa 3anass an12 bitri ) ABCDABCEEBACEEABCFABCGH $.

  $( Convert triple conjunction to conjunction, then commute.  (Contributed by
     Jonathan Ben-Naim, 3-Jun-2011.)  (Shortened by Garrett Katz,
     15-Jun-2026.) $)
  3anan32 $p |- ( ( ph /\ ps /\ ch ) <-> ( ( ph /\ ch ) /\ ps ) ) $=
    ( w3a wa 3anan12 biancomi ) ABCDACEBABCFG $.

  $( Obsolete version of ~ 3anan32 as of 15-Jun-2026.  Convert triple
     conjunction to conjunction, then commute.  (Contributed by Jonathan
     Ben-Naim, 3-Jun-2011.)  (New usage is discouraged.)
     (Proof modification is discouraged.) $)
  3anan32OLD $p |- ( ( ph /\ ps /\ ch ) <-> ( ( ph /\ ch ) /\ ps ) ) $=
    ( w3a wa df-3an an32 bitri ) ABCDABECEACEBEABCFABCGH $.

  $( Commutation law for triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Wolf Lammen, 5-Jun-2022.) $)
  3ancoma $p |- ( ( ph /\ ps /\ ch ) <-> ( ps /\ ph /\ ch ) ) $=
    ( w3a wa 3anan12 3anass bitr4i ) ABCDBACEEBACDABCFBACGH $.

  $( Commutation law for triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Revised to shorten ~ 3anrot by Wolf Lammen, 9-Jun-2022.) $)
  3ancomb $p |- ( ( ph /\ ps /\ ch ) <-> ( ph /\ ch /\ ps ) ) $=
    ( w3a wa df-3an 3anan32 bitr4i ) ABCDABECEACBDABCFACBGH $.

  $( Rotation law for triple conjunction.  (Contributed by NM, 8-Apr-1994.)
     (Proof shortened by Wolf Lammen, 9-Jun-2022.) $)
  3anrot $p |- ( ( ph /\ ps /\ ch ) <-> ( ps /\ ch /\ ph ) ) $=
    ( w3a 3ancoma 3ancomb bitri ) ABCDBACDBCADABCEBACFG $.

  $( Reversal law for triple conjunction.  (Contributed by NM, 21-Apr-1994.) $)
  3anrev $p |- ( ( ph /\ ps /\ ch ) <-> ( ch /\ ps /\ ph ) ) $=
    ( w3a 3ancoma 3anrot bitr4i ) ABCDBACDCBADABCECBAFG $.

  $( Distribution of triple conjunction over conjunction.  (Contributed by
     David A. Wheeler, 4-Nov-2018.) $)
  anandi3 $p |- ( ( ph /\ ps /\ ch ) <-> ( ( ph /\ ps ) /\ ( ph /\ ch ) ) ) $=
    ( w3a wa 3anass anandi bitri ) ABCDABCEEABEACEEABCFABCGH $.

  $( Distribution of triple conjunction over conjunction.  (Contributed by
     David A. Wheeler, 4-Nov-2018.) $)
  anandi3r $p |- ( ( ph /\ ps /\ ch ) <-> ( ( ph /\ ps ) /\ ( ch /\ ps ) ) ) $=
    ( w3a wa 3anan32 anandir bitri ) ABCDACEBEABECBEEABCFACBGH $.

  $( Idempotent law for conjunction.  (Contributed by Peter Mazsa,
     17-Oct-2023.) $)
  3anidm $p |- ( ( ph /\ ph /\ ph ) <-> ph ) $=
    ( w3a wa df-3an anabs1 anidm 3bitri ) AAABAACZACHAAAADAAEAFG $.

  $( Associative law for four conjunctions with a triple conjunction.
     (Contributed by Alexander van der Vekens, 24-Jun-2018.) $)
  3an4anass $p |- ( ( ( ph /\ ps /\ ch ) /\ th )
                    <-> ( ( ph /\ ps ) /\ ( ch /\ th ) ) ) $=
    ( w3a wa df-3an anbi1i anass bitri ) ABCEZDFABFZCFZDFLCDFFKMDABCGHLCDIJ $.

  $( Negated triple disjunction as triple conjunction.  (Contributed by Scott
     Fenton, 19-Apr-2011.) $)
  3ioran $p |- ( -. ( ph \/ ps \/ ch ) <-> ( -. ph /\ -. ps /\ -. ch ) ) $=
    ( wo wn wa w3o w3a ioran anbi1i df-3or xchnxbir df-3an 3bitr4i ) ABDZEZCEZF
    ZAEZBEZFZQFABCGZESTQHPUAQABIJOCDRUBOCIABCKLSTQMN $.

  $( Negated triple conjunction expressed in terms of triple disjunction.
     (Contributed by Jeff Hankins, 15-Aug-2009.)  (Proof shortened by Andrew
     Salmon, 13-May-2011.)  Shorten with ~ xchnxbir .  (Revised by Wolf Lammen,
     8-Apr-2022.) $)
  3ianor $p |- ( -. ( ph /\ ps /\ ch ) <-> ( -. ph \/ -. ps \/ -. ch ) ) $=
    ( wa wn wo w3a w3o ianor orbi1i df-3an xchnxbir df-3or 3bitr4i ) ABDZEZCEZF
    ZAEZBEZFZQFABCGZESTQHPUAQABIJOCDRUBOCIABCKLSTQMN $.

  $( Triple conjunction expressed in terms of triple disjunction.  (Contributed
     by Jeff Hankins, 15-Aug-2009.)  (Proof shortened by Wolf Lammen,
     8-Apr-2022.) $)
  3anor $p |- ( ( ph /\ ps /\ ch ) <-> -. ( -. ph \/ -. ps \/ -. ch ) ) $=
    ( wn w3o w3a 3ianor con1bii bicomi ) ADBDCDEZDABCFZKJABCGHI $.

  $( Triple disjunction in terms of triple conjunction.  (Contributed by NM,
     8-Oct-2012.) $)
  3oran $p |- ( ( ph \/ ps \/ ch ) <-> -. ( -. ph /\ -. ps /\ -. ch ) ) $=
    ( wn w3a w3o 3ioran con1bii bicomi ) ADBDCDEZDABCFZKJABCGHI $.

  ${
    3impa.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( Importation from double to triple conjunction.  (Contributed by NM,
       20-Aug-1995.)  (Revised to shorten ~ 3imp by Wolf Lammen,
       20-Jun-2022.) $)
    3impa $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      ( w3a wa df-3an sylbi ) ABCFABGCGDABCHEI $.
  $}

  ${
    3imp.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( Importation inference.  (Contributed by NM, 8-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 20-Jun-2022.) $)
    3imp $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      ( imp31 3impa ) ABCDABCDEFG $.

    $( The importation inference ~ 3imp with commutation of the first and third
       conjuncts of the assertion relative to the hypothesis.  (Contributed by
       Alan Sare, 11-Sep-2016.) $)
    3imp31 $p |- ( ( ch /\ ps /\ ph ) -> th ) $=
      ( com13 3imp ) CBADABCDEFG $.

    $( Importation inference.  (Contributed by Alan Sare, 17-Oct-2017.) $)
    3imp231 $p |- ( ( ps /\ ch /\ ph ) -> th ) $=
      ( com3l 3imp ) BCADABCDEFG $.

    $( The importation inference ~ 3imp with commutation of the first and
       second conjuncts of the assertion relative to the hypothesis.
       (Contributed by Alan Sare, 11-Sep-2016.)  (Revised to shorten ~ 3com12
       by Wolf Lammen, 23-Jun-2022.) $)
    3imp21 $p |- ( ( ps /\ ph /\ ch ) -> th ) $=
      ( com13 3imp231 ) CBADABCDEFG $.
  $}

  ${
    3impb.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Importation from double to triple conjunction.  (Contributed by NM,
       20-Aug-1995.) $)
    3impb $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      ( exp32 3imp ) ABCDABCDEFG $.
  $}

  ${
    bi23imp13.1 $e |- ( ph -> ( ps <-> ( ch -> th ) ) ) $.
    $( ~ 3imp with middle implication of the hypothesis a biconditional.
       (Contributed by Alan Sare, 6-Nov-2017.) $)
    bi23imp13 $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      ( wi biimpd 3imp ) ABCDABCDFEGH $.
  $}

  ${
    3impib.1 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( Importation to triple conjunction.  (Contributed by NM, 13-Jun-2006.) $)
    3impib $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      ( expd 3imp ) ABCDABCDEFG $.
  $}

  ${
    3impia.1 $e |- ( ( ph /\ ps ) -> ( ch -> th ) ) $.
    $( Importation to triple conjunction.  (Contributed by NM, 13-Jun-2006.)
       (Proof shortened by Wolf Lammen, 21-Jun-2022.) $)
    3impia $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      ( expimpd 3impib ) ABCDABCDEFG $.
  $}

  ${
    3exp.1 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( Exportation from triple to double conjunction.  (Contributed by NM,
       20-Aug-1995.)  (Revised to shorten ~ 3exp and ~ pm3.2an3 by Wolf Lammen,
       22-Jun-2022.) $)
    3expa $p |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $=
      ( wa w3a df-3an sylbir ) ABFCFABCGDABCHEI $.

    $( Exportation inference.  (Contributed by NM, 30-May-1994.)  (Proof
       shortened by Wolf Lammen, 22-Jun-2022.) $)
    3exp $p |- ( ph -> ( ps -> ( ch -> th ) ) ) $=
      ( 3expa exp31 ) ABCDABCDEFG $.

    $( Exportation from triple to double conjunction.  (Contributed by NM,
       20-Aug-1995.) $)
    3expb $p |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $=
      ( 3exp imp32 ) ABCDABCDEFG $.

    $( Exportation from triple conjunction.  (Contributed by NM, 19-May-2007.)
       (Proof shortened by Wolf Lammen, 22-Jun-2022.) $)
    3expia $p |- ( ( ph /\ ps ) -> ( ch -> th ) ) $=
      ( 3expb expr ) ABCDABCDEFG $.

    $( Exportation from triple conjunction.  (Contributed by NM,
       19-May-2007.) $)
    3expib $p |- ( ph -> ( ( ps /\ ch ) -> th ) ) $=
      ( 3exp impd ) ABCDABCDEFG $.

    $( Commutation in antecedent.  Swap 1st and 2nd.  (Contributed by NM,
       28-Jan-1996.)  (Proof shortened by Andrew Salmon, 13-May-2011.)  (Proof
       shortened by Wolf Lammen, 22-Jun-2022.) $)
    3com12 $p |- ( ( ps /\ ph /\ ch ) -> th ) $=
      ( 3exp 3imp21 ) ABCDABCDEFG $.

    $( Commutation in antecedent.  Swap 1st and 3rd.  (Contributed by NM,
       28-Jan-1996.)  (Proof shortened by Wolf Lammen, 22-Jun-2022.) $)
    3com13 $p |- ( ( ch /\ ps /\ ph ) -> th ) $=
      ( 3exp 3imp31 ) ABCDABCDEFG $.

    $( Commutation in antecedent.  Rotate right.  (Contributed by NM,
       28-Jan-1996.)  Theorems shortened and reordered.  (Revised by Wolf
       Lammen, 9-Apr-2022.) $)
    3comr $p |- ( ( ch /\ ph /\ ps ) -> th ) $=
      ( 3com12 3com13 ) BACDABCDEFG $.

    $( Commutation in antecedent.  Swap 2nd and 3rd.  (Contributed by NM,
       28-Jan-1996.)  (Proof shortened by Wolf Lammen, 9-Apr-2022.) $)
    3com23 $p |- ( ( ph /\ ch /\ ps ) -> th ) $=
      ( 3comr 3com12 ) CABDABCDEFG $.

    $( Commutation in antecedent.  Rotate left.  (Contributed by NM,
       28-Jan-1996.) $)
    3coml $p |- ( ( ps /\ ch /\ ph ) -> th ) $=
      ( 3com23 3com13 ) ACBDABCDEFG $.
  $}

  ${
    3jca.1 $e |- ( ph -> ps ) $.
    3jca.2 $e |- ( ph -> ch ) $.
    3jca.3 $e |- ( ph -> th ) $.
    $( Join consequents with conjunction.  (Contributed by NM, 9-Apr-1994.) $)
    3jca $p |- ( ph -> ( ps /\ ch /\ th ) ) $=
      ( wa w3a jca31 df-3an sylibr ) ABCHDHBCDIABCDEFGJBCDKL $.
  $}

  ${
    3jcad.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3jcad.2 $e |- ( ph -> ( ps -> th ) ) $.
    3jcad.3 $e |- ( ph -> ( ps -> ta ) ) $.
    $( Deduction conjoining the consequents of three implications.
       (Contributed by NM, 25-Sep-2005.) $)
    3jcad $p |- ( ph -> ( ps -> ( ch /\ th /\ ta ) ) ) $=
      ( w3a wa imp 3jca ex ) ABCDEIABJCDEABCFKABDGKABEHKLM $.
  $}

  ${
    3adant.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       16-Jul-1995.)  (Proof shortened by Wolf Lammen, 21-Jun-2022.) $)
    3adant1 $p |- ( ( th /\ ph /\ ps ) -> ch ) $=
      ( adantll 3impa ) DABCABCDEFG $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       16-Jul-1995.) $)
    3adant2 $p |- ( ( ph /\ th /\ ps ) -> ch ) $=
      ( adantlr 3impa ) ADBCABCDEFG $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       16-Jul-1995.)  (Proof shortened by Wolf Lammen, 21-Jun-2022.) $)
    3adant3 $p |- ( ( ph /\ ps /\ th ) -> ch ) $=
      ( adantrr 3impb ) ABDCABCDEFG $.
  $}

  ${
    3ad2ant.1 $e |- ( ph -> ch ) $.
    $( Deduction adding conjuncts to an antecedent.  (Contributed by NM,
       21-Apr-2005.) $)
    3ad2ant1 $p |- ( ( ph /\ ps /\ th ) -> ch ) $=
      ( adantr 3adant2 ) ADCBACDEFG $.

    $( Deduction adding conjuncts to an antecedent.  (Contributed by NM,
       21-Apr-2005.) $)
    3ad2ant2 $p |- ( ( ps /\ ph /\ th ) -> ch ) $=
      ( adantr 3adant1 ) ADCBACDEFG $.

    $( Deduction adding conjuncts to an antecedent.  (Contributed by NM,
       21-Apr-2005.) $)
    3ad2ant3 $p |- ( ( ps /\ th /\ ph ) -> ch ) $=
      ( adantl 3adant1 ) DACBACDEFG $.
  $}

  $( Simplification of triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Wolf Lammen, 22-Jun-2022.) $)
  simp1 $p |- ( ( ph /\ ps /\ ch ) -> ph ) $=
    ( id 3ad2ant1 ) ABACADE $.

  $( Simplification of triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Wolf Lammen, 22-Jun-2022.) $)
  simp2 $p |- ( ( ph /\ ps /\ ch ) -> ps ) $=
    ( id 3ad2ant2 ) BABCBDE $.

  $( Simplification of triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Wolf Lammen, 22-Jun-2022.) $)
  simp3 $p |- ( ( ph /\ ps /\ ch ) -> ch ) $=
    ( id 3ad2ant3 ) CACBCDE $.

  ${
    3simp1i.1 $e |- ( ph /\ ps /\ ch ) $.
    $( Infer a conjunct from a triple conjunction.  (Contributed by NM,
       19-Apr-2005.) $)
    simp1i $p |- ph $=
      ( w3a simp1 ax-mp ) ABCEADABCFG $.

    $( Infer a conjunct from a triple conjunction.  (Contributed by NM,
       19-Apr-2005.) $)
    simp2i $p |- ps $=
      ( w3a simp2 ax-mp ) ABCEBDABCFG $.

    $( Infer a conjunct from a triple conjunction.  (Contributed by NM,
       19-Apr-2005.) $)
    simp3i $p |- ch $=
      ( w3a simp3 ax-mp ) ABCECDABCFG $.
  $}

  ${
    3simp1d.1 $e |- ( ph -> ( ps /\ ch /\ th ) ) $.
    $( Deduce a conjunct from a triple conjunction.  (Contributed by NM,
       4-Sep-2005.) $)
    simp1d $p |- ( ph -> ps ) $=
      ( w3a simp1 syl ) ABCDFBEBCDGH $.

    $( Deduce a conjunct from a triple conjunction.  (Contributed by NM,
       4-Sep-2005.) $)
    simp2d $p |- ( ph -> ch ) $=
      ( w3a simp2 syl ) ABCDFCEBCDGH $.

    $( Deduce a conjunct from a triple conjunction.  (Contributed by NM,
       4-Sep-2005.) $)
    simp3d $p |- ( ph -> th ) $=
      ( w3a simp3 syl ) ABCDFDEBCDGH $.
  $}

  ${
    3simp1bi.1 $e |- ( ph <-> ( ps /\ ch /\ th ) ) $.
    $( Deduce a conjunct from a triple conjunction.  (Contributed by Jonathan
       Ben-Naim, 3-Jun-2011.) $)
    simp1bi $p |- ( ph -> ps ) $=
      ( w3a biimpi simp1d ) ABCDABCDFEGH $.

    $( Deduce a conjunct from a triple conjunction.  (Contributed by Jonathan
       Ben-Naim, 3-Jun-2011.) $)
    simp2bi $p |- ( ph -> ch ) $=
      ( w3a biimpi simp2d ) ABCDABCDFEGH $.

    $( Deduce a conjunct from a triple conjunction.  (Contributed by Jonathan
       Ben-Naim, 3-Jun-2011.) $)
    simp3bi $p |- ( ph -> th ) $=
      ( w3a biimpi simp3d ) ABCDABCDFEGH $.
  $}

  $( Simplification of triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Wolf Lammen, 21-Jun-2022.) $)
  3simpa $p |- ( ( ph /\ ps /\ ch ) -> ( ph /\ ps ) ) $=
    ( wa id 3adant3 ) ABABDZCGEF $.

  $( Simplification of triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Wolf Lammen, 21-Jun-2022.) $)
  3simpb $p |- ( ( ph /\ ps /\ ch ) -> ( ph /\ ch ) ) $=
    ( wa id 3adant2 ) ACACDZBGEF $.

  $( Simplification of triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Andrew Salmon, 13-May-2011.)  (Proof shortened by Wolf
     Lammen, 21-Jun-2022.) $)
  3simpc $p |- ( ( ph /\ ps /\ ch ) -> ( ps /\ ch ) ) $=
    ( wa id 3adant1 ) BCBCDZAGEF $.

  ${
    3anim123i.1 $e |- ( ph -> ps ) $.
    3anim123i.2 $e |- ( ch -> th ) $.
    3anim123i.3 $e |- ( ta -> et ) $.
    $( Join antecedents and consequents with conjunction.  (Contributed by NM,
       8-Apr-1994.) $)
    3anim123i $p |- ( ( ph /\ ch /\ ta ) -> ( ps /\ th /\ et ) ) $=
      ( w3a 3ad2ant1 3ad2ant2 3ad2ant3 3jca ) ACEJBDFACBEGKCADEHLEAFCIMN $.
  $}

  ${
    3animi.1 $e |- ( ph -> ps ) $.
    $( Add two conjuncts to antecedent and consequent.  (Contributed by Jeff
       Hankins, 16-Aug-2009.) $)
    3anim1i $p |- ( ( ph /\ ch /\ th ) -> ( ps /\ ch /\ th ) ) $=
      ( id 3anim123i ) ABCCDDECFDFG $.

    $( Add two conjuncts to antecedent and consequent.  (Contributed by AV,
       21-Nov-2019.) $)
    3anim2i $p |- ( ( ch /\ ph /\ th ) -> ( ch /\ ps /\ th ) ) $=
      ( id 3anim123i ) CCABDDCFEDFG $.

    $( Add two conjuncts to antecedent and consequent.  (Contributed by Jeff
       Hankins, 19-Aug-2009.) $)
    3anim3i $p |- ( ( ch /\ th /\ ph ) -> ( ch /\ th /\ ps ) ) $=
      ( id 3anim123i ) CCDDABCFDFEG $.
  $}

  ${
    bi3.1 $e |- ( ph <-> ps ) $.
    bi3.2 $e |- ( ch <-> th ) $.
    bi3.3 $e |- ( ta <-> et ) $.
    $( Join 3 biconditionals with conjunction.  (Contributed by NM,
       21-Apr-1994.) $)
    3anbi123i $p |- ( ( ph /\ ch /\ ta ) <-> ( ps /\ th /\ et ) ) $=
      ( wa w3a anbi12i df-3an 3bitr4i ) ACJZEJBDJZFJACEKBDFKOPEFABCDGHLILACEMBD
      FMN $.

    $( Join 3 biconditionals with disjunction.  (Contributed by NM,
       17-May-1994.) $)
    3orbi123i $p |- ( ( ph \/ ch \/ ta ) <-> ( ps \/ th \/ et ) ) $=
      ( wo w3o orbi12i df-3or 3bitr4i ) ACJZEJBDJZFJACEKBDFKOPEFABCDGHLILACEMBD
      FMN $.
  $}

  ${
    3anbi1i.1 $e |- ( ph <-> ps ) $.
    $( Inference adding two conjuncts to each side of a biconditional.
       (Contributed by NM, 8-Sep-2006.) $)
    3anbi1i $p |- ( ( ph /\ ch /\ th ) <-> ( ps /\ ch /\ th ) ) $=
      ( biid 3anbi123i ) ABCCDDECFDFG $.

    $( Inference adding two conjuncts to each side of a biconditional.
       (Contributed by NM, 8-Sep-2006.) $)
    3anbi2i $p |- ( ( ch /\ ph /\ th ) <-> ( ch /\ ps /\ th ) ) $=
      ( biid 3anbi123i ) CCABDDCFEDFG $.

    $( Inference adding two conjuncts to each side of a biconditional.
       (Contributed by NM, 8-Sep-2006.) $)
    3anbi3i $p |- ( ( ch /\ th /\ ph ) <-> ( ch /\ th /\ ps ) ) $=
      ( biid 3anbi123i ) CCDDABCFDFEG $.
  $}

  ${
    syl3an.1 $e |- ( ph -> ps ) $.
    syl3an.2 $e |- ( ch -> th ) $.
    syl3an.3 $e |- ( ta -> et ) $.
    syl3an.4 $e |- ( ( ps /\ th /\ et ) -> ze ) $.
    $( A triple syllogism inference.  (Contributed by NM, 13-May-2004.) $)
    syl3an $p |- ( ( ph /\ ch /\ ta ) -> ze ) $=
      ( w3a 3anim123i syl ) ACELBDFLGABCDEFHIJMKN $.
  $}

  ${
    syl3anb.1 $e |- ( ph <-> ps ) $.
    syl3anb.2 $e |- ( ch <-> th ) $.
    syl3anb.3 $e |- ( ta <-> et ) $.
    syl3anb.4 $e |- ( ( ps /\ th /\ et ) -> ze ) $.
    $( A triple syllogism inference.  (Contributed by NM, 15-Oct-2005.) $)
    syl3anb $p |- ( ( ph /\ ch /\ ta ) -> ze ) $=
      ( w3a 3anbi123i sylbi ) ACELBDFLGABCDEFHIJMKN $.
  $}

  ${
    syl3anbr.1 $e |- ( ps <-> ph ) $.
    syl3anbr.2 $e |- ( th <-> ch ) $.
    syl3anbr.3 $e |- ( et <-> ta ) $.
    syl3anbr.4 $e |- ( ( ps /\ th /\ et ) -> ze ) $.
    $( A triple syllogism inference.  (Contributed by NM, 29-Dec-2011.) $)
    syl3anbr $p |- ( ( ph /\ ch /\ ta ) -> ze ) $=
      ( bicomi syl3anb ) ABCDEFGBAHLDCILFEJLKM $.
  $}

  ${
    syl3an1.1 $e |- ( ph -> ps ) $.
    syl3an1.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an1 $p |- ( ( ph /\ ch /\ th ) -> ta ) $=
      ( w3a 3anim1i syl ) ACDHBCDHEABCDFIGJ $.
  $}

  ${
    syl3an2.1 $e |- ( ph -> ch ) $.
    syl3an2.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.)  (Proof
       shortened by Wolf Lammen, 26-Jun-2022.) $)
    syl3an2 $p |- ( ( ps /\ ph /\ th ) -> ta ) $=
      ( w3a 3anim2i syl ) BADHBCDHEACBDFIGJ $.
  $}

  ${
    syl3an3.1 $e |- ( ph -> th ) $.
    syl3an3.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.)  (Proof
       shortened by Wolf Lammen, 26-Jun-2022.) $)
    syl3an3 $p |- ( ( ps /\ ch /\ ph ) -> ta ) $=
      ( w3a 3anim3i syl ) BCAHBCDHEADBCFIGJ $.
  $}

  ${
    syl3an132.1 $e |- ( ph -> ps ) $.
    syl3an132.2 $e |- ( ( ch /\ th ) -> ta ) $.
    syl3an132.3 $e |- ( ( ps /\ ta ) -> et ) $.
    $( ~ syl2an with antecedents in standard conjunction form.  (Contributed by
       Alan Sare, 26-Aug-2016.) $)
    syl3an132 $p |- ( ( ph /\ ch /\ th ) -> et ) $=
      ( wa syl2an 3impb ) ACDFABEFCDJGHIKL $.
  $}

  ${
    3adantl.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       24-Feb-2005.) $)
    3adantl1 $p |- ( ( ( ta /\ ph /\ ps ) /\ ch ) -> th ) $=
      ( w3a wa 3simpc sylan ) EABGABHCDEABIFJ $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       24-Feb-2005.) $)
    3adantl2 $p |- ( ( ( ph /\ ta /\ ps ) /\ ch ) -> th ) $=
      ( w3a wa 3simpb sylan ) AEBGABHCDAEBIFJ $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       24-Feb-2005.) $)
    3adantl3 $p |- ( ( ( ph /\ ps /\ ta ) /\ ch ) -> th ) $=
      ( w3a wa 3simpa sylan ) ABEGABHCDABEIFJ $.
  $}

  ${
    3adantr.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       27-Apr-2005.) $)
    3adantr1 $p |- ( ( ph /\ ( ta /\ ps /\ ch ) ) -> th ) $=
      ( w3a wa 3simpc sylan2 ) EBCGABCHDEBCIFJ $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       27-Apr-2005.) $)
    3adantr2 $p |- ( ( ph /\ ( ps /\ ta /\ ch ) ) -> th ) $=
      ( w3a wa 3simpb sylan2 ) BECGABCHDBECIFJ $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       27-Apr-2005.) $)
    3adantr3 $p |- ( ( ph /\ ( ps /\ ch /\ ta ) ) -> th ) $=
      ( w3a wa 3simpa sylan2 ) BCEGABCHDBCEIFJ $.
  $}

  ${
    ad4ant3.1 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant123 $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ ta ) -> th ) $=
      ( wa 3expa adantr ) ABGCGDEABCDFHI $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant124 $p |- ( ( ( ( ph /\ ps ) /\ ta ) /\ ch ) -> th ) $=
      ( wa 3expa adantlr ) ABGCDEABCDFHI $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant134 $p |- ( ( ( ( ph /\ ta ) /\ ps ) /\ ch ) -> th ) $=
      ( 3expa adantllr ) ABCDEABCDFGH $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant234 $p |- ( ( ( ( ta /\ ph ) /\ ps ) /\ ch ) -> th ) $=
      ( 3expa adantlll ) ABCDEABCDFGH $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       8-Jan-2006.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
    3adant1l $p |- ( ( ( ta /\ ph ) /\ ps /\ ch ) -> th ) $=
      ( wa simpr syl3an1 ) EAGABCDEAHFI $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       8-Jan-2006.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
    3adant1r $p |- ( ( ( ph /\ ta ) /\ ps /\ ch ) -> th ) $=
      ( wa simpl syl3an1 ) AEGABCDAEHFI $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       8-Jan-2006.)  (Proof shortened by Wolf Lammen, 25-Jun-2022.) $)
    3adant2l $p |- ( ( ph /\ ( ta /\ ps ) /\ ch ) -> th ) $=
      ( wa simpr syl3an2 ) EBGABCDEBHFI $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       8-Jan-2006.)  (Proof shortened by Wolf Lammen, 25-Jun-2022.) $)
    3adant2r $p |- ( ( ph /\ ( ps /\ ta ) /\ ch ) -> th ) $=
      ( wa simpl syl3an2 ) BEGABCDBEHFI $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       8-Jan-2006.)  (Proof shortened by Wolf Lammen, 25-Jun-2022.) $)
    3adant3l $p |- ( ( ph /\ ps /\ ( ta /\ ch ) ) -> th ) $=
      ( wa simpr syl3an3 ) ECGABCDECHFI $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       8-Jan-2006.)  (Proof shortened by Wolf Lammen, 25-Jun-2022.) $)
    3adant3r $p |- ( ( ph /\ ps /\ ( ch /\ ta ) ) -> th ) $=
      ( wa simpl syl3an3 ) CEGABCDCEHFI $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       16-Feb-2008.) $)
    3adant3r1 $p |- ( ( ph /\ ( ta /\ ps /\ ch ) ) -> th ) $=
      ( 3expb 3adantr1 ) ABCDEABCDFGH $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       17-Feb-2008.) $)
    3adant3r2 $p |- ( ( ph /\ ( ps /\ ta /\ ch ) ) -> th ) $=
      ( 3expb 3adantr2 ) ABCDEABCDFGH $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       18-Feb-2008.) $)
    3adant3r3 $p |- ( ( ph /\ ( ps /\ ch /\ ta ) ) -> th ) $=
      ( 3expb 3adantr3 ) ABCDEABCDFGH $.
  $}

  ${
    3ad2antl.1 $e |- ( ( ph /\ ch ) -> th ) $.
    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       4-Aug-2007.) $)
    3ad2antl1 $p |- ( ( ( ph /\ ps /\ ta ) /\ ch ) -> th ) $=
      ( adantlr 3adantl2 ) AECDBACDEFGH $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       4-Aug-2007.) $)
    3ad2antl2 $p |- ( ( ( ps /\ ph /\ ta ) /\ ch ) -> th ) $=
      ( adantlr 3adantl1 ) AECDBACDEFGH $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       4-Aug-2007.) $)
    3ad2antl3 $p |- ( ( ( ps /\ ta /\ ph ) /\ ch ) -> th ) $=
      ( adantll 3adantl1 ) EACDBACDEFGH $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       25-Dec-2007.) $)
    3ad2antr1 $p |- ( ( ph /\ ( ch /\ ps /\ ta ) ) -> th ) $=
      ( adantrr 3adantr3 ) ACBDEACDBFGH $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       27-Dec-2007.) $)
    3ad2antr2 $p |- ( ( ph /\ ( ps /\ ch /\ ta ) ) -> th ) $=
      ( adantrl 3adantr3 ) ABCDEACDBFGH $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       30-Dec-2007.) $)
    3ad2antr3 $p |- ( ( ph /\ ( ps /\ ta /\ ch ) ) -> th ) $=
      ( adantrl 3adantr1 ) AECDBACDEFGH $.
  $}

  $( Simplification of conjunction.  (Contributed by Jeff Hankins,
     17-Nov-2009.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl1 $p |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ph ) $=
    ( simpl 3ad2antl1 ) ABDACADEF $.

  $( Simplification of conjunction.  (Contributed by Jeff Hankins,
     17-Nov-2009.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl2 $p |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ps ) $=
    ( simpl 3ad2antl2 ) BADBCBDEF $.

  $( Simplification of conjunction.  (Contributed by Jeff Hankins,
     17-Nov-2009.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl3 $p |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ch ) $=
    ( simpl 3ad2antl3 ) CADCBCDEF $.

  $( Simplification of conjunction.  (Contributed by Jeff Hankins,
     17-Nov-2009.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpr1 $p |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ps ) $=
    ( simpr 3ad2antr1 ) ACBBDABEF $.

  $( Simplification of conjunction.  (Contributed by Jeff Hankins,
     17-Nov-2009.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpr2 $p |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ch ) $=
    ( simpr 3ad2antr2 ) ABCCDACEF $.

  $( Simplification of conjunction.  (Contributed by Jeff Hankins,
     17-Nov-2009.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpr3 $p |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> th ) $=
    ( simpr 3ad2antr3 ) ABDDCADEF $.

  $( Simplification of triple conjunction.  (Contributed by NM, 9-Nov-2011.) $)
  simp1l $p |- ( ( ( ph /\ ps ) /\ ch /\ th ) -> ph ) $=
    ( wa simpl 3ad2ant1 ) ABECADABFG $.

  $( Simplification of triple conjunction.  (Contributed by NM, 9-Nov-2011.) $)
  simp1r $p |- ( ( ( ph /\ ps ) /\ ch /\ th ) -> ps ) $=
    ( wa simpr 3ad2ant1 ) ABECBDABFG $.

  $( Simplification of triple conjunction.  (Contributed by NM, 9-Nov-2011.) $)
  simp2l $p |- ( ( ph /\ ( ps /\ ch ) /\ th ) -> ps ) $=
    ( wa simpl 3ad2ant2 ) BCEABDBCFG $.

  $( Simplification of triple conjunction.  (Contributed by NM, 9-Nov-2011.) $)
  simp2r $p |- ( ( ph /\ ( ps /\ ch ) /\ th ) -> ch ) $=
    ( wa simpr 3ad2ant2 ) BCEACDBCFG $.

  $( Simplification of triple conjunction.  (Contributed by NM, 9-Nov-2011.) $)
  simp3l $p |- ( ( ph /\ ps /\ ( ch /\ th ) ) -> ch ) $=
    ( wa simpl 3ad2ant3 ) CDEACBCDFG $.

  $( Simplification of triple conjunction.  (Contributed by NM, 9-Nov-2011.) $)
  simp3r $p |- ( ( ph /\ ps /\ ( ch /\ th ) ) -> th ) $=
    ( wa simpr 3ad2ant3 ) CDEADBCDFG $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp11 $p |- ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) -> ph ) $=
    ( w3a simp1 3ad2ant1 ) ABCFDAEABCGH $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp12 $p |- ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) -> ps ) $=
    ( w3a simp2 3ad2ant1 ) ABCFDBEABCGH $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp13 $p |- ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) -> ch ) $=
    ( w3a simp3 3ad2ant1 ) ABCFDCEABCGH $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp21 $p |- ( ( ph /\ ( ps /\ ch /\ th ) /\ ta ) -> ps ) $=
    ( w3a simp1 3ad2ant2 ) BCDFABEBCDGH $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp22 $p |- ( ( ph /\ ( ps /\ ch /\ th ) /\ ta ) -> ch ) $=
    ( w3a simp2 3ad2ant2 ) BCDFACEBCDGH $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp23 $p |- ( ( ph /\ ( ps /\ ch /\ th ) /\ ta ) -> th ) $=
    ( w3a simp3 3ad2ant2 ) BCDFADEBCDGH $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp31 $p |- ( ( ph /\ ps /\ ( ch /\ th /\ ta ) ) -> ch ) $=
    ( w3a simp1 3ad2ant3 ) CDEFACBCDEGH $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp32 $p |- ( ( ph /\ ps /\ ( ch /\ th /\ ta ) ) -> th ) $=
    ( w3a simp2 3ad2ant3 ) CDEFADBCDEGH $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp33 $p |- ( ( ph /\ ps /\ ( ch /\ th /\ ta ) ) -> ta ) $=
    ( w3a simp3 3ad2ant3 ) CDEFAEBCDEGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpll1 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th ) /\ ta ) -> ph ) $=
    ( w3a simp1 ad2antrr ) ABCFADEABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpll2 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th ) /\ ta ) -> ps ) $=
    ( w3a simp2 ad2antrr ) ABCFBDEABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpll3 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th ) /\ ta ) -> ch ) $=
    ( w3a simp3 ad2antrr ) ABCFCDEABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simplr1 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) ) /\ ta ) -> ph ) $=
    ( w3a simp1 ad2antlr ) ABCFADEABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simplr2 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) ) /\ ta ) -> ps ) $=
    ( w3a simp2 ad2antlr ) ABCFBDEABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simplr3 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) ) /\ ta ) -> ch ) $=
    ( w3a simp3 ad2antlr ) ABCFCDEABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simprl1 $p |- ( ( ta /\ ( ( ph /\ ps /\ ch ) /\ th ) ) -> ph ) $=
    ( w3a simp1 ad2antrl ) ABCFAEDABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simprl2 $p |- ( ( ta /\ ( ( ph /\ ps /\ ch ) /\ th ) ) -> ps ) $=
    ( w3a simp2 ad2antrl ) ABCFBEDABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simprl3 $p |- ( ( ta /\ ( ( ph /\ ps /\ ch ) /\ th ) ) -> ch ) $=
    ( w3a simp3 ad2antrl ) ABCFCEDABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simprr1 $p |- ( ( ta /\ ( th /\ ( ph /\ ps /\ ch ) ) ) -> ph ) $=
    ( w3a simp1 ad2antll ) ABCFAEDABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simprr2 $p |- ( ( ta /\ ( th /\ ( ph /\ ps /\ ch ) ) ) -> ps ) $=
    ( w3a simp2 ad2antll ) ABCFBEDABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simprr3 $p |- ( ( ta /\ ( th /\ ( ph /\ ps /\ ch ) ) ) -> ch ) $=
    ( w3a simp3 ad2antll ) ABCFCEDABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl1l $p |- ( ( ( ( ph /\ ps ) /\ ch /\ th ) /\ ta ) -> ph ) $=
    ( wa simpll 3ad2antl1 ) ABFCEADABEGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl1r $p |- ( ( ( ( ph /\ ps ) /\ ch /\ th ) /\ ta ) -> ps ) $=
    ( wa simplr 3ad2antl1 ) ABFCEBDABEGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl2l $p |- ( ( ( ch /\ ( ph /\ ps ) /\ th ) /\ ta ) -> ph ) $=
    ( wa simpll 3ad2antl2 ) ABFCEADABEGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl2r $p |- ( ( ( ch /\ ( ph /\ ps ) /\ th ) /\ ta ) -> ps ) $=
    ( wa simplr 3ad2antl2 ) ABFCEBDABEGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl3l $p |- ( ( ( ch /\ th /\ ( ph /\ ps ) ) /\ ta ) -> ph ) $=
    ( wa simpll 3ad2antl3 ) ABFCEADABEGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl3r $p |- ( ( ( ch /\ th /\ ( ph /\ ps ) ) /\ ta ) -> ps ) $=
    ( wa simplr 3ad2antl3 ) ABFCEBDABEGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr1l $p |- ( ( ta /\ ( ( ph /\ ps ) /\ ch /\ th ) ) -> ph ) $=
    ( wa simprl 3ad2antr1 ) ECABFADEABGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr1r $p |- ( ( ta /\ ( ( ph /\ ps ) /\ ch /\ th ) ) -> ps ) $=
    ( wa simprr 3ad2antr1 ) ECABFBDEABGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr2l $p |- ( ( ta /\ ( ch /\ ( ph /\ ps ) /\ th ) ) -> ph ) $=
    ( wa simprl 3ad2antr2 ) ECABFADEABGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr2r $p |- ( ( ta /\ ( ch /\ ( ph /\ ps ) /\ th ) ) -> ps ) $=
    ( wa simprr 3ad2antr2 ) ECABFBDEABGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr3l $p |- ( ( ta /\ ( ch /\ th /\ ( ph /\ ps ) ) ) -> ph ) $=
    ( wa simprl 3ad2antr3 ) ECABFADEABGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr3r $p |- ( ( ta /\ ( ch /\ th /\ ( ph /\ ps ) ) ) -> ps ) $=
    ( wa simprr 3ad2antr3 ) ECABFBDEABGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1ll $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th /\ ta ) -> ph ) $=
    ( wa simpll 3ad2ant1 ) ABFCFDAEABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1lr $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th /\ ta ) -> ps ) $=
    ( wa simplr 3ad2ant1 ) ABFCFDBEABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1rl $p |- ( ( ( ch /\ ( ph /\ ps ) ) /\ th /\ ta ) -> ph ) $=
    ( wa simprl 3ad2ant1 ) CABFFDAECABGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1rr $p |- ( ( ( ch /\ ( ph /\ ps ) ) /\ th /\ ta ) -> ps ) $=
    ( wa simprr 3ad2ant1 ) CABFFDBECABGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2ll $p |- ( ( th /\ ( ( ph /\ ps ) /\ ch ) /\ ta ) -> ph ) $=
    ( wa simpll 3ad2ant2 ) ABFCFDAEABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2lr $p |- ( ( th /\ ( ( ph /\ ps ) /\ ch ) /\ ta ) -> ps ) $=
    ( wa simplr 3ad2ant2 ) ABFCFDBEABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2rl $p |- ( ( th /\ ( ch /\ ( ph /\ ps ) ) /\ ta ) -> ph ) $=
    ( wa simprl 3ad2ant2 ) CABFFDAECABGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2rr $p |- ( ( th /\ ( ch /\ ( ph /\ ps ) ) /\ ta ) -> ps ) $=
    ( wa simprr 3ad2ant2 ) CABFFDBECABGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3ll $p |- ( ( th /\ ta /\ ( ( ph /\ ps ) /\ ch ) ) -> ph ) $=
    ( wa simpll 3ad2ant3 ) ABFCFDAEABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3lr $p |- ( ( th /\ ta /\ ( ( ph /\ ps ) /\ ch ) ) -> ps ) $=
    ( wa simplr 3ad2ant3 ) ABFCFDBEABCGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3rl $p |- ( ( th /\ ta /\ ( ch /\ ( ph /\ ps ) ) ) -> ph ) $=
    ( wa simprl 3ad2ant3 ) CABFFDAECABGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3rr $p |- ( ( th /\ ta /\ ( ch /\ ( ph /\ ps ) ) ) -> ps ) $=
    ( wa simprr 3ad2ant3 ) CABFFDBECABGH $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl11 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ et ) -> ph ) $=
    ( w3a simpl1 3ad2antl1 ) ABCGDFAEABCFHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl12 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ et ) -> ps ) $=
    ( w3a simpl2 3ad2antl1 ) ABCGDFBEABCFHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl13 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ et ) -> ch ) $=
    ( w3a simpl3 3ad2antl1 ) ABCGDFCEABCFHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl21 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ et ) -> ph ) $=
    ( w3a simpl1 3ad2antl2 ) ABCGDFAEABCFHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl22 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ et ) -> ps ) $=
    ( w3a simpl2 3ad2antl2 ) ABCGDFBEABCFHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl23 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ et ) -> ch ) $=
    ( w3a simpl3 3ad2antl2 ) ABCGDFCEABCFHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl31 $p |- ( ( ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ et ) -> ph ) $=
    ( w3a simpl1 3ad2antl3 ) ABCGDFAEABCFHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl32 $p |- ( ( ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ et ) -> ps ) $=
    ( w3a simpl2 3ad2antl3 ) ABCGDFBEABCFHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl33 $p |- ( ( ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ et ) -> ch ) $=
    ( w3a simpl3 3ad2antl3 ) ABCGDFCEABCFHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr11 $p |- ( ( et /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) ) -> ph ) $=
    ( w3a simpr1 3ad2antr1 ) FDABCGAEFABCHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr12 $p |- ( ( et /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) ) -> ps ) $=
    ( w3a simpr2 3ad2antr1 ) FDABCGBEFABCHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr13 $p |- ( ( et /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) ) -> ch ) $=
    ( w3a simpr3 3ad2antr1 ) FDABCGCEFABCHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr21 $p |- ( ( et /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) ) -> ph ) $=
    ( w3a simpr1 3ad2antr2 ) FDABCGAEFABCHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr22 $p |- ( ( et /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) ) -> ps ) $=
    ( w3a simpr2 3ad2antr2 ) FDABCGBEFABCHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr23 $p |- ( ( et /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) ) -> ch ) $=
    ( w3a simpr3 3ad2antr2 ) FDABCGCEFABCHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr31 $p |- ( ( et /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) ) -> ph ) $=
    ( w3a simpr1 3ad2antr3 ) FDABCGAEFABCHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr32 $p |- ( ( et /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) ) -> ps ) $=
    ( w3a simpr2 3ad2antr3 ) FDABCGBEFABCHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr33 $p |- ( ( et /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) ) -> ch ) $=
    ( w3a simpr3 3ad2antr3 ) FDABCGCEFABCHI $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1l1 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th ) /\ ta /\ et ) -> ph ) $=
    ( w3a wa simpl1 3ad2ant1 ) ABCGDHEAFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1l2 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th ) /\ ta /\ et ) -> ps ) $=
    ( w3a wa simpl2 3ad2ant1 ) ABCGDHEBFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1l3 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th ) /\ ta /\ et ) -> ch ) $=
    ( w3a wa simpl3 3ad2ant1 ) ABCGDHECFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1r1 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) ) /\ ta /\ et ) -> ph ) $=
    ( w3a wa simpr1 3ad2ant1 ) DABCGHEAFDABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1r2 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) ) /\ ta /\ et ) -> ps ) $=
    ( w3a wa simpr2 3ad2ant1 ) DABCGHEBFDABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1r3 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) ) /\ ta /\ et ) -> ch ) $=
    ( w3a wa simpr3 3ad2ant1 ) DABCGHECFDABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2l1 $p |- ( ( ta /\ ( ( ph /\ ps /\ ch ) /\ th ) /\ et ) -> ph ) $=
    ( w3a wa simpl1 3ad2ant2 ) ABCGDHEAFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2l2 $p |- ( ( ta /\ ( ( ph /\ ps /\ ch ) /\ th ) /\ et ) -> ps ) $=
    ( w3a wa simpl2 3ad2ant2 ) ABCGDHEBFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2l3 $p |- ( ( ta /\ ( ( ph /\ ps /\ ch ) /\ th ) /\ et ) -> ch ) $=
    ( w3a wa simpl3 3ad2ant2 ) ABCGDHECFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2r1 $p |- ( ( ta /\ ( th /\ ( ph /\ ps /\ ch ) ) /\ et ) -> ph ) $=
    ( w3a wa simpr1 3ad2ant2 ) DABCGHEAFDABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2r2 $p |- ( ( ta /\ ( th /\ ( ph /\ ps /\ ch ) ) /\ et ) -> ps ) $=
    ( w3a wa simpr2 3ad2ant2 ) DABCGHEBFDABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2r3 $p |- ( ( ta /\ ( th /\ ( ph /\ ps /\ ch ) ) /\ et ) -> ch ) $=
    ( w3a wa simpr3 3ad2ant2 ) DABCGHECFDABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3l1 $p |- ( ( ta /\ et /\ ( ( ph /\ ps /\ ch ) /\ th ) ) -> ph ) $=
    ( w3a wa simpl1 3ad2ant3 ) ABCGDHEAFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3l2 $p |- ( ( ta /\ et /\ ( ( ph /\ ps /\ ch ) /\ th ) ) -> ps ) $=
    ( w3a wa simpl2 3ad2ant3 ) ABCGDHEBFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3l3 $p |- ( ( ta /\ et /\ ( ( ph /\ ps /\ ch ) /\ th ) ) -> ch ) $=
    ( w3a wa simpl3 3ad2ant3 ) ABCGDHECFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3r1 $p |- ( ( ta /\ et /\ ( th /\ ( ph /\ ps /\ ch ) ) ) -> ph ) $=
    ( w3a wa simpr1 3ad2ant3 ) DABCGHEAFDABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3r2 $p |- ( ( ta /\ et /\ ( th /\ ( ph /\ ps /\ ch ) ) ) -> ps ) $=
    ( w3a wa simpr2 3ad2ant3 ) DABCGHEBFDABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3r3 $p |- ( ( ta /\ et /\ ( th /\ ( ph /\ ps /\ ch ) ) ) -> ch ) $=
    ( w3a wa simpr3 3ad2ant3 ) DABCGHECFDABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp11l $p |- ( ( ( ( ph /\ ps ) /\ ch /\ th ) /\ ta /\ et ) -> ph ) $=
    ( wa w3a simp1l 3ad2ant1 ) ABGCDHEAFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp11r $p |- ( ( ( ( ph /\ ps ) /\ ch /\ th ) /\ ta /\ et ) -> ps ) $=
    ( wa w3a simp1r 3ad2ant1 ) ABGCDHEBFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp12l $p |- ( ( ( ch /\ ( ph /\ ps ) /\ th ) /\ ta /\ et ) -> ph ) $=
    ( wa w3a simp2l 3ad2ant1 ) CABGDHEAFCABDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp12r $p |- ( ( ( ch /\ ( ph /\ ps ) /\ th ) /\ ta /\ et ) -> ps ) $=
    ( wa w3a simp2r 3ad2ant1 ) CABGDHEBFCABDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp13l $p |- ( ( ( ch /\ th /\ ( ph /\ ps ) ) /\ ta /\ et ) -> ph ) $=
    ( wa w3a simp3l 3ad2ant1 ) CDABGHEAFCDABIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp13r $p |- ( ( ( ch /\ th /\ ( ph /\ ps ) ) /\ ta /\ et ) -> ps ) $=
    ( wa w3a simp3r 3ad2ant1 ) CDABGHEBFCDABIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp21l $p |- ( ( ta /\ ( ( ph /\ ps ) /\ ch /\ th ) /\ et ) -> ph ) $=
    ( wa w3a simp1l 3ad2ant2 ) ABGCDHEAFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp21r $p |- ( ( ta /\ ( ( ph /\ ps ) /\ ch /\ th ) /\ et ) -> ps ) $=
    ( wa w3a simp1r 3ad2ant2 ) ABGCDHEBFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp22l $p |- ( ( ta /\ ( ch /\ ( ph /\ ps ) /\ th ) /\ et ) -> ph ) $=
    ( wa w3a simp2l 3ad2ant2 ) CABGDHEAFCABDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp22r $p |- ( ( ta /\ ( ch /\ ( ph /\ ps ) /\ th ) /\ et ) -> ps ) $=
    ( wa w3a simp2r 3ad2ant2 ) CABGDHEBFCABDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp23l $p |- ( ( ta /\ ( ch /\ th /\ ( ph /\ ps ) ) /\ et ) -> ph ) $=
    ( wa w3a simp3l 3ad2ant2 ) CDABGHEAFCDABIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp23r $p |- ( ( ta /\ ( ch /\ th /\ ( ph /\ ps ) ) /\ et ) -> ps ) $=
    ( wa w3a simp3r 3ad2ant2 ) CDABGHEBFCDABIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp31l $p |- ( ( ta /\ et /\ ( ( ph /\ ps ) /\ ch /\ th ) ) -> ph ) $=
    ( wa w3a simp1l 3ad2ant3 ) ABGCDHEAFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp31r $p |- ( ( ta /\ et /\ ( ( ph /\ ps ) /\ ch /\ th ) ) -> ps ) $=
    ( wa w3a simp1r 3ad2ant3 ) ABGCDHEBFABCDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp32l $p |- ( ( ta /\ et /\ ( ch /\ ( ph /\ ps ) /\ th ) ) -> ph ) $=
    ( wa w3a simp2l 3ad2ant3 ) CABGDHEAFCABDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp32r $p |- ( ( ta /\ et /\ ( ch /\ ( ph /\ ps ) /\ th ) ) -> ps ) $=
    ( wa w3a simp2r 3ad2ant3 ) CABGDHEBFCABDIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp33l $p |- ( ( ta /\ et /\ ( ch /\ th /\ ( ph /\ ps ) ) ) -> ph ) $=
    ( wa w3a simp3l 3ad2ant3 ) CDABGHEAFCDABIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp33r $p |- ( ( ta /\ et /\ ( ch /\ th /\ ( ph /\ ps ) ) ) -> ps ) $=
    ( wa w3a simp3r 3ad2ant3 ) CDABGHEBFCDABIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp111 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ et /\ ze ) -> ph ) $=
    ( w3a simp11 3ad2ant1 ) ABCHDEHFAGABCDEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp112 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ et /\ ze ) -> ps ) $=
    ( w3a simp12 3ad2ant1 ) ABCHDEHFBGABCDEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp113 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ et /\ ze ) -> ch ) $=
    ( w3a simp13 3ad2ant1 ) ABCHDEHFCGABCDEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp121 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ et /\ ze ) -> ph ) $=
    ( w3a simp21 3ad2ant1 ) DABCHEHFAGDABCEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp122 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ et /\ ze ) -> ps ) $=
    ( w3a simp22 3ad2ant1 ) DABCHEHFBGDABCEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp123 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ et /\ ze ) -> ch ) $=
    ( w3a simp23 3ad2ant1 ) DABCHEHFCGDABCEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp131 $p |- ( ( ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ et /\ ze ) -> ph ) $=
    ( w3a simp31 3ad2ant1 ) DEABCHHFAGDEABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp132 $p |- ( ( ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ et /\ ze ) -> ps ) $=
    ( w3a simp32 3ad2ant1 ) DEABCHHFBGDEABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp133 $p |- ( ( ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ et /\ ze ) -> ch ) $=
    ( w3a simp33 3ad2ant1 ) DEABCHHFCGDEABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp211 $p |- ( ( et /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ ze ) -> ph ) $=
    ( w3a simp11 3ad2ant2 ) ABCHDEHFAGABCDEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp212 $p |- ( ( et /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ ze ) -> ps ) $=
    ( w3a simp12 3ad2ant2 ) ABCHDEHFBGABCDEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp213 $p |- ( ( et /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ ze ) -> ch ) $=
    ( w3a simp13 3ad2ant2 ) ABCHDEHFCGABCDEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp221 $p |- ( ( et /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ ze ) -> ph ) $=
    ( w3a simp21 3ad2ant2 ) DABCHEHFAGDABCEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp222 $p |- ( ( et /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ ze ) -> ps ) $=
    ( w3a simp22 3ad2ant2 ) DABCHEHFBGDABCEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp223 $p |- ( ( et /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ ze ) -> ch ) $=
    ( w3a simp23 3ad2ant2 ) DABCHEHFCGDABCEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp231 $p |- ( ( et /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ ze ) -> ph ) $=
    ( w3a simp31 3ad2ant2 ) DEABCHHFAGDEABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp232 $p |- ( ( et /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ ze ) -> ps ) $=
    ( w3a simp32 3ad2ant2 ) DEABCHHFBGDEABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp233 $p |- ( ( et /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ ze ) -> ch ) $=
    ( w3a simp33 3ad2ant2 ) DEABCHHFCGDEABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp311 $p |- ( ( et /\ ze /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) ) -> ph ) $=
    ( w3a simp11 3ad2ant3 ) ABCHDEHFAGABCDEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp312 $p |- ( ( et /\ ze /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) ) -> ps ) $=
    ( w3a simp12 3ad2ant3 ) ABCHDEHFBGABCDEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp313 $p |- ( ( et /\ ze /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) ) -> ch ) $=
    ( w3a simp13 3ad2ant3 ) ABCHDEHFCGABCDEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp321 $p |- ( ( et /\ ze /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) ) -> ph ) $=
    ( w3a simp21 3ad2ant3 ) DABCHEHFAGDABCEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp322 $p |- ( ( et /\ ze /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) ) -> ps ) $=
    ( w3a simp22 3ad2ant3 ) DABCHEHFBGDABCEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp323 $p |- ( ( et /\ ze /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) ) -> ch ) $=
    ( w3a simp23 3ad2ant3 ) DABCHEHFCGDABCEIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp331 $p |- ( ( et /\ ze /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) ) -> ph ) $=
    ( w3a simp31 3ad2ant3 ) DEABCHHFAGDEABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp332 $p |- ( ( et /\ ze /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) ) -> ps ) $=
    ( w3a simp32 3ad2ant3 ) DEABCHHFBGDEABCIJ $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp333 $p |- ( ( et /\ ze /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) ) -> ch ) $=
    ( w3a simp33 3ad2ant3 ) DEABCHHFCGDEABCIJ $.

  ${
    3anibar.1 $e |- ( ( ph /\ ps /\ ch ) -> ( th <-> ( ch /\ ta ) ) ) $.
    $( Remove a hypothesis from the second member of a biconditional.
       (Contributed by FL, 22-Jul-2008.) $)
    3anibar $p |- ( ( ph /\ ps /\ ch ) -> ( th <-> ta ) ) $=
      ( w3a simp3 mpbirand ) ABCGDCEABCHFI $.
  $}

  $( Introduction in triple disjunction.  (Contributed by NM, 4-Apr-1995.) $)
  3mix1 $p |- ( ph -> ( ph \/ ps \/ ch ) ) $=
    ( wo w3o orc 3orass sylibr ) AABCDZDABCEAIFABCGH $.

  $( Introduction in triple disjunction.  (Contributed by NM, 4-Apr-1995.) $)
  3mix2 $p |- ( ph -> ( ps \/ ph \/ ch ) ) $=
    ( w3o 3mix1 3orrot sylibr ) AACBDBACDACBEBACFG $.

  $( Introduction in triple disjunction.  (Contributed by NM, 4-Apr-1995.) $)
  3mix3 $p |- ( ph -> ( ps \/ ch \/ ph ) ) $=
    ( w3o 3mix1 3orrot sylib ) AABCDBCADABCEABCFG $.

  ${
    3mixi.1 $e |- ph $.
    $( Introduction in triple disjunction.  (Contributed by Mario Carneiro,
       6-Oct-2014.) $)
    3mix1i $p |- ( ph \/ ps \/ ch ) $=
      ( w3o 3mix1 ax-mp ) AABCEDABCFG $.

    $( Introduction in triple disjunction.  (Contributed by Mario Carneiro,
       6-Oct-2014.) $)
    3mix2i $p |- ( ps \/ ph \/ ch ) $=
      ( w3o 3mix2 ax-mp ) ABACEDABCFG $.

    $( Introduction in triple disjunction.  (Contributed by Mario Carneiro,
       6-Oct-2014.) $)
    3mix3i $p |- ( ps \/ ch \/ ph ) $=
      ( w3o 3mix3 ax-mp ) ABCAEDABCFG $.
  $}

  ${
    3mixd.1 $e |- ( ph -> ps ) $.
    $( Deduction introducing triple disjunction.  (Contributed by Scott Fenton,
       8-Jun-2011.) $)
    3mix1d $p |- ( ph -> ( ps \/ ch \/ th ) ) $=
      ( w3o 3mix1 syl ) ABBCDFEBCDGH $.

    $( Deduction introducing triple disjunction.  (Contributed by Scott Fenton,
       8-Jun-2011.) $)
    3mix2d $p |- ( ph -> ( ch \/ ps \/ th ) ) $=
      ( w3o 3mix2 syl ) ABCBDFEBCDGH $.

    $( Deduction introducing triple disjunction.  (Contributed by Scott Fenton,
       8-Jun-2011.) $)
    3mix3d $p |- ( ph -> ( ch \/ th \/ ps ) ) $=
      ( w3o 3mix3 syl ) ABCDBFEBCDGH $.
  $}

  ${
    3pm3.2i.1 $e |- ph $.
    3pm3.2i.2 $e |- ps $.
    3pm3.2i.3 $e |- ch $.
    $( Infer conjunction of premises.  (Contributed by NM, 10-Feb-1995.) $)
    3pm3.2i $p |- ( ph /\ ps /\ ch ) $=
      ( w3a wa pm3.2i df-3an mpbir2an ) ABCGABHCABDEIFABCJK $.
  $}

  $( Version of ~ pm3.2 for a triple conjunction.  (Contributed by Alan Sare,
     24-Oct-2011.)  (Proof shortened by Kyle Wyonch, 24-Apr-2021.)  (Proof
     shortened by Wolf Lammen, 21-Jun-2022.) $)
  pm3.2an3 $p |- ( ph -> ( ps -> ( ch -> ( ph /\ ps /\ ch ) ) ) ) $=
    ( w3a id 3exp ) ABCABCDZGEF $.

  ${
    mpbir3an.1 $e |- ps $.
    mpbir3an.2 $e |- ch $.
    mpbir3an.3 $e |- th $.
    mpbir3an.4 $e |- ( ph <-> ( ps /\ ch /\ th ) ) $.
    $( Detach a conjunction of truths in a biconditional.  (Contributed by NM,
       16-Sep-2011.) $)
    mpbir3an $p |- ph $=
      ( w3a 3pm3.2i mpbir ) ABCDIBCDEFGJHK $.
  $}

  ${
    mpbir3and.1 $e |- ( ph -> ch ) $.
    mpbir3and.2 $e |- ( ph -> th ) $.
    mpbir3and.3 $e |- ( ph -> ta ) $.
    mpbir3and.4 $e |- ( ph -> ( ps <-> ( ch /\ th /\ ta ) ) ) $.
    $( Detach a conjunction of truths in a biconditional.  (Contributed by
       Mario Carneiro, 11-May-2014.)  (Revised by Mario Carneiro,
       9-Jan-2015.) $)
    mpbir3and $p |- ( ph -> ps ) $=
      ( w3a 3jca mpbird ) ABCDEJACDEFGHKIL $.
  $}

  ${
    syl3anbrc.1 $e |- ( ph -> ps ) $.
    syl3anbrc.2 $e |- ( ph -> ch ) $.
    syl3anbrc.3 $e |- ( ph -> th ) $.
    syl3anbrc.4 $e |- ( ta <-> ( ps /\ ch /\ th ) ) $.
    $( Syllogism inference.  (Contributed by Mario Carneiro, 11-May-2014.) $)
    syl3anbrc $p |- ( ph -> ta ) $=
      ( w3a 3jca sylibr ) ABCDJEABCDFGHKIL $.
  $}

  ${
    syl21anbrc.1 $e |- ( ph -> ps ) $.
    syl21anbrc.2 $e |- ( ph -> ch ) $.
    syl21anbrc.3 $e |- ( ph -> th ) $.
    syl21anbrc.4 $e |- ( ta <-> ( ( ps /\ ch ) /\ th ) ) $.
    $( Syllogism inference.  (Contributed by Peter Mazsa, 18-Sep-2022.) $)
    syl21anbrc $p |- ( ph -> ta ) $=
      ( wa jca31 sylibr ) ABCJDJEABCDFGHKIL $.
  $}

  ${
    3imp3i2an.1 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    3imp3i2an.2 $e |- ( ( ph /\ ch ) -> ta ) $.
    3imp3i2an.3 $e |- ( ( th /\ ta ) -> et ) $.
    $( An elimination deduction.  (Contributed by Alan Sare, 17-Oct-2017.)
       (Proof shortened by Wolf Lammen, 13-Apr-2022.) $)
    3imp3i2an $p |- ( ( ph /\ ps /\ ch ) -> et ) $=
      ( w3a 3adant2 syl2anc ) ABCJDEFGACEBHKIL $.
  $}

  ${
    ex3.1 $e |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $.
    $( Apply ~ ex to a hypothesis with a 3-right-nested conjunction antecedent,
       with the antecedent of the assertion being a triple conjunction rather
       than a 2-right-nested conjunction.  (Contributed by Alan Sare,
       22-Apr-2018.) $)
    ex3 $p |- ( ( ph /\ ps /\ ch ) -> ( th -> ta ) ) $=
      ( wi wa ex 3impa ) ABCDEGABHCHDEFIJ $.
  $}

  ${
    3imp1.1 $e |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $.
    $( Importation to left triple conjunction.  (Contributed by NM,
       24-Feb-2005.) $)
    3imp1 $p |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $=
      ( w3a wi 3imp imp ) ABCGDEABCDEHFIJ $.

    $( Importation deduction for triple conjunction.  (Contributed by NM,
       26-Oct-2006.) $)
    3impd $p |- ( ph -> ( ( ps /\ ch /\ th ) -> ta ) ) $=
      ( w3a wi com4l 3imp com12 ) BCDGAEBCDAEHABCDEFIJK $.

    $( Importation to right triple conjunction.  (Contributed by NM,
       26-Oct-2006.) $)
    3imp2 $p |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $=
      ( w3a 3impd imp ) ABCDGEABCDEFHI $.
  $}

  ${
    3impdi.1 $e |- ( ( ( ph /\ ps ) /\ ( ph /\ ch ) ) -> th ) $.
    $( Importation inference (undistribute conjunction).  (Contributed by NM,
       14-Aug-1995.) $)
    3impdi $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      ( anandis 3impb ) ABCDABCDEFG $.
  $}

  ${
    3impdir.1 $e |- ( ( ( ph /\ ps ) /\ ( ch /\ ps ) ) -> th ) $.
    $( Importation inference (undistribute conjunction).  (Contributed by NM,
       20-Aug-1995.) $)
    3impdir $p |- ( ( ph /\ ch /\ ps ) -> th ) $=
      ( anandirs 3impa ) ACBDACBDEFG $.
  $}

  ${
    3exp1.1 $e |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $.
    $( Exportation from left triple conjunction.  (Contributed by NM,
       24-Feb-2005.) $)
    3exp1 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      ( wi w3a ex 3exp ) ABCDEGABCHDEFIJ $.
  $}

  ${
    3expd.1 $e |- ( ph -> ( ( ps /\ ch /\ th ) -> ta ) ) $.
    $( Exportation deduction for triple conjunction.  (Contributed by NM,
       26-Oct-2006.) $)
    3expd $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      ( wi w3a com12 3exp com4r ) BCDAEBCDAEGABCDHEFIJK $.
  $}

  ${
    3exp2.1 $e |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $.
    $( Exportation from right triple conjunction.  (Contributed by NM,
       26-Oct-2006.) $)
    3exp2 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      ( w3a ex 3expd ) ABCDEABCDGEFHI $.
  $}

  ${
    exp5o.1 $e |- ( ( ph /\ ps /\ ch ) -> ( ( th /\ ta ) -> et ) ) $.
    $( A triple exportation inference.  (Contributed by Jeff Hankins,
       8-Jul-2009.) $)
    exp5o $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      ( wi w3a expd 3exp ) ABCDEFHHABCIDEFGJK $.
  $}

  ${
    exp516.1 $e |- ( ( ( ph /\ ( ps /\ ch /\ th ) ) /\ ta ) -> et ) $.
    $( A triple exportation inference.  (Contributed by Jeff Hankins,
       8-Jul-2009.) $)
    exp516 $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      ( wi w3a exp31 3expd ) ABCDEFHABCDIEFGJK $.
  $}

  ${
    exp520.1 $e |- ( ( ( ph /\ ps /\ ch ) /\ ( th /\ ta ) ) -> et ) $.
    $( A triple exportation inference.  (Contributed by Jeff Hankins,
       8-Jul-2009.) $)
    exp520 $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      ( w3a wa ex exp5o ) ABCDEFABCHDEIFGJK $.
  $}

  $( Version of ~ impexp for a triple conjunction.  (Contributed by Alan Sare,
     31-Dec-2011.) $)
  3impexp $p |- ( ( ( ph /\ ps /\ ch ) -> th ) <->
                ( ph -> ( ps -> ( ch -> th ) ) ) ) $=
    ( w3a wi id 3expd 3impd impbii ) ABCEDFZABCDFFFZKABCDKGHLABCDLGIJ $.

  ${
    3an1rs.1 $e |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $.
    $( Swap conjuncts.  (Contributed by NM, 16-Dec-2007.)  (Proof shortened by
       Wolf Lammen, 14-Apr-2022.) $)
    3an1rs $p |- ( ( ( ph /\ ps /\ th ) /\ ch ) -> ta ) $=
      ( 3exp1 com34 3imp1 ) ABDCEABCDEABCDEFGHI $.
  $}

  $( Associative law for four conjunctions with a triple conjunction.
     (Contributed by Thierry Arnoux, 21-Jan-2025.) $)
  13an22anass $p |- ( ( ph /\ ( ps /\ ch /\ th ) )
                   <-> ( ( ph /\ ps ) /\ ( ch /\ th ) ) ) $=
    ( wa w3a an2anr an4 bitri an43 3bitr2ri 3an4anass ancom ) ABECDEEZBCEDAEEZB
    CDFZAEAPEOCBEADEEZACEDBEEZNBCDAGRCAEBDEEQACDBGCABDHIACDBJKBCDALPAMK $.

  ${
    3anasss.1 $e |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $.
    $( Associative law for conjunction applied to antecedent (eliminates
       syllogism).  Converse of ~ 3anassrs .  (Contributed by Thierry Arnoux,
       5-Jul-2026.) $)
    3anasss $p |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $=
      ( w3a wa 13an22anass anasss sylbi ) ABCDGHABHZCDHHEABCDILCDEFJK $.
  $}

  ${
    3anassrs.1 $e |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $.
    $( Associative law for conjunction applied to antecedent (eliminates
       syllogism).  (Contributed by Mario Carneiro, 4-Jan-2017.) $)
    3anassrs $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $=
      ( 3exp2 imp41 ) ABCDEABCDEFGH $.
  $}

  $( An equivalence of two four-terms conjunctions with the terms regrouped
     (here, the second sub-conjunct of the first term is pulled separately).
     (Contributed by Zhi Wang, 4-Sep-2024.)  (Proof shortened by Garrett Katz,
     26-Jun-2026.) $)
  4anpull2 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) )
          <-> ( ( ph /\ ch /\ th ) /\ ps ) ) $=
    ( wa w3a an42 3an4anass bitr4i ) ABECDEEACEDBEEACDFBEABCDGACDBHI $.

  $( Obsolete version of ~ 4anpull2 as of 26-Jun-2026.  An equivalence of two
     four-terms conjunctions with the terms regrouped (here, the second
     sub-conjunct of the first term is pulled separately).  (Contributed by Zhi
     Wang, 4-Sep-2024.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  4anpull2OLD $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) )
          <-> ( ( ph /\ ch /\ th ) /\ ps ) ) $=
    ( wa w3a anass 3anass anbi1i ancom anbi2i 3bitr4ri bitri ) ABECDEZEABNEZEZA
    CDFZBEZABNGANEZBEANBEZERPANBGQSBACDHIOTABNJKLM $.

  ${
    ad5ant.1 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant245 $p |- ( ( ( ( ( ta /\ ph ) /\ et ) /\ ps ) /\ ch ) -> th ) $=
      ( wa 3adant1l ad4ant134 ) EAHBCDFABCDEGIJ $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant234 $p |- ( ( ( ( ( ta /\ ph ) /\ ps ) /\ ch ) /\ et ) -> th ) $=
      ( wa ad4ant234 adantr ) EAHBHCHDFABCDEGIJ $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant235 $p |- ( ( ( ( ( ta /\ ph ) /\ ps ) /\ et ) /\ ch ) -> th ) $=
      ( wa ad4ant234 adantlr ) EAHBHCDFABCDEGIJ $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
    ad5ant123 $p |- ( ( ( ( ( ph /\ ps ) /\ ch ) /\ ta ) /\ et ) -> th ) $=
      ( wa 3expa ad2antrr ) ABHCHDEFABCDGIJ $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.)  (Proof
       shortened by Garrett Katz, 13-Jun-2026.) $)
    ad5ant124 $p |- ( ( ( ( ( ph /\ ps ) /\ ta ) /\ ch ) /\ et ) -> th ) $=
      ( wa 3expa ad4ant13 ) ABHCDEFABCDGIJ $.

    $( Obsolete version of ~ ad5ant124 as of 13-Jun-2026.  Deduction adding
       conjuncts to antecedent.  (Contributed by Alan Sare, 17-Oct-2017.)
       (Proof shortened by Wolf Lammen, 23-Jun-2022.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    ad5ant124OLD $p |- ( ( ( ( ( ph /\ ps ) /\ ta ) /\ ch ) /\ et ) -> th ) $=
      ( wa ad4ant124 adantr ) ABHEHCHDFABCDEGIJ $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.)  (Proof
       shortened by Garrett Katz, 13-Jun-2026.) $)
    ad5ant125 $p |- ( ( ( ( ( ph /\ ps ) /\ ta ) /\ et ) /\ ch ) -> th ) $=
      ( wa 3expa ad4ant14 ) ABHCDEFABCDGIJ $.

    $( Obsolete version of ~ ad5ant125 as of 13-Jun-2026.  Deduction adding
       conjuncts to antecedent.  (Contributed by Alan Sare, 17-Oct-2017.)
       (Proof shortened by Wolf Lammen, 23-Jun-2022.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    ad5ant125OLD $p |- ( ( ( ( ( ph /\ ps ) /\ ta ) /\ et ) /\ ch ) -> th ) $=
      ( wa wi 3expia 2a1d imp41 ) ABHZEFCDMCDIEFABCDGJKL $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.)  (Proof
       shortened by Garrett Katz, 13-Jun-2026.) $)
    ad5ant134 $p |- ( ( ( ( ( ph /\ ta ) /\ ps ) /\ ch ) /\ et ) -> th ) $=
      ( ad4ant123 adantl3r ) ABCFDEABCDFGHI $.

    $( Obsolete version of ~ ad5ant134 as of 13-Jun-2026.  Deduction adding
       conjuncts to antecedent.  (Contributed by Alan Sare, 17-Oct-2017.)
       (Proof shortened by Wolf Lammen, 23-Jun-2022.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    ad5ant134OLD $p |- ( ( ( ( ( ph /\ ta ) /\ ps ) /\ ch ) /\ et ) -> th ) $=
      ( wa ad4ant134 adantr ) AEHBHCHDFABCDEGIJ $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.)  (Proof
       shortened by Garrett Katz, 13-Jun-2026.) $)
    ad5ant135 $p |- ( ( ( ( ( ph /\ ta ) /\ ps ) /\ et ) /\ ch ) -> th ) $=
      ( ad4ant124 adantl3r ) ABFCDEABCDFGHI $.

    $( Obsolete version of ~ ad5ant135 as of 13-Jun-2026.  Deduction adding
       conjuncts to antecedent.  (Contributed by Alan Sare, 17-Oct-2017.)
       (Proof shortened by Wolf Lammen, 23-Jun-2022.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    ad5ant135OLD $p |- ( ( ( ( ( ph /\ ta ) /\ ps ) /\ et ) /\ ch ) -> th ) $=
      ( wa ad4ant134 adantlr ) AEHBHCDFABCDEGIJ $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
    ad5ant145 $p |- ( ( ( ( ( ph /\ ta ) /\ et ) /\ ps ) /\ ch ) -> th ) $=
      ( wa ad4ant134 adantllr ) AEHBCDFABCDEGIJ $.
  $}

  ${
    ad5ant2345.1 $e |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $.
    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.) $)
    ad5ant2345 $p |- ( ( ( ( ( et /\ ph ) /\ ps ) /\ ch ) /\ th ) -> ta ) $=
      ( wa wi exp41 adantl imp41 ) FAHBCDEABCDEIIIFABCDEGJKL $.
  $}

  ${
    syl3anc.1 $e |- ( ph -> ps ) $.
    syl3anc.2 $e |- ( ph -> ch ) $.
    syl3anc.3 $e |- ( ph -> th ) $.
    ${
      syl3anc.4 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl3anc $p |- ( ph -> ta ) $=
        ( w3a 3jca syl ) ABCDJEABCDFGHKIL $.
    $}

    syl3Xanc.4 $e |- ( ph -> ta ) $.
    ${
      syl13anc.5 $e |- ( ( ps /\ ( ch /\ th /\ ta ) ) -> et ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl13anc $p |- ( ph -> et ) $=
        ( w3a 3jca syl2anc ) ABCDELFGACDEHIJMKN $.
    $}

    ${
      syl31anc.5 $e |- ( ( ( ps /\ ch /\ th ) /\ ta ) -> et ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl31anc $p |- ( ph -> et ) $=
        ( w3a 3jca syl2anc ) ABCDLEFABCDGHIMJKN $.
    $}

    ${
      syl112anc.5 $e |- ( ( ps /\ ch /\ ( th /\ ta ) ) -> et ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl112anc $p |- ( ph -> et ) $=
        ( wa jca syl3anc ) ABCDELFGHADEIJMKN $.
    $}

    ${
      syl121anc.5 $e |- ( ( ps /\ ( ch /\ th ) /\ ta ) -> et ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl121anc $p |- ( ph -> et ) $=
        ( wa jca syl3anc ) ABCDLEFGACDHIMJKN $.
    $}

    ${
      syl211anc.5 $e |- ( ( ( ps /\ ch ) /\ th /\ ta ) -> et ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl211anc $p |- ( ph -> et ) $=
        ( wa jca syl3anc ) ABCLDEFABCGHMIJKN $.
    $}

    syl23anc.5 $e |- ( ph -> et ) $.
    ${
      syl23anc.6 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta /\ et ) ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl23anc $p |- ( ph -> ze ) $=
        ( wa jca syl13anc ) ABCNDEFGABCHIOJKLMP $.
    $}

    ${
      syl32anc.6 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et ) ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl32anc $p |- ( ph -> ze ) $=
        ( wa jca syl31anc ) ABCDEFNGHIJAEFKLOMP $.
    $}

    ${
      syl122anc.6 $e |- ( ( ps /\ ( ch /\ th ) /\ ( ta /\ et ) ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl122anc $p |- ( ph -> ze ) $=
        ( wa jca syl121anc ) ABCDEFNGHIJAEFKLOMP $.
    $}

    ${
      syl212anc.6 $e |- ( ( ( ps /\ ch ) /\ th /\ ( ta /\ et ) ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl212anc $p |- ( ph -> ze ) $=
        ( wa jca syl211anc ) ABCDEFNGHIJAEFKLOMP $.
    $}

    ${
      syl221anc.6 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta ) /\ et ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl221anc $p |- ( ph -> ze ) $=
        ( wa jca syl211anc ) ABCDENFGHIADEJKOLMP $.
    $}

    ${
      syl113anc.6 $e |- ( ( ps /\ ch /\ ( th /\ ta /\ et ) ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl113anc $p |- ( ph -> ze ) $=
        ( w3a 3jca syl3anc ) ABCDEFNGHIADEFJKLOMP $.
    $}

    ${
      syl131anc.6 $e |- ( ( ps /\ ( ch /\ th /\ ta ) /\ et ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl131anc $p |- ( ph -> ze ) $=
        ( w3a 3jca syl3anc ) ABCDENFGHACDEIJKOLMP $.
    $}

    ${
      syl311anc.6 $e |- ( ( ( ps /\ ch /\ th ) /\ ta /\ et ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl311anc $p |- ( ph -> ze ) $=
        ( w3a 3jca syl3anc ) ABCDNEFGABCDHIJOKLMP $.
    $}

    syl33anc.6 $e |- ( ph -> ze ) $.
    ${
      syl33anc.7 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et /\ ze ) )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl33anc $p |- ( ph -> si ) $=
        ( w3a 3jca syl13anc ) ABCDPEFGHABCDIJKQLMNOR $.
    $}

    ${
      syl222anc.7 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta ) /\ ( et /\ ze ) )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl222anc $p |- ( ph -> si ) $=
        ( wa jca syl221anc ) ABCDEFGPHIJKLAFGMNQOR $.
    $}

    ${
      syl123anc.7 $e |- ( ( ps /\ ( ch /\ th ) /\ ( ta /\ et /\ ze ) )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl123anc $p |- ( ph -> si ) $=
        ( wa jca syl113anc ) ABCDPEFGHIACDJKQLMNOR $.
    $}

    ${
      syl132anc.7 $e |- ( ( ps /\ ( ch /\ th /\ ta ) /\ ( et /\ ze ) )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Jul-2012.) $)
      syl132anc $p |- ( ph -> si ) $=
        ( wa jca syl131anc ) ABCDEFGPHIJKLAFGMNQOR $.
    $}

    ${
      syl213anc.7 $e |- ( ( ( ps /\ ch ) /\ th /\ ( ta /\ et /\ ze ) )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl213anc $p |- ( ph -> si ) $=
        ( wa jca syl113anc ) ABCPDEFGHABCIJQKLMNOR $.
    $}

    ${
      syl231anc.7 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta /\ et ) /\ ze )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl231anc $p |- ( ph -> si ) $=
        ( wa jca syl131anc ) ABCPDEFGHABCIJQKLMNOR $.
    $}

    ${
      syl312anc.7 $e |- ( ( ( ps /\ ch /\ th ) /\ ta /\ ( et /\ ze ) )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Jul-2012.) $)
      syl312anc $p |- ( ph -> si ) $=
        ( wa jca syl311anc ) ABCDEFGPHIJKLAFGMNQOR $.
    $}

    ${
      syl321anc.7 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et ) /\ ze )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Jul-2012.) $)
      syl321anc $p |- ( ph -> si ) $=
        ( wa jca syl311anc ) ABCDEFPGHIJKAEFLMQNOR $.
    $}

    syl133anc.7 $e |- ( ph -> si ) $.
    ${
      syl133anc.8 $e |- ( ( ps /\ ( ch /\ th /\ ta ) /\ ( et /\ ze /\ si ) )
           -> rh ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl133anc $p |- ( ph -> rh ) $=
        ( w3a 3jca syl131anc ) ABCDEFGHRIJKLMAFGHNOPSQT $.
    $}

    ${
      syl313anc.8 $e |- ( ( ( ps /\ ch /\ th ) /\ ta /\ ( et /\ ze /\ si ) )
           -> rh ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl313anc $p |- ( ph -> rh ) $=
        ( w3a 3jca syl311anc ) ABCDEFGHRIJKLMAFGHNOPSQT $.
    $}

    ${
      syl331anc.8 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et /\ ze ) /\ si )
           -> rh ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl331anc $p |- ( ph -> rh ) $=
        ( w3a 3jca syl311anc ) ABCDEFGRHIJKLAEFGMNOSPQT $.
    $}

    ${
      syl223anc.8 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta ) /\ ( et /\ ze /\ si )
          ) -> rh ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl223anc $p |- ( ph -> rh ) $=
        ( wa jca syl213anc ) ABCDERFGHIJKADELMSNOPQT $.
    $}

    ${
      syl232anc.8 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta /\ et ) /\ ( ze /\ si )
          ) -> rh ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl232anc $p |- ( ph -> rh ) $=
        ( wa jca syl231anc ) ABCDEFGHRIJKLMNAGHOPSQT $.
    $}

    ${
      syl322anc.8 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et ) /\ ( ze /\ si )
          ) -> rh ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl322anc $p |- ( ph -> rh ) $=
        ( wa jca syl321anc ) ABCDEFGHRIJKLMNAGHOPSQT $.
    $}

    syl233anc.8 $e |- ( ph -> rh ) $.
    ${
      syl233anc.9 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta /\ et ) /\ ( ze /\ si /\
          rh ) ) -> mu ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl233anc $p |- ( ph -> mu ) $=
        ( wa jca syl133anc ) ABCTDEFGHIJABCKLUAMNOPQRSUB $.
    $}

    ${
      syl323anc.9 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et ) /\ ( ze /\ si /\
          rh ) ) -> mu ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl323anc $p |- ( ph -> mu ) $=
        ( wa jca syl313anc ) ABCDEFTGHIJKLMAEFNOUAPQRSUB $.
    $}

    ${
      syl332anc.9 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et /\ ze ) /\ ( si /\
          rh ) ) -> mu ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl332anc $p |- ( ph -> mu ) $=
        ( wa jca syl331anc ) ABCDEFGHITJKLMNOPAHIQRUASUB $.
    $}

    syl333anc.9 $e |- ( ph -> mu ) $.
    ${
      syl333anc.10 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et /\ ze )
          /\ ( si /\ rh /\ mu ) ) -> la ) $.
      $( A syllogism inference combined with contraction.  (Contributed by NM,
         10-Mar-2012.) $)
      syl333anc $p |- ( ph -> la ) $=
        ( w3a 3jca syl331anc ) ABCDEFGHIJUBKLMNOPQAHIJRSTUCUAUD $.
    $}
  $}

  ${
    syl3an1b.1 $e |- ( ph <-> ps ) $.
    syl3an1b.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an1b $p |- ( ( ph /\ ch /\ th ) -> ta ) $=
      ( biimpi syl3an1 ) ABCDEABFHGI $.
  $}

  ${
    syl3an2b.1 $e |- ( ph <-> ch ) $.
    syl3an2b.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an2b $p |- ( ( ps /\ ph /\ th ) -> ta ) $=
      ( biimpi syl3an2 ) ABCDEACFHGI $.
  $}

  ${
    syl3an3b.1 $e |- ( ph <-> th ) $.
    syl3an3b.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an3b $p |- ( ( ps /\ ch /\ ph ) -> ta ) $=
      ( biimpi syl3an3 ) ABCDEADFHGI $.
  $}

  ${
    syl3an1br.1 $e |- ( ps <-> ph ) $.
    syl3an1br.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an1br $p |- ( ( ph /\ ch /\ th ) -> ta ) $=
      ( biimpri syl3an1 ) ABCDEBAFHGI $.
  $}

  ${
    syl3an2br.1 $e |- ( ch <-> ph ) $.
    syl3an2br.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an2br $p |- ( ( ps /\ ph /\ th ) -> ta ) $=
      ( biimpri syl3an2 ) ABCDECAFHGI $.
  $}

  ${
    syl3an3br.1 $e |- ( th <-> ph ) $.
    syl3an3br.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an3br $p |- ( ( ps /\ ch /\ ph ) -> ta ) $=
      ( biimpri syl3an3 ) ABCDEDAFHGI $.
  $}

  ${
    syld3an3.1 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    syld3an3.2 $e |- ( ( ph /\ ps /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 20-May-2007.) $)
    syld3an3 $p |- ( ( ph /\ ps /\ ch ) -> ta ) $=
      ( w3a simp1 simp2 syl3anc ) ABCHABDEABCIABCJFGK $.
  $}

  ${
    syld3an1.1 $e |- ( ( ch /\ ps /\ th ) -> ph ) $.
    syld3an1.2 $e |- ( ( ph /\ ps /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 7-Jul-2008.)  (Proof
       shortened by Wolf Lammen, 26-Jun-2022.) $)
    syld3an1 $p |- ( ( ch /\ ps /\ th ) -> ta ) $=
      ( w3a simp2 simp3 syl3anc ) CBDHABDEFCBDICBDJGK $.
  $}

  ${
    syld3an2.1 $e |- ( ( ph /\ ch /\ th ) -> ps ) $.
    syld3an2.2 $e |- ( ( ph /\ ps /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 20-May-2007.) $)
    syld3an2 $p |- ( ( ph /\ ch /\ th ) -> ta ) $=
      ( w3a simp1 simp3 syl3anc ) ACDHABDEACDIFACDJGK $.
  $}

  ${
    syl3anl1.1 $e |- ( ph -> ps ) $.
    syl3anl1.2 $e |- ( ( ( ps /\ ch /\ th ) /\ ta ) -> et ) $.
    $( A syllogism inference.  (Contributed by NM, 24-Feb-2005.) $)
    syl3anl1 $p |- ( ( ( ph /\ ch /\ th ) /\ ta ) -> et ) $=
      ( w3a 3anim1i sylan ) ACDIBCDIEFABCDGJHK $.
  $}

  ${
    syl3anl2.1 $e |- ( ph -> ch ) $.
    syl3anl2.2 $e |- ( ( ( ps /\ ch /\ th ) /\ ta ) -> et ) $.
    $( A syllogism inference.  (Contributed by NM, 24-Feb-2005.)  (Proof
       shortened by Wolf Lammen, 27-Jun-2022.) $)
    syl3anl2 $p |- ( ( ( ps /\ ph /\ th ) /\ ta ) -> et ) $=
      ( w3a 3anim2i sylan ) BADIBCDIEFACBDGJHK $.
  $}

  ${
    syl3anl3.1 $e |- ( ph -> th ) $.
    syl3anl3.2 $e |- ( ( ( ps /\ ch /\ th ) /\ ta ) -> et ) $.
    $( A syllogism inference.  (Contributed by NM, 24-Feb-2005.) $)
    syl3anl3 $p |- ( ( ( ps /\ ch /\ ph ) /\ ta ) -> et ) $=
      ( w3a 3anim3i sylan ) BCAIBCDIEFADBCGJHK $.
  $}

  ${
    syl3anl.1 $e |- ( ph -> ps ) $.
    syl3anl.2 $e |- ( ch -> th ) $.
    syl3anl.3 $e |- ( ta -> et ) $.
    syl3anl.4 $e |- ( ( ( ps /\ th /\ et ) /\ ze ) -> si ) $.
    $( A triple syllogism inference.  (Contributed by NM, 24-Dec-2006.) $)
    syl3anl $p |- ( ( ( ph /\ ch /\ ta ) /\ ze ) -> si ) $=
      ( w3a 3anim123i sylan ) ACEMBDFMGHABCDEFIJKNLO $.
  $}

  ${
    syl3anr1.1 $e |- ( ph -> ps ) $.
    syl3anr1.2 $e |- ( ( ch /\ ( ps /\ th /\ ta ) ) -> et ) $.
    $( A syllogism inference.  (Contributed by NM, 31-Jul-2007.) $)
    syl3anr1 $p |- ( ( ch /\ ( ph /\ th /\ ta ) ) -> et ) $=
      ( w3a 3anim1i sylan2 ) ADEICBDEIFABDEGJHK $.
  $}

  ${
    syl3anr2.1 $e |- ( ph -> th ) $.
    syl3anr2.2 $e |- ( ( ch /\ ( ps /\ th /\ ta ) ) -> et ) $.
    $( A syllogism inference.  (Contributed by NM, 1-Aug-2007.)  (Proof
       shortened by Wolf Lammen, 27-Jun-2022.) $)
    syl3anr2 $p |- ( ( ch /\ ( ps /\ ph /\ ta ) ) -> et ) $=
      ( w3a 3anim2i sylan2 ) BAEICBDEIFADBEGJHK $.
  $}

  ${
    syl3anr3.1 $e |- ( ph -> ta ) $.
    syl3anr3.2 $e |- ( ( ch /\ ( ps /\ th /\ ta ) ) -> et ) $.
    $( A syllogism inference.  (Contributed by NM, 23-Aug-2007.) $)
    syl3anr3 $p |- ( ( ch /\ ( ps /\ th /\ ph ) ) -> et ) $=
      ( w3a 3anim3i sylan2 ) BDAICBDEIFAEBDGJHK $.
  $}

  ${
    3anidm12.1 $e |- ( ( ph /\ ph /\ ps ) -> ch ) $.
    $( Inference from idempotent law for conjunction.  (Contributed by NM,
       7-Mar-2008.) $)
    3anidm12 $p |- ( ( ph /\ ps ) -> ch ) $=
      ( 3expib anabsi5 ) ABCAABCDEF $.
  $}

  ${
    3anidm13.1 $e |- ( ( ph /\ ps /\ ph ) -> ch ) $.
    $( Inference from idempotent law for conjunction.  (Contributed by NM,
       7-Mar-2008.) $)
    3anidm13 $p |- ( ( ph /\ ps ) -> ch ) $=
      ( 3com23 3anidm12 ) ABCABACDEF $.
  $}

  ${
    3anidm23.1 $e |- ( ( ph /\ ps /\ ps ) -> ch ) $.
    $( Inference from idempotent law for conjunction.  (Contributed by NM,
       1-Feb-2007.) $)
    3anidm23 $p |- ( ( ph /\ ps ) -> ch ) $=
      ( 3expa anabss3 ) ABCABBCDEF $.
  $}

  ${
    syl2an3an.1 $e |- ( ph -> ps ) $.
    syl2an3an.2 $e |- ( ph -> ch ) $.
    syl2an3an.3 $e |- ( th -> ta ) $.
    syl2an3an.4 $e |- ( ( ps /\ ch /\ ta ) -> et ) $.
    $( ~ syl3an with antecedents in standard conjunction form.  (Contributed by
       Alan Sare, 31-Aug-2016.) $)
    syl2an3an $p |- ( ( ph /\ th ) -> et ) $=
      ( syl3an 3anidm12 ) ADFABACDEFGHIJKL $.
  $}

  ${
    syl2an23an.1 $e |- ( ph -> ps ) $.
    syl2an23an.2 $e |- ( ph -> ch ) $.
    syl2an23an.3 $e |- ( ( th /\ ph ) -> ta ) $.
    syl2an23an.4 $e |- ( ( ps /\ ch /\ ta ) -> et ) $.
    $( Deduction related to ~ syl3an with antecedents in standard conjunction
       form.  (Contributed by Alan Sare, 31-Aug-2016.)  (Proof shortened by
       Wolf Lammen, 28-Jun-2022.) $)
    syl2an23an $p |- ( ( th /\ ph ) -> et ) $=
      ( wa syl2an3an anabss7 ) DAFABCDAKEFGHIJLM $.
  $}

  ${
    3ori.1 $e |- ( ph \/ ps \/ ch ) $.
    $( Infer implication from triple disjunction.  (Contributed by NM,
       26-Sep-2006.) $)
    3ori $p |- ( ( -. ph /\ -. ps ) -> ch ) $=
      ( wn wa wo ioran w3o df-3or mpbi ori sylbir ) AEBEFABGZECABHNCABCINCGDABC
      JKLM $.
  $}

  $( Disjunction of three antecedents.  (Contributed by NM, 8-Apr-1994.) $)
  3jao $p |- ( ( ( ph -> ps ) /\ ( ch -> ps ) /\ ( th -> ps ) ) ->
              ( ( ph \/ ch \/ th ) -> ps ) ) $=
    ( wi w3o wo jao df-3or syl7bi syl6 3imp ) ABEZCBEZDBEZACDFZBEZMNACGZBEZOQEA
    BCHPRDGSOBACDIRBDHJKL $.

  $( Disjunction of three antecedents.  (Contributed by NM, 13-Sep-2011.)
     (Proof shortened by Hongxiu Chen, 29-Jun-2025.) $)
  3jaob $p |- ( ( ( ph \/ ch \/ th ) -> ps ) <->
              ( ( ph -> ps ) /\ ( ch -> ps ) /\ ( th -> ps ) ) ) $=
    ( wo wi wa w3o w3a pm5.53 df-3or imbi1i df-3an 3bitr4i ) ACEDEZBFABFZCBFZGD
    BFZGACDHZBFPQRIACDBJSOBACDKLPQRMN $.

  ${
    3jaoi.1 $e |- ( ph -> ps ) $.
    3jaoi.2 $e |- ( ch -> ps ) $.
    3jaoi.3 $e |- ( th -> ps ) $.
    $( Disjunction of three antecedents (inference).  (Contributed by NM,
       12-Sep-1995.)  (Proof shortened by Garrett Katz, 16-Jun-2026.) $)
    3jaoi $p |- ( ( ph \/ ch \/ th ) -> ps ) $=
      ( w3o wi 3jaob mpbir3an ) ACDHBIABICBIDBIEFGABCDJK $.

    $( Obsolete version of ~ 3jaoi as of 16-Jun-2026.  Disjunction of three
       antecedents (inference).  (Contributed by NM, 12-Sep-1995.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    3jaoiOLD $p |- ( ( ph \/ ch \/ th ) -> ps ) $=
      ( wi w3a w3o 3pm3.2i 3jao ax-mp ) ABHZCBHZDBHZIACDJBHNOPEFGKABCDLM $.
  $}

  ${
    3jaod.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3jaod.2 $e |- ( ph -> ( th -> ch ) ) $.
    3jaod.3 $e |- ( ph -> ( ta -> ch ) ) $.
    $( Disjunction of three antecedents (deduction).  (Contributed by NM,
       14-Oct-2005.) $)
    3jaod $p |- ( ph -> ( ( ps \/ th \/ ta ) -> ch ) ) $=
      ( wi w3o 3jao syl3anc ) ABCIDCIECIBDEJCIFGHBCDEKL $.
  $}

  ${
    3jaoian.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    3jaoian.2 $e |- ( ( th /\ ps ) -> ch ) $.
    3jaoian.3 $e |- ( ( ta /\ ps ) -> ch ) $.
    $( Disjunction of three antecedents (inference).  (Contributed by NM,
       14-Oct-2005.) $)
    3jaoian $p |- ( ( ( ph \/ th \/ ta ) /\ ps ) -> ch ) $=
      ( w3o wi ex 3jaoi imp ) ADEIBCABCJDEABCFKDBCGKEBCHKLM $.
  $}

  ${
    3jaodan.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    3jaodan.2 $e |- ( ( ph /\ th ) -> ch ) $.
    3jaodan.3 $e |- ( ( ph /\ ta ) -> ch ) $.
    $( Disjunction of three antecedents (deduction).  (Contributed by NM,
       14-Oct-2005.) $)
    3jaodan $p |- ( ( ph /\ ( ps \/ th \/ ta ) ) -> ch ) $=
      ( w3o ex 3jaod imp ) ABDEICABCDEABCFJADCGJAECHJKL $.
  $}

  ${
    mpjao3dan.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    mpjao3dan.2 $e |- ( ( ph /\ th ) -> ch ) $.
    mpjao3dan.3 $e |- ( ( ph /\ ta ) -> ch ) $.
    mpjao3dan.4 $e |- ( ph -> ( ps \/ th \/ ta ) ) $.
    $( Eliminate a three-way disjunction in a deduction.  (Contributed by
       Thierry Arnoux, 13-Apr-2018.)  (Proof shortened by Wolf Lammen,
       20-Apr-2024.) $)
    mpjao3dan $p |- ( ph -> ch ) $=
      ( w3o 3jaodan mpdan ) ABDEJCIABCDEFGHKL $.
  $}

  ${
    3jaao.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3jaao.2 $e |- ( th -> ( ta -> ch ) ) $.
    3jaao.3 $e |- ( et -> ( ze -> ch ) ) $.
    $( Inference conjoining and disjoining the antecedents of three
       implications.  (Contributed by Jeff Hankins, 15-Aug-2009.)  (Proof
       shortened by Andrew Salmon, 13-May-2011.)  (Proof shortened by Garrett
       Katz, 16-Jun-2026.) $)
    3jaao $p |- ( ( ph /\ th /\ et ) -> ( ( ps \/ ta \/ ze ) -> ch ) ) $=
      ( wi w3o 3jao syl3an ) ABCKDECKFGCKBEGLCKHIJBCEGMN $.

    $( Obsolete version of ~ 3jaao as of 16-Jun-2026.  Inference conjoining and
       disjoining the antecedents of three implications.  (Contributed by Jeff
       Hankins, 15-Aug-2009.)  (Proof shortened by Andrew Salmon, 13-May-2011.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    3jaaoOLD $p |- ( ( ph /\ th /\ et ) -> ( ( ps \/ ta \/ ze ) -> ch ) ) $=
      ( w3a wi 3ad2ant1 3ad2ant2 3ad2ant3 3jaod ) ADFKBCEGADBCLFHMDAECLFINFAGCL
      DJOP $.
  $}

  ${
    syl3an9b.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    syl3an9b.2 $e |- ( th -> ( ch <-> ta ) ) $.
    syl3an9b.3 $e |- ( et -> ( ta <-> ze ) ) $.
    $( Nested syllogism inference conjoining 3 dissimilar antecedents.
       (Contributed by NM, 1-May-1995.) $)
    syl3an9b $p |- ( ( ph /\ th /\ et ) -> ( ps <-> ze ) ) $=
      ( wb wa sylan9bb 3impa ) ADFBGKADLBEFGABCDEHIMJMN $.
  $}

  ${
    bi3d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bi3d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    bi3d.3 $e |- ( ph -> ( et <-> ze ) ) $.
    $( Deduction joining 3 equivalences to form equivalence of disjunctions.
       (Contributed by NM, 20-Apr-1994.) $)
    3orbi123d $p |- ( ph -> ( ( ps \/ th \/ et ) <-> ( ch \/ ta \/ ze ) ) ) $=
      ( wo w3o orbi12d df-3or 3bitr4g ) ABDKZFKCEKZGKBDFLCEGLAPQFGABCDEHIMJMBDF
      NCEGNO $.

    $( Deduction joining 3 equivalences to form equivalence of conjunctions.
       (Contributed by NM, 22-Apr-1994.) $)
    3anbi123d $p |- ( ph -> ( ( ps /\ th /\ et ) <-> ( ch /\ ta /\ ze ) ) ) $=
      ( wa w3a anbi12d df-3an 3bitr4g ) ABDKZFKCEKZGKBDFLCEGLAPQFGABCDEHIMJMBDF
      NCEGNO $.
  $}

  ${
    3anbi12d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3anbi12d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Deduction conjoining and adding a conjunct to equivalences.
       (Contributed by NM, 8-Sep-2006.) $)
    3anbi12d $p |- ( ph -> ( ( ps /\ th /\ et ) <-> ( ch /\ ta /\ et ) ) ) $=
      ( biidd 3anbi123d ) ABCDEFFGHAFIJ $.

    $( Deduction conjoining and adding a conjunct to equivalences.
       (Contributed by NM, 8-Sep-2006.) $)
    3anbi13d $p |- ( ph -> ( ( ps /\ et /\ th ) <-> ( ch /\ et /\ ta ) ) ) $=
      ( biidd 3anbi123d ) ABCFFDEGAFIHJ $.

    $( Deduction conjoining and adding a conjunct to equivalences.
       (Contributed by NM, 8-Sep-2006.) $)
    3anbi23d $p |- ( ph -> ( ( et /\ ps /\ th ) <-> ( et /\ ch /\ ta ) ) ) $=
      ( biidd 3anbi123d ) AFFBCDEAFIGHJ $.
  $}

  ${
    3anbi1d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduction adding conjuncts to an equivalence.  (Contributed by NM,
       8-Sep-2006.) $)
    3anbi1d $p |- ( ph -> ( ( ps /\ th /\ ta ) <-> ( ch /\ th /\ ta ) ) ) $=
      ( biidd 3anbi12d ) ABCDDEFADGH $.

    $( Deduction adding conjuncts to an equivalence.  (Contributed by NM,
       8-Sep-2006.) $)
    3anbi2d $p |- ( ph -> ( ( th /\ ps /\ ta ) <-> ( th /\ ch /\ ta ) ) ) $=
      ( biidd 3anbi12d ) ADDBCEADGFH $.

    $( Deduction adding conjuncts to an equivalence.  (Contributed by NM,
       8-Sep-2006.) $)
    3anbi3d $p |- ( ph -> ( ( th /\ ta /\ ps ) <-> ( th /\ ta /\ ch ) ) ) $=
      ( biidd 3anbi13d ) ADDBCEADGFH $.
  $}

  ${
    3anim123d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3anim123d.2 $e |- ( ph -> ( th -> ta ) ) $.
    3anim123d.3 $e |- ( ph -> ( et -> ze ) ) $.
    $( Deduction joining 3 implications to form implication of conjunctions.
       (Contributed by NM, 24-Feb-2005.) $)
    3anim123d $p |- ( ph -> ( ( ps /\ th /\ et ) -> ( ch /\ ta /\ ze ) ) ) $=
      ( wa w3a anim12d df-3an 3imtr4g ) ABDKZFKCEKZGKBDFLCEGLAPQFGABCDEHIMJMBDF
      NCEGNO $.

    $( Deduction joining 3 implications to form implication of disjunctions.
       (Contributed by NM, 4-Apr-1997.) $)
    3orim123d $p |- ( ph -> ( ( ps \/ th \/ et ) -> ( ch \/ ta \/ ze ) ) ) $=
      ( wo w3o orim12d df-3or 3imtr4g ) ABDKZFKCEKZGKBDFLCEGLAPQFGABCDEHIMJMBDF
      NCEGNO $.
  $}

  ${
    3orim123da.1 $e |- ( ph -> ( ps \/ th \/ et ) ) $.
    3orim123da.2 $e |- ( ( ph /\ ps ) -> ch ) $.
    3orim123da.3 $e |- ( ( ph /\ th ) -> ta ) $.
    3orim123da.4 $e |- ( ( ph /\ et ) -> ze ) $.
    $( Disjoin antecedents and consequents of three premises.  (Contributed by
       Thierry Arnoux, 13-Jul-2026.) $)
    3orim123da $p |- ( ph -> ( ch \/ ta \/ ze ) ) $=
      ( w3o ex 3orim123d mpd ) ABDFLCEGLHABCDEFGABCIMADEJMAFGKMNO $.
  $}

  $( Rearrangement of 6 conjuncts.  (Contributed by NM, 13-Mar-1995.) $)
  an6 $p |- ( ( ( ph /\ ps /\ ch ) /\ ( th /\ ta /\ et ) ) <->
              ( ( ph /\ th ) /\ ( ps /\ ta ) /\ ( ch /\ et ) ) ) $=
    ( wa w3a an4 bianbi df-3an anbi12i 3bitr4i ) ABGZCGZDEGZFGZGZADGZBEGZGZCFGZ
    GABCHZDEFHZGSTUBHRNPGUBUANCPFIABDEIJUCOUDQABCKDEFKLSTUBKM $.

  $( Analogue of ~ an4 for triple conjunction.  (Contributed by Scott Fenton,
     16-Mar-2011.)  (Proof shortened by Andrew Salmon, 25-May-2011.) $)
  3an6 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) /\ ( ta /\ et ) ) <->
                ( ( ph /\ ch /\ ta ) /\ ( ps /\ th /\ et ) ) ) $=
    ( w3a wa an6 bicomi ) ACEGBDFGHABHCDHEFHGACEBDFIJ $.

  $( Analogue of ~ or4 for triple conjunction.  (Contributed by Scott Fenton,
     16-Mar-2011.) $)
  3or6 $p |- ( ( ( ph \/ ps ) \/ ( ch \/ th ) \/ ( ta \/ et ) ) <->
                ( ( ph \/ ch \/ ta ) \/ ( ps \/ th \/ et ) ) ) $=
    ( wo w3o or4 orbi1i bitr2i df-3or orbi12i 3bitr4i ) ABGZCDGZGZEFGZGZACGZEGZ
    BDGZFGZGZOPRHACEHZBDFHZGUDTUBGZRGSTEUBFIUGQRACBDIJKOPRLUEUAUFUCACELBDFLMN
    $.

  ${
    mp3an1.1 $e |- ph $.
    mp3an1.2 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       21-Nov-1994.) $)
    mp3an1 $p |- ( ( ps /\ ch ) -> th ) $=
      ( wa 3expb mpan ) ABCGDEABCDFHI $.
  $}

  ${
    mp3an2.1 $e |- ps $.
    mp3an2.2 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       21-Nov-1994.) $)
    mp3an2 $p |- ( ( ph /\ ch ) -> th ) $=
      ( 3expa mpanl2 ) ABCDEABCDFGH $.
  $}

  ${
    mp3an3.1 $e |- ch $.
    mp3an3.2 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       21-Nov-1994.) $)
    mp3an3 $p |- ( ( ph /\ ps ) -> th ) $=
      ( wa 3expia mpi ) ABGCDEABCDFHI $.
  $}

  ${
    mp3an12.1 $e |- ph $.
    mp3an12.2 $e |- ps $.
    mp3an12.3 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       13-Jul-2005.) $)
    mp3an12 $p |- ( ch -> th ) $=
      ( mp3an1 mpan ) BCDFABCDEGHI $.
  $}

  ${
    mp3an13.1 $e |- ph $.
    mp3an13.2 $e |- ch $.
    mp3an13.3 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       14-Jul-2005.) $)
    mp3an13 $p |- ( ps -> th ) $=
      ( mp3an3 mpan ) ABDEABCDFGHI $.
  $}

  ${
    mp3an23.1 $e |- ps $.
    mp3an23.2 $e |- ch $.
    mp3an23.3 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       14-Jul-2005.) $)
    mp3an23 $p |- ( ph -> th ) $=
      ( mp3an3 mpan2 ) ABDEABCDFGHI $.
  $}

  ${
    mp3an1i.1 $e |- ps $.
    mp3an1i.2 $e |- ( ph -> ( ( ps /\ ch /\ th ) -> ta ) ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 5-Jul-2005.) $)
    mp3an1i $p |- ( ph -> ( ( ch /\ th ) -> ta ) ) $=
      ( wa wi w3a com12 mp3an1 ) CDHAEBCDAEIFABCDJEGKLK $.
  $}

  ${
    mp3anl1.1 $e |- ph $.
    mp3anl1.2 $e |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       24-Feb-2005.) $)
    mp3anl1 $p |- ( ( ( ps /\ ch ) /\ th ) -> ta ) $=
      ( wa wi w3a ex mp3an1 imp ) BCHDEABCDEIFABCJDEGKLM $.
  $}

  ${
    mp3anl2.1 $e |- ps $.
    mp3anl2.2 $e |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       24-Feb-2005.) $)
    mp3anl2 $p |- ( ( ( ph /\ ch ) /\ th ) -> ta ) $=
      ( wa wi w3a ex mp3an2 imp ) ACHDEABCDEIFABCJDEGKLM $.
  $}

  ${
    mp3anl3.1 $e |- ch $.
    mp3anl3.2 $e |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       24-Feb-2005.) $)
    mp3anl3 $p |- ( ( ( ph /\ ps ) /\ th ) -> ta ) $=
      ( wa wi w3a ex mp3an3 imp ) ABHDEABCDEIFABCJDEGKLM $.
  $}

  ${
    mp3anr1.1 $e |- ps $.
    mp3anr1.2 $e |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 4-Nov-2006.) $)
    mp3anr1 $p |- ( ( ph /\ ( ch /\ th ) ) -> ta ) $=
      ( wa w3a ancoms mp3anl1 ) CDHAEBCDAEFABCDIEGJKJ $.
  $}

  ${
    mp3anr2.1 $e |- ch $.
    mp3anr2.2 $e |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       24-Nov-2006.) $)
    mp3anr2 $p |- ( ( ph /\ ( ps /\ th ) ) -> ta ) $=
      ( wa w3a ancoms mp3anl2 ) BDHAEBCDAEFABCDIEGJKJ $.
  $}

  ${
    mp3anr3.1 $e |- th $.
    mp3anr3.2 $e |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       19-Oct-2007.) $)
    mp3anr3 $p |- ( ( ph /\ ( ps /\ ch ) ) -> ta ) $=
      ( wa w3a ancoms mp3anl3 ) BCHAEBCDAEFABCDIEGJKJ $.
  $}

  ${
    mp3an.1 $e |- ph $.
    mp3an.2 $e |- ps $.
    mp3an.3 $e |- ch $.
    mp3an.4 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       14-May-1999.) $)
    mp3an $p |- th $=
      ( mp3an1 mp2an ) BCDFGABCDEHIJ $.
  $}

  ${
    mpd3an3.2 $e |- ( ( ph /\ ps ) -> ch ) $.
    mpd3an3.3 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 8-Nov-2007.) $)
    mpd3an3 $p |- ( ( ph /\ ps ) -> th ) $=
      ( wa 3expa mpdan ) ABGCDEABCDFHI $.
  $}

  ${
    mpd3an23.1 $e |- ( ph -> ps ) $.
    mpd3an23.2 $e |- ( ph -> ch ) $.
    mpd3an23.3 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 4-Dec-2006.) $)
    mpd3an23 $p |- ( ph -> th ) $=
      ( id syl3anc ) AABCDAHEFGI $.
  $}

  ${
    mp3and.1 $e |- ( ph -> ps ) $.
    mp3and.2 $e |- ( ph -> ch ) $.
    mp3and.3 $e |- ( ph -> th ) $.
    mp3and.4 $e |- ( ph -> ( ( ps /\ ch /\ th ) -> ta ) ) $.
    $( A deduction based on modus ponens.  (Contributed by Mario Carneiro,
       24-Dec-2016.) $)
    mp3and $p |- ( ph -> ta ) $=
      ( w3a 3jca mpd ) ABCDJEABCDFGHKIL $.
  $}

  ${
    mp3an12i.1 $e |- ph $.
    mp3an12i.2 $e |- ps $.
    mp3an12i.3 $e |- ( ch -> th ) $.
    mp3an12i.4 $e |- ( ( ph /\ ps /\ th ) -> ta ) $.
    $( ~ mp3an with antecedents in standard conjunction form and with one
       hypothesis an implication.  (Contributed by Alan Sare, 28-Aug-2016.) $)
    mp3an12i $p |- ( ch -> ta ) $=
      ( mp3an12 syl ) CDEHABDEFGIJK $.
  $}

  ${
    mp3an2i.1 $e |- ph $.
    mp3an2i.2 $e |- ( ps -> ch ) $.
    mp3an2i.3 $e |- ( ps -> th ) $.
    mp3an2i.4 $e |- ( ( ph /\ ch /\ th ) -> ta ) $.
    $( ~ mp3an with antecedents in standard conjunction form and with two
       hypotheses which are implications.  (Contributed by Alan Sare,
       28-Aug-2016.) $)
    mp3an2i $p |- ( ps -> ta ) $=
      ( mp3an1 syl2anc ) BCDEGHACDEFIJK $.
  $}

  ${
    mp3an3an.1 $e |- ph $.
    mp3an3an.2 $e |- ( ps -> ch ) $.
    mp3an3an.3 $e |- ( th -> ta ) $.
    mp3an3an.4 $e |- ( ( ph /\ ch /\ ta ) -> et ) $.
    $( ~ mp3an with antecedents in standard conjunction form and with two
       hypotheses which are implications.  (Contributed by Alan Sare,
       28-Aug-2016.) $)
    mp3an3an $p |- ( ( ps /\ th ) -> et ) $=
      ( mp3an1 syl2an ) BCEFDHIACEFGJKL $.
  $}

  ${
    mp3an2ani.1 $e |- ph $.
    mp3an2ani.2 $e |- ( ps -> ch ) $.
    mp3an2ani.3 $e |- ( ( ps /\ th ) -> ta ) $.
    mp3an2ani.4 $e |- ( ( ph /\ ch /\ ta ) -> et ) $.
    $( An elimination deduction.  (Contributed by Alan Sare, 17-Oct-2017.) $)
    mp3an2ani $p |- ( ( ps /\ th ) -> et ) $=
      ( wa mp3an3an anabss5 ) BDFABCBDKEFGHIJLM $.
  $}

  ${
    biimp3a.1 $e |- ( ( ph /\ ps ) -> ( ch <-> th ) ) $.
    $( Infer implication from a logical equivalence.  Similar to ~ biimpa .
       (Contributed by NM, 4-Sep-2005.) $)
    biimp3a $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      ( wa biimpa 3impa ) ABCDABFCDEGH $.

    $( Infer implication from a logical equivalence.  Similar to ~ biimpar .
       (Contributed by NM, 2-Jan-2009.) $)
    biimp3ar $p |- ( ( ph /\ ps /\ th ) -> ch ) $=
      ( exbiri 3imp ) ABDCABCDEFG $.
  $}

  ${
    3anandis.1 $e |- ( ( ( ph /\ ps ) /\ ( ph /\ ch ) /\ ( ph /\ th ) )
                      -> ta ) $.
    $( Inference that undistributes a triple conjunction in the antecedent.
       (Contributed by NM, 18-Apr-2007.) $)
    3anandis $p |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $=
      ( w3a wa simpl simpr1 simpr2 simpr3 syl222anc ) ABCDGZHABACADEANIZABCDJOA
      BCDKOABCDLFM $.
  $}

  ${
    3anandirs.1 $e |- ( ( ( ph /\ th ) /\ ( ps /\ th ) /\ ( ch /\ th ) )
                      -> ta ) $.
    $( Inference that undistributes a triple conjunction in the antecedent.
       (Contributed by NM, 25-Jul-2006.) $)
    3anandirs $p |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $=
      ( w3a wa simpl1 simpr simpl2 simpl3 syl222anc ) ABCGZDHADBDCDEABCDINDJZAB
      CDKOABCDLOFM $.
  $}


  ${
    ecase13d.1 $e |- ( ph -> -. ch ) $.
    ecase13d.2 $e |- ( ph -> -. th ) $.
    ecase13d.3 $e |- ( ph -> ( ch \/ ps \/ th ) ) $.
    $( Deduction for elimination by cases.  (Contributed by Jeff Hankins,
       18-Aug-2009.) $)
    ecase13d $p |- ( ph -> ps ) $=
      ( wn wo w3o wi 3orass df-or bitri sylib mpd olcnd ) ABDACHZBDIZEACBDJZRSK
      ZGTCSIUACBDLCSMNOPFQ $.
  $}

  ${
    ecase23d.1 $e |- ( ph -> -. ch ) $.
    ecase23d.2 $e |- ( ph -> -. th ) $.
    ecase23d.3 $e |- ( ph -> ( ps \/ ch \/ th ) ) $.
    $( Deduction for elimination by cases.  (Contributed by NM,
       22-Apr-1994.) $)
    ecase23d $p |- ( ph -> ps ) $=
      ( wo w3o 3orass sylib wn ioran sylanbrc olcnd ) ABCDHZABCDIBPHGBCDJKACLDL
      PLEFCDMNO $.
  $}

  ${
    ecase33d.1 $e |- ( ph -> -. ps ) $.
    ecase33d.2 $e |- ( ph -> -. ch ) $.
    ecase33d.3 $e |- ( ph -> ( ps \/ ch \/ th ) ) $.
    $( Deduction for elimination by cases.  (Contributed by Thierry Arnoux,
       5-Jul-2026.) $)
    ecase33d $p |- ( ph -> th ) $=
      ( wo w3o df-3or sylib wn ioran sylanbrc orcnd ) ABCHZDABCDIPDHGBCDJKABLCL
      PLEFBCMNO $.
  $}

  ${
    3ecase.1 $e |- ( -. ph -> th ) $.
    3ecase.2 $e |- ( -. ps -> th ) $.
    3ecase.3 $e |- ( -. ch -> th ) $.
    3ecase.4 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( Inference for elimination by cases.  (Contributed by NM,
       13-Jul-2005.) $)
    3ecase $p |- th $=
      ( wi 3exp wn 2a1d pm2.61i pm2.61nii ) BCDABCDIIABCDHJAKDBCELMFGN $.
  $}

  ${
    3biorfd.1 $e |- ( ph -> -. th ) $.
    $( A disjunction is equivalent to a threefold disjunction with single
       falsehood, analogous to ~ biorf .  (Contributed by Alexander van der
       Vekens, 8-Sep-2017.) $)
    3bior1fd $p |- ( ph -> ( ( ch \/ ps ) <-> ( th \/ ch \/ ps ) ) ) $=
      ( wo w3o wn wb biorf syl 3orass bitr4di ) ACBFZDNFZDCBGADHNOIEDNJKDCBLM
      $.

    $( A disjunction is equivalent to a threefold disjunction with single
       falsehood of a conjunction.  (Contributed by Alexander van der Vekens,
       8-Sep-2017.) $)
    3bior1fand $p |- ( ph -> ( ( ch \/ ps )
                       <-> ( ( th /\ ta ) \/ ch \/ ps ) ) ) $=
      ( wa intnanrd 3bior1fd ) ABCDEGADEFHI $.

    3biorfd.2 $e |- ( ph -> -. ch ) $.
    $( A wff is equivalent to its threefold disjunction with double falsehood,
       analogous to ~ biorf .  (Contributed by Alexander van der Vekens,
       8-Sep-2017.) $)
    3bior2fd $p |- ( ph -> ( ps <-> ( th \/ ch \/ ps ) ) ) $=
      ( wo w3o wn wb biorf syl 3bior1fd bitrd ) ABCBGZDCBHACIBOJFCBKLABCDEMN $.
  $}

  ${
    3biantd.1 $e |- ( ph -> th ) $.
    $( A conjunction is equivalent to a threefold conjunction with single
       truth, analogous to ~ biantrud .  (Contributed by Alexander van der
       Vekens, 26-Sep-2017.) $)
    3biant1d $p |- ( ph -> ( ( ch /\ ps ) <-> ( th /\ ch /\ ps ) ) ) $=
      ( wa w3a biantrurd 3anass bitr4di ) ACBFZDKFDCBGADKEHDCBIJ $.
  $}

  ${
    intn3and.1 $e |- ( ph -> -. ps ) $.
    $( Introduction of a triple conjunct inside a contradiction.  (Contributed
       by FL, 27-Dec-2007.)  (Proof shortened by Andrew Salmon,
       26-Jun-2011.) $)
    intn3an1d $p |- ( ph -> -. ( ps /\ ch /\ th ) ) $=
      ( w3a simp1 nsyl ) ABBCDFEBCDGH $.

    $( Introduction of a triple conjunct inside a contradiction.  (Contributed
       by FL, 27-Dec-2007.)  (Proof shortened by Andrew Salmon,
       26-Jun-2011.) $)
    intn3an2d $p |- ( ph -> -. ( ch /\ ps /\ th ) ) $=
      ( w3a simp2 nsyl ) ABCBDFECBDGH $.

    $( Introduction of a triple conjunct inside a contradiction.  (Contributed
       by FL, 27-Dec-2007.)  (Proof shortened by Andrew Salmon,
       26-Jun-2011.) $)
    intn3an3d $p |- ( ph -> -. ( ch /\ th /\ ps ) ) $=
      ( w3a simp3 nsyl ) ABCDBFECDBGH $.
  $}

  $( Distribution of conjunction over threefold conjunction.  (Contributed by
     Thierry Arnoux, 8-Apr-2019.) $)
  an3andi $p |- ( ( ph /\ ( ps /\ ch /\ th ) ) <->
               ( ( ph /\ ps ) /\ ( ph /\ ch ) /\ ( ph /\ th ) ) ) $=
    ( wa w3a anandi bianbi df-3an anbi2i 3bitr4i ) ABCEZDEZEZABEZACEZEZADEZEABC
    DFZEOPRFNALERQALDGABCGHSMABCDIJOPRIK $.

  $( Rearrange a 9-fold conjunction.  (Contributed by Thierry Arnoux,
     14-Apr-2019.)  (Proof shortened by Wolf Lammen, 21-Apr-2024.) $)
  an33rean $p |- (
        ( ( ph /\ ps /\ ch ) /\ ( th /\ ta /\ et ) /\ ( ze /\ si /\ rh ) ) <->
    ( ( ph /\ ta /\ rh ) /\ ( ( ps /\ th ) /\ ( et /\ si ) /\ ( ch /\ ze ) ) )
    ) $=
    ( w3a wa 3anass 3anan12 3anrev bitri 3anbi123i anass anbi2i 3bitr4i df-3an
    3an6 an42 anbi1i 3bitr3i 3bitri ) ABCJZDEFJZGHIJZJABCKZKZEDFKZKZIHGKZKZJAEI
    JZUIUKUMJZKUOBDKZFHKZCGKZJZKUFUJUGULUHUNABCLDEFMUHIHGJUNGHINIHGLOPAUIEUKIUM
    UAUPUTUOUIUKKZUMKZUQURKZUSKZUPUTVAHKZGKVCCKZGKVBVDVEVFGUIUKHKZKZUQURCKKZVEV
    FVHUIDURKZKVIVGVJUIDFHQRBCDURUBOUIUKHQUQURCQSUCVAHGQVCCGQUDUIUKUMTUQURUSTSR
    UE $.

  $( Partial elimination of a triple disjunction by denial of a disjunct.
     (Contributed by Scott Fenton, 26-Mar-2011.)  (Proof shortened by Andrew
     Salmon, 25-May-2011.)  (Proof shortened by Eric Schmidt, 8-Oct-2025.) $)
  3orel2 $p |- ( -. ps -> ( ( ph \/ ps \/ ch ) -> ( ph \/ ch ) ) ) $=
    ( w3o wn wo 3orcoma 3orel1 biimtrid ) ABCDBACDBEACFABCGBACHI $.

  $( Obsolete version of ~ 3orel2 as of 8-Oct-2025.  (Contributed by Scott
     Fenton, 26-Mar-2011.)  (Proof shortened by Andrew Salmon, 25-May-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  3orel2OLD $p |- ( -. ps -> ( ( ph \/ ps \/ ch ) -> ( ph \/ ch ) ) ) $=
    ( w3o wn wo 3orrot 3orel1 orcom imbitrdi biimtrid ) ABCDBCADZBEZACFZABCGMLC
    AFNBCAHCAIJK $.

  $( Partial elimination of a triple disjunction by denial of a disjunct.
     (Contributed by Scott Fenton, 26-Mar-2011.) $)
  3orel3 $p |- ( -. ch -> ( ( ph \/ ps \/ ch ) -> ( ph \/ ps ) ) ) $=
    ( w3o wo wn df-3or orel2 biimtrid ) ABCDABEZCECFJABCGCJHI $.

  $( Elimination of two disjuncts in a triple disjunction.  (Contributed by
     Scott Fenton, 9-Jun-2011.) $)
  3orel13 $p |- ( ( -. ph /\ -. ch ) -> ( ( ph \/ ps \/ ch ) -> ps ) ) $=
    ( wn w3o wo 3orel3 orel1 sylan9r ) CDABCEABFADBABCGABHI $.

  ${
    3pm3.2ni.1 $e |- -. ph $.
    3pm3.2ni.2 $e |- -. ps $.
    3pm3.2ni.3 $e |- -. ch $.
    $( Triple negated disjunction introduction.  (Contributed by Scott Fenton,
       20-Apr-2011.) $)
    3pm3.2ni $p |- -. ( ph \/ ps \/ ch ) $=
      ( w3o wo pm3.2ni df-3or mtbir ) ABCGABHZCHLCABDEIFIABCJK $.
  $}

  ${
    an42ds.1 $e |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $.
    $( Inference exchanging the last antecedent with the second one.  See also
       ~ an32s .  (Contributed by Thierry Arnoux, 3-Jun-2025.) $)
    an42ds $p |- ( ( ( ( ph /\ th ) /\ ch ) /\ ps ) -> ta ) $=
      ( wa an32 anbi1i 3bitr3i sylbir ) ADGZCGBGZABGZCGDGZENDGZCGLBGZCGOMPQCABD
      HINDCHLBCHJFK $.
  $}


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical "nand" (Sheffer stroke)
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( Declare connective for alternative denial ("nand"). $)
  $c -/\ $.  $( Overlined "wedge" (read:  "nand") $)

  $( Extend wff definition to include alternative denial ("nand"). $)
  wnan $a wff ( ph -/\ ps ) $.

  $( Define incompatibility, or alternative denial ("not-and" or "nand").  See
     ~ dfnan2 for an alternative.  This is also called the Sheffer stroke,
     represented by a vertical bar, but we use a different symbol to avoid
     ambiguity with other uses of the vertical bar.  In the second edition of
     Principia Mathematica (1927), Russell and Whitehead used the Sheffer
     stroke and suggested it as a replacement for the "or" and "not" operations
     of the first edition.  However, in practice, "or" and "not" are more
     widely used.  After we define the constant true ` T. ` ( ~ df-tru ) and
     the constant false ` F. ` ( ~ df-fal ), we will be able to prove these
     truth table values: ` ( ( T. -/\ T. ) <-> F. ) ` ( ~ trunantru ),
     ` ( ( T. -/\ F. ) <-> T. ) ` ( ~ trunanfal ), ` ( ( F. -/\ T. ) <-> T. ) `
     ( ~ falnantru ), and ` ( ( F. -/\ F. ) <-> T. ) ` ( ~ falnanfal ).
     Contrast with ` /\ ` ( ~ df-an ), ` \/ ` ( ~ df-or ), ` -> ` ( ~ wi ), and
     ` \/_ ` ( ~ df-xor ).  (Contributed by Jeff Hoffman, 19-Nov-2007.) $)
  df-nan $a |- ( ( ph -/\ ps ) <-> -. ( ph /\ ps ) ) $.

  $( Conjunction in terms of alternative denial.  (Contributed by Mario
     Carneiro, 9-May-2015.) $)
  nanan $p |- ( ( ph /\ ps ) <-> -. ( ph -/\ ps ) ) $=
    ( wnan wa df-nan con2bii ) ABCABDABEF $.

  $( Alternative denial in terms of our primitive connectives (implication and
     negation).  (Contributed by WL, 26-Jun-2020.) $)
  dfnan2 $p |- ( ( ph -/\ ps ) <-> ( ph -> -. ps ) ) $=
    ( wnan wa wn wi df-nan imnan bitr4i ) ABCABDEABEFABGABHI $.

  $( Alternative denial in terms of disjunction and negation.  This explains
     the name "alternative denial".  (Contributed by BJ, 19-Oct-2022.) $)
  nanor $p |- ( ( ph -/\ ps ) <-> ( -. ph \/ -. ps ) ) $=
    ( wnan wa wn wo df-nan ianor bitri ) ABCABDEAEBEFABGABHI $.

  $( Alternative denial is commutative.  Remark: alternative denial is not
     associative, see ~ nanass .  (Contributed by Mario Carneiro, 9-May-2015.)
     (Proof shortened by Wolf Lammen, 26-Jun-2020.) $)
  nancom $p |- ( ( ph -/\ ps ) <-> ( ps -/\ ph ) ) $=
    ( wn wi wnan con2b dfnan2 3bitr4i ) ABCDBACDABEBAEABFABGBAGH $.

  $( Nested alternative denials.  (Contributed by Jeff Hoffman, 19-Nov-2007.)
     (Proof shortened by Wolf Lammen, 26-Jun-2020.) $)
  nannan $p |- ( ( ph -/\ ( ps -/\ ch ) ) <-> ( ph -> ( ps /\ ch ) ) ) $=
    ( wnan wn wi wa dfnan2 nanan imbi2i bitr4i ) ABCDZDALEZFABCGZFALHNMABCIJK
    $.

  $( Implication in terms of alternative denial.  (Contributed by Jeff Hoffman,
     19-Nov-2007.) $)
  nanim $p |- ( ( ph -> ps ) <-> ( ph -/\ ( ps -/\ ps ) ) ) $=
    ( wnan wa wi nannan anidmdbi bitr2i ) ABBCCABBDEABEABBFABGH $.

  $( Negation in terms of alternative denial.  (Contributed by Jeff Hoffman,
     19-Nov-2007.)  Use ~ dfnan2 .  (Revised by Wolf Lammen, 26-Jun-2020.) $)
  nannot $p |- ( -. ph <-> ( ph -/\ ph ) ) $=
    ( wnan wn wi dfnan2 pm4.8 bitr2i ) AABAACZDHAAEAFG $.

  $( Biconditional in terms of alternative denial.  (Contributed by Jeff
     Hoffman, 19-Nov-2007.)  (Proof shortened by Wolf Lammen, 27-Jun-2020.) $)
  nanbi $p |- ( ( ph <-> ps ) <->
          ( ( ph -/\ ps ) -/\ ( ( ph -/\ ph ) -/\ ( ps -/\ ps ) ) ) ) $=
    ( wb wnan wa wi wn dfbi3 df-nan bicomi nannot anbi12i imbi12i 3bitri nannan
    wo df-or bitr4i ) ABCZABDZAADZBBDZEZFZTUAUBDDSABEZAGZBGZEZPUEGZUHFUDABHUEUH
    QUITUHUCTUIABIJUFUAUGUBAKBKLMNTUAUBOR $.

  $( Introduce a right anti-conjunct to both sides of a logical equivalence.
     (Contributed by Anthony Hart, 1-Sep-2011.)  (Proof shortened by Wolf
     Lammen, 27-Jun-2020.) $)
  nanbi1 $p |- ( ( ph <-> ps ) -> ( ( ph -/\ ch ) <-> ( ps -/\ ch ) ) ) $=
    ( wb wn wi wnan imbi1 dfnan2 3bitr4g ) ABDACEZFBKFACGBCGABKHACIBCIJ $.

  $( Introduce a left anti-conjunct to both sides of a logical equivalence.
     (Contributed by Anthony Hart, 1-Sep-2011.)  (Proof shortened by SF,
     2-Jan-2018.) $)
  nanbi2 $p |- ( ( ph <-> ps ) -> ( ( ch -/\ ph ) <-> ( ch -/\ ps ) ) ) $=
    ( wb wnan nanbi1 nancom 3bitr4g ) ABDACEBCECAECBEABCFCAGCBGH $.

  $( Join two logical equivalences with anti-conjunction.  (Contributed by SF,
     2-Jan-2018.) $)
  nanbi12 $p |- ( ( ( ph <-> ps ) /\ ( ch <-> th ) ) ->
                                       ( ( ph -/\ ch ) <-> ( ps -/\ th ) ) ) $=
    ( wb wnan nanbi1 nanbi2 sylan9bb ) ABEACFBCFCDEBDFABCGCDBHI $.

  ${
    nanbii.1 $e |- ( ph <-> ps ) $.
    $( Introduce a right anti-conjunct to both sides of a logical equivalence.
       (Contributed by SF, 2-Jan-2018.) $)
    nanbi1i $p |- ( ( ph -/\ ch ) <-> ( ps -/\ ch ) ) $=
      ( wb wnan nanbi1 ax-mp ) ABEACFBCFEDABCGH $.

    $( Introduce a left anti-conjunct to both sides of a logical equivalence.
       (Contributed by SF, 2-Jan-2018.) $)
    nanbi2i $p |- ( ( ch -/\ ph ) <-> ( ch -/\ ps ) ) $=
      ( wb wnan nanbi2 ax-mp ) ABECAFCBFEDABCGH $.

    nanbi12i.2 $e |- ( ch <-> th ) $.
    $( Join two logical equivalences with anti-conjunction.  (Contributed by
       SF, 2-Jan-2018.) $)
    nanbi12i $p |- ( ( ph -/\ ch ) <-> ( ps -/\ th ) ) $=
      ( wb wnan nanbi12 mp2an ) ABGCDGACHBDHGEFABCDIJ $.
  $}

  ${
    nanbid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Introduce a right anti-conjunct to both sides of a logical equivalence.
       (Contributed by SF, 2-Jan-2018.) $)
    nanbi1d $p |- ( ph -> ( ( ps -/\ th ) <-> ( ch -/\ th ) ) ) $=
      ( wb wnan nanbi1 syl ) ABCFBDGCDGFEBCDHI $.

    $( Introduce a left anti-conjunct to both sides of a logical equivalence.
       (Contributed by SF, 2-Jan-2018.) $)
    nanbi2d $p |- ( ph -> ( ( th -/\ ps ) <-> ( th -/\ ch ) ) ) $=
      ( wb wnan nanbi2 syl ) ABCFDBGDCGFEBCDHI $.

    nanbi12d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Join two logical equivalences with anti-conjunction.  (Contributed by
       Scott Fenton, 2-Jan-2018.) $)
    nanbi12d $p |- ( ph -> ( ( ps -/\ th ) <-> ( ch -/\ ta ) ) ) $=
      ( wb wnan nanbi12 syl2anc ) ABCHDEHBDICEIHFGBCDEJK $.
  $}

  $( A characterization of when an expression involving alternative denials
     associates.  Remark: alternative denial is commutative, see ~ nancom .
     (Contributed by Richard Penner, 29-Feb-2020.)  (Proof shortened by Wolf
     Lammen, 23-Oct-2022.) $)
  nanass $p |- ( ( ph <-> ch ) <->
                 ( ( ( ph -/\ ps ) -/\ ch ) <-> ( ph -/\ ( ps -/\ ch ) ) ) ) $=
    ( wb bicom1 nanbi2 nanbi12d wa wi nannan simpr imim2i sylbi wn nanan sylbir
    wnan simpl nancom bitri impbid21d pm5.1im syl2imc impbii nanbi2i bibi1i
    bija ) ACDZCBAQZQZABCQZQZDZABQZCQZULDUHUMUHCAUIUKACEACBFGUJULUHUJULACULABCH
    ZIACIABCJUPCABCKLMUJCBAHZICAICBAJUQACBAKLMUAULNZAUJNZCUHURAUKHAAUKOAUKRPUSC
    UIHCCUIOCUIRPACUBUCUGUDUJUOULUJCUNQUOUIUNCBASUECUNSTUFT $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical "xor"
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( Declare connective for exclusive disjunction ("xor"). $)
  $c \/_ $.  $( Underlined "vee" (read:  "xor") $)

  $( Extend wff definition to include exclusive disjunction ("xor"). $)
  wxo $a wff ( ph \/_ ps ) $.

  $( Define exclusive disjunction (logical "xor").  Return true if either the
     left or right, but not both, are true.  After we define the constant true
     ` T. ` ( ~ df-tru ) and the constant false ` F. ` ( ~ df-fal ), we will be
     able to prove these truth table values: ` ( ( T. \/_ T. ) <-> F. ) `
     ( ~ truxortru ), ` ( ( T. \/_ F. ) <-> T. ) ` ( ~ truxorfal ),
     ` ( ( F. \/_ T. ) <-> T. ) ` ( ~ falxortru ), and
     ` ( ( F. \/_ F. ) <-> F. ) ` ( ~ falxorfal ).  Contrast with ` /\ `
     ( ~ df-an ), ` \/ ` ( ~ df-or ), ` -> ` ( ~ wi ), and ` -/\ `
     ( ~ df-nan ).  (Contributed by FL, 22-Nov-2010.) $)
  df-xor $a |- ( ( ph \/_ ps ) <-> -. ( ph <-> ps ) ) $.

  $( Two ways to write XNOR (exclusive not-or).  (Contributed by Mario
     Carneiro, 4-Sep-2016.) $)
  xnor $p |- ( ( ph <-> ps ) <-> -. ( ph \/_ ps ) ) $=
    ( wxo wb df-xor con2bii ) ABCABDABEF $.

  $( The connector ` \/_ ` is commutative.  (Contributed by Mario Carneiro,
     4-Sep-2016.)  (Proof shortened by Wolf Lammen, 21-Apr-2024.) $)
  xorcom $p |- ( ( ph \/_ ps ) <-> ( ps \/_ ph ) ) $=
    ( wxo wb wn df-xor bicom xchbinx bitr4i ) ABCZBADZEBACJABDKABFABGHBAFI $.

  $( The connector ` \/_ ` is associative.  (Contributed by FL, 22-Nov-2010.)
     (Proof shortened by Andrew Salmon, 8-Jun-2011.)  (Proof shortened by Wolf
     Lammen, 20-Jun-2020.) $)
  xorass $p |- ( ( ( ph \/_ ps ) \/_ ch ) <-> ( ph \/_ ( ps \/_ ch ) ) ) $=
    ( wxo wb xor3 biass xnor bibi1i bibi2i 3bitr3i nbbn 3bitr2ri df-xor 3bitr4i
    wn ) ABDZCEPZABCDZEPZQCDASDTASPZEZQPZCEZRASFABEZCEABCEZEUDUBABCGUEUCCABHIUF
    UAABCHJKQCLMQCNASNO $.

  $( This tautology shows that xor is really exclusive.  (Contributed by FL,
     22-Nov-2010.) $)
  excxor $p |- ( ( ph \/_ ps ) <-> ( ( ph /\ -. ps ) \/ ( -. ph /\ ps ) ) ) $=
    ( wxo wb wn wa wo df-xor xor ancom orbi2i 3bitri ) ABCABDEABEFZBAEZFZGMNBFZ
    GABHABIOPMBNJKL $.

  $( Two ways to express "exclusive or".  (Contributed by Mario Carneiro,
     4-Sep-2016.) $)
  xor2 $p |- ( ( ph \/_ ps ) <-> ( ( ph \/ ps ) /\ -. ( ph /\ ps ) ) ) $=
    ( wxo wb wn wo wa df-xor nbi2 bitri ) ABCABDEABFABGEGABHABIJ $.

  $( Exclusive disjunction implies disjunction ("XOR implies OR").
     (Contributed by BJ, 19-Apr-2019.) $)
  xoror $p |- ( ( ph \/_ ps ) -> ( ph \/ ps ) ) $=
    ( wxo wo wa wn xor2 simplbi ) ABCABDABEFABGH $.

  $( Exclusive disjunction implies alternative denial ("XOR implies NAND").
     (Contributed by BJ, 19-Apr-2019.) $)
  xornan $p |- ( ( ph \/_ ps ) -> -. ( ph /\ ps ) ) $=
    ( wxo wo wa wn xor2 simprbi ) ABCABDABEFABGH $.

  $( XOR implies NAND (written with the ` -/\ ` connector).  (Contributed by
     BJ, 19-Apr-2019.) $)
  xornan2 $p |- ( ( ph \/_ ps ) -> ( ph -/\ ps ) ) $=
    ( wxo wa wn wnan xornan df-nan sylibr ) ABCABDEABFABGABHI $.

  $( The connector ` \/_ ` is negated under negation of one argument.
     (Contributed by Mario Carneiro, 4-Sep-2016.)  (Proof shortened by Wolf
     Lammen, 27-Jun-2020.) $)
  xorneg2 $p |- ( ( ph \/_ -. ps ) <-> -. ( ph \/_ ps ) ) $=
    ( wn wxo wb df-xor pm5.18 xnor 3bitr2i ) ABCZDAJECABEABDCAJFABGABHI $.

  $( The connector ` \/_ ` is negated under negation of one argument.
     (Contributed by Mario Carneiro, 4-Sep-2016.)  (Proof shortened by Wolf
     Lammen, 27-Jun-2020.) $)
  xorneg1 $p |- ( ( -. ph \/_ ps ) <-> -. ( ph \/_ ps ) ) $=
    ( wn wxo xorcom xorneg2 xchbinx bitri ) ACZBDBIDZABDZCIBEJBADKBAFBAEGH $.

  $( The connector ` \/_ ` is unchanged under negation of both arguments.
     (Contributed by Mario Carneiro, 4-Sep-2016.) $)
  xorneg $p |- ( ( -. ph \/_ -. ps ) <-> ( ph \/_ ps ) ) $=
    ( wn wxo xorneg1 xorneg2 con2bii bitr4i ) ACBCZDAIDZCABDZAIEJKABFGH $.

  ${
    xorbi12.1 $e |- ( ph <-> ps ) $.
    xorbi12.2 $e |- ( ch <-> th ) $.
    $( Equality property for exclusive disjunction.  (Contributed by Mario
       Carneiro, 4-Sep-2016.)  (Proof shortened by Wolf Lammen,
       21-Apr-2024.) $)
    xorbi12i $p |- ( ( ph \/_ ch ) <-> ( ps \/_ th ) ) $=
      ( wxo wb wn df-xor bibi12i xchbinx bitr4i ) ACGZBDHZIBDGNACHOACJABCDEFKLB
      DJM $.
  $}

  ${
    xor12d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    xor12d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Equality property for exclusive disjunction.  (Contributed by Mario
       Carneiro, 4-Sep-2016.) $)
    xorbi12d $p |- ( ph -> ( ( ps \/_ th ) <-> ( ch \/_ ta ) ) ) $=
      ( wb wn wxo bibi12d notbid df-xor 3bitr4g ) ABDHZICEHZIBDJCEJAOPABCDEFGKL
      BDMCEMN $.
  $}

  $( Conjunction distributes over exclusive-or.  In intuitionistic logic this
     assertion is also true, even though ~ xordi does not necessarily hold, in
     part because the usual definition of xor is subtly different in
     intuitionistic logic.  (Contributed by David A. Wheeler, 7-Oct-2018.) $)
  anxordi $p |- ( ( ph /\ ( ps \/_ ch ) ) <->
      ( ( ph /\ ps ) \/_ ( ph /\ ch ) ) ) $=
    ( wb wn wa wxo xordi df-xor anbi2i 3bitr4i ) ABCDEZFABFZACFZDEABCGZFMNGABCH
    OLABCIJMNIK $.

  $( Exclusive-or variant of the law of the excluded middle ( ~ exmid ).  This
     statement is ancient, going back to at least Stoic logic.  This statement
     does not necessarily hold in intuitionistic logic.  (Contributed by David
     A. Wheeler, 23-Feb-2019.) $)
  xorexmid $p |- ( ph \/_ -. ph ) $=
    ( wn wxo wb pm5.19 df-xor mpbir ) AABZCAHDBAEAHFG $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical "nor"
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( Declare connective for joint denial ("nor"). $)
  $c -\/ $.  $( Overlined "vee" (read:  "nor") $)

  $( Extend wff definition to include joint denial ("nor"). $)
  wnor $a wff ( ph -\/ ps ) $.

  $( Define joint denial ("not-or" or "nor").  After we define the constant
     true ` T. ` ( ~ df-tru ) and the constant false ` F. ` ( ~ df-fal ), we
     will be able to prove these truth table values:
     ` ( ( T. -\/ T. ) <-> F. ) ` ( ~ trunortru ), ` ( ( T. -\/ F. ) <-> F. ) `
     ( ~ trunorfal ), ` ( ( F. -\/ T. ) <-> F. ) ` ( ~ falnortru ), and
     ` ( ( F. -\/ F. ) <-> T. ) ` ( ~ falnorfal ).  Contrast with ` /\ `
     ( ~ df-an ), ` \/ ` ( ~ df-or ), ` -> ` ( ~ wi ), ` -/\ ` ( ~ df-nan ),
     and ` \/_ ` ( ~ df-xor ).  (Contributed by Remi, 25-Oct-2023.) $)
  df-nor $a |- ( ( ph -\/ ps ) <-> -. ( ph \/ ps ) ) $.

  $( The connector ` -\/ ` is commutative.  (Contributed by Remi, 25-Oct-2023.)
     (Proof shortened by Wolf Lammen, 23-Apr-2024.) $)
  norcom $p |- ( ( ph -\/ ps ) <-> ( ps -\/ ph ) ) $=
    ( wnor wo wn df-nor orcom xchbinx bitr4i ) ABCZBADZEBACJABDKABFABGHBAFI $.

  $( ` -. ` is expressible via ` -\/ ` .  (Contributed by Remi, 25-Oct-2023.)
     (Proof shortened by Wolf Lammen, 8-Dec-2023.) $)
  nornot $p |- ( -. ph <-> ( ph -\/ ph ) ) $=
    ( wnor wn wo df-nor oridm xchbinx bicomi ) AABZACIAADAAAEAFGH $.

  $( ` /\ ` is expressible via ` -\/ ` .  (Contributed by Remi, 26-Oct-2023.)
     (Proof shortened by Wolf Lammen, 8-Dec-2023.) $)
  noran $p |- ( ( ph /\ ps ) <-> ( ( ph -\/ ph ) -\/ ( ps -\/ ps ) ) ) $=
    ( wa wnor wo wn anor nornot orbi12i xchbinx df-nor bitr4i ) ABCZAADZBBDZEZF
    NODMAFZBFZEPABGQNROAHBHIJNOKL $.

  $( ` \/ ` is expressible via ` -\/ ` .  (Contributed by Remi, 26-Oct-2023.)
     (Proof shortened by Wolf Lammen, 8-Dec-2023.) $)
  noror $p |- ( ( ph \/ ps ) <-> ( ( ph -\/ ps ) -\/ ( ph -\/ ps ) ) ) $=
    ( wo wnor wn df-nor con2bii nornot bitri ) ABCZABDZEKKDKJABFGKHI $.

  $( This lemma shows the equivalence of two expressions, used in ~ norass .
     (Contributed by Wolf Lammen, 18-Dec-2023.) $)
  norasslem1 $p |- ( ( ( ph \/ ps ) -> ch ) <-> ( ( ph -\/ ps ) \/ ch ) ) $=
    ( wo wi wn wnor imor df-nor orbi1i bitr4i ) ABDZCELFZCDABGZCDLCHNMCABIJK $.

  $( This lemma specializes ~ biimt suitably for the proof of ~ norass .
     (Contributed by Wolf Lammen, 18-Dec-2023.) $)
  norasslem2 $p |- ( ph -> ( ps <-> ( ( ph \/ ch ) -> ps ) ) ) $=
    ( wo wi wb biimt orcs ) ACBACDZBEFIBGH $.

  $( This lemma specializes ~ biorf suitably for the proof of ~ norass .
     (Contributed by Wolf Lammen, 18-Dec-2023.) $)
  norasslem3 $p |- ( -. ph -> ( ( ps -> ch ) <-> ( ( ph \/ ps ) -> ch ) ) ) $=
    ( wn wo biorf imbi1d ) ADBABECABFG $.

  $( A characterization of when an expression involving joint denials
     associates.  This is identical to the case when alternative denial is
     associative, see ~ nanass .  Remark:  Like alternative denial, joint
     denial is also commutative, see ~ norcom .  (Contributed by RP,
     29-Oct-2023.)  (Proof shortened by Wolf Lammen, 17-Dec-2023.) $)
  norass $p |- ( ( ph <-> ch ) <->
                 ( ( ( ph -\/ ps ) -\/ ch ) <-> ( ph -\/ ( ps -\/ ch ) ) ) ) $=
    ( wnor wo wb wn notbi wi norasslem1 bibi12i bicom norasslem2 bibi12d bitrid
    impimprbi norasslem3 pm2.61i 3bitr4i df-nor norcom orbi1i orcom ) ABDZCEZAB
    CDZEZFZUEGZUGGZFACFZUDCDZAUFDZFUEUGHBAECIZBCEAIZFZBADZCEZUFAEZFUKUHUNURUOUS
    BACJBCAJKBUKUPFUKCAFBUPACLBCUNAUOBCAMBACMNOUKACIZCAIZFBGZUPACPVBUTUNVAUOBAC
    QBCAQNORUEURUGUSUDUQCABUAUBAUFUCKSULUIUMUJUDCTAUFTKS $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  True and false constants
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  Universal quantifier for use by df-tru
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  Even though it is not ordinarily part of propositional calculus, the
  universal quantifier ` A. ` is introduced here so that the soundness of
  Definition ~ df-tru can be checked by the same algorithm that is used for
  predicate calculus.  Its first real use is in Definition ~ df-ex in the
  predicate calculus section below.  For those who want propositional calculus
  to be self-contained, i.e., to use wff variables only, the alternate
  Definition ~ dftru2 may be adopted and this subsection moved down to the
  start of the subsection with ~ wex below.  However, the use of ~ dftru2 as a
  definition requires a more elaborate definition checking algorithm that we
  prefer to avoid.

$)

  $( Declare new symbols needed for predicate calculus. $)
  $c A. $.  $( "inverted A" universal quantifier (read:  "for all") $)
  $c setvar $.  $( Individual variable type (read:  "the following is an
                   individual (set) variable") $)

  $( Add 'setvar' as a typecode for bound variables. $)
  $( $j syntax 'setvar'; bound 'setvar'; $)

  $( Declare the color of setvar variables. $)
  $( $j
    varcolorcode "setvar" as "FF0000";
    altvarcolorcode "setvar" as "FF0000";
  $)

  ${
    $v x $.
    $( Let ` x ` be an individual variable (temporary declaration). $)
    vx.wal $f setvar x $.
    $( Extend wff definition to include the universal quantifier ("for all").
       ` A. x ph ` is read " ` ph ` (phi) is true for all ` x ` ".  Typically,
       in its final application ` ph ` would be replaced with a wff containing
       a (free) occurrence of the variable ` x ` , for example ` x = y ` .  In
       a universe with a finite number of objects, "for all" is equivalent to a
       big conjunction (AND) with one wff for each possible case of ` x ` .
       When the universe is infinite (as with set theory), such a
       propositional-calculus equivalent is not possible because an infinitely
       long formula has no meaning, but conceptually the idea is the same. $)
    wal $a wff A. x ph $.

    $( Register the universal quantifier 'A.' as a primitive expression
       (lacking a definition). $)
    $( $j primitive 'wal'; $)
  $}


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  Equality predicate for use by df-tru
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  Even though it is not ordinarily part of propositional calculus, the equality
  predicate ` = ` is introduced here so that the soundness of definition
  ~ df-tru can be checked by the same algorithm as is used for predicate
  calculus.  Its first real use is in Theorem ~ weq in the predicate calculus
  section below.  For those who want propositional calculus to be
  self-contained, i.e., to use wff variables only, the alternate definition
  ~ dftru2 may be adopted and this subsection moved down to just above ~ weq
  below.  However, the use of ~ dftru2 as a definition requires a more
  elaborate definition checking algorithm that we prefer to avoid.

$)

  $c class $.

  $( Add 'class' as a typecode. $)
  $( $j syntax 'class'; $)

  $( Declare the color of class variables. $)
  $( $j
    varcolorcode "class" as "CC33CC";
    altvarcolorcode "class" as "CC33CC";
  $)

  ${
    $v x $.
    $( Let ` x ` be an individual variable (temporary declaration). $)
    vx.cv $f setvar x $.
    $( This syntax construction states that a variable ` x ` , which has been
       declared to be a setvar variable by $f statement vx, is also a class
       expression.  This can be justified informally as follows.  We know that
       the class builder ` { y | y e. x } ` is a class by ~ cab .  Since (when
       ` y ` is distinct from ` x ` ) we have ` x = { y | y e. x } ` by
       ~ cvjust , we can argue that the syntax " ` class x ` " can be viewed as
       an abbreviation for " ` class { y | y e. x } ` ".  See the discussion
       under the definition of class in [Jech] p. 4 showing that "Every set can
       be considered to be a class".

       While it is tempting and perhaps occasionally useful to view ~ cv as a
       "type conversion" from a setvar variable to a class variable, keep in
       mind that ~ cv is intrinsically no different from any other
       class-building syntax such as ~ cab , ~ cun , or ~ c0 .

       For a general discussion of the theory of classes and the role of ~ cv ,
       see ~ mmset.html#class .

       (The description above applies to set theory, not predicate calculus.
       The purpose of introducing ` class x ` here, and not in set theory where
       it belongs, is to allow to express, i.e., "prove", the ~ weq of
       predicate calculus from the ~ wceq of set theory, so that we do not
       overload the ` = ` connective with two syntax definitions.  This is done
       to prevent ambiguity that would complicate some Metamath parsers.) $)
    cv $a class x $.

    $( Register set-to-class promotion as a primitive expression (lacking a
       definition). $)
    $( $j primitive 'cv'; $)
  $}

  $( Declare the equality predicate symbol. $)
  $c = $.  $( Equal sign (read:  'is equal to') $)

  ${
    $v A $.
    $v B $.
    $( Temporary declarations of ` A ` and ` B ` . $)
    cA.wceq $f class A $.
    cB.wceq $f class B $.
    $( Extend wff definition to include class equality.

       For a general discussion of the theory of classes, see
       ~ mmset.html#class .

       (The purpose of introducing ` wff A = B ` here, and not in set theory
       where it belongs, is to allow to express, i.e., "prove", the ~ weq of
       predicate calculus in terms of the ~ wceq of set theory, so that we do
       not "overload" the ` = ` connective with two syntax definitions.  This
       is done to prevent ambiguity that would complicate some Metamath
       parsers.  For example, some parsers - although not the Metamath program
       - stumble on the fact that the ` = ` in ` x = y ` could be the ` = ` of
       either ~ weq or ~ wceq , although mathematically it makes no difference.
       The class variables ` A ` and ` B ` are introduced temporarily for the
       purpose of this definition but otherwise not used in predicate calculus.
       See ~ df-cleq for more information on the set theory usage of
       ~ wceq .) $)
    wceq $a wff A = B $.

    $( Register class equality as a primitive expression (lacking a
       definition). $)
    $( $j primitive 'wceq'; $)
  $}


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  The true constant
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
$)

  $c T. $.  $( Symbol for the true constant. $)

  $( The constant ` T. ` is a wff. $)
  wtru $a wff T. $.

  ${
    $v x $.
    $v y $.
    $( Temporary declarations of ` x ` and ` y ` for local use by ~ df-tru .
       These will be redeclared globally in the predicate calculus section. $)
    vx.tru $f setvar x $.
    vy.tru $f setvar y $.
    $( Soundness justification theorem for ~ df-tru .  Instance of
       ~ monothetic .  (Contributed by Mario Carneiro, 17-Nov-2013.)  (Revised
       by NM, 11-Jul-2019.) $)
    trujust $p |- ( ( A. x x = x -> A. x x = x )
                <-> ( A. y y = y -> A. y y = y ) ) $=
      ( cv wceq wal monothetic ) ACZGDAEBCZHDBEF $.

    $( Definition of the truth value "true", or "verum", denoted by ` T. ` .
       In this definition, an instance of ~ id is used as the definiens,
       although any tautology, such as an axiom, can be used in its place.
       This particular instance of ~ id was chosen so this definition can be
       checked by the same algorithm that is used for predicate calculus.  This
       definition should be referenced directly only by ~ tru , and other
       proofs should use ~ tru instead of this definition, since there are many
       alternate ways to define ` T. ` .  (Contributed by Anthony Hart,
       13-Oct-2010.)  (Revised by NM, 11-Jul-2019.)  Use ~ tru instead.
       (New usage is discouraged.) $)
    df-tru $a |- ( T. <-> ( A. x x = x -> A. x x = x ) ) $.

    $( The truth value ` T. ` is provable.  (Contributed by Anthony Hart,
       13-Oct-2010.) $)
    tru $p |- T. $=
      ( vx.tru wtru cv wceq wal wi id df-tru mpbir ) BACZJDAEZKFKGAHI $.
  $}

  $( An alternate definition of "true" (see comment of ~ df-tru ).  The
     associated justification theorem is ~ monothetic .  (Contributed by
     Anthony Hart, 13-Oct-2010.)  (Revised by BJ, 12-Jul-2019.)  Use ~ tru
     instead.  (New usage is discouraged.) $)
  dftru2 $p |- ( T. <-> ( ph -> ph ) ) $=
    ( wtru wi tru id 2th ) BAACDAEF $.

  $( A proposition is equivalent to it being implied by ` T. ` .  Closed form
     of ~ mptru .  Dual of ~ dfnot .  It is to ~ tbtru what ~ a1bi is to
     ~ tbt .  (Contributed by BJ, 26-Oct-2019.) $)
  trut $p |- ( ph <-> ( T. -> ph ) ) $=
    ( wtru tru a1bi ) BACD $.

  ${
    mptru.1 $e |- ( T. -> ph ) $.
    $( Eliminate ` T. ` as an antecedent.  A proposition implied by ` T. ` is
       true.  This is modus ponens ~ ax-mp when the minor hypothesis is ` T. `
       (which holds by ~ tru ).  (Contributed by Mario Carneiro,
       13-Mar-2014.) $)
    mptru $p |- ph $=
      ( wtru tru ax-mp ) CADBE $.
  $}

  $( A proposition is equivalent to itself being equivalent to ` T. ` .
     (Contributed by Anthony Hart, 14-Aug-2011.) $)
  tbtru $p |- ( ph <-> ( ph <-> T. ) ) $=
    ( wtru tru tbt ) BACD $.

  ${
    bitru.1 $e |- ph $.
    $( A theorem is equivalent to truth.  (Contributed by Mario Carneiro,
       9-May-2015.) $)
    bitru $p |- ( ph <-> T. ) $=
      ( wtru tru 2th ) ACBDE $.
  $}

  $( Anything implies ` T. ` .  Dual statement of ~ falim .  Deduction form of
     ~ tru .  Note on naming: in 2022, the theorem now known as ~ mptru was
     renamed from trud so if you are reading documentation written before that
     time, references to trud refer to what is now ~ mptru .  (Contributed by
     FL, 20-Mar-2011.)  (Proof shortened by Anthony Hart, 1-Aug-2011.) $)
  trud $p |- ( ph -> T. ) $=
    ( wtru tru a1i ) BACD $.

  $( True can be removed from a conjunction.  (Contributed by FL, 20-Mar-2011.)
     (Proof shortened by Wolf Lammen, 21-Jul-2019.) $)
  truan $p |- ( ( T. /\ ph ) <-> ph ) $=
    ( wtru wa tru biantrur bicomi ) ABACBADEF $.


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  The false constant
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
$)

  $c F. $.  $( Symbol for the false constant. $)

  $( The constant ` F. ` is a wff. $)
  wfal $a wff F. $.

  $( Definition of the truth value "false", or "falsum", denoted by ` F. ` .
     See also ~ df-tru .  (Contributed by Anthony Hart, 22-Oct-2010.) $)
  df-fal $a |- ( F. <-> -. T. ) $.

  $( The truth value ` F. ` is refutable.  (Contributed by Anthony Hart,
     22-Oct-2010.)  (Proof shortened by Mel L. O'Cat, 11-Mar-2012.) $)
  fal $p |- -. F. $=
    ( wfal wtru wn tru notnoti df-fal mtbir ) ABCBDEFG $.

  $( The negation of a proposition is equivalent to itself being equivalent to
     ` F. ` .  (Contributed by Anthony Hart, 14-Aug-2011.) $)
  nbfal $p |- ( -. ph <-> ( ph <-> F. ) ) $=
    ( wfal fal nbn ) BACD $.

  ${
    bifal.1 $e |- -. ph $.
    $( A contradiction is equivalent to falsehood.  (Contributed by Mario
       Carneiro, 9-May-2015.) $)
    bifal $p |- ( ph <-> F. ) $=
      ( wfal fal 2false ) ACBDE $.
  $}

  $( The truth value ` F. ` implies anything.  Also called the "principle of
     explosion", or "ex falso [[sequitur]] quodlibet" (Latin for "from
     falsehood, anything [[follows]]").  Dual statement of ~ trud .
     (Contributed by FL, 20-Mar-2011.)  (Proof shortened by Anthony Hart,
     1-Aug-2011.) $)
  falim $p |- ( F. -> ph ) $=
    ( wfal fal pm2.21i ) BACD $.

  $( The truth value ` F. ` implies anything.  (Contributed by Mario Carneiro,
     9-Feb-2017.) $)
  falimd $p |- ( ( ph /\ F. ) -> ps ) $=
    ( wfal falim adantl ) CBABDE $.

  $( Given falsum ` F. ` , we can define the negation of a wff ` ph ` as the
     statement that ` F. ` follows from assuming ` ph ` .  (Contributed by
     Mario Carneiro, 9-Feb-2017.)  (Proof shortened by Wolf Lammen,
     21-Jul-2019.) $)
  dfnot $p |- ( -. ph <-> ( ph -> F. ) ) $=
    ( wfal wn wi wb fal mtt ax-mp ) BCACABDEFBAGH $.

  ${
    inegd.1 $e |- ( ( ph /\ ps ) -> F. ) $.
    $( Negation introduction rule from natural deduction.  (Contributed by
       Mario Carneiro, 9-Feb-2017.) $)
    inegd $p |- ( ph -> -. ps ) $=
      ( wfal wi wn ex dfnot sylibr ) ABDEBFABDCGBHI $.
  $}

  ${
    efald.1 $e |- ( ( ph /\ -. ps ) -> F. ) $.
    $( Deduction based on reductio ad absurdum.  (Contributed by Mario
       Carneiro, 9-Feb-2017.) $)
    efald $p |- ( ph -> ps ) $=
      ( wn inegd notnotrd ) ABABDCEF $.
  $}

  ${
    pm2.21fal.1 $e |- ( ph -> ps ) $.
    pm2.21fal.2 $e |- ( ph -> -. ps ) $.
    $( If a wff and its negation are provable, then falsum is provable.
       (Contributed by Mario Carneiro, 9-Feb-2017.) $)
    pm2.21fal $p |- ( ph -> F. ) $=
      ( wfal pm2.21dd ) ABECDF $.
  $}


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Truth tables
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  Some sources define logical connectives by their truth tables.  These are
  tables that give the truth value of the composed expression for all possible
  combinations of the truth values of their arguments.  In this section, we
  show that our definitions and axioms produce equivalent results for all the
  logical connectives we have introduced (either axiomatically or by a
  definition): implication ~ wi , negation ~ wn , biconditional ~ df-bi ,
  conjunction ~ df-an , disjunction ~ df-or , alternative denial ~ df-nan ,
  exclusive disjunction ~ df-xor .

$)


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  Implication
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
$)

  $( A ` -> ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.)  An
     alternate proof is possible using ~ trud instead of ~ id but the principle
     of identity ~ id is more basic, and the present proof indicates that the
     result still holds in relevance logic.
     (Proof modification is discouraged.) $)
  truimtru $p |- ( ( T. -> T. ) <-> T. ) $=
    ( wtru wi id bitru ) AABACD $.

  $( A ` -> ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.)  (Proof
     shortened by Andrew Salmon, 13-May-2011.) $)
  truimfal $p |- ( ( T. -> F. ) <-> F. ) $=
    ( wfal wtru wi trut bicomi ) ABACADE $.

  $( A ` -> ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.)  An
     alternate proof is possible using ~ falim instead of ~ trud but the
     present proof using ~ trud emphasizes that the result does not require the
     principle of explosion.  (Proof modification is discouraged.) $)
  falimtru $p |- ( ( F. -> T. ) <-> T. ) $=
    ( wfal wtru wi trud bitru ) ABCADE $.

  $( A ` -> ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.)  An
     alternate proof is possible using ~ falim instead of ~ id but the present
     proof using ~ id emphasizes that the result does not require the principle
     of explosion.  (Proof modification is discouraged.) $)
  falimfal $p |- ( ( F. -> F. ) <-> T. ) $=
    ( wfal wi id bitru ) AABACD $.


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  Negation
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
$)

  $( A ` -. ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.) $)
  nottru $p |- ( -. T. <-> F. ) $=
    ( wfal wtru wn df-fal bicomi ) ABCDE $.

  $( A ` -. ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.)  (Proof
     shortened by Andrew Salmon, 13-May-2011.) $)
  notfal $p |- ( -. F. <-> T. ) $=
    ( wfal wn fal bitru ) ABCD $.


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  Equivalence
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
$)

  $( A ` <-> ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.)  (Proof
     shortened by Andrew Salmon, 13-May-2011.) $)
  trubitru $p |- ( ( T. <-> T. ) <-> T. ) $=
    ( wtru wb biid bitru ) AABACD $.

  $( A ` <-> ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.)  (Proof
     shortened by Andrew Salmon, 13-May-2011.)  (Proof shortened by Wolf
     Lammen, 10-Jul-2020.) $)
  falbitru $p |- ( ( F. <-> T. ) <-> F. ) $=
    ( wfal wtru wb tbtru bicomi ) AABCADE $.

  $( A ` <-> ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.)  (Proof
     shortened by Andrew Salmon, 13-May-2011.)  (Proof shortened by Wolf
     Lammen, 10-Jul-2020.) $)
  trubifal $p |- ( ( T. <-> F. ) <-> F. ) $=
    ( wtru wfal wb bicom falbitru bitri ) ABCBACBABDEF $.

  $( A ` <-> ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.)  (Proof
     shortened by Andrew Salmon, 13-May-2011.) $)
  falbifal $p |- ( ( F. <-> F. ) <-> T. ) $=
    ( wfal wb biid bitru ) AABACD $.


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  Conjunction
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
$)

  $( A ` /\ ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.) $)
  truantru $p |- ( ( T. /\ T. ) <-> T. ) $=
    ( wtru anidm ) AB $.

  $( A ` /\ ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.) $)
  truanfal $p |- ( ( T. /\ F. ) <-> F. ) $=
    ( wfal truan ) AB $.

  $( A ` /\ ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.) $)
  falantru $p |- ( ( F. /\ T. ) <-> F. ) $=
    ( wfal wtru wa fal intnanr bifal ) ABCABDEF $.

  $( A ` /\ ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.) $)
  falanfal $p |- ( ( F. /\ F. ) <-> F. ) $=
    ( wfal anidm ) AB $.


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  Disjunction
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
$)

  $( A ` \/ ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.)  (Proof
     shortened by Andrew Salmon, 13-May-2011.) $)
  truortru $p |- ( ( T. \/ T. ) <-> T. ) $=
    ( wtru oridm ) AB $.

  $( A ` \/ ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.) $)
  truorfal $p |- ( ( T. \/ F. ) <-> T. ) $=
    ( wtru wfal wo tru orci bitru ) ABCABDEF $.

  $( A ` \/ ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.) $)
  falortru $p |- ( ( F. \/ T. ) <-> T. ) $=
    ( wfal wtru wo tru olci bitru ) ABCBADEF $.

  $( A ` \/ ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.)  (Proof
     shortened by Andrew Salmon, 13-May-2011.) $)
  falorfal $p |- ( ( F. \/ F. ) <-> F. ) $=
    ( wfal oridm ) AB $.


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  Alternative denial
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
$)

  $( A ` -/\ ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.)  (Proof
     shortened by Andrew Salmon, 13-May-2011.) $)
  trunantru $p |- ( ( T. -/\ T. ) <-> F. ) $=
    ( wtru wnan wn wfal nannot nottru bitr3i ) AABACDAEFG $.

  $( A ` -/\ ` identity.  (Contributed by Anthony Hart, 23-Oct-2010.)  (Proof
     shortened by Andrew Salmon, 13-May-2011.)  (Proof shortened by Wolf
     Lammen, 10-Jul-2020.) $)
  trunanfal $p |- ( ( T. -/\ F. ) <-> T. ) $=
    ( wtru wfal wnan wn wa df-nan truanfal xchbinx notfal bitri ) ABCZBDAKABEBA
    BFGHIJ $.

  $( A ` -/\ ` identity.  (Contributed by Anthony Hart, 23-Oct-2010.)  (Proof
     shortened by Andrew Salmon, 13-May-2011.) $)
  falnantru $p |- ( ( F. -/\ T. ) <-> T. ) $=
    ( wfal wtru wnan nancom trunanfal bitri ) ABCBACBABDEF $.

  $( A ` -/\ ` identity.  (Contributed by Anthony Hart, 22-Oct-2010.)  (Proof
     shortened by Andrew Salmon, 13-May-2011.) $)
  falnanfal $p |- ( ( F. -/\ F. ) <-> T. ) $=
    ( wfal wnan wn wtru nannot notfal bitr3i ) AABACDAEFG $.


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  Exclusive disjunction
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
$)

  $( A ` \/_ ` identity.  (Contributed by David A. Wheeler, 8-May-2015.) $)
  truxortru $p |- ( ( T. \/_ T. ) <-> F. ) $=
    ( wtru wxo wn wfal wb df-xor trubitru xchbinx nottru bitri ) AABZACDKAAEAAA
    FGHIJ $.

  $( A ` \/_ ` identity.  (Contributed by David A. Wheeler, 8-May-2015.) $)
  truxorfal $p |- ( ( T. \/_ F. ) <-> T. ) $=
    ( wtru wfal wxo wn wb df-xor trubifal xchbinx notfal bitri ) ABCZBDAKABEBAB
    FGHIJ $.

  $( A ` \/_ ` identity.  (Contributed by David A. Wheeler, 9-May-2015.)
     (Proof shortened by Wolf Lammen, 10-Jul-2020.) $)
  falxortru $p |- ( ( F. \/_ T. ) <-> T. ) $=
    ( wfal wtru wxo xorcom truxorfal bitri ) ABCBACBABDEF $.

  $( A ` \/_ ` identity.  (Contributed by David A. Wheeler, 9-May-2015.) $)
  falxorfal $p |- ( ( F. \/_ F. ) <-> F. ) $=
    ( wfal wxo wtru wn wb df-xor falbifal xchbinx nottru bitri ) AABZCDAKAAECAA
    FGHIJ $.


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  Joint denial
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
$)

  $( A ` -\/ ` identity.  (Contributed by Remi, 25-Oct-2023.)  (Proof shortened
     by Wolf Lammen, 7-Dec-2023.) $)
  trunortru $p |- ( ( T. -\/ T. ) <-> F. ) $=
    ( wtru wnor wn wfal wo df-nor truortru xchbinx df-fal bitr4i ) AABZACDKAAEA
    AAFGHIJ $.

  $( A ` -\/ ` identity.  (Contributed by Remi, 25-Oct-2023.)  (Proof shortened
     by Wolf Lammen, 17-Dec-2023.) $)
  trunorfal $p |- ( ( T. -\/ F. ) <-> F. ) $=
    ( wtru wfal wnor wn wo df-nor truorfal xchbinx df-fal bitr4i ) ABCZADBKABEA
    ABFGHIJ $.

  $( A ` -\/ ` identity.  (Contributed by Remi, 25-Oct-2023.) $)
  falnortru $p |- ( ( F. -\/ T. ) <-> F. ) $=
    ( wfal wtru wnor norcom trunorfal bitri ) ABCBACAABDEF $.

  $( A ` -\/ ` identity.  (Contributed by Remi, 25-Oct-2023.)  (Proof shortened
     by Wolf Lammen, 17-Dec-2023.) $)
  falnorfal $p |- ( ( F. -\/ F. ) <-> T. ) $=
    ( wfal wnor wn wtru wo df-nor falorfal xchbinx notfal bitri ) AABZACDKAAEAA
    AFGHIJ $.

  $( Add support for natural deduction, indicating the constants used to
     indicate implication, context conjunction, and empty context. $)
  $( $j natded_init 'wi' 'wa' 'wtru'; $)

  $( These are variations on the assumption rule of natural deduction.
     They have the form ` Gamma -> ph ` where ` Gamma ` is composed entirely
     of (binary) conjunctions and one of the conjuncts is ` ph ` . $)
  $( $j natded_assume 'id' 'simpl' 'simpr'
          'simpll' 'simplr' 'simprl' 'simprr'
          'simplll' 'simpllr' 'simplrl' 'simplrr'
          'simprll' 'simprlr' 'simprrl' 'simprrr'
          'simp-4l' 'simp-4r' 'simp-5l' 'simp-5r'
          'simp-6l' 'simp-6r' 'simp-7l' 'simp-7r'
          'simp-8l' 'simp-8r' 'simp-9l' 'simp-9r'
          'simp-10l' 'simp-10r' 'simp-11l' 'simp-11r'; $)

  $( These are variations on the weakening lemma of natural deduction.
     They have the form ` _D -> ph |- _G -> ph ` where ` _G `
     and ` _D ` are composed entirely of (binary) conjunctions and
     ` _D C_ _G ` . $)
  $( $j natded_weak 'a1i' 'adantl' 'adantr'
          'adantll' 'adantlr' 'adantrl' 'adantrr'
          'adantlll' 'adantllr' 'adantlrl' 'adantlrr'
          'adantrll' 'adantrlr' 'adantrrl' 'adantrrr'
          'ad2antll' 'ad2antlr' 'ad2antrl' 'ad2antrr'
          'ad2ant2l' 'ad2ant2lr' 'ad2ant2rl' 'ad2ant2r'
          'ad3antlr' 'ad3antrrr' 'ad4antlr' 'ad4antr'
          'ad4antlr' 'ad4antr' 'ad5antlr' 'ad5antr'
          'ad6antlr' 'ad6antr' 'ad7antlr' 'ad7antr'
          'ad8antlr' 'ad8antr' 'ad9antlr' 'ad9antr'
          'ad10antlr' 'ad10antr'
          'anidms' 'ancoms' 'anasss' 'anassrs' 'an12s'  'ancom2s' 'an13s'
          'an32s' 'ancom1s' 'an31s' 'anass1rs' 'anabsan'  'anabss1' 'anabss4'
          'anabss5' 'anabss7' 'anabsan2' 'anabss3' 'an4s' 'an42s'
          'anandis' 'anandirs'; $)

  $( These are variations on the cut axiom (modus ponens) of natural deduction.
     All assumptions and the consequent have the form ` ph ` or ` _G -> ph `
     where ` _G ` is composed entirely of (binary) conjunctions, and possibly
     some intermediate statements are cancelled. (This does not include the
     "natded_assume" and "natded_weak" lists, which also count in this
     category.) $)
  $( $j natded_cut 'mp2b' 'mp1i' 'syl' '3syl' '4syl' 'syldan' 'sylan' 'sylan2'
          'syl2an' 'syl2anr' 'sylanl1' 'sylanl2' 'sylanr1' 'sylanr2' 'syl2anc'
          'sylancl' 'sylancr' 'sylancom' 'mpdan' 'mpancom' 'mpan' 'mpan2'
          'mp2an' 'mp4an' 'mpanl1' 'mpanl2' 'mpanl12' 'mpanr1' 'mpanr2'
          'mpanr12' 'mpanlr1' 'syl12anc' 'syl21anc' 'syl22anc'; $)

  $( Natural deduction rules for the logical connectives, defining the
     connective itself and natural deduction rules pertaining to it.
     These don't have a fixed form, except that all the statements should be
     parseable as natural deduction statements, i.e. ` ph ` or ` _G -> ph `
     where _G is a nested conjunction. $)
  $( $j natded_true 'wtru' with 'mptru' 'tru' 'trud';
        natded_imp 'wi' with 'ex' 'imp' 'mpd' 'ax-mp' 'syl' 'mpi';
        natded_and 'wa' with 'jca' 'pm3.2i' 'jca31' 'jca32' 'jctil' 'jctir'
          'jctl' 'jctr' 'ancli' 'ancri';
        natded_or 'wo' with 'olc' 'orc' 'olci' 'orci' 'olcd' 'orcd' 'olcs'
          'orcs' 'jaoi' 'jaod' 'jaodan' 'mpjaodan';
        natded_not 'wn' 'wfal' with 'falim' 'falimd' 'inegd' 'mtand' 'pm2.65da'
          'pm2.01da' 'pm2.18da' 'pm2.21dd' 'pm2.21fal' 'efald' 'pm2.18da'
          'notnotr' 'notnotrd'; $)


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Half adder and full adder in propositional calculus
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  Propositional calculus deals with truth values, which can be interpreted as
  bits.  Using this, we can define the half adder and the full adder in pure
  propositional calculus, and show their basic properties.

  The half adder adds two 1-bit numbers.  Its two outputs are the "sum" S and
  the "carry" C.  The real sum is then given by 2C+S.  The sum and carry
  correspond respectively to the logical exclusive disjunction ( ~ df-xor ) and
  the logical conjunction ( ~ df-an ).

  The full adder takes into account an "input carry", so it has three inputs
  and again two outputs, corresponding to the "sum" ( ~ df-had ) and "updated
  carry" ( ~ df-cad ).

  Here is a short description.  We code the bit 0 by ` F. ` and 1 by ` T. ` .
  Even though ` hadd ` and ` cadd ` are invariant under permutation of their
  arguments, assume for the sake of concreteness that ` ph ` (resp. ` ps ` ) is
  the i^th bit of the first (resp. second) number to add (with the convention
  that the i^th bit is the multiple of 2^i in the base-2 representation), and
  that ` ch ` is the i^th carry (with the convention that the 0^th carry is 0).
  Then, ` hadd ( ph , ps , ch ) ` gives the i^th bit of the sum, and
  ` cadd ( ph , ps , ch ) ` gives the (i+1)^th carry.  Then, addition is
  performed by iteration from i = 0 to i = 1 + (max of the number of digits of
  the two summands) by "updating" the carry.

$)


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  Full adder: sum
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
$)

  $c hadd $.

  $( Syntax for the "sum" output of the full adder.  (Contributed by Mario
     Carneiro, 4-Sep-2016.) $)
  whad $a wff hadd ( ph , ps , ch ) $.

  $( Definition of the "sum" output of the full adder (triple exclusive
     disjunction, or XOR3, or testing whether an odd number of parameters are
     true).  (Contributed by Mario Carneiro, 4-Sep-2016.) $)
  df-had $a |- ( hadd ( ph , ps , ch ) <-> ( ( ph \/_ ps ) \/_ ch ) ) $.

  ${
    hadbid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    hadbid.2 $e |- ( ph -> ( th <-> ta ) ) $.
    hadbid.3 $e |- ( ph -> ( et <-> ze ) ) $.
    $( Equality theorem for the adder sum.  (Contributed by Mario Carneiro,
       4-Sep-2016.) $)
    hadbi123d $p |- ( ph ->
      ( hadd ( ps , th , et ) <-> hadd ( ch , ta , ze ) ) ) $=
      ( wxo whad xorbi12d df-had 3bitr4g ) ABDKZFKCEKZGKBDFLCEGLAPQFGABCDEHIMJM
      BDFNCEGNO $.
  $}

  ${
    hadbii.1 $e |- ( ph <-> ps ) $.
    hadbii.2 $e |- ( ch <-> th ) $.
    hadbii.3 $e |- ( ta <-> et ) $.
    $( Equality theorem for the adder sum.  (Contributed by Mario Carneiro,
       4-Sep-2016.) $)
    hadbi123i $p |- ( hadd ( ph , ch , ta ) <-> hadd ( ps , th , et ) ) $=
      ( whad wb wtru a1i hadbi123d mptru ) ACEJBDFJKLABCDEFABKLGMCDKLHMEFKLIMNO
      $.
  $}

  $( Associative law for the adder sum.  (Contributed by Mario Carneiro,
     4-Sep-2016.) $)
  hadass $p |- ( hadd ( ph , ps , ch ) <-> ( ph \/_ ( ps \/_ ch ) ) ) $=
    ( whad wxo df-had xorass bitri ) ABCDABECEABCEEABCFABCGH $.

  $( The adder sum is the same as the triple biconditional.  (Contributed by
     Mario Carneiro, 4-Sep-2016.) $)
  hadbi $p |- ( hadd ( ph , ps , ch ) <-> ( ( ph <-> ps ) <-> ch ) ) $=
    ( wxo wb wn whad df-xor df-had xnor bibi1i nbbn bitri 3bitr4i ) ABDZCDOCEFZ
    ABCGABEZCEZOCHABCIROFZCEPQSCABJKOCLMN $.

  $( Commutative law for the adder sum.  (Contributed by Mario Carneiro,
     4-Sep-2016.)  (Proof shortened by Wolf Lammen, 17-Dec-2023.) $)
  hadcoma $p |- ( hadd ( ph , ps , ch ) <-> hadd ( ps , ph , ch ) ) $=
    ( wb whad bicom bibi1i hadbi 3bitr4i ) ABDZCDBADZCDABCEBACEJKCABFGABCHBACHI
    $.

  $( Commutative law for the adders sum.  (Contributed by Mario Carneiro,
     4-Sep-2016.) $)
  hadcomb $p |- ( hadd ( ph , ps , ch ) <-> hadd ( ph , ch , ps ) ) $=
    ( wxo whad biid xorcom xorbi12i hadass 3bitr4i ) ABCDZDACBDZDABCEACBEAAKLAF
    BCGHABCIACBIJ $.

  $( Rotation law for the adder sum.  (Contributed by Mario Carneiro,
     4-Sep-2016.) $)
  hadrot $p |- ( hadd ( ph , ps , ch ) <-> hadd ( ps , ch , ph ) ) $=
    ( whad hadcoma hadcomb bitri ) ABCDBACDBCADABCEBACFG $.

  $( The adder sum distributes over negation.  (Contributed by Mario Carneiro,
     4-Sep-2016.)  (Proof shortened by Wolf Lammen, 11-Jul-2020.) $)
  hadnot $p |- ( -. hadd ( ph , ps , ch ) <->
    hadd ( -. ph , -. ps , -. ch ) ) $=
    ( wb wn whad notbi bibi1i xor3 hadbi xchnxbir 3bitr4i ) ABDZCEZDZAEZBEZDZND
    ABCFZEPQNFMRNABGHMCDOSMCIABCJKPQNJL $.

  $( If the first input is true, then the adder sum is equivalent to the
     biconditionality of the other two inputs, and conversely.  (Contributed by
     Mario Carneiro, 4-Sep-2016.)  (Proof shortened by Wolf Lammen,
     11-Jul-2020.)  Strengthen to a biconditional.  (Revised by BJ,
     10-Aug-2026.) $)
  had1 $p |- ( ph <-> ( hadd ( ph , ps , ch ) <-> ( ps <-> ch ) ) ) $=
    ( whad wb hadrot hadbi bitri birot mpbir ) AABCDZBCEZEEKLAEZEKBCADMABCFBCAG
    HAKLIJ $.

  $( If the first input is false, then the adder sum is equivalent to the
     exclusive disjunction of the other two inputs, and conversely.
     (Contributed by Mario Carneiro, 4-Sep-2016.)  (Proof shortened by Wolf
     Lammen, 12-Jul-2020.)  Strengthen to a biconditional.  (Revised by BJ,
     10-Aug-2026.) $)
  had0 $p |- ( -. ph <-> ( hadd ( ph , ps , ch ) <-> ( ps \/_ ch ) ) ) $=
    ( whad wxo wb wn hadrot df-had df-xor xor3 bitri biass mpbir bicomi ) ABCDZ
    BCEZFZAGZRSFPQSFZFPBCADZTABCHUAQAEZTBCAIUBQAFGTQAJQAKLLLPQSMNO $.

  $( Obsolete version of ~ had1 as of 10-Aug-2026.  (Contributed by Mario
     Carneiro, 4-Sep-2016.)  (Proof shortened by Wolf Lammen, 11-Jul-2020.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  had1OLD $p |- ( ph -> ( hadd ( ph , ps , ch ) <-> ( ps <-> ch ) ) ) $=
    ( whad wb hadrot hadbi bitri biass mpbir biimpri ) ABCDZBCEZEZANAELMAEZELBC
    ADOABCFBCAGHLMAIJK $.

  $( Obsolete version of ~ had0 as of 10-Aug-2026.  (Contributed by Mario
     Carneiro, 4-Sep-2016.)  (Proof shortened by Wolf Lammen, 12-Jul-2020.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  had0OLD $p |- ( -. ph -> ( hadd ( ph , ps , ch ) <-> ( ps \/_ ch ) ) ) $=
    ( wn whad wxo wb had1OLD hadnot xnor notbi bitr3i 3bitr4g con4bid ) ADZABCE
    ZBCFZOOBDZCDZERSGZPDQDZORSHABCIUABCGTBCJBCKLMN $.

  $( The value of the adder sum is, if the first input is true, the
     biconditionality, and if the first input is false, the exclusive
     disjunction, of the other two inputs.  (Contributed by BJ,
     11-Aug-2020.) $)
  hadifp $p |-
    ( hadd ( ph , ps , ch ) <-> if- ( ph , ( ps <-> ch ) , ( ps \/_ ch ) ) ) $=
    ( whad wb wxo had1 biimpi wn had0 casesifp ) AABCDZBCEZBCFZALMEABCGHAILNEAB
    CJHK $.

  $( Obsolete version of ~ hadifp as of 10-Aug-2026.  (Contributed by BJ,
     11-Aug-2020.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  hadifpOLD $p |-
    ( hadd ( ph , ps , ch ) <-> if- ( ph , ( ps <-> ch ) , ( ps \/_ ch ) ) ) $=
    ( whad wb wxo had1OLD had0OLD casesifp ) AABCDBCEBCFABCGABCHI $.


$(
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  Full adder: carry
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
$)

  $c cadd $.

  $( Syntax for the "carry" output of the full adder.  (Contributed by Mario
     Carneiro, 4-Sep-2016.) $)
  wcad $a wff cadd ( ph , ps , ch ) $.

  $( Definition of the "carry" output of the full adder.  It is true when at
     least two arguments are true, so it is equal to the "majority" function on
     three variables.  See ~ cador and ~ cadan for alternate definitions.
     (Contributed by Mario Carneiro, 4-Sep-2016.) $)
  df-cad $a |- ( cadd ( ph , ps , ch ) <->
    ( ( ph /\ ps ) \/ ( ch /\ ( ph \/_ ps ) ) ) ) $.

  $( The adder carry in disjunctive normal form.  (Contributed by Mario
     Carneiro, 4-Sep-2016.)  (Proof shortened by Wolf Lammen, 11-Jul-2020.) $)
  cador $p |- ( cadd ( ph , ps , ch ) <->
        ( ( ph /\ ps ) \/ ( ph /\ ch ) \/ ( ps /\ ch ) ) ) $=
    ( wa wxo wo wcad w3o wn xor2 rbaib anbi1d ancom andir 3bitr3g pm5.74i df-or
    wi 3bitr4i df-cad 3orass ) ABDZCABEZDZFZUBACDZBCDZFZFZABCGUBUFUGHUBIZUDRUJU
    HRUEUIUJUDUHUJUCCDABFZCDUDUHUJUCUKCUCUKUJABJKLUCCMABCNOPUBUDQUBUHQSABCTUBUF
    UGUAS $.

  $( The adder carry in conjunctive normal form.  (Contributed by Mario
     Carneiro, 4-Sep-2016.)  (Proof shortened by Wolf Lammen, 25-Sep-2018.) $)
  cadan $p |- ( cadd ( ph , ps , ch ) <->
        ( ( ph \/ ps ) /\ ( ph \/ ch ) /\ ( ps \/ ch ) ) ) $=
    ( wcad wo w3a w3o df-3or cador andi orbi1i 3bitr4i ordir ordi orcom animorl
    wa wi wb bitr4i pm4.72 mpbi anbi12i 3bitri df-3an ) ABCDZABEZACEZQZBCEZQZUG
    UHUJFUFAUJQZBCQZEZAUMEZUJUMEZQUKABQZACQZUMGUQUREZUMEUFUNUQURUMHABCIULUSUMAB
    CJKLAUJUMMUOUIUPUJABCNUPUMUJEZUJUJUMOUMUJRUJUTSBCCPUMUJUAUBTUCUDUGUHUJUET
    $.

  ${
    cadbid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    cadbid.2 $e |- ( ph -> ( th <-> ta ) ) $.
    cadbid.3 $e |- ( ph -> ( et <-> ze ) ) $.
    $( Equality theorem for the adder carry.  (Contributed by Mario Carneiro,
       4-Sep-2016.) $)
    cadbi123d $p |- ( ph ->
      ( cadd ( ps , th , et ) <-> cadd ( ch , ta , ze ) ) ) $=
      ( wa wxo wo wcad anbi12d xorbi12d orbi12d df-cad 3bitr4g ) ABDKZFBDLZKZMC
      EKZGCELZKZMBDFNCEGNATUCUBUEABCDEHIOAFGUAUDJABCDEHIPOQBDFRCEGRS $.
  $}

  ${
    cadbii.1 $e |- ( ph <-> ps ) $.
    cadbii.2 $e |- ( ch <-> th ) $.
    cadbii.3 $e |- ( ta <-> et ) $.
    $( Equality theorem for the adder carry.  (Contributed by Mario Carneiro,
       4-Sep-2016.) $)
    cadbi123i $p |- ( cadd ( ph , ch , ta ) <-> cadd ( ps , th , et ) ) $=
      ( wcad wb wtru a1i cadbi123d mptru ) ACEJBDFJKLABCDEFABKLGMCDKLHMEFKLIMNO
      $.
  $}

  $( Commutative law for the adder carry.  (Contributed by Mario Carneiro,
     4-Sep-2016.) $)
  cadcoma $p |- ( cadd ( ph , ps , ch ) <-> cadd ( ps , ph , ch ) ) $=
    ( wa wxo wo wcad ancom xorcom anbi2i orbi12i df-cad 3bitr4i ) ABDZCABEZDZFB
    ADZCBAEZDZFABCGBACGNQPSABHORCABIJKABCLBACLM $.

  $( Commutative law for the adder carry.  (Contributed by Mario Carneiro,
     4-Sep-2016.)  (Proof shortened by Wolf Lammen, 11-Jul-2020.) $)
  cadcomb $p |- ( cadd ( ph , ps , ch ) <-> cadd ( ph , ch , ps ) ) $=
    ( wcad wo w3a cadan 3ancoma orcom 3anbi3i 3bitri bitr4i ) ABCDZACEZABEZCBEZ
    FZACBDMONBCEZFNORFQABCGONRHRPNOBCIJKACBGL $.

  $( Rotation law for the adder carry.  (Contributed by Mario Carneiro,
     4-Sep-2016.) $)
  cadrot $p |- ( cadd ( ph , ps , ch ) <-> cadd ( ps , ch , ph ) ) $=
    ( wcad cadcoma cadcomb bitri ) ABCDBACDBCADABCEBACFG $.

  $( The adder carry distributes over negation.  (Contributed by Mario
     Carneiro, 4-Sep-2016.)  (Proof shortened by Wolf Lammen, 11-Jul-2020.) $)
  cadnot $p |- ( -. cadd ( ph , ps , ch ) <->
    cadd ( -. ph , -. ps , -. ch ) ) $=
    ( wa wn w3a wo wcad ianor 3anbi123i w3o 3ioran cador xchnxbir cadan 3bitr4i
    ) ABDZEZACDZEZBCDZEZFZAEZBEZGZUDCEZGZUEUGGZFABCHZEUDUEUGHRUFTUHUBUIABIACIBC
    IJQSUAKUCUJQSUALABCMNUDUEUGOP $.

  $( If (at least) two inputs are true, then the adder carry is true.
     (Contributed by Mario Carneiro, 4-Sep-2016.) $)
  cad11 $p |- ( ( ph /\ ps ) -> cadd ( ph , ps , ch ) ) $=
    ( wa wxo wo wcad orc df-cad sylibr ) ABDZKCABEDZFABCGKLHABCIJ $.

  $( If one input is true, then the adder carry is true exactly when at least
     one of the other two inputs is true.  (Contributed by Mario Carneiro,
     8-Sep-2016.)  (Proof shortened by Wolf Lammen, 19-Jun-2020.) $)
  cad1 $p |- ( ch -> ( cadd ( ph , ps , ch ) <-> ( ph \/ ps ) ) ) $=
    ( wcad wo wa w3a cadan 3anass bitri olc jca biantrud bitr4id ) CABCDZABEZAC
    EZBCEZFZFZPOPQRGTABCHPQRIJCSPCQRCAKCBKLMN $.

  $( If one input is false, then the adder carry is true exactly when both of
     the other two inputs are true.  (Contributed by Mario Carneiro,
     8-Sep-2016.)  (Proof shortened by Wolf Lammen, 21-Sep-2024.) $)
  cad0 $p |- ( -. ch -> ( cadd ( ph , ps , ch ) <-> ( ph /\ ps ) ) ) $=
    ( wn wcad wa wxo wo df-cad idd pm2.21 adantrd jaod biimtrid cad11 impbid1 )
    CDZABCEZABFZRSCABGZFZHQSABCIQSSUAQSJQCSTCSKLMNABCOP $.

  $( The value of the carry is, if the input carry is true, the disjunction,
     and if the input carry is false, the conjunction, of the other two inputs.
     (Contributed by BJ, 8-Oct-2019.) $)
  cadifp $p |-
      ( cadd ( ph , ps , ch ) <-> if- ( ch , ( ph \/ ps ) , ( ph /\ ps ) ) ) $=
    ( wcad wo wa cad1 cad0 casesifp ) CABCDABEABFABCGABCHI $.

  $( The adder carry is true as soon as its first two inputs are the truth
     constant.  (Contributed by Mario Carneiro, 4-Sep-2016.) $)
  cadtru $p |- cadd ( T. , T. , ph ) $=
    ( wtru wcad tru cad11 mp2an ) BBBBACDDBBAEF $.


$(
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
  Other axiomatizations related to classical propositional calculus
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
$)


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Minimal implicational calculus
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  Minimal implicational calculus, or intuitionistic implicational calculus, or
  positive implicational calculus, is the implicational fragment of minimal
  calculus (which is also the implicational fragment of intuitionistic calculus
  and of positive calculus).  It is sometimes called "C-pure intuitionism"
  since the letter C is sometimes used to denote implication, especially in
  prefix notation.  It can be axiomatized by the inference rule of modus ponens
  ~ ax-mp together with the axioms { ~ ax-1 , ~ ax-2 } (sometimes written KS),
  or with { ~ imim1 , ~ ax-1 , ~ pm2.43 } (written B'KW), or with { ~ imim2 ,
  ~ pm2.04 , ~ ax-1 , ~ pm2.43 } (written BCKW), or with the single axiom
  ~ minimp .  This section proves ~ minimp from { ~ ax-1 , ~ ax-2 }, and then
  the converse, due to Ivo Thomas.

  Sources for this section are the webpage
  ~ https://web.ics.purdue.edu/~~dulrich/C-pure-intuitionism-page.htm
  on Ted Ulrich's website, and the articles
  C. A. Meredith,
  _A single axiom of positive logic_,
  Journal of computing systems, vol. 1 (1953), 169--170,
  and
  C. A. Meredith, A. N. Prior,
  _Notes on the axiomatics of the propositional calculus_,
  Notre Dame Journal of Formal Logic, vol. 4 (1963), 171--187.

  We may use a compact notation for derivations known as the D-notation where
  "D" stands for "condensed Detachment".  For instance, "D21" means detaching
  ~ ax-1 from ~ ax-2 , that is, using modus ponens ~ ax-mp with ~ ax-1 as minor
  premise and ~ ax-2 as major premise.  D-strings are accepted by the grammar
  Dstr := digit | "D" Dstr Dstr.

  (Contributed by BJ, 11-Apr-2021.)

$)

  $( A single axiom for minimal implicational calculus, due to Meredith.  Other
     single axioms of the same length are known, but it is thought to be the
     minimal length.  Among single axioms of this length, it is the one with
     simplest antecedents (i.e., in the corresponding ordering of binary trees
     which first compares left subtrees, it is the first one).  (Contributed by
     BJ, 4-Apr-2021.) $)
  minimp $p |- ( ph ->
  ( ( ps -> ch ) -> ( ( ( th -> ps ) -> ( ch -> ta ) ) -> ( ps -> ta ) ) ) ) $=
    ( wi jarr a2d com12 a1i ) BCFZDBFCEFZFZBEFZFFAMKNMBCEDBLGHIJ $.
  $( $j usage 'minimp' avoids 'ax-3'; $)

  $( Derivation of Syll-Simp ( ~ jarr ) from ~ ax-mp and ~ minimp .
     (Contributed by BJ, 4-Apr-2021.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  minimp-syllsimp $p |- ( ( ( ph -> ps ) -> ch ) -> ( ps -> ch ) ) $=
    ( wi minimp ax-mp mp2 mp2b ) ABDZIDZJJDJDDZICDZDZLDZILCDZDZLBCDZDZJLIDZJDJD
    DZKDZITDZMDTLDDZNTIIIIETTTDZUDUDDUDDDDZUAUCDTTTTTEUETKILEFMMMDZUFUFDUFDDDZM
    TDUCNDMMMMMEMIILIEUGMTUBLEGHIKDZINDSNODDZPDDZNPDZIIIIIEUHINLOENNNDZULULDULD
    DDZNUIDUJUKDNNNNNENLIKCEUMNUIIPEGHLLLDZUNUNDUNDDDZLPDBLDPQDDZRDDZPRDZLLLLLE
    UOLPBQEPPPDZUSUSDUSDDDZPUPDUQURDPPPPPEPBLACEUTPUPLREGHH $.

  $( Derivation of ~ ax-1 from ~ ax-mp and ~ minimp .  (Contributed by BJ,
     4-Apr-2021.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  minimp-ax1 $p |- ( ph -> ( ps -> ph ) ) $=
    ( wi minimp-syllsimp ax-mp ) ABCZACBACZCAGCABADFAGDE $.

  $( Derivation of a commuted form of ~ ax-2 from ~ ax-mp and ~ minimp .
     (Contributed by BJ, 4-Apr-2021.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  minimp-ax2c $p |- ( ( ph -> ps ) ->
                                ( ( ph -> ( ps -> ch ) ) -> ( ph -> ch ) ) ) $=
    ( wi minimp ax-mp mp2 minimp-syllsimp ) ABDZAADZJJDJDDZADZBCDZDZACDZDZDZPAM
    DZODZDZISDZAKDZQAAAAAEUBABKCEFRRDZPDSDZTRUCUCUCDUCDDDZRNDZUDRRRRRELLDZRDNDZ
    UFLUGUGUGDUGDDDZLADZUHLLLLLEZLKDZUBLDLDZUJLAAAAEKKKDZUNUNDUNDDDZUNUMKKKKKEK
    AAAAEUOKKAAEGUIULUMUJDDUKUILKUBAEFGUILALMEGUGRNHFUERNROEGUCPSHFSQDZIIDZTDUA
    DZTUADZDZDQUSDZDZUTVAQQQDZVCVCDVCDDDZQURDZVBQQQQQEIUQUQUQDUQDDDZVEIIIIIEVFI
    PISEFVDQURSUSEGUQTUAHUPUTVAHGG $.

  $( Derivation of ~ ax-2 from ~ ax-mp and ~ minimp .  (Contributed by BJ,
     4-Apr-2021.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  minimp-ax2 $p |- ( ( ph -> ( ps -> ch ) ) ->
                                          ( ( ph -> ps ) -> ( ph -> ch ) ) ) $=
    ( wi minimp-ax2c minimp-syllsimp ax-mp mp2 ) ABDZABCDDZACDZDDZJLIKDZDZDZJMD
    ZABCEIJDNDOIJKEIJNFGJLDOPDZDLQDJLMEJLQFGH $.

  $( Derivation of ~ pm2.43 (also called "hilbert" or W) from ~ ax-mp and
     ~ minimp .  It uses the classical derivation from ~ ax-1 and ~ ax-2
     written DD22D21 in D-notation (see head comment for an explanation) and
     shortens the proof using ~ mp2 (which only requires ~ ax-mp ).
     (Contributed by BJ, 31-May-2021.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  minimp-pm2.43 $p |- ( ( ph -> ( ph -> ps ) ) -> ( ph -> ps ) ) $=
    ( wi minimp-ax2 minimp-ax1 ax-mp mp2 ) AABCZCZAACZHCCIJCZIHCAABDAHACCKAHEAH
    ADFIJHDG $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Implicational Calculus
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  Implicational calculus is the fragment of propositional logic that uses only
  material implication, and not negation.  It can be axiomatized by inference
  rule modus ponens ~ ax-mp together with the axioms { ~ ax-1 , ~ ax-2 ,
  ~ peirce } or the Tarski-Bernays axioms { ~ ax-1 , ~ imim1 , ~ peirce } or
  with the single axiom { ~ impsingle }.  From either one of these three axiom
  sets, all tautologies containing only material implication may be proved.  In
  contrast, minimal implicational calculus, which is presented just before this
  section, cannot prove certain tautologies ( ~ peirce , for example ).  The
  class of theorems proved by minimal implicational calculus is thus a subset
  of the class of theorems proved by implicational calculus.

  The primary source for this section is the paper by Jan Lukasiewicz, _The
  Shortest Axiom of the Implicational Calculus of Propositions_, Proceedings
  of the Royal Irish Academy, Section A, vol. 52 (1948-1950), 25--33.  It will
  be cited as simply "Lukasiewicz" in the remainder of this section.

  This section proves that the above three distinct axiom sets for
  implicational calculus all produce the same class of theorems.

  (Contributed by Larry Lesyna and Jeffrey P. Machado, 1-Aug-2023.)

$)

  $( The shortest single axiom for implicational calculus, due to Lukasiewicz.
     It is now known to be the _unique_ shortest axiom.  The axiom is proved
     here starting from { ~ ax-1 , ~ ax-2 and ~ peirce }.  (Contributed by
     Larry Lesyna and Jeffrey P. Machado, 18-Jul-2023.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  impsingle $p |- ( ( ( ph -> ps ) -> ch )
     -> ( ( ch -> ph ) -> ( th -> ph ) ) ) $=
    ( wi imim1 peirce a1d syl6 ) ABEZCECAEJAEZDAEJCAFKADABGHI $.

  $( Derivation of impsingle-step4 from ~ ax-mp and ~ impsingle .  It is used
     as a lemma in proofs of ~ imim1 and ~ peirce from ~ impsingle .  It is
     Step 4 in Lukasiewicz, where it appears as 'CCCpqpCsp' using
     parenthesis-free prefix notation.  (Contributed by Larry Lesyna and
     Jeffrey P. Machado, 2-Aug-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  impsingle-step4 $p |- ( ( ( ph -> ps ) -> ph ) -> ( ch -> ph ) ) $=
    ( wta wet wze wsi wth wi impsingle ax-mp ) DEIFIFDIGDIIIZABIZAICAIIZDEFGJAH
    IZMIZNIZLNIZAHMCJNMIPIZQRIMMINISABMCJMMNOJKNMPLJKKK $.

  $( Derivation of impsingle-step8 from ~ ax-mp and ~ impsingle .  It is used
     as a lemma in proofs of ~ ax-1 ~ imim1 and ~ peirce from ~ impsingle .  It
     is Step 8 in Lukasiewicz, where it appears as 'CCCsqpCqp' using
     parenthesis-free prefix notation.  (Contributed by Larry Lesyna and
     Jeffrey P. Machado, 2-Aug-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  impsingle-step8 $p |- ( ( ( ph -> ps ) -> ch ) -> ( ps -> ch ) ) $=
    ( wta wet wze wsi wth wi impsingle ax-mp ) DEIFIFDIGDIIIZABIZCIZBCIZIZDEFGJ
    ZCHIZMIZPIZLPIZCHMBJPMISIZTUAIMOIPIZUBOBIMIZUCLUDQBHIZOIZUDIZLUDIZBHOAJUDOI
    UFIZUGUHIOOIUDIUIBCOAJOOUDUEJKUDOUFLJKKKOBMNJKMOPRJKPMSLJKKK $.

  $( Derivation of impsingle-ax1 ( ~ ax-1 ) from ~ ax-mp and ~ impsingle .
     Lukasiewicz was used to construct this proof.  Every formula corresponding
     to a detachment step was converted to its corresponding Metamath formula.
     mmj2 was used to unify each formula using ~ ax-mp , which in turn produced
     this proof.  With extremely high confidence, this result shows that the
     Lukasiewicz proof of ~ ax-1 (step 27) is correct and that Metamath
     correctly verifies the proof.  The same comments apply to the proofs that
     follow this one.  (Contributed by Larry Lesyna and Jeffrey P. Machado,
     2-Aug-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  impsingle-ax1 $p |- ( ph -> ( ps -> ph ) ) $=
    ( wch wi impsingle-step8 ax-mp ) CBDZADBADZDAHDCBAEGAHEF $.

  $( Derivation of impsingle-step15 from ~ ax-mp and ~ impsingle .  It is used
     as a lemma in proofs of ~ imim1 and ~ peirce from ~ impsingle .  It is
     Step 15 in Lukasiewicz, where it appears as 'CCCrqCspCCrpCsp' using
     parenthesis-free prefix notation.  (Contributed by Larry Lesyna and
     Jeffrey P. Machado, 2-Aug-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  impsingle-step15 $p |- ( ( ( ph -> ps ) -> ( ch -> th ) )
                              -> ( ( ph -> th ) -> ( ch -> th ) ) ) $=
    ( wla wta wsi wrh wmu wet wze wi impsingle impsingle-step8 ax-mp ) DELZALZA
    DLZCDLZLZLZABLZSLZTLZDEACMFGLHLHFLIFLLLZUAUDLZFGHIMTJLZQLZUFLZUEUFLZTJQUCMU
    FQLUHLZUIUJLQUDLUFLZUKUDALQLZULUBUDLZUMSKLZUBLUDLUNSKUBRMUOUBUDNOABUDPMOUDA
    QUAMOQUDUFUGMOUFQUHUEMOOOO $.

  $( Derivation of impsingle-step18 from ~ ax-mp and ~ impsingle .  It is used
     as a lemma in proofs of ~ imim1 and ~ peirce from ~ impsingle .  It is
     Step 18 in Lukasiewicz, where it appears as 'CCCCrpCspCCCpqrtCuCCCpqrt'
     using parenthesis-free prefix notation.  (Contributed by Larry Lesyna and
     Jeffrey P. Machado, 2-Aug-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  impsingle-step18 $p |- ( ( ( ( ph -> ps ) -> ( ch -> ps ) )
                               -> ( ( ( ps -> th ) -> ph ) -> ta ) )
                 -> ( et -> ( ( ( ps -> th ) -> ph ) -> ta ) ) ) $=
    ( wrh wi impsingle impsingle-step8 ax-mp impsingle-step15 ) BDHAHZEHZCBHZHZ
    ABHZOHZHZRNHFNHHMRHZSBDACINSHZTSHOGHZNHSHUAOGNQIUBNSJKMEPRLKKNORFIK $.

  $( Derivation of impsingle-step19 from ~ ax-mp and ~ impsingle .  It is used
     as a lemma in proofs of ~ imim1 and ~ peirce from ~ impsingle .  It is
     Step 19 in Lukasiewicz, where it appears as 'CCCCspqCrpCCCpqrCsp' using
     parenthesis-free prefix notation.  (Contributed by Larry Lesyna and
     Jeffrey P. Machado, 2-Aug-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  impsingle-step19 $p |- ( ( ( ( ph -> ps ) -> ch ) -> ( th -> ps ) )
                        -> ( ( ( ps -> ch ) -> th ) -> ( ph -> ps ) ) ) $=
    ( wta wet wze wsi wrh wmu wi impsingle-step18 ax-mp ) EFKGFKKFHKEKIKZKJNKKZ
    ABKZCKDBKZKZBCKDKZPKZKZEFGHIJLQPKTKUAKOUAKDBACPRLQPSCTOLMM $.

  $( Derivation of impsingle-step20 from ~ ax-mp and ~ impsingle .  It is used
     as a lemma in proofs of ~ imim1 and ~ peirce from ~ impsingle .  It is
     Step 20 in Lukasiewicz, where it appears as 'CCCCrppCspCCCpqrCsp' using
     parenthesis-free prefix notation.  (Contributed by Larry Lesyna and
     Jeffrey P. Machado, 2-Aug-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  impsingle-step20 $p |- ( ( ( ( ph -> ps ) -> ps ) -> ( ch -> ps ) )
                          -> ( ( ( ps -> th ) -> ph ) -> ( ch -> ps ) ) ) $=
    ( wta wze wsi wrh wet wi impsingle-step19 impsingle impsingle-step8 ax-mp )
    CBJZDJZABJZJZBDJAJZOJZJZQBJZOJZTJZCBDAKEFJGJGEJHEJJJZUAUDJZEFGHLTIJZRJZUFJZ
    UEUFJZTIRUCLUFRJUHJZUIUJJRUDJUFJZUKUDQJRJZULUBUDJZUMOEJZUBJUDJUNOEUBSLUOUBU
    DMNQBUDPLNUDQRUALNRUDUFUGLNUFRUHUELNNNN $.

  $( Derivation of impsingle-step21 from ~ ax-mp and ~ impsingle .  It is used
     as a lemma in the proof of ~ imim1 from ~ impsingle .  It is Step 21 in
     Lukasiewicz, where it appears as 'CCCCprqqCCqrCpr' using parenthesis-free
     prefix notation.  (Contributed by Larry Lesyna and Jeffrey P. Machado,
     2-Aug-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  impsingle-step21 $p |- ( ( ( ( ph -> ps ) -> ch ) -> ch )
                           -> ( ( ch -> ps ) -> ( ph -> ps ) ) ) $=
    ( wi impsingle-step15 impsingle-step20 ax-mp ) CABDZDHDCBDZHDZDHCDCDJDCHABE
    CHICFG $.

  $( Derivation of impsingle-step22 from ~ ax-mp and ~ impsingle .  It is used
     as a lemma in proofs of ~ imim1 and ~ peirce from ~ impsingle .  It is
     Step 22 in Lukasiewicz, where it appears as 'Cpp' using parenthesis-free
     prefix notation.  (Contributed by Larry Lesyna and Jeffrey P. Machado,
     2-Aug-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  impsingle-step22 $p |- ( ph -> ph ) $=
    ( wth wmu wla wps wi impsingle-step4 impsingle ax-mp ) BCFBFDBFFZAAFZBCDGAE
    FZAFZKFZJKFZAEAGKAFMFNOFAALGKAMJHIII $.

  $( Derivation of impsingle-step25 from ~ ax-mp and ~ impsingle .  It is used
     as a lemma in the proof of ~ imim1 from ~ impsingle .  It is Step 25 in
     Lukasiewicz, where it appears as 'CCpqCCCprqq' using parenthesis-free
     prefix notation.  (Contributed by Larry Lesyna and Jeffrey P. Machado,
     2-Aug-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  impsingle-step25 $p |- ( ( ph -> ps )
                         -> ( ( ( ph -> ch ) -> ps ) -> ps ) ) $=
    ( wth wi impsingle-step22 impsingle-step20 impsingle-step8 impsingle-step15
    ax-mp ) ACEZKBEZBEZEZABEMEBDEZKEMEZNMMEPMFKBLDGJOKMHJACLBIJ $.

  $( Derivation of impsingle-imim1 ( ~ imim1 ) from ~ ax-mp and ~ impsingle .
     It is step 29 in Lukasiewicz.  (Contributed by Larry Lesyna and Jeffrey P.
     Machado, 2-Aug-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  impsingle-imim1 $p |- ( ( ph -> ps )
                          -> ( ( ps -> ch ) -> ( ph -> ch ) ) ) $=
    ( wi impsingle-step21 impsingle-step25 ax-mp ) ACDZBDBDZBCDHDZDZABDZJDZACBE
    MIDIDZKMDLIDNABCFLIJFGLJIEGG $.

  $( Derivation of impsingle-peirce ( ~ peirce ) from ~ ax-mp and ~ impsingle .
     It is step 28 in Lukasiewicz.  (Contributed by Larry Lesyna and Jeffrey P.
     Machado, 2-Aug-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  impsingle-peirce $p |- ( ( ( ph -> ps ) -> ph ) -> ph ) $=
    ( wi impsingle-step22 impsingle-step25 ax-mp ) AACABCACACADAABEF $.

  $( Derivation of ~ ax-2 from the Tarski-Bernays axiom set { ~ ax-1 ,
     ~ imim1 , ~ peirce }.  Note that no inference rule other than ~ ax-mp is
     used in this proof.  This proof establishes a circle of equivalence:  From
     { ~ impsingle }, { ~ ax-1 , ~ imim1 , ~ peirce } was proved.  From {
     ~ ax-1 , ~ imim1 , ~ peirce }, { ~ ax-1 , ~ ax-2 and ~ peirce } was
     proved.  From { ~ ax-1 , ~ ax-2 and ~ peirce }, { ~ impsingle } was
     proved.  Therefore, the theorems that can be proved by selecting any one
     of these three distinct axiom sets must be equivalent.  Prover9 and mmj2
     were used to help constuct this proof.  (Contributed by Larry Lesyna and
     Jeffrey P. Machado, 1-Aug-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  tarski-bernays-ax2 $p |- ( ( ph -> ( ps -> ch ) )
                             -> ( ( ph -> ps ) -> ( ph -> ch ) ) ) $=
    ( wi peirce ax-1 ax-mp imim1 ) ABDZABCDZDZACDZDZDZKILDZDZJLDZMDZNKQLDZDZRJC
    DZLDZSDZTQUBLDZDZUCLCDZUADZUDDZUEUBUFLDZDZUDDZUHUILDZUDDZUDDZUKUMUNDZUNUMUL
    DZUOULUPLCEULUMFGUMULUDHGUNUDDUNDZUNDZUOUNDZUNUDEUOUQDURUSDUMUNUDHUOUQUNHGG
    GUJUMDUNUKDUBUILHUJUMUDHGGUGUJDUKUHDUFUALHUGUJUDHGGQUGDUHUEDJLCHQUGUDHGGUBU
    DLDZDZUEUCDZUDUBDZUTDZVAUDUTDZUTDZVDUTLDUTDZUTDZVFUTLEVEVGDVHVFDUDUTLHVEVGU
    THGGVCVEDVFVDDUDUBLHVCVEUTHGGUBVCDVDVADUBUDFUBVCUTHGGUTSDZUCDZVBDZVAVBDZUEV
    IDVKQUDLHUEVIUCHGVAVJDVKVLDUBUTSHVAVJVBHGGGGKUBDUCTDAJCHKUBSHGGQSLDZDZTRDZS
    QDZVMDZVNSVMDZVMDZVQVMLDVMDZVMDZVSVMLEVRVTDWAVSDSVMLHVRVTVMHGGVPVRDVSVQDSQL
    HVPVRVMHGGQVPDVQVNDQSFQVPVMHGGVMMDZRDZVODZVNVODZTWBDWDKSLHTWBRHGVNWCDWDWEDQ
    VMMHVNWCVOHGGGGIQDRNDABCHIQMHGGKMLDZDZNPDZMKDZWFDZWGMWFDZWFDZWJWFLDWFDZWFDZ
    WLWFLEWKWMDWNWLDMWFLHWKWMWFHGGWIWKDWLWJDMKLHWIWKWFHGGKWIDWJWGDKMFKWIWFHGGWF
    ODZPDZWHDZWGWHDZNWODWQIMLHNWOPHGWGWPDWQWRDKWFOHWGWPWHHGGGG $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Derive the Lukasiewicz axioms from Meredith's sole axiom
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( Carew Meredith's sole axiom for propositional calculus.  This amazing
     formula is thought to be the shortest possible single axiom for
     propositional calculus with inference rule ~ ax-mp , where negation and
     implication are primitive.  Here we prove Meredith's axiom from ~ ax-1 ,
     ~ ax-2 , and ~ ax-3 .  Then from it we derive the Lukasiewicz axioms
     ~ luk-1 , ~ luk-2 , and ~ luk-3 .  Using these we finally rederive our
     axioms as ~ ax1 , ~ ax2 , and ~ ax3 , thus proving the equivalence of all
     three systems.  C. A. Meredith, "Single Axioms for the Systems (C,N),
     (C,O) and (A,N) of the Two-Valued Propositional Calculus", _The Journal of
     Computing Systems_ vol. 1 (1953), pp. 155-164.  Meredith claimed to be
     close to a proof that this axiom is the shortest possible, but the proof
     was apparently never completed.

     An obscure Irish lecturer, Meredith (1904-1976) became enamored with logic
     somewhat late in life after attending talks by Lukasiewicz and produced
     many remarkable results such as this axiom.  From his obituary:  "He did
     logic whenever time and opportunity presented themselves, and he did it on
     whatever materials came to hand: in a pub, his favored pint of porter
     within reach, he would use the inside of cigarette packs to write proofs
     for logical colleagues."  (Contributed by NM, 14-Dec-2002.)  (Proof
     shortened by Andrew Salmon, 25-Jul-2011.)  (Proof shortened by Wolf
     Lammen, 28-May-2013.) $)
  meredith $p |- ( ( ( ( ( ph -> ps ) -> ( -. ch -> -. th ) ) -> ch ) ->
       ta ) -> ( ( ta -> ph ) -> ( th -> ph ) ) ) $=
    ( wi wn pm2.21 con4 imim12i com13 con1d com12 a1d ax-1 imim1d ja ) ABFZCGDG
    FZFZCFZEEAFZDAFZFUAGZUCUBDUDADAUATAGZDCUERSDCFABHCDIJKLMNEDEAEDOPQ $.

  $( Step 3 of Meredith's proof of Lukasiewicz axioms from his sole axiom.
     (The step numbers refer to Meredith's original paper.)  (Contributed by
     NM, 14-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  merlem1 $p |- ( ( ( ch -> ( -. ph -> ps ) ) -> ta ) -> ( ph -> ta ) ) $=
    ( wn wi meredith ax-mp ) DAEZFIBFZEZIFFZJFCJFZFZMDFADFFJDECEFZEKEFZFOFDFLFN
    IBOKDGJPDCLGHDIJAMGH $.

  $( Step 4 of Meredith's proof of Lukasiewicz axioms from his sole axiom.
     (Contributed by NM, 14-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  merlem2 $p |- ( ( ( ph -> ph ) -> ch ) -> ( th -> ch ) ) $=
    ( wi wn merlem1 meredith ax-mp ) BBDZAECEZDDADAADZDKBDCBDDAJIAFBBACKGH $.

  $( Step 7 of Meredith's proof of Lukasiewicz axioms from his sole axiom.
     (Contributed by NM, 14-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  merlem3 $p |- ( ( ( ps -> ch ) -> ph ) -> ( ch -> ph ) ) $=
    ( wi wn merlem2 ax-mp meredith ) AADZCEZJDZDZCDBCDZDZMADCADZDOBEZPDDBDZLDZN
    KKDLDRJKIFKLQFGCABBLHGAACCMHG $.

  $( Step 8 of Meredith's proof of Lukasiewicz axioms from his sole axiom.
     (Contributed by NM, 14-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  merlem4 $p |- ( ta -> ( ( ta -> ph ) -> ( th -> ph ) ) ) $=
    ( wi wn meredith merlem3 ax-mp ) AADBEZIDDBDZCDCADBADDZDCKDAABBCFKJCGH $.

  $( Step 11 of Meredith's proof of Lukasiewicz axioms from his sole axiom.
     (Contributed by NM, 14-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  merlem5 $p |- ( ( ph -> ps ) -> ( -. -. ph -> ps ) ) $=
    ( wi wn meredith merlem1 merlem4 ax-mp ) BBCZBDZJCCBCBCIICCZABCZADZDZBCCZBB
    BBBEIJNDCCBCZACZOCZKOCZBBBNAEOKDZCMTCCZACQCZRSCUAUBMBLTFAPUAGHOTAKQEHHH $.

  $( Step 12 of Meredith's proof of Lukasiewicz axioms from his sole axiom.
     (Contributed by NM, 14-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  merlem6 $p |- ( ch -> ( ( ( ps -> ch ) -> ph ) -> ( th -> ph ) ) ) $=
    ( wi merlem4 merlem3 ax-mp ) BCEZIAEDAEEZECJEADIFJBCGH $.

  $( Between steps 14 and 15 of Meredith's proof of Lukasiewicz axioms from his
     sole axiom.  (Contributed by NM, 22-Dec-2002.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merlem7 $p |- ( ph -> ( ( ( ps -> ch ) -> th ) -> ( ( ( ch -> ta ) ->
                  ( -. th -> -. ps ) ) -> th ) ) ) $=
    ( wi wn merlem4 merlem6 meredith ax-mp ) BCFZLDFZCEFDGBGFFZDFZFZFZAPFZDNLHP
    AGZFCGZSFFZCFLFZQRFOUAFUBSMOTICEDBUAJKPSCALJKK $.

  $( Step 15 of Meredith's proof of Lukasiewicz axioms from his sole axiom.
     (Contributed by NM, 22-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  merlem8 $p |- ( ( ( ps -> ch ) -> th ) -> ( ( ( ch -> ta ) ->
                  ( -. th -> -. ps ) ) -> th ) ) $=
    ( wph wi wn meredith merlem7 ax-mp ) EEFZEGZLFFEFEFKKFFZABFCFBDFCGAGFFCFFEE
    EEEHMABCDIJ $.

  $( Step 18 of Meredith's proof of Lukasiewicz axioms from his sole axiom.
     (Contributed by NM, 22-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  merlem9 $p |- ( ( ( ph -> ps ) -> ( ch -> ( th -> ( ps -> ta ) ) ) ) ->
                    ( et -> ( ch -> ( th -> ( ps -> ta ) ) ) ) ) $=
    ( wi wn merlem6 merlem8 ax-mp meredith ) CDBEGZGZGZFHZGBHZPGGZBGABGZGZSOGFO
    GGMRHDHGZHAHGZGUAGRGZTNRGUCPCNQIDMRUBJKBEUAARLKOPBFSLK $.

  $( Step 19 of Meredith's proof of Lukasiewicz axioms from his sole axiom.
     (Contributed by NM, 14-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  merlem10 $p |- ( ( ph -> ( ph -> ps ) ) -> ( th -> ( ph -> ps ) ) ) $=
    ( wi wn meredith merlem9 ax-mp ) AADZAEZJDDADADIIDDZAABDZDZCLDDZAAAAAFLADJC
    EDDADZADNDKNDLAACAFOAMCBKGHH $.

  $( Step 20 of Meredith's proof of Lukasiewicz axioms from his sole axiom.
     (Contributed by NM, 14-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  merlem11 $p |- ( ( ph -> ( ph -> ps ) ) -> ( ph -> ps ) ) $=
    ( wi wn meredith merlem10 ax-mp ) AACZADZICCACACHHCCZAABCZCZKCZAAAAAELMCJMC
    ABLFLKJFGG $.

  $( Step 28 of Meredith's proof of Lukasiewicz axioms from his sole axiom.
     (Contributed by NM, 14-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  merlem12 $p |- ( ( ( th -> ( -. -. ch -> ch ) ) -> ph ) -> ph ) $=
    ( wn wi merlem5 merlem2 ax-mp merlem4 merlem11 ) CBDDBEZEZAEZMAEZEZNLOBBEKE
    LBBFBKCGHAMLIHMAJH $.

  $( Step 35 of Meredith's proof of Lukasiewicz axioms from his sole axiom.
     (Contributed by NM, 14-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  merlem13 $p |- ( ( ph -> ps ) ->
              ( ( ( th -> ( -. -. ch -> ch ) ) -> -. -. ph ) -> ps ) ) $=
    ( wi wn merlem12 merlem5 ax-mp merlem6 meredith merlem11 ) BBEZAFZDCFFCEEZN
    FZEZFZEZEAEZAEZABEQBEETUAEZUASUBOREZREZSRCDGRBEZRFPEZEREUCEZUDSEUFUGQPEUFPC
    DGQPHIRUEUFOJIRBRNUCKIIAMSTJITALIBBAQAKI $.

  $( 1 of 3 axioms for propositional calculus due to Lukasiewicz, derived from
     Meredith's sole axiom.  (Contributed by NM, 14-Dec-2002.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  luk-1 $p |- ( ( ph -> ps ) -> ( ( ps -> ch ) -> ( ph -> ch ) ) ) $=
    ( wi wn meredith merlem13 ax-mp ) CCDZAEZEZEJDDKDBDZBCDACDDZDZABDZMDZCCKABF
    MADZOEZEZERDDSDLDZNPDOLDTABJIGOLRQGHMASOLFHH $.

  $( 2 of 3 axioms for propositional calculus due to Lukasiewicz, derived from
     Meredith's sole axiom.  (Contributed by NM, 14-Dec-2002.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  luk-2 $p |- ( ( -. ph -> ph ) -> ph ) $=
    ( wn wi merlem5 merlem4 ax-mp merlem11 meredith ) ABZACZJACZCZKAJBZCIBMCCZI
    CZICZLOPCZPNQAMDIONEFOIGFAMIJIHFJAGF $.

  $( 3 of 3 axioms for propositional calculus due to Lukasiewicz, derived from
     Meredith's sole axiom.  (Contributed by NM, 14-Dec-2002.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  luk-3 $p |- ( ph -> ( -. ph -> ps ) ) $=
    ( wn wi merlem11 merlem1 ax-mp ) ACZHBDZDIDAIDHBEABHIFG $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Derive the standard axioms from the Lukasiewicz axioms
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  ${
    luklem1.1 $e |- ( ph -> ps ) $.
    luklem1.2 $e |- ( ps -> ch ) $.
    $( Used to rederive standard propositional axioms from Lukasiewicz'.
       (Contributed by NM, 23-Dec-2002.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    luklem1 $p |- ( ph -> ch ) $=
      ( wi luk-1 ax-mp ) BCFZACFZEABFIJFDABCGHH $.
  $}

  $( Used to rederive standard propositional axioms from Lukasiewicz'.
     (Contributed by NM, 22-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  luklem2 $p |- ( ( ph -> -. ps ) ->
                ( ( ( ph -> ch ) -> th ) -> ( ps -> th ) ) ) $=
    ( wn wi luk-1 luk-3 ax-mp luklem1 ) ABEZFZBACFZFZMDFBDFFLKCFZMFZNAKCGBOFPNF
    BCHBOMGIJBMDGJ $.

  $( Used to rederive standard propositional axioms from Lukasiewicz'.
     (Contributed by NM, 22-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  luklem3 $p |- ( ph -> ( ( ( -. ph -> ps ) -> ch ) -> ( th -> ch ) ) ) $=
    ( wn wi luk-3 luklem2 luklem1 ) AAEZDEZFJBFCFDCFFAKGJDBCHI $.

  $( Used to rederive standard propositional axioms from Lukasiewicz'.
     (Contributed by NM, 22-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  luklem4 $p |- ( ( ( ( -. ph -> ph ) -> ph ) -> ps ) -> ps ) $=
    ( wn wi luk-2 luklem3 ax-mp luk-1 luklem1 ) ACADADZBDZBCZBDZBLJDZKMDJCJDJDZ
    NJEJONDAEJJJLFGGLJBHGBEI $.

  $( Used to rederive standard propositional axioms from Lukasiewicz'.
     (Contributed by NM, 22-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  luklem5 $p |- ( ph -> ( ps -> ph ) ) $=
    ( wn wi luklem3 luklem4 luklem1 ) AACADADBADZDHAAABEAHFG $.

  $( Used to rederive standard propositional axioms from Lukasiewicz'.
     (Contributed by NM, 22-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  luklem6 $p |- ( ( ph -> ( ph -> ps ) ) -> ( ph -> ps ) ) $=
    ( wi luk-1 wn luklem5 luklem2 luklem4 luklem1 ax-mp ) AABCZCKBCZKCZKAKBDKEZ
    KCZKCMKCZCZPMOCZQNLCRNBEZNCZLNSFTSBCBCLCLSKBBGBLHIINLKDJMOKDJKPHJI $.

  $( Used to rederive standard propositional axioms from Lukasiewicz'.
     (Contributed by NM, 22-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  luklem7 $p |- ( ( ph -> ( ps -> ch ) ) -> ( ps -> ( ph -> ch ) ) ) $=
    ( wi luk-1 luklem5 luklem1 luklem6 ax-mp ) ABCDZDJCDZACDZDZBLDZAJCEBKDMNDBJ
    KDZKBJBDOBJFJBCEGJCHGBKLEIG $.

  $( Used to rederive standard propositional axioms from Lukasiewicz'.
     (Contributed by NM, 22-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  luklem8 $p |- ( ( ph -> ps ) -> ( ( ch -> ph ) -> ( ch -> ps ) ) ) $=
    ( wi luk-1 luklem7 ax-mp ) CADZABDZCBDZDDIHJDDCABEHIJFG $.

  $( Standard propositional axiom derived from Lukasiewicz axioms.
     (Contributed by NM, 22-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  ax1 $p |- ( ph -> ( ps -> ph ) ) $=
    ( luklem5 ) ABC $.

  $( Standard propositional axiom derived from Lukasiewicz axioms.
     (Contributed by NM, 22-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  ax2 $p |- ( ( ph -> ( ps -> ch ) ) -> ( ( ph -> ps ) -> ( ph -> ch ) ) ) $=
    ( wi luklem7 luklem8 luklem6 ax-mp luklem1 ) ABCDDBACDZDZABDZJDZABCEKLAJDZD
    ZMBJAFNJDOMDACGNJLFHII $.

  $( Standard propositional axiom derived from Lukasiewicz axioms.
     (Contributed by NM, 22-Dec-2002.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  ax3 $p |- ( ( -. ph -> -. ps ) -> ( ps -> ph ) ) $=
    ( wn wi luklem2 luklem4 luklem1 ) ACZBCDHADADBADZDIHBAAEAIFG $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Derive Nicod's axiom from the standard axioms
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  Prove Nicod's axiom and implication and negation definitions.

$)

  $( This theorem "defines" implication in terms of 'nand'.  Analogous to
     ~ nanim .  In a pure (standalone) treatment of Nicod's axiom, this theorem
     would be changed to a definition ($a statement).  (Contributed by NM,
     11-Dec-2008.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  nic-dfim $p |- ( ( ( ph -/\ ( ps -/\ ps ) ) -/\ ( ph -> ps ) ) -/\
                   ( ( ( ph -/\ ( ps -/\ ps ) ) -/\ ( ph -/\ ( ps -/\ ps ) ) )
                                   -/\ ( ( ph -> ps ) -/\ ( ph -> ps ) ) ) ) $=
    ( wnan wi wb nanim bicomi nanbi mpbi ) ABBCCZABDZEJKCJJCKKCCCKJABFGJKHI $.

  $( This theorem "defines" negation in terms of 'nand'.  Analogous to
     ~ nannot .  In a pure (standalone) treatment of Nicod's axiom, this
     theorem would be changed to a definition ($a statement).  (Contributed by
     NM, 11-Dec-2008.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  nic-dfneg $p |- ( ( ( ph -/\ ph ) -/\ -. ph ) -/\
           ( ( ( ph -/\ ph ) -/\ ( ph -/\ ph ) ) -/\ ( -. ph -/\ -. ph ) ) ) $=
    ( wnan wn wb nannot bicomi nanbi mpbi ) AABZACZDIJBIIBJJBBBJIAEFIJGH $.

  ${
    $( Minor premise. $)
    nic-jmin $e |- ph $.
    $( Major premise. $)
    nic-jmaj $e |- ( ph -/\ ( ch -/\ ps ) ) $.
    $( Derive Nicod's rule of modus ponens using 'nand', from the standard one.
       Although the major and minor premise together also imply ` ch ` , this
       form is necessary for useful derivations from ~ nic-ax .  In a pure
       (standalone) treatment of Nicod's axiom, this theorem would be changed
       to an axiom ($a statement).  (Contributed by Jeff Hoffman, 19-Nov-2007.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    nic-mp $p |- ps $=
      ( wnan wa wi nannan mpbi simprd ax-mp ) ABDACBACBFFACBGHEACBIJKL $.

    $( A direct proof of ~ nic-mp .  (Contributed by NM, 30-Dec-2008.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    nic-mpALT $p |- ps $=
      ( wa wi wn wnan df-nan anbi2i xchbinx mpbi iman mpbir simprd ax-mp ) ABDA
      CBACBFZGARHZFZHZACBIZIZUAEUCAUBFTAUBJUBSACBJKLMARNOPQ $.
  $}

  $( Nicod's axiom derived from the standard ones.  See _Introduction to
     Mathematical Philosophy_ by B. Russell, p. 152.  Like ~ meredith , the
     usual axioms can be derived from this and vice versa.  Unlike ~ meredith ,
     Nicod uses a different connective ('nand'), so another form of modus
     ponens must be used in proofs, e.g., ` { ` ~ nic-ax , ~ nic-mp ` } ` is
     equivalent to ` { ` ~ luk-1 , ~ luk-2 , ~ luk-3 , ~ ax-mp ` } ` .  In a
     pure (standalone) treatment of Nicod's axiom, this theorem would be
     changed to an axiom ($a statement).  (Contributed by Jeff Hoffman,
     19-Nov-2007.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  nic-ax $p |- ( ( ph -/\ ( ch -/\ ps ) ) -/\ ( ( ta -/\ ( ta -/\ ta ) ) -/\
               ( ( th -/\ ch ) -/\ ( ( ph -/\ th ) -/\ ( ph -/\ th ) ) ) ) ) $=
    ( wnan wa wi nannan biimpi simpl imim2i wn imnan df-nan bitr4i imim2d con2b
    con3 mpbir 3bitr4ri imbitrrdi biimtrrid nanim sylib 3syl pm4.24 jctil ) ACB
    FFZEEEFFZDCFZADFZULFFZFFUIUJUMGHUIUMUJUIACBGZHZACHZUMUIUOACBIJUNCACBKLUPUKU
    LHUMUKDCMZHZUPULURDCGMUKDCNDCOPUPURDAMZHZULUPUQUSDACSQADMHADGMUTULADNDARADO
    UAUBUCUKULUDUEUFUJEEEGZHEVAEUGJEEEITUHUIUJUMIT $.

  $( A direct proof of ~ nic-ax .  (Contributed by NM, 11-Dec-2008.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  nic-axALT $p |- ( ( ph -/\ ( ch -/\ ps ) ) -/\ ( ( ta -/\ ( ta -/\ ta ) )
           -/\ ( ( th -/\ ch ) -/\ ( ( ph -/\ th ) -/\ ( ph -/\ th ) ) ) ) ) $=
    ( wnan wa wn anidm df-nan anbi2i notbii iman 3bitr4i bitr4i xchbinx anbi12i
    wi imnan mpbir simpl imim2i con3 imim2d biimpri jctil con2b bitr3i 3bitri
    syl ) ACBFZFZEEEFZFZDCFZADFZUPFZFZFZFULUSGZHZVAACBGZRZEEEGZRZDCHZRZDAHZRZRZ
    GZRZVCVJVEVCACRZVJVBCACBUAUBVMVFVHDACUCUDUJVDEEIUEUFVAVCVKHZGZHVLUTVOULVCUS
    VNAUKGZHAVBHZGZHULVCVPVRUKVQACBJKLAUKJAVBMNUSUNURGVKUNURJUNVEURVJEUMGZHEVDH
    ZGZHUNVEVSWAUMVTEEEJKLEUMJEVDMNUOUQGZHVGVIHZGZHURVJWBWDUOVGUQWCUODCGHVGDCJD
    CSOUQUPUPGZVIUPUPJWEUPADGHZVIUPIADJWFADHRVIADSADUGUHUIPQLUOUQJVGVIMNQPQLVCV
    KMOTULUSJT $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Derive the Lukasiewicz axioms from Nicod's axiom
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  ${
    $( Minor premise. $)
    nic-imp.1 $e |- ( ph -/\ ( ch -/\ ps ) ) $.
    $( Inference for ~ nic-mp using ~ nic-ax as major premise.  (Contributed by
       Jeff Hoffman, 17-Nov-2007.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    nic-imp $p |- ( ( th -/\ ch ) -/\ ( ( ph -/\ th ) -/\ ( ph -/\ th ) ) ) $=
      ( wta wnan nic-ax nic-mp ) ACBGGDCGADGZJGGFFFGGEABCDFHI $.
  $}

  $( Lemma for ~ nic-id .  (Contributed by Jeff Hoffman, 17-Nov-2007.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  nic-idlem1 $p |- ( ( th -/\ ( ta -/\ ( ta -/\ ta ) ) ) -/\
                 ( ( ( ph -/\ ( ch -/\ ps ) ) -/\ th ) -/\
                   ( ( ph -/\ ( ch -/\ ps ) ) -/\ th ) ) ) $=
    ( wnan nic-ax nic-imp ) ACBFFACFAAFZIFFEEEFFDABCAEGH $.

  ${
    nic-idlem2.1 $e |- ( et -/\ ( ( ph -/\ ( ch -/\ ps ) ) -/\ th ) ) $.
    $( Lemma for ~ nic-id .  Inference used by ~ nic-id .  (Contributed by Jeff
       Hoffman, 17-Nov-2007.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    nic-idlem2 $p |- ( ( th -/\ ( ta -/\ ( ta -/\ ta ) ) ) -/\ et ) $=
      ( wnan nic-ax nic-imp nic-mp ) FACBHHZDHZHDEEEHHZHZFHZPGOMMFLACHAAHZQHHND
      ABCAEIJJK $.
  $}

  $( Theorem ~ id expressed with ` -/\ ` .  (Contributed by Jeff Hoffman,
     17-Nov-2007.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  nic-id $p |- ( ta -/\ ( ta -/\ ta ) ) $=
    ( wph wps wch wth wnan nic-ax nic-idlem2 nic-idlem1 nic-mp ) BCFZCBFZLFFZDD
    DFZFZFZCCCFFZFAAAFFZOEEEMDQCCCBEGHMNDPCORFKLLOAIHJ $.

  $( The connector ` -/\ ` is symmetric.  (Contributed by Jeff Hoffman,
     17-Nov-2007.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  nic-swap $p |- ( ( th -/\ ph ) -/\ ( ( ph -/\ th ) -/\ ( ph -/\ th ) ) ) $=
    ( wta wnan nic-id nic-ax nic-mp ) AAADDBADABDZHDDCCCDDAEAAABCFG $.

  ${
    nic-isw1.1 $e |- ( th -/\ ph ) $.
    $( Inference version of ~ nic-swap .  (Contributed by Jeff Hoffman,
       17-Nov-2007.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    nic-isw1 $p |- ( ph -/\ th ) $=
      ( wnan nic-swap nic-mp ) BADABDZGCABEF $.
  $}

  ${
    nic-isw2.1 $e |- ( ps -/\ ( th -/\ ph ) ) $.
    $( Inference for swapping nested terms.  (Contributed by Jeff Hoffman,
       17-Nov-2007.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    nic-isw2 $p |- ( ps -/\ ( ph -/\ th ) ) $=
      ( wnan nic-swap nic-imp nic-mp nic-isw1 ) BACEZBCAEZEJBEZLDJKKBCAFGHI $.
  $}

  ${
    nic-iimp1.1 $e |- ( ph -/\ ( ch -/\ ps ) ) $.
    nic-iimp1.2 $e |- ( th -/\ ch ) $.
    $( Inference version of ~ nic-imp using right-handed term.  (Contributed by
       Jeff Hoffman, 17-Nov-2007.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    nic-iimp1 $p |- ( th -/\ ph ) $=
      ( wnan nic-imp nic-mp nic-isw1 ) DADCGADGZKFABCDEHIJ $.
  $}

  ${
    nic-iimp2.1 $e |- ( ( ph -/\ ps ) -/\ ( ch -/\ ch ) ) $.
    nic-iimp2.2 $e |- ( th -/\ ph ) $.
    $( Inference version of ~ nic-imp using left-handed term.  (Contributed by
       Jeff Hoffman, 17-Nov-2007.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    nic-iimp2 $p |- ( th -/\ ( ch -/\ ch ) ) $=
      ( wnan nic-isw1 nic-iimp1 ) CCGZBADJABGEHFI $.
  $}

  ${
    nic-idel.1 $e |- ( ph -/\ ( ch -/\ ps ) ) $.
    $( Inference to remove the trailing term.  (Contributed by Jeff Hoffman,
       17-Nov-2007.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    nic-idel $p |- ( ph -/\ ( ch -/\ ch ) ) $=
      ( wnan nic-id nic-isw1 nic-imp nic-mp ) CCEZCEAJEZKJCCFGABCJDHI $.
  $}

  ${
    nic-ich.1 $e |- ( ph -/\ ( ps -/\ ps ) ) $.
    nic-ich.2 $e |- ( ps -/\ ( ch -/\ ch ) ) $.
    $( Chained inference.  (Contributed by Jeff Hoffman, 17-Nov-2007.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    nic-ich $p |- ( ph -/\ ( ch -/\ ch ) ) $=
      ( wnan nic-isw1 nic-imp nic-mp ) CCFZBFAJFZKJBEGABBJDHI $.
  $}

  ${
    nic-idbl.1 $e |- ( ph -/\ ( ps -/\ ps ) ) $.
    $( Double the terms.  Since doubling is the same as negation, this can be
       viewed as a contraposition inference.  (Contributed by Jeff Hoffman,
       17-Nov-2007.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    nic-idbl $p |- ( ( ps -/\ ps ) -/\ ( ( ph -/\ ph ) -/\ ( ph -/\ ph ) ) ) $=
      ( wnan nic-imp nic-ich ) BBDABDAADABBBCEABBACEF $.
  $}

  $( Biconditional justification from Nicod's axiom.  For nic-* definitions,
     the biconditional connective is not used.  Instead, definitions are made
     based on this form. ~ nic-bi1 and ~ nic-bi2 are used to convert the
     definitions into usable theorems about one side of the implication.
     (Contributed by Jeff Hoffman, 18-Nov-2007.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  nic-bijust $p |- ( ( ta -/\ ta ) -/\ ( ( ta -/\ ta ) -/\ ( ta -/\ ta ) ) ) $=
    ( nic-swap ) AAB $.

  ${
    $( 'Biconditional' premise. $)
    nic-bi1.1 $e |- ( ( ph -/\ ps ) -/\ ( ( ph -/\ ph )
         -/\ ( ps -/\ ps ) ) ) $.
    $( Inference to extract one side of an implication from a definition.
       (Contributed by Jeff Hoffman, 18-Nov-2007.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    nic-bi1 $p |- ( ph -/\ ( ps -/\ ps ) ) $=
      ( wnan nic-id nic-iimp1 nic-isw2 nic-idel ) AABBAAABDBBDAADACAEFGH $.
  $}

  ${
    $( 'Biconditional' premise. $)
    nic-bi2.1 $e |- ( ( ph -/\ ps ) -/\ ( ( ph -/\ ph )
         -/\ ( ps -/\ ps ) ) ) $.
    $( Inference to extract the other side of an implication from a
       'biconditional' definition.  (Contributed by Jeff Hoffman, 18-Nov-2007.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    nic-bi2 $p |- ( ps -/\ ( ph -/\ ph ) ) $=
      ( wnan nic-isw2 nic-id nic-iimp1 nic-idel ) BBAABDZAADZBBDZBKIJCEBFGH $.
  $}

  ${
    $( Minor premise. $)
    nic-smin $e |- ph $.
    $( Major premise. $)
    nic-smaj $e |- ( ph -> ps ) $.
    $( Derive the standard modus ponens from ~ nic-mp .  (Contributed by Jeff
       Hoffman, 18-Nov-2007.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    nic-stdmp $p |- ps $=
      ( wi wnan nic-dfim nic-bi2 nic-mp ) ABBCABEZABBFFZKDKJABGHII $.
  $}

  $( Proof of ~ luk-1 from ~ nic-ax and ~ nic-mp (and Definitions ~ nic-dfim
     and ~ nic-dfneg ).  Note that the standard axioms ~ ax-1 , ~ ax-2 , and
     ~ ax-3 are proved from the Lukasiewicz axioms by Theorems ~ ax1 , ~ ax2 ,
     and ~ ax3 .  (Contributed by Jeff Hoffman, 18-Nov-2007.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  nic-luk1 $p |- ( ( ph -> ps ) -> ( ( ps -> ch ) -> ( ph -> ch ) ) ) $=
    ( wta wi nic-dfim nic-bi2 nic-ax nic-isw2 nic-idel nic-bi1 nic-idbl nic-imp
    wnan nic-swap nic-ich nic-mp ) ABEZBCEZACEZEZUANNZRUAEZUCRABBNNZUAUDRABFGUD
    STTNZNZUAUDCCNZBNZAUGNZUINZNZUFUDDDDNNZUKUKUDULABBUGDHIJUKUEUHNUFUEUJUJUHUI
    TUITACFKLMSUHUHUESBUGNZUHUMSBCFGUGBOPMPPUFUASTFKPPUBUCRUAFKQ $.

  $( Proof of ~ luk-2 from ~ nic-ax and ~ nic-mp .  (Contributed by Jeff
     Hoffman, 18-Nov-2007.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  nic-luk2 $p |- ( ( -. ph -> ph ) -> ph ) $=
    ( wn wi wnan nic-dfim nic-bi2 nic-dfneg nic-iimp1 nic-isw2 nic-isw1 nic-bi1
    nic-id nic-mp ) ABZACZAADZDZOACZROPONPDZSPSONAEFNPPPNDNNDPPDPAGPLHIHJQROAEK
    M $.

  $( Proof of ~ luk-3 from ~ nic-ax and ~ nic-mp .  (Contributed by Jeff
     Hoffman, 18-Nov-2007.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  nic-luk3 $p |- ( ph -> ( -. ph -> ps ) ) $=
    ( wnan nic-dfim nic-bi1 nic-dfneg nic-bi2 nic-id nic-iimp1 nic-iimp2 nic-mp
    wn wi ) AALZBMZOCCZAOMZQNBBCZOANRCONBDENAACZSASNAFGAHIJPQAODEK $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Derive Nicod's Axiom from Lukasiewicz's First Sheffer Stroke Axiom
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( This alternative axiom for propositional calculus using the Sheffer Stroke
     was discovered by Lukasiewicz in his Selected Works.  It improves on
     Nicod's axiom by reducing its number of variables by one.

     This axiom also uses ~ nic-mp for its constructions.

     Here, the axiom is proved as a substitution instance of ~ nic-ax .
     (Contributed by Anthony Hart, 31-Jul-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  lukshef-ax1 $p |- ( ( ph -/\ ( ch -/\ ps ) ) -/\ ( ( th -/\ ( th -/\ th ) )
          -/\ ( ( th -/\ ch ) -/\ ( ( ph -/\ th ) -/\ ( ph -/\ th ) ) ) ) ) $=
    ( nic-ax ) ABCDDE $.

  $( Lemma for ~ renicax .  (Contributed by NM, 31-Jul-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  lukshefth1 $p |- ( ( ( ( ta -/\ ps ) -/\ ( ( ph -/\ ta ) -/\ ( ph
          -/\ ta ) ) ) -/\ ( th -/\ ( th -/\ th ) ) ) -/\ ( ph -/\ ( ps
          -/\ ch ) ) ) $=
    ( wnan lukshef-ax1 nic-mp ) ABCFFZEEEFFZEBFAEFZKFFZFZFZLDDDFFZFZIFZQACBEGPM
    MFFZNQQFFIIIFFJODEFEDFZSFFZFFRLLLFFEEEDGJTOLGHPMMIGHH $.

  $( Lemma for ~ renicax .  (Contributed by NM, 31-Jul-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  lukshefth2 $p |- ( ( ta -/\ th ) -/\ ( ( th -/\ ta ) -/\ ( th
          -/\ ta ) ) ) $=
    ( wps wch wph wnan lukshef-ax1 nic-mp lukshefth1 ) AAAFFZBAFABFZKFFBBBFFAJF
    ZCDEFFZAFZNFFZJBEFEBFZPFFZMJADFCAFZRFFZFFOJCEDAGMSJAGHQJFZEEEFFZFZOTFZUCEEE
    ABIOUAENFLEFZUDFFZFFUBUCUCFFTTTFFLNNEGOUEUATGHHHAAABGH $.

  $( A rederivation of ~ nic-ax from ~ lukshef-ax1 , proving that ~ lukshef-ax1
     with ~ nic-mp can be used as a complete axiomatization of propositional
     calculus.  (Contributed by Anthony Hart, 31-Jul-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  renicax $p |- ( ( ph -/\ ( ch -/\ ps ) ) -/\ ( ( ta -/\ ( ta -/\ ta ) )
          -/\ ( ( th -/\ ch ) -/\ ( ( ph -/\ th ) -/\ ( ph -/\ th ) ) ) ) ) $=
    ( wnan lukshefth1 lukshefth2 nic-mp lukshef-ax1 ) EEEFFZDCFADFZLFFZFZACBFFZ
    FZONFZQOMKFZFZPPROFSSACBEDGORHINRRFFSPPFFOOOFFMKHNRROJIIONHI $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Derive the Lukasiewicz Axioms from the Tarski-Bernays-Wajsberg Axioms
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( Justification for ~ tbw-negdf .  (Contributed by Anthony Hart,
     15-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  tbw-bijust $p |- ( ( ph <-> ps ) <->
                      ( ( ( ph -> ps ) -> ( ( ps -> ph ) -> F. ) ) -> F. ) ) $=
    ( wb wi wn wfal dfbi1 pm2.21 imim2i falim impbii notbii ax-1 pm2.43i 3bitri
    id ja ) ABCABDZBADZEZDZERSFDZDZEZUCFDZABGUAUCUAUCTUBRSFHIUBTRSFTTPTJQIKLUDU
    EUCFHUEUDUCFUEUDDZUDUEMUFJQNKO $.

  $( The definition of negation, in terms of ` -> ` and ` F. ` .  (Contributed
     by Anthony Hart, 15-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  tbw-negdf $p |- ( ( ( -. ph -> ( ph -> F. ) )
    -> ( ( ( ph -> F. ) -> -. ph ) -> F. ) ) -> F. ) $=
    ( wn wfal wi wb pm2.21 ax-1 falim ja pm2.43i impbii tbw-bijust mpbi ) ABZAC
    DZENODONDZCDDCDNOACFONACPNOGPHIJKNOLM $.

  $( The first of four axioms in the Tarski-Bernays-Wajsberg system.
     (Contributed by Anthony Hart, 13-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  tbw-ax1 $p |- ( ( ph -> ps ) -> ( ( ps -> ch ) -> ( ph -> ch ) ) ) $=
    ( imim1 ) ABCD $.

  $( The second of four axioms in the Tarski-Bernays-Wajsberg system.
     (Contributed by Anthony Hart, 13-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  tbw-ax2 $p |- ( ph -> ( ps -> ph ) ) $=
    ( ax-1 ) ABC $.

  $( The third of four axioms in the Tarski-Bernays-Wajsberg system.
     (Contributed by Anthony Hart, 13-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  tbw-ax3 $p |- ( ( ( ph -> ps ) -> ph ) -> ph ) $=
    ( peirce ) ABC $.

  $( The fourth of four axioms in the Tarski-Bernays-Wajsberg system.

     This axiom was added to the Tarski-Bernays axiom system (see ~ tb-ax1 ,
     ~ tb-ax2 , and ~ tb-ax3 ) by Wajsberg for completeness.  (Contributed by
     Anthony Hart, 13-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  tbw-ax4 $p |- ( F. -> ph ) $=
    ( falim ) AB $.

  ${
    tbwsyl.1 $e |- ( ph -> ps ) $.
    tbwsyl.2 $e |- ( ps -> ch ) $.
    $( Used to rederive the Lukasiewicz axioms from Tarski-Bernays-Wajsberg'.
       (Contributed by Anthony Hart, 16-Aug-2011.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    tbwsyl $p |- ( ph -> ch ) $=
      ( wi tbw-ax1 ax-mp ) BCFZACFZEABFIJFDABCGHH $.
  $}

  $( Used to rederive the Lukasiewicz axioms from Tarski-Bernays-Wajsberg'.
     (Contributed by Anthony Hart, 16-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  tbwlem1 $p |- ( ( ph -> ( ps -> ch ) ) -> ( ps -> ( ph -> ch ) ) ) $=
    ( wi tbw-ax1 tbw-ax2 tbwsyl tbw-ax3 ax-mp ) ABCDZDJCDZACDZDZBLDZAJCEBKDMNDB
    JKDZKBJBDOBJFJBCEGOKCDKDKJKCEKCHGGBKLEIG $.

  $( Used to rederive the Lukasiewicz axioms from Tarski-Bernays-Wajsberg'.
     (Contributed by Anthony Hart, 16-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  tbwlem2 $p |- ( ( ph -> ( ps -> F. ) ) -> ( ( ( ph -> ch ) -> th )
    -> ( ps -> th ) ) ) $=
    ( wfal wi tbw-ax1 tbw-ax4 tbwlem1 ax-mp tbwsyl ) ABEFZFZBACFZFZNDFBDFFMLCFZ
    NFZOALCGBPFZQOFLBCFZFZRECFZTCHLUASFFUATFBECGLUASIJJLBCIJBPNGJKBNDGK $.

  $( Used to rederive the Lukasiewicz axioms from Tarski-Bernays-Wajsberg'.
     (Contributed by Anthony Hart, 16-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  tbwlem3 $p |- ( ( ( ( ( ph -> F. ) -> ph ) -> ph ) -> ps ) -> ps ) $=
    ( wfal wi tbw-ax3 tbw-ax2 tbw-ax1 tbwsyl ax-mp ) ACDADADZBDZKBDZDZLJMACEJKJ
    DMJKFKJBGHIMLBDLDLKLBGLBEHI $.

  $( Used to rederive the Lukasiewicz axioms from Tarski-Bernays-Wajsberg'.
     (Contributed by Anthony Hart, 16-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  tbwlem4 $p |- ( ( ( ph -> F. ) -> ps ) -> ( ( ps -> F. ) -> ph ) ) $=
    ( wfal wi tbw-ax4 tbw-ax1 tbwlem1 ax-mp tbwlem2 tbwlem3 tbwsyl ) ACDZBDZLBC
    DZCDZDZNADZBODZMPDZNNDZRCCDZTCENUANDDUATDBCCFNUANGHHNBCGHMRPDDRSDLBOFMRPGHH
    PLADADQDQLNAAIAQJKK $.

  $( Used to rederive the Lukasiewicz axioms from Tarski-Bernays-Wajsberg'.
     (Contributed by Anthony Hart, 16-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  tbwlem5 $p |- ( ( ( ph -> ( ps -> F. ) ) -> F. ) -> ph ) $=
    ( wfal wi tbw-ax2 tbw-ax1 tbwsyl tbwlem1 ax-mp tbwlem4 ) ACDZABCDZDZDZMCDAD
    AKLDZDNABADOABEBACFGAKLHIAMJI $.

  $( ~ luk-1 derived from the Tarski-Bernays-Wajsberg axioms.  (Contributed by
     Anthony Hart, 16-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  re1luk1 $p |- ( ( ph -> ps ) -> ( ( ps -> ch ) -> ( ph -> ch ) ) ) $=
    ( tbw-ax1 ) ABCD $.

  $( ~ luk-2 derived from the Tarski-Bernays-Wajsberg axioms.  (Contributed by
     Anthony Hart, 16-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  re1luk2 $p |- ( ( -. ph -> ph ) -> ph ) $=
    ( wn wi wfal tbw-negdf tbw-ax2 tbwlem4 ax-mp tbw-ax1 tbw-ax3 tbwsyl ) ABZAC
    ZADCZACZANLCZMOCLNCZPDCZCZDCZPAERSCTPCRQFPSGHHNLAIHADJK $.

  $( ~ luk-3 derived from the Tarski-Bernays-Wajsberg axioms.

     This theorem, along with ~ re1luk1 and ~ re1luk2 proves that ~ tbw-ax1 ,
     ~ tbw-ax2 , ~ tbw-ax3 , and ~ tbw-ax4 , with ~ ax-mp can be used as a
     complete axiom system for all of propositional calculus.  (Contributed by
     Anthony Hart, 16-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  re1luk3 $p |- ( ph -> ( -. ph -> ps ) ) $=
    ( wfal wi wn tbw-ax4 tbw-ax1 tbwlem1 ax-mp tbw-negdf tbwlem5 tbwsyl ) AACDZ
    BDZAEZBDZMABDZDZANDCBDZRBFMSQDDSRDACBGMSQHIIMABHIOMDZNPDTMODZCDDCDTAJTUAKIO
    MBGIL $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Derive the Tarski-Bernays-Wajsberg axioms from Meredith's First CO Axiom
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( A single axiom for propositional calculus discovered by C. A. Meredith.

     This axiom is worthy of note, due to it having only 19 symbols, not
     counting parentheses.  The more well-known ~ meredith has 21 symbols, sans
     parentheses.

     See ~ merco2 for another axiom of equal length.  (Contributed by Anthony
     Hart, 13-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  merco1 $p |- ( ( ( ( ( ph -> ps ) -> ( ch -> F. ) ) -> th ) -> ta )
         -> ( ( ta -> ph ) -> ( ch -> ph ) ) ) $=
    ( wi wfal wn ax-1 falim ja imim2i imim1i meredith syl ) ABFZCGFZFZDFZEFPDHZ
    CHZFZFZDFZEFEAFCAFFUDSERUCDQUBPCGUBUATIUBJKLMMABDCENO $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 17-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem1 $p |- ( ph -> ( F. -> ch ) ) $=
    ( wfal wi merco1 ax-mp ) AACADZDZDZACBDZDZHGDZHDZIGCDACDZDZGDHDZMGNDZNDZGDO
    DPCAANGEGNAGOEFGCAGHEFHCDZNDZGDLDZMIDQSDHDTDUACAASHEGNHHTEFHCAGLEFFHJDZKDZI
    KDZJCDNDZGDHDZUCRJDUEDUFCAANJEGNAJUEEFJCAGHEFKCDICDZDZJDUBDZUCUDDJUGDSDKDUH
    DUICBISKEJUGHKUHEFKCIJUBEFFF $.

  $( ~ tbw-ax4 rederived from ~ merco1 .  (Contributed by Anthony Hart,
     17-Sep-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  retbwax4 $p |- ( F. -> ph ) $=
    ( wfal wi merco1lem1 ax-mp ) ABACZCZFAADGADE $.

  $( ~ tbw-ax2 rederived from ~ merco1 .  (Contributed by Anthony Hart,
     17-Sep-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  retbwax2 $p |- ( ph -> ( ps -> ph ) ) $=
    ( wi wfal merco1lem1 merco1 ax-mp ) AAAACZCZCZABACZCZDACZHCZICZJHACADCZCACZ
    MCOQAEHAAAMFGIPCPCDCNCOJCAHAPDFIPADNFGGMKCZLCZJLCZKACPCACZMCSUAAEKAAAMFGLBD
    CZCJDCZCDCRCSTCAKBUCDFLUBJDRFGGG $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 17-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem2 $p |- ( ( ( ph -> ps ) -> ch ) -> ( ( ( ps -> ta ) -> ( ph ->
    F. ) ) -> ch ) ) $=
    ( wi wfal retbwax2 merco1 ax-mp ) CAEZBDEAFEEZFEZEZBEABEZEZNCEKCEELMEOLJGBD
    AFMHICAKBNHI $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 17-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem3 $p |- ( ( ( ph -> ps ) -> ( ch -> F. ) ) -> ( ch -> ph ) ) $=
    ( wi wfal merco1lem2 retbwax2 ax-mp ) AAADZAEDDZIDZDZABDCEDDZCADZDZIEDJEDDZ
    LAAEAFKLDPLDKAGJILEFHHNEDMEDDZLODZCAEBFORDQRDOLGMNREFHHH $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 17-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem4 $p |- ( ( ( ph -> ps ) -> ch ) -> ( ps -> ch ) ) $=
    ( wi wfal merco1lem3 merco1 ax-mp ) CADZBEDZDZBDABDZDZLCDBCDDJAEDZDIEDZDKDM
    JNIFBEAOKGHCABBLGH $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 17-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem5 $p |- ( ( ( ( ph -> F. ) -> ch ) -> ta ) -> ( ph -> ta ) ) $=
    ( wi wfal merco1lem4 merco1 ax-mp ) CADZAEDZDBDJBDZDKCDACDDIJBFCAABKGH $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 17-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem6 $p |- ( ( ph -> ( ph -> ps ) ) -> ( ch -> ( ph -> ps ) ) ) $=
    ( wi wfal merco1lem5 merco1lem3 ax-mp merco1 ) ABDZEDCEDZDZEDZADZAJDCJDDJME
    DZDZNLODZPOEDMDQLEEFOELGHJKOFHABMGHJECEAIH $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 17-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem7 $p |- ( ph -> ( ( ( ps -> ch ) -> ps ) -> ps ) ) $=
    ( wi wfal merco1lem5 merco1 ax-mp merco1lem6 ) BCDZBDZKBDZDZALDBEDKEDZDCDJD
    MBNCFBEKCJGHKBAIH $.

  $( ~ tbw-ax3 rederived from ~ merco1 .  (Contributed by Anthony Hart,
     17-Sep-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  retbwax3 $p |- ( ( ( ph -> ps ) -> ph ) -> ph ) $=
    ( wi retbwax2 merco1lem7 ax-mp ) AAACCZABCACACAADGABEF $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 17-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem8 $p |- ( ph -> ( ( ps -> ( ps -> ch ) ) -> ( ps -> ch ) ) ) $=
    ( wi merco1lem6 ax-mp ) BBCDZDZHGDZDAIDBCHEHGAEF $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 18-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem9 $p |- ( ( ph -> ( ph -> ps ) ) -> ( ph -> ps ) ) $=
    ( wfal wi merco1lem8 ax-mp ) CADZAABDZDHDZDZIGABEJABEF $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 18-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem10 $p |- ( ( ( ( ( ph -> ps ) -> ch ) -> ( ta -> ch ) ) -> ph ) ->
    ( th -> ph ) ) $=
    ( wi wfal merco1 merco1lem2 ax-mp ) ABFZDGFZFCAFEGFFAFZGFZFKCFECFFZFZOAFDAF
    FMKFOFPCAEAKHMKOLIJABDNOHJ $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 18-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem11 $p |- ( ( ph -> ps ) -> ( ( ( ch -> ( ph -> ta ) ) -> F. ) -> ps
    ) ) $=
    ( wi wfal merco1lem5 merco1lem3 ax-mp merco1lem4 merco1 merco1lem2 ) ADEZBA
    EZCMEZFEZFEZEZFEZFEZEZABEPBEEZOTEZUAQTEZUCRTEZUDTFESEUERFFGTFRHINQTJIOFTGIC
    MTJISAEUBEUAUBEBAPFAKSAUBDLII $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 18-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem12 $p |- ( ( ph -> ps ) -> ( ( ( ch -> ( ph -> ta ) ) -> ph ) -> ps
    ) ) $=
    ( wi wfal merco1lem3 merco1 ax-mp merco1lem9 merco1lem11 ) BAEZCADEZEZAEZFE
    ZEFEAEZABEOBEEOAEZQOREZRMPECFEZENESMPCGADOTNHIOAJIOALFKIBAOFAHI $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 18-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem13 $p |- ( ( ( ( ph -> ps ) -> ( ch -> ps ) ) -> ta ) -> ( ph ->
    ta ) ) $=
    ( wi wfal merco1 merco1lem4 ax-mp merco1lem12 ) DAEZAFEEAEABECBEEZEZLDEADEE
    ALEZMBAECFEEAEZAELENBACAAGOALHIALKFJIDAAALGI $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 18-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem14 $p |- ( ( ( ( ph -> ps ) -> ps ) -> ch ) -> ( ph -> ch ) ) $=
    ( wi wfal merco1lem13 merco1lem8 merco1 ax-mp merco1lem9 merco1lem12 ) CADZ
    AEDDADABDZBDZDZNCDACDDANDZOMNDNDZPDZPABMNFRRPDZDZSPADREDDADZQDTUAMBGPARAQHI
    RPJIIANLEKICAAANHI $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 18-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem15 $p |- ( ( ph -> ps ) -> ( ph -> ( ch -> ps ) ) ) $=
    ( wi merco1lem14 merco1lem13 ax-mp ) ABDZBDCBDZDAIDZDHJDABIEHBCJFG $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 18-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem16 $p |- ( ( ( ph -> ( ps -> ch ) ) -> ta ) -> ( ( ph -> ch ) -> ta
    ) ) $=
    ( wi wfal merco1lem15 merco1lem11 ax-mp merco1 ) DAEZACEZFEEFEABCEEZEZMDELD
    EELMENACBGLMKFHIDALFMJI $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 18-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem17 $p |- ( ( ( ( ( ph -> ps ) -> ph ) -> ch ) -> ta ) -> ( ( ph ->
    ch ) -> ta ) ) $=
    ( wi merco1lem11 merco1lem7 merco1 ax-mp merco1lem9 merco1lem16 merco1lem4
    wfal ) DAEZACEZMEZECEZABEAEZCEZEZSDEODEEPCEZSEZTPOEZSEZUBOSEZUDCAEZRMEEMEAE
    ZUERAEZUGEZUGRAUFMFUIUIUGEZEZUJUGAEUIMEEAEZUHEUKULABGUGAUIAUHHIUIUGJIICARMA
    HISAEZUCMEEMEOEZUEUDEUCOEZUNEZUNUCOUMMFUPUPUNEZEZUQUNAEUPMEEAEZUOEURUSOMGUN
    AUPAUOHIUPUNJIISAUCMOHIIPACSKIUMQMEEMEUAEZUBTEQUAEUTNPCLQUAUMMFISAQMUAHIIDA
    OCSHI $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco1 .
     (Contributed by Anthony Hart, 18-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco1lem18 $p |- ( ( ph -> ( ps -> ch ) ) -> ( ( ps -> ph ) -> ( ps ->
    ch ) ) ) $=
    ( wfal merco1 merco1lem17 ax-mp merco1lem5 merco1lem3 merco1lem4 merco1lem2
    wi merco1lem9 ) BALZABCLZLZNOLZLZLZROBLZALRLZSTNDLZLTLALRLUAOBNTAETUBARFGBC
    ARFGSSRLZLZUCQRDLSDLZLZDLZDLZLZUDRUHLZUIUFUHLZUJUHDLUGLUKUFDDHUHDUFIGRUEUHH
    GPQUHJGUGNLUDLUIUDLRDSDNEUGNUDOKGGSRMGG $.

  $( ~ tbw-ax1 rederived from ~ merco1 .

     This theorem, along with ~ retbwax2 , ~ retbwax3 , and ~ retbwax4 , shows
     that ~ merco1 with ~ ax-mp can be used as a complete axiomatization of
     propositional calculus.  (Contributed by Anthony Hart, 18-Sep-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  retbwax1 $p |- ( ( ph -> ps ) -> ( ( ps -> ch ) -> ( ph -> ch ) ) ) $=
    ( wi merco1lem18 merco1lem16 ax-mp merco1lem15 merco1lem14 wfal merco1lem10
    merco1 merco1lem9 merco1lem13 ) BCDZABDZACDZDZDZPOQDZDZBQDRDSBACEBACRFGOSUA
    DZDZUBSRDUBDZUCRUBDZUDRUADUEPQOHRUASHGRSUAEGORUBIGUCUBDZJDZUADZUFUGTDZUHUFQ
    DZTDZUIOUBQITADZUGJDZDZQDUJDZUKUIDQADZUGDZUMDUNDZUOUMJDULJDDUGDUQDURUGJJUPU
    LKUMJULUGUQLGQAUFUMUNLGTAUGQUJLGGUGTPHGUHUBDUFDZUFDZUHUFDUSUTDUTUFJUAUSSKUS
    UFMGUHUBUCUFNGGGG $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Derive the Tarski-Bernays-Wajsberg axioms from Meredith's Second CO Axiom
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( A single axiom for propositional calculus discovered by C. A. Meredith.

     This axiom has 19 symbols, sans auxiliaries.  See notes in ~ merco1 .
     (Contributed by Anthony Hart, 7-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  merco2 $p |- ( ( ( ph -> ps ) -> ( ( F. -> ch ) -> th ) ) -> ( ( th
         -> ph ) -> ( ta -> ( et -> ph ) ) ) ) $=
    ( wi wfal falim pm2.04 mpi jarl idd jad looinv 3syl a1dd a1i com4l ) FABGZH
    CGZDGGZDAGZEAUBUCEAGGGFUBUCAEUBTDGZADGDGUCAGUBUAUDCITUADJKUDADDABDLUDDMNADO
    PQRS $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco2 .
     (Contributed by Anthony Hart, 16-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  mercolem1 $p |- ( ( ( ph -> ps ) -> ch ) -> ( ps -> ( th -> ch ) ) ) $=
    ( wi wfal merco2 ax-mp ) AAEZFAEZAEEIAIEEEZABEZCEZBDCEZEZEZAAAAAAGZKKPEZQCA
    EZJLEZEZPEZKREZCAALBDGPTEJUAEEZUBUCETOEJPEEZUDOJFEZEFBETEEUEBNAFJAGOUFBTJMG
    HTOAPJSGHPTAUAKKGHHHH $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco2 .
     (Contributed by Anthony Hart, 16-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  mercolem2 $p |- ( ( ( ph -> ps ) -> ph ) -> ( ch -> ( th -> ph ) ) ) $=
    ( wi wfal merco2 ax-mp ) AAEZFAEZAEEIAIEEEZABEZAEZCDAEEZEZAAAAAAGZKKOEZPIJL
    EZEZOEZKQEZAAALCDGOREJSEEZTUAERNEJOEEZUBNLEJREEZUCLJFEZEJNEEUDABAFCDGLUEANJ
    JGHNLARJMGHRNAOJIGHORASKKGHHHH $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco2 .
     (Contributed by Anthony Hart, 16-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  mercolem3 $p |- ( ( ps -> ch ) -> ( ps -> ( ph -> ch ) ) ) $=
    ( wi wfal merco2 mercolem2 ax-mp ) AADZEADZADDIAIDDDZBCDZBACDZDZDZAAAAAAFZK
    KODZPCADZJBDZDZODZKQDZCAABBAFOSDJTDDZUAUBDSNDJODDZUCNBDJSDDUDBMJJGNBASJLFHS
    NAOJRFHOSATKKFHHHH $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco2 .
     (Contributed by Anthony Hart, 16-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  mercolem4 $p |- ( ( th -> ( et -> ph ) ) -> ( ( ( th -> ch )
  -> ph ) -> ( ta -> ( et -> ph ) ) ) ) $=
    ( wi wfal merco2 mercolem1 ax-mp mercolem3 ) AAFZGAFZAFFLALFFFZCEAFZFZCBFZA
    FZDOFFZFZAAAAAAHZNNTFZUAOAFZMCFFZTFZNUBFZOAACRDHTCFZMUDFFZUEUFFUGUDFZUHQMTF
    FZUIMQFZTFZUJLUKFSFULAAAQDEHLUKSPIJMQTMIJCBATUCMHJMUGUDKJTCAUDNNHJJJJ $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco2 .
     (Contributed by Anthony Hart, 16-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  mercolem5 $p |- ( th -> ( ( th -> ph ) -> ( ta -> ( ch -> ph ) ) ) ) $=
    ( wi wfal merco2 mercolem1 ax-mp mercolem2 ) AAEZFAEZAEEKAKEEEZCCAEDBAEEEZE
    ZAAAAAAGZMMOEZPLCEZOEZMQEZKRENESAAACDBGKRNCHIOCELREESTECNLLJOCARMMGIIII $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco2 .
     (Contributed by Anthony Hart, 16-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  mercolem6 $p |- ( ( ph -> ( ps -> ( ph -> ch ) ) )
  -> ( ps -> ( ph -> ch ) ) ) $=
    ( wi wfal merco2 mercolem1 ax-mp mercolem5 mercolem4 ) AADZEADADDKAKDDDZABA
    CDZDZDZNDZAAAAAAFZLLPDZQLLRDZQORDZLSDZLTQMRDZLTDZAODZMDPDUBAOMBGUDMPLGHATDU
    BUCDNOALIRCALOJHHHLTUADZQPUADZLUEDZALDZPDSDUFALPLGUHPSLGHOUEDUFUGDRLOLIUANO
    LTJHHHHHHH $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco2 .
     (Contributed by Anthony Hart, 16-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  mercolem7 $p |- ( ( ph -> ps ) -> ( ( ( ph -> ch )
  -> ( th -> ps ) ) -> ( th -> ps ) ) ) $=
    ( wi wfal merco2 mercolem3 mercolem6 ax-mp mercolem5 mercolem4 ) AAEZFAEAEE
    MAMEEEZABEZACEZDBEZEZQEZEZAAAAAAGPSEZNTEZRUAEUARPQHRPQIJATEUAUBEBDARKSCANOL
    JJJ $.

  $( Used to rederive the Tarski-Bernays-Wajsberg axioms from ~ merco2 .
     (Contributed by Anthony Hart, 16-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  mercolem8 $p |- ( ( ph -> ps ) -> ( ( ps -> ( ph -> ch ) )
  -> ( ta -> ( th -> ( ph -> ch ) ) ) ) ) $=
    ( wi wfal merco2 mercolem3 ax-mp mercolem7 ) AAFZGAFZAFFLALFFFZABFZBACFZFED
    PFFFZFZAAAAAAHZNNRFZSPMBFZFUAFZRFZNTFZUBQFUCPUAABEDHOUBQIJRMUBFZFUEFZUCUDFO
    UBFUFABCMKOUBQMKJRUEAUBNNHJJJJ $.

  $( ~ tbw-ax1 rederived from ~ merco2 .  (Contributed by Anthony Hart,
     16-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  re1tbw1 $p |- ( ( ph -> ps ) -> ( ( ps -> ch ) -> ( ph -> ch ) ) ) $=
    ( wi mercolem3 mercolem8 mercolem6 ax-mp ) BCDZABDZIACDZDZDZDZMJNDZNIBKDZDZ
    OABCEPNDZQODZPMDZRJTDTABCIJFJPLGHIPMEHQRSDZDUAIPMJQFQROGHHHJILGHIJKGH $.

  $( ~ tbw-ax2 rederived from ~ merco2 .  (Contributed by Anthony Hart,
     16-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  re1tbw2 $p |- ( ph -> ( ps -> ph ) ) $=
    ( wi mercolem1 ax-mp mercolem6 ) BABACZCZCZHAICZIAACZACHCJAAABDKAHBDEABGFEB
    AAFE $.

  $( ~ tbw-ax3 rederived from ~ merco2 .  (Contributed by Anthony Hart,
     16-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  re1tbw3 $p |- ( ( ( ph -> ps ) -> ph ) -> ph ) $=
    ( wi mercolem2 mercolem6 ax-mp ) AACZACAGCCZABCACZACZAAAADIHJCZCKABHIDIHAEF
    F $.

  $( ~ tbw-ax4 rederived from ~ merco2 .

     This theorem, along with ~ re1tbw1 , ~ re1tbw2 , and ~ re1tbw3 , shows
     that ~ merco2 , along with ~ ax-mp , can be used as a complete
     axiomatization of propositional calculus.  (Contributed by Anthony Hart,
     16-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  re1tbw4 $p |- ( F. -> ph ) $=
    ( wi wfal re1tbw3 re1tbw2 re1tbw1 ax-mp mercolem3 merco2 ) AABZCABZJABZABZJ
    AADALBMJBAJEALAFGGZJJKBZNKKBZJOBZKABZKBZKBZPKADKSBTPBKREKSKFGGRPBPQBCKAHKAA
    KJJIGGGG $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Derive the Lukasiewicz axioms from the Russell-Bernays Axioms
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( Justification for ~ rb-imdf .  (Contributed by Anthony Hart, 17-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  rb-bijust $p |- ( ( ph <-> ps ) <->
                           -. ( -. ( -. ph \/ ps ) \/ -. ( -. ps \/ ph ) ) ) $=
    ( wb wi wn wo dfbi1 imor notbii imbi12i pm4.62 3bitri ) ABCABDZBADZEZDZEAEB
    FZBEAFZEZDZEQESFZEABGPTMQOSABHNRBAHIJITUAQRKIL $.

  $( The definition of implication, in terms of ` \/ ` and ` -. ` .
     (Contributed by Anthony Hart, 17-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  rb-imdf $p |- -. ( -. ( -. ( ph -> ps ) \/ ( -. ph \/ ps ) )
    \/ -. ( -. ( -. ph \/ ps ) \/ ( ph -> ps ) ) ) $=
    ( wi wn wo wb imor rb-bijust mpbi ) ABCZADBEZFJDKEDKDJEDEDABGJKHI $.

  ${
    anmp.min $e |- ph $.
    anmp.maj $e |- ( -. ph \/ ps ) $.
    $( Modus ponens for ` { \/ , -. } ` axiom systems.  (Contributed by Anthony
       Hart, 12-Aug-2011.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    anmp $p |- ps $=
      ( imorri ax-mp ) ABCABDEF $.
  $}

  $( The first of four axioms in the Russell-Bernays axiom system.
     (Contributed by Anthony Hart, 13-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  rb-ax1 $p |- ( -. ( -. ps \/ ch ) \/ ( -. ( ph \/ ps ) \/ ( ph \/ ch ) ) ) $=
    ( wn wo wi orim2 imor 3imtr3i imori ) BDCEZABEZDACEZEZBCFLMFKNABCGBCHLMHIJ
    $.

  $( The second of four axioms in the Russell-Bernays axiom system.
     (Contributed by Anthony Hart, 13-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  rb-ax2 $p |- ( -. ( ph \/ ps ) \/ ( ps \/ ph ) ) $=
    ( wo wn pm1.4 con3i con1i orri ) ABCZDZBACZKJIKABEFGH $.

  $( The third of four axioms in the Russell-Bernays axiom system.
     (Contributed by Anthony Hart, 13-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  rb-ax3 $p |- ( -. ph \/ ( ps \/ ph ) ) $=
    ( wn wo pm2.46 con1i orri ) ACZBADZIHBAEFG $.

  $( The fourth of four axioms in the Russell-Bernays axiom system.
     (Contributed by Anthony Hart, 13-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  rb-ax4 $p |- ( -. ( ph \/ ph ) \/ ph ) $=
    ( wo wn pm1.2 con3i con1i orri ) AABZCZAAIHAADEFG $.

  ${
    rbsyl.1 $e |- ( -. ps \/ ch ) $.
    rbsyl.2 $e |- ( ph \/ ps ) $.
    $( Used to rederive the Lukasiewicz axioms from Russell-Bernays'.
       (Contributed by Anthony Hart, 18-Aug-2011.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    rbsyl $p |- ( ph \/ ch ) $=
      ( wo wn rb-ax1 anmp ) ABFZACFZEBGCFJGKFDABCHII $.
  $}

  ${
    rblem1.1 $e |- ( -. ph \/ ps ) $.
    rblem1.2 $e |- ( -. ch \/ th ) $.
    $( Used to rederive the Lukasiewicz axioms from Russell-Bernays'.
       (Contributed by Anthony Hart, 18-Aug-2011.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    rblem1 $p |- ( -. ( ph \/ ch ) \/ ( ps \/ th ) ) $=
      ( wo wn rb-ax1 anmp rb-ax2 rbsyl ) ACGHZBCGZBDGZCHDGNHOGFBCDIJMCBGZNCBKMC
      AGZPAHBGQHPGECABIJACKLLL $.
  $}

  $( Used to rederive the Lukasiewicz axioms from Russell-Bernays'.
     (Contributed by Anthony Hart, 18-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  rblem2 $p |- ( -. ( ch \/ ph ) \/ ( ch \/ ( ph \/ ps ) ) ) $=
    ( wn wo rb-ax2 rb-ax3 rbsyl rb-ax1 anmp ) ADZABEZECAEDCLEEKBAELBAFABGHCALIJ
    $.

  $( Used to rederive the Lukasiewicz axioms from Russell-Bernays'.
     (Contributed by Anthony Hart, 18-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  rblem3 $p |- ( -. ( ch \/ ph ) \/ ( ( ch \/ ps ) \/ ph ) ) $=
    ( wo wn rb-ax2 rblem2 rbsyl ) CADEZACBDZDZJADAJFIACDKCBAGCAFHH $.

  ${
    rblem4.1 $e |- ( -. ph \/ th ) $.
    rblem4.2 $e |- ( -. ps \/ ta ) $.
    rblem4.3 $e |- ( -. ch \/ et ) $.
    $( Used to rederive the Lukasiewicz axioms from Russell-Bernays'.
       (Contributed by Anthony Hart, 18-Aug-2011.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    rblem4 $p |- ( -. ( ( ph \/ ps ) \/ ch ) \/ ( ( et \/ ta ) \/ th ) ) $=
      ( wo wn rblem1 rb-ax2 rb-ax1 anmp rbsyl rb-ax4 rblem2 rb-ax3 ) ABJZCJKZCB
      JZAJZFEJZDJUBUDADCFBEIHLGLUABCJZAJZUCUFKZAUBJZUCAUBMUGAUEJZUHUEKUBJUIKUHJ
      BCMAUEUBNOUEAMPPUAUFUFJUFUFQTUFCUFTKUIUFAUEMBCARPCKZUEJUJUFJCBSUEAUJROLPP
      P $.
  $}

  $( Used to rederive the Lukasiewicz axioms from Russell-Bernays'.
     (Contributed by Anthony Hart, 19-Aug-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  rblem5 $p |- ( -. ( -. -. ph \/ ps ) \/ ( -. -. ps \/ ph ) ) $=
    ( wn wo rb-ax2 rb-ax4 rb-ax3 rbsyl anmp rblem1 ) ACZCZBDCABCZCZDNADANELABNK
    ADLCZADKAADAAFAAGHZKOAAOLDLODOLLDLLFLLGHOLEIPJINMDMNDNMMDMMFMMGHNMEIJH $.

  ${
    rblem6.1 $e |- -. ( -. ( -. ph \/ ps ) \/ -. ( -. ps \/ ph ) ) $.
    $( Used to rederive the Lukasiewicz axioms from Russell-Bernays'.
       (Contributed by Anthony Hart, 19-Aug-2011.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    rblem6 $p |- ( -. ph \/ ps ) $=
      ( wn wo rb-ax4 rb-ax3 rbsyl rb-ax2 anmp rblem3 rblem5 ) ADBEZDZBDAEDZEZDZ
      MCNDZPEZQDMEPREZSNREZTRNEUARNNENNFNNGHRNIJRONKJPRIJMPLJJ $.
  $}

  ${
    rblem7.1 $e |- -. ( -. ( -. ph \/ ps ) \/ -. ( -. ps \/ ph ) ) $.
    $( Used to rederive the Lukasiewicz axioms from Russell-Bernays'.
       (Contributed by Anthony Hart, 19-Aug-2011.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    rblem7 $p |- ( -. ps \/ ph ) $=
      ( wn wo rb-ax3 rblem5 anmp ) ADBEDZBDAEZDZEZDZJCKDLEMDJEKIFJLGHH $.
  $}

  ${
    re1axmp.min $e |- ph $.
    re1axmp.maj $e |- ( ph -> ps ) $.
    $( ~ ax-mp derived from Russell-Bernays'.  (Contributed by Anthony Hart,
       19-Aug-2011.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    re1axmp $p |- ps $=
      ( wi wn wo rb-imdf rblem6 anmp ) ABCABEZAFBGZDKLABHIJJ $.
  $}

  $( ~ luk-1 derived from Russell-Bernays'.  (Contributed by Anthony Hart,
     19-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  re2luk1 $p |- ( ( ph -> ps ) -> ( ( ps -> ch ) -> ( ph -> ch ) ) ) $=
    ( wi wn rb-imdf rblem7 rblem6 rb-ax2 rb-ax4 rb-ax3 rbsyl anmp rblem1 rb-ax1
    wo rblem4 ) ABDZEZBCDZACDZDZPZRUBDZSTEZUAPZUBUBUFTUAFGSAEZBPZUFUHEZBECPZEZU
    GCPZPZUFUKUEULUAUEUJPZUKEZUEPZTUJBCFHUNEUEUOPUPUEUOIUEUEUJUOUEEUEUEPUEUEJUE
    UEKLUOUKPUKUOPUOUKUKPUKUKJUKUKKLZUOUKIMNLMUAULACFGNUKUIULPZPZUIUMPZUGBCOUSE
    ZUMUIPZUTUMUIIVAURUKPVBUIULUKUIULUKUIEUIUIPUIUIJUIUIKLULEULULPULULJULULKLUQ
    QUKURILLMLRUHABFHLLUDUCRUBFGM $.

  $( ~ luk-2 derived from Russell-Bernays'.  (Contributed by Anthony Hart,
     19-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  re2luk2 $p |- ( ( -. ph -> ph ) -> ph ) $=
    ( wn wi wo rb-ax4 rb-ax3 rbsyl rb-ax2 anmp rblem1 rb-imdf rblem6 rblem7 ) A
    BZACZBZADZOACZPNBZADZATBAADZAAEZSAAANADSBZADNUAAUBAAFGZNUCAAUCSDSUCDUCSSDSS
    ESSFGUCSHIUDJIUDJGOTNAKLGRQOAKMI $.

  $( ~ luk-3 derived from Russell-Bernays'.

     This theorem, along with ~ re1axmp , ~ re2luk1 , and ~ re2luk2 shows that
     ~ rb-ax1 , ~ rb-ax2 , ~ rb-ax3 , and ~ rb-ax4 , along with ~ anmp , can be
     used as a complete axiomatization of propositional calculus.  (Contributed
     by Anthony Hart, 19-Aug-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  re2luk3 $p |- ( ph -> ( -. ph -> ps ) ) $=
    ( wn wi wo rb-imdf rblem7 rb-ax4 rb-ax3 rbsyl rb-ax2 anmp rblem2 ) ACZNBDZE
    ZAODZNNCZBEZOOSNBFGNREZNSERNETRNNENNHNNIJRNKLRBNMLJQPAOFGL $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Stoic logic non-modal portion (Chrysippus of Soli)
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  The Greek Stoics developed a system of logic called Stoic logic.  The Stoic
  Chrysippus, in particular, was often considered one of the greatest logicians
  of antiquity.  Stoic logic is different from Aristotle's system, since it
  focuses on propositional logic, though later thinkers did combine the systems
  of the Stoics with Aristotle.  Jan Lukasiewicz reports, "For anybody familiar
  with mathematical logic it is self-evident that the Stoic dialectic is the
  ancient form of modern propositional logic"
  ( _On the history of the logic of proposition_ by Jan Lukasiewicz (1934),
  translated in: _Selected Works_ - Edited by Ludwik Borkowski -
  Amsterdam, North-Holland, 1970 pp. 197-217,
  referenced in "History of Logic,
  ~ https://www.historyoflogic.com/logic-stoics.htm ).

  In this section we show that the propositional logic system we use (which is
  non-modal) is at least as strong as the non-modal portion of Stoic logic.  We
  show this by showing that our system assumes or proves all of key features of
  Stoic logic's non-modal portion (specifically the Stoic logic
  indemonstrables, themata, and principles).

  "In terms of contemporary logic, Stoic syllogistic is best understood as a
  substructural backwards-working Gentzen-style natural-deduction system that
  consists of five kinds of axiomatic arguments (the indemonstrables) and four
  inference rules, called themata.  An argument is a syllogism precisely if it
  either is an indemonstrable or can be reduced to one by means of the themata
  (Diogenes Laertius (D. L. 7.78))." (_Ancient Logic_, Stanford Encyclopedia of
  Philosophy ~ https://plato.stanford.edu/entries/logic-ancient/ ).  There are
  also a few "principles" that support logical reasoning, discussed below.  For
  more information, see "Stoic Logic" by Susanne Bobzien, especially
  [Bobzien] p. 110-120, especially for a discussion about the themata
  (including how they were reconstructed and how they were used).  There are
  differences in the systems we can only partly represent, for example, in
  Stoic logic "truth and falsehood are temporal properties of assertibles...
  They can belong to an assertible at one time but not at another"
  ([Bobzien] p. 87).  Stoic logic also included various kinds of modalities,
  which we do not include here since our basic propositional logic does not
  include modalities.

  A key part of the Stoic logic system is a set of five "indemonstrables"
  assigned to Chrysippus of Soli by Diogenes Laertius, though in general it is
  difficult to assign specific ideas to specific thinkers.  The indemonstrables
  are described in, for example, [Lopez-Astorga] p. 11 , [Sanford] p. 39, and
  [Hitchcock] p. 5.  These indemonstrables are modus ponendo ponens (modus
  ponens) ~ ax-mp , modus tollendo tollens (modus tollens) ~ mto , modus
  ponendo tollens I ~ mptnan , modus ponendo tollens II ~ mptxor , and modus
  tollendo ponens (exclusive-or version) ~ mtpxor .  The first is an axiom, the
  second is already proved; in this section we prove the other three.  Note
  that modus tollendo ponens ~ mtpxor originally used exclusive-or, but over
  time the name modus tollendo ponens has increasingly referred to an
  inclusive-or variation, which is proved in ~ mtpor .

  After we prove the indemonstratables, we then prove all the Stoic logic
  themata (the inference rules of Stoic logic; "thema" is singular).  This is
  straightforward for thema 1 ( ~ stoic1a and ~ stoic1b ) and thema 3
  ( ~ stoic3 ).  However, while Stoic logic was once a leading logic system,
  most direct information about Stoic logic has since been lost, including the
  exact texts of thema 2 and thema 4.  There are, however, enough references
  and specific examples to support reconstruction.  Themata 2 and 4 have been
  reconstructed; see statements T2 and T4 in [Bobzien] p. 110-120 and our
  proofs of them in ~ stoic2a , ~ stoic2b , ~ stoic4a , and ~ stoic4b .

  Stoic logic also had a set of principles involving assertibles.  Statements
  in [Bobzien] p. 99 express the known principles.  The following paragraphs
  discuss these principles and our proofs of them.

  "A principle of double negation, expressed by saying that a double-negation
  (Not: not: p) is equivalent to the assertible that is doubly negated (p) (DL
  VII 69)."  In other words, ` ( ph <-> -. -. ph ) ` as proven in ~ notnotb .

  "The principle that all conditionals that are formed by using the same
  assertible twice (like 'If p, p') are true (Cic. Acad. II 98)."  In other
  words, ` ( ph -> ph ) ` as proven in ~ id .

  "The principle that all disjunctions formed by a contradiction (like 'Either
  p or not: p') are true (S. E. M VIII 282)."  Remember that in Stoic logic,
  'or' means 'exclusive or'.  In other words, ` ( ph \/_ -. ph ) ` as proven in
  ~ xorexmid .

  [Bobzien] p. 99 also suggests that Stoic logic may have dealt with
  commutativity (see ~ xorcom and ~ ancom ) and the principle of contraposition
  ( ~ con4 ) (pointing to DL VII 194).

  In short, the non-modal propositional logic system we use is at least as
  strong as the non-modal portion of Stoic logic.

  For more about Aristotle's system, see ~ barbara and related theorems.

$)

  ${
    $( Minor premise for modus ponendo tollens 1. $)
    mptnan.min $e |- ph $.
    $( Major premise for modus ponendo tollens 1. $)
    mptnan.maj $e |- -. ( ph /\ ps ) $.
    $( Modus ponendo tollens 1, one of the "indemonstrables" in Stoic logic.
       See rule 1 on [Lopez-Astorga] p. 12 , rule 1 on [Sanford] p. 40, and
       rule A3 in [Hitchcock] p. 5.  Sanford describes this rule second (after
       ~ mptxor ) as a "safer, and these days much more common" version of
       modus ponendo tollens because it avoids confusion between inclusive-or
       and exclusive-or.  (Contributed by David A. Wheeler, 3-Jul-2016.) $)
    mptnan $p |- -. ps $=
      ( wn imnani ax-mp ) ABECABDFG $.
  $}

  ${
    $( Minor premise for modus ponendo tollens 2. $)
    mptxor.min $e |- ph $.
    $( Major premise for modus ponendo tollens 2. $)
    mptxor.maj $e |- ( ph \/_ ps ) $.
    $( Modus ponendo tollens 2, one of the "indemonstrables" in Stoic logic.
       Note that this uses exclusive-or ` \/_ ` .  See rule 2 on
       [Lopez-Astorga] p. 12 , rule 4 on [Sanford] p. 39 and rule A4 in
       [Hitchcock] p. 5 .  (Contributed by David A. Wheeler, 3-Jul-2016.)
       (Proof shortened by Wolf Lammen, 12-Nov-2017.)  (Proof shortened by BJ,
       19-Apr-2019.) $)
    mptxor $p |- -. ps $=
      ( wxo wa wn xornan ax-mp mptnan ) ABCABEABFGDABHIJ $.
  $}

  ${
    $( Minor premise for modus tollendo ponens (inclusive-or version). $)
    mtpor.min $e |- -. ph $.
    $( Major premise for modus tollendo ponens (inclusive-or version). $)
    mtpor.max $e |- ( ph \/ ps ) $.
    $( Modus tollendo ponens (inclusive-or version), aka disjunctive syllogism.
       This is similar to ~ mtpxor , one of the five original "indemonstrables"
       in Stoic logic.  However, in Stoic logic this rule used exclusive-or,
       while the name modus tollendo ponens often refers to a variant of the
       rule that uses inclusive-or instead.  The rule says, "if ` ph ` is not
       true, and ` ph ` or ` ps ` (or both) are true, then ` ps ` must be
       true".  An alternate phrasing is:  "once you eliminate the impossible,
       whatever remains, no matter how improbable, must be the truth". --
       Sherlock Holmes (Sir Arthur Conan Doyle, 1890:  The Sign of the Four,
       ch. 6).  (Contributed by David A. Wheeler, 3-Jul-2016.)  (Proof
       shortened by Wolf Lammen, 11-Nov-2017.) $)
    mtpor $p |- ps $=
      ( wn ori ax-mp ) AEBCABDFG $.
  $}

  ${
    $( Minor premise for modus tollendo ponens (original exclusive-or version).
    $)
    mtpxor.min $e |- -. ph $.
    $( Major premise for modus tollendo ponens (original exclusive-or version).
    $)
    mtpxor.maj $e |- ( ph \/_ ps ) $.
    $( Modus tollendo ponens (original exclusive-or version), aka disjunctive
       syllogism, similar to ~ mtpor , one of the five "indemonstrables" in
       Stoic logic.  The rule says:  "if ` ph ` is not true, and either ` ph `
       or ` ps ` (exclusively) are true, then ` ps ` must be true".  Today the
       name "modus tollendo ponens" often refers to a variant, the inclusive-or
       version as defined in ~ mtpor .  See rule 3 on [Lopez-Astorga] p. 12
       (note that the "or" is the same as ~ mptxor , that is, it is
       exclusive-or ~ df-xor ), rule 3 of [Sanford] p. 39 (where it is not as
       clearly stated which kind of "or" is used but it appears to be in the
       same sense as ~ mptxor ), and rule A5 in [Hitchcock] p. 5 (exclusive-or
       is expressly used).  (Contributed by David A. Wheeler, 4-Jul-2016.)
       (Proof shortened by Wolf Lammen, 11-Nov-2017.)  (Proof shortened by BJ,
       19-Apr-2019.) $)
    mtpxor $p |- ps $=
      ( wxo wo xoror ax-mp mtpor ) ABCABEABFDABGHI $.
  $}

  ${
    $( Premise for Stoic logic thema 1. $)
    stoic1.1 $e |- ( ( ph /\ ps ) -> th ) $.
    $( Stoic logic Thema 1 (part a).

       The first thema of the four Stoic logic themata, in its basic form, was:

       "When from two (assertibles) a third follows, then from either of them
       together with the contradictory of the conclusion the contradictory of
       the other follows."  (Apuleius Int. 209.9-14), see [Bobzien] p. 117 and
       ~ https://plato.stanford.edu/entries/logic-ancient/

       We will represent thema 1 as two very similar rules ~ stoic1a and
       ~ stoic1b to represent each side.  (Contributed by David A. Wheeler,
       16-Feb-2019.)  (Proof shortened by Wolf Lammen, 21-May-2020.) $)
    stoic1a $p |- ( ( ph /\ -. th ) -> -. ps ) $=
      ( ex con3dimp ) ABCABCDEF $.

    $( Stoic logic Thema 1 (part b).  The other part of thema 1 of Stoic logic;
       see ~ stoic1a .  (Contributed by David A. Wheeler, 16-Feb-2019.) $)
    stoic1b $p |- ( ( ps /\ -. th ) -> -. ph ) $=
      ( ancoms stoic1a ) BACABCDEF $.
  $}

  ${
    $( Premise 1 for Stoic logic Thema 2 version a. $)
    stoic2a.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Premise 2 for Stoic logic Thema 2 version a. $)
    stoic2a.2 $e |- ( ( ph /\ ch ) -> th ) $.
    $( Stoic logic Thema 2 version a.  Statement T2 of [Bobzien] p. 117 shows a
       reconstructed version of Stoic logic thema 2 as follows:  "When from two
       assertibles a third follows, and from the third and one (or both) of the
       two another follows, then this other follows from the first two."
       Bobzien uses constructs such as ` ph , ps |- ch ` ; in Metamath we will
       represent that construct as ` ph /\ ps -> ch ` .  This version a is
       without the phrase "or both"; see ~ stoic2b for the version with the
       phrase "or both".  We already have this rule as ~ syldan , so here we
       show the equivalence and discourage its use.
       (New usage is discouraged.)  (Contributed by David A. Wheeler,
       17-Feb-2019.) $)
    stoic2a $p |- ( ( ph /\ ps ) -> th ) $=
      ( syldan ) ABCDEFG $.
  $}

  ${
    $( Premise 1 for Stoic logic Thema 2 version b. $)
    stoic2b.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Premise 2 for Stoic logic Thema 2 version b. $)
    stoic2b.2 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( Stoic logic Thema 2 version b.  See ~ stoic2a .  Version b is with the
       phrase "or both".  We already have this rule as ~ mpd3an3 , so here we
       prove the equivalence and discourage its use.
       (New usage is discouraged.)  (Contributed by David A. Wheeler,
       17-Feb-2019.) $)
    stoic2b $p |- ( ( ph /\ ps ) -> th ) $=
      ( mpd3an3 ) ABCDEFG $.
  $}

  ${
    $( Premise 1 for Stoic logic Thema 3. $)
    stoic3.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Premise 2 for Stoic logic Thema 3. $)
    stoic3.2 $e |- ( ( ch /\ th ) -> ta ) $.
    $( Stoic logic Thema 3.  Statement T3 of [Bobzien] p. 116-117 discusses
       Stoic logic Thema 3.  "When from two (assemblies) a third follows, and
       from the one that follows (i.e., the third) together with another,
       external assumption, another follows, then that other follows from the
       first two and the externally co-assumed one.  (Simp.  Cael. 237.2-4)"
       (Contributed by David A. Wheeler, 17-Feb-2019.) $)
    stoic3 $p |- ( ( ph /\ ps /\ th ) -> ta ) $=
      ( wa sylan 3impa ) ABDEABHCDEFGIJ $.
  $}

  ${
    $( Premise 1 for Stoic logic Thema 4a. $)
    stoic4a.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Premise 2 for Stoic logic Thema 4a. $)
    stoic4a.2 $e |- ( ( ch /\ ph /\ th ) -> ta ) $.
    $( Stoic logic Thema 4 version a.  Statement T4 of [Bobzien] p. 117 shows a
       reconstructed version of Stoic logic Thema 4:  "When from two
       assertibles a third follows, and from the third and one (or both) of the
       two and one (or more) external assertible(s) another follows, then this
       other follows from the first two and the external(s)."

       We use ` th ` to represent the "external" assertibles.  This is version
       a, which is without the phrase "or both"; see ~ stoic4b for the version
       with the phrase "or both".  (Contributed by David A. Wheeler,
       17-Feb-2019.) $)
    stoic4a $p |- ( ( ph /\ ps /\ th ) -> ta ) $=
      ( w3a 3adant3 simp1 simp3 syl3anc ) ABDHCADEABCDFIABDJABDKGL $.
  $}

  ${
    $( Premise 1 for Stoic logic Thema 4b. $)
    stoic4b.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Premise 2 for Stoic logic Thema 4b. $)
    stoic4b.2 $e |- ( ( ( ch /\ ph /\ ps ) /\ th ) -> ta ) $.
    $( Stoic logic Thema 4 version b.  This is version b, which is with the
       phrase "or both".  See ~ stoic4a for more information.  (Contributed by
       David A. Wheeler, 17-Feb-2019.) $)
    stoic4b $p |- ( ( ph /\ ps /\ th ) -> ta ) $=
      ( w3a 3adant3 simp1 simp2 simp3 syl31anc ) ABDHCABDEABCDFIABDJABDKABDLGM
      $.
