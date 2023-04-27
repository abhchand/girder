import { openModal } from 'src/components/modal/open';
import ProductFeedbackForm from 'src/components/product_feedback_form';
import React from 'react';

// eslint-disable-next-line padded-blocks
$(document).ready(() => {
  function findMobileDropdownEl() {
    return document.querySelector('.mobile-header-dropdown');
  }

  function findMobileOverlayEl() {
    return document.querySelector('.mobile-header-dropdown__overlay');
  }

  function closeMobileDropdown() {
    const dropdown = findMobileDropdownEl();
    const overlay = findMobileOverlayEl();

    dropdown.classList.remove('active');
    dropdown.classList.add('inactive');
    overlay.classList.remove('active');
    overlay.classList.add('inactive');
  }

  function openMobileDropdown() {
    const dropdown = findMobileDropdownEl();
    const overlay = findMobileOverlayEl();

    dropdown.classList.remove('inactive');
    dropdown.classList.add('active');
    overlay.classList.remove('inactive');
    overlay.classList.add('active');
  }

  function toggleMobileDropdown() {
    const dropdown = findMobileDropdownEl();

    if (dropdown.classList.contains('active')) {
      closeMobileDropdown();
    } else {
      openMobileDropdown();
    }
  }

  /*
   *
   * Toggle dropdown when clicking header icon
   *
   */
  $('.mobile-header').on('click', '.mobile-header__menu-icon', (e) => {
    e.preventDefault();
    toggleMobileDropdown();
  });

  /*
   *
   * Close dropdown when clicking close button
   *
   */
  $('.mobile-header-dropdown').on(
    'click',
    '.mobile-header-dropdown__close',
    (e) => {
      e.preventDefault();
      closeMobileDropdown();
    }
  );

  /*
   *
   * Close dropdown when clicking overlay
   *
   */
  $('body').on('click', '.mobile-header-dropdown__overlay', (e) => {
    e.preventDefault();
    closeMobileDropdown();
  });

  /*
   *
   * Product Feedback Link
   *
   */
  $('.mobile-header-dropdown__link-element--product-feedback').on(
    'click',
    'a',
    (e) => {
      e.preventDefault();
      closeMobileDropdown();
      openModal(<ProductFeedbackForm />);
    }
  );
});
