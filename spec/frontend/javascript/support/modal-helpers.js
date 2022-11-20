import { expect } from 'chai';

const closeModal = async (wrapper, appliance) => {
  const closeBtn = wrapper.find('.modal-content__button--close');
  await closeBtn.simulate('click');
}

const openModal = async (wrapper, appliance) => {
  const row = wrapper.find(
    `.filter-table__table tbody tr[data-id='${appliance.id}']`
  );

  const submitBtn = row.find('.actions button');
  await submitBtn.simulate('click');
}

const expectModalIsClosed = (wrapper) => {
  expect(wrapper.exists('.modal')).to.eql(false);
}

const expectModalIsOpen = (wrapper) => {
  expect(wrapper.exists('.modal')).to.eql(true);
}

const modalErrorForBlock = (wrapper, css) => {
  const error_css = `.modal-form__block[data-for='${css}'] .modal--error`;
  return wrapper.find(error_css).at(0).text;
};

const modalSubmitBtn = (wrapper) => {
  return wrapper.find('.modal-content__button--submit');
}

export {
  closeModal,
  openModal,
  expectModalIsClosed,
  expectModalIsOpen,
  modalErrorForBlock,
  modalSubmitBtn
}
