export interface Category {
  id: number
  name: string
  description: string | null
  image: string | null
  created_at: string
  updated_at: string
}

export interface AdminCategory {
  id: number
  name_ar: string
  name_en: string
  description_ar?: string | null
  description_en?: string | null
  image: string | null
  created_at: string
  updated_at: string
}

export interface CategoryFilters {
  search?: string
}

export interface CategoryDetails {
  id: number
  name_ar: string
  name_en: string
  description_ar: string | null
  description_en: string | null
  image: string | null
  services: import('../../services/types/service').ServiceListItem[]
  created_at: string
  updated_at: string
}

export interface CategoryFormValues {
  name_ar: string
  name_en: string
  description_ar: string
  description_en: string
  image: File | null
}
