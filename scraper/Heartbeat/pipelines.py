# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/topics/item-pipeline.html

import json

from Heartbeat.items import TeamItem, ResultItem

class HeartbeatPipeline(object):
    spiders = 0
    data = {}
    outfile = ''

    @classmethod
    def from_crawler(cls, crawler):
        cls.outfile = crawler.settings['OUTFILE']
        return cls()

    @classmethod
    def open_spider(cls, spider):
        cls.spiders += 1

    @classmethod
    def close_spider(cls, spider):
        cls.spiders -= 1
        if cls.spiders == 0:
            outf = open(cls.outfile, "w")
            outf.write(json.dumps(cls.data.values(), indent=4, ensure_ascii=False, encoding="utf-8").encode("utf-8"))
            outf.close()

    @classmethod
    def process_item(cls, item, spider):
        if isinstance(item, (TeamItem, ResultItem)):
            if (item['year'], item['name']) not in cls.data:
                cls.data[(item['year'], item['name'])] = dict(item)
            else:
                cls.data[(item['year'], item['name'])].update(dict(item))
        return item
