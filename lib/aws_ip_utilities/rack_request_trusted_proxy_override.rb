module AwsIPUtilities
  module RackRequestTrustedProxyOverride
    def trusted_proxy?(ip)
      return true if super(ip)
      return true if AwsIpUtilities.service_for(ip) == 'CLOUDFRONT'
      false
    end
  end
end
