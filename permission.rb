class Permission
  attr_reader :tree, :permission_store, :user

  def initialize(permission_store, user)
    @tree = {}
    @permission_store = permission_store
    @user = user
  end

  def update
    @tree = permission_store.load_permissions(user)
  end

  def for(class_object, method)
    rules = tree.fetch(class_object).fetch(method)
    (rules.fetch('roles') & user.roles).any?
  rescue KeyError
    raise 'No Permission defined.'
  end
end

