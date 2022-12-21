import { expect } from 'chai';

const closeModal = async (wrapper) => {
  const closeBtn = wrapper.find('.modal-content__button--close');
  await closeBtn.simulate('click');
}

const expectModalIsClosed = (wrapper) => {
  expect(wrapper.exists('.modal')).to.eql(false);
}

const expectModalIsOpen = (wrapper) => {
  expect(wrapper.exists('.modal')).to.eql(true);
}

const modalErrorForBlock = (wrapper, css) => {
  const errorCss = `.modal-form__block[data-for='${css}'] .modal--error`;
  return wrapper.exists(errorCss) ? wrapper.find(errorCss).at(0).text() : null;
};

const modalSubmitBtn = (wrapper) => {
  return wrapper.find('.modal-content__button--submit');
}

export {
  closeModal,
  expectModalIsClosed,
  expectModalIsOpen,
  modalErrorForBlock,
  modalSubmitBtn
}
