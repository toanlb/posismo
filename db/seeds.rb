# encoding: utf-8 
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Seed Root
unless Admin.find_by_login_id("root")
  puts "Seeding root......"
  admin = Admin.create({
                         login_id: "root",
                         name: "root",
                         password: "root",
                         password_confirmation: "root",
                         email: "root@itokuro.jp"
                       })
  admin.super_user = true
  begin
    admin.save!(:validate => false)
  rescue Exception => e
    puts e.to_s    
  end
end

unless Admin.find_by_login_id("admin")
  puts "Seeding admin......"
  admin = Admin.create({
                         login_id: "root",
                         name: "root",
                         password: "root",
                         password_confirmation: "root",
                         email: "root@itokuro.jp"
                       }) 
  
  admin.super_user = true
  begin
    admin.save!(:validate => false)
  rescue Exception => e
    puts e.to_s     
  end
end

require Rails.root.join("spec/support/blueprints")

unless ENV["RAILS_ENV"] == "production"
  puts "Seeding admins ......"
  Admin.make!(100)
  # This will make 50 normal clients and 5 promotions each of client
  puts "Seeding clients ......" 
  Client.make!(50)
  # This will make 50 consigned clients and 5 promotions each of client
  puts "Seeding consigned clients ......"
  Client.make!(50, :consigned => true)
  # This will make 100 partners and 2 sites each.
  puts "Seeding partners ......"
  Partner.make!(100)
  
  puts "Seeding promotions ......"
  sites = Site.all
  Promotion.all.each_with_index do |p, i|
    p.publish!(sites[i % sites.size])
  end

  puts "Seeding orders ......"
  Order.make!(200)
  puts "Seeding dailies ......"
  Daily.make!(200)
  
end
