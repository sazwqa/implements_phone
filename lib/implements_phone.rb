module ImplementsPhone
  def self.included(base)
    base.send(:extend, ClassMethods)
  end
  
  # fields = all the fields in model that are for use with phone
  # validate_presence = all the fields on which validates_presence_of will be applied
  # format_message = message for incorrect format
  # presence_message = message for validates_presence_of
  # format_regex = regex for checking the phone format
  module ClassMethods
    def implements_phone(options = {})
      (puts('ImplementsPhone configuration error, fields not specified.'); return) if options[:fields].blank?
      # options
      fields            = options[:fields]
      validate_presence = options[:validate_presence] || []
      format_message    = options[:format_message]    || 'is in improper format.'
      presence_message  = options[:presence_message]  || 'is blank.'
      format_regex      = options[:format_regex]      || /^([0-9]){3}\-([0-9]){3}\-([0-9]){4}([\-]){0,1}([0-9]){0,4}$/
      
      # constants
      empty_pattern = ['', '', '', '']
      
      class_eval do
        fields.each do |x|
          validates_presence_of(x, :message => presence_message) if validate_presence.include?(x)
          validates_format_of x, 
            :with => format_regex, 
            :message => format_message, 
            :unless => proc {|val| val.send(x).nil? }
          # phone_apart
          define_method("#{x}_apart") do 
            value = read_attribute(x)  
            value.blank? ? empty_pattern : value.split('-')
          end
          # phone_apart=
          define_method("#{x}_apart=") do |val|
            write_attribute(x, (val.values == empty_pattern) ? nil : val.values.join('-'))
          end
          # formatted_phone
          define_method("formatted_#{x}") do
            value = self.send("#{x}_apart")
            "#{value[0]}-#{value[1]}-#{value[2]} #{'Ext. '+value[3] unless value[3].blank?}"
          end
        end
      end
    end
  end
end