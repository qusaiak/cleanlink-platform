import { apiClient } from '../../../core/api/api-client'
import { apiEndpoints } from '../../../core/api/api-endpoints'
import type { ApiResponse } from '../../../core/api/api-types'
import type { Region, RegionFormValues } from '../types/region'

const toFormData = (values: RegionFormValues, includeManager: boolean) => {
  const data = new FormData()
  data.append('name_ar', values.name_ar)
  data.append('name_en', values.name_en)
  if (includeManager) data.append('manager_id', values.manager_id)
  if (values.image) data.append('image', values.image)
  return data
}

export const regionsApi = {
  async list(signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<Region[]>>(
      apiEndpoints.regions.list,
      { signal },
    )
    return response.data.data
  },
  async create(values: RegionFormValues) {
    const response = await apiClient.post<ApiResponse<Region>>(
      apiEndpoints.regions.create,
      toFormData(values, true),
    )
    return response.data.data
  },
  async detail(id: number, signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<Region>>(
      apiEndpoints.regions.detail(id),
      { signal },
    )
    return response.data.data
  },
  async update(id: number, values: RegionFormValues) {
    const data = toFormData(values, false)
    data.append('_method', 'PUT')
    const response = await apiClient.post<ApiResponse<Region>>(
      apiEndpoints.regions.update(id),
      data,
    )
    return response.data.data
  },
  async delete(id: number) {
    await apiClient.delete(apiEndpoints.regions.delete(id))
  },
}

export const regionKeys = {
  all: ['regions'] as const,
  list: () => [...regionKeys.all, 'list'] as const,
  details: () => [...regionKeys.all, 'detail'] as const,
  detail: (id: number) => [...regionKeys.details(), id] as const,
}
