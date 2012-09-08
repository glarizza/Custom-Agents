#mco rpc --agent snapshot --action rollback --arg vm='Test Centos' --arg snapshot_name=puppet -I test-master.dc1.puppetlabs.net --verbose

module MCollective
  module Agent
    class Snapshot<RPC::Agent
      metadata :name        => 'snapshot',
               :description => 'Manages/rolls back VMs to a snapshot',
               :author      => 'Gary Larizza',
               :license     => 'Apache 2.0',
               :version     => '0.1',
               :url         => 'http://puppetlabs.com',
               :timeout     => 300

      def establish_connection
        begin
          require 'rubygems'
          require 'rbvmomi'
        rescue => e
          reply.fail "#{e.inspect}"
        end

        vim = RbVmomi::VIM.connect :host => 'vsphere.dc1.puppetlabs.net', :user => 'vsphere_username', :password => 'vsphere_password', :insecure => true
        rootFolder = vim.serviceInstance.content.rootFolder
        @dc = rootFolder.childEntity.grep(RbVmomi::VIM::Datacenter).find { |x| x.name == "dc1" }
      end

      action 'rollback' do
        begin
          @dc ||= establish_connection
          folder_name = @dc.vmFolder.childEntity.grep(RbVmomi::VIM::Folder).find { |x| x.name == 'SELab' }
          vm = folder_name.childEntity.grep(RbVmomi::VIM::VirtualMachine).find { |x| x.name == request[:vm] }
          vm.snapshot.rootSnapshotList.each_with_index { |h, i| @index = i if h.name == request[:snapshot_name] }
        rescue => e
          reply.fail "#{e.inspect}"
        end

        if @index
          reply['result'] = "Found #{request[:snapshot_name]} at index #{@index} on VM #{request[:vm]}"
          vm.snapshot.rootSnapshotList[@index].snapshot.RevertToSnapshot_Task
        else
          reply['result'] = "Did not find anything --> Index: #{@index}\n#{request[:vm]}"
        end
      end
    end
  end
end
