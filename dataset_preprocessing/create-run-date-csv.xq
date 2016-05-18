declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "csv";
declare option output:csv "header=yes, separator=semicolon";

declare function local:create-date($date as xs:string) as xs:string {
  let $year:=substring($date,1,4)
  let $month:=substring($date,5,2)
  let $day:=substring($date,7,2)
  return string-join(($year,$month,$day),'-')
  
};

let $csv:=
<csv>{
  for $record in  db:open("yle-data")/programmes/AXFRoot/MVAttribute[@type="PUBLICATIONS_TVAR"]
  let $program_id:=data($record/@objectid)
  
  let $publication_date:= local:create-date(data($record/Meta[@name="PUB_DATETIME"]))
 
 let $type:=data($record/Meta[@name="PUB_MODE"])
      return
      <entry>
      <id>{$program_id}</id>
      <date>{$publication_date}</date>
      <type>{$type}</type>
      </entry>
 }</csv>
return $csv   