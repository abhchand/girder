module FeatureHelpers
  def search_filter_table_for(str)
    page.find('.filter-table__search-input').base.send_keys(str)
    wait_for_async_process('filter-table-fetch-items', delay: 0.5)
  end

  def expect_filter_table_total_count_to_be(count)
    # Luckily `to_i` turns a string like "6 users" to `6`
    # This isn't great but it works for basic testing!
    actual = page.find('.filter-table__total-count').text.to_i
    expect(actual).to eq(count)
  end

  def expect_filter_table_records_to_be(records)
    # First wait for the table to update
    wait_for { page.all('.filter-table__table tbody tr').count == records.size }

    actual = page.all('.filter-table__table tbody tr').map { |r| r['data-id'] }

    if records[0].instance_of?(::UserInvitation)
      expect(actual).to eq(records.map(&:id).map(&:to_s))
    else
      expect(actual).to eq(records.map(&:synthetic_id))
    end
  end

  def click_filter_table_pagination_next
    page.find('.filter-table__pagination-nav-link--next').click
    wait_for_async_process('filter-table-fetch-items', delay: 0.2)
  end

  def click_filter_table_pagination_prev
    page.find('.filter-table__pagination-nav-link--prev').click
    wait_for_async_process('filter-table-fetch-items', delay: 0.2)
  end

  def click_filter_table_activate_for(user)
    page.find('FILL-ME-IN').click
  end

  def click_filter_table_deactivate_for(user)
    page.find('FILL-ME-IN').click
  end

  def click_filter_table_delete_for(user_invitation)
    page.find('FILL-ME-IN').click
  end

  def click_filter_table_edit_user_roles_for(user)
    page.find('FILL-ME-IN').click
  end
end
