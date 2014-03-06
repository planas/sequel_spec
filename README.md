# SequelSpec

SequelSpec is a refactor of [rspec_sequel_matchers](https://github.com/openhood/rspec_sequel_matchers) borrowing concepts from [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers). In contrast with rspec_sequel_matchers it provides a sweeter syntax and it doesn't rely on a specific mocking framework.

## Installation

Add this line to your application's Gemfile:

    gem 'sequel_spec', :group => :test

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequel_spec

## Usage

The matchers are automatically included on RSpec. Just use them at will.

### Association

```ruby
it { should have_many_to_many :items }
it { should have_many_to_one :item }
it { should have_one_to_many :comments }
it { should have_one_to_one :photo }
it { should have_one_through_one :author }
```

You can specify options using ```#with_options```

```ruby
it { should have_one_through_one(:author).with_options :key => :user_id }
```

### Validation

```ruby
# Format
it { should validate_format_of(:name).with(/\w+/) }

# Inclusion
it { should ensure_inclusion_of(:name).in(['John', 'Smith']) }

# Integrity (valid integer)
it { should validate_integrity_of(:age) }

# Length
it { should validate_length_of(:name).is(20) }
it { should validate_length_of(:name).is_at_least(20) }
it { should validate_length_of(:name).is_at_most(20) }
it { should validate_length_of(:name).is_between(2..20) }

# Not null
it { should validate_not_null(:category_id) }

# Numericality (valid float)
it { should validate_numericality_of(:price) }

# Type
it { should validate_type_of(:birthdate).is Date }

# Uniqueness
it { should validate_uniqueness_of(:username) }
```

This matchers accepts options through ```#with_options``` as well

```ruby
it { should validate_uniqueness_of(:username).with_options :message => "This username is already taken" }
```

Or with the specialized helpers: ```#allowing_nil```, ```#allowing_blank```, ```#allowing_missing```, and ```#with_message```

```ruby
it { should validate_length_of(:name).is(20).allowing_nil }
it { should validate_length_of(:name).is(20).allowing_blank }
it { should validate_length_of(:name).is(20).allowing_missing }
it { should validate_length_of(:name).is(20).with_message "Name should be 20 chars long" }
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/sequel_spec/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
