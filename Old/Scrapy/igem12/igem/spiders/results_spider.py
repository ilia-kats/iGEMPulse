from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector

from igem.items import IgemItem

class igemAbstractSpider(BaseSpider):
    name = "results"
    allowed_domains = ["igem.org"]
    start_urls = [
        "http://igem.org/Results?year=2008&division=igem",
        "http://igem.org/Results?year=2009&division=igem",
        "http://igem.org/Results?year=2010&division=igem",
        "http://igem.org/Results?year=2011&division=igem",
        "http://igem.org/Results?year=2012&division=igem",
    ]

    def parse(self, response):
       hxs = HtmlXPathSelector(response)
       year = hxs.select('id("content")/h1').re('\d{4}')
       teams = hxs.select('id("bodyContent")//td[@style="width:400px;padding:2px;"]')
       items = []
       for team in teams:
           withdrew = team.select('div[@class="teambar"]/div[@class="resulticons"]/p/text()').extract()
           if not withdrew:
               name = team.select('div[@class="teambar"]/p/a[@title="Go to team wiki"]/text()').extract()
               if name:
                   item = IgemItem()
                   item['year'] = year
                   item['name'] = name
                   item['medal'] = team.select('div[@class="teambar"]/div[@class="resulticons"]/img/@alt').extract()
                   item['award'] = team.select('div[@class="awardbar"]').select('child::p/text()').extract()
                   items.append(item)
       return items

