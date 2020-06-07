
# Mixin for Flammarion::Writeable which provides short-cuts for common html elements
#
# - The method name will become the html element / tag.
# - Any un-named parameter will become the value for the element. Several parameters will create several elements of the given tag.
# - Any named parameter will become an attribute to all created elements.
#
# Parameters will not be escaped (raw)!
#
# Some examples:
#   f.p                       =>     f.puts "<p/>", raw: true
#   f.h1 "Title"              =>     f.puts "<h1>Title</h2>", raw: true
#   f.img src: "url", width: 32 =>     f.puts '<img src="url" width="32"/>', raw: true
#   f.p "Hello", "World"      =>     f.puts "<p>Hello</p><p>World</p>", raw: true
#
module Flammarion::Writeable

  def method_missing(m, *args, &block)
    
    if !isHTML5Element(m)
      puts "Warning: #{m} is not a valid HTML 5 Tag"
    end    
    
    attribs = args.last.is_a?(Hash) ? args.pop.map { |key, value| %| #{key.to_s}="#{value}"| }.join : ""
    
    if args.size == 0
      puts "<#{m} #{attribs}/>", raw: true
    else
      puts args.map { |value| "<#{m} #{attribs}>#{value}</#{m}>" }.join, raw: true
    end 
  end
  
end
