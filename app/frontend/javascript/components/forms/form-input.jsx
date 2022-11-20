import PropTypes from 'prop-types';
import React from 'react';

class FormInput extends React.Component {
  static propTypes = {
    // The field name e.g. `model_name[field_name]`
    field: PropTypes.string.isRequired,
    initialValue: PropTypes.string,
    isError: PropTypes.bool,
    // The model name e.g. `model_name[field_name]`
    namespace: PropTypes.string.isRequired,
    // A handler that will be called when the input value changes
    onChange: PropTypes.func
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
    const { field, namespace, onChange } = this.props;
    const { inputValue } = this.state;

    if (onChange) onChange(inputValue, namespace, field);
  }

  onChange(e) {
    this.setState({
      inputValue: e.currentTarget.value
    }, this.afterChange);
  }

  render() {
    const { field, isError, namespace } = this.props;

    const errorClass = isError ? 'input--error' : 'input-highlight-on-focus';

    return (
      <input
        className={errorClass}
        onChange={this.onChange}
        value={this.state.inputValue}
        type='input'
        name={`${namespace}[${field}]`}
        id={`${namespace}_${field}`}
      />
    );
  }
}

export default FormInput;
