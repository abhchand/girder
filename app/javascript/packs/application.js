/* eslint no-console:0 */

// Expose JQuery globally
window.jQuery = require('jquery');
window.$ = window.jQuery;
require('jquery-ujs');

import 'core-js/stable';

import 'mount-react-component';

import 'application/_mobile_navigation.js';
import 'application/_modal.js';
import 'application/flash.js';

import 'components/example';
