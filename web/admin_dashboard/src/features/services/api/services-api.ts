import { apiClient } from '../../../core/api/api-client'
import { apiEndpoints } from '../../../core/api/api-endpoints'
import type { ApiResponse } from '../../../core/api/api-types'
import type { ServiceDetails, ServiceListItem } from '../types/service'

export const servicesApi = {
  async list(signal?: AbortSignal, companyId?: number) {
    const response = await apiClient.get<ApiResponse<ServiceListItem[]>>(
      apiEndpoints.services.list,
      { signal, params: companyId ? { company_id: companyId } : undefined },
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
  list: (companyId?: number) => [...serviceKeys.lists(), companyId ?? 'all'] as const,
  details: () => [...serviceKeys.all, 'detail'] as const,
  detail: (id: number) => [...serviceKeys.details(), id] as const,
}
