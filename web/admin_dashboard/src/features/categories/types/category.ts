export interface Category {
  id: number
  name: string
  description: string | null
  image: string | null
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
