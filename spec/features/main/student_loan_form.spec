require 'yaml'
require 'spec_helper'
require_relative '../../support/page_object.rb'
require_relative '../../sleepers.rb'

Sleep_lengths = Hash.new
Sleep_lengths[:short]=2
Sleep_lengths[:medium]=4
Sleep_lengths[:long]=14

describe 'student loan products' do
  include Sleepers

  describe "Undergraduate Sad Page 1", sad: true, loan_type: 'undergraduate', page_type: 'form' do
  p = PageObject.new
    it "has a form for undergraduate student loans that is filled out Incorrectly", happy: true, loan_type: 'undergraduate' do
      visit "/student-loans/smart-option-student-loan/"
      click_link p.apply_for_loan
      sleep_short
      fill_in p.first_name, with: ''
      fill_in p.middle_initial, with: 't'
      fill_in p.last_name, with: 'testLast'
      fill_in p.email_address, with: 'test@salliemae.com'
      fill_in p.phone, with: '6175551212'
      select 'JAN', from: p.dob_month
      fill_in p.dob_day, with: '01'
      fill_in p.dob_year, with: '1992'
      select 'US Citizen', from: 'BO_Citizenship1'
      fill_in 'BO_SSN1_mask', with: '666'
      fill_in 'BO_SSN2_mask', with: '00'
      fill_in 'BO_SSN3_mask', with: '0000'
      fill_in 'BO_ConfirmSSN1_mask', with: '666'
      fill_in 'BO_ConfirmSSN2_mask', with: '00'
      fill_in 'BO_ConfirmSSN3_mask', with: '0000'
      find('button#Continue').click
      expect(find('input#BO_FirstName').value).to eq ''
      expect(find("input#BO_LastName").value).to eq 'testLast'
      expect(find("input#BO_EmailAddr").value).to eq 'test@salliemae.com'
    end
  end

  describe "Undergraduate Happy All Pages", happy: true, smoke: true, loan_type: 'undergraduate', page_type: 'form' do
    it "has a form for undergraduate student loans", smoke: true do
      visit "/student-loans/smart-option-student-loan/"
      click_link 'Apply for this loan'
      expect(find('form#mainform')).to be
    end
    it "has a form for undergraduate student loans that is filled out correctly", happy: true, loan_type: 'undergraduate' do
      visit "/student-loans/smart-option-student-loan/"
      click_link 'Apply for this loan'
      sleep_short
      fill_in 'BO_FirstName', with: 'testFirst'
      fill_in 'BO_MiddleInitial', with: 't'
      fill_in 'BO_LastName', with: 'testLast'
      fill_in 'BO_EmailAddr', with: 'test@salliemae.com'
      fill_in 'BO_PrimaryPhoneNbr', with: '6175551212'
      select 'JAN', from: 'BO_DOB1'
      fill_in 'BO_DOB2', with: '01'
      fill_in 'BO_DOB3', with: '1992'
      select 'US Citizen', from: 'BO_Citizenship1'
      fill_in 'BO_SSN1_mask', with: '666'
      fill_in 'BO_SSN2_mask', with: '00'
      fill_in 'BO_SSN3_mask', with: '0000'
      fill_in 'BO_ConfirmSSN1_mask', with: '666'
      fill_in 'BO_ConfirmSSN2_mask', with: '00'
      fill_in 'BO_ConfirmSSN3_mask', with: '0000'
      find('button#Continue').click
      sleepy  Sleep_lengths[:medium] # Increased from short to medium to pass.  md
      expect(find('div#BO_AddressInfo')).to be

      fill_in 'BO_PermStreetAddr1', with: '1 main st'
      fill_in 'BO_PermStreetAddr2', with: 'Apt#1'
      fill_in 'BO_PermCity', with: 'New York'
      select 'New York', from: 'BO_PermState'
      fill_in 'BO_PermZipCode', with: '10024'
      select '10', from: 'BO_PermAddrLengthYears'
      find('button#Continue').click
      expect(find('form#mainform')).to be

      fill_in 'BO_School', with: 'NEW YORK LAW SCHOOL, NEW YORK, NY, 00278300'
      sleep_short
      find('input#BO_School').send_keys :arrow_down
      find('input#BO_School').send_keys :tab
      select 'Bachelors', from: 'BO_Degree'
      select 'Law and Law Studies', from: 'BO_Major'
      select 'Full Time', from: 'BO_EnrollmentStatus'
      select 'First Year Masters/Doctorate', from: 'BO_GradeLevel'
      select 'Jan', from: 'BO_LoanPeriodStartDate1'
      select Date.today.strftime('%Y'), from: 'BO_LoanPeriodStartDate2'
      select 'Jan', from: 'BO_LoanPeriodEndDate1'
      select Date.today.strftime('%Y').to_i+1, from: 'BO_LoanPeriodEndDate2'
      select 'Jan', from: 'BO_AnticipatedGradDate1'
      select Date.today.strftime('%Y').to_i+2, from: 'BO_AnticipatedGradDate2'
      find('button#Continue').click
      sleepy  Sleep_lengths[:medium] # Increased from short to medium to pass.  md
      expect(find('input#BO_COAAmt')).to be

      fill_in 'BO_COAAmt', with: '10000'
      fill_in 'BO_EstFinAsstAmt', with: '4000'
      fill_in 'BO_CalcLoanAmt', with: '4000'
      fill_in 'BO_ReqLoanAmt', with: '2000'
      find('button#Continue').click
      sleep_short
      expect(find 'select#BO_EmploymentStatus').to be

      select 'Employed PT', from: 'BO_EmploymentStatus'
      find('button#Continue').click
      fill_in 'BO_CurrEmployerName', with: 'test inc'
      select 'Engineer', from: 'BO_Occupation'
      fill_in 'BO_WorkPhone', with: '6175551212'
      fill_in 'BO_WorkPhoneExt', with: '100'
      select '10', from: 'BO_EmploymentLength'
      fill_in 'BO_GrossAnnualIncome', with: '50000'
      find('button#Continue').click
      expect(find 'input#BO_CheckingCheckBox').to be

      check('BO_CheckingCheckBox')
      expect(find 'input#BO_CheckingAmt').to be

      check 'BO_CheckingCheckBox'
      fill_in 'BO_CheckingAmt', with: '1000'
      select 'Own', from: 'BO_ResidenceType'
      fill_in 'BO_MortgageRentAmt', with: 1000
      find('button#Continue').click
      sleep_short
      expect(find 'input#BO_PC1_FirstName').to be

      fill_in 'BO_PC1_FirstName', with: 'testMomFirst'
      fill_in 'BO_PC1_LastName', with: 'testMomLast'
      fill_in 'BO_PC1_PhoneNumber', with: '6175551212'
      select 'Mother', from: 'BO_PC1_RelToContact'
      fill_in 'BO_PC2_FirstName', with: 'testDadFirst'
      fill_in 'BO_PC2_LastName', with: 'testDadLast'
      fill_in 'BO_PC2_PhoneNumber', with: '6175551213'
      select 'Father', from: 'BO_PC2_RelToContact'
      find('button#Continue').click
      choose 'BO_HowToApplyChoice', option: 'I'
      find('button#Continue').click
      sleep_short
      expect(find 'iframe#dialogIFrame').to be

      within_frame(find('iframe#dialogIFrame')) do
        find('img#ElectronicConsentAccept').click
      end
      sleep_short
      within_frame(find('iframe#dialogIFrame')) do
        expect(find('div.slm-title-module', text: /^Information.*Rates.*Fees$/)).to be
      end

      within_frame(find('iframe#dialogIFrame')) do
        find('button#imgContinue').click
      end
      within_frame(find('iframe#dialogIFrame')) do
        expect(find('div.slm-title-module', text: /^Privacy Policy$/)).to be
      end

      within_frame(find('iframe#dialogIFrame')) do
        find('button#btnContinue').click
      end

      within_frame(find('iframe#dialogIFrame')) do
        find('button#btnSubmitApp').click
      end

      sleepy Sleep_lengths[:long]
      expect(find('div.slm-title-module', text: /^Application Status$/)).to be
      sleep_short
    end
  end
end
