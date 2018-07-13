# AWS IP address utilities

Useful for checking if an IP address belongs to an AWS subnet. The gem automatically updates and publishes itself every day, publishing only takes place
if the AWS IP ranges change.

The prefixes get retrieved from https://ip-ranges.amazonaws.com/ip-ranges.json


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws_ip_utilities'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws_ip_utilities

## Usage

You can check if an IP address belongs to AWS by doing a check:

```
AwsIpUtilities.aws_ip?(your_ip_addr) #=> true or false
```

Find out what region the IP is in:

```
AwsIpUtilities.region_for(your_ip_addr) #=> "eu-west-1"
```

and determine what service it provides:

```
AwsIpUtilities.service_for(your_ip_addr) #=> "CLOUDFRONT"
```

To make `Rack::Request` trust CloudFront as a proxy (when it gets injected into `X-Forwarded-For`) call the following method:

```
AwsIpUtilities.make_cloudfront_rack_trusted_proxy!
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/julik/aws_ip_utilities.

