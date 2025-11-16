import { defineConfig } from 'vite'
import StimulusHMR from 'vite-plugin-stimulus-hmr'
import FullReload from 'vite-plugin-full-reload'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    StimulusHMR(),
    FullReload(['config/routes.rb', 'app/views/**/*', 'app/frontend/**/*', 'app/builders/**/*', 'app/components/**/*', 'app/helpers/**/*']),
  ],
  server: {
    "port": 3046,
    "hmr": {
      clientPort: 3046,
    },
    host: true,
    strictPort: true,
  }
})
