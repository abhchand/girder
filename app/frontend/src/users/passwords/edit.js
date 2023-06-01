const MIN_PASSWORD_LEN = 6;

// If making changes here, also remember to update backend model
function checkPasswordCriteria(e) {
  const value = e.currentTarget.value || '';
  const prefix = '.passwords-edit__criteria';

  const elLength = document.querySelector(`${prefix} .status--length`),
    elLetter = document.querySelector(`${prefix} .status--letter`),
    elNumber = document.querySelector(`${prefix} .status--number`),
    elSpecial = document.querySelector(`${prefix} .status--special`);

  if (value.length >= MIN_PASSWORD_LEN) {
    elLength.classList.add('valid');
  } else {
    elLength.classList.remove('valid');
  }

  if (/[a-z]/iu.test(value)) {
    elLetter.classList.add('valid');
  } else {
    elLetter.classList.remove('valid');
  }

  if (/[0-9]/iu.test(value)) {
    elNumber.classList.add('valid');
  } else {
    elNumber.classList.remove('valid');
  }

  if (/[!#$%&]/iu.test(value)) {
    elSpecial.classList.add('valid');
  } else {
    elSpecial.classList.remove('valid');
  }
}

export { checkPasswordCriteria };
