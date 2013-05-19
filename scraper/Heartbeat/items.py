# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/topics/items.html

from scrapy.item import Item, Field

class TeamItem(Item):
    year = Field()
    name = Field()
    region = Field()
    project = Field()
    abstract = Field()
    instructors = Field()
    students = Field()
    advisors = Field()
    url = Field()
    wiki = Field()
    parts_range = Field()

class ResultItem(Item):
    year = Field()
    team = Field()
    medal = Field()
    awards = Field()
