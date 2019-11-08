import { keyCodes, parseKeyCode } from 'utils/keys';

$(document).ready(() => {
  // eslint-disable-next-line padded-blocks
  function closeModal() {

    /*
     * `data-id` is sometimes set on the modal when it opens
     * Remove it if it exists
     */
    $('.modal').removeAttr('data-id');

    // Close the modal
    $('.modal').removeClass('active');
  }

  $('.modal-content__button--cancel').click(() => {
    closeModal();
  });

  $('.modal-content__button--close').click(() => {
    closeModal();
  });

  $('body').on('keyup', (e) => {
    // Escape Key
    if (parseKeyCode(e) === keyCodes.ENTER && $('.modal').is(':visible')) { closeModal(); }
  });
});
