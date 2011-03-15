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
