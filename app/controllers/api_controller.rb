# a controller to display status infromation on the api
class ApiController < ActionController::Base
  def index
    # hoping to provide some sort of status information here
    @status = nil
  end
end
