//
// Enzyme
//

import Enzyme from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';

Enzyme.configure({ adapter: new Adapter() });

//
// Chai
//

import chai from 'chai';
import chaiEnzyme from 'chai-enzyme';

chai.use(chaiEnzyme()); // Note the invocation at the end

//
// I18n
//

// The `i18n-js` gem uses Sprockets / the Asset Pipeline to build a JS
// file that defines a global `I18n` and all it's translations.
// This `I18n` object is then available globally to other assets such as
// the packs built by Webpack containing the React components.
//
// For testing Jest loads each component in isolation and `I18n` must be
// defined manually. We do this by reading the `config/locales/en.yml`
// file and building the `I18n.translations` object.

global.I18n = require('i18n-js');
const yaml = require('js-yaml');

const fs = require('fs');
const path = require('path');

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
  const translations = yaml.safeLoad(fs.readFileSync(configPath, 'utf8'));
  global.I18n.translations = {};
  global.I18n.translations.en = translations.en;
} catch (e) {
  // eslint-disable-next-line no-console
  console.log(`FAILED to load I18n translations from ${configPath}: ${e}`);
}
