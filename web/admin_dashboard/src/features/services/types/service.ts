import type { CompanyListItem, CompanyReview } from '../../companies/types/company'

export interface SkillReference {
  id: number
  name_ar: string
  name_en: string
}

export interface ServicePackage {
  id: number
  name_ar: string
  name_en: string
  duration: number
  price: number | string
  price_after_discount?: number | string | null
  minimum_workers: number
  details_ar?: string[]
  details_en?: string[]
}

export interface ServiceListItem {
  id: number
  company_id: number
  category_id: number
  name_ar: string
  name_en: string
  description_ar?: string | null
  description_en?: string | null
  rating: number | string
  min_duration: number
  max_duration: number
  price: number | string
  image: string | null
  discount: number | string
  company?: CompanyListItem | null
  category?: {
    id: number
    name_ar: string
    name_en: string
  } | null
  created_at: string
  updated_at: string
}

export interface ServiceDetails extends ServiceListItem {
  packages: ServicePackage[]
  required_skills?: SkillReference[]
  requiredskills?: SkillReference[]
  reviews: CompanyReview[]
  images?: Array<{ id: number; image: string }>
  attributes?: Array<{
    id: number
    name_ar: string
    name_en: string
    pivot?: { price?: number | string; duration?: number }
  }>
}

export interface ServiceFilters {
  search?: string
  companyId?: number
  categoryId?: number
}
