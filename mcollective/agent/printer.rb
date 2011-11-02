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
        reply[:output] = `lpstat -a | cut -d ' ' -f 1`.split("\n")
      end

      action 'devices' do
	      reply[:output] = `lpstat -v | cut -d ' ' -f 3,4`.split("\n")
      end

      action 'add' do
        validate :printer, :shellsafe
        validate :address, :shellsafe

        printerarray = `lpstat -a | cut -d ' ' -f 1`
        reply.fail! "Printer already installed on the system." if printerarray.include? request[:printer] }

        args = ['lpadmin ']
        args.push "-p #{request[:printer]} " if request[:printer]
        args.push "-v #{request[:address]} " if request[:address]

        validate :location, :shellsafe and
          args.push "-L #{request[:location]} " if request[:location]
        validate :driver, :shellsafe and
          args.push "-P #{request[:driver]} " if request[:driver]
        args.push "-E "

        `#{args}`

        printerarray = `lpstat -a | cut -d ' ' -f 1`.split("\n")
        if printerarray.include? request[:printer]
          reply[:output] = "Printer #{request[:printer]} successfully installed on the system."
        else
          reply.fail! "Error: The printer could not be installed."
        end

      end

      action 'remove' do
        validate :printer, :shellsafe

        return_code = system("lpadmin -x #{request[:printer]}")

        if return_code
          reply[:output] = "Successfully removed printer: #{request[:printer]}\n"
        else
	        reply.fail! "There was an error attempting to delete printer: #{request[:printer]}"
        end
      end

      action 'cancel' do
        validate :printer, :shellsafe

        jobsarray = `lpstat -P #{request[:printer]}`

        if jobsarray == ""
          reply.fail! "There are no print jobs for that printer."
        else
          reply[:output] = "Cancelling all print jobs for the #{request[:printer]} printer."
          `lprm -P #{request[:printer]} -`
        end
      end

      action 'cancel_all' do
        `cancel -a -`
        reply[:output] = "Cancelled all print jobs on all queues"
      end
    end
  end
end
