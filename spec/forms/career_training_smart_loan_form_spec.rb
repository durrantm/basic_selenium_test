describe 'student loan products', loan_type: 'career_training', page_type: 'form', order: :defined do

  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new

  describe "Career Training Form", :smoke do
    it "exists for following tests to use, otherwise they are skipped" do
      goto_page(p.career_training_loan_form_url, p.career_training_loan_form_id, p)
      find p.main_form, visible: true, wait: Sleep_lengths[:medium]
      expect(find(p.main_form)).to be
    end
  end

  describe "Career Training Sad Page 1", :sad do
    it "has a form for career training student loans that is filled out Incorrectly" do
      goto_page(p.career_training_loan_form_url, p.career_training_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
      # TODO add expects for other values that were entered
    end
  end

  describe "Career Training Happy All Pages", :happy do
    it "has a form for career training student loans that is filled out correctly" do
      goto_page(p.career_training_loan_form_url, p.career_training_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      fill_out_school(p, 'NEW YORK METHODIST HOSPITAL')
      wait_for_ajax
      find_by_id_medium p.degree
      fill_out_education_certificate_information(p, this_year)
      continue(p)
      find_by_id_medium p.copay
      fill_out_loan_information(p)
      continue(p)
      fill_out_employment_information(p)
      continue(p)
      fill_out_financial_information(p)
      continue(p)
      fill_out_contact_information(p)
      continue(p)
      choose_individual_application(p)
      submit_application(p)
      expect_to_see_application_status_page(p)
    end
  end
end
