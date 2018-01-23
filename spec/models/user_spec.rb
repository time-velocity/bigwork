require 'rails_helper'
RSpec.describe User, type: :model do
    # 测试用例1 
    # 创建了一个 单身 但不漂亮的 女孩, 来验证 have_chance? 方法
    before(:each) do
     
      @user = User.new(name: "Example User", email: "user@example.com",password:"123456",password_confirmation:"123456")
      

    end
  
    it "should be valid" do 
      
      expect(@user.valid?).to eq(true)
    end
    it "name should be present" do
      @user[:name] = " "
      expect(@user.valid?).to eq(false)
    end
    it "用户名不多余50" do
      @user[:name] = "x11111111112222222222333333333344444444445555555555"
      expect(@user.valid?).to eq(false)
    end
    
    it "密码不能少于6位" do
      @user = User.new(name: "Example User", email: "user@example.com",password:"12345",password_confirmation:"12345")
      
      expect(@user.valid?).to eq(false)
    end

    it "密码确认要相同" do
      @user = User.new(name: "Example User", email: "user@example.com",password:"123456",password_confirmation:"12345678")

      expect(@user.valid?).to eq(false)
    end

    it "邮箱要存在" do 
      @user[:email] = " "
      expect(@user.valid?).to eq(false)
    end

    it "邮箱格式正确" do
      @user[:email] = "abcdefghi"
      expect(@user.valid?).to eq(false)
    end



      
  end
  
  