# == Schema Information
# Schema version: 20110316070023
#
# Table name: authentications
#
#  id         :integer(38)     not null, primary key
#  user_id    :integer(38)
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Authentication < ActiveRecord::Base
  establish_connection(AMSSettings.global_db)
  
  belongs_to :user
end
