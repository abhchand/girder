// See: jestjs.io/docs/configuration.html
module.exports = {
  rootDir: '../../..',
  roots: ['app/frontend/src', 'app/frontend/test'],
  moduleFileExtensions: ['js', 'jsx'],
  moduleDirectories: ['node_modules', 'app/frontend'],
  setupFilesAfterEnv: ['<rootDir>/app/frontend/test/jest.setup.js'],
  transform: {
    '\\.jsx?$': 'babel-jest'
  },
  transformIgnorePatterns: ['/node_modules/(?!i18n-js/)'],
  verbose: false
};
