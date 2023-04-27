import { keyCodes, parseKeyCode } from 'src/utils/keys';
import { openModal } from 'src/components/modal/open';
import ProductFeedbackForm from 'src/components/product_feedback_form';
import React from 'react';

// eslint-disable-next-line padded-blocks
$(document).ready(() => {
  function findDesktopDropdownEl() {
    return document.querySelector('.desktop-header-account-dropdown');
  }

  function closeDesktopDropdown() {
    const dropdown = findDesktopDropdownEl();

    dropdown.classList.remove('active');
    dropdown.classList.add('inactive');
  }

  function openDesktopDropdown() {
    const dropdown = findDesktopDropdownEl();

    dropdown.classList.remove('inactive');
    dropdown.classList.add('active');
  }

  function toggleDesktopDropdown() {
    const dropdown = findDesktopDropdownEl();

    if (dropdown.classList.contains('active')) {
      closeDesktopDropdown();
    } else {
      openDesktopDropdown();
    }
  }

  /*
   *
   * Toggle Dropdown by clicking on Profile pic
   *
   */
  $('.desktop-header').on('click', '.desktop-header__profile-pic', (e) => {
    e.preventDefault();
    toggleDesktopDropdown();
  });

  /*
   *
   * Close Dropdown when clicking outside dropdown
   *
   */
  $('body').on('click', '.responsive-navigation-content', (e) => {
    const dropdown = findDesktopDropdownEl();
    const clickedInsideDropdown =
      dropdown !== e.target && dropdown.contains(e.target);

    if (!clickedInsideDropdown) {
      closeDesktopDropdown();
    }
  });

  /*
   * Close Dropdown when pressing ESCAPE
   */
  $(document).ready(() => {
    $('body').on('keyup', (e) => {
      const dropdown = findDesktopDropdownEl();
      const isDropdownOpen = dropdown.classList.contains('active');

      if (parseKeyCode(e) === keyCodes.ESCAPE && isDropdownOpen) {
        closeDesktopDropdown();
      }
    });
  });

  /*
   *
   * Product Feedback Link
   *
   */
  $('.desktop-header-account-dropdown__link-element--product-feedback').on(
    'click',
    'a',
    (e) => {
      e.preventDefault();
      closeDesktopDropdown();
      openModal(<ProductFeedbackForm />);
    }
  );
});
