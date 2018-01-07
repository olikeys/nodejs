require 'spec_helper'
require 'set'

describe "VPC" do
    context "Networking" do
      it "should use the right CIDR" do
        expected_cidr_block = $terraform_tfvars['cidr_block']
        expect($terraform_plan['aws_vpc.vpc']['cidr_block']).to eq expected_cidr_block
      end
    end
  end