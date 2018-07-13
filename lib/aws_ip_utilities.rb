require 'json'
require 'ipaddr'

module AwsIpUtilities
  require_relative "aws_ip_utilities/version"

  class Prefix < Struct.new(:ip_prefix, :region, :service)
    def include?(addr)
      ip_prefix.include?(addr)
    end
  end

  PREFIXES = JSON.parse(File.read(__dir__ + '/aws_ip_utilities/ip-ranges.json'), symbolize_names: true).fetch(:prefixes).map do |prefix|
    ipaddr = IPAddr.new(prefix.fetch(:ip_prefix))
    Prefix.new(ipaddr, prefix.fetch(:region), prefix.fetch(:service))
  end

  def self.aws_ip?(ip_addr_string)
    aws_prefix(ip_addr_string) ? true : false
  end

  def self.aws_prefix(ip_addr_string)
    ip = IPAddr.new(ip_addr_string)
    PREFIXES.find {|subnet| subnet.include?(ip) }
  end

  def self.region_for(ip_addr_string)
    if prefix = aws_prefix(ip_addr_string)
      prefix.region
    end
  end

  def self.service_for(ip_addr_string)
    if prefix = aws_prefix(ip_addr_string)
      prefix.service
    end
  end

  def self.make_cloudfront_rack_trusted_proxy!
    require_relative 'aws_ip_utilities/rack_request_trusted_proxy_override'
    Rack::Request.prepend(RackRequestTrustedProxyOverride)
  end
end
