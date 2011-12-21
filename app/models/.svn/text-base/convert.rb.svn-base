class Convert < ActiveRecord::Base

  def self.get_new_id(type, old)
    old = old.to_s if old.class == Fixnum
    self.find_by_id_type_and_old_id(type, old).try(:new_id)
  end

end
