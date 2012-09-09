metadata :name        => 'munki',
         :description => 'MCollective agent for interacting with Munki',
         :author      => 'Gary Larizza',
         :license     => 'Apache 2',
         :version     => '0.1',
         :url         => 'http://puppetlabs.com',
         :timeout     => 300

action "check_updates", :description => "Lists available package updates" do
  display :always

  output :output,
         :description => "Available Updates",
         :display_as  => "Packages"

  output :errors,
         :description => "Errors thrown by managedsoftwareupdate",
         :display_as  => "Command Errors"
end

action "check_updates_with_id", :description => "Check available updates for a given manifest id" do
  display :always

  input :id, 
        :prompt      => "Manifest ID",
        :description => "The name (id) of the Munki Manifest to enforce on this machine.",
        :optional    => false,
        :type        => :string,
  	    :validation  => '(.*?)',
        :maxlength   => 230

  output :output,
         :description => "Available Updates",
         :display_as  => "Packages"
  
  output :errors,
         :description => "Errors thrown by managedsoftwareupdate",
         :display_as  => "Command Errors"
end

action "auto_run", :description => "Performs a 'managedsoftwareupdate --auto' run" do
  display :always

  output :output,
         :description => "Run Message",
         :display_as  => "Output"

  output :errors,
         :description => "Errors thrown by managedsoftwareupdate",
         :display_as  => "Command Errors"
end

action "list_cache", :description => "Lists all files in the Munki Cache directory" do
  display :always

  output :output,
         :description => "Cache Contents",
         :display_as  => "Cached Files"

  output :errors,
         :description => "Errors thrown by managedsoftwareupdate",
         :display_as  => "Command Errors"
end

action "install_only", :description => "Performs a 'managedsoftwareupdate --installonly' run that forces package installs silently." do
  display :always

  output :output,
         :description => "Command Output",
         :display_as  => "Response"

  output :errors,
         :description => "Errors thrown by managedsoftwareupdate",
         :display_as  => "Command Errors"
end

