## Custom MCollective Agents

These are the custom MCollective agents that I've built and the locations for which they should be installed relative to MCollective's libdir (/usr/libexec/mcollective in the Open Source version MCollective, and /opt/puppet/libexec/mcollective on Puppet Enterprise).

Once you've installed the agent, make sure to run `mco controller reload_agents` on an MCollective client to update each MCollective server's config.
