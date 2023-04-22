import './form-input.scss';

import { idFromName } from './helpers';
import PropTypes from 'prop-types';
import React from 'react';

/*
 * This `<input>` can be controlled either internally or externally
 *
 *   * Externally:
 *       Specifying the `value` prop will allow a parent to fully manage the
 *       state and value of this component via props
 *
 *   * Internally:
 *       Specifying the `initialValue` prop will allow a parent to specify the
 *       value once, and this component will manage its own state.
 *
 * If both `value` and `initialValue` are specified, `value` takes precedence.
 */
class FormInput extends React.Component {
  static propTypes = {
    initialValue: PropTypes.string,
    inputType: PropTypes.string,
    isError: PropTypes.bool,
    /*
     * The Rails-style microformat describing the attribute and resource
     * e.g. `creator[widget_attributes][0][name]`
     * See: https://wonderfullyflawed.wordpress.com/2009/02/17/rails-forms-microformat/
     */
    name: PropTypes.string.isRequired,
    onChange: PropTypes.func,
    placeholderText: PropTypes.string,
    value: PropTypes.string
  };

  static defaultProps = {
    inputType: 'input',
    isError: false
  };

  constructor(props) {
    super(props);

    this.broadcastValue = this.broadcastValue.bind(this);
    this.isExternallyControlled = this.isExternallyControlled.bind(this);
    this.onChange = this.onChange.bind(this);

    this.state = {
      inputValue: props.initialValue
    };
  }

  broadcastValue(newValue, forceInvokeHandler) {
    const { onChange } = this.props;

    /*
     * In the case of an externally controlled component, we'll want to set
     * `forceInvokeHandler` as `true` so that we always call `onChange` (if not,
     * how else will a parent "subscribe" to updates?).
     */
    if (forceInvokeHandler || onChange) onChange(newValue);
  }

  isExternallyControlled() {
    const { value } = this.props;

    return typeof value === 'string';
  }

  onChange(e) {
    const newValue = e.currentTarget.value;

    /*
     * If this component is externally controlled, skip updating state and
     * jump to broadcasting
     */
    if (this.isExternallyControlled()) {
      this.broadcastValue(newValue, true);
      return;
    }

    this.setState(
      { inputValue: newValue },
      this.broadcastValue(newValue, false)
    );
  }

  render() {
    const { inputType, isError, name, placeholderText, value } = this.props;
    const { inputValue } = this.state;

    const errorClass = isError ? 'input--error' : 'input-highlight-on-focus';

    return (
      <input
        className={errorClass}
        onChange={this.onChange}
        placeholder={placeholderText}
        value={this.isExternallyControlled() ? value : inputValue}
        type={inputType}
        name={name}
        id={idFromName(name)}
      />
    );
  }
}

export default FormInput;
