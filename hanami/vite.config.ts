import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import FullReload from 'vite-plugin-full-reload'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    FullReload(['app/frontend/**/*', 'app/templates/**/*']),
  ],
  server: {
    // Allow the hanami container to reach this server by its compose service name
    allowedHosts: ['vite-hanami'],
  },
})
