import {
  registerAsyncProcess,
  unregisterAsyncProcess
} from 'utils/async-registration';
import axios from 'axios';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';
import { setFlash } from 'src/application/flash';

/*
 * Send a request to the specified URL. Default is POST, but other methods
 * can be specified.
 *
 * Will reload the page on success or set a generic flash message on failure
 */
function httpRequest(url, method = 'post') {
  const config = {
    method: method,
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
      'X-CSRF-Token': ReactOnRails.authenticityToken()
    }
  };

  axios(url, config)
    .then((_response) => window.location.reload())
    .catch((_error) => setFlash('error', I18n.t('generic_error')));
}

function addRole(userId, _roleName) {
  /*
   * See comment in controller - this endpoint doesn't actually handle adding
   * or removing roles generically. It's hardcoded to act on the 'leader' role
   */
  httpRequest(`/api/v1/users/${userId}/add_role.json`);
}

function removeRole(userId, _roleName) {
  /*
   * See comment in controller - this endpoint doesn't actually handle adding
   * or removing roles generically. It's hardcoded to act on the 'leader' role
   */
  httpRequest(`/api/v1/users/${userId}/remove_role.json`);
}

function deleteUser(userId) {
  httpRequest(`/api/v1/users/${userId}.json`, 'delete');
}

function resendUserInvitation(userInvitationid) {
  httpRequest(`/api/v1/user_invitations/${userInvitationid}/resend.json`);
}

function deleteUserInvitation(userInvitationid) {
  httpRequest(`/api/v1/user_invitations/${userInvitationid}.json`, 'delete');
}

function onFormEmailChange(e) {
  const submit = document.querySelector(
    ".settings-users-index__user-invitation-form input[type='submit']"
  );
  const input = e.target;

  submit.disabled = input.value.length === 0;
}

function onFormSubmit(e) {
  e.preventDefault();

  const form = e.target;

  const url = form.action;
  const data = new FormData(form);
  const config = {
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json'
    }
  };

  registerAsyncProcess('user-invitation-form-submit');

  return axios
    .post(url, data, config)
    .then((_response) => {
      unregisterAsyncProcess('user-invitation-form-submit');
      window.location.reload();
    })
    .catch((error) => {
      unregisterAsyncProcess('user-invitation-form-submit');
      setFlash('error', error.response.data.error);
    });
}

export {
  addRole,
  removeRole,
  deleteUser,
  resendUserInvitation,
  deleteUserInvitation,
  onFormEmailChange,
  onFormSubmit
};
