
def crequire(requireName, gemName = nil)
  require requireName
rescue LoadError
  gemName = requireName if gemName.nil?
  system("gem install #{gemName}")
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
  File.file?('/proc/version') && File.open('/proc/version', &:gets).downcase.include?("microsoft")
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
   

module CLog

  def log
    CLog.log
  end

  # Global, memoized, lazy initialized instance of a logger
  def self.log
    @log ||= Logger.new(STDOUT)
  end
end

module Ccommon
 


  
  
  
end
