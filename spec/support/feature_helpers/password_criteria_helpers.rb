module FeatureHelpers
  def expect_password_criteria_dialog_to_be(criteria)
    criteria.each do |name, enabled|
      css = ".password-criteria .status--#{name}"
      if enabled
        expect(page).to have_selector("#{css}.valid")
      else
        expect(page).to_not have_selector("#{css}.valid")
      end
    end
  end
end
