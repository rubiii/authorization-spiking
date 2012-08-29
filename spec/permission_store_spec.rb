require_relative '../permission_store'

describe PermissionStore do
  describe 'load_permissions' do
    it 'returns the permissions for a given user' do
      user = stub
      PermissionStore.load_permissions(user).should == {}
    end
  end
end

