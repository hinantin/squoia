xquery version "3.0";
declare namespace html = "http://www.w3.org/1999/xhtml";
declare namespace exist = "http://exist.sourceforge.net/NS/exist";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace request="http://exist-db.org/xquery/request";

(: return xdmp:eval("1+8+9+1") :)
declare function local:getCommand($SRCAttr as xs:string?, $TRGAttr as xs:string?, $ELEMENT as xs:string?, $AttrName as xs:string?, $AttrValue as xs:string?) as xs:string?
{
  fn:concat("let $ELEMENT := ",$ELEMENT," return if (fn:exists($ELEMENT/@",$AttrName,")) then ( update value $ELEMENT/@",$AttrName," with ", $AttrValue, " ) else ( update insert attribute ",$AttrName," { ", $AttrValue, " } into $ELEMENT )")
};

declare function local:propagateAttr($SRC as node()?, $SRCAttr as xs:string?, $SRCType as xs:string?, $TRG as node()?, $TRGAttr as xs:string?, $TRGType as xs:string?, $direction as xs:string?, $wmode as xs:string?) as xs:string?
{
  let $targetAttribute := 
      if (fn:matches($TRGAttr,"\$NODE")) then fn:replace($TRGAttr,"\$NOD.+/@", "", "") 
      else if (fn:matches($TRGAttr,"\$CHUNK")) then fn:replace($TRGAttr,"\$CHUN.+/@", "", "") 
      else () 
  let $target := 
      if (fn:matches($TRGAttr,"\$NODE")) then fn:replace($TRGAttr, "\$NODE", "\$TRG") 
      else if (fn:matches($TRGAttr,"\$CHUNK")) then fn:replace($TRGAttr, "\$CHUNK", "\$TRG") 
      else ( $TRGAttr )
  let $sourceAttribute := if (fn:matches($SRCAttr,"\$NODE/@|\$CHUNK/@")) then fn:replace($SRCAttr, fn:concat("\$", $SRCType, "/@"), "") else () 
  let $source := if (fn:matches($SRCAttr,"\$NODE/@|\$CHUNK/@")) then fn:concat("$SRC/@", $sourceAttribute) else ( $SRCAttr )  
  let $element := fn:replace($target, fn:concat("/@", $targetAttribute,"$"), "")
  let $command := 
    if ($wmode eq "concat") then ( 
      let $AttrValue := fn:concat('fn:concat(', $target, ',",",', $source,')') 
      return local:getCommand($SRCAttr, $target, $element, $targetAttribute, $AttrValue)
    ) else 
    if ($wmode eq "concatnodelim") then ( 
      let $AttrValue := fn:concat('fn:concat(', $target, ',', $source,')')
      return local:getCommand($SRCAttr, $target, $element, $targetAttribute, $AttrValue)
    ) else 
    if ($wmode eq "overwrite") then ( 
      local:getCommand($SRCAttr, $target, $element, $targetAttribute, $source)
    ) else 
    if ($wmode eq "no-overwrite") then ( 
      fn:concat("if (not(fn:exists(",$target,"))) then ( update insert attribute ", $targetAttribute," { ", $source, " } into ",$element," ) else ()")
    ) else ( error(QName("http://hinant.in/err", "wmode"), fn:concat("Wrong write mode: ", $wmode)) )
  let $result := util:eval($command)
  return $command
};

let $inputfile := request:get-parameter('inputfile', '')
let $outputfile := request:get-parameter('outputfile', '')

let $dom := doc(fn:concat("/db/MT_Systems/tmp/",$inputfile))
let $intraConditions := doc('/db/MT_Systems/squoia/esqu/grammar/esqu_intrachunk_transfer.xml')
return <methodResponse><params><param><value><string> {
for $CHUNK in $dom//CHUNK 
  for $intraNODE in $CHUNK/child::NODE (: Getting intranodes :)
    for $intraRULE in $intraConditions//rule
    let $s := fn:replace(data($intraRULE/child::descendantCond), "\$NODE", "\$intraNODE")
    let $result := util:eval($s)
    where not(fn:empty($result))
    return 
        (: the sequence must not go up to $CHUNK or its ancestors :)
        for $ancestorCHUNK in ($result/ancestor::CHUNK except $CHUNK/ancestor-or-self)
        let $s := fn:replace(data($intraRULE/child::ancestorCond), "\$CHUNK", "\$ancestorCHUNK")
        let $result := util:eval($s)
        where not(fn:deep-equal($ancestorCHUNK, $CHUNK))
            return
              if (fn:empty($result)) then ()
              else (
                let $direction := data($intraRULE/child::direction)
                let $descendantAttr := data($intraRULE/child::descendantAttr)
                let $ancestorAttr := data($intraRULE/child::ancestorAttr)
                let $writeMode := data($intraRULE/child::writeMode)
                return 
                  if ($direction eq "up") then local:propagateAttr($intraNODE, $descendantAttr, "NODE", $ancestorCHUNK, $ancestorAttr, "CHUNK", $direction, $writeMode)
                  else if ($direction eq "down") then local:propagateAttr($ancestorCHUNK, $ancestorAttr, "CHUNK", $intraNODE, $descendantAttr, "NODE", $direction, $writeMode)
                  else ( error(QName("http://hinant.in/err", "direction"), fn:concat("Wrong direction: ", $direction)) )
              )
} </string></value></param></params></methodResponse>

