# frozen_string_literal: true

module PhoneNumberHelper
  def seems_like_mobile_number?(phone_number)
    (phone_number =~ /^((\+|00)41 ?|0)7[5-9]/).present?
  end
end
