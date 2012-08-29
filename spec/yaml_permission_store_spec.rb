require_relative '../lib/yaml_permission_store'

describe YamlPermissionStore do
  describe 'new' do
    it 'accepts a Yaml string' do
      user = stub
      yaml = "---\nfoo: bar"
      permission_store = YamlPermissionStore.new(yaml)

      permission_store.load_permissions(user).should == {
        'foo' => 'bar'
      }
    end
  end
end

