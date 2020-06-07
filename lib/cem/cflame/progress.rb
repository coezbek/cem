
#
# A simple CSS-based progress bar for Flammarion.
#
# Use set() to set the progress as an integer in percent.
#
#   progress = f.progress
#   ... # do first half
#   progress.set(50)
#   ... # finish work
#   progress.set(100) # => will set to 100%
#
# Or use each() with an array
#
#   progress.each([1,2,3]) { |x| ... } 
#
module Flammarion::Writeable 

  class Progress
    def initialize(name, owner)
      @name = name
      @owner = owner
      @owner.raw("<div id='progressBar' style='width: 100%; height: 22px; border: 1px solid #8f8f8f; background-color: #292929; border-radius: 2px; box-shadow: 0 2px 3px rgba(0, 0, 0, 0.25) inset;'><div id='progressBarInner-#{@name}' style='height: 100%; color: #fff; text-align: center; line-height: 22px; width: 0px; background-color: #0099ff;'></div></div>")
    end
  
    def each(ary, &block)
      set(0)
      @max = ary.size
      return if @max == 0
      
      ary.each_with_index { |a, i|
        yield a
        set(i * 100 / @max)
      }
      ary        
    end
    
    def set(value)
      value = value.to_s
      @owner.js("$( '#progressBarInner-#{@name}' ).width('#{value}%').html('#{value}%');")
    end
  
  end
  
  def progress(name = nil)
    return Progress.new(name || @engraving.make_id, self)    
  end
end