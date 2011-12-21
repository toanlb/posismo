class AddLoginId < ActiveRecord::Migration
  def self.up
    #カラムを追加
    add_column :admins, :login_id, :string, :null => false, :default =>"", :unique => true, :after => "id"
    add_column :clients, :login_id, :string, :null => false, :default =>"", :unique => true, :after => "id"
    add_column :partners, :login_id, :string, :null => false, :default =>"", :unique => true, :after => "id"
    #既存データを更新
    Admin.all.each do |a|
      a.login_id = a.email
      a.save
    end
    Client.all.each do |a|
      a.login_id = a.email
      a.save
    end
    Partner.all.each do |a|
      a.login_id = a.email
      a.save
    end
  end

  def self.down
    remove_column :admins, :login_id
    remove_column :clients, :login_id
    remove_column :partners, :login_id
  end
end
