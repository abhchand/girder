// See: jestjs.io/docs/configuration.html
module.exports = {
  rootDir: '../../..',
  roots: ['app/frontend/src', 'app/frontend/test'],
  moduleFileExtensions: ['js', 'jsx'],
  moduleDirectories: ['node_modules', 'app/frontend'],
  moduleNameMapper: {
    // Jest can't handle CSS imports, so we need to mock it
    // See: https://stackoverflow.com/a/54646930/2490003
    '\\.(css|scss)$': '<rootDir>/app/frontend/test/mocks/styleMock.js',
  },
  setupFilesAfterEnv: ['<rootDir>/app/frontend/test/jest.setup.js'],
  transform: {
    '\\.jsx?$': 'babel-jest'
  },
  transformIgnorePatterns: ['/node_modules/(?!i18n-js/)'],
  verbose: false
};
