/*
 * Loads translations into a global `I18n` object on the test/jest environment.
 * It does this by reading the source YML files directly, bypassing the
 * `i18n-js` and webpack build process.
 */
const fs = require('fs');
const I18n = require('i18n-js');
const path = require('path');
const yaml = require('js-yaml');

const configPath = path.join(
  __dirname,
  '..',
  '..',
  '..',
  'config',
  'locales',
  'en.yml'
);

try {
  // eslint-disable-next-line no-sync
  const translations = yaml.safeLoad(fs.readFileSync(configPath, 'utf8'));
  global.I18n = new I18n(translations);
} catch (e) {
  // eslint-disable-next-line no-console
  console.log(`FAILED to load I18n translations from ${configPath}: ${e}`);
}
