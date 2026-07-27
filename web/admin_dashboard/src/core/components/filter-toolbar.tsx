import { RefreshCw, SlidersHorizontal, X } from 'lucide-react'
import type { ReactNode } from 'react'
import { useTranslation } from 'react-i18next'
import { Button } from './button'

interface FilterToolbarProps {
  children: ReactNode
  resultCount: number
  hasFilters?: boolean
  fetching?: boolean
  onClear?: () => void
  onRefresh: () => void
}

export function FilterToolbar({
  children,
  resultCount,
  hasFilters = false,
  fetching = false,
  onClear,
  onRefresh,
}: FilterToolbarProps) {
  const { t } = useTranslation()

  return (
    <div className="filter-toolbar">
      <div className="filter-toolbar__controls">{children}</div>
      <div className="filter-toolbar__summary">
        <span className="filter-toolbar__count" aria-live="polite">
          <SlidersHorizontal size={15} aria-hidden="true" />
          {t('table.results', { count: resultCount })}
        </span>
        {hasFilters && onClear ? (
          <Button variant="ghost" onClick={onClear}>
            <X size={16} />
            {t('actions.clearFilters')}
          </Button>
        ) : null}
        <Button
          variant="ghost"
          iconOnly
          loading={fetching}
          aria-label={t('actions.refresh')}
          onClick={onRefresh}
        >
          <RefreshCw size={17} />
        </Button>
      </div>
    </div>
  )
}
