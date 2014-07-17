metadata :name        => 'certificate',
         :description => 'Performs actions for certificates',
         :author      => 'Gary Larizza',
         :license     => 'Apache2',
         :version     => '0.1',
         :url         => 'http://puppetlabs.com',
         :timeout     => 120

action "sign", :description => "Sign certs" do
  display :always

  input :filename,
        :prompt      => "Certificate Filename",
        :description => "Certificate Filename",
        :optional    => false,
        :type        => :string,
        :validation  => '(.*?)',
        :maxlength   => 230
end
