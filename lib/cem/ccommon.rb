
#
# Require the given ruby file and if loading fails, try to install the gem of the same name or given parameter
#
def crequire(requireName, gem_name = nil)
  require requireName
rescue LoadError
  gem_name = requireName if gem_name.nil?
  system("gem install #{gem_name}")
  Gem.clear_paths
  require requireName
end

class File

  # Returns the first match of the given files
  def self.exist_first?(*candidates)
    candidates.each { |candidate|
      if File.exist?(candidate)
        return candidate
      end
    }
    return nil
  end
end



class Array
	def with_progress(&block)
  
    crequire 'progress_bar' 
  
		bar = ProgressBar.new(count)
		if block
			each{|obj| yield(obj).tap{bar.increment!}}
		else
			Enumerator.new{ |yielder|
				self.each do |obj|
					(yielder << obj).tap{bar.increment!}
				end
			}
		end
	end
end


# Returns true if this script is running on the Windows Sub-System for Linux, i.e. under Linux where the host is Windows.
#
# If true, interoperability with Windows is possible.
def wsl?
  @@wsl ||= File.file?('/proc/version') && File.open('/proc/version', &:gets).downcase.include?("microsoft")
end


#
# If on wsl? then the given is converted from a Windows path to a Linux path (e.g. "C:\" becomes "/mnt/c/")
#
# Uses the wslpath command, passes mode to wslpath:
#
#    -a    force result to absolute path format
#    -u    translate from a Windows path to a WSL path (default)
#    -w    translate from a WSL path to a Windows path
#    -m    translate from a WSL path to a Windows path, with '/' instead of '\'
#
def wslpath(path, mode = "")
  return path if !wsl? 
  
  return `wslpath #{mode} '#{path}'`.strip
end

def isHTML5Element(element)

  # https://html.spec.whatwg.org/#elements-3

  @valid_elements ||= %w(a abbr address area article aside audio b base bdi bdo blockquote body br button canvas caption cite code col colgroup data datalist dd del details dfn dialog div dl dt em embed fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup hr html i iframe img input ins kbd label legend li link main map mark math menu meta meter nav noscript object ol optgroup option output p param picture pre progress q rp rt ruby s samp script section select slot small source span strong style sub summary sup svg table tbody td template textarea tfoot th thead time title tr track u ul var video wbr)
    
  return @valid_elements.include?(element.to_s.downcase)

end

module CLog

  def log
    CLog.log
  end

  # Global, memoized, lazy initialized instance of a logger
  def self.log
    @log ||= Logger.new(STDOUT)
  end
end

