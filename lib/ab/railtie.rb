require 'ab/view_helpers'

module Ab
  class Railtie < Rails::Railtie
    initializer "ab.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end
