module MCollective
  module Agent
    class Printer<RPC::Agent
      metadata :name        => 'printer',
               :description => 'Performs actions for printers and printing',
               :author      => 'Gary Larizza',
               :license     => 'BSD',
               :version     => '0.1',
               :url         => 'http://puppetlabs.com',
               :timeout     => 100

      action 'list' do
        list = []
        run("lpstat -a | cut -d ' ' -f 1", :stdout => list, :stderr => :errors)

        if list.first
          reply[:output] = list.first.split
        else
          reply[:output] = 'No printers have been installed'
        end
      end

      action 'devices' do
        list = []
	      run("lpstat -v | cut -d ' ' -f 3,4", :stdout => list, :stderr => :errors)
        reply[:output] = list
      end

      action 'add' do
        validate :printer, :shellsafe
        validate :address, :shellsafe

        list = []
        run("lpstat -a | cut -d ' ' -f 1", :stdout => list, :stderr => :errors)
        printerarray = list.first.split unless list.empty?

        unless printerarray.nil?
          reply.fail! "Printer already installed on the system." if printerarray.include? request[:printer]
        end

        args = 'lpadmin '
        args << "-p '#{request[:printer]}' " if request[:printer]
        args << "-v '#{request[:address]}' " if request[:address]

        validate :location, :shellsafe and
          args << "-L '#{request[:location]}' " if request[:location]
        validate :driver, :shellsafe and
          args << "-P '#{request[:driver]}' " if request[:driver]
        args << "-E "

        # Run the command created from above
        run(args, :stdout => :add_output, :stderr => :add_errors)

        # Update the list of printers
        list = []
        run("lpstat -a | cut -d ' ' -f 1", :stdout => list)
        printerarray = list.first.split unless list.empty?

        if printerarray.include? request[:printer]
          reply[:output] = "Printer #{request[:printer]} successfully installed on the system."
        else
          reply.fail! "Error: The printer could not be installed."
        end

      end

      action 'remove' do
        validate :printer, :shellsafe

        status = run("lpadmin -x #{request[:printer]}")

        if status == 0
          reply[:output] = "Successfully removed printer: #{request[:printer]}\n"
        else
          reply[:output] = "There was an error attempting to delete printer: #{request[:printer]}"
	        reply.fail! "There was an error attempting to delete printer: #{request[:printer]}"
        end
      end

      action 'cancel' do
        validate :printer, :shellsafe
        list = []

        run("lpstat -P #{request[:printer]}", :stdout => list)

        if list.empty?
          reply[:output] = "There are no print jobs for that printer."
        else
          reply[:output] = "Cancelling all print jobs for the #{request[:printer]} printer."
          run("lprm -P #{request[:printer]} -")
        end
      end

      action 'cancel_all' do
        errors = []
        run('cancel -a -', :stderr => errors)

        unless errors.empty?
          reply[:errors] = errors.first
        else
          reply[:output] = "Cancelled all print jobs on all queues"
        end
      end
    end
  end
end
