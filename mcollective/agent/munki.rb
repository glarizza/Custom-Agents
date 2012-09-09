module MCollective
  module Agent
    class Munki<RPC::Agent
      metadata :name        => 'munki',
               :description => 'An MCollective agent to manage Munki actions',
               :author      => 'Gary Larizza',
               :license     => 'Apache 2',
               :version     => '0.1',
               :url         => 'http://puppetlabs.com',
               :timeout     => 400

      action 'check_updates' do
        if File.exists?('/usr/local/munki/managedsoftwareupdate')
          @updates = []
          out = []
          status = run('/usr/local/munki/managedsoftwareupdate --checkonly', :stdout => out, :stderr => :errors)
          out[0].each do |line|
            puts line
            line.lstrip!
            if line =~ /^\+/
              @updates << line.split("\s")[1].chomp
            end
          end

          unless @updates.empty?
            reply[:output] = @updates.sort
          else
            reply[:output] = "No Updates Available: #{out.size}"
          end
        else
          reply[:output] = "/usr/local/munki/managedsoftwareupdate does not exist. Exiting..."
        end
      end

      action 'check_updates_with_id' do
        if File.exists?('/usr/local/munki/managedsoftwareupdate')
          @updates = []
          out = []
          status = run("/usr/local/munki/managedsoftwareupdate --checkonly --id=#{request[:id]}", :stdout => out, :stderr => :errors)
          out[0].each do |line|
            puts line
            line.lstrip!
            if line =~ /^\+/ and not @the_error
              @updates << line.split("\s")[1].chomp
            end
          end

          unless @updates.empty?
            reply[:output] = @updates.sort
          else
            reply[:output] = "No Updates Available: #{out.size}"
          end
        else
          reply[:output] = "/usr/local/munki/managedsoftwareupdate does not exist. Exiting..."
        end
      end

      action 'auto_run' do
        if File.exists?('/usr/local/munki/managedsoftwareupdate')
          out = []
          status = run('/usr/local/munki/managedsoftwareupdate --auto', :stdout => out, :stderr => :errors)

          reply[:output] = "Run of 'managedsoftwareupdate --auto' has completed'"
        else
          reply[:output] = "/usr/local/munki/managedsoftwareupdate does not exist. Exiting..."
        end
      end

      action 'list_cache' do
        if File.directory?('/Library/Managed Installs/Cache/')
          reply[:output] = Dir['/Library/Managed Installs/Cache/*'].collect { |file| File.basename(file) }
        else
          reply[:output] = 'The /Library/Managed Installs/Cache directory does not exist'
        end
      end

      action 'install_only' do
        if File.exists?('/usr/local/munki/managedsoftwareupdate')
          run('/usr/local/munki/managedsoftwareupdate --installonly', :stdout => :output, :stderr => :errors)
        else
          reply[:output] = "/usr/local/munki/managedsoftwareupdate does not exist. Exiting..."
        end
      end
    end
  end
end
