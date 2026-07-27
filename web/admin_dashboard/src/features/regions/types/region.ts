import type { RegionManager } from '../../region-managers/types/region-manager'
import type { CompanyListItem } from '../../companies/types/company'

export interface Region {
  id: number
  name_ar: string
  name_en: string
  manager_id: number
  image: string | null
  manager?: RegionManager | null
  created_at: string
  updated_at: string
  companies?: CompanyListItem[]
}

export interface RegionFormValues {
  name_ar: string
  name_en: string
  manager_id: string
  image: File | null
}

export interface RegionFilters {
  search?: string
}
