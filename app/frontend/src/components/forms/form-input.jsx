import './form-input.scss';

import { idFromName } from './helpers';
import PropTypes from 'prop-types';
import React from 'react';

/*
 * This `<input>` can be controlled either internally or externally.
 *
 *   * Externally:
 *       The `onChange` prop is specified. In this case the `value` prop from
 *       the parent will be used to continusouly set the current value.
 *
 *   * Internally:
 *       The `onChange` prop is not specified. In this case the `value` prop
 *       from the parent is just used as an initial value.
 */
class FormInput extends React.Component {
  static propTypes = {
    // For an input type of `file`, see `<FormInputFile> specifically
    inputType: PropTypes.oneOf(['input', 'hidden', 'radio', 'select']),
    isError: PropTypes.bool,
    /*
     * The Rails-style microformat describing the attribute and resource
     * e.g. `creator[widget_attributes][0][name]`
     * See: https://wonderfullyflawed.wordpress.com/2009/02/17/rails-forms-microformat/
     */
    name: PropTypes.string.isRequired,
    onChange: PropTypes.func,
    placeholderText: PropTypes.string,
    value: PropTypes.oneOfType([PropTypes.string, PropTypes.object])
  };

  static defaultProps = {
    inputType: 'input',
    isError: false
  };

  constructor(props) {
    super(props);

    this.isExternallyControlled = this.isExternallyControlled.bind(this);
    this.onChange = this.onChange.bind(this);

    /*
     * For internally controlled components, use the `value` to initialize the
     * internal state, once.
     */
    this.state = {
      internalValue: this.isExternallyControlled() ? null : props.value
    };
  }

  isExternallyControlled() {
    return typeof this.props.onChange === 'function';
  }

  onChange(e) {
    const input = e.currentTarget;

    if (this.isExternallyControlled()) {
      this.props.onChange(input.value);
      return;
    }

    this.setState({ internalValue: input.value });
  }

  render() {
    const { inputType, isError, name, placeholderText, value } = this.props;
    const { internalValue } = this.state;

    const errorClass = isError ? 'input--error' : 'input-highlight-on-focus';

    return (
      <input
        className={errorClass}
        onChange={this.onChange}
        placeholder={placeholderText}
        value={(this.isExternallyControlled() ? value : internalValue) || ''}
        type={inputType}
        name={name}
        id={idFromName(name)}
      />
    );
  }
}

export default FormInput;
