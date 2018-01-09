require 'spec_helper'

describe vpc('application-vpc') do
  it { should exist }
  it { should be_available }
  its(:cidr_block) { should eq '10.2.0.0/16' }
  it { should have_route_table('management-public-subnets-route-table-eu-west-1b') }
  it { should have_route_table('application-public-subnets-route-table-eu-west-1c') }
  it { should have_route_table('management-public-subnets-route-table-eu-west-1a') }
  it { should have_route_table('application-public-subnets-route-table-eu-west-1b') }
  it { should have_route_table('application-public-subnets-route-table-eu-west-1a') }
  it { should have_route_table('management-public-subnets-route-table-eu-west-1c') }
end
