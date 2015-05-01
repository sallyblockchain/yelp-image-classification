import scrapy
import json
from yelpimages.items import YelpimagesItem

class DemoSpider(scrapy.Spider):
    name = "yelpdemo"
    allowed_domains = ["yelp.com"]
    base_url = "http://www.yelp.com/biz_photos/"
    start_urls = []
    suffix = ["tacodeli-austin-3"]
    next_page = "?start=100"
    for each in suffix:
        curr_url = base_url + each
        next_url = curr_url + next_page
        start_urls.append(curr_url)
        start_urls.append(next_url)
    # print start_urls

    """
    rules = ( Rule (SgmlLinkExtractor(restrict_xpaths=('//a[@class="page-option available-number"]/@href',)), follow= True),
          Rule (SgmlLinkExtractor(restrict_xpaths=('//div[@class="foto_imovel"]',)), callback='parse')
    )
    """

    def parse(self, response):

        item = YelpimagesItem()
        item['image_urls'] = []
        
        """
        page_info = response.xpath('//div[@class="page-of-pages arrange_unit arrange_unit--fill"]/text()').extract()[0].strip()
        # u'Page 1 of 2'
        index = page_info.rfind('f')
        page_nums = int(page_info[i+2:])
        """

        urls = response.xpath('//div[@class="photo-box biz-photo-box pb-ms"]/a/img/@src').extract()
        for url in urls:
            k = url.rfind('/')
            url = url[:k] + '/ls.jpg'
            item['image_urls'].append(url)
        print item['image_urls']

        yield item
       
