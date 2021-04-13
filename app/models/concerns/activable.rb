module Activable
  extend ActiveSupport::Concern

  included do
    enum active_status: [:inactive, :active]

    validates_presence_of :active_status
  end

  def active_status=val
    val = :active if val == "true" || val == true
    val = :inactive if val == "false" || val == false
    super
  end

  module ClassMethods
    def by_active_status active_status
      active_status = case active_status
      when "true" then :active
      when "false" then :inactive
      else "all"
      end
      return active_status == "all" ? all : where(active_status: active_status)
    end
  end
end
