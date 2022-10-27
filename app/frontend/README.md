# How the Frontend Works

## Overview

Webpack is used to build all assets from `app/frontend/*` into `public/packs/*`.
This includes -

  * JS
  * CSS
  * Images

The `webpack.config.js` defines multiple `entry` points, and a single `output`.

Webpack can be built with `yarn run build:${env}`, where `env` is `test`, `dev`,
or `prod`.

## Building Packs

Each `entry` in `webpack.config.js` is a "pack". A pack consists of a bundle of
JS + CSS.

Packs are fingerprinted based on contents. An `assets-manifest.json` file holds
the mapping between a pack name (e.g. `'admin'`) and it's latest fingerprinted
file name. E.g. -

```shell
ls -hlt public/packs
assets-manifest.json
admin-f2ef4449ffece4629993.js
...
```

## Including Packs

Rails can include certain packs when building view. A Rails controller just needs
to include the name of the pack in an array called `@use_packs`:

```ruby
# app/controllers/admin_controller.rb
before_action { @use_packs << 'admin' }
```

When rendering the view, Rails will include the JS and CSS associated with each
pack name in `@use_packs`. It uses the above `assets-manifest.json` mapping to
determine the fingerprinted file for each name.

## Ways to use JS functionality

### ReactJS

React components live under `app/frontend/components/*`. To mount a React
component on a page, just include `react_component()` in the Rails view and
pass in an `id` and a list of initial props.

```ruby
react_component('example', { photos: @photos.map(&:to_h) })
```

This will create a `<div>` mount node that React can render into.

Inside the React JS file itself, call `mountComponent()` with the component and
the same `id`:

```js
mountReactComponent(Example, 'example');
```

This will call `ReactDom.render()` and mount the component into the DOM node
created above.

### Redux Preloaded State

If you have a Redux component that requires some initial state pre-loaded or
set, you can render that into the DOM for Redux to read from.

Set `@redux_preloaded_state` in any controller:

```ruby
@redux_preloaded_state = { foo: 'bar' }
```

This will be embedded into the template as a `<script>` and will be availabel in
JS as `window.__REDUX_PRELOADED_STATE__`

### On Page Load Events + Handlers

Any functionality that runs automatically on page load can be written inside the
pack as

```js
$(document).ready(() => {
  // Example: `keyup` listener event
  $('body').on('keyup', (e) => {
  }
}
```

### Exported Functions

The JS `default export` value of every **pack** is set as `Girder.<pack_name>`  on
the global namespace.

```js
// app/frontend/javascript/packs/admin.js
const doFoo = () => alert('boo!');

export default {
  doFoo
}
```

In the console:

```js
Girder.admin.doFoo()
```
