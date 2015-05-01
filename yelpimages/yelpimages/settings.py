# -*- coding: utf-8 -*-

# Scrapy settings for yelpimages project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/en/latest/topics/settings.html
#

BOT_NAME = 'yelpimages'

SPIDER_MODULES = ['yelpimages.spiders']
NEWSPIDER_MODULE = 'yelpimages.spiders'

ITEM_PIPELINES = {'scrapy.contrib.pipeline.images.ImagesPipeline': 1}
# Change here before using
IMAGES_STORE = 'path/to/images'

# Crawl responsibly by identifying yourself (and your website) on the user-agent
#USER_AGENT = 'yelpimages (+http://www.yourdomain.com)'
