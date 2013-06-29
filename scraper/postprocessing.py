#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from optparse import OptionParser
import json
from nltk.tokenize import word_tokenize
from nltk.stem.porter import PorterStemmer
from nltk.text import TokenSearcher
from nltk.corpus import stopwords

parser = OptionParser()
parser.add_option("-i", "--infile", dest="infile", help="Read JSON from FILE", metavar="FILE", default="-")
parser.add_option("-m", "--meshfile", dest="meshfile", help="Read MESH terms from FILE", metavar="FILE", default="")
parser.add_option("-o", "--outfile", dest="outfile", help="Write JSON output to FILE", metavar="FILE", default="infile")
parser.add_option("-n", "--number", dest="number", help="Retain top N MESH terms", metavar="N", default=5)
options = parser.parse_args()[0]

stemmer = PorterStemmer()
meshterms = {}

meshfile = open(options.meshfile, 'r')
for meshterm in meshfile:
    stripped = meshterm.strip()
    mesh_tokenized = word_tokenize(stripped)
    meshterms[stripped] = [[stemmer.stem(w) for w in mesh_tokenized]]
    meshterms[stripped].append("<%s>" % "> <".join(meshterms[stripped][0]))
meshfile.close()

if options.infile == '-':
    inputfile = sys.stdin
else:
    inputfile = open(options.infile, 'r')
data = json.load(inputfile, "utf-8")
inputfile.close()

stemmed = {}
stopwords_en = set(stopwords.words('english'))

i = 1
for team in data:
    tokenized = word_tokenize(team['abstract'])
    stemmed[(team['year'], team['name'])] = TokenSearcher(stemmer.stem(w) for w in tokenized)
    found = {}
    for (term, processed) in meshterms.iteritems():
        length = len(stemmed[(team['year'], team['name'])].findall(processed[1]))
        if length > 0:
            found[term] = length
    if len(found) > 0:
        mesh_sorted = found.keys()
        mesh_sorted.sort(lambda x,y: cmp(found[x], found[y]))
        team['meshterms'] = {meshterm : found[meshterm] for meshterm in mesh_sorted[0:options.number] if found[meshterm] > 0}
    information = 0
    for w in tokenized:
        if w not in stopwords_en:
            information += 1
    team['information_content'] = information / float(len(tokenized))
    print >> sys.stderr, "\r%d / %d" % (i, len(data)),
    i += 1

print >> sys.stderr, "\n",

if options.outfile == '-':
    outfile = sys.stdout
else:
    outfile = open(options.outfile, 'w')
outfile.write(json.dumps(data, indent=4, ensure_ascii=False, encoding="utf-8").encode("utf-8"))
outfile.close()
