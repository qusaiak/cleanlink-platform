import { Ban, CircleOff } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import { Link, useLocation } from 'react-router-dom'
import { routePaths } from '../../../app/router/route-paths'

export default function ErrorPage() {
  const { t } = useTranslation()
  const location = useLocation()
  const forbidden = location.pathname === routePaths.forbidden
  const Icon = forbidden ? Ban : CircleOff

  return (
    <main className="standalone-error">
      <div className="feedback-state__icon">
        <Icon size={25} />
      </div>
      <p className="page-header__eyebrow">{forbidden ? '403' : '404'}</p>
      <h1>{t('errors.pageTitle')}</h1>
      <p>
        {t(forbidden ? 'errors.forbiddenPage' : 'errors.notFoundPage')}
      </p>
      <Link className="button button--primary" to={routePaths.dashboard}>
        {t('actions.backToDashboard')}
      </Link>
    </main>
  )
}
