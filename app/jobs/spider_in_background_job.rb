class SpiderInBackgroundJob < ActiveJob::Base
  queue_as :high_priority
  require 'v8'
  
  def perform(*args)
    spideContext = V8::Context.new
    spideContext.load(Rails.root.join('app','assets','javascripts','jquery.js'))
    spideContext.load(Rails.root.join('app','assets','javascripts','echarts.js'))    
    spideContext.load(Rails.root.join('app','assets','javascripts','bmap.min.js'))
    spideContext.eval "
    var get_data_url = '+args[1]+';
    var post_data_url = '+args[2]+';
   
    function GetDataFromServer() {
            $.ajax({
                type: 'GET',
                url: get_data_url,
                dataType: 'json',
                success: function (house_data) {
    
                    // 拿到房屋数据后先显示出来
                 
                    // 然后先用街道去查坐标
                    myGeo.getPoint(house_data.street, function (point) {
                        if (point) {
                            // 如果查到坐标，开始检索周围信息
                            console.log('找到房屋坐标:'+point.lng+';'+point.lat)
                            SearchStart(point, house_data);
                        } else {
                            console.log('第一次未找到'+house_data.street)
                            myGeo.getPoint('中国科学院大学雁栖湖校区',function(point){
                                console.log('daxu'+point.lng+'j'+point.lat)
                            });
                            
                            // 如果街道没查搭配，再用小区去查坐标
                            myGeo.getPoint(house_data.community, function (repoint) {
                                if (repoint) {
                                    // 如果查到坐标，开始检索周围信息
                                    console.log('第二次找到房屋坐标：')
                                    SearchStart(repoint, house_data)
                                } else {
                                    setTimeout(function () {
                                        console.log('Error: no address of ' + ' id: ' + house_data.id + ' community: ' + house_data.community + ' street: ' + house_data.street);
                                        // 如果还没查到坐标，继续查询下一个房屋，延迟timeInterval秒
                                        GetDataFromServer();
                                    }, timeInterval);
                                }
                            }, '北京市');
                        }
                    }, '北京市');
                },
                error: function () {
                  
                },
                timeout: function () {
                
                }
            });
        }
    
    
        function SearchStart(point, house_data) {
       
    
            // 首先查询此房屋的第一个关键词信息（公交车站，idx＝0）
            setTimeout(function () {
                SearchNearby(point, house_data, 0);
            }, timeInterval);
    
        }
    
        function SearchNearby(house_loc, house_data, keyword_idx) {
            var nearby_info = [];

            var local = new BMap.LocalSearch(map, {
                renderOptions: {map: map, autoViewport: false},
                pageCapacity: 50,
                onSearchComplete: function (results) {
                 
                    if (local.getStatus() == BMAP_STATUS_SUCCESS) {
                        // 百度地图成功返回，将每个周边信息储存到nearby_info里
                        for (var i = 0; i < results.getCurrentNumPois(); i++) {
                            var locate = results.getPoi(i);
                            if (locate != null) {
                                // 查询结果与房屋的距离
                                var distance = parseFloat(map.getDistance(locate.point, house_loc)).toFixed(1);
                                nearby_info.push(locate.title + '/' + locate.point.lng + '/' + locate.point.lat + '/' + distance);
                       
                            }
                        }
                        // 获得百度地图查询结果后立即发送给服务器
                        return sendData(keywords_en[keyword_idx], nearby_info, house_data, house_loc, keyword_idx)
                    } else {
                        GetDataFromServer();
                        console.log('No records with baiduAPI:', local.getStatus());
                        return false;
                    }
                }
            });
            local.searchNearby(keywords[keyword_idx], house_loc, search_range);
        }
    
        function sendData(nearby_type, nearby_info, house_data, house_loc, idx) {
            data = 'nearby_type=' + nearby_type + '&nearby_info=' + nearby_info + '&id=' + house_data.id + '&lat=' + house_loc.lat + '&lng=' + house_loc.lng;
            $.ajax({
                type: 'POST',
                url: post_data_url,
                data: data,
                dataType: 'JSON',
                success: function (data) {
                    if (flag) {
                        console.log('warning', 'pause');
                    } else {
                        // 当查询到最后一个kewords时，请求服务器获得下一个房屋信息
                        if (idx == keywords.length - 1) {
                            GetDataFromServer();
                        } else {
                            // 查询此房屋的下一个关键词信息
                            setTimeout(function () {
                                SearchNearby(house_loc, house_data, idx + 1);
                            }, timeInterval);
                        }
                        console.log('success', data);
                    }
                    return true;
                },
                error: function () {
                 
                    return false;
                },
                timeout: function () {
  
                    return false;
                }
            });
        };
        GetDataFromServer();
        "
    # Do something later
  end
end
