require 'spec_helper.rb'

describe route53_hosted_zone('cni-techtest-ok.com.') do
  it { should exist }
  its(:resource_record_set_count) { should eq 4 }
end
