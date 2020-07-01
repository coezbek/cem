
#
# Run the given program using Open3.popen3 and redirects output to the subpane("out") (STDOUT and STDERR).
#
module Flammarion::Writeable 

  # This method does not block, but returns after the program has been started.
  #
  # Caution: By default most program run via Open3.popen3 assume they are started in non PTY mode and will buffer their output.
  # To tell the program to be interactive use something like 'script -qefc \"<program>\" /dev/null' as command.
  # See https://stackoverflow.com/questions/1401002/trick-an-application-into-thinking-its-stdout-is-a-terminal-not-a-pipe
  # 
  # +*cmd+:: cmd string to pass to Open3.popen3
  # +pane_out+:: Name of the pane that the STDOUT of the program should be print to. Defaults to "out"
  # +pane_err+:: Name of the pane that the STDERR of the program should be print to. Defaults to "out". Set to nil/false to prevent STDERR to be printed.
  # +pane_in+:: Name of the pane that should be used to wait for input from the user. Defaults to "in". Set to nil/false to prevent user input.
  # +status+:: Should status updates (start, termination) be printed to Writeable::status. Defaults to true. Set to nil/false to disable.
  # +close_btn+:: Should a close button be shown in the pane_in. Defaults to true. Set to nil/false to disable.
  # +auto_clear+:: Should the panes be cleared prior to launching the program? Defaults to true. Set to nil/false to disable.
  # +kill_sig+:: What to pass to Process.kill when close_btn is pressed but program does not react to STDIN being closed. Defaults to "KILL". Could be "TERM".
  #
  def system(*cmd, pane_out: "out", pane_err: "out", pane_in: "in", status: true, close_btn: true, auto_clear: true, kill_sig: 'KILL')

    # Clear all panes if auto_clear is set
    [pane_out, pane_err, pane_in].uniq.each { |p| p && subpane(p).clear } if auto_clear

    i, o, e, t = Open3.popen3(*cmd, pgroup: true)
    cmd = cmd.join

    status("Running '#{cmd}'".light_green) if status

    if pane_in
    
      subpane(pane_in).input("> ", autoclear:true, history:true) do |msg|
        i.puts msg['text']
      end 

      if close_btn
      
        subpane(pane_in).button("Close") do       
        
          subpane(pane_in).clear if auto_clear
          i.close
          
          value = begin
            if t.join(1)
              t.value
            else
              # TERM/KILL whole progress group
              Process.kill(kill_sig, -Process.getpgid(t.pid))
              if t.join(3)
                t.value
              else
                nil
              end
            end
          end
              
          if !value 
            status("Command '#{cmd}' did not terminate promptly.".light_red);
          end if status
        end
      end
    end

    Thread.new do
      begin
        while l = e.readpartial(4096)
          subpane(pane_err).print l.red
        end
      rescue EOFError
        # Do nothing
      end
    end if pane_err

    begin
      while l = o.readpartial(4096)
        subpane(pane_out).print l
      end
    rescue EOFError
      subpane(pane_in).clear if auto_clear
      
      if status && t.join(5)
        t.value.success? ? status("Command '#{cmd}' exited with success".light_green) : status("Command '#{cmd}' exited with error code: #{t.value}".light_red)
      end
    end  
  end

end