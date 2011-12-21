
task :create_categories => :environment do
  path = File::join(Rails.root.to_s, "data", "categories.yml")
  puts "create categories from #{path}"
  data = YAML::load_file path
  data.each do |category|
    big_category_name = category[0]
    small_category_names = category[1]
    
    big_category = Category.new({:category_name => big_category_name})
    big_category.save!
    puts "create category #{big_category_name}"
    
    small_category_names.each do |small_category_name|
      
      small_category  = Category.new({:parent_id => big_category.id, :category_name => small_category_name})
      small_category.save!
      puts "create category #{big_category_name}/#{small_category_name}"
      
    end
    
  end
  puts "created categories"
end
