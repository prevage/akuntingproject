require 'rails_helper'

RSpec.describe Employee, type: :model do
  
	it "has valid Employee" do
		expect(build(:employee)).to be_valid
	end

	it "Employee not valid without :email" do
		expect(build(:employee, email: nil)).to_not be_valid
	end

	it "Employee not valid if password_confimartion doe not match" do
		expect(build(:employee, password_confirmation: "12345657")).to_not be_valid
	end

	it do 
		should have_one(:profile)
	end

	it { should validate_presence_of(:email) }

	it { should accept_nested_attributes_for(:profile)}

	it 'profile :fname is woodson' do
		emp = build(:employee, profile_attributes: { fname: 'woodson', lname: 'delhia'})

		expect(emp.profile.fname).to eql("woodson")
	end

	it 'check that profile_id is same as employee' do
		emp = build(:employee, profile_attributes: { fname: 'woodson', lname: 'delhia'})

		expect(emp.profile.employee_id).to eql(emp.id)
	end

end
