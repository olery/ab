require "digest/sha1"

require "ab/version"
require "ab/tester"
require "ab/indexer"
require "ab/chance"
require 'ab/view_helpers'

require 'ab/railtie' if defined?(Rails)

#
# Overall Initial Idea:
#

#options = []
#options << link_to("some kind of url")
#options << link_to("the other url")

# = ab_test(:options=>options, :chance=>"1/1", :input=>user.id, :name=>"announcements") # returns an option

module Ab
end

