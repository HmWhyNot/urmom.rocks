import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import mkcert from 'vite-plugin-mkcert'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue(), mkcert()],
  server: {
    port: 3333,
    https: false,
    strictPort: true,
    proxy: {
      '/api': {
        target: 'http://localhost:5178',
        changeOrigin: true,
        secure: false,
      }
    }
  }
})
