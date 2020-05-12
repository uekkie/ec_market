require 'rails_helper'

RSpec.describe BusinessTime, type: :model do
  it '2020/05/12（水）の3営業日後は2020/05/15（金）になる' do
    current = DateTime.new(2020, 5, 12, 9, 0)
    expect(current.workday?).to be_truthy
    expect(3.business_days.after(current).to_date).to eq(DateTime.new(2020, 5, 15).to_date)
  end

  it '2020/05/13（木）の3営業日後は2020/05/18（月）になる' do
    current = DateTime.new(2020, 5, 13, 9, 0)
    expect(current.workday?).to be_truthy
    expect(3.business_days.after(current).to_date).to eq(DateTime.new(2020, 5, 18).to_date)
  end

  it '2020/05/13（木)の3営業日〜14営業日は5/18（月）〜6/2（火）になる' do
    current = DateTime.new(2020, 5, 13, 0, 0)
    expect(current.workday?).to be_truthy
    expect(3.business_days.after(current).to_date).to eq(DateTime.new(2020, 5, 18).to_date)
    expect(14.business_days.after(current).to_date).to eq(DateTime.new(2020, 6, 2).to_date)
  end
end
