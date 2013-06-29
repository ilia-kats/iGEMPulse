#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from optparse import OptionParser
import json
from nltk.tokenize import wordpunct_tokenize, word_tokenize
from nltk.stem.porter import PorterStemmer
from nltk.text import TokenSearcher
from nltk.corpus import stopwords
from nltk.probability import FreqDist

parser = OptionParser()
parser.add_option("-i", "--infile", dest="infile", help="Read JSON from FILE", metavar="FILE", default="-")
parser.add_option("-m", "--meshfile", dest="meshfile", help="Read MESH terms from FILE", metavar="FILE", default="")
parser.add_option("-o", "--outfile", dest="outfile", help="Write JSON output to FILE", metavar="FILE", default="infile")
parser.add_option("-n", "--numbermesh", dest="numbermesh", help="Retain top N MESH terms", metavar="N", default=5)
parser.add_option("-k", "--numberwords", dest="numberwords", help="Retain top N words", metavar="N", default=5)
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

freq_dists = {}
stopwords_en = set(stopwords.words('english'))
freq_dist_background = {}
freq_dist_background_sum = 0

i = 1
for team in data:
    tokenized = wordpunct_tokenize(team['abstract'])
    tokenized_filtered = [w.lower() for w in tokenized if w.lower() not in stopwords_en and w.isalnum() and len(w) > 1]
    stemmed = [stemmer.stem(w) for w in tokenized_filtered]
    searcher = TokenSearcher(stemmed)
    found = {}
    for (term, processed) in meshterms.iteritems():
        length = len(searcher.findall(processed[1]))
        if length > 0:
            found[term] = length
    if len(found) > 0:
        mesh_sorted = found.keys()
        mesh_sorted.sort(lambda x,y: cmp(found[x], found[y]))
        team['meshterms'] = {meshterm : found[meshterm] for meshterm in mesh_sorted[0:options.numbermesh] if found[meshterm] > 0}
    information = 0
    team['information_content'] = len(tokenized_filtered) / float(len(tokenized))
    fdist = FreqDist(tokenized_filtered)
    freq_dists[(team['name'], team['year'])] = fdist
    for (word, count) in fdist.iteritems():
        if word not in freq_dist_background:
            freq_dist_background[word] = count
        else:
            freq_dist_background[word] += count
        freq_dist_background_sum += count
    print >> sys.stderr, "\r%d / %d" % (i, len(data)),
    i += 1

for team in data:
    fdist = freq_dists[(team['name'], team['year'])]
    for w in fdist.iterkeys():
        fdist[w] = (fdist[w] / float(fdist.N())) / (freq_dist_background[w] / float(freq_dist_background_sum))
    words = fdist.keys()
    words.sort(lambda x,y: cmp(fdist[x], fdist[y]))
    team['topwords'] = {word : fdist[word] for word in words[0:options.numberwords]}

print >> sys.stderr, "\n",

if options.outfile == '-':
    outfile = sys.stdout
else:
    outfile = open(options.outfile, 'w')
outfile.write(json.dumps(data, indent=4, ensure_ascii=False, encoding="utf-8").encode("utf-8"))
outfile.close()
