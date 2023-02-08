/* eslint-disable jsx-a11y/label-has-for */
import { idFromName } from 'src/components/forms/helpers';
import ModalError from 'src/components/modal/error';
import PropTypes from 'prop-types';
import React from 'react';

const Block = (props) => {
  /*
   * Allow specifying a Rails-style microformat "name", since `labelFor` will
   * typically target a form element `id` that will be specified using the
   * same microformat.
   */
  const labelFor = idFromName(props.labelFor);

  /*
   * Some form elements (like radio buttons) utilize individual `<label>` tags
   * on each element. In those cases, this component allows passing
   * `isLabelEnabled={false}`, which will effectively disable this top-level
   * label.
   *
   * It still renders as a `<label>` element for styling, but without the
   * `htmlFor` attribute which gives it any meaning.
   */
  const labelAttrs = {};
  if (props.isLabelEnabled) {
    labelAttrs.htmlFor = labelFor;
  }

  return (
    <div className='modal-form__block' data-for={labelFor}>
      {/* eslint-disable-next-line react/jsx-props-no-spreading */}
      <label {...labelAttrs}>{props.label}</label>

      <div className='modal-form__block-element-container'>
        <div className='modal-form__block-element'>{props.children}</div>

        {props.errorText && <ModalError text={props.errorText} />}
      </div>
    </div>
  );
};

Block.propTypes = {
  children: PropTypes.node,
  errorText: PropTypes.string,
  isLabelEnabled: PropTypes.bool,
  label: PropTypes.string.isRequired,
  labelFor: PropTypes.string.isRequired
};

Block.defaultProps = {
  isLabelEnabled: true
};

export default Block;
