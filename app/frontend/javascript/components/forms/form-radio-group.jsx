import { idFromName } from './helpers';
import PropTypes from 'prop-types';
import React from 'react';

class FormRadioGroup extends React.Component {
  static propTypes = {
    initialSelectedValue: PropTypes.string,
    /*
     * The Rails-style microformat describing the attribute and resource
     * e.g. `creator[widget_attributes][0][name]`
     * See: https://wonderfullyflawed.wordpress.com/2009/02/17/rails-forms-microformat/
     */
    name: PropTypes.string.isRequired,
    onChange: PropTypes.func,
    /*
     * Receives a `value` as an argument and renders any additional content for
     * that radio button
     */
    renderDisplayContentForRadioValue: PropTypes.func,
    /*
     * Expects an array of values for radio buttons.
     * A placeholder/null value can be specified with a `null` `id`.
     *
     *    [
     *      'days'
     *      'months'
     *      'years'
     *    ]
     */
    values: PropTypes.array.isRequired
  };

  constructor(props) {
    super(props);

    this.afterChange = this.afterChange.bind(this);
    this.onChange = this.onChange.bind(this);

    this.state = {
      selectedValue: props.initialSelectedValue
    }
  }

  afterChange() {
    const { onChange } = this.props;
    const { selectedValue } = this.state;

    if (onChange) onChange(selectedValue);
  }

  onChange(e) {
    this.setState({
      selectedValue: e.currentTarget.value
    }, this.afterChange);
  }

  render() {
    const { renderDisplayContentForRadioValue, name, values } = this.props;
    const { selectedValue } = this.state;
    const { onChange } = this;

    const id = idFromName(name);

    return (
      <div className={`${id}_radio_group`}>
        {
          values.map((value) => {
            /*
             * The `id` for a radio button group must be unique, so we follow
             * the Rails-style microformat and append the value to the `id`
             */
            const radioId = `${id}_${value}`;

            return (
              <label key={radioId} htmlFor={radioId}>
                {renderDisplayContentForRadioValue(value)}
                <input
                  checked={selectedValue === value}
                  id={radioId}
                  name={name}
                  onChange={onChange}
                  tabIndex="0"
                  type='radio'
                  value={value} />
              </label>
            );
          })
        }
      </div>
    );
  }
}

export default FormRadioGroup;
