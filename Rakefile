# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

# BEGIN
# Rake 0.9.0 対応
module ::Twopm
  class Application
    include Rake::DSL
  end
end
module ::RakeFileUtils
  extend Rake::FileUtilsExt
end
# Rake 0.9.0 対応
# END
Twopm::Application.load_tasks
