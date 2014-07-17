metadata :name        => 'certificate',
         :description => 'Performs actions for certificates',
         :author      => 'Gary Larizza',
         :license     => 'Apache2',
         :version     => '0.1',
         :url         => 'http://puppetlabs.com',
         :timeout     => 120

action "sign", :description => "Sign certs" do
  display :always

  output :cmd_1,
         :description => "command",
         :display_as  => "command"

  output :cmd_2,
         :description => "command",
         :display_as  => "command"

  output :cmd_3,
         :description => "command",
         :display_as  => "command"

  output :certificate_file,
         :description => "certificate file",
         :display_as  => "certificate_file"

  output :certname,
         :description => "certname",
         :display_as  => "certname"

  output :private_key_dir,
         :description => "private key dir",
         :display_as  => "private_key_dir"

  output :certificate_dir,
         :description => "certificate_dir",
         :display_as  => "certificate_dir"

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

  output :cmd_4_out,
         :description => "cmd 4 out",
         :display_as  => "cmd_4_out"

  output :cmd_4_err,
         :description => "cmd 4 err",
         :display_as  => "cmd_4_err"

  input :filename,
        :prompt      => "Certificate Filename",
        :description => "Certificate Filename",
        :optional    => false,
        :type        => :string,
        :validation  => '(.*?)',
        :maxlength   => 230
end
