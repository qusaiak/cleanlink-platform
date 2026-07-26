import { create } from 'zustand'
import { authStorage } from './auth-storage'
import type { AuthSession, AuthUser } from './auth-types'

interface AuthState {
  token: string | null
  user: AuthUser | null
  initialized: boolean
  setSession: (session: AuthSession, remember: boolean) => void
  updateUser: (user: AuthUser) => void
  clearSession: () => void
}

const savedSession = authStorage.get()

export const useAuthStore = create<AuthState>((set) => ({
  token: savedSession?.token ?? null,
  user: savedSession?.user ?? null,
  initialized: true,
  setSession: (session, remember) => {
    authStorage.set(session, remember)
    set({ token: session.token, user: session.user })
  },
  updateUser: (user) => {
    const token = useAuthStore.getState().token
    if (token) {
      authStorage.set({ token, user }, authStorage.isPersistent())
    }
    set({ user })
  },
  clearSession: () => {
    authStorage.clear()
    set({ token: null, user: null })
  },
}))
