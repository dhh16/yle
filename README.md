# Mining Mediated Memory (DHH16)

## Explorations of YLE Metro Metadata


### Analysis scripts

* metro-metadata-analysis.Rmd
* metro-metadata-change-activity.Rmd
* metro-topic-modeling.Rmd
* NER.py
* gender.py
* topicmodeling.py
* viz.py

### Data preprocessing scripts

XQuery scripts require importing XML data to [BaseX XML database](http://basex.org).

* create-csv.xq -- creates a CSV version of the dataset.
* create-documentarist-id.xq -- creates a CSV with information related to metadata changes
 
OpenRefine was used to categorize the data and to create subsets of the data with keyword searches.

* OpenRefineSalla.json -- Directory for OpenRefine scripts.
* OpenRefineSalla-UKK.json --	Scripts for creating the subsets concerning president Kekkonen and parliament elections (eduskuntavaalit)

