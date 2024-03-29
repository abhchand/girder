function parseJsonApiError(error) {
  // If we're dealing with a standard JS TypeError
  if (!Object.prototype.hasOwnProperty.call(error, 'response')) {
    return error.message;
  }

  const errorObj = error.response.data.errors[0] || {};
  return errorObj.description || errorObj.title || I18n.t('generic_error');
}

export { parseJsonApiError };
