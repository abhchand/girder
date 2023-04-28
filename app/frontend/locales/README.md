# I18n JS Pipeline

The JS build for I18n translations is handled via the [`i18n-js`](https://github.com/fnando/i18n-js) gem.

As much as possible, we try to keep all files associated with this feature in this directory.

The pipeline involves 2 stages -

  1. Generating (Exporting) the translations as a JSON file

  2. Loading the JSON translations into a global `I18n` object


# 1. Generating translations

The gem provides a built-in CLI that does the exporting. It takes a config file as an argument, describing what translations and keys to be exported

```shell
bundle exec i18n export --config ./app/frontend/locales/config.yml
```

The outputs a `translations.json` file in `./app/frontend/locales/`. **This file is `.gitignore`-d**.

  * On `production`, this file is pre-compiled as part of the build pipeline
  * On `development`, we continuously watch for changes to I18n locales and rebuild this file as needed
  * On `test`, this file is not used (it reads directly from the source YML file)

### Continously Build

The `i18n-js` gem provides a listener that watches for file changes in the `config/locales/*` source directory and re-builds this file by calling the above CLI command. It uses the `listen` gem internally.

That listener is registered in `listen.rb`, and is invoked from an initializer.

# 2. Loading the Translations

To load the translations, we build a webpack pack called `i18n` which reads and loads the translations into a globally available `I18n` object. This pack is included on every page by default, and is embedded in `application.html.erb`. The pack calls `loader.js` to do this.

The exception is the `test` environment, which bypasses this pack entirely since it is dynamically built. Instead the `test` / `jest` environment calls `loader-test.js` which reads the source YML file directly and loads the definitions into a `global.I18n` object.

