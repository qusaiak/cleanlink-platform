import { Navigate, Outlet } from 'react-router-dom'
import { useAuthStore } from '../../core/auth/auth-store'
import { routePaths } from './route-paths'

export function PublicRoute() {
  const token = useAuthStore((state) => state.token)
  const user = useAuthStore((state) => state.user)

  return token && user?.role === 'admin' ? (
    <Navigate replace to={routePaths.dashboard} />
  ) : (
    <Outlet />
  )
}
