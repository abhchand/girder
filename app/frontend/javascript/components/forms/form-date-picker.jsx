import DatePicker from 'react-datepicker';
import PropTypes from 'prop-types';
import React from 'react';

class FormDatePicker extends React.Component {
  static propTypes = {
    // The field name e.g. `model_name[field_name]`
    field: PropTypes.string.isRequired,
    // Initial value *must* be a Date object in local browser time.
    initialValue: PropTypes.instanceOf(Date),
    // The model name e.g. `model_name[field_name]`
    namespace: PropTypes.string.isRequired,
    // A handler that will be called when the input value changes
    onChange: PropTypes.func
  };

  constructor(props) {
    super(props);

    this.afterChange = this.afterChange.bind(this);
    this.onChange = this.onChange.bind(this);

    this.state = {
      inputValue: props.initialValue
    }
  }

  afterChange() {
    const { field, namespace, onChange } = this.props;
    const { inputValue } = this.state;

    if (onChange) onChange(inputValue, namespace, field);
  }

  onChange(date) {
    this.setState({ inputValue: date }, this.afterChange);
  }

  render() {
    const { field, namespace } = this.props;

    return (
      <DatePicker
        id={`${namespace}_${field}`}
        name={`${namespace}[${field}]`}
        dateFormat="yyyy-MM-dd"
        onChange={this.onChange}
        selected={this.state.inputValue} />
    );
  }
}

export default FormDatePicker;
