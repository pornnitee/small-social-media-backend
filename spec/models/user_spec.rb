# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  # Associations
  it { should have_many(:posts) }

  # Validations
  it { should validate_presence_of(:user_name) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should allow_value('user@example.com').for(:email) }
  it { should_not allow_value('invalid-email').for(:email) }
end
