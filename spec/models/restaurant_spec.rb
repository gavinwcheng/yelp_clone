require 'rails_helper'
require 'spec_helper'

RSpec.describe Restaurant, type: :model do
  it { is_expected.to have_many :reviews }
end
