require "jibe/view_helpers"

module Jibe
  class Railtie < Rails::Railtie
    initializer "jibe.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end