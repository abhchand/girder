/* eslint no-console:0 */

/*
 * This pack should only be included in the test environment. It includes JQuery
 * so the selenium / Capybara tests can use it
 */

// Expose JQuery globally
window.jQuery = require('jquery');
window.$ = window.jQuery;
