# AB

This gem provides you with a way to do AB testing in a deterministic way
without the need for Redis or any other service.

** NOTICE ** 

*The gem is in very early development*

Since other gems need all kinds of extra services to work, and we didn't want
any extra dependencies, we created a gem that will serve your users an A/B/C or
whatever version based on for example a user-id

You can then use e.g. a tool like Mixpanel to track which user saw what, and
make your AB testing decisions.

The gem works in a Rails and non rails environment. It's tested on ruby 1.8.7
and 1.9.3.

# Examples

## Simple view usage
In your view (haml):

```haml
-ab(:options=>["dude","your royal highness"], :chances=>"20/80",:name=>"greeting").for(@current_user.id) do |option|
  ="Well hello #{option}"
```

## Defining tests in a controller
You can also create a tester, for example in your ```app/controllers/application_controller.rb```

```ruby
class ApplicationController
  before_filter :ab_tests

  def ab_tests
    @greeting_test = Ab::Tester.new(:options=>["Yo", "Hello"],  :chances=>"50/50", :name=>"greeter")
  end
end
```

Then in your view (haml style):

```haml
-@greeting_test.for(@current_user) do |option|
  ="#{option} Bro!"
```

## Using a Tracker

Let's say you have a hypothetical MixPanel Tracker you want to use for AB
testing. You can for example implement it like this:

```ruby
class ApplicationController
  before_filter :ab_tests
  after_filter :track_ab_choices

  def ab_tests
    @greeting_test = Ab::Tester.new(:options=>["Yo", "Hello"],  :chances=>"50/50", :name=>"greeter")
  end

  def track_ab_choices
    MixpanelTracker.track(@current_user, "experiment:greeting", :version=>@greeting_test.call(@current_user.id))
  end
end
```

## What a chance!

The chances option of the ab view helper as well as in ```Ab::Tester``` takes a
string as an argument. With a format using ```/```. It normalized the chances
afterwards, so the following chances result in the exact same chance
distribution:

```ruby
 Ab::Tester.new(:chances=>"10/60/30")
 Ab::Tester.new(:chances=>"1/6/3")
 Ab::Tester.new(:chances=>"35/210/105")
```

## Installation

Add this line to your application's Gemfile:

    gem 'ab'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ab

## Usage

The main class is the ```Ab::Tester``` class which takes several options as arguments:

## General Usage:
```ruby
tester = Ab::Tester.new(:name=>"test_name", :options=>[true, false], :chances=>"50/50")
tester.for(user.id) # Will return true or false, depending on the user.id
```

```Ab::Tester``` options:

* ```name```: Name of the tester, used as a seed to the random number generator 
* ```options```: (required) Array of options to choose from in the test, the options can be anything
* ```chances```: (required) String representing the chances of the options e.g. ```"10/20/70"```
* ```indexer```: A class that responds a class level ```call(opts={})``` which contains the logic on how to get from a value, seed and chances to a choice. See the source code of the basic Indexer.

### If you use rails

You can also use the view helper ```ab``` with the exact same options as above

option 1: using the output directy

```erb
Hello there <%=ab(:options=>["stranger", "you"], :chances=>"80/20").for(@current_user.id) %>
```

option 2: using a block:

```erb
<%=ab(:options=>[:stranger, :you], :chances=>"80/20").for(@current_user.id) do |option| %>
  <% if option == :stranger %>
    Hello there stranger!
  <% elsif options == :you %>
    Could you please introduce yourself?
  <% end %>  
<% end %>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
