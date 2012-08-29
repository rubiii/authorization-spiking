class SecurityProxy
  def initialize(subject, permission)
    @subject = subject
    @subject_name = @subject.kind_of?(Class) ? @subject.name : @subject.class.name
    @permission = permission
  end

  def method_missing(method, *args, &block)
    if @permission.for(@subject_name, method.to_s)
      @subject.send(method, *args, &block)
    else
      raise 'Not allowed!'
    end
  end
end

