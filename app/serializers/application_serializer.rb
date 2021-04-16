class ApplicationSerializer < ActiveModel::Serializer
  def active_status
    self.object.active_status_before_type_cast == 1
  end

end
