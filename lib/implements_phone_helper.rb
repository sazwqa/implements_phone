module ImplementsPhoneHelper
  def phone (object, field)
    string = "(" + content_tag(:input, nil, gen_hash(object, field, 0, 3)) + ")"
    string += content_tag(:input, nil, gen_hash(object, field, 1, 3)) + "-"
    string += content_tag(:input, nil, gen_hash(object, field, 2, 4))
    string += " Ext. " + content_tag(:input, nil, gen_hash(object, field, 3, 4))
    string
  end
  
  private
  def gen_hash(object, field, count, size)
    downcase    = object.class.to_s.downcase
    underscore  = object.class.to_s.underscore
    hash = 
    {
      :type => :text, 
      :class => "#{underscore}_#{field}", 
      :name => "#{downcase}[#{field}_apart][#{count}]", 
      :id => "#{underscore}_#{field}_#{count}", 
      :size => size, 
      :maxlength => size, 
      :onkeyup => "if (this.value.length == #{size}) { document.getElementById('#{underscore}_#{field}_#{count+1}').focus(); };",
      :value => object.send("#{field}_apart")[count] 
    }
    hash.delete(:onkeyup) if count == 3 
    hash
  end
end