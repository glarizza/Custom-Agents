metadata :name        => 'certificate',
         :description => 'Performs actions for certificates',
         :author      => 'Gary Larizza',
         :license     => 'Apache2',
         :version     => '0.1',
         :url         => 'http://puppetlabs.com',
         :timeout     => 120

action "sign", :description => "Sign certs" do
  display :always

  output :cmd_1_out,
         :description => "cmd 1 out",
         :display_as  => "cmd_1_out"

  output :cmd_1_err,
         :description => "cmd 1 err",
         :display_as  => "cmd_1_err"

  output :cmd_2_out,
         :description => "cmd 2 out",
         :display_as  => "cmd_2_out"

  output :cmd_2_err,
         :description => "cmd 2 err",
         :display_as  => "cmd_2_err"

  output :cmd_3_out,
         :description => "cmd 3 out",
         :display_as  => "cmd_3_out"

  output :cmd_3_err,
         :description => "cmd 3 err",
         :display_as  => "cmd_3_err"

  input :filename,
        :prompt      => "Certificate Filename",
        :description => "Certificate Filename",
        :optional    => false,
        :type        => :string,
        :validation  => '(.*?)',
        :maxlength   => 230
end
