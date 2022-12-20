/* eslint no-console:0 */
/* eslint sort-imports:0 */

import {
  addAdmin,
  deleteUser,
  removeAdmin,
  resendUserInvitation
} from 'javascript/admin/users/index';

/*
 * Import CSS for this pack
 * This will be extracted into a separate file by the webpack build
 */
import '../../stylesheets/packs/admin.scss';

// The export value here will be available under `Girder.admin.*`
export default {
  addAdmin,
  removeAdmin,
  deleteUser,
  resendUserInvitation
};
