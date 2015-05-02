import scrapy
import json
from yelpimages.items import YelpimagesItem

class DemoSpider(scrapy.Spider):
    name = "yelpdemo"
    allowed_domains = ["yelp.com"]
    base_url = "http://www.yelp.com/biz_photos/"
    start_urls = []
    next_page = ["?start=100", "?start=200", "?start=300"]
    
    tacodeli = ["tacodeli-austin-3", "tacodeli-austin-4", 
                "tacodeli-austin-6", "tacodeli-austin-11",
                "tacodeli-west-lake-hills"]
    for each in tacodeli:
        curr_url = base_url + each
        next_url = curr_url + next_page[0]
        start_urls.append(curr_url)
        start_urls.append(next_url)

    torchys = "torchys-tacos-austin"
    start_urls.append(base_url + torchys)
    for i in range(0, len(next_page)):
        start_urls.append(base_url + torchys + next_page[i])

    index = [3, 4, 6, 7, 10, 11, 12, 13]
    
    for i in range(0, len(index)):
        curr_url = base_url + torchys + '-' + str(index[i])
        next_url = curr_url + next_page[0]
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

        yield item
       
