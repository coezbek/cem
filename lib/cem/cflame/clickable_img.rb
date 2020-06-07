#
# Clickable Image module mixin for Flammarion::Writeable
# 
# Features:
#   - clickable => will call the given block when user clicks image
#   - update() => can be replaced/updated 
#   - src= => img src can be updated on the fly
#
module Flammarion::Writeable 

  attr_accessor :url, :width, :height, :alt, :title

  class ClickableImage
    def initialize(url, width, height, alt, title, name, owner, block)
      @name = name
      @owner = owner
      @block = block
      @url = url
      @width = width
      @height = height
      @alt = alt
      @title = title
    end
      
    def to_s
      return @owner.callback_link(html) {
        @block.call(self) if @block
      }
    end
    
    def html
      %|<img id="#{@name}" width=#{@width.to_s} max-height=#{@height.to_s} src="#{@url.to_s}" alt="#{@alt}" title="#{@title}"/>|
    end
    
    def update(url, width, height, alt, title)
      @url = url
      @width = width
      @height = height
      @alt = alt if alt
      @title = title if title
      
      @owner.js("$( '##{@name}' ).replaceWith('#{html}');")
    
    end   
    
    def url=(value)
      value = value.to_s
      # puts "urlset on #{@name}"
      @owner.js("$( '##{@name}' ).attr('src', '#{value}');")
    end
  
  end
    
  def img_raw(url, width, height, alt, title, options = {}, &block)
    return ClickableImage.new(url, width, height, alt, title, @engraving.make_id, self, block)    
  end
  
end
