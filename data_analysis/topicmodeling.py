import csv
from collections import defaultdict
import numpy as np  
import sklearn.feature_extraction.text as text
from sklearn import decomposition

columns = defaultdict(list) 
with open('yle-csv-Kekkonen.csv') as f:
	reader = csv.DictReader(f)
	for row in reader:
		for (k,v) in row.items():#iteritems
			columns[k].append(v)
ids = columns.get('id')
contents = columns.get('content')

#FIX ENCODING HERE
data = {id: row for id, row in zip(ids, contents)}

my_stop_words = []
uline = ''
with open("finstop.txt") as d:
	for line in d:
		line = line.replace('\n', '')
		#uline = u'\t'.join((line)).decode('utf-8').strip()
		my_stop_words.append(line)#.encode('utf-8'))
	d.close()

stop_words2 = text.ENGLISH_STOP_WORDS.union(my_stop_words)

print(my_stop_words)

vectorizer = text.CountVectorizer(input=contents, stop_words=stop_words2, min_df=20)
dtm = vectorizer.fit_transform(contents).toarray()
vocab = np.array(vectorizer.get_feature_names())

num_topics = 20
num_top_words = 20
clf = decomposition.NMF(n_components=num_topics, random_state=1)
doctopic = clf.fit_transform(dtm)

topic_words = []

for topic in clf.components_:
	word_idx = np.argsort(topic)[::-1][0:num_top_words]
	topic_words.append([vocab[i] for i in word_idx])

	doctopic = doctopic / np.sum(doctopic, axis=1, keepdims=True)

#WRTITE topics TO FILE
topics = ""
text_file = open("topics.txt", "w")
topic_counter = 0 
for t in topic_words:
	topic_counter += 1
	topics += "Topic " + str(topic_counter) + "\t" + u'\t'.join((t)).encode('utf-8').strip() + '\n'
	
text_file.write(topics)
text_file.close()