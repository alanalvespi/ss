require 'test_helper'

class FeederControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "should have # of rows in the xml" do
    #here your object to test, i.e. 
    # feeder.xml        
    x = get :show, 'market_update'
    
    assert false unless x == example_xml
    #assertion case in the xml, i.e.
    # assert
    assert true   
  end
  
  
  
end
