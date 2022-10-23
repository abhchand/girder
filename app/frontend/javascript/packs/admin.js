/* eslint no-console:0 */

import 'javascript/admin/users/admin_user_manager';
import {
  addAdmin,
  removeAdmin,
  deleteUser,
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
