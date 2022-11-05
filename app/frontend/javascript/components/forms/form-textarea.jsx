import PropTypes from 'prop-types';
import React from 'react';

class FormTextarea extends React.Component {
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
      textareaValue: props.initialValue || ''
    }
  }

  afterChange() {
    const { onChange } = this.props;
    const { textareaValue } = this.state;

    if (onChange) onChange(textareaValue);
  }

  onChange(e) {
    this.setState({
      textareaValue: e.currentTarget.value
    }, this.afterChange);
  }

  render() {
    const { field, namespace } = this.props;

    return (
      <textarea
        className='input-highlight-on-focus'
        id={`${namespace}_${field}`}
        name={`${namespace}[${field}]`}
        onChange={this.onChange}
        type='input'
        value={this.state.textareaValue}
      />
    );
  }
}

export default FormTextarea;
