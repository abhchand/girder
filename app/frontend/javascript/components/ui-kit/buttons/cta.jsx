import PropTypes from 'prop-types';
import React from 'react';

const CtaButton = (props) => {
  return (
    <input
      type="button"
      className={`cta ${props.additionalClasses.join(' ')}`}
      value={props.value}
      disabled={props.disabled}
      onClick={props.onClick}
    />
  );
};

CtaButton.propTypes = {
  additionalClasses: PropTypes.arrayOf(PropTypes.string),
  disabled: PropTypes.bool,
  onClick: PropTypes.func.isRequired,
  value: PropTypes.string.isRequired
};

CtaButton.defaultProps = {
  additionalClasses: [],
  disabled: false
}

export default CtaButton;
