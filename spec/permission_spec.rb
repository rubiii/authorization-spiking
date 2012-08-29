require_relative '../lib/permission'

describe Permission do

  let(:user) { stub }
  let(:permission_store) { stub }

  subject(:permission) { Permission.new(permission_store, user) }

  describe '#tree' do
    it 'updates the inner permission tree by querying the permission store' do
      permission_tree = stub
      permission_store.should_receive(:load_permissions).with(user).and_return(permission_tree)

      permission.tree.should == permission_tree
    end
  end

  describe '#for' do
    it 'raises an execption if permission path cannot be resolved' do
      permission_store.should_receive(:load_permissions).and_return({})

      expect { subject.for('Foo', 'not_existent') }.
        to raise_error 'No Permission defined.'
    end

    describe 'with permissions defined' do
      before do
        permission_store.should_receive(:load_permissions).with(user).and_return(
          'Foo' => {
            'foo' => {
              'roles' => ['bang']
            }
          }
        )
      end

      it 'returns true when roles match' do
        user.stub(:roles) { ['bang'] }
        permission.for('Foo', 'foo').should be_true
      end

      it 'returns false when roles do not match' do
        user.stub(:roles) { ['boom'] }
        permission.for('Foo', 'foo').should be_false
      end
    end
  end
end

