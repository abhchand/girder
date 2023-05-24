import './upload-photo.scss';

import React, { useState } from 'react';
import EditModal from './edit-modal';
import FormInputFile from 'src/components/forms/form-input-file';
import { idFromName } from 'src/components/forms/helpers';
import PropTypes from 'prop-types';
import User from 'src/models/user';

const UploadPhoto = ({ user }) => {
  const [imageUrl, setImageUrl] = useState(null);
  const [imageName, setImageName] = useState(null);

  const i18nPrefix = 'account.index.avatar_editor.upload_photo';

  const onFileSelect = (files) => {
    const fileReader = new FileReader();
    fileReader.onload = () => {
      setImageName(files[0].name);
      setImageUrl(fileReader.result);
    };
    fileReader.readAsDataURL(files[0]);
  };

  function renderEditModal() {
    if (!imageName || !imageUrl) {
      return null;
    }

    return (
      <EditModal
        key='upload-photo-edit-modal'
        imageName={imageName}
        imageUrl={imageUrl}
        closeModal={() => setImageName(null) && setImageUrl(null)}
        user={user}
      />
    );
  }

  /*
   * Even though this uses the Rails microformat naming, this is not part of
   * any `<form>`. The actual `formData` is manually compiled to include the
   * cropped image canvas
   */
  return [
    // eslint-disable-next-line jsx-a11y/label-has-for
    <label
      key='upload-photo-label'
      className='avatar-editor__upload-photo cta cta--primary'
      htmlFor={idFromName('user[avatar]')}
      // eslint-disable-next-line jsx-a11y/no-noninteractive-tabindex
      tabIndex='0'>
      <FormInputFile
        accept={['image/png', 'image/gif', 'image/jpeg']}
        name='user[avatar]'
        onChange={onFileSelect}
        value={imageUrl || ''}
      />
      {I18n.t(`${i18nPrefix}.label`)}
    </label>,
    renderEditModal()
  ];
};

UploadPhoto.propTypes = {
  user: PropTypes.instanceOf(User).isRequired
};

export default UploadPhoto;
