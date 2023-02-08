import { keyCodes, parseKeyCode } from 'src/utils/keys';
import { closeModal } from 'src/components/modal/close';

$(document).ready(() => {
  $('body').on('keyup', (e) => {
    if (parseKeyCode(e) === keyCodes.ESCAPE && $('.modal').is(':visible')) {
      closeModal();
    }
  });
});
