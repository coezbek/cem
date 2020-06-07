
#
# Paragraph which can be updated easily as a mixin for Flammarion
#
module Flammarion::Writeable

  class Paragraph
  
    def initialize(text, name, owner)
      @text = text
      @name = name
      @owner = owner
    end
    
    def html
      %|<p id="#{@name}">#{@text}</p>|  
    end
    
    def to_s
      html
    end

    def text=(newText)
      return if newText == @text
      @text = newText    
      
      @owner.js("$( '##{@name}' ).replaceWith('#{html}');")
    end
  end
  
  def p(text)
    object = Paragraph.new(text, @engraving.make_id, self)
    puts object, raw:true
    object
  end
  
end