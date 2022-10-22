/* eslint no-console:0 */

// Expose JQuery globally
window.$ = window.jQuery = require('jquery');
require('jquery-ujs');

import 'core-js/stable';

import 'javascript/application/_desktop_navigation';
import 'javascript/application/_global_modal_close';
import 'javascript/application/_mobile_navigation';
import 'javascript/application/flash.js';

import 'javascript/components/example';
import 'javascript/components/product_feedback_form';

import 'javascript/mount-react-component';

/*
 * Import CSS for this pack
 * This will be extracted into a separate file by the webpack build
 */
import '../../stylesheets/packs/common.scss';
