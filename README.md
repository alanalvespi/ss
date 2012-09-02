ss SentrySystem SVA Server
==========================

This is a RubyOnRails Server, implemented for SentrySystems.
In addition to the standard CRUD Datamaintenance, the server
side batch feeders are implemented in it.


Notes
==========================


Database and Server access:
=============================
	:adapter => 'mysql2', 
	:database=>'ss', 
	:user => 'deploy', 
	:password => 'LeIhJhLFdD', 
	:host => 'ec2-23-23-212-26.compute-1.amazonaws.com'
	
	
ssh deploy@ec2-23-23-212-26.compute-1.amazonaws.com


ssh -L 3307:ec2-23-23-212-26.compute-1.amazonaws.com:3306 deploy@ec2-23-23-212-26.compute-1.amazonaws.com


Full DB regeneration, and Startup
=================================

1. rake db:drop
2. rake db:migrate
3. Add Companies: "RL360"
4. Add Plantypes:  
  
	* name:'Oracle',                        company_id: id(RL360), created/updated_at: now
    * name:'Quantum',                       company_id: id(RL360), created/updated_at: now
    * name:'Portafolio Management Service', company_id: id(RL360), created/updated_at: now
    
5. Add Currencies USD,GBP,EUR

6. Run Market_Update
7. Run LoadFunds
8. Run Client_Update
