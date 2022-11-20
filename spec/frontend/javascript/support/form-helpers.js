
/*
 * Input Fields
 */

const getFormInputValue = (wrapper, css) => {
  return wrapper.find(css).at(0).prop('value');
}

const setFormInputValue = (wrapper, css, text) => {
  const input = wrapper.find(css).at(0);

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
  const selected = el.find('option').forEach((o) => {
    if (o.instance().selected) id = o.prop('value');
  });

  return id;
}

const setFormSelectId = (wrapper, css, id) => {
  const el = wrapper.find(css).at(0);

  el.find('option').forEach((o) => {
    if (o.prop('value') == id) o.instance().selected = true;
  });
}

export {
  getFormInputValue,
  setFormInputValue,
  getFormSelectId,
  setFormSelectId
}
