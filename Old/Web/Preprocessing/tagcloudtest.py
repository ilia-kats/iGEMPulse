#!/usr/bin/env python

import re, json, math

def quantinizer(kw, teams):
    i = 0
    for team in teams:
        for tag in team["tags"]:
            if tag == kw:
                i += 1
    return i

def jsonImport(fp):
    doc = open(fp)
    data = json.load(doc)
    doc.close()
    return data

def createKwArray(kwFile):
    p = []
    with open (kwFile, 'r') as f:
        for l in f:
            p.append(l.strip())
    p.sort(key=str.lower)
    return p

teams = jsonImport("tagged_dataset.json")
kws = createKwArray("key_terms-extended.txt")
newData = []
linkList = ""
logLinkList = ""
for kw in kws:
    q = quantinizer(kw, teams)
    if q != 0:
        tag = {"text": kw, "weight": q, "html": {"title": "count: " + str(q)}}
        newData.append(tag)
        linkList = linkList + '<a href="#" title="'+kw+' ['+str(q)+']" rel="' + str(q) + '">' + kw + "</a>\n"
        logLinkList = logLinkList + '<span title="'+kw+' ['+str(q)+']" rel="' + str(math.log(q)) + '">' + kw + "</span>\n"

filename = "keywords.json"
open(filename, 'wb').write(json.dumps(newData))
filename2 = "linkList.txt"
open(filename2, 'wb').write(linkList)
filename3 = "logLinkList.txt"
open(filename3, 'wb').write(logLinkList)
