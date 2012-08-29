class SecurityProxy
  def initialize(subject, permission, user = nil)
    @subject = subject
    @subject_name = subject.kind_of?(Class) ? subject.name : subject.class.name
    @permission = permission
    @user = user
  end

  attr_reader :subject, :subject_name, :permission, :user

  def method_missing(method, *args, &block)
    if permission.for(subject_name, method.to_s)
      subject.send(method, *args, &block)
    else
      raise 'Not allowed!'
    end
  end
end

