
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws_ip_utilities/version'

Gem::Specification.new do |spec|
  spec.name          = "aws_ip_utilities"
  spec.version       = AwsIpUtilities::VERSION
  spec.authors       = ["Julik Tarkhanov"]
  spec.email         = ["me@julik.nl"]

  spec.summary       = %q{Checks for AWS IP ranges.}
  spec.description   = %q{Checks for AWS IP ranges, including adding to Rack trusted proxy list.}
  spec.homepage      = "https://github.com/WeTransfer/aws_ip_utilities"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "wetransfer_style", "0.6.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rack"
  spec.add_development_dependency "rspec", "~> 3.0"
end
