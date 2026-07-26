import { apiClient } from '../../../core/api/api-client'
import { apiEndpoints } from '../../../core/api/api-endpoints'
import type { ApiResponse } from '../../../core/api/api-types'
import type {
  Category,
  CategoryDetails,
  CategoryFormValues,
} from '../types/category'
import type { ServiceListItem } from '../../services/types/service'

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
  async create(values: CategoryFormValues) {
    const response = await apiClient.post<ApiResponse<Category>>(
      apiEndpoints.categories.create,
      toFormData(values),
    )
    return response.data.data
  },
  async detail(id: number, signal?: AbortSignal) {
    try {
      const response = await apiClient.get<ApiResponse<CategoryDetails>>(
        apiEndpoints.categories.detail(id),
        { signal },
      )
      return response.data.data
    } catch (error) {
      const [english, arabic, services] = await Promise.all([
        apiClient.get<ApiResponse<Category[]>>(apiEndpoints.categories.list, {
          signal,
          headers: { 'Accept-Language': 'en' },
        }),
        apiClient.get<ApiResponse<Category[]>>(apiEndpoints.categories.list, {
          signal,
          headers: { 'Accept-Language': 'ar' },
        }),
        apiClient.get<ApiResponse<ServiceListItem[]>>(apiEndpoints.services.list, {
          signal,
        }),
      ])
      const en = english.data.data.find((category) => category.id === id)
      const ar = arabic.data.data.find((category) => category.id === id)
      if (!en || !ar) throw error
      return {
        id,
        name_ar: ar.name,
        name_en: en.name,
        description_ar: ar.description,
        description_en: en.description,
        image: en.image ?? ar.image,
        services: services.data.data.filter((service) => service.category_id === id),
        created_at: en.created_at,
        updated_at: en.updated_at,
      }
    }
  },
  async delete(id: number) {
    await apiClient.delete(apiEndpoints.categories.delete(id))
  },
}

export const categoryKeys = {
  all: ['categories'] as const,
  lists: () => [...categoryKeys.all, 'list'] as const,
  list: (language: string) => [...categoryKeys.lists(), language] as const,
  details: () => [...categoryKeys.all, 'detail'] as const,
  detail: (id: number) => [...categoryKeys.details(), id] as const,
}
