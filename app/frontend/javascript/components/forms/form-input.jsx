import { idFromName } from './helpers';
import PropTypes from 'prop-types';
import React from 'react';

class FormInput extends React.Component {
  static propTypes = {
    initialValue: PropTypes.string,
    isError: PropTypes.bool,
    /*
     * The Rails-style microformat describing the attribute and resource
     * e.g. `creator[widget_attributes][0][name]`
     * See: https://wonderfullyflawed.wordpress.com/2009/02/17/rails-forms-microformat/
     */
    name: PropTypes.string.isRequired,
    onChange: PropTypes.func,
    placeholderText: PropTypes.string
  };

  static defaultProps = {
    initialValue: '',
    isError: false
  };

  constructor(props) {
    super(props);

    this.afterChange = this.afterChange.bind(this);
    this.onChange = this.onChange.bind(this);

    this.state = {
      inputValue: props.initialValue || ''
    }
  }

  afterChange() {
    const { onChange } = this.props;
    const { inputValue } = this.state;

    if (onChange) onChange(inputValue);
  }

  onChange(e) {
    this.setState({
      inputValue: e.currentTarget.value
    }, this.afterChange);
  }

  render() {
    const { isError, name, placeholderText } = this.props;

    const errorClass = isError ? 'input--error' : 'input-highlight-on-focus';

    return (
      <input
        className={errorClass}
        onChange={this.onChange}
        placeholder={placeholderText}
        value={this.state.inputValue}
        type='input'
        name={name}
        id={idFromName(name)}
      />
    );
  }
}

export default FormInput;
