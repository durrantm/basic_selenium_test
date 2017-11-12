require 'spec_helper'

if PRODUCTION # Not using for OLA development

	describe "visit home page" do
		it "can visit the home page" do
			visit ""
			expect(page.title).to match /[Ll]oan/
		end
	end

	describe "student loan products" do
		it "has a link on the home page" do
			visit ""
			expect(page.find("a", text: /Student loan products/)).to be
		end
		it "has a summary page on student loans" do
			visit "/student-loans/"
			expect(page.find('h1').text).to match /^Student loans.*for all types of students/
		end
		describe "Student loan products" do
			describe "Undergraduate" do
				it "has a page on undergraduate student loans" do
					visit "/student-loans/smart-option-student-loan/"
					expect(page.find('h1').text).to match /^Smart Option Student Loan/
				end
				it "has a form for undergraduate student loans" do
					visit "/student-loans/smart-option-student-loan/"
					click_link('Apply for this loan')
					expect(page.find('body.slm-body')).to be
				end
			end
			it "has a page on career training smart option student loans" do
				visit "/student-loans/career-training-smart-option-student-loan/"
				expect(page.find('h1').text).to match /^Career Training Smart Option Student Loan/
			end
			it "has a page on parent loans" do
				visit "/student-loans/parent-loan/"
				expect(page.find('h1').text).to match /^Sallie Mae Parent Loan/
			end
			it "has a page on k-12 Family Education loans" do
				visit "/student-loans/private-school-loan/"
				expect(page.find('h1').text).to match /^K.12 Family Education Loan/
			end
			it "has a page on graduate student loans" do
				visit "/student-loans/graduate-smart-option-student-loan/"
				expect(page.find('h1').text).to match /^Smart Option Student Loan. for Graduate Students/
			end
			it "has a page on MBA loans" do
				visit "/student-loans/mba-loan/"
				expect(page.find('h1').text).to match /^Sallie Mae MBA Loan/
			end
			it "has a page on Health Professaionals graduate loans" do
				visit "/student-loans/health-professions-graduate-loan/"
				expect(page.find('h1').text).to match /^Sallie Mae Health Professions Graduate Loan/
			end
			it "has a page on Dental and Medical school loans" do
				visit "/student-loans/dental-and-medical-school-loan/"
				expect(page.find('h1').text).to match /^Sallie Mae Dental and Medical School Loan/
			end
			it "has a page on Dental Residency and relocation loans" do
				visit "/student-loans/dental-residency-loan/"
				expect(page.find('h1').text).to match /^Dental Residency and Relocation Loan/
			end
			it "has a page on Medical Residency and relocation loans" do
				visit "/student-loans/medical-residency-loan/"
				expect(page.find('h1').text).to match /^Medical Residency and Relocation Loan/
			end
			it "has a page on Bar Study loans" do
				visit "/student-loans/bar-study-loan/"
				expect(page.find('h1').text).to match /^Bar Study Loan/
			end
		end
	end
end
