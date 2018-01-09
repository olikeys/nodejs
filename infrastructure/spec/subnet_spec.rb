require 'spec_helper'
describe subnet('man-pub-eu-west-1c') do
  it { should exist }
  it { should be_available }
  it { should belong_to_vpc('application-vpc') }
  its(:cidr_block) { should eq '10.2.1.80/28' }
end

describe subnet('app-pub-eu-west-1c') do
  it { should exist }
  it { should be_available }
  it { should belong_to_vpc('application-vpc') }
  its(:cidr_block) { should eq '10.2.0.80/28' }
end

describe subnet('man-pub-eu-west-1a') do
  it { should exist }
  it { should be_available }
  it { should belong_to_vpc('application-vpc') }
  its(:cidr_block) { should eq '10.2.1.48/28' }
end

describe subnet('app-pub-eu-west-1b') do
  it { should exist }
  it { should be_available }
  it { should belong_to_vpc('application-vpc') }
  its(:cidr_block) { should eq '10.2.0.64/28' }
end

describe subnet('man-pub-eu-west-1b') do
  it { should exist }
  it { should be_available }
  it { should belong_to_vpc('application-vpc') }
  its(:cidr_block) { should eq '10.2.1.64/28' }
end

describe subnet('app-pub-eu-west-1a') do
  it { should exist }
  it { should be_available }
  it { should belong_to_vpc('application-vpc') }
  its(:cidr_block) { should eq '10.2.0.48/28' }
end
