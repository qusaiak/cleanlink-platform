export type UserRole =
  | 'admin'
  | 'region_manager'
  | 'company_manager'
  | 'client'
  | 'worker'

export interface Profile {
  id: number
  user_id: number
  image: string | null
  address: string | null
  phone: string | null
  created_at: string
  updated_at: string
}

export interface AuthUser {
  id: number
  fullname: string
  email: string
  role: UserRole
  profile?: Profile | null
  created_at: string
  updated_at: string
}

export interface AuthSession {
  token: string
  user: AuthUser
}
