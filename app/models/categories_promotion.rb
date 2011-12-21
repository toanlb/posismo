class CategoriesPromotion < ActiveRecord::Base
  belongs_to :category
  belongs_to :promotion
  
  LIMIT_PER_PROMOTION = 3
  
  # form helperのselect()用に作成
  def parent_category_id
    
  end
end
