class SecurityProxy
  def initialize(subject, permission)
    @subject = subject
    @permission = permission
  end

  def method_missing(method, *args, &block)
    if @permission.for(@subject.class.to_s, method.to_s)
      @subject.send(method, *args, &block)
    else
      raise 'Not allowed!'
    end
  end
end

