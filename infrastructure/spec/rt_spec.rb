require 'spec_helper.rb'

describe route_table('application-public-subnets-route-table-eu-west-1b') do
  it { should exist }
  it { should belong_to_vpc('application-vpc') }
  it { should have_route('10.2.0.0/16').target(gateway: 'local') }
  it { should have_subnet('app-pub-eu-west-1b') }
end

describe route_table('application-public-subnets-route-table-eu-west-1c') do
  it { should exist }
  it { should belong_to_vpc('application-vpc') }
  it { should have_route('10.2.0.0/16').target(gateway: 'local') }
  it { should have_subnet('app-pub-eu-west-1c') }
end

describe route_table('management-public-subnets-route-table-eu-west-1a') do
  it { should exist }
  it { should belong_to_vpc('application-vpc') }
  it { should have_route('10.2.0.0/16').target(gateway: 'local') }
  it { should have_subnet('man-pub-eu-west-1a') }
end

describe route_table('management-public-subnets-route-table-eu-west-1c') do
  it { should exist }
  it { should belong_to_vpc('application-vpc') }
  it { should have_route('10.2.0.0/16').target(gateway: 'local') }
  it { should have_subnet('man-pub-eu-west-1c') }
end

describe route_table('application-public-subnets-route-table-eu-west-1a') do
  it { should exist }
  it { should belong_to_vpc('application-vpc') }
  it { should have_route('10.2.0.0/16').target(gateway: 'local') }
  it { should have_subnet('app-pub-eu-west-1a') }
end

describe route_table('management-public-subnets-route-table-eu-west-1b') do
  it { should exist }
  it { should belong_to_vpc('application-vpc') }
  it { should have_route('10.2.0.0/16').target(gateway: 'local') }
  it { should have_subnet('man-pub-eu-west-1b') }
end

