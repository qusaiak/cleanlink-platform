import { useQuery } from '@tanstack/react-query'
import { Navigate, Outlet } from 'react-router-dom'
import { PageSkeleton } from '../../core/components/feedback'
import { useAuthStore } from '../../core/auth/auth-store'
import { authApi } from '../../features/auth/api/auth-api'
import { routePaths } from './route-paths'

export function ProtectedRoute() {
  const token = useAuthStore((state) => state.token)
  const user = useAuthStore((state) => state.user)
  const updateUser = useAuthStore((state) => state.updateUser)
  const clearSession = useAuthStore((state) => state.clearSession)

  const sessionQuery = useQuery({
    queryKey: ['auth', 'me'],
    queryFn: async ({ signal }) => {
      const response = await authApi.me(signal)
      if (response.data.role !== 'admin') {
        clearSession()
        throw new Error('FORBIDDEN_ROLE')
      }
      updateUser(response.data)
      return response.data
    },
    enabled: Boolean(token),
    retry: false,
    staleTime: 5 * 60_000,
  })

  if (!token || !user) {
    return <Navigate replace to={routePaths.login} />
  }

  if (user.role !== 'admin') {
    clearSession()
    return <Navigate replace to={routePaths.forbidden} />
  }

  if (sessionQuery.isLoading) {
    return (
      <main style={{ padding: 32 }}>
        <PageSkeleton />
      </main>
    )
  }

  if (sessionQuery.error instanceof Error && sessionQuery.error.message === 'FORBIDDEN_ROLE') {
    return <Navigate replace to={routePaths.forbidden} />
  }

  return <Outlet />
}
