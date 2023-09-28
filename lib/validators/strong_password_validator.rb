class StrongPasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value =~ /[A-Z]/ && value =~ /[a-z]/ && value =~ /[0-9]/ && value =~ /[^A-Za-z0-9]/

    record.errors.add(attribute, (options[:message] || 'must contain at least one uppercase letter, one lowercase letter, one number, and one special character'))
  end
end
