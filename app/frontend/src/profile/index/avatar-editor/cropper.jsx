/* eslint-disable react/forbid-component-props */
import 'cropperjs/dist/cropper.css';
import './cropper.scss';

import PropTypes from 'prop-types';
import React from 'react';
import ReactCropper from 'react-cropper';

const Cropper = ({ imageUrl, onInitialized }) => {
  return (
    <ReactCropper
      aspectRatio={1}
      autoCropArea={0.8}
      background={false}
      checkOrientation={false}
      dragMode='move'
      guides
      initialAspectRatio={1}
      minCropBoxHeight={200}
      minCropBoxWidth={200}
      onInitialized={onInitialized}
      responsive
      src={imageUrl}
      style={{ maxHeight: 400, width: '100%' }}
      viewMode={3}
    />
  );
};

Cropper.propTypes = {
  imageUrl: PropTypes.string.isRequired,
  onInitialized: PropTypes.func.isRequired
};

export default Cropper;
