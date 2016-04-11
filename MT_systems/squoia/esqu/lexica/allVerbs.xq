let $documents := '/db/MT_Systems/ancoralex/verb-es'

return
<lexentries>{
for $doc in collection($documents)
for $lexentry in $doc//lexentry
  return $lexentry
}</lexentries>