const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin(
    {
      $: 'jquery/src/jquery',
      jQuery: 'jquery/src/jquery'
    }
  )
)
const erb = require('./loaders/erb')

environment.loaders.prepend('erb', erb)
module.exports = environment
