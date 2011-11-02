module MCollective
    module Agent
        class Yaml_store<RPC::Agent
              require 'puppet'
              
              metadata    :name        => "yaml_store.rb",
                          :description => "A conduit to search your puppet master's YAML store.", 
                          :author      => "Gary Larizza <glarizza@me.com>",
                          :license     => "Apache License, Version 2.0",
                          :version     => "1.0",
                          :url         => "http://glarizza.posterous.com",
                          :timeout     => 60
              
              # Search action:  This action will check for the YAML file of a specified certname or hostname.
              # =>               If the file exists, it will output the contents of the YAML file. If it
              # =>               doesn't exist, you will receive an error message.
              # Variables:
              # =>              :hostname  => The hostname for which we want fact information
              # =>              :certname  => The puppet certname of the node for which we want fact information
              # =>              :fact      => The specific fact whose value we're seeking
              # Calling:
              # =>              Run the fact with 'mc-rpc --agent yaml_store --action search --arg hostname=lab01-hsimaclab-hhs'
              # =>               or with 'mc-rpc --agent yaml_store --action search --arg certname=lab01-hsimaclab-hhs'  
              # =>               or with 'mc-rpc --agent yaml_store --action search --arg certname=lab01-hsimaclab-hhs --arg fact=warranty_end'     
              # 
        
              action "search" do
                
                if request.include?(:hostname) 
                  if request.include?(:fact)
                    searchfield = 'hostname'
                    arg = request[:hostname]
                    reply[:facts] = get_specific_fact(searchfield, arg, request[:fact])
                  else 
                    searchfield = 'hostname'
                    arg = request[:hostname]
                    reply[:facts] = get_all_facts(searchfield, arg)
                  end
                elsif request.include?(:certname)
                  if request.include?(:fact)
                    searchfield = 'certname'
                    arg = request[:certname]
                    reply[:facts] = get_specific_fact(searchfield, arg, request[:fact])
                  else 
                    searchfield = 'certname'
                    arg = request[:certname]
                    reply[:facts] = get_all_facts(searchfield, arg)
                  end
                end
                
                if not (request.include?(:hostname) or request.include?(:certname))
                  reply[:facts] = puts "You must specify either a hostname or a certname."
                end
    
              end # Action end
                   
                # Function:  get_all_facts
                #
                # Arguments:
                # =>        searchfield:  Whether we're searching for the certname or hostname
                # =>        arg:          The actual certname/hostname in question
                #
                # Returns:
                # =>        A list of all the facts for the specified certname or hostname  
                def get_all_facts(searchfield, arg)
                  $found_file = nil
                  Dir.glob("#{Puppet[:vardir]}/yaml/facts/*") {|file|
                    $tempfile = YAML::load_file(file).values
                    if $tempfile[searchfield] == arg
                      $found_file = true
                      break
                    end
                  }
                  
                  if $found_file
                    $tempfile.each_pair{|key, value|
                      puts "#{key} = #{value}"
                    }
                  else
                    return "That #{searchfield} was not found."
                  end
                  
                end # Def end
                
                # Function:  get_specific_facct
                #
                # Arguments:
                # =>        searchfield:  Whether we're searching for the certname or hostname
                # =>        arg:          The actual certname/hostname in question
                # =>        fact:         The specific fact whose value we want 
                #
                # Returns:
                # =>        The value for the specified fact
                def get_specific_fact(searchfield, arg, thefact)
                  $found_file = nil
                  Dir.glob("#{Puppet[:vardir]}/yaml/facts/*") {|file|
                    $tempfile = YAML::load_file(file).values
                    if $tempfile[searchfield] == arg
                      $found_file = true
                      break
                    end
                  }
                  
                  if $found_file
                    if $tempfile[thefact]
                      return "#{thefact} = #{$tempfile[thefact]}"
                    else
                      return "#{thefact} is not a valid fact, or wasn't found."
                    end
                  else
                    return "That #{searchfield} was not found."
                  end
                  
                end # Def end
                
        end # Class Etc_facts end
        
  end # Module Agent end
  
end # Module MCollective end