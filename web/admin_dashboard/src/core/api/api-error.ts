import axios from 'axios'

export type ApiErrorKind =
  | 'network'
  | 'timeout'
  | 'unauthorized'
  | 'forbidden'
  | 'notFound'
  | 'validation'
  | 'rateLimit'
  | 'server'
  | 'unknown'

export interface ApiError {
  kind: ApiErrorKind
  status?: number
  message: string
  fieldErrors: Record<string, string>
}

interface ErrorEnvelope {
  message?: string
  errors?: Record<string, string[] | string>
}

export const normalizeApiError = (error: unknown): ApiError => {
  if (!axios.isAxiosError<ErrorEnvelope>(error)) {
    return {
      kind: 'unknown',
      message: error instanceof Error ? error.message : 'Unknown error',
      fieldErrors: {},
    }
  }

  if (error.code === 'ECONNABORTED' || error.code === 'ETIMEDOUT') {
    return { kind: 'timeout', message: error.message, fieldErrors: {} }
  }

  if (!error.response) {
    return { kind: 'network', message: error.message, fieldErrors: {} }
  }

  const status = error.response.status
  const rawErrors = error.response.data?.errors ?? {}
  const fieldErrors = Object.fromEntries(
    Object.entries(rawErrors).map(([key, value]) => [
      key,
      Array.isArray(value) ? (value[0] ?? '') : value,
    ]),
  )
  const message =
    error.response.data?.message || error.message || 'Request failed'

  const kind: ApiErrorKind =
    status === 401
      ? 'unauthorized'
      : status === 403
        ? 'forbidden'
        : status === 404
          ? 'notFound'
          : status === 422
            ? 'validation'
            : status === 429
              ? 'rateLimit'
              : status >= 500
                ? 'server'
                : 'unknown'

  return { kind, status, message, fieldErrors }
}
