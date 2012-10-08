class CalculationsController < ApplicationController

require 'find'

    
  # get calculation/switches
  def switch
    
    @calculations = Calculation.new
    
    
    respond_to do |format|
      format.html { render erb: @calculations} 
      format.json { render json: @calculations}
    end
   end
end
