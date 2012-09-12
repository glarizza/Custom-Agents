begin
  require 'osx/cocoa'
  include OSX
rescue LoadError
  # I'm rescuing this error in case the agent gets installed on a Linux
  # box (like the master) that DOES NOT have osx/cocoa. We don't want to
  # EXIT because that would fail to load the Agent and Live Management
  # on the master (if you install this on the master) would COMPLETELY BLANK
  # out the Controlling Puppet and Advanced Tasks windows.  Which sucks. Hard.
end

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

      action 'apple_sus_packages_only' do
        if File.exists?('/usr/local/munki/managedsoftwareupdate')
          run('/usr/local/munki/managedsoftwareupdate --applesuspkgsonly', :stdout => :output, :stderr => :errors)
        else
          reply[:output] = "/usr/local/munki/managedsoftwareupdate does not exist. Exiting..."
        end
      end

      action 'munki_packages_only' do
        if File.exists?('/usr/local/munki/managedsoftwareupdate')
          run('/usr/local/munki/managedsoftwareupdate --munkipkgsonly', :stdout => :output, :stderr => :errors)
        else
          reply[:output] = "/usr/local/munki/managedsoftwareupdate does not exist. Exiting..."
        end
      end

      action 'version' do
        if File.exists?('/usr/local/munki/managedsoftwareupdate')
          run('/usr/local/munki/managedsoftwareupdate --version', :stdout => :output, :stderr => :errors)
        else
          reply[:output] = "/usr/local/munki/managedsoftwareupdate does not exist. Exiting..."
        end
      end

      action 'settings' do
        munki_plist = '/Library/Preferences/ManagedInstalls.plist'
        if File.exists?(munki_plist)
          munki_plist_hash = OSX::NSMutableDictionary.dictionaryWithContentsOfFile(munki_plist).to_ruby
          reply[:output] = munki_plist_hash
        else
          reply[:output] = "/Library/Preferences/ManagedInstalls.plist does not exist. Exiting..."
        end
      end

      action 'application_search_by_name' do
        if File.exists?('/Library/Managed Installs/ApplicationInventory.plist')
          inventory_plist = File.read('/Library/Managed Installs/ApplicationInventory.plist')

          nsdata = inventory_plist.to_ns.dataUsingEncoding(NSUTF8StringEncoding)
          inventory_data_array = OSX::NSPropertyListSerialization.objc_send(
            :propertyListFromData, nsdata,
            :mutabilityOption, OSX::NSPropertyListMutableContainersAndLeaves,
            :format, nil,
            :errorDescription, nil).to_ruby

          list_of_applications = Hash.new
          inventory_data_array.each do |app|
            if app['name'] =~ /#{request[:name]}/i
              list_of_applications[app['name']] = app
            end
          end

          unless list_of_applications.empty?
            reply[:output] = list_of_applications
          else
            reply[:output] = 'Application Not Found'
          end
        else
          reply.fail! "'/Library/Managed Installs/ApplicationInventory.plist' does not exist"
        end
      end
    end
  end
end
