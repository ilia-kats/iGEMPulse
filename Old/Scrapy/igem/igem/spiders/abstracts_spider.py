from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector
import json

from igem.items import IgemItem

class igemAbstractSpider(BaseSpider):
    name = "abstracts"
    allowed_domains = ["igem.org"]
    start_urls = [
        "http://2008.igem.org/Jamboree/Project_Abstract/Team_Abstracts",
        "http://2009.igem.org/Jamboree/Project_Abstract/Team_Abstracts",
        "http://2010.igem.org/Jamboree/Project_Abstract/Team_Abstracts",
        "http://2011.igem.org/Jamboree/Team_Abstracts"
    ]

    def parse(self, response):
       hxs = HtmlXPathSelector(response)
       year = hxs.select('//title').re('\d{4}')
       if year == [u'2008'] or year == [u'2011']:
           teams = hxs.select('id("bodyContent")/h4')
       else:
           teams = hxs.select('id("bodyContent")/h3')
       items = []
       for team in teams:
           link = team.select('span[@class="mw-headline"]/a/@href').extract()
           if link:
               item = IgemItem()
               if year == [u'2008']:
                   name = team.select('span[@class="mw-headline"]/a/text()').re('^ (\S+)')
                   if name:
                       item['year'] = year
                       item['name'] = name
                       item['title'] = [team.select('following::p//text()')[0].extract()]
                       link = team.select('span[@class="mw-headline"]/a/@href').extract()
                       item['link'] = ["http://" + year[0] + ".igem.org" + link[0]]
                       item['abstract'] = team.select('following::p/text()')[1].extract()
               elif year == [u'2011']:
                   name = team.select('span[@class="mw-headline"]/a/text()').re(' Team (\S+)')
                   if name:
                       item['year'] = year
                       item['name'] = name
                       item['title'] = team.select('span[@class="mw-headline"]/text()').re(': (.+)')
                       link = team.select('span[@class="mw-headline"]/a/@href').extract()
                       item['link'] = ["http://" + year[0] + ".igem.org" + link[0]]
                       item['abstract'] = team.select('following::p/text()')[0].extract()
               else:
                   name = team.select('span[@class="mw-headline"]/a/text()').re('(\w+):')
                   if name:
                       item['year'] = year
                       item['name'] = name
                       item['title'] = team.select('span[@class="mw-headline"]/text()').extract()
                       link = team.select('span[@class="mw-headline"]/a/@href').extract()
                       item['link'] = ["http://" + year[0] + ".igem.org" + link[0]]
                       item['abstract'] = team.select('following::p/text()')[0].extract()
               items.append(item)
       return items

