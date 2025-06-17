import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
      '@components': path.resolve(__dirname, './src/frontend/src/components'),
      '@pages': path.resolve(__dirname, './src/frontend/src/pages'),
      '@hooks': path.resolve(__dirname, './src/frontend/src/hooks'),
      '@context': path.resolve(__dirname, './src/frontend/src/context'),
      '@services': path.resolve(__dirname, './src/frontend/src/services'),
      '@utils': path.resolve(__dirname, './src/frontend/src/utils'),
      '@types': path.resolve(__dirname, './src/frontend/src/types'),
      '@styles': path.resolve(__dirname, './src/frontend/src/styles'),
    },
  },
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ''),
      },
    },
  },
  build: {
    outDir: 'dist/frontend',
    sourcemap: true,
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom', 'react-router-dom'],
        },
      },
    },
  },
}); 