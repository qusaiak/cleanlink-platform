import { apiClient } from '../../../core/api/api-client'
import { apiEndpoints } from '../../../core/api/api-endpoints'
import type { ApiResponse } from '../../../core/api/api-types'
import type {
  Category,
  AdminCategory,
  CategoryFilters,
  CategoryDetails,
  CategoryFormValues,
} from '../types/category'
import { compactQueryParams } from '../../../core/api/list-query'

function toCategoryQueryParams(filters: CategoryFilters) {
  return compactQueryParams({
    query: filters.search?.trim() || undefined,
  })
}

const toFormData = (values: CategoryFormValues) => {
  const data = new FormData()
  data.append('name_ar', values.name_ar)
  data.append('name_en', values.name_en)
  data.append('description_ar', values.description_ar)
  data.append('description_en', values.description_en)
  if (values.image) data.append('image', values.image)
  return data
}

export const categoriesApi = {
  async list(signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<Category[]>>(
      apiEndpoints.categories.list,
      { signal },
    )
    return response.data.data
  },
  async search(filters: CategoryFilters, signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<AdminCategory[]>>(
      apiEndpoints.categories.adminList,
      { params: toCategoryQueryParams(filters), signal },
    )
    return response.data.data
  },
  async create(values: CategoryFormValues) {
    const response = await apiClient.post<ApiResponse<Category>>(
      apiEndpoints.categories.create,
      toFormData(values),
    )
    return response.data.data
  },
  async detail(id: number, signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<CategoryDetails>>(
      apiEndpoints.categories.detail(id),
      { signal },
    )
    return response.data.data
  },
  async delete(id: number) {
    await apiClient.delete(apiEndpoints.categories.delete(id))
  },
}

export const categoryKeys = {
  all: ['categories'] as const,
  lists: () => [...categoryKeys.all, 'list'] as const,
  list: (filters: CategoryFilters | string = {}) =>
    [...categoryKeys.lists(), filters] as const,
  details: () => [...categoryKeys.all, 'detail'] as const,
  detail: (id: number) => [...categoryKeys.details(), id] as const,
}
