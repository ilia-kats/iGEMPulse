from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector
import json
from scrapy import log

from igem.items import TeamMembers, IgemItem

def jsonImport(fp):
    doc = open(fp)
    data = json.load(doc)
    doc.close()
    return data


class igemTestSpider(BaseSpider):
    name = "test"
    allowed_domains = ["igem.org"]
    
    def __init__(self, datasetFile="whole_dataset.json"):
        dataset = jsonImport(datasetFile)
        self.start_urls = []
        i = 0
        for t in dataset[0:10]:
            self.start_urls.append(t["teamInfo"])
#           print '%d) %s' % (i, start_urls[i])
            i += 1
        
#        print self.start_urls
#    for t in dataset[0:10]:
#        yield Request(t["teamInfo"],
#            callback=self.parse)
                
    def parse(self, response):
        hxs = HtmlXPathSelector(response)
        item = TeamMembers()
        item["teamInfo"] = response.meta['redirect_urls'][0]
        #print vars(self) #.dataset[2]["name"]
#        item["name"] = hxs.select('//*[@id="table_info"]/tr[1]/td[2]/text()').extract()
#        item["year"] = hxs.select('//title').re('\d{4}')
        roster = hxs.select('//*[@id="table_roster"]')
        for rost in roster:
            context = rost.select('.//tr[1]/td[1]/b/text()').extract()[0].replace(" ", "_")
#            print context
            members = rost.select('.//tr[position()!=1]/td[2]/text()').extract()
#            print members
            item[context] = members
        return item


#class igemAbstractSpider(BaseSpider):
#    name = "teams"
#    allowed_domains = ["igem.org"]
#    start_urls = [
#        "http://2008.igem.org/Jamboree/Project_Abstract/Team_Abstracts",
#        "http://2009.igem.org/Jamboree/Project_Abstract/Team_Abstracts",
#        "http://2010.igem.org/Jamboree/Project_Abstract/Team_Abstracts",
#        "http://2011.igem.org/Jamboree/Team_Abstracts"
#    ]

#    def parse(self, response):
#       hxs = HtmlXPathSelector(response)
#       year = hxs.select('//title').re('\d{4}')
#       if year == [u'2008'] or year == [u'2011']:
#           teams = hxs.select('id("bodyContent")/h4')
#       else:
#           teams = hxs.select('id("bodyContent")/h3')
#       items = []
#       for team in teams:
#           link = team.select('span[@class="mw-headline"]/a/@href').extract()
#           if link:
#               item = IgemItem()
#               if year == [u'2008']:
#                   name = team.select('span[@class="mw-headline"]/a/text()').re('^ (\S+)')
#                   if name:
#                       item['year'] = year
#                       item['name'] = name
#                       item['title'] = [team.select('following::p//text()')[0].extract()]
#                       link = team.select('span[@class="mw-headline"]/a/@href').extract()
#                       item['link'] = ["http://" + year[0] + ".igem.org" + link[0]]
#                       item['abstract'] = team.select('following::p/text()')[1].extract()
#               elif year == [u'2011']:
#                   name = team.select('span[@class="mw-headline"]/a/text()').re(' Team (\S+)')
#                   if name:
#                       item['year'] = year
#                       item['name'] = name
#                       item['title'] = team.select('span[@class="mw-headline"]/text()').re(': (.+)')
#                       link = team.select('span[@class="mw-headline"]/a/@href').extract()
#                       item['link'] = ["http://" + year[0] + ".igem.org" + link[0]]
#                       item['abstract'] = team.select('following::p/text()')[0].extract()
#               else:
#                   name = team.select('span[@class="mw-headline"]/a/text()').re('(\w+):')
#                   if name:
#                       item['year'] = year
#                       item['name'] = name
#                       item['title'] = team.select('span[@class="mw-headline"]/text()').extract()
#                       link = team.select('span[@class="mw-headline"]/a/@href').extract()
#                       item['link'] = ["http://" + year[0] + ".igem.org" + link[0]]
#                       item['abstract'] = team.select('following::p/text()')[0].extract()
#               items.append(item)
#       return items

