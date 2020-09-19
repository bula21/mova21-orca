# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  icon       :string           not null
#  label      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :tag do
    code { 'MyString' }
    label { 'MyString' }
    icon { 'MyString' }
  end
end
