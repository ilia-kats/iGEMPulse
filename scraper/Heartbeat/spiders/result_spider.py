from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector
from scrapy.http import Request

from Heartbeat.items import ResultItem

class ResultSpider(BaseSpider):
    name = 'ResultSpider'

    def __init__(self):
        self.seenTeams = set() # avoid duplicates when teams are listed both for continent and championship

    def start_requests(self):
        for year in self.crawler.settings['YEARS']:
            yield self.make_requests_from_url(self.crawler.settings['RESULTS'] % year)

    def parse(self, response):
        hxs = HtmlXPathSelector(response)
        year = int(hxs.select("//h1[@class='firstHeading']/text()").re("for iGEM (\d{4})")[0])
        for teamtable in hxs.select("//table[starts-with(@id, 'table_Teams_from_')]"):
            region = teamtable.select("./@id").extract()[0][17:]
            for team in teamtable.select(".//td"):
                if not team.select("./*"):
                    continue
                item = ResultItem()
                item['year'] = year
                item['name'] = team.select("./div[@class='teambar']/p/a/text()").extract()[0]
                if (year, item['name']) in self.seenTeams:
                    continue
                else:
                    self.seenTeams.add((year, item['name']))
                seal = team.select("./div[@class='teambar']/div[@class='resulticons']/img[@class='seal']/@alt").extract()
                if seal:
                    item['medal'] = seal[0].split(" ")[0]
                awards = team.select("./div[@class='awardbar']/p/text()").extract()
                item['awards_regional'] = []
                item['awards_championship'] = []
                for award in awards:
                    if award.endswith(region):
                        item['awards_regional'].append(award)
                    else:
                        item['awards_championship'].append(award)
                yield item
