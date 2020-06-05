
#
# Christopher Flammarion extensions
#

module Flammarion::Writeable 

  class Progress
    def initialize(name, owner)
      @name = name
      @owner = owner
      @owner.raw("<div id='progressBar' style='width: 100%; height: 22px; border: 1px solid #8f8f8f; background-color: #292929;border-radius: 2px;
box-shadow: 0 2px 3px rgba(0, 0, 0, 0.25) inset;'><div id='progressBarInner-#{@name}' style='height: 100%; color: #fff; text-align: center; line-height: 22px; width: 0px; background-color: #0099ff;'></div></div>")
    end
  
    def each(ary, &block)
      set(0)
      @max = ary.size
      
      ary.each_with_index { |a, i|
        yield a
        set(i)
      }
      ary        
    end
    
    def set(value)
      value = value.to_s
      @owner.js("$( '#progressBarInner-#{@name}' ).width('#{value}%').html('#{value}%');")
    end
  
  end
  
  def progress(name, options = {})
    return Progress.new(name, self)    
  end
end