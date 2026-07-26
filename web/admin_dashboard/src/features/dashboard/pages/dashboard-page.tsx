import { useQuery } from '@tanstack/react-query'
import {
  ArrowUpRight,
  Map,
  Plus,
  Shapes,
  UserCog,
} from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'
import { routePaths } from '../../../app/router/route-paths'
import { normalizeApiError } from '../../../core/api/api-error'
import { useAuthStore } from '../../../core/auth/auth-store'
import { ErrorState, PageSkeleton } from '../../../core/components/feedback'
import { PageHeader } from '../../../core/components/page-header'
import { formatNumber } from '../../../core/utils/formatters'
import { categoriesApi } from '../../categories/api/categories-api'
import { regionManagersApi } from '../../region-managers/api/region-managers-api'
import { regionsApi } from '../../regions/api/regions-api'
import './dashboard-page.css'

interface SummaryCardProps {
  label: string
  value: number
  icon: LucideIcon
  path: string
}

function SummaryCard({ label, value, icon: Icon, path }: SummaryCardProps) {
  return (
    <Link className="summary-card" to={path}>
      <div className="summary-card__top">
        <span className="summary-card__icon">
          <Icon size={21} />
        </span>
        <ArrowUpRight size={17} aria-hidden="true" />
      </div>
      <strong>{formatNumber(value)}</strong>
      <span>{label}</span>
    </Link>
  )
}

export default function DashboardPage() {
  const { t, i18n } = useTranslation()
  const user = useAuthStore((state) => state.user)
  const language = i18n.language.startsWith('ar') ? 'ar' : 'en'
  const query = useQuery({
    queryKey: ['dashboard', 'admin-summary', language],
    queryFn: async ({ signal }) => {
      const [managers, categories, regions] = await Promise.all([
        regionManagersApi.list(signal),
        categoriesApi.list(signal),
        regionsApi.list(signal),
      ])
      return {
        managers: managers.length,
        categories: categories.length,
        regions: regions.length,
      }
    },
  })

  if (query.isLoading) return <PageSkeleton />
  if (query.error) {
    return (
      <ErrorState
        error={normalizeApiError(query.error)}
        onRetry={() => void query.refetch()}
      />
    )
  }

  const summary = query.data ?? { managers: 0, categories: 0, regions: 0 }

  return (
    <>
      <PageHeader
        title={
          user?.fullname
            ? t('dashboard.welcome', { name: user.fullname })
            : t('dashboard.welcomeFallback')
        }
        description={t('dashboard.description')}
      />
      <section className="dashboard-section" aria-labelledby="overview-title">
        <div className="section-heading">
          <div>
            <h2 id="overview-title">{t('dashboard.overview')}</h2>
            <p>{t('dashboard.overviewHint')}</p>
          </div>
          {query.isFetching ? (
            <span className="refresh-indicator">
              <span className="inline-spinner" />
              {t('feedback.refreshing')}
            </span>
          ) : null}
        </div>
        <div className="summary-grid">
          <SummaryCard
            label={t('dashboard.totalManagers')}
            value={summary.managers}
            icon={UserCog}
            path={routePaths.regionManagers}
          />
          <SummaryCard
            label={t('dashboard.totalCategories')}
            value={summary.categories}
            icon={Shapes}
            path={routePaths.categories}
          />
          <SummaryCard
            label={t('dashboard.totalRegions')}
            value={summary.regions}
            icon={Map}
            path={routePaths.regions}
          />
        </div>
      </section>

      <section className="dashboard-section" aria-labelledby="quick-title">
        <div className="section-heading">
          <div>
            <h2 id="quick-title">{t('dashboard.quickActions')}</h2>
            <p>{t('dashboard.quickActionsHint')}</p>
          </div>
        </div>
        <div className="quick-actions">
          <Link to={routePaths.regionManagers}>
            <span><UserCog size={20} /></span>
            <strong>{t('dashboard.addManager')}</strong>
            <Plus size={17} />
          </Link>
          <Link to={routePaths.categories}>
            <span><Shapes size={20} /></span>
            <strong>{t('dashboard.addCategory')}</strong>
            <Plus size={17} />
          </Link>
          <Link to={routePaths.regions}>
            <span><Map size={20} /></span>
            <strong>{t('dashboard.addRegion')}</strong>
            <Plus size={17} />
          </Link>
        </div>
        <p className="dashboard-limitation">{t('dashboard.limitedStats')}</p>
      </section>
    </>
  )
}
