import csv
from collections import defaultdict
import sexmachine.detector as gender

#READ CSV
columns = defaultdict(list) 
with open('NERoutput.csv') as f:
	reader = csv.DictReader(f)
	for row in reader:
		for (k,v) in row.items():#iteritems
			columns[k].append(v)
ids = columns.get('id')
#contents = columns.get('content')
ner = columns.get('NER')
print "csv file read"

data = {id: row for id, row in zip(ids, ner)}
output = ()
d = gender.Detector()
for idn in data:
	ent = data.get(idn)
	#CLEAN ENT
	#if tag is PER, get first name and store by id, gender in dict
	if isinstance(ent, str):
		if ent[1:6] =='I-PER': #len(ent) > 3 and 
			ent = ent.replace("u'",'')
			ent = ent.replace("'",'')
			rec = ent[7:-2].split(';')
			for entity in rec:
				name = ''.join(ch for ch in entity if ch.isalnum())
				output += (idn, name, d.get_gender(name),'XOXO')
	
print "writing to file"
#WRTITE gender TO FILE
text_file = open("genders.txt","w")
text_file.write(str(output))
text_file.close()
print "all done"