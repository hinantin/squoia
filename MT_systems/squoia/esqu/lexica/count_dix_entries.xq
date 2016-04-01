xquery version "3.0";

let $dom := doc('/db/MT_Systems/squoia/esqu/lexica/es-quz.dix')
let $results := <results>{
for $section in $dom//section
  let $r := $section//e//r[1]
  let $total := count($r)
  let $untranslated := count($r[text() eq 'unspecified'])
  let $translated := $total - $untranslated
    return 
        <result section="{data($section//@id)}" entries="{$total}" unspecified="{$untranslated}" translated="{$translated}"/>
}
</results>

return <query>
    <total totalentries="{sum($results//result//@entries)}" totalunspecified="{sum($results//result//@unspecified)}" totaltranslated="{sum($results//result//@translated)}" />
    {$results}
    </query>
