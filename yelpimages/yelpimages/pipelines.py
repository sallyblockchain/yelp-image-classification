# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html
import scrapy
from scrapy.contrib.pipeline.images import ImagesPipeline
from scrapy.exceptions import DropItem

class MyImagesPipeline(ImagesPipeline):

    # def item_completed(self, results, item, info):
    #     image_paths = [x['path'] for ok, x in results if ok]
    #     if not image_paths:
    #         raise DropItem("Item contains no images")
    #     item['image_paths'] = image_paths
    #     return item
    #Name download version
    def file_path(self, request, response=None, info=None):
        #item=request.meta['item'] # Like this you can use all from item, not just url.
        image_guid = request.url.split('/')[-2]
        return 'full/%s' % (image_guid)

    def get_media_requests(self, item, info):
        for image_url in item['image_urls']:
            yield scrapy.Request(image_url)

# from scrapy.contrib.pipeline.media import MediaPipeline
# from scrapy.http.request import Request
# import os
# import urllib

# """
# class DemographPipeline(object):
#     def process_item(self, item, spider):
#         return item
# """

# class YelpimagesPipeline(MediaPipeline):

#     IMAGE_DIR = "../images"

#     def get_media_requests(self, item, info):
                
#         #os.system("vlc -vvv %s > /dev/null 2>&1 &" % item['video_url'][0])
#         return Request(item["image_src"], meta={"item":item})
    

#     def media_downloaded(self, response, request, info):
#         """
#         File is downloaded available as response.body save it.
#         """
#         item = response.meta.get("item")
#         image = response.body
#         image_basename = item['image_src'].split('/')[-2]
#         url = item['image_src']

#         new_filename = os.path.join(self.IMAGE_DIR, image_basename, '.img')
#         urllib.urlretrieve(url, new_filename)
#         return item
