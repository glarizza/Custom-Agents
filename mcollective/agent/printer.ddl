metadata :name        => 'printer',
         :description => 'Performs actions for printers and printing',
         :author      => 'Gary Larizza',
         :license     => 'BSD',
         :version     => '0.1',
         :url         => 'http://puppetlabs.com',
         :timeout     => 120

action "list", :description => "Lists current printers on the system" do
  display :always

  output :output,
         :description => "Current Printers",
         :display_as  => "Printers"

  output :errors,
         :description => "Error Messages",
         :display_as  => "Errors"
end

action "add", :description => "Adds a printer to the system" do
  display :always

  output :add_output,
         :description => "Add a printer output",
         :display_as  => "Output from Printer Creation"

  output :add_errors,
         :description => "Errors from creating a printer",
         :display_as  => "Errors from Printer Creation"

  input :printer,
        :prompt      => "Printer name (NO SPACES)",
        :description => "Printer name (NO SPACES)",
        :optional    => false,
        :type        => :string,
        :validation  => '(.*?)',
        :maxlength   => 230

  input :address,
        :description => "Printer address (in the format of 'lpd://10.13.1.10')",
        :prompt      => "Printer address (in the format of 'lpd://10.13.1.10')",
        :optional    => false,
        :type        => :string,
        :validation  => '(.*?)',
        :maxlength   => 230

  input :location,
        :description => "Printer location (Please quote value if it contains spaces)",
        :prompt      => "Printer location (Please quote value if it contains spaces)",
        :optional    => true,
        :type        => :string,
        :validation  => '(.*?)',
        :maxlength   => 230

  input :driver,
        :description => "Printer driver file (Please escape or quote values with spaces)",
        :prompt      => "Printer driver file (Please escape or quote values with spaces)",
        :optional    => true,
        :type        => :string,
        :validation  => '(.*?)',
        :maxlength   => 230
end

action "remove", :description => "Removes specified printers" do
  display :always

  output :output,
         :description => "Output",
         :display_as  => "Output"
  
  input :printer,
        :prompt      => "Printer name (NO SPACES)",
        :description => "Printer name (NO SPACES)",
        :optional    => false,
        :type        => :string,
        :validation  => '(.*?)',
        :maxlength   => 230

end

action "devices", :description => "List printers and their devices" do
  display :always

  output :output,
	 :description => "Printers and their devices",
	 :display_as  => "Printers"
end

action "cancel", :description => "Cancels print jobs for a specified queue" do
  display :always

  output :output,
         :description => "Output",
         :display_as  => "Output"
  
  input :printer,
        :prompt      => "Printer name (NO SPACES)",
        :description => "Printer name (NO SPACES)",
        :optional    => false,
        :type        => :string,
        :validation  => '(.*?)',
        :maxlength   => 230

end

action "cancel_all", :description => "Cancels ALL print jobs for ALL printers" do
  display :always

  output :output,
         :description => "Output",
         :display_as  => "Output"
  
  output :errors,
         :description => "Errors",
         :display_as  => "Errors"
end
