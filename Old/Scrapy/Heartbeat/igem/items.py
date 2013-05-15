# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/topics/items.html

from scrapy.item import Item, Field

class IgemItem(Item):
    # define the fields for your item here like:
    # name = Field()
    year = Field()
    name = Field()
    title = Field()
    link = Field()
    abstract = Field()
    track = Field()
    award = Field()
    medal = Field()
    tracks = Field()
    teamInfo = Field()
    teamMembers = Field()
#    region = Field()
    pass

class TeamMembers(Item):
    teamInfo = Field()
    Others = Field()
    Advisors=Field()
    Instructors=Field()
    Student_Members=Field()
