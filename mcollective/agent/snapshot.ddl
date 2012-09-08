metadata    :name        => "VM Snapshot Agent",
            :description => "Manages/rolls back VMs to a snapshot",
            :author      => "Gary Larizza",
            :license     => "Apache 2.0",
            :version     => "0.1",
            :url         => "http://www.puppetlabs.com",
            :timeout     => 300


action "rollback", :description => "Roll a VM back to a snapshot" do
    display :always

    input :vm,
          :prompt      => "VM",
          :description => "The name of the Virtual Machine that is to be rolled back.",
          :type        => :string,
          :validation  => '.',
          :optional    => false,
          :maxlength   => 100

    input :snapshot_name,
          :prompt      => "Snapshot_name",
          :description => "The name of the snapshot to which we are rolling back.",
          :type        => :string,
          :validation  => '.',
          :optional    => false,
          :maxlength   => 100

    output :result,
          :description => "Result from the rollback command",
          :display_as  => "Result"
end
