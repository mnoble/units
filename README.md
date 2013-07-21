# Units

Playing around with simple unit conversion.

## Usage
### Convert from one basic unit to another

```ruby
NumberWithUnit.configure do
  factor 3413, [:kwh, :btu]
end

1.from(:kwh).to(:btu).value
# => 3413.0
```

### Convert special cases for specific energy types

```ruby
NumberWithUnit.configure do
  factor 0.9277, [:kwh, :co2], :electric
end

1.as(:electric).from(:kwh).to(:co2).value
# => 0.9277
```
