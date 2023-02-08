import PropTypes from 'prop-types';
import React from 'react';

const LinkButton = (props) => {
  return (
    <button
      type='button'
      className={`link-btn ${props.additionalClasses.join(' ')}`}
      onClick={props.onClick}>
      {props.children}
    </button>
  );
};

LinkButton.propTypes = {
  additionalClasses: PropTypes.arrayOf(PropTypes.string),
  children: PropTypes.node,
  onClick: PropTypes.func.isRequired
};

LinkButton.defaultProps = {
  additionalClasses: []
};

export default LinkButton;
