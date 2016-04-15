xquery version "3.0";

let $dom := doc('/db/MT_Systems/squoia/esqu/lexica/es-quz.dix')

return $dom//section//e[descendant::l eq "fumador"]
