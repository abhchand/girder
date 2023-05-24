import './index.scss';

import React, { useState } from 'react';
import dataStore from 'src/models';
import mountReactComponent from 'mount-react-component.jsx';
import PropTypes from 'prop-types';
import UploadPhoto from './upload-photo';

const AvatarEditor = (props) => {
  const user = dataStore.sync(props.user);

  return (
    <div className='avatar-editor'>
      <img
        alt={user.name()}
        className='avatar-editor__avatar'
        src={user.avatar.url.original}
      />
      <UploadPhoto user={user} />
    </div>
  );
};

AvatarEditor.propTypes = {
  user: PropTypes.object.isRequired
};

export default AvatarEditor;

mountReactComponent(AvatarEditor, 'avatar-editor');
