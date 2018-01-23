# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class ErshoufangItem(scrapy.Item):
    name = scrapy.Field()
    area = scrapy.Field()
    street = scrapy.Field()
    avgPrice = scrapy.Field()
    builtTime = scrapy.Field()
    local = scrapy.Field()
    type = scrapy.Field()
    decorate = scrapy.Field()
    green_rate = scrapy.Field()
    history_price = scrapy.Field()
    link = scrapy.Field()
    pass
