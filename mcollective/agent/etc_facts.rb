module MCollective
    module Agent
        class Etc_facts<RPC::Agent
              metadata    :name        => "Utility for /etc/facts.txt Fact File",
                          :description => "A conduit to inspect and modify your /etc/facts.txt file.", 
                          :author      => "Gary Larizza <glarizza@me.com>",
                          :license     => "Apache License, Version 2.0",
                          :version     => "1.0",
                          :url         => "http://marionette-collective.org/",
                          :timeout     => 3
                          
              
              # search action:  This action will list all the values from a specified fact.
              #
              # Variables:
              # =>              fact  => The fact for which we're checking a value

              action "search" do
                 validate :fact, String

                 hash = check_file

                 if hash == "false"
                   reply[:info] = "The /etc/facts.txt file was not found."
                 end

                 if hash.size == 0
                   reply[:info] = "The /etc/facts.txt file does not contain any key/value pairs."
                 else
                   if hash.has_key?(request[:fact]) 
                     reply[:info] = "The value of #{request[:fact]} is: #{hash[request[:fact]]}"
                   else
                      reply.fail "The #{request[:fact]} fact has not been found in this /etc/facts.txt file."
                    end
                 end
              end # Action end.

              
              # factcheck action:  This action will check for a specified value from a specified fact.
              # =>               if either the fact or the value is incorrect, you will be alerted.
              # Variables:
              # =>              fact  => The fact for which we're checking a value
              # =>              value => The value for which we're searching
        
              action "factcheck" do
                 validate :value, String
                 validate :fact, String

                 hash = check_file
                        
                 if hash == "false"
                   reply[:info] = "The /etc/facts.txt file was not found."
                 end
                        
                 if hash.size == 0
                   reply[:info] = "The /etc/facts.txt file does not contain any key/value pairs."
                 else
                   if hash.has_key?(request[:fact]) 
                     if hash[request[:fact]] =~ /(?i)#{request[:value]}/
                       reply[:info] = "#{request[:value]} was found.  Here is the contents of the #{request[:fact]} fact: #{hash[request[:fact]]}"
                     else
                       reply.fail "Value #{request[:value]} is not found."
                     end
                    else
                      reply.fail "The #{request[:fact]} fact has not been found in this /etc/facts.txt file."
                    end
                 end
                
                end # Action end.
        
                # removevalue action:  This action removes a specified value from the specified fact.  If the
                # =>               value or fact is not found, we return an error.
                # Variables:
                # =>              fact  => The fact for which we're removing a value.
                # =>              value => The value we're removing.
                
                action "removevalue" do
                  
                  validate :value, String
                  validate :fact, String
                  
                  hash = check_file
                  
                  if hash == "false"
                     reply.fail "The /etc/facts.txt file was not found."
                  end
                  
                  if hash.size == 0
                     reply[:info] = "The /etc/facts.txt file does not contain any key/value pairs."
                  else
                    if hash.has_key?(request[:fact])
                      if hash[request[:fact]] =~ /,(?i)#{request[:value]},/ or hash[request[:fact]] =~ /,(?i)#{request[:value]}/
                         hash[request[:fact]][",#{request[:value]}"]= ""
                         write_to_file(hash)
                         reply[:info] = "The value of #{request[:fact]} is now: #{hash[request[:fact]]}"
                      elsif hash[request[:fact]] =~ /(?i)#{request[:value]},/
                         hash[request[:fact]]["#{request[:value]},"]= ""
                         write_to_file(hash)
                         reply[:info] = "The value of #{request[:fact]} is now: #{hash[request[:fact]]}"
                      elsif hash[request[:fact]] == request[:value]
                         hash[request[:fact]] = ""
                         write_to_file(hash)
                         reply[:info] = "The value of #{request[:fact]} is now: #{hash[request[:fact]]}"
                      else
                         reply.fail "Value #{request[:value]} is not found in the #{request[:fact]} fact."
                      end
                    else
                      reply.fail "The #{request[:fact]} fact has not been found in this /etc/facts.txt file."
                    end
                  end      
                end # Action end.
                
                #  addvalue Action:  This action will add the specified value to the specified fact by simply
                #                     appending it to the end of the list with a comma.
                #  Variables:
                # =>                fact  => The fact to which we're appending a value.
                # =>                value => The actual value we're appending for the specified fact.
                
                action "addvalue" do
                  
                  validate :value, String
                  validate :fact, String
                  
                  hash = check_file
                  
                  if hash == "false"
                     reply[:info] = "The /etc/facts.txt file was not found."
                  end
                  
                  if hash.size == 0
                     reply[:info] = "The /etc/facts.txt file does not contain any key/value pairs."
                  else
                    if hash.has_key?(request[:fact])
                      if hash[request[:fact]] =~ /#{request[:value]}/
                        reply.fail "The #{request[:value]} value already exists in the #{request[:fact]} fact."
                      elsif hash[request[:fact]] == "" or hash[request[:fact]] == nil
                        hash[request[:fact]] = "#{request[:value]}"
                        reply[:info] = "The value of #{request[:fact]} is now: #{hash[request[:fact]]}"
                        write_to_file(hash)
                      else
                        hash[request[:fact]] += ",#{request[:value]}"
                        reply[:info] = "The value of #{request[:fact]} is now: #{hash[request[:fact]]}"
                        write_to_file(hash)
                      end
                    else
                      reply.fail "The #{request[:fact]} fact has not been found in this /etc/facts.txt file."
                    end
                  end
                end # Action end.
                
                #  addfact Action:  This action will add the specified fact and value to /etc/facts.txt
                #  Variables:
                # =>                fact  => The fact we're adding.
                # =>                value => The value we're adding.
                
                action "addfact" do
                  
                  validate :value, String
                  validate :fact, String
                  
                  hash = check_file
                  
                  if hash == "false"
                     reply[:info] = "The /etc/facts.txt file was not found."
                  end
                  
                  if hash.size == 0
                     reply[:info] = "The /etc/facts.txt file does not contain any key/value pairs."
                  else
                    if hash.has_key?(request[:fact])
                      reply.fail "The #{request[:fact]} fact already exists."
                    else
                      append_to_file(request[:fact], request[:value])
                      reply[:info] = "We've added the following in /etc/facts.txt:  #{request[:fact]}=#{request[:value]}"
                    end
                  end
                end # Action end.
                
                
                #  set Action:  This action will set the specified fact and value in /etc/facts.txt
                # =>            NOTE!! It will overwrite any previously set value.
                #  Variables:
                # =>                fact  => The fact we're setting.
                # =>                value => The value we're setting.
                action "set" do
                  
                  validate :value, String
                  validate :fact, String
                  
                  hash = check_file
                  
                  if hash == "false"
                     reply.fail = "The /etc/facts.txt file was not found."
                  end
                  
                  if hash.size == 0
                     reply.fail = "The /etc/facts.txt file does not contain any key/value pairs."
                  else
                    if hash.has_key?(request[:fact])
                      hash[request[:fact]] = request[:value]
                      write_to_file(hash)
                      reply[:info] = "We've set #{request[:fact]} to be: #{request[:value]}"
                    else
                      reply.fail "The #{request[:fact]} fact has not been found in this /etc/facts.txt file."
                    end
                  end
                end # Action end.
                
                #  removefact Action:  This action will remove the specified fact from your /etc/facts.txt file.
                #
                #  Variables:
                # =>                fact  => The fact we're removing.
                #
                action "removefact" do
                  
                  validate :fact, String
                  
                  hash = check_file
                  
                  if hash == "false"
                     reply.fail "The /etc/facts.txt file was not found."
                  end
                  
                  if hash.size == 0
                     reply[:info] = "The /etc/facts.txt file does not contain any key/value pairs."
                  else
                    if hash.has_key?(request[:fact])
                      hash.delete("#{request[:fact]}")
                      reply[:info] = "We've deleted #{request[:fact]} from your /etc/facts.txt file."
                      write_to_file(hash)
                    else
                      reply.fail "The #{request[:fact]} fact has not been found in this /etc/facts.txt file."
                    end
                  end      
                end # Action end.
      
                
                def check_file
                  h = {}
                  
                  if File.exists?("/etc/facts.txt")
                     File.open("/etc/facts.txt") do |fp|
                        fp.each do |line|
                          key, value = line.chomp.split("=")
                          h[key] = value
                        end
                      end
                      return h
                    else
                      return "false"
                    end
                end # Def end
                
                def write_to_file(h)
                  File.open("/etc/facts.txt", 'w') do |fp|
                    h.each{|key, value| fp.puts "#{key}=#{value}"}
                  end
                end # Def end
                
                def append_to_file(key, value)
                  File.open("/etc/facts.txt", 'a+') do |fp|
                    fp.puts "#{key}=#{value}"
                  end
                end # Def end
                  
                
        end # Class Etc_facts end
        
  end # Module Agent end
  
end # Module MCollective end
        
        
        
