import axios from 'axios'
import { i18n } from '../../app/providers/localization-provider'
import { env } from '../../config/env'
import { useAuthStore } from '../auth/auth-store'
import { apiEndpoints } from './api-endpoints'

export const apiClient = axios.create({
  baseURL: env.apiBaseUrl,
  timeout: env.apiTimeoutMs,
  headers: {
    Accept: 'application/json',
  },
})

apiClient.interceptors.request.use((config) => {
  const token = useAuthStore.getState().token
  if (!config.headers.has('Accept-Language')) {
    config.headers.set('Accept-Language', i18n.language.startsWith('ar') ? 'ar' : 'en')
  }
  config.headers.set('Accept', 'application/json')

  if (token) config.headers.set('Authorization', `Bearer ${token}`)
  return config
})

apiClient.interceptors.response.use(
  (response) => response,
  (error: unknown) => {
    if (axios.isAxiosError(error) && error.response?.status === 401) {
      const requestUrl = error.config?.url ?? ''
      if (!requestUrl.endsWith(apiEndpoints.auth.login)) {
        useAuthStore.getState().clearSession()
        window.dispatchEvent(new CustomEvent('cleanlink:session-expired'))
      }
    }
    return Promise.reject(error)
  },
)
