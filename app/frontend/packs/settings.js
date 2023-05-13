/* eslint no-console:0 */
/* eslint sort-imports:0 */

import {
  addRole,
  deleteUser,
  removeRole,
  resendUserInvitation
} from 'src/settings/users/index';

/*
 * CSS
 * This will be extracted into a separate file by the webpack build
 */
import 'src/settings/index.scss';
import 'src/settings/users/index.scss';

// The export value here will be available under `Girder.settings.*`
export default {
  addRole,
  removeRole,
  deleteUser,
  resendUserInvitation
};
