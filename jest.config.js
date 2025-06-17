module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  roots: ['<rootDir>/src'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
    '^@components/(.*)$': '<rootDir>/src/frontend/src/components/$1',
    '^@pages/(.*)$': '<rootDir>/src/frontend/src/pages/$1',
    '^@hooks/(.*)$': '<rootDir>/src/frontend/src/hooks/$1',
    '^@context/(.*)$': '<rootDir>/src/frontend/src/context/$1',
    '^@services/(.*)$': '<rootDir>/src/frontend/src/services/$1',
    '^@utils/(.*)$': '<rootDir>/src/frontend/src/utils/$1',
    '^@types/(.*)$': '<rootDir>/src/frontend/src/types/$1',
    '^@styles/(.*)$': '<rootDir>/src/frontend/src/styles/$1',
  },
  setupFilesAfterEnv: ['<rootDir>/src/frontend/src/setupTests.ts'],
  testMatch: ['**/__tests__/**/*.+(ts|tsx|js)', '**/?(*.)+(spec|test).+(ts|tsx|js)'],
  transform: {
    '^.+\\.(ts|tsx)$': 'ts-jest',
  },
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
    '!src/frontend/src/index.tsx',
    '!src/frontend/src/setupTests.ts',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
}; 