import { ChevronLeft, ChevronRight } from 'lucide-react'
import type { ReactNode } from 'react'
import { useTranslation } from 'react-i18next'
import { Button } from './button'
import { EmptyState, ErrorState } from './feedback'
import type { ApiError } from '../api/api-error'

export interface DataColumn<T> {
  key: string
  header: string
  render: (item: T) => ReactNode
  align?: 'start' | 'end'
}

interface DataTableProps<T> {
  data: T[]
  columns: DataColumn<T>[]
  getRowKey: (item: T) => string | number
  page: number
  pageCount: number
  total: number
  onPageChange: (page: number) => void
  loading?: boolean
  error?: ApiError | null
  onRetry?: () => void
  emptyTitle: string
  emptyDescription: string
  toolbar?: ReactNode
}

export function DataTable<T>({
  data,
  columns,
  getRowKey,
  page,
  pageCount,
  total,
  onPageChange,
  loading,
  error,
  onRetry,
  emptyTitle,
  emptyDescription,
  toolbar,
}: DataTableProps<T>) {
  const { t, i18n } = useTranslation()
  const PreviousIcon = i18n.dir() === 'rtl' ? ChevronRight : ChevronLeft
  const NextIcon = i18n.dir() === 'rtl' ? ChevronLeft : ChevronRight

  if (error) return <ErrorState error={error} onRetry={onRetry} />
  if (!loading && data.length === 0 && total === 0) {
    return (
      <section className="table-shell">
        {toolbar ? <div className="table-toolbar">{toolbar}</div> : null}
        <EmptyState title={emptyTitle} description={emptyDescription} />
      </section>
    )
  }

  return (
    <section className="table-shell" aria-busy={loading}>
      {toolbar ? <div className="table-toolbar">{toolbar}</div> : null}
      <div className="table-scroll">
        <table className="data-table">
          <thead>
            <tr>
              {columns.map((column) => (
                <th
                  key={column.key}
                  scope="col"
                  style={{ textAlign: column.align }}
                >
                  {column.header}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {loading
              ? Array.from({ length: 6 }, (_, rowIndex) => (
                  <tr key={rowIndex}>
                    {columns.map((column) => (
                      <td key={column.key}>
                        <div className="skeleton skeleton--text" />
                      </td>
                    ))}
                  </tr>
                ))
              : data.map((item) => (
                  <tr key={getRowKey(item)}>
                    {columns.map((column) => (
                      <td
                        key={column.key}
                        style={{ textAlign: column.align }}
                      >
                        {column.render(item)}
                      </td>
                    ))}
                  </tr>
                ))}
          </tbody>
        </table>
      </div>
      <footer className="table-pagination">
        <p>
          {t('table.page', {
            current: Math.min(page, Math.max(pageCount, 1)),
            total: Math.max(pageCount, 1),
          })}{' '}
          · {t('table.results', { count: total })}
        </p>
        <div className="table-pagination__actions">
          <Button
            variant="ghost"
            disabled={page <= 1 || loading}
            onClick={() => onPageChange(page - 1)}
          >
            <PreviousIcon size={16} />
            {t('actions.previous')}
          </Button>
          <Button
            variant="ghost"
            disabled={page >= pageCount || loading}
            onClick={() => onPageChange(page + 1)}
          >
            {t('actions.next')}
            <NextIcon size={16} />
          </Button>
        </div>
      </footer>
    </section>
  )
}
