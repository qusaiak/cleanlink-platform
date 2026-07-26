const required = (name: keyof ImportMetaEnv): string => {
  const value = import.meta.env[name]

  if (!value && import.meta.env.DEV) {
    throw new Error(`Missing required environment variable: ${name}`)
  }

  return value
}

const parsedTimeout = Number(import.meta.env.VITE_API_TIMEOUT_MS ?? 30_000)

export const env = {
  apiBaseUrl: required('VITE_API_BASE_URL').replace(/\/+$/, ''),
  apiTimeoutMs:
    Number.isFinite(parsedTimeout) && parsedTimeout > 0 ? parsedTimeout : 30_000,
} as const
