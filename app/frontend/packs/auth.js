/* eslint no-console:0 sort-imports:0 */

import { checkPasswordCriteria } from 'src/users/passwords/edit';
import { showSlidingFrame } from 'src/users/shared/index';

/*
 * CSS
 * This will be extracted into a separate file by the webpack build
 */

import 'src/deactivated_user/index.scss';
import 'src/users/confirmations/new.scss';
import 'src/users/passwords/edit.scss';
import 'src/users/passwords/new.scss';
import 'src/users/registrations/new.scss';
import 'src/users/sessions/new.scss';
import 'src/users/shared/_omniauth_links.scss';
import 'src/users/shared/index.scss';

// The export value here will be available under `Familyties.auth.*`
export default {
  checkPasswordCriteria,
  showSlidingFrame
};
