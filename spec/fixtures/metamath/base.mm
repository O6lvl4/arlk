$( A small database with distinct-variable conditions, for Arlk's tests.
   Shared by every fixture in this directory; each fixture appends
   theorems to it. $)

$c ( ) -> wff |- setvar A. = $.
$v ph ps x y z .a .b $.
wph $f wff ph $.
wps $f wff ps $.
vx $f setvar x $.
vy $f setvar y $.
vz $f setvar z $.
va $f setvar .a $.
vb $f setvar .b $.
wi $a wff ( ph -> ps ) $.
wal $a wff A. x ph $.
weq $a wff x = y $.
${
  min $e |- ph $.
  maj $e |- ( ph -> ps ) $.
  ax-mp $a |- ps $.
$}
${
  $d x ph $.
  ax-5 $a |- ( ph -> A. x ph ) $.
$}
${
  $d x y $.
  ax-dv $a |- ( x = y -> x = y ) $.
$}
${
  ax-drop.1 $e |- ( ph -> A. x ph ) $.
  ax-drop $a |- ( ph -> ph ) $.
$}
