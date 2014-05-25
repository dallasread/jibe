require "jibe/version"
require "jibe/railtie" if defined? Rails

module Jibe
  mattr_accessor :director
  self.director = :pusher
  
  class Engine < Rails::Engine
  end
  
  module Sync
    extend ActiveSupport::Concern
 
    included do
    end
 
    module ClassMethods
      def jibe(options = {})
        include Jibe::Sync::InstanceMethods
        
        attr_accessor :skip_jibe
        
        after_create :do_jibe_create
        after_update :do_jibe_update
        after_destroy :do_jibe_destroy
      end
    end
    
    module InstanceMethods
      def do_jibe(action_name)
        unless skip_jibe
          if Jibe.director == :pusher
            model = self.class.name.downcase
            Pusher["Jibe"].trigger("event", {
              action_name: action_name,
              action_capitalized: action_name.capitalize,
              id: id,
              collection: self.class.name.downcase.pluralize,
              model: model,
              dom_id: "#{model}_#{id}",
              partial: Jibe::Render.new.to_string(self),
              data: jibe_data
            })
            logger.info "\033[0;34mJibing #{model} #{action_name}...\033[0m"
          end
        end
      end
      
      def do_jibe_create
        do_jibe "create"
      end
      
      def do_jibe_update
        do_jibe "update"
      end
      
      def do_jibe_destroy
        do_jibe "destroy"
      end
      
      def jibe_data
        attributes
      end
    end
  end
  
  class Render
    attr_accessor :context

    def initialize
      self.context = ApplicationController.new.view_context
      self.context.instance_eval do
        def url_options
          ActionMailer::Base.default_url_options
        end
      end
    end

    def to_string(options)
      context.render(options)
    end
  end
end

ActiveRecord::Base.send :include, Jibe::Sync
