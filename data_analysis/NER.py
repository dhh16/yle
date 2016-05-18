from polyglot.text import Text
import numpy as np
from numpy import loadtxt
import nltk
import csv
from collections import defaultdict

#ids = np.genfromtxt('ylestripped.csv', delimiter=',', usecols=0, dtype=str)
#contents = np.genfromtxt('ylestripped.csv', delimiter=',',dtype=str)[:,2:]
columns = defaultdict(list) 
with open('ylestripped.csv') as f:
	reader = csv.DictReader(f)
	for row in reader:
		for (k,v) in row.items():#iteritems
			columns[k].append(v)
ids = columns.get('id')
contents = columns.get('content')
data = {id: row for id, row in zip(ids, contents)}
#print "data read"
#data = [(id, row) for id, row in zip(ids,contents)]
#print "data stored"

output = csv.writer(open("yletemp.csv", "wb"))
output.writerow(('id', 'content','NE','tag'))
#print "creating csv"

for idd, content in data.iteritems():

 	text = Text(content, hint_language_code='fi')
 	
 	output.writerow([idd,content,text.entities])
	#print idd,content,text.entities#, text.tag
# 	
#print "All done!"
