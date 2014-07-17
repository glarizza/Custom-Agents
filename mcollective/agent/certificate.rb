module MCollective
  module Agent
    class Certificate < RPC::Agent
      metadata :name        => 'Certificate Agent',
               :description => 'Performs actions for Certificates',
               :author      => 'Gary Larizza',
               :license     => 'Apache 2',
               :version     => '0.1',
               :url         => 'http://puppetlabs.com',
               :timeout     => 100

      action 'sign' do
        certificate_file = "/tmp/certs/#{request[:filename]}"
        certname         = File.basename(certificate_file, '.pfx')
        private_key_dir  = '/etc/puppetlabs/puppet/ssl/private_keys'
        public_key_dir  = '/etc/puppetlabs/puppet/ssl/public_keys'
        certificate_dir  = '/etc/puppetlabs/puppet/ssl/certs'
        std_out_1 = []
        std_out_2 = []
        std_out_3 = []
        std_out_4 = []
        std_err_1 = []
        std_err_2 = []
        std_err_3 = []
        std_err_4 = []

        reply[:certificate_file] = certificate_file
        reply[:certname] = certname
        reply[:private_key_dir] = private_key_dir
        reply[:certificate_dir] = certificate_dir
        reply[:cmd_1] = "/usr/bin/openssl pkcs12 -in #{certificate_file} -passin pass:#{certname} -out #{private_key_dir}/#{certname}.key.pem -nocerts -nodes"
        reply[:cmd_2] = "/usr/bin/openssl pkcs12 -in #{certificate_file} -passin pass:#{certname} -out #{certificate_dir}/#{certname}.crt.pem -clcerts -nodes -nokeys"
        reply[:cmd_3] = "/usr/bin/openssl pkcs12 -in #{certificate_file} -passin pass:#{certname} -out #{certificate_dir}/ca.pem -cacerts -nodes -nokeys"


        run("/usr/bin/openssl pkcs12 -in #{certificate_file} -passin pass:#{certname} -out #{private_key_dir}/#{certname}.pem -nocerts -nodes", :stdout => std_out_1, :stderr => std_err_1)
        run("/usr/bin/openssl pkcs12 -in #{certificate_file} -passin pass:#{certname} -out #{certificate_dir}/#{certname}.pem -clcerts -nodes -nokeys", :stdout => std_out_2, :stderr => std_err_2)
        run("/usr/bin/openssl pkcs12 -in #{certificate_file} -passin pass:#{certname} -out #{certificate_dir}/ca.pem -cacerts -nodes -nokeys", :stdout => std_out_3, :stderr => std_err_3)
        run("/usr/bin/openssl rsa -in #{private_key_dir}/#{certname}.pem -out #{public_key_dir}/#{certname}.pem -pubout", :stdout => std_out_4, :stderr => std_err_4)

        reply[:cmd_1_out] = std_out_1
        reply[:cmd_1_err] = std_err_1
        reply[:cmd_2_out] = std_out_2
        reply[:cmd_2_err] = std_err_2
        reply[:cmd_3_out] = std_out_3
        reply[:cmd_3_err] = std_err_3
        reply[:cmd_4_out] = std_out_4
        reply[:cmd_4_err] = std_err_4
      end
    end
  end
end


