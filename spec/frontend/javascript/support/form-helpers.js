
/*
 * Input Fields
 */

const getFormInputValue = (wrapper, css) => {
  /*
   * Typically `find()` should be sufficient (especially for an `id` which is
   * supposed to be unique). But some libraries nest elements with the same
   * attributes, so we need to filter by element type too
   */
  return(
    wrapper.find(css).filterWhere((n) => n.type() === 'input').at(0).prop('value')
  );
}

const setFormInputValue = (wrapper, css, text) => {
  const input = wrapper.find(css).filterWhere((n) => n.type() === 'input').at(0);

  // Both are required, to set the value and trigger the handler
  input.getDOMNode().value = text;
  input.simulate('change', { currentTarget: { value: text } });
}

/*
 * Select Dropdowns
 */

const getFormSelectId = (wrapper, css) => {
  const el = wrapper.find(css).at(0);

  let id = null;
  el.find('option').forEach((o) => {
    if (o.instance().selected) id = o.prop('value');
  });

  return id;
}

const setFormSelectId = (wrapper, css, id) => {
  const el = wrapper.find(css).at(0);

  el.find('option').forEach((o) => {
    if (o.prop('value') === id) o.instance().selected = true;
  });
}

/*
 * Textarea Fields
 */

const getFormTextareaValue = (wrapper, css) => {
  /*
   * Typically `find()` should be sufficient (especially for an `id` which is
   * supposed to be unique). But some libraries nest elements with the same
   * attributes, so we need to filter by element type too
   */
  return(
    wrapper.find(css).filterWhere((n) => n.type() === 'textarea').at(0).prop('value')
  );
}

const setFormTextareaValue = (wrapper, css, text) => {
  const textarea = wrapper.find(css).filterWhere((n) => n.type() === 'textarea').at(0);

  // Both are required, to set the value and trigger the handler
  textarea.getDOMNode().value = text;
  textarea.simulate('change', { currentTarget: { value: text } });
}

export {
  getFormInputValue,
  setFormInputValue,
  getFormSelectId,
  setFormSelectId,
  getFormTextareaValue,
  setFormTextareaValue
}
