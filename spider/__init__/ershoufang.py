# -*- coding: utf-8 -*-
#网易房产的单线程房源爬虫
#若要实现多线程爬虫，首先写好多个爬虫函数
#然后通过CrawlerProcess实现
import scrapy
#from scrapy.crawler import CrawlerProcess   多线程
import re
import copy

class ershoufangSpider(scrapy.Spider):
    #爬虫名，必须唯一
    name = "ershoufang"
    #爬虫入口，即放入要爬取的网址，若要放入多个网址，这些网址必须是同一个域名
    start_urls = ["http://data.house.163.com/bj/housing/xx1/ALL/all/2014.12.01-2017.12.01/allDistrict/todayflat/desc/all/1.html","https://bj.lianjia.com/ershoufang/"]
    #将网址作为参数传给response，继而爬取具体的数据
    def parse(self, response):
        #使用xpath选择器得到单个房源的网址
        houses = response.xpath(".//div[@id='resultdiv_1']/table/tbody/tr")
        for house in houses[3:]:
            link = ''
            price = ''
            attention = ''
            #visited = ''
            #publishday = ''
            try:
                link = house.xpath("td[2]/a/@href").extract()[0]

                #attention = house.xpath(".//div[@class='followInfo']/text()").re("\d+")[0]
                #visited = house.xpath(".//div[@class='followInfo']/text()").re("\d+")[1]
                #if u'月' in house.xpath(".//div[@class='followInfo']/text()").extract()[0].split('/')[2]:
                    #number = house.xpath(".//div[@class='followInfo']/text()").re("\d+")[2]
                    #publishday = '' + int(number)*30

                #elif u'年' in house.xpath(".//div[@class='followInfo']/text()").extract()[0].split('/')[2]:
                    #number = house.xpath(".//div[@class='followInfo']/text()").re("\d+")[2]
                    #publishday = '365'
                #else:
                    #publishday = house.xpath(".//div[@class='followInfo']/text()").re("\d+")[2]
            except:

                print "These are some 1 exceptions"
            #将得到的网址结果作为参数传入到第二个函数当中，继续爬取
            yield scrapy.Request(link, callback=self.parse_two)

        # page = response.xpath("//div[@class='page-box house-lst-page-box'][@page-data]").re("\d+")
        #判断当前页以及下一页
        page = response.xpath("//div[@class='pager_box']/a[@class='pager_b current']/text()").re("\d+")[0]
        page = int(page)
        p = re.compile(r'\d+\.html')
        if page<40 :
            next_page = re.split(p,response.url)[0]+str(int(page)+1)+'.html'
            #print next_page+"*********************"
            next_page = response.urljoin(next_page)
            yield scrapy.Request(next_page, callback=self.parse)

    def parse_two(self,response):
        house = response.xpath(".//div[@id='lpk_main_nav']")
        h_data = {}
        detail_link = ''

        prices = response.xpath(".//*[@id='lpk_wrap']/div[3]/div[12]/div[2]/div/div/ul")
        for price in prices:
            try:

                date = price.xpath("li[1]/text()").extract()[0].strip().split()[0]

                uprice = price.xpath("li[3]/span/text()").extract()[0]

                h_data[date] = uprice
                h = copy.deepcopy(h_data)

            except Exception,e:

                print "These are some  2 exceptions"
                print e

        try:
            detail_link =house.xpath("table[1]/tr/td[2]/a/@href").extract()[0]

            #attention = house.xpath(".//div[@class='dealDate']/text()").extract()
            #attention = house.xpath(".//div[@class='followInfo']/text()").re("\d+")[0]
            #visited = house.xpath(".//div[@class='followInfo']/text()").re("\d+")[1]
            #if u'月' in house.xpath(".//div[@class='followInfo']/text()").extract()[0].split('/')[2]:
                #number = house.xpath(".//div[@class='followInfo']/text()").re("\d+")[2]
                #publishday = '' + int(number)*30

            #elif u'年' in house.xpath(".//div[@class='followInfo']/text()").extract()[0].split('/')[2]:
                #number = house.xpath(".//div[@class='followInfo']/text()").re("\d+")[2]
                #publishday = '365'
            #else:
                #publishday = house.xpath(".//div[@class='followInfo']/text()").re("\d+")[2]
        except Exception, e:

            print "These are some  2.1 exceptions"
            print e

        #print detail_link
        detail_link = 'http://xf.house.163.com'+detail_link

        yield scrapy.Request(detail_link,meta={'history_price':h},callback=self.parse_three)


    def parse_three(self,response):

        #houses = response.xpath(".//ul[@class='listContent']/li")
        house = response.xpath(".//div[@id='lpk_wrap']")
        name = ''
        avgPrice=''
        area = ''
        street=''
        local = ''
        type = ''
        decorate=''
        green_rate = ''
        h = response.meta['history_price']
        #根据具体字段提取需要的数据
        try:
            name = house.xpath("//*[@id='product_name']/text()").extract()[0].strip()
        except Exception, e:
            print "These are some 3.1 exceptions"
            print e

        try:
            avgPrice = house.xpath(u"//*/td[text()='价格']/following-sibling::td/text()").extract()[0].strip().replace('\t','').replace('\n','').replace(' ','')
        except Exception, e:
            print "These are some 3.2 exceptions"
            print e

        try:
            area = house.xpath(u"//*/td[text()='户型介绍']/following-sibling::td/text()").extract()[0].strip().replace('\t','').replace('\n','').replace(' ','')
        except Exception, e:
            print "These are some 3.3 exceptions"
            print e

        try:
            street = house.xpath(u"//*/td[text()='楼盘地址']/following-sibling::td/text()").extract()[0].strip().replace('\t','').replace('\n','').replace(' ','')
        except Exception, e:
            print "These are some 3.4 exceptions"
            print e

        try:
            local = house.xpath(u"//*/td[text()='所属区域']/following-sibling::td/text()").extract()[0].strip().replace('\t','').replace('\n','').replace(' ','')
        except Exception, e:
            print "These are some 3.5 exceptions"
            print e

        try:
            type = house.xpath(u"//*/td[text()='建筑类型']/following-sibling::td/text()").extract()[0].strip().replace('\t','').replace('\n','').replace(' ','')
        except Exception, e:
            print "These are some 3.6 exceptions"
            print e


        try:
            decorate = house.xpath(u"//*/td[text()='装修情况']/following-sibling::td/text()").extract()[0].strip().replace('\t','').replace('\n','').replace(' ','')
        except Exception, e:
            print "These are some 3.8 exceptions"
            print e

        try:
            green_rate = house.xpath(u"//*/td[text()='绿化率']/following-sibling::td/text()").extract()[0].strip()
        except Exception, e:
            print "These are some 3.9 exceptions"
            print e


        yield{
            'name':name,
            'avgPrice' : avgPrice,
            'area':area,
            'street':street,
            'local':local,
            'type':type,
            'decorate':decorate,
            'green_rate':green_rate,
            'history_price':h
        }

#多线程
#process = CrawlerProcess({
#    'USER_AGENT':'Mozilla/4.0 (compatible; MSIE 7.0;windows NT 5.1)'
#})
#process.crawl(Spider1)
#process.crawl(Spider2)
#process.start()

