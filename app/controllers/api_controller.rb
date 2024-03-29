require 'new_relic/agent/instrumentation/controller_instrumentation'
# a controller to display status infromation on the api
class ApiController < ActionController::Base
  newrelic_ignore_apdex

  def index
    # hoping to provide some sort of status information here
    @status = nil
  end

  # action to redirect users to the main website. used as root in production
  def main_redirect
    redirect_to 'https://www.peckapp.com'
  end
end
