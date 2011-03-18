# == Schema Information
# Schema version: 20110316070023
#
# Table name: users
#
#  id                   :integer(38)     not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default("")
#  password_salt        :string(255)     default("")
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer(38)     default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  username             :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :authentications
  
  # Setup accessible (or protected) attributes for your model
  attr_accessor :current_branch
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    self.username = omniauth['user_info']['name'] if username.blank?
     
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def strata_employee?
    email.gsub(/.*@/,'').split('.').include?('strata')
  end

  def subdomain
    email.gsub(/.*@/,'').split('.')[0]
  end

  def frontoffice?
    email.split('@')[0].downcase.eql?('frontoffice')
  end
end
