require_dependency "#{RAILS_ROOT}/vendor/extensions/hejia/app/models/webpm"
class RadminUser < ActiveRecord::Base
  acts_as_readonlyable [:read_only_51hejia]
  has_many :groups, :class_name => "PublishColumnGroup", :conditions => ["is_del = ?", false]

  # 得到用户所有的角色（名称）
  def roles
    @roles ||=
      Webpm.find(:all,
                 :select => "value",
                 :conditions => ["keyword = ? and id in (?)", 'role', role.blank? ? [] : role.split(',')]
                ).map! { |pm| pm.value }
  end

  def member_of?(role)
    roles.include? role
  end

  def admin?
    member_of? '管理员'
  end
end
