import PropTypes from 'prop-types';
import React from 'react';

class FormSelect extends React.Component {
  static propTypes = {
    field: PropTypes.string.isRequired,
    initialSelectedId: PropTypes.string,
    namespace: PropTypes.string.isRequired,
    onChange: PropTypes.func,
    /*
     * Expects an array of objects that define the dropdown options.
     * A placeholder/null value can be specified with a `null` `id`.
     *
     *    [
     *      { id: null, value: '--Select One--' },
     *      { id: '1',  value: 'Days' },
     *      { id: '2',  value: 'Months' },
     *      { id: '3',  value: 'Years' },
     *    ]
     */
    options: PropTypes.array.isRequired
  };

  constructor(props) {
    super(props);

    this.afterChange = this.afterChange.bind(this);
    this.onChange = this.onChange.bind(this);

    this.state = {
      selectId: props.initialSelectedId || ''
    }
  }

  afterChange() {
    const { onChange, options } = this.props;
    const { selectId } = this.state;

    const selectValue = options.find((o) => {
      /*
       * Blank options have an `id` of `null`, but the selected value gets parsed
       * as blank string
       */
      const id = selectId == '' ? null : selectId;

      return o.id == id;
    }).value;

    // As a convenience, pass both the id and value of the selected option
    if (onChange) onChange(selectId, selectValue);
  }

  onChange(e) {
    this.setState({
      selectId: e.currentTarget.value
    }, this.afterChange);
  }

  render() {
    const { field, namespace, options } = this.props;

    return (
      <select
        id={`${namespace}_${field}`}
        name={`${namespace}[${field}]`}
        onChange={this.onChange}
        defaultValue={this.state.selectId}>
        {
          options.map((option, _i) => {
            // Placeholder value should have `id` of blank string
            const id = option.id || '';

            return (
              <option key={`${namespace}-${field}-${id}`} value={id}>
                {option.value}
              </option>
            );
          })
        }
      </select>
    );
  }
}

export default FormSelect;
