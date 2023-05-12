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

function addAdmin(userId) {
  httpRequest(`/api/v1/users/${userId}/add_admin.json`);
}

function removeAdmin(userId) {
  httpRequest(`/api/v1/users/${userId}/remove_admin.json`);
}

function deleteUser(userId) {
  httpRequest(`/api/v1/users/${userId}.json`, 'delete');
}

function resendUserInvitation(userInvitationid) {
  httpRequest(`/api/v1/user_invitations/${userInvitationid}/resend.json`);
}

export { addAdmin, removeAdmin, deleteUser, resendUserInvitation };
