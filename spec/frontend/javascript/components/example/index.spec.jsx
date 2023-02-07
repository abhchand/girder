import Example from 'javascript/components/example';
import { expect } from 'chai';
import { mount } from 'enzyme';
import React from 'react';

let photos, wrapper;

beforeEach(() => {
  photos = [
    { id: 1, takenAt: 'Jan 01, 2023' },
    { id: 2, takenAt: 'Dec 31, 2023' }
  ];
});

afterEach(() => {
  wrapper.unmount();
});

describe('<Example />', () => {
  it('renders the list items with the correct `id`', () => {
    renderComponent();

    wrapper.find('.page-content li').forEach((node, idx) => {
      expect(node.props()['data-id']).to.eq(photos[idx].id);
    });
  });
});

const renderComponent = (additionalProps = {}) => {
  const fixedProps = {
    photos: photos
  };

  const props = { ...fixedProps, ...additionalProps };

  wrapper = mount(<Example {...props} />);
};
