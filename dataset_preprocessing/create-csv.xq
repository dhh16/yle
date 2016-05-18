
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
         return if ($individual != '') then
         normalize-space($individual)
         else()
         
  return string-join($clean_codes,'|')
  
  
};

declare function local:create-date($date as xs:string) as xs:string {
  let $year:=substring($date,1,4)
  let $month:=substring($date,5,2)
  let $day:=substring($date,7,2)
  return string-join(($year,$month,$day),'-')
  
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
  for $record in /programmes/AXFRoot[position()<5]
    let $id:=data($record/MAObject[@mdclass="PROGRAMME"]/GUID)
    let $programme_title:=replace(normalize-space(data($record/MAObject[@mdclass="PROGRAMME"]/Meta[@name="SECONDARY_TITLE"])),'\.\.\.','.')
    let $tokenized_title:=tokenize($programme_title,'\.\s')
    let $finnish_title:=normalize-space(data($record/MAObject[@mdclass="PROGRAMME"]/Meta[@name="FI_TITLE"]))
    let $swedish_title:=normalize-space(data($record/MAObject[@mdclass="PROGRAMME"]/Meta[@name="SE_TITLE"]))
    let $main_title:=normalize-space(data($record/MAObject/Meta[@name="MAIN_TITLE"]))
    let $third_title:=normalize-space(data($record/MAObject/Meta[@name="THIRD_TITLE"]))
    let $firstrun_date:=local:create-date($record/MAObject/Meta[@name="FIRSTRUN_DATE"])
    let $firstrun_time:=data($record/MAObject/Meta[@name="FIRSTRUN_TIME"])
    let $date_of_capture:=local:create-date($record/MAObject/Meta[@name="DATE_OF_CAPTURE"])
    let $contributor:=normalize-space(data($record/MAObject/Meta[@name="CONTRIBUTOR2"]))
    let $duration:=local:convert-milliseconds-to-minutes(data($record/MAObject/Meta[@name="DURATION"]))
    let $origin:=data($record/MAObject/Meta[@name="ORIGIN"])
    let $description:=normalize-space(data($record/MAObject/Meta[@name="SUBJECT"]))
    let $subject:=normalize-space(string-join($record/Stratum[@name="SUBJECT"]/Segment/Content,' '))
    let $finnish_subs:=normalize-space(string-join($record/Stratum[@name="SUBTITLE_FIN"]/Segment/Content,' '))
    let $swedish_subs:=normalize-space(string-join($record/Stratum[@name="SUBTITLE_SWE"]/Segment/Content,' '))
    let $press_description:=normalize-space(data($record/MAObject/Meta[@name="DESCRIPTION_SHORT"]))
    let $contributors:=normalize-space(string-join(distinct-values($record/MVAttribute[@type="CONTRIBUTORS"]/Meta[@name="CONT_PERSON_NAME"]),'|'))
    let $content:=normalize-space(string-join($record/Stratum[@name="CONTENT_DESCRIPTION"]/Segment/Content,' '))
    let $persons_visible:=normalize-space(string-join($record/Stratum[@name="PERSONS_VISIBLE"]/Segment/Content,' '))
    let $actors:=normalize-space(string-join(($record/MAObject/Meta[@name="ACTORS"],$record/MAObject/Meta[@name="ACTORS1"]),' '))
    let $classification_main:=normalize-space(data($record/MAObject/Meta[@name="CLASSIFICATION_MAIN_CLASS"]))
    let $classification_content:=normalize-space(data($record/MAObject/Meta[@name="CLASSIFICATION_CONTENT"]))
    let $classification_comb:=normalize-space(data($record/MAObject/Meta[@name="CLASSIFICATION_COMB_A"]))
    let $archivist_codes:=local:process-archivist-codes(data($record/MAObject/Meta[@name="TVAR_DOCUMENTALIST_ID"]))
    
  
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
  <finnish_title>{$finnish_title}</finnish_title>
  <swedish_title>{$swedish_title}</swedish_title>
  <main_title>{$main_title}</main_title>
  <third_title>{$third_title}</third_title>
  <firstrun_date>{$firstrun_date}</firstrun_date>
  <firstrun_time>{$firstrun_time}</firstrun_time>
  <capture_date>{$date_of_capture}</capture_date>
  <contributor>{$contributor}</contributor>
  <actors>{$actors}</actors>
  <origin>{$origin}</origin>
  <description>{$description}</description>
  <subject>{$subject}</subject>
  <finnish_subs>{$finnish_subs}</finnish_subs>
  <swedish_subs>{$swedish_subs}</swedish_subs>
  <contributors>{$contributors}</contributors>
  <interviewed_persons>{$persons_visible}</interviewed_persons>
  <content>{$content}</content>
  <duration>{$duration}</duration>
  <classification_main>{$classification_main}</classification_main>
  <classification_sub>{$classification_main}</classification_sub>
  <classification_content>{$classification_content}</classification_content>
  <classification_comb>{$classification_comb}</classification_comb>
  <archivist_codes>{$archivist_codes}</archivist_codes>
</entry>
}</csv>
return $csv