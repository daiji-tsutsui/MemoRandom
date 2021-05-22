class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  def error_print(str)
    [str] + self.errors.full_messages
  end
end
