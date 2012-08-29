require "yaml"

class YamlPermissionStore
  def initialize(permission_config)
    @permissions = YAML.load(permission_config)
  end

  def load_permissions(user)
    @permissions
  end
end

