#!/usr/bin/env python

import re, json

def createRegex (kwFile):
    with open (kwFile, 'r') as f:
        p = "|".join([l.strip() for l in f])
    return re.compile(p)

def jsonImport(fp):
    doc = open(fp)
    data = json.load(doc)
    doc.close()
    return data

rx = createRegex("key_terms-extended.txt")
#abstracts = abstractArray("whole_dataset.json")
#for abstract in abstracts:
#    print rx.findall(abstract)

teams = jsonImport("whole_dataset.json")
newData = []
for team in teams:
    print team['name'] + str(team['year'])
    tags = rx.findall(team['title'] + " " + team['abstract'])
    team['tags'] = (tags if tags else [u'not tagged'])
    newData.append(team)
filename = "tagged_dataset.json"
open(filename, 'wb').write(json.dumps(newData, indent = 4))
