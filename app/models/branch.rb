# == Schema Information
# Schema version: 20110623174749
#
# Table name: branches
#
#  id          :integer         primary key
#  name        :string(298)
#  address     :string(1000)
#  city        :string(50)
#  phone       :string(255)
#  email       :string(100)
#  category    :string(1)       not null
#  parent_id   :integer
#  parent_name :string(255)
#  card_id     :string(16)
#  city_id     :integer
#  subdomain   :string(50)
#

class Branch < ActiveRecord::Base
  has_many :satellites, :foreign_key => "parent_id", :class_name => "Branch"
  belongs_to :parent, :foreign_key => "parent_id", :class_name => "Branch"
  
  def isEventBranch
    if self.category =='T'
      true
    else
      false
    end
  end
  
  def self.branch_id_from_subdomain(subdomain)
    subdomainbranch = Branch.find_by_subdomain_and_category(subdomain.downcase,['P','W'])
    id = subdomainbranch.id
    id
  end
  
  def self.branch_name_from_subdomain(subdomain)
    find(branch_id_from_subdomain(subdomain)).name
  end
  
  def self.branch_from_subdomain(subdomain)
    find(branch_id_from_subdomain(subdomain))
  end
  
  def self.associate_branches(subdomain)
    branch_id = branch_id_from_subdomain(subdomain)
    if branch_id == 801
      find(:all, :conditions => ['category IN(? , ?, ?)', 'H','W','T'])
    else
      find(:all, :conditions => ['parent_id = ?', branch_id])
    end
  end
  
  def self.strata_branches 
    find(:all, :conditions => ['category IN(? , ?, ?)', 'H','W','T'])
  end
end

