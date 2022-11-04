import PropTypes from 'prop-types';
import React from 'react';

const Block = (props) => {
  return (
    <div className='modal-form__block'>
      <label htmlFor={props.labelFor}>{props.label}</label>

      <div className='modal-form__block-element'>
        {props.children}
      </div>
    </div>
  );
};

Block.propTypes = {
  children: PropTypes.node,
  label: PropTypes.string.isRequired,
  labelFor: PropTypes.string.isRequired
};

export default Block;
