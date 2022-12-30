import { idFromName } from './helpers';
import PropTypes from 'prop-types';
import React from 'react';

class FormTextarea extends React.Component {
  static propTypes = {
    initialValue: PropTypes.string,
    /*
     * The Rails-style microformat describing the attribute and resource
     * e.g. `creator[widget_attributes][0][name]`
     * See: https://wonderfullyflawed.wordpress.com/2009/02/17/rails-forms-microformat/
     */
    name: PropTypes.string.isRequired,
    onChange: PropTypes.func
  };

  constructor(props) {
    super(props);

    this.afterChange = this.afterChange.bind(this);
    this.onChange = this.onChange.bind(this);

    this.state = {
      textareaValue: props.initialValue || ''
    };
  }

  afterChange() {
    const { onChange } = this.props;
    const { textareaValue } = this.state;

    if (onChange) onChange(textareaValue);
  }

  onChange(e) {
    this.setState(
      {
        textareaValue: e.currentTarget.value
      },
      this.afterChange
    );
  }

  render() {
    const { name } = this.props;

    return (
      <textarea
        className='input-highlight-on-focus'
        id={idFromName(name)}
        name={name}
        onChange={this.onChange}
        type='input'
        value={this.state.textareaValue}
      />
    );
  }
}

export default FormTextarea;
