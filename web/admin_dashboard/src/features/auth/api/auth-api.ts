import { apiClient } from '../../../core/api/api-client'
import { apiEndpoints } from '../../../core/api/api-endpoints'
import type { ApiResponse } from '../../../core/api/api-types'
import type { AuthUser } from '../../../core/auth/auth-types'

export interface LoginInput {
  email: string
  password: string
}

interface LoginData {
  user: AuthUser
  access_token: string
}

export const authApi = {
  async login(input: LoginInput, signal?: AbortSignal) {
    const response = await apiClient.post<ApiResponse<LoginData>>(
      apiEndpoints.auth.login,
      input,
      { signal },
    )
    return response.data
  },
  async me(signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<AuthUser>>(
      apiEndpoints.auth.me,
      { signal },
    )
    return response.data
  },
  async logout() {
    await apiClient.post(apiEndpoints.auth.logout)
  },
}
