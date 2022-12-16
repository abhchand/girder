import ModalError from 'javascript/components/modal/error';
import PropTypes from 'prop-types';
import React from 'react';

const Block = (props) => {

  return (
    <div className='modal-form__block' data-for={props.labelFor}>
      <label htmlFor={props.labelFor}>{props.label}</label>

      <div className='modal-form__block-element-container'>
        <div className='modal-form__block-element'>
          {props.children}
        </div>

        {props.errorText && <ModalError text={props.errorText} />}
      </div>
    </div>
  );
};

Block.propTypes = {
  children: PropTypes.node,
  errorText: PropTypes.string,
  label: PropTypes.string.isRequired,
  labelFor: PropTypes.string.isRequired
};

export default Block;
