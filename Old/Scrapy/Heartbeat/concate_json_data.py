#!/usr/bin/env python

import json, re

#class merger(object):
#    
#    def jsonImport(self, fp):
#        print fp
##        doc = open(fp)
##        data = json.load(doc)
##        return data
#    
#    def concate(self, fp1, fp2):
#        data1 = self.jsonImport(fp1)
#        data2 = self.jsonImport(fp2)
#        print data1
#    pass
        
#conc1 = merger()
#conc1.concate("tracks.json", "results.json")

def jsonImport(fp):
    doc = open(fp)
    data = json.load(doc)
    doc.close()
    return data

def concate(abstracts, results, tracks, teamMembers):
    dataAbs = jsonImport(abstracts)
    dataRes = jsonImport(results)
    dataTra = jsonImport(tracks)
    dataTM = jsonImport(teamMembers)
    
    # preprocess TM
    teamMembers = {}
    for m in dataTM:
        adress = m.pop("teamInfo")
        teamMembers[adress] = m
    
    newDataset = []
    i = 0
    p = re.compile(' ')
    for itemAbs in dataAbs:
        doubletest = 1 # for resultdatasets 2010/2011 doubled sets are included so we have to check for this
        for itemRes in dataRes:
            itemResName = p.sub('_', str(itemRes['name']))
#            print itemResName
            if str(itemAbs['name']) == itemResName and itemAbs['year'] == itemRes['year'] and doubletest:
#            if str(itemAbs['name']) == itemRes['name'] and itemAbs['year'] == itemRes['year'] and doubletest:
#                print "MATCH"
                newData = {}
                print i
                newData['name'] = itemAbs['name'][0]
                newData["year"] = int(itemAbs['year'][0])
                newData["title"] = (itemAbs['title'][0] if itemAbs['title'] else "")
                newData["link"] = (itemAbs['link'][0] if itemAbs['link'] else "no link")
                newData["abstract"] = itemAbs['abstract']
                newData["medal"] = (itemRes['medal'][0] if itemRes['medal'] else "no medal")
                newData["award"] = itemRes['award']
                for itemTra in dataTra:
                    if itemAbs['name'] == itemTra['name'] and itemAbs['year'] == itemTra['year']:
                        newData["track"] = (itemTra['track'][0] if itemTra['track'] else "")
                        newData["teamInfo"] = (itemTra['teamInfo'][0] if itemTra['teamInfo'] else "")
                        newData["teamMembers"] = teamMembers[newData["teamInfo"]]
                newDataset.append(newData)
                i += 1
                doubletest = 0
    print i
    return newDataset

test = concate("abstracts.json", "results.json", "tracks.json", "teamMembers.json")
#print test
filename = "whole_dataset_with_members.json"
fobj = open(filename, 'wb').write(json.dumps(test, indent = 4))
#test2 = concate("results.json", "abstracts.json")
#print test2
#test3 = concate("tracks.json", "abstracts.json")
#print "tracks" + test3
