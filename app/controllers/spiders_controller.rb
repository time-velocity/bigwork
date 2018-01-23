class SpidersController < ApplicationController

  # TODO
  # 增加权限控制，只有管理员才能调用return_next和create
  # END
  @@house_id=0
  def SpidersController.init_houseid
    @@house_id= 0
  end


  def return_next
    # 查询下一个房屋信息
    puts "############## "
    puts @@house_id
    if @@house_id > 0
      house=House.find(@@house_id)
      if house == House.last
        respond_to do |format|
          format.json { render :json => {"status":"success"
          }}
        end
      end
    end
    
   
    
    while true
      house=House.next_record(@@house_id)
      @@house_id = house.id
      break if house == House.last or house.spider_status == 0 
    end



    # while not house.buses_houses.nil? and not house.buses_houses.blank?
    #   house=House.next_record(@@house_id)
    #   @@house_id=house.id
    #   break if house == House.last
    # end
    
    # redirect_to houses_path, flash: {:success => "抓取完毕"}
    
    respond_to do |format|
      format.json { render :json => house }
    end

    
      
  end
    

    # 避免重复抓取，跳过已经有相关信息的
    

    # TODO
    # 避免重复抓取，现在只能靠bus信息进行判断，希望更全面的信息判断
    # END

    
  

  def spider_complete

  end

  def spider_error
  end

  def index
    @total = House.all.size
    current_house = House.where("spider_status = 0").first
    if current_house
      @@house_id  = House.where("spider_status = 0").first.id-1
    else 
      @@house_id  = House.all.last.id
    end
    @houses_error = House.where("spider_status = 2")
    @house_success_total = House.where("spider_status = 1").size
    
    @bus_total = Bus.all.size
    @hospital_total = Hospital.all.size
    @school_total = School.all.size
    @shop_total = Shop.all.size
    @subway_total = Subway.all.size
    @work_total = Work.all.size
    @bus_house_total = BusesHouses.all.size
    @hospital_house_total = HospitalsHouses.all.size
    @school_house_total = SchoolsHouses.all.size
    @shop_house_total = ShopsHouses.all.size
    @subway_house_total = SubwaysHouses.all.size
    @work_house_total = WorksHouses.all.size
    
    @current_spider_id = @@house_id
    
    puts "?????"
    puts @@house_id

  end

  def create
    puts "@@@@@"
    puts params[:type]
    if params[:type]=='1' 
      house=House.find_by(id: params[:id])
      house.latitude=params[:lat]
      house.longitude=params[:lng]
      house.spider_status=1
      house.save

      insert(house, params, Bus, BusesHouses, 'bus') if params[:nearby_type] == 'bus'
      insert(house, params, Hospital, HospitalsHouses, 'hospital') if params[:nearby_type] == 'hospital'
      insert(house, params, Work, WorksHouses, 'work') if params[:nearby_type] == 'work'
      insert(house, params, School, SchoolsHouses, 'school') if params[:nearby_type] == 'school'
      insert(house, params, Subway, SubwaysHouses, 'subway') if params[:nearby_type] == 'subway'
      insert(house, params, Bus, ShopsHouses, 'shop') if params[:nearby_type] == 'shop'
      
      
    else
      puts "$$$$$$$$"
      puts params
      house = House.find_by(id: params[:id])
      
      house.spider_status=2
      house.save
    end
    render json: params.as_json
  end


  # TODO
  # bus数据的导出，需要自己写前端
  # END
  
  def export_bus
    respond_to do |format|
      format.csv { send_data Bus.to_csv, filename: "buses-#{Date.today}.csv" }
    end
  end

  def export_bus_house
    respond_to do |format|
      format.csv { send_data BusesHouses.to_csv, filename: "buses_houses-#{Date.today}.csv" }
    end
  end

  def do_background
    @spider_job = SpiderInBackgroundJob.perform_now(return_next_spiders_path,spiders_path)
    redirect_to :action => :index
  end

  def pause_background
    queue = Sidekiq::Queue.new("spider")
    queue.each do |job|
      job.delete if job.job_id == @spider_job.job_id
      redirect_to :action => :index
    end

  end


end
