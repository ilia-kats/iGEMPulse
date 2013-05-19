# Scrapy settings for Heartbeat project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/topics/settings.html
#

BOT_NAME = 'Heartbeat'
BOT_VERSION = '1.0'

SPIDER_MODULES = ['Heartbeat.spiders']
NEWSPIDER_MODULE = 'Heartbeat.spiders'
#USER_AGENT = '%s/%s' % (BOT_NAME, BOT_VERSION)
HTTPCACHE_ENABLED = False
#COOKIES_ENABLED = False
COOKIES_DEBUG = True

# Team.cgi works extensively with cookies
#CONCURRENT_ITEMS = 1
#CONCURRENT_REQUESTS_PER_DOMAIN = 1
DUPEFILTER_CLASS = 'scrapy.dupefilter.BaseDupeFilter'

YEARS = [2007, 2008, 2009, 2010, 2011, 2012]
TEAM_LIST = "http://igem.org/Team_List?year=%d"
RESULTS = "http://igem.org/Results?year=%d"

