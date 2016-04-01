xquery version "3.0";

let $dom := doc('/db/MT_Systems/squoia/esqu/lexica/es-quz.dix')

for $section in $dom//section
  let $r := $section//e//r[1]
  let $total := count($r)
  let $translated := count($r[text() ne 'unspecified'])
  let $untranslated := $total - $translated
    return <e>{concat('u: ',$untranslated, '+ t: ', $translated, ' = ', $total)}</e>
