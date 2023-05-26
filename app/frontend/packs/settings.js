/* eslint no-console:0 */
/* eslint sort-imports:0 */

import {
  addRole,
  deleteUser,
  removeRole,
  resendUserInvitation,
  deleteUserInvitation,
  onFormEmailChange,
  onFormSubmit
} from 'src/settings/users/index';

import { apiPost } from 'src/services/api/post';
import 'src/account/index/avatar-editor';

/*
 * CSS
 * This will be extracted into a separate file by the webpack build
 */
import 'src/application/_settings_template.scss';
import 'src/settings/index.scss';
import 'src/settings/users/index.scss';

// The export value here will be available under `Girder.settings.*`
export default {
  addRole,
  removeRole,
  deleteUser,
  resendUserInvitation,
  deleteUserInvitation,
  onFormEmailChange,
  onFormSubmit,
  apiPost
};
