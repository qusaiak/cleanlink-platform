const requiredInDevelopment = (
  name: keyof ImportMetaEnv,
  productionFallback: string,
): string => {
  const value = import.meta.env[name]

  if (!value && import.meta.env.DEV) {
    throw new Error(`Missing required environment variable: ${name}`)
  }

  return value || productionFallback
}

const parsedTimeout = Number(import.meta.env.VITE_API_TIMEOUT_MS ?? 30_000)

export const env = {
  apiBaseUrl: requiredInDevelopment('VITE_API_BASE_URL', '/api').replace(
    /\/+$/,
    '',
  ),
  apiTimeoutMs:
    Number.isFinite(parsedTimeout) && parsedTimeout > 0 ? parsedTimeout : 30_000,
} as const
