import { idFromName } from './helpers';
import PropTypes from 'prop-types';
import React from 'react';

class FormSelect extends React.Component {
  static propTypes = {
    initialSelectedId: PropTypes.string,
    /*
     * The Rails-style microformat describing the attribute and resource
     * e.g. `creator[widget_attributes][0][name]`
     * See: https://wonderfullyflawed.wordpress.com/2009/02/17/rails-forms-microformat/
     */
    name: PropTypes.string.isRequired,
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
      const id = selectId === '' ? null : selectId;

      return o.id === id;
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
    const { name, options } = this.props;
    const id = idFromName(name);

    return (
      <select
        id={id}
        name={name}
        onBlur={this.onChange}
        defaultValue={this.state.selectId}>
        {
          options.map((option, _i) => {
            // Placeholder value should have `id` of blank string
            const optionId = option.id || '';

            return (
              <option key={`${id}_${optionId}`} value={optionId}>
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
