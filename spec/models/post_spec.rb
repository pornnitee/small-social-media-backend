# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  # Associations
  it { is_expected.to belong_to(:user) }
end
