/* eslint no-console:0 */
/* eslint sort-imports:0 */

import {
  addAdmin,
  deleteUser,
  removeAdmin,
  resendUserInvitation
} from 'src/admin/users/index';

/*
 * CSS
 * This will be extracted into a separate file by the webpack build
 */
import 'src/admin/_filter_warning.scss';
import 'src/admin/index.scss';
import 'src/admin/users/index.scss';

// The export value here will be available under `Girder.admin.*`
export default {
  addAdmin,
  removeAdmin,
  deleteUser,
  resendUserInvitation
};
