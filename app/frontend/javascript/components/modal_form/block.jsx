/* eslint-disable jsx-a11y/label-has-for */
import { idFromName } from 'javascript/components/forms/helpers';
import ModalError from 'javascript/components/modal/error';
import PropTypes from 'prop-types';
import React from 'react';

const Block = (props) => {
  /*
   * Allow specifying a Rails-style microformat "name", since `labelFor` will
   * typically target a form element `id` that will be specified using the
   * same microformat.
   */
  const labelFor = idFromName(props.labelFor);

  return (
    <div className='modal-form__block' data-for={labelFor}>
      <label htmlFor={labelFor}>{props.label}</label>

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
