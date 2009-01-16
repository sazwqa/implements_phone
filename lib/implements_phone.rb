module ImplementsPhone
  def self.included(base)
    base.send(:extend, ClassMethods)
  end
  module ClassMethods
    def implements_phone(options = {})
      fields = []
      fields.concat(options[:validate])   unless options[:validate].blank?
      fields.concat(options[:invalidate]) unless options[:invalidate].blank?
      return if fields.blank?
      class_eval do
        fields.each do |x|
          if !options[:validate].blank? and options[:validate].include?(x)
            validates_presence_of x, :message => 'is blank.'
          end
          validates_format_of x, 
            :with => /^([0-9]){3}\-([0-9]){3}\-([0-9]){4}([\-]){0,1}([0-9]){0,4}$/, 
            :message => 'is in improper format.', 
            :unless => proc {|val| val.send(x).nil? }
          # phone_apart
          define_method("#{x}_apart") do 
            value = read_attribute(x)  
            value.blank? ? ['', '', '', ''] : value.split('-')
          end
          # phone_apart=
          define_method("#{x}_apart=") do |val| 
            write_attribute(x, val.values.first.blank? ? nil : val.values.join('-'))
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