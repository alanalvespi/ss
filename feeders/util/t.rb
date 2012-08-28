require 'rubygems'
require 'mysql2'
require 'sequel'

Sequel.connect(:adapter => 'mysql2', :database=>'ss', :user => 'deploy', :password => 'LeIhJhLFdD', :host => 'ec2-23-23-212-26.compute-1.amazonaws.com')