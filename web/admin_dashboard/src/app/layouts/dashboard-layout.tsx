import {
  ChevronLeft,
  ChevronRight,
  LogOut,
  Menu,
  PanelLeftClose,
  PanelLeftOpen,
  X,
} from 'lucide-react'
import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { NavLink, Outlet, useLocation, useNavigate } from 'react-router-dom'
import { navigationItems } from '../../config/navigation'
import { authApi } from '../../features/auth/api/auth-api'
import { useAuthStore } from '../../core/auth/auth-store'
import { getInitials } from '../../core/utils/formatters'
import { Button } from '../../core/components/button'
import { useToast } from '../../core/components/toast'
import { routePaths } from '../router/route-paths'
import { LanguageToggle, ThemeToggle } from './preference-controls'

const collapsedKey = 'cleanlink-admin-sidebar-collapsed'

export function DashboardLayout() {
  const { t, i18n } = useTranslation()
  const navigate = useNavigate()
  const location = useLocation()
  const user = useAuthStore((state) => state.user)
  const clearSession = useAuthStore((state) => state.clearSession)
  const { showToast } = useToast()
  const [mobileOpen, setMobileOpen] = useState(false)
  const [collapsed, setCollapsed] = useState(
    () => window.localStorage.getItem(collapsedKey) === 'true',
  )
  const [loggingOut, setLoggingOut] = useState(false)

  useEffect(() => {
    window.localStorage.setItem(collapsedKey, String(collapsed))
  }, [collapsed])

  useEffect(() => {
    const expired = () => navigate(routePaths.login, { replace: true })
    window.addEventListener('cleanlink:session-expired', expired)
    return () => window.removeEventListener('cleanlink:session-expired', expired)
  }, [navigate])

  const logout = async () => {
    setLoggingOut(true)
    try {
      await authApi.logout()
    } catch {
      showToast({
        kind: 'info',
        title: t('feedback.networkTitle'),
        message: t('feedback.networkDescription'),
      })
    } finally {
      clearSession()
      navigate(routePaths.login, { replace: true })
    }
  }

  const activeItem = navigationItems.find((item) =>
    location.pathname.startsWith(item.path),
  )
  const DirectionIcon =
    i18n.dir() === 'rtl' ? ChevronLeft : ChevronRight

  return (
    <div
      className={`dashboard-shell ${collapsed ? 'dashboard-shell--collapsed' : ''}`}
    >
      <a className="skip-link" href="#main-content">
        {t('app.skipToContent')}
      </a>
      {mobileOpen ? (
        <button
          className="mobile-overlay"
          type="button"
          aria-label={t('nav.close')}
          onClick={() => setMobileOpen(false)}
        />
      ) : null}
      <aside
        className={`sidebar ${mobileOpen ? 'sidebar--mobile-open' : ''}`}
        aria-label={t('app.admin')}
      >
        <div className="sidebar__brand">
          <div className="brand-mark" aria-hidden="true">
            <span />
            <span />
          </div>
          <div className="sidebar__brand-copy">
            <strong>{t('app.name')}</strong>
            <span>{t('app.admin')}</span>
          </div>
          <Button
            className="sidebar__mobile-close"
            variant="ghost"
            iconOnly
            aria-label={t('nav.close')}
            onClick={() => setMobileOpen(false)}
          >
            <X size={19} />
          </Button>
        </div>

        <nav className="sidebar__nav">
          {navigationItems.map((item, index) => {
            const Icon = item.icon
            const previousSection = navigationItems[index - 1]?.sectionKey
            return (
              <div className="sidebar__nav-item" key={item.path}>
                {item.sectionKey !== previousSection ? (
                  <span className="sidebar__section-label">
                    {t(item.sectionKey)}
                  </span>
                ) : null}
                <NavLink
                  className={({ isActive }) =>
                    `sidebar__link ${isActive ? 'sidebar__link--active' : ''}`
                  }
                  to={item.path}
                  title={collapsed ? t(item.labelKey) : undefined}
                  onClick={() => setMobileOpen(false)}
                >
                  <Icon size={19} aria-hidden="true" />
                  <span>{t(item.labelKey)}</span>
                </NavLink>
              </div>
            )
          })}
        </nav>

        <div className="sidebar__footer">
          <button
            className="sidebar__profile"
            type="button"
            onClick={() => navigate(routePaths.profile)}
          >
            <span className="sidebar__avatar">
              {getInitials(user?.fullname ?? 'Admin')}
            </span>
            <span className="sidebar__profile-copy">
              <strong>{user?.fullname}</strong>
              <small>{user?.email}</small>
            </span>
            <DirectionIcon size={16} aria-hidden="true" />
          </button>
          <Button
            className="sidebar__logout"
            variant="ghost"
            loading={loggingOut}
            onClick={() => void logout()}
            title={collapsed ? t('nav.logout') : undefined}
          >
            <LogOut size={19} />
            <span>{t('nav.logout')}</span>
          </Button>
        </div>
      </aside>

      <div className="dashboard-content">
        <header className="topbar">
          <div className="topbar__start">
            <Button
              className="topbar__mobile-menu"
              variant="ghost"
              iconOnly
              aria-label={t('nav.open')}
              onClick={() => setMobileOpen(true)}
            >
              <Menu size={21} />
            </Button>
            <Button
              className="topbar__collapse"
              variant="ghost"
              iconOnly
              aria-label={t(collapsed ? 'nav.expand' : 'nav.collapse')}
              onClick={() => setCollapsed((current) => !current)}
            >
              {collapsed ? (
                <PanelLeftOpen size={20} />
              ) : (
                <PanelLeftClose size={20} />
              )}
            </Button>
            <div className="breadcrumbs" aria-label="Breadcrumb">
              <span>{t('app.admin')}</span>
              <DirectionIcon size={14} aria-hidden="true" />
              <strong>{activeItem ? t(activeItem.labelKey) : ''}</strong>
            </div>
          </div>
          <div className="topbar__actions">
            <ThemeToggle />
            <LanguageToggle />
            <button
              className="topbar__profile"
              type="button"
              aria-label={t('nav.profile')}
              onClick={() => navigate(routePaths.profile)}
            >
              {getInitials(user?.fullname ?? 'Admin')}
            </button>
          </div>
        </header>
        <main className="main-content" id="main-content" tabIndex={-1}>
          <Outlet />
        </main>
      </div>
    </div>
  )
}
