#!/usr/bin/env python
from twisted.internet import reactor
from scrapy.crawler import Crawler
from scrapy.settings import Settings
from scrapy.utils.project import inside_project, get_project_settings
from scrapy import log

settings = get_project_settings()

def setupCrawler(spider):
    crawler = Crawler(settings)
    crawler.configure()
    crawler.crawl(crawler.spiders.create(spider))
    crawler.start()

for spider in settings['SPIDERS']:
    setupCrawler(spider)

log.start()
reactor.run() # the script will block here
