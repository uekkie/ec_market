class ShipTime < ActiveHash::Base
  self.data = [
    { id: 1, value: '8時〜12時' },
    { id: 2, value: '12時〜14時' },
    { id: 3, value: '14時〜16時' },
    { id: 4, value: '16時〜18時' },
    { id: 5, value: '18時〜20時' },
    { id: 6, value: '20時〜21時' }
  ]

  def self.range
    data.map { |e| e[:value] }
  end
end
