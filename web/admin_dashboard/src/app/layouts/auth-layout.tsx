import { Outlet } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { LanguageToggle, ThemeToggle } from './preference-controls'

export function AuthLayout() {
  const { t } = useTranslation()
  return (
    <div className="auth-layout">
      <div className="auth-layout__preferences">
        <ThemeToggle />
        <LanguageToggle />
      </div>
      <aside className="auth-layout__brand" aria-label={t('app.name')}>
        <div className="brand-mark brand-mark--large" aria-hidden="true">
          <span />
          <span />
        </div>
        <div>
          <strong>{t('app.name')}</strong>
          <p>{t('auth.secure')}</p>
        </div>
        <div className="auth-layout__pattern" aria-hidden="true" />
      </aside>
      <main className="auth-layout__main">
        <Outlet />
      </main>
    </div>
  )
}
