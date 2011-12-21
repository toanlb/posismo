class CreateBanners < ActiveRecord::Migration
  def self.up
    create_table :banners do |t|
      t.references :promotion
      t.string :name
      t.text :description
      # to use Single Table Inheritance
      t.string :type
      # for text banner
      t.string :text
      # for image_banner
      t.string :image
      t.string :image_size
      
      t.timestamps
    end
  end

  def self.down
    drop_table :banners
  end
end
