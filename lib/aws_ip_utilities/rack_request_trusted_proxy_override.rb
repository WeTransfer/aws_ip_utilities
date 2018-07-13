module AwsIpUtilities::RackRequestTrustedProxyOverride
  def trusted_proxy?(ip)
    return true if super(ip)
    return true if AwsIpUtilities.aws_ip?(ip)
    false
  end
end
