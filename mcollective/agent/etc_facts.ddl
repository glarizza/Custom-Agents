metadata    :name        => "Etc Facts Agent",
			:description => "A conduit to inspect and modify your /etc/facts.txt file.", 
			:author      => "Gary Larizza <glarizza@me.com>",
			:license     => "Apache License, Version 2.0",
			:version     => "1.0",
			:url         => "http://glarizza.posterous.com",
			:timeout     => 60

action "search", :description => "This action will list all the values from a specified fact." do
    display :always

    input :fact, 
          	:prompt      => "Facter Fact",
          	:description => "The fact for which you're needing values returned.",
          	:type        => :string,
          	:optional    => true,
		  	:validation  => '(.*?)',
          	:maxlength   => 230
		
	output :info,
		  	:description => "Information relevant to your query.",
	        :display_as  => "Client Response"
end

action "factcheck", :description => "This action will check for a specified value from a specified fact." do
    display :always
	
	 input :fact, 
	          	:prompt      => "Facter Fact",
	          	:description => "The fact for which you're needing values returned.",
	          	:type        => :string,
	          	:optional    => true,
			  	:validation  => '(.*?)',
	          	:maxlength   => 230
		
	 input :value, 
	          	:prompt      => "Fact Value",
	          	:description => "The fact value for which you're checking.",
	          	:type        => :string,
	          	:optional    => true,
			  	:validation  => '(.*?)',
	          	:maxlength   => 230
	
	  output :info,
			  	:description => "Information relevant to your query.",
		        :display_as  => "Client Response"
end

action "removevalue", :description => "This action will remove a specified value from a specified fact." do
    display :always
	
	 input :fact, 
	          	:prompt      => "Facter Fact",
	          	:description => "The fact for which you're needing values removed.",
	          	:type        => :string,
	          	:optional    => true,
			  	:validation  => '(.*?)',
	          	:maxlength   => 230
		
	 input :value, 
	          	:prompt      => "Fact Value",
	          	:description => "The fact value that you're actually removing.",
	          	:type        => :string,
	          	:optional    => true,
			  	:validation  => '(.*?)',
	          	:maxlength   => 230
	
	  output :info,
			  	:description => "Information relevant to your query.",
		        :display_as  => "Client Response"
end

action "addvalue", :description => "This action will add a specified value to a specified fact." do
    display :always
	
	 input :fact, 
	          	:prompt      => "Facter Fact",
	          	:description => "The fact for which you're needing values added.",
	          	:type        => :string,
	          	:optional    => true,
			  	:validation  => '(.*?)',
	          	:maxlength   => 230
		
	 input :value, 
	          	:prompt      => "Fact Value",
	          	:description => "The fact value that you're actually adding.",
	          	:type        => :string,
	          	:optional    => true,
			  	:validation  => '(.*?)',
	          	:maxlength   => 230
	
	  output :info,
			  	:description => "Information relevant to your query.",
		        :display_as  => "Client Response"
end

action "addfact", :description => "This action will add a specified fact and values to your /etc/facts.txt file." do
    display :always
	
	 input :fact, 
	          	:prompt      => "Facter Fact",
	          	:description => "The fact you're adding.",
	          	:type        => :string,
	          	:optional    => true,
			  	:validation  => '(.*?)',
	          	:maxlength   => 230
		
	 input :value, 
	          	:prompt      => "Fact Value",
	          	:description => "The fact value(s) that you're actually adding.",
	          	:type        => :string,
	          	:optional    => true,
			  	:validation  => '(.*?)',
	          	:maxlength   => 230
	
	  output :info,
			  	:description => "Information relevant to your query.",
		        :display_as  => "Client Response"
end


action "set", :description => "This action will set a specified value to a specified fact (deleting anything that existed previously)." do
    display :always
	
	 input :fact, 
	          	:prompt      => "Facter Fact",
	          	:description => "The fact for which you're needing a value set.",
	          	:type        => :string,
	          	:optional    => true,
			  	:validation  => '(.*?)',
	          	:maxlength   => 230
		
	 input :value, 
	          	:prompt      => "Fact Value",
	          	:description => "The fact value that you're setting.",
	          	:type        => :string,
	          	:optional    => true,
			  	:validation  => '(.*?)',
	          	:maxlength   => 230
	
	  output :info,
			  	:description => "Information relevant to your query.",
		        :display_as  => "Client Response"
end

action "removefact", :description => "This action will remove a specified fact from your /etc/facts.txt file." do
    display :always
	
	 input :fact, 
	          	:prompt      => "Facter Fact",
	          	:description => "The fact that you're removing.",
	          	:type        => :string,
	          	:optional    => true,
			  	:validation  => '(.*?)',
	          	:maxlength   => 230
	
	  output :info,
			  	:description => "Information relevant to your query.",
		        :display_as  => "Client Response"
end