require_relative '../yaml_permission_store'
require_relative '../permission'
require_relative '../security_proxy'

class Foo
  def foo
    'foo'
  end

  def bar
    'bar'
  end
end

describe 'The SecurityProxy' do

  let(:config) do
    <<-CONFIG.gsub(/^ {6}/, '')
      ---
      Foo:
        foo:
          roles:
            - king
    CONFIG
  end

  let(:permission_store) { YamlPermissionStore.new(config) }

  let(:king) { stub(:roles => ['king'] )}
  let(:pawn) { stub(:roles => ['pawn'] )}

  it 'rejects a method one is not allowed to call' do
    permission = Permission.new(permission_store, pawn)
    permission.update
    secure_foo = SecurityProxy.new(Foo.new, permission)

    expect {
      secure_foo.foo
    }.to raise_error('Not allowed!')
  end

  it 'rejects a method for which no permissions are defined' do
    permission = Permission.new(permission_store, king)
    permission.update
    secure_foo = SecurityProxy.new(Foo.new, permission)

    expect {
      secure_foo.bar
    }.to raise_error 'No Permission defined.'
  end

  it 'calls methods one is allowed to call' do
    permission = Permission.new(permission_store, king)
    permission.update
    secure_foo = SecurityProxy.new(Foo.new, permission)

    secure_foo.foo.should == 'foo'
  end
end
