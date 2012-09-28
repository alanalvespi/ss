class Todolist < ActiveRecord::Base  
  attr_accessible :tablename, :id, :description, :state, :reason
end