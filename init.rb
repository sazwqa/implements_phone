require 'implements_phone'
ActiveRecord::Base.send(:include, ImplementsPhone)

require 'implements_phone_helper'
ActionView::Base.send(:include, ImplementsPhoneHelper)