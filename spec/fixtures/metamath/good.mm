$[ base.mm $]
$( A mandatory $d pair, discharged by the theorem's own condition
   (normal and compressed proofs). $)
${
  $d x ps $.
  th1 $p |- ( ps -> A. x ps ) $= wps vx ax-5 $.
  th1c $p |- ( ps -> A. x ps ) $= ( ax-5 ) ABC $.
$}
$( Distinct setvars, including ones named with punctuation. $)
${
  $d .a .b $.
  th2 $p |- ( .a = .b -> .a = .b ) $= va vb ax-dv $.
$}
$( A dummy variable z that must stay apart from ps: chosen fresh. $)
${
  $d z ps $.
  th3 $p |- ( ps -> ps ) $= wps vz wps vz ax-5 ax-drop $.
  th3c $p |- ( ps -> ps ) $= ( vz ax-5 ax-drop ) ABABCD $.
$}
