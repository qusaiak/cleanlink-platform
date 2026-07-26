import { lazy, Suspense } from 'react'
import { Navigate, Route, Routes } from 'react-router-dom'
import { PageSkeleton } from '../../core/components/feedback'
import { AuthLayout } from '../layouts/auth-layout'
import { DashboardLayout } from '../layouts/dashboard-layout'
import { ProtectedRoute } from './protected-route'
import { PublicRoute } from './public-route'
import { routePaths } from './route-paths'

const LoginPage = lazy(() => import('../../features/auth/pages/login-page'))
const DashboardPage = lazy(
  () => import('../../features/dashboard/pages/dashboard-page'),
)
const RegionManagersPage = lazy(
  () =>
    import('../../features/region-managers/pages/region-managers-page'),
)
const CategoriesPage = lazy(
  () => import('../../features/categories/pages/categories-page'),
)
const RegionsPage = lazy(
  () => import('../../features/regions/pages/regions-page'),
)
const ProfilePage = lazy(
  () => import('../../features/profile/pages/profile-page'),
)
const ErrorPage = lazy(() => import('../../features/errors/pages/error-page'))

const loading = (
  <main style={{ padding: 28 }}>
    <PageSkeleton />
  </main>
)

export function AppRouter() {
  return (
    <Suspense fallback={loading}>
      <Routes>
        <Route element={<PublicRoute />}>
          <Route element={<AuthLayout />}>
            <Route path={routePaths.login} element={<LoginPage />} />
          </Route>
        </Route>

        <Route element={<ProtectedRoute />}>
          <Route element={<DashboardLayout />}>
            <Route path={routePaths.dashboard} element={<DashboardPage />} />
            <Route
              path={routePaths.regionManagers}
              element={<RegionManagersPage />}
            />
            <Route path={routePaths.categories} element={<CategoriesPage />} />
            <Route path={routePaths.regions} element={<RegionsPage />} />
            <Route path={routePaths.profile} element={<ProfilePage />} />
          </Route>
        </Route>

        <Route path={routePaths.forbidden} element={<ErrorPage />} />
        <Route path={routePaths.notFound} element={<ErrorPage />} />
        <Route
          path="/"
          element={<Navigate replace to={routePaths.dashboard} />}
        />
        <Route path="*" element={<Navigate replace to={routePaths.notFound} />} />
      </Routes>
    </Suspense>
  )
}
