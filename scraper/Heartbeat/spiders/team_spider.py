from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector
from scrapy.http import Request

from Heartbeat.items import TeamItem

class TeamSpider(BaseSpider):
    name = 'TeamSpider'

    def __init__(self):
        self.seenTeams = set() # avoid duplicates when teams are listed both for continent and championship

    def start_requests(self):
        for year in self.crawler.settings['YEARS']:
            yield self.make_requests_from_url(self.crawler.settings['TEAM_LIST'] % year)

    def parse(self, response):
        hxs = HtmlXPathSelector(response)
        teamtables = hxs.select("//table[starts-with(@id, 'table_Teams_from_')]")
        for url in teamtables.select(".//a/@href").extract():
            yield Request(url, callback=self.parseTeam, meta={'url': url, 'cookiejar': url})

    def parseTeam(self, response):
        if response.meta['url'] not in self.seenTeams:
            hxs = HtmlXPathSelector(response)
            item = TeamItem()
            item['year'] = int(hxs.select("//h1[@class='firstHeading']/text()").re("IGEM (\d{4})")[0])
            item['name'] = hxs.select("//table[@id='table_info']/tr[1]/td[2]/text()").extract()[0].replace("_", " ")
            item['region'] = hxs.select("//table[@id='table_info']/tr[td[1]/text()='Region:']/td[2]/text()").extract()[0]
            item['project'] = "".join(hxs.select("//table[@id='table_abstract']/tr[1]/td[1]//text()").extract())
            item['abstract'] = "".join(hxs.select("//table[@id='table_abstract']/tr[2]/td[1]//text()").extract())
            track = hxs.select("//table[@id='table_tracks']//td/text()").extract()[0]
            if track.startswith("Assigned Track:"):
                item['track'] = track[15:].strip()
            item['instructors'] = hxs.select("//table[@id='table_roster'][1]//tr/td[2]/text()").extract()
            item['students'] = hxs.select("//table[@id='table_roster'][2]//tr/td[2]/text()").extract()
            item['advisors'] = hxs.select("//table[@id='table_roster'][3]//tr/td[2]/text()").extract()
            item['url'] = response.meta['url'] # can't use response.url due to redirect
            item['wiki'] = hxs.select("//table[@id='table_info']/tr[1]/td[2]/div/a[1]/@href").extract()[0]
            item['parts_range'] = hxs.select("//table[@id='table_ranges']//span/text()").re("(BBa_[^\s]+) to (BBa_[^\s]+)")

            self.seenTeams.add(item['url'])

            return item
