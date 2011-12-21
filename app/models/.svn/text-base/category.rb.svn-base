class Category < ActiveRecord::Base
  has_many :categories_promotions
  has_many :categories_sites
  
  # 親カテゴリをoptgroup、子optionタグにするための配列
  #[[親カテゴリ,[[子カテゴリ名前,子カテゴリ値],...]],...]
  def self.category_options_for_select
    options = []
    
    parent_categories = self.where("parent_id is null").order(:id)
    parent_categories.each do |parent|
      options << [parent.category_name]
    end
    
    child_categories = self.where("parent_id is not null").order(:id)
    child_categories.each do |child|
      parent = parent_categories.detect{|x|x.id == child.parent_id}
      index = options.index{|x| x[0] == parent.category_name}
      
      options[index][1] = [] if options[index][1].nil?
      options[index][1] << [child.category_name, child.id]
    end
    
    options
  end
  
  def self.parent_category_options_for_select
    options = []
    
    parent_categories = self.where("parent_id is null").order(:id)
    parent_categories.each do |parent|
      options << [parent.category_name, parent.id]
    end
    
    options
  end
  
  def self.child_category_options_for_select(parent_id)
    options = []
    
    child_categories = self.where(["parent_id = ?", parent_id]).order(:id)
    child_categories.each do |child|
      options << [child.category_name, child.id]
    end
    
    options
  end
  
  def find_duplicate?
    !Category.where(:id => self.id).blank?
  end
end
