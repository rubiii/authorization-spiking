require_relative '../lib/yaml_permission_store'
require_relative '../lib/permission'
require_relative '../lib/security_proxy'

class Task
  def self.start
    '(class) start task'
  end

  def start
    'start task'
  end

  def finish
    'finish task'
  end
end

describe 'The SecurityProxy' do

  let(:config) do
    <<-CONFIG.gsub(/^ {6}/, '')
      ---
      Task:
        start:
          roles:
            - king
    CONFIG
  end

  let(:permission_store) { YamlPermissionStore.new(config) }

  let(:king) { stub(roles: ['king']) }
  let(:pawn) { stub(roles: ['pawn']) }

  it 'rejects a method one is not allowed to call' do
    permission = Permission.new(permission_store, pawn)
    secure_task = SecurityProxy.new(Task.new, permission)

    expect { secure_task.start }.
      to raise_error('Not allowed!')
  end

  it 'rejects a method for which no permissions are defined' do
    permission = Permission.new(permission_store, king)
    secure_task = SecurityProxy.new(Task.new, permission)

    expect { secure_task.finish }.
      to raise_error('No Permission defined.')
  end

  it 'calls methods one is allowed to call' do
    permission = Permission.new(permission_store, king)
    secure_task = SecurityProxy.new(Task.new, permission)

    secure_task.start.should == 'start task'
  end

  it 'rejects a class method one is not allowed to call' do
    permission = Permission.new(permission_store, pawn)
    secure_task = SecurityProxy.new(Task, permission)

    expect { secure_task.start }.
      to raise_error('Not allowed!')
  end

  it "calls class methods one is allowed to call" do
    permission = Permission.new(permission_store, king)
    secure_task = SecurityProxy.new(Task, permission)

    secure_task.start.should == '(class) start task'
  end

  it "is fucking dynamic" do
    permission = Permission.new(permission_store, king)
    secure_task = SecurityProxy.new(Task, permission)

    #secure_task.start.should == '(class) start task'
  end
end
