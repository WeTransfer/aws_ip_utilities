require "spec_helper"

RSpec.describe AwsIpUtilities do
  it "has a version number" do
    expect(AwsIpUtilities::VERSION).not_to be nil
  end

  it "has the minor version start with 20 to indicate date" do
    expect(AwsIpUtilities::VERSION).to match(/\.20\d+$/)
  end

  it "has the sync token set" do
    expect(AwsIpUtilities::SYNC_TOKEN).to be_kind_of(String)
  end

  it "does not tag localhost as AWS IP" do
    expect(AwsIpUtilities).not_to be_aws_ip('127.0.0.1')
  end

  it "does not tag Google DNS as AWS IP" do
    expect(AwsIpUtilities).not_to be_aws_ip('8.8.8.8')
  end

  it "tags Cloudfront IPs in range AWS IP addresses" do
    expect(AwsIpUtilities).to be_aws_ip('216.137.60.1')
    expect(AwsIpUtilities).to be_aws_ip('216.137.60.47')
    expect(AwsIpUtilities).to be_aws_ip('216.137.60.255')
    expect(AwsIpUtilities).not_to be_aws_ip('216.137.64.255')
  end
end
