import './form-input-file.scss';

import React, { useEffect, useRef } from 'react';
import { idFromName } from './helpers';
import PropTypes from 'prop-types';

/*
 * An input for `input[type='file']` to select and add files
 *
 * This component can be controlled internally or externally
 *
 *  1. Internally - `value` should be specified as `null`
 *  2. Externally - `value` should be specified as either the list of files, or
 *     as `''` which will reset the file list. The list of files can be derived
 *     by specifyin `onChange()`, which will send the file list as an argument
 *     to the handler on each file change.
 */
const FormInputFile = ({ name, onChange, value }) => {
  const inputRef = useRef();

  useEffect(() => {
    if (value === '') {
      inputRef.current.value = '';
    }
  }, [value]);

  return (
    <input
      id={idFromName(name)}
      name={name}
      onChange={(e) => onChange && onChange([...e.target.files])}
      ref={inputRef}
      type='file'
    />
  );
};

FormInputFile.propTypes = {
  name: PropTypes.string.isRequired,
  onChange: PropTypes.func,
  value: PropTypes.oneOfType([PropTypes.string, PropTypes.array])
};

export default FormInputFile;
