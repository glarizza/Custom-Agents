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
        certificate_dir  = '/etc/puppetlabs/puppet/ssl/certs'

        reply[:certificate_file] = certificate_file
        reply[:certname] = certname
        reply[:private_key_dir] = private_key_dir
        reply[:certificate_dir] = certificate_dir

        run("/usr/bin/openssl pkcs12 -in #{certificate_file} -passin pass:#{certname} -out #{private_key_dir}/#{certname}.key.pem -nocerts -nodes", :stdout => reply[:cmd_1_out], :stderr => reply[:cmd_1_err])
        run("/usr/bin/openssl pkcs12 -in #{certificate_file} -passin pass:#{certname} -out #{certificate_dir}/#{certname}.crt.pem -clcerts -nodes -nokeys", :stdout => reply[:cmd_2_out], :stderr => reply[:cmd_2_err])
        run("/usr/bin/openssl pkcs12 -in #{certificate_file} -passin pass:#{certname} -out #{certificate_dir}/ca.pem -cacerts -nodes -nokeys", :stdout => reply[:cmd_3_out], :stderr => reply[:cmd_3_err])
      end
    end
  end
end


