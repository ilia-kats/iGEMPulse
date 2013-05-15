from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector

from igem.items import IgemItem

class igemAbstractSpider(BaseSpider):
    name = "tracks"
    allowed_domains = ["igem.org"]
    start_urls = [
        "http://igem.org/Team_Tracks?year=2008",
        "http://igem.org/Team_Tracks?year=2009",
        "http://igem.org/Team_Tracks?year=2010",
        "http://igem.org/Team_Tracks?year=2011",
        "http://igem.org/Team_Tracks?year=2012"
    ]

    def parse(self, response):
       hxs = HtmlXPathSelector(response)
       year = hxs.select('id("content")/h1[@class="firstHeading"]/text()').re('\d{4}')
       tracks = hxs.select('id("bodyContent")//table[@width="915"]')
       items = []
       for track in tracks:
           teams = track.select('.//div[@style="border: none;"]/a')
           for team in teams:
               item = IgemItem()
               item['track'] = track.select('@id').re('table_Teams_from_([\S\s]+)')
               item['year'] = year
               item['name'] = team.select('text()').extract()
               item['teamInfo'] = team.select('@href').extract()
               items.append(item)
       return items

