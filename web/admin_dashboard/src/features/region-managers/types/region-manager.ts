import type { Profile } from '../../../core/auth/auth-types'

export interface RegionManager {
  id: number
  fullname: string
  email: string
  role: 'region_manager'
  profile?: Profile | null
  created_at: string
  updated_at: string
}

export interface CreateRegionManagerInput {
  fullname: string
  email: string
  password: string
}

export interface RegionManagerFilters {
  search?: string
}
