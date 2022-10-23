import axios from 'axios';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';
import { setFlash } from 'javascript/application/flash';

function addAdmin(user_id) {
  httpRequest(`/api/v1/users/${user_id}/add_admin.json`);
}

function removeAdmin(user_id) {
  httpRequest(`/api/v1/users/${user_id}/remove_admin.json`);
}

function deleteUser(user_id) {
  httpRequest(`/api/v1/users/${user_id}.json`, 'delete');
}

function resendUserInvitation(user_invitation_id) {
  httpRequest(`/api/v1/user_invitations/${user_invitation_id}/resend.json`);
}

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
    .catch((error) => setFlash('error', I18n.t('generic_error')));
}

export {
  addAdmin,
  removeAdmin,
  deleteUser,
  resendUserInvitation
}
