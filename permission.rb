class Permission

  def initialize(permission_store, user)
    @permission_store = permission_store
    @user = user
  end

  attr_reader :user, :permission_store

  def tree
    @tree = permission_store.load_permissions(user)
  end

  def for(class_object, method)
    rules = tree.fetch(class_object).fetch(method)
    (rules.fetch('roles') & user.roles).any?
  rescue KeyError
    raise 'No Permission defined.'
  end
end

