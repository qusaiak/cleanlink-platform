import { apiClient } from '../../../core/api/api-client'
import { apiEndpoints } from '../../../core/api/api-endpoints'
import type { ApiResponse } from '../../../core/api/api-types'
import type {
  CreateRegionManagerInput,
  RegionManager,
  RegionManagerFilters,
} from '../types/region-manager'
import { compactQueryParams } from '../../../core/api/list-query'

function toRegionManagerQueryParams(filters: RegionManagerFilters) {
  return compactQueryParams({
    query: filters.search?.trim() || undefined,
  })
}

export const regionManagersApi = {
  async list(signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<RegionManager[]>>(
      apiEndpoints.regionManagers.list,
      { signal },
    )
    return response.data.data
  },
  async search(filters: RegionManagerFilters, signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<RegionManager[]>>(
      apiEndpoints.regionManagers.adminList,
      { params: toRegionManagerQueryParams(filters), signal },
    )
    return response.data.data
  },
  async create(input: CreateRegionManagerInput) {
    const response = await apiClient.post<ApiResponse<RegionManager>>(
      apiEndpoints.regionManagers.create,
      input,
    )
    return response.data.data
  },
  async delete(id: number) {
    await apiClient.delete(apiEndpoints.regionManagers.delete(id))
  },
}

export const regionManagerKeys = {
  all: ['region-managers'] as const,
  lists: () => [...regionManagerKeys.all, 'list'] as const,
  list: (filters: RegionManagerFilters = {}) =>
    [...regionManagerKeys.lists(), filters] as const,
}
