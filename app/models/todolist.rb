class Todolist < ActiveRecord::Base
  attr_accessible :description, :id, :reason, :state, :tablename
end
