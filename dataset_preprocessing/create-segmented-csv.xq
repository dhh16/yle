
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "csv";
declare option output:csv "header=yes, separator=semicolon";

declare function local:create-date($date as xs:string) as xs:string? {
  let $year:=substring($date,1,4)
  let $month:=substring($date,5,2)
  let $day:=substring($date,7,2)
  return if($year) then
    string-join(($year,$month,$day),'-')
   else()
  
};

declare function local:convert-milliseconds-to-minutes($duration as xs:string) as xs:string? {
  
  let $duration_as_minutes:=
    (: If seems that default length of 1000 msec has been used as a placeholder:)
    if(string-length($duration)>1 and $duration != '1000') then
      xs:string((xs:int($duration) div 1000) div 60)
    else()
  return $duration_as_minutes
};

let $csv:=
<csv>{
  for $record in /programmes/AXFRoot
    (:Tunniste:)
    let $id:=data($record/MAObject[@mdclass="PROGRAMME"]/GUID)
    (: Ohjelman nimi:)
    let $programme_title:=replace(normalize-space(data($record/MAObject[@mdclass="PROGRAMME"]/Meta[@name="SECONDARY_TITLE"])),'\.\.\.','.')
    let $tokenized_title:=tokenize($programme_title,'\.\s')
    (: Ensilähetyspvm:)
    let $firstrun_date:=local:create-date($record/MAObject/Meta[@name="FIRSTRUN_DATE"])
    let $program_duration:=
      if (string-length($record/MAObject/Meta[@name="DURATION"]) > 1) then 
        $record/MAObject/Meta[@name="DURATION"] div 1000
        else()
    
    let $segmented_contents:=
      for $segment in $record/Stratum[@name="CONTENT_DESCRIPTION"]/Segment 
        let $segment_length:=  ($segment/End - $segment/Begin) div 1000 
        return
          <entry>
            <id>{$id}</id>
            <programme_title>{$programme_title}</programme_title> 
            <title_token_1>{$tokenized_title[1]}</title_token_1>
            <title_token_2>{$tokenized_title[2]}</title_token_2>
            <title_token_3>{$tokenized_title[3]}</title_token_3>
            <title_token_4>{$tokenized_title[4]}</title_token_4>
            <title_token_5>{$tokenized_title[5]}</title_token_5>
            <title_token_6>{$tokenized_title[6]}</title_token_6> 
            <firstrun_date>{$firstrun_date}</firstrun_date>
            <segment_length>{$segment_length}</segment_length>
            <program_duration>{$program_duration}</program_duration>
            <content>{data(normalize-space($segment/Content))}</content>
          </entry>
      return $segmented_contents
    }</csv>
return $csv