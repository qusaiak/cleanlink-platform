import { apiClient } from '../../../core/api/api-client'
import { apiEndpoints } from '../../../core/api/api-endpoints'
import type { ApiResponse } from '../../../core/api/api-types'
import type {
  CreateRegionManagerInput,
  RegionManager,
} from '../types/region-manager'

export const regionManagersApi = {
  async list(signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<RegionManager[]>>(
      apiEndpoints.regionManagers.list,
      { signal },
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
  list: () => [...regionManagerKeys.all, 'list'] as const,
}
