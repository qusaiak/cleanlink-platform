import { apiClient } from '../../../core/api/api-client'
import { apiEndpoints } from '../../../core/api/api-endpoints'
import type { ApiResponse } from '../../../core/api/api-types'
import type {
  ServiceDetails,
  ServiceFilters,
  ServiceListItem,
} from '../types/service'
import { compactQueryParams } from '../../../core/api/list-query'

function toServiceQueryParams(filters: ServiceFilters) {
  return compactQueryParams({
    query: filters.search?.trim() || undefined,
    company_id: filters.companyId,
    category_id: filters.categoryId,
  })
}

export const servicesApi = {
  async list(signal?: AbortSignal, companyId?: number) {
    const response = await apiClient.get<ApiResponse<ServiceListItem[]>>(
      apiEndpoints.services.list,
      { signal, params: companyId ? { company_id: companyId } : undefined },
    )
    return response.data.data
  },
  async search(filters: ServiceFilters, signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<ServiceListItem[]>>(
      apiEndpoints.services.adminList,
      { params: toServiceQueryParams(filters), signal },
    )
    return response.data.data
  },
  async detail(id: number, signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<ServiceDetails>>(
      apiEndpoints.services.detail(id),
      { signal },
    )
    return response.data.data
  },
}

export const serviceKeys = {
  all: ['services'] as const,
  lists: () => [...serviceKeys.all, 'list'] as const,
  list: (filters: ServiceFilters | number = {}) =>
    [...serviceKeys.lists(), filters] as const,
  details: () => [...serviceKeys.all, 'detail'] as const,
  detail: (id: number) => [...serviceKeys.details(), id] as const,
}
