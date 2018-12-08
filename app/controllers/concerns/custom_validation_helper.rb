module CustomValidationHelper
  extend ActiveSupport::Concern

  def valid_time_string?(str)
    begin
      !Time.zone.parse(str).nil?
    rescue
      false
    end
  end
end