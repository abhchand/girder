import DatePicker from 'react-datepicker';
import { idFromName } from './helpers';
import PropTypes from 'prop-types';
import React from 'react';

class FormDatePicker extends React.Component {
  static propTypes = {
    // Initial value *must* be a Date object in local browser time.
    initialValue: PropTypes.instanceOf(Date),
    /*
     * The Rails-style microformat describing the attribute and resource
     * e.g. `creator[widget_attributes][0][name]`
     * See: https://wonderfullyflawed.wordpress.com/2009/02/17/rails-forms-microformat/
     */
    name: PropTypes.string.isRequired,
    // A handler that will be called when the input value changes
    onChange: PropTypes.func
  };

  constructor(props) {
    super(props);

    this.afterChange = this.afterChange.bind(this);
    this.onChange = this.onChange.bind(this);

    this.state = {
      inputValue: props.initialValue
    };
  }

  afterChange() {
    const { onChange } = this.props;
    const { inputValue } = this.state;

    if (onChange) onChange(inputValue);
  }

  onChange(date) {
    this.setState({ inputValue: date }, this.afterChange);
  }

  render() {
    const { name } = this.props;
    const { inputValue } = this.state;

    return (
      <DatePicker
        id={idFromName(name)}
        name={name}
        dateFormat='yyyy-MM-dd'
        onChange={this.onChange}
        selected={inputValue}
      />
    );
  }
}

export default FormDatePicker;
