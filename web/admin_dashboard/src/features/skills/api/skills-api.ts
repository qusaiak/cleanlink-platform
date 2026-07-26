import { apiClient } from '../../../core/api/api-client'
import { apiEndpoints } from '../../../core/api/api-endpoints'
import type { ApiResponse } from '../../../core/api/api-types'
import type { Skill, SkillFormValues } from '../types/skill'

export const skillsApi = {
  async list(signal?: AbortSignal) {
    const response = await apiClient.get<ApiResponse<Skill[]>>(
      apiEndpoints.skills.list,
      { signal },
    )
    return response.data.data
  },
  async create(values: SkillFormValues) {
    const response = await apiClient.post<ApiResponse<Skill>>(
      apiEndpoints.skills.create,
      values,
    )
    return response.data.data
  },
  async delete(id: number) {
    await apiClient.delete(apiEndpoints.skills.delete(id))
  },
}

export const skillKeys = {
  all: ['skills'] as const,
  list: () => [...skillKeys.all, 'list'] as const,
}
