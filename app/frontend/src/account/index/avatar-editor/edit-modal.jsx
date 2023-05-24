import './edit-modal.scss';

import React, { useState } from 'react';
import axios from 'axios';
import Cropper from './cropper';
import Modal from 'src/components/modal';
import ModalError from 'src/components/modal/error';
import PropTypes from 'prop-types';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';
import User from 'src/models/user';

const EditModal = ({ closeModal, imageName, imageUrl, user }) => {
  const [cropper, setCropper] = useState(null);
  const [errorText, setErrorText] = useState(null);

  const i18nPrefix = 'account.index.avatar_editor.edit_modal';

  function onSubmit() {
    // Clear any existing error
    setErrorText(null);

    const config = {
      method: 'PUT',
      url: `/api/v1/users/${user.id}`,
      data: new FormData(),
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      }
    };

    const canvas = cropper.getCroppedCanvas();
    const getBlob = new Promise((resolve) =>
      canvas.toBlob((blob) => resolve(blob))
    );

    return getBlob
      .then((blob) => {
        config.data.append('user[avatar]', blob, imageName);
        return axios(config);
      })
      .then((_response) => window.location.reload())
      .catch((error) => {
        setErrorText(I18n.t('generic_error'));
        /*
         * Return a Promise rejection so the execution falls to the next
         * `catch()` block, skipping any `then()` blocks inside `<Modal />`
         */
        return Promise.reject(error);
      });
  }

  function renderError() {
    return errorText ? <ModalError text={errorText} /> : null;
  }

  /*
   * Ideally we'd use `ModalForm` here, but the `canvas.toBlob()` call is async,
   * so it can't easily be inserted into the ModalForm flow. The `formData` is
   * manually created and posted above
   */
  return (
    <Modal
      onSubmit={onSubmit}
      closeModal={closeModal}
      heading={I18n.t(`${i18nPrefix}.heading`)}
      httpMethod='put'
      modalClassName='avatar-editor__edit-modal'
      submitButtonEnabled>
      {renderError()}
      <Cropper
        imageUrl={imageUrl}
        onInitialized={(instance) => setCropper(instance)}
      />
    </Modal>
  );
};

EditModal.propTypes = {
  closeModal: PropTypes.func.isRequired,
  imageName: PropTypes.string.isRequired,
  imageUrl: PropTypes.string.isRequired,
  user: PropTypes.instanceOf(User).isRequired
};

export default EditModal;
