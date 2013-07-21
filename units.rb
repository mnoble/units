require "bigdecimal"

class NumberWithUnit
  class << self
    attr_accessor :type
  end

  def self.configure(&block)
    instance_eval(&block)
  end

  def self.conversions
    @conversions ||= {}
  end

  def self.factor(value, units, type=:base)
    from = units.first
    to   = units.last

    conversions[type] ||= {}

    conversions[type][from] ||= {}
    conversions[type][from][to] = BigDecimal.new(value.to_s)

    conversions[type][to] ||= {}
    conversions[type][to][from] = BigDecimal.new((1 / value.to_f).to_s)
  end

  attr_accessor :value, :unit, :type

  def initialize(value, unit, type=:base)
    @value = value
    @unit  = unit
    @type  = type
  end

  def as(as_type)
    NumberWithUnit.new(value, unit, as_type)
  end

  def from(from_unit)
    NumberWithUnit.new(value, from_unit, type)
  end

  def to(new_unit)
    factor    = conversions[type][unit][new_unit]
    new_value = value * factor
    NumberWithUnit.new(new_value, new_unit, type)
  end

  private

  def conversions
    self.class.conversions
  end
end

class Numeric
  def as(type)
    NumberWithUnit.new(self, nil, type)
  end

  def from(unit)
    NumberWithUnit.new(self, unit)
  end
end

NumberWithUnit.configure do
  factor 3413,    [:kwh, :btu]
  factor 748.052, [:ccf, :gallons]
  factor 100_000, [:therms, :btu]
  factor 7.48052, [:ft3, :gallons]
  factor 0.9277,  [:kwh, :co2], :electric
  factor 103_100, [:ccf, :btu], :gas
  factor 11.71,   [:therms, :co2], :gas
  factor 24.26,   [:gallons, :co2], :oil
  factor 138_690, [:gallons, :btu], :oil
end

puts 1.from(:kwh).to(:btu).value.to_f
puts 3413.from(:btu).to(:kwh).value.to_f
puts 1.as(:electric).from(:kwh).to(:co2).value.to_f

