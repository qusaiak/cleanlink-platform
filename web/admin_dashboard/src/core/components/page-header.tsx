import type { ReactNode } from 'react'
import { useTranslation } from 'react-i18next'

interface PageHeaderProps {
  title: string
  description: string
  actions?: ReactNode
}

export function PageHeader({
  title,
  description,
  actions,
}: PageHeaderProps) {
  const { t } = useTranslation()
  return (
    <header className="page-header">
      <div>
        <p className="page-header__eyebrow">{t('app.admin')}</p>
        <h1>{title}</h1>
        <p className="page-header__description">{description}</p>
      </div>
      {actions}
    </header>
  )
}
