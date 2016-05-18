import module namespace functx = 'http://www.functx.com';
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "csv";
declare option output:csv "header=yes, separator=semicolon";



declare function local:process-archivist-codes($codes as xs:string) as xs:string? {
  
  for $value in distinct-values($codes)
     let $individuals:=
       distinct-values(
         tokenize(
            
              replace(
             lower-case($value),'kesken',''),'[,\s]'))
  let $clean_codes:=
      for $individual in $individuals
         return if ($individual != '' or $individual != '.') then
         normalize-space(functx:substring-before-if-contains($individual,'.'))
         else()
         
  return string-join($clean_codes,'|')
  
  
};

declare function local:process-documentation-dates($dates as xs:string) as xs:string? {
 let $clean_dates:=
   for $date in tokenize($dates,' ')
   return  local:create-date($date)
         
  return string-join($clean_dates,'|')
  
  
};

declare function local:create-date($date as xs:string) as xs:string? {
  let $year:=substring($date,1,4)
  let $month:=substring($date,5,2)
  let $day:=substring($date,7,2)
  
  let $date:=
    if ($year) then
    string-join(($year,$month,$day),'-')
    else()
  return $date
};


let $csv1:=
<csv>{
  for $record in /programmes/AXFRoot
    let $id:=data($record/MAObject[@mdclass="PROGRAMME"]/GUID)
    
    let $archivist_codes:=local:process-archivist-codes(data($record/MAObject/Meta[@name="TVAR_DOCUMENTALIST_ID"]))
    let $documentation_dates:=local:process-documentation-dates(data($record/MAObject/Meta[@name="DOCUMENTATION_DATE"]))
  
  return

<entry>
  <id>{$id}</id>
  <change_dates>{$documentation_dates}</change_dates>
  <archivist_codes>{$archivist_codes}</archivist_codes>
</entry>
}</csv>


let $csv2:=
<csv>{for $record in $csv1/entry
  let $dates:=tokenize($record/change_dates,'\|')
  let $codes:=tokenize($record/archivist_codes,'\|')
  for $date in $dates
  for $code in $codes
  let $row:=
    if ($code) then
      <entry>
        <id>{data($record/id)}</id>
        <code>{$code}</code>
        <date>{$date}</date>
      </entry>
    else()
  return $row
}</csv>
return $csv2 