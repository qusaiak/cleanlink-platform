import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { Plus, Trash2, UserCog } from 'lucide-react'
import { useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { appConfig } from '../../../config/app-config'
import { normalizeApiError } from '../../../core/api/api-error'
import { Button } from '../../../core/components/button'
import {
  DataTable,
  type DataColumn,
} from '../../../core/components/data-table'
import { SearchInput } from '../../../core/components/form-controls'
import { ConfirmationDialog } from '../../../core/components/modal'
import { PageHeader } from '../../../core/components/page-header'
import { useToast } from '../../../core/components/toast'
import {
  formatDate,
  getInitials,
} from '../../../core/utils/formatters'
import {
  regionManagerKeys,
  regionManagersApi,
} from '../api/region-managers-api'
import { RegionManagerForm } from '../components/region-manager-form'
import type { RegionManager } from '../types/region-manager'

export default function RegionManagersPage() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const { showToast } = useToast()
  const [search, setSearch] = useState('')
  const [page, setPage] = useState(1)
  const [formOpen, setFormOpen] = useState(false)
  const [deleting, setDeleting] = useState<RegionManager | null>(null)
  const query = useQuery({
    queryKey: regionManagerKeys.list(),
    queryFn: ({ signal }) => regionManagersApi.list(signal),
  })

  const filtered = useMemo(() => {
    const term = search.trim().toLocaleLowerCase()
    if (!term) return query.data ?? []
    return (query.data ?? []).filter((manager) =>
      `${manager.fullname} ${manager.email}`
        .toLocaleLowerCase()
        .includes(term),
    )
  }, [query.data, search])
  const pageCount = Math.max(
    1,
    Math.ceil(filtered.length / appConfig.defaultPageSize),
  )
  const activePage = Math.min(page, pageCount)
  const rows = filtered.slice(
    (activePage - 1) * appConfig.defaultPageSize,
    activePage * appConfig.defaultPageSize,
  )

  const deleteMutation = useMutation({
    mutationFn: regionManagersApi.delete,
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: regionManagerKeys.all })
      showToast({ kind: 'success', title: t('managers.deletedSuccess') })
      setDeleting(null)
    },
    onError: (error) => {
      const normalized = normalizeApiError(error)
      showToast({
        kind: 'error',
        title: t('feedback.unknownTitle'),
        message: normalized.message,
      })
    },
  })

  const columns: DataColumn<RegionManager>[] = [
    {
      key: 'name',
      header: t('managers.name'),
      render: (manager) => (
        <div className="entity">
          <span className="entity__avatar">
            {getInitials(manager.fullname)}
          </span>
          <div className="entity__details">
            <strong>{manager.fullname}</strong>
            <span>#{manager.id}</span>
          </div>
        </div>
      ),
    },
    {
      key: 'email',
      header: t('managers.email'),
      render: (manager) => manager.email,
    },
    {
      key: 'phone',
      header: t('managers.phone'),
      render: (manager) => manager.profile?.phone || '—',
    },
    {
      key: 'created',
      header: t('managers.created'),
      render: (manager) => formatDate(manager.created_at),
    },
    {
      key: 'actions',
      header: t('managers.actions'),
      align: 'end',
      render: (manager) => (
        <div className="table-actions">
          <Button
            variant="ghost"
            iconOnly
            aria-label={`${t('actions.delete')} ${manager.fullname}`}
            disabled={
              deleteMutation.isPending && deleting?.id === manager.id
            }
            onClick={() => setDeleting(manager)}
          >
            <Trash2 size={17} />
          </Button>
        </div>
      ),
    },
  ]

  return (
    <>
      <PageHeader
        title={t('managers.title')}
        description={t('managers.description')}
        actions={
          <Button onClick={() => setFormOpen(true)}>
            <Plus size={18} />
            {t('managers.add')}
          </Button>
        }
      />
      <DataTable
        data={rows}
        columns={columns}
        getRowKey={(manager) => manager.id}
        page={activePage}
        pageCount={pageCount}
        total={filtered.length}
        onPageChange={setPage}
        loading={query.isLoading}
        error={query.error ? normalizeApiError(query.error) : null}
        onRetry={() => void query.refetch()}
        emptyTitle={
          search ? t('managers.noResultsTitle') : t('managers.emptyTitle')
        }
        emptyDescription={
          search
            ? t('managers.noResultsDescription')
            : t('managers.emptyDescription')
        }
        toolbar={
          <>
            <SearchInput
              value={search}
              onChange={(value) => {
                setSearch(value)
                setPage(1)
              }}
              placeholder={t('managers.searchPlaceholder')}
            />
            <span className="table-toolbar__meta">
              <UserCog size={15} aria-hidden="true" />{' '}
              {t('table.results', { count: filtered.length })}
            </span>
          </>
        }
      />
      <RegionManagerForm
        open={formOpen}
        onClose={() => setFormOpen(false)}
      />
      <ConfirmationDialog
        open={Boolean(deleting)}
        title={t('managers.deleteTitle')}
        description={t('managers.deleteDescription', {
          name: deleting?.fullname ?? '',
        })}
        loading={deleteMutation.isPending}
        onCancel={() => setDeleting(null)}
        onConfirm={() => {
          if (deleting) deleteMutation.mutate(deleting.id)
        }}
      />
    </>
  )
}
