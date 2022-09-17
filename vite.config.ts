import { defineConfig } from 'vite'
import StimulusHMR from 'vite-plugin-stimulus-hmr'
import FullReload from 'vite-plugin-full-reload'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  plugins: [
    StimulusHMR(),
    FullReload(['config/routes.rb', 'app/views/**/*', 'app/frontend/**/*', 'app/builders/**/*', 'app/components/**/*', 'app/helpers/**/*']),
    RubyPlugin(),
  ],
})
