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
const CategoryDetailsPage = lazy(
  () => import('../../features/categories/pages/category-details-page'),
)
const RegionsPage = lazy(
  () => import('../../features/regions/pages/regions-page'),
)
const RegionDetailsPage = lazy(
  () => import('../../features/regions/pages/region-details-page'),
)
const CompaniesPage = lazy(
  () => import('../../features/companies/pages/companies-page'),
)
const CompanyDetailsPage = lazy(
  () => import('../../features/companies/pages/company-details-page'),
)
const ServicesPage = lazy(
  () => import('../../features/services/pages/services-page'),
)
const ServiceDetailsPage = lazy(
  () => import('../../features/services/pages/service-details-page'),
)
const SkillsPage = lazy(
  () => import('../../features/skills/pages/skills-page'),
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
            <Route path="/categories/:categoryId" element={<CategoryDetailsPage />} />
            <Route path={routePaths.regions} element={<RegionsPage />} />
            <Route path="/regions/:regionId" element={<RegionDetailsPage />} />
            <Route path={routePaths.companies} element={<CompaniesPage />} />
            <Route path="/companies/:companyId" element={<CompanyDetailsPage />} />
            <Route path={routePaths.services} element={<ServicesPage />} />
            <Route path="/services/:serviceId" element={<ServiceDetailsPage />} />
            <Route path={routePaths.skills} element={<SkillsPage />} />
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
