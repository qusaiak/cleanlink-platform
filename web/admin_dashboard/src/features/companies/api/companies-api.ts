import { apiClient } from '../../../core/api/api-client'
import { apiEndpoints } from '../../../core/api/api-endpoints'
import type { ApiResponse } from '../../../core/api/api-types'
import type {
  CompanyDetails,
  CompanyListItem,
  CompanyManager,
} from '../types/company'

export const companiesApi = {
  async list(signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<CompanyListItem[]>>(
      apiEndpoints.companies.list,
      { signal },
    )
    return response.data.data
  },
  async detail(id: number, signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<CompanyDetails>>(
      apiEndpoints.companies.detail(id),
      { signal },
    )
    return response.data.data
  },
  async managers(signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<CompanyManager[]>>(
      apiEndpoints.companies.managers,
      { signal },
    )
    return response.data.data
  },
  async delete(id: number) {
    await apiClient.delete(apiEndpoints.companies.delete(id))
  },
}

export const companyKeys = {
  all: ['companies'] as const,
  lists: () => [...companyKeys.all, 'list'] as const,
  list: () => [...companyKeys.lists()] as const,
  details: () => [...companyKeys.all, 'detail'] as const,
  detail: (id: number) => [...companyKeys.details(), id] as const,
  managers: () => [...companyKeys.all, 'managers'] as const,
}
