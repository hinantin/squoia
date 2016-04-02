let $documents := '/db/MT_Systems/ancoralex/verb-es'
for $doc in collection($documents)
for $lexentry in $doc//lexentry
  let $lemma := data($lexentry//@lemma)
  return 
  <type lemma="{$lemma}"> {
  for $frame in $lexentry//descendant::frame
    let $lss := data($frame/@lss)
    let $type := data($frame/@type)
    let $thematicRoleOfSubj := $frame//child::argument[@function eq 'suj'][1]/@thematicrole
    return 
        if ($type ne 'resultative') then ( <lsstype value="{ concat($lss, '#', $type, '##', $thematicRoleOfSubj) }" /> )
        else ()
  } </type>