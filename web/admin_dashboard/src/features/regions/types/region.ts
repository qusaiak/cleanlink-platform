import type { RegionManager } from '../../region-managers/types/region-manager'

export interface Region {
  id: number
  name_ar: string
  name_en: string
  manager_id: number
  image: string | null
  manager?: RegionManager | null
  created_at: string
  updated_at: string
}

export interface RegionFormValues {
  name_ar: string
  name_en: string
  manager_id: string
  image: File | null
}
