class Twopm::Application
  # Override load_console to load project specific irbrc
  def load_console(sandbox=false)
    super
    puts "Loading console..."
    # Configs
    %w(rubygems wirble ap hirb).each do |gem|
      begin
        require gem
      rescue LoadError => err
        warn "Please do: gem install #{gem.sub(/\/.*/,'')}"
      end
    end

    # disable hirb for default
    Hirb.disable

    # Setup Wirble for colorizing, auto omplete, etc.
    Wirble.init
    Wirble.colorize

    # Configure awesome_print as default irb formatter
    unless IRB.version.include?('DietRB')
      IRB::Irb.class_eval do
        def output_value
          ap @context.last_value
        end
      end
    else # MacRuby
      IRB.formatter = Class.new(IRB::Formatter) do
        def inspect_object(object)
          object.ai
        end
      end.new
    end

    # print SQL to STDOUT
    if defined?(Rails)
        ActiveRecord::Base.logger = Logger.new(STDOUT)
    end

  end
end
