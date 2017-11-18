describe 'student loan products', loan_type: 'bar', page_type: 'form', order: :defined do

  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new

	describe "Bar Study Form", smoke: true do
		it "exists for following tests to use, otherwise they are skipped" do
			visit_url(TEST_ENVIRONMENT, p.bar_study_loan_form_url, p.bar_study_loan_form_id, p)
			find p.main_form, visible: true, wait: Sleep_lengths[:medium]
			expect(find(p.main_form)).to be
		end
	end

	describe "Bar Study Sad Page 1", sad: true do
		it "has a form for Bar Study student loans that is filled out Incorrectly" do
			visit_url(TEST_ENVIRONMENT, p.bar_study_loan_form_url, p.bar_study_loan_form_id, p)
			fill_out_basic_information_form(p,d)
			fill_in p.first_name, with: ''
			continue(p)
			expect(find_by_id(p.first_name).value).to eq ''
			expect(find_by_id(p.last_name).value).to eq 'testLast'
			expect(find_by_id(p.email_address).value).to eq d.email
		end
	end

	describe "Bar Study Happy All Pages" do
		it "has a form for Bar Study student loans that is filled out correctly", happy: true do
			visit_url(TEST_ENVIRONMENT, p.bar_study_loan_form_url, p.bar_study_loan_form_id, p)
			fill_out_basic_information_form(p,d)
			continue(p)
			fill_out_address(p)
			continue(p)
			fill_out_school(p, 'DRAKE')
			wait_for_ajax
      find('#' + p.degree + ' option:nth-child(2)', visible:true, wait:Sleep_lengths[:medium_long])
      find('#' + p.degree + ' option:nth-child(2)').select_option
      select 'Full Time', from: p.enrollment_status
      fill_out_graduation(p, this_year-2)
      select 'Jan', from: p.exam_date_month
      select this_year, from: p.exam_date_year
      continue(p)
			find_by_id p.requested_loan, wait: Sleep_lengths[:medium]
			fill_in p.requested_loan, with: 10000
			fill_out_disbursement_information(p, this_year)
			continue(p)
			fill_out_employment_information(p)
			continue(p)
			fill_out_financial_information(p)
			continue(p)
			fill_out_contact_information(p)
			continue(p)
			choose_individual_application(p)
			find p.dialog_frame, wait: Sleep_lengths[:medium]
			within_frame(find(p.dialog_frame)) do
				find(p.electronic_consent).click
			end
			find(p.dialog_frame)
			within_frame(find(p.dialog_frame)) do
				find(p.button_continue).click
			end
			find(p.dialog_frame)
			within_frame(find(p.dialog_frame)) do
				find(p.submit_application).click
			end
			find(p.title, text: /^Application Status$/, wait: Sleep_lengths[:long])
			expect(find(p.title, text: /^Application Status$/)).to be
			sleep_short
		end
	end
end
