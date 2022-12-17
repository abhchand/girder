module FeatureHelpers
  def select_date(name, date:)
    # Calculate the first of the month, capturing the "day" value
    date_fom = date.split('-')
    day = date_fom[2]
    date_fom[2] = '01'
    date_fom = date_fom.join('-')

    # The easiest way to select a date is to cheat and fill in the input field
    # directly first and then fill in the day. We fill in the 1st of the month,
    # and then select the actual desired day.
    #
    # This has 2 advantages:
    #
    #   1. It takes us directly to the month, preventing us from having to
    #      calculate the offset from the current date and navigate by clicking
    #      next/prev arrows
    #
    #   2. Clicking the date in the datepicker actually closes the datepicker,
    #      so it doesn't stay open for the remainder of the test run
    fill_in(name, with: date_fom)

    # A given calendar view may display a day more than once. `find` selects
    # the first one.
    find(".react-datepicker__day--#{day.to_s.rjust(3, '0')}").click
  end
end
