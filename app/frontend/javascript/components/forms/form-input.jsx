import PropTypes from 'prop-types';
import React from 'react';

class FormInput extends React.Component {
  static propTypes = {
    field: PropTypes.string.isRequired,
    initialValue: PropTypes.string,
    namespace: PropTypes.string.isRequired,
    onChange: PropTypes.func
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
    const { field, namespace } = this.props;

    return (
      <input
        className='input-highlight-on-focus'
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
