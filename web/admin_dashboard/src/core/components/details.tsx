import type { ReactNode } from 'react'
import { Link } from 'react-router-dom'
import { ChevronLeft, ChevronRight } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import { resolveImageUrl, getInitials } from '../utils/formatters'

export function Breadcrumbs({
  items,
}: {
  items: Array<{ label: string; to?: string }>
}) {
  const { i18n } = useTranslation()
  const Icon = i18n.dir() === 'rtl' ? ChevronLeft : ChevronRight
  return (
    <nav className="breadcrumbs" aria-label="Breadcrumb">
      {items.map((item, index) => (
        <span key={`${item.label}-${index}`}>
          {item.to ? <Link to={item.to}>{item.label}</Link> : <b>{item.label}</b>}
          {index < items.length - 1 ? <Icon size={14} /> : null}
        </span>
      ))}
    </nav>
  )
}

export function EntityImage({
  src,
  name,
  className = '',
}: {
  src?: string | null
  name: string
  className?: string
}) {
  const resolved = resolveImageUrl(src)
  return (
    <span className={`entity-image ${className}`}>
      {resolved ? <img src={resolved} alt={name} /> : getInitials(name)}
    </span>
  )
}

export function DetailSection({
  title,
  children,
  className = '',
}: {
  title: string
  children: ReactNode
  className?: string
}) {
  return (
    <section className={`detail-section ${className}`}>
      <h2>{title}</h2>
      {children}
    </section>
  )
}

export function DefinitionGrid({
  items,
}: {
  items: Array<{ label: string; value: ReactNode }>
}) {
  return (
    <dl className="definition-grid">
      {items.map((item) => (
        <div key={item.label}>
          <dt>{item.label}</dt>
          <dd>{item.value || '—'}</dd>
        </div>
      ))}
    </dl>
  )
}
