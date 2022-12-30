/* eslint no-invalid-this: 0 */

/*
 * Helps manage `state` for field errors on forms
 *
 * All functions here need to be bound to `this` to have access to `setState``
 */

import { toSnakeCase } from 'javascript/utils/case';

function clearFieldError(field) {
  this.setState((prevState) => {
    // Copy the object
    const fieldErrors = { ...prevState.fieldErrors };

    // Dynamically cleary the field error
    fieldErrors[field] = null;

    return { fieldErrors };
  });
}

function formHasError() {
  const { fieldErrors } = this.state;

  for (const field in fieldErrors) {
    if (fieldErrors[field]) {
      return true;
    }
  }

  return false;
}

function setFieldError(field, key) {
  this.setState((prevState) => {
    // Copy the object
    const fieldErrors = { ...prevState.fieldErrors };

    // Dynamically set the field error
    fieldErrors[field] = I18n.t(
      `activerecord.errors.models.appliance.attributes.${toSnakeCase(
        field
      )}.${key}`
    );

    return { fieldErrors };
  });
}

export { clearFieldError, formHasError, setFieldError };
