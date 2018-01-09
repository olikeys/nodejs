require 'spec_helper.rb'

describe security_group('bastion-sg') do
  it { should exist }
  its(:group_name) { should eq 'bastion-sg' }
  its(:outbound) { should be_opened.protocol('all').for('0.0.0.0/0') }
  its(:inbound_rule_count) { should eq 4 }
  its(:outbound_rule_count) { should eq 1 }
  its(:inbound_permissions_count) { should eq 2 }
  its(:outbound_permissions_count) { should eq 1 }
  it { should belong_to_vpc('application-vpc') }
end

describe security_group('application-alb-sg') do
  it { should exist }
  its(:group_name) { should eq 'application-alb-sg' }
  its(:inbound) { should be_opened(80).protocol('tcp').for('0.0.0.0/0') }
  its(:outbound) { should be_opened.protocol('all').for('0.0.0.0/0') }
  its(:inbound_rule_count) { should eq 2 }
  its(:outbound_rule_count) { should eq 1 }
  its(:inbound_permissions_count) { should eq 1 }
  its(:outbound_permissions_count) { should eq 1 }
  it { should belong_to_vpc('application-vpc') }
end

describe security_group('application-sg') do
  it { should exist }
  its(:group_name) { should eq 'application-sg' }
  its(:inbound) { should be_opened(80).protocol('tcp').for('0.0.0.0/0') }
  its(:outbound) { should be_opened.protocol('all').for('0.0.0.0/0') }
  its(:inbound_rule_count) { should eq 6 }
  its(:outbound_rule_count) { should eq 1 }
  its(:inbound_permissions_count) { should eq 3 }
  its(:outbound_permissions_count) { should eq 1 }
  it { should belong_to_vpc('application-vpc') }
end
