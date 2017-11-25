describe 'student loan products', loan_type: 'parent', page_type: 'form', order: :defined do

  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new

  describe "Parent Form", :smoke do
    it "exists for following tests to use, otherwise they are skipped" do
      visit_url(TEST_ENVIRONMENT, p.parent_loan_form_url, p.parent_loan_form_id, p)
      find p.main_form, visible: true, wait: Sleep_lengths[:medium]
      expect(find(p.main_form)).to be
    end
  end

  describe "Parent Sad Page 1", :sad do
    it "has a form for parent loans that is filled out Incorrectly" do
      visit_url(TEST_ENVIRONMENT, p.parent_loan_form_url, p.parent_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
    end
  end

  describe "Parent Happy All Pages", :happy do
    it "has a form for parent student loans that is filled out correctly" do
      visit_url(TEST_ENVIRONMENT, p.parent_loan_form_url, p.parent_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      select 'Parent', from: p.relationship_to_student
      continue(p)
      fill_out_address(p)
      continue(p)
      find p.main_form
      fill_out_student_info(p)
      fill_out_school(p, 'NEW YORK LAW SCHOOL, NEW YORK, NY, 00278300')
      wait_for_ajax
      fill_out_education_degree_information(p, this_year)
      continue(p)
      find_by_id_medium p.copay
      fill_out_loan_information(p)
      continue(p)
      fill_out_employment_information(p)
      continue(p)
      find_by_id p.checking_account
      check p.checking_account
      fill_out_financial_information(p)
      continue(p)
      choose_individual_application(p)
      within_frame(find(p.dialog_frame)) do
        first('input#rdoStudentDependentConfirmation').click
      end
      submit_application(p)
      expect_to_see_application_status_page(p)
    end
  end
end
