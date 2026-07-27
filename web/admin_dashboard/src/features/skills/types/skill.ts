export interface Skill {
  id: number
  name_ar: string
  name_en: string
  created_at: string
  updated_at: string
}

export interface SkillFormValues {
  name_ar: string
  name_en: string
}

export interface SkillFilters {
  search?: string
}
