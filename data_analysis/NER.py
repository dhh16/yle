from polyglot.text import Text
import numpy as np
from numpy import loadtxt
import nltk
import csv
from collections import defaultdict


columns = defaultdict(list) 
with open('yle.csv') as f:
	reader = csv.DictReader(f)
	for row in reader:
		for (k,v) in row.items():#iteritems
			columns[k].append(v)
ids = columns.get('id')
contents = columns.get('content')

data = {id: row for id, row in zip(ids, contents)}


#output = csv.writer(open("yletemp.csv", "wb"))
#output.writerow(('id', 'contents','NE','tag'))

output = ""
text_file = open("yle-output.txt","w")
for id in data:
	c = data.get(id)
 	try:
 		text = Text(c, hint_language_code='fi')
 		output += id + "," + c + "," + str(text.entities)
 	except ValueError:
 		pass
text_file.write(output)
text_file.close()

