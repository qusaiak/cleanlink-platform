import type { AuthSession } from './auth-types'

const storageKey = 'cleanlink-admin-session'

const parseSession = (raw: string | null): AuthSession | null => {
  if (!raw) return null

  try {
    const value = JSON.parse(raw) as Partial<AuthSession>
    if (
      typeof value.token !== 'string' ||
      !value.user ||
      value.user.role !== 'admin'
    ) {
      return null
    }
    return value as AuthSession
  } catch {
    return null
  }
}

export const authStorage = {
  get(): AuthSession | null {
    return (
      parseSession(window.localStorage.getItem(storageKey)) ??
      parseSession(window.sessionStorage.getItem(storageKey))
    )
  },
  set(session: AuthSession, remember: boolean) {
    this.clear()
    const storage = remember ? window.localStorage : window.sessionStorage
    storage.setItem(storageKey, JSON.stringify(session))
  },
  isPersistent() {
    return window.localStorage.getItem(storageKey) !== null
  },
  clear() {
    window.localStorage.removeItem(storageKey)
    window.sessionStorage.removeItem(storageKey)
  },
}
