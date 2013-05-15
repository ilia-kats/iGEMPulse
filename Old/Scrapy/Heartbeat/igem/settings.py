# Scrapy settings for igem project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/topics/settings.html
#

BOT_NAME = 'igem'
BOT_VERSION = '1.0'

SPIDER_MODULES = ['igem.spiders']
NEWSPIDER_MODULE = 'igem.spiders'
#USER_AGENT = '%s/%s' % (BOT_NAME, BOT_VERSION)
HTTPCACHE_ENABLED=False
COOKIES_DEBUG=True
