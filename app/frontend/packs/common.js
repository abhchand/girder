/* eslint no-console:0 */

// Expose JQuery globally
window.jQuery = require('jquery');
window.$ = window.jQuery;
require('jquery-ujs');

import 'core-js/stable';

import 'src/application/_desktop_navigation';
import 'src/application/_global_modal_close';
import 'src/application/_mobile_navigation';
import 'src/application/flash.js';

import 'src/components/example';
import 'src/components/product_feedback_form';

import 'src/mount-react-component';

/*
 * CSS
 * This will be extracted into a separate file by the webpack build
 */

import 'src/shared/index.scss';
import 'src/application/_desktop_header.scss';
import 'src/application/_mobile_header.scss';
