require_relative '../security_proxy'

class TestFoo
  def foo
    'foo'
  end

  def self.bar
    'bar'
  end
end

describe SecurityProxy do
  it 'delegates method calls to its delegate if allowed' do
    permission = stub
    permission.should_receive(:for).with('TestFoo', 'foo').and_return(true)

    SecurityProxy.new(TestFoo.new, permission).foo.should == 'foo'
  end

  it 'raises a not allowed error when action is forbidden' do
    permission = stub
    permission.should_receive(:for).with('TestFoo', 'foo').and_return(false)

    expect {
      SecurityProxy.new(TestFoo.new, permission).foo
    }.to raise_error('Not allowed!')
  end
end

