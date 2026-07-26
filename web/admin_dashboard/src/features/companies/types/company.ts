import type { Region } from '../../regions/types/region'
import type { ServiceListItem } from '../../services/types/service'

export interface CompanyManager {
  id: number
  fullname: string
  email: string
  role: 'company_manager'
  profile?: {
    phone?: string | null
    address?: string | null
    image?: string | null
  } | null
  created_at?: string
}

export interface CompanyWorkTime {
  id: number
  day_of_week: number
  open_at: string | null
  close_at: string | null
  is_holiday: boolean | number
}

export interface CompanyWorker {
  id: number
  user_id: number
  company_id: number
  experience_years: number
  rating: number | string
  status?: string | null
  is_leader?: boolean
  user?: {
    id: number
    fullname: string
    email: string
    profile?: {
      phone?: string | null
      image?: string | null
      address?: string | null
    } | null
  } | null
}

export interface CompanyReview {
  id: number
  comment: string | null
  rating: number | string
  created_at: string
  client?: {
    fullname?: string
    profile?: { image?: string | null } | null
  } | null
}

export interface CompanyListItem {
  id: number
  manager_id: number
  region_id: number
  name_ar: string
  name_en: string
  description_ar?: string | null
  description_en?: string | null
  image: string | null
  location_ar?: string | null
  location_en?: string | null
  rating: number | string
  region?: Region | null
  work_times?: CompanyWorkTime[]
  created_at: string
  updated_at: string
}

export interface CompanyDetails extends CompanyListItem {
  services: ServiceListItem[]
  workers: CompanyWorker[]
  reviews: CompanyReview[]
}
