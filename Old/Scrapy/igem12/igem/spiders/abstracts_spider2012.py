from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector
import json

from igem.items import IgemItem

class igemAbstractSpider(BaseSpider):
    name = "abstracts12"
    allowed_domains = ["igem.org"]
    start_urls = [
        "http://igem.org/Team_List?year=2012"
    ]

    def parse(self, response):
       hxs = HtmlXPathSelector(response)
       year = [u'2012']
       teams = hxs.select('id("bodyContent")//a')
       items = []
       for team in teams:
           link = team.select('@href').extract()
           if link:
               item = IgemItem()
               name = team.select('text()').extract()#.re('^ (\S+)')
               
               item['year'] = year
               item['name'] = name
               item['link'] = link#[link[0]]
               items.append(item)
       return items

