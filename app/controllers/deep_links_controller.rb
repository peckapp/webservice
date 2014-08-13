class DeepLinksController < ApplicationController
  before_action :confirm_minimal_access, except: [:native_peck, :set_request_format, :set_format_fallbacks]
  before_action :set_request_format, :set_format_fallbacks

  def native_peck
    if mobile_request?
      redirect_to("peckapp://")
    else
      redirect_to("http://peckapp.com")
    end
  end

  def set_request_format
    request.format = :mobile if mobile_request?
  end

  def set_format_fallbacks
    if request.format == :mobile
      self.formats = [:mobile, :html]
    end
  end
end
