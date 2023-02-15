/* eslint-disable no-process-env */

const testMode = process.env.NODE_ENV === 'test';
// eslint-disable-next-line
const prodMode = process.env.NODE_ENV === 'production';

const path = require('path');

const ASSETS_DIR = path.resolve(__dirname, 'app/frontend');

const PUBLIC_DIR = path.resolve(__dirname, 'public');
const PACKS_DIR = path.resolve(
  __dirname,
  testMode ? 'public/packs-test' : 'public/packs'
);
const IMAGES_DIR = path.resolve(
  __dirname,
  testMode ? 'public/assets/images-test' : 'public/assets/images'
);

const PUBLIC_PATH = testMode ? '/packs-test/' : '/packs/';

const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin');
const CopyPlugin = require('copy-webpack-plugin');
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const WebpackAssetsManifest = require('webpack-assets-manifest');
const webpack = require('webpack');

const config = {
  mode: testMode ? 'none' : process.env.NODE_ENV,
  output: {
    filename: '[name]-[fullhash].js',
    chunkFilename: '[name]-[chunkhash].chunk.js',
    path: PACKS_DIR,
    publicPath: PUBLIC_PATH,
    pathinfo: true,
    // https://github.com/webpack/webpack/issues/6693#issuecomment-745688108
    hotUpdateChunkFilename: '[id].[fullhash].hot-update.js',
    hotUpdateMainFilename: '[runtime].[fullhash].hot-update.json',
    /*
     * Expose each pack as `Girder.<pack_name>` (e.g. `Girder.admin`). The value
     * will be the default export of that pack
     */
    library: {
      name: ['Girder', '[name]'],
      type: 'var',
      export: 'default'
    }
  },
  resolve: {
    extensions: [
      '.erb',
      '.jsx',
      '.js',
      '.sass',
      '.scss',
      '.css',
      '.module.sass',
      '.module.scss',
      '.module.css',
      '.png',
      '.svg',
      '.gif',
      '.jpeg',
      '.jpg'
    ],
    modules: [ASSETS_DIR, 'node_modules']
  },
  resolveLoader: {
    modules: ['node_modules']
  },
  optimization: {
    /*
     * Minimization will remove duplicate CSS that occurs from repeated
     * `@xtend` and `@import` statements.
     *
     * By default minimization will only happen in `production`, but can be
     * forced in `development` with `minimize: true`.
     */
    minimizer: [
      // Triple dot preserves existing minimizers that Webpack may define
      `...`,
      new CssMinimizerPlugin(),
    ]
  },
  devtool: 'cheap-module-source-map',
  devServer: {
    client: {
      logging: 'none'
    },
    compress: true,
    // `webpack-dev-middleware` library options
    devMiddleware: {
      /*
       * Webpack-dev-server serves assets from memory. Since
       * the assets/images/* files are statically copied (via the
       * `CopyPlugin` below) and not built as a webpack "pack"
       * (using a defined 'entry point') they are not served
       * from webpack dev server's memory. To get around this
       * we write these files to disk and the dev server will
       * fallback to looking for them on the disk since we
       * statically serve everything under the public directory.
       */
      writeToDisk: (filePath) => {
        return /assets\/images\//u.test(filePath);
      }
    },
    host: 'localhost',
    port: 3035,
    https: false,
    hot: true,

    historyApiFallback: {
      disableDotRule: true
    },
    headers: {
      'Access-Control-Allow-Origin': '*'
    },
    static: {
      /*
       * Note: `publicPath` takes precedence if defined
       * so don't define it and just serve all content
       * as static from the `public/` directory
       */
      directory: PUBLIC_DIR,
      watch: {
        ignored: '/node_modules/'
      }
    }
  },
  /*
   * Define entrypoints to build various "packs".
   *
   * Each pack consists of a JS file and a CSS file. Webpack allows specifying
   * multiple imports so ideally we would do:
   *
   *    {
   *      import: [
   *        '/path/to/flie.js',
   *        '/path/to/flie.css'
   *      ],
   *      dependOn: 'common'
   *    }
   *
   * However we need to have a singular import so that the return value can
   * be set as the library value above (in `output.library.name`).
   *
   * So instead, we only bundle the JS file here and `import` the CSS file
   * inside the JS file.
   *
   *      * The imported CSS file will be loaded by the `MiniCssExtractPlugin`
   *        loader below
   *
   *      * The compiled file will be fingerprinted by the `MiniCssExtractPlugin`
   *        plugin below
   */
  entry: {
    admin: {
      import: `${ASSETS_DIR}/packs/admin.js`,
      dependOn: 'common'
    },
    auth: {
      import: `${ASSETS_DIR}/packs/auth.js`,
      dependOn: 'common'
    },
    common: `${ASSETS_DIR}/packs/common.js`,
    i18n: `${ASSETS_DIR}/packs/i18n.js`,
    'jquery-for-test': `${ASSETS_DIR}/packs/jquery-for-test.js`
  },
  module: {
    strictExportPresence: true,
    rules: [
      {
        test: /\.(css)$/iu,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
            options: {}
          },
          {
            loader: 'css-loader',
            options: {
              sourceMap: true,
              importLoaders: 2,
              modules: false
            }
          }
        ]
      },
      {
        test: /\.(scss|sass)$/iu,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
            options: {}
          },
          {
            loader: 'css-loader',
            options: {
              sourceMap: true,
              importLoaders: 2,
              modules: false
            }
          },
          {
            loader: 'sass-loader',
            options: {
              sourceMap: true
            }
          }
        ]
      },
      {
        test: /\.(jpg|jpeg|png|gif|tiff|ico|svg|eot|otf|ttf|woff|woff2)$/iu,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[path][name]-[fullhash].[ext]'
            }
          }
        ]
      },
      {
        test: /\.erb$/u,
        enforce: 'pre',
        exclude: /node_modules/u,
        use: [
          {
            loader: 'rails-erb-loader',
            options: {
              runner: 'bin/rails runner'
            }
          }
        ]
      },
      {
        test: /\.(js|jsx)?(\.erb)?$/u,
        exclude: /node_modules/u,
        use: [
          {
            loader: 'babel-loader',
            options: {
              cacheDirectory: true,
              babelrc: true
            }
          }
        ]
      }
    ]
  },
  plugins: [
    new webpack.ProvidePlugin({
      $: 'jquery',
      JQuery: 'jquery',
      jquery: 'jquery'
    }),
    new webpack.EnvironmentPlugin(['NODE_ENV']),
    new CaseSensitivePathsPlugin(),
    new MiniCssExtractPlugin({
      filename: '[name]-[contenthash].css',
      chunkFilename: '[id]-[contenthash].chunk.css'
    }),
    new CopyPlugin({
      patterns: [
        {
          from: '**/*',
          context: `${ASSETS_DIR}/images`,
          to: IMAGES_DIR
        }
      ]
    }),
    new WebpackAssetsManifest({
      integrity: false,
      entrypoints: false,
      writeToDisk: true,
      publicPath: PUBLIC_PATH
    })
  ]
};

module.exports = config;
