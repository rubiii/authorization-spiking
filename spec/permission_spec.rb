require_relative '../permission'

describe Permission do

  let(:user) { stub }
  let(:permission_store) { stub }
  subject { Permission.new(permission_store, user) }

  describe '#new' do
    it 'creates an empty permission tree' do
      subject.tree.should == {}
    end

    it 'holds a reference to the given permission_store' do
      subject.permission_store.should == permission_store
    end
  end

  describe '#update' do
    it 'updates the inner permission tree by querying the permission store' do
      permission_tree = stub
      permission_store.should_receive(:load_permissions).with(user).and_return(permission_tree)

      subject.tap do |permission|
        permission.update
        permission.tree.should == permission_tree
      end
    end
  end

  describe '#for' do
    it 'raises an execption if permission path cannot be resolved' do
      expect {
        subject.for('Foo', 'not_existent')
      }.to raise_error 'No Permission defined.'
    end

    describe 'with permissions defined' do
      before do
        permission_store.should_receive(:load_permissions).with(user).and_return({
          'Foo' => {
            'foo' => {
              'roles' => ['bang']
            }
          }
        })
      end

      it 'returns true when roles match' do
        user.stub(:roles) { ['bang'] }

        subject.tap do |permission|
          permission.update
          permission.for('Foo', 'foo').should be_true
        end
      end

      it 'returns false when roles do not match' do
        user.stub(:roles) { ['boom'] }

        subject.tap do |permission|
          permission.update
          permission.for('Foo', 'foo').should be_false
        end
      end
    end
  end
end

