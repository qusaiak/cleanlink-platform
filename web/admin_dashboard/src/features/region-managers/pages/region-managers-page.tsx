import {
  keepPreviousData,
  useMutation,
  useQuery,
  useQueryClient,
} from '@tanstack/react-query'
import { Plus, Trash2 } from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { normalizeApiError } from '../../../core/api/api-error'
import { Button } from '../../../core/components/button'
import { DataTable, type DataColumn } from '../../../core/components/data-table'
import { FilterToolbar } from '../../../core/components/filter-toolbar'
import { SearchInput } from '../../../core/components/form-controls'
import { ConfirmationDialog } from '../../../core/components/modal'
import { PageHeader } from '../../../core/components/page-header'
import { useToast } from '../../../core/components/toast'
import { formatDate, getInitials } from '../../../core/utils/formatters'
import { useListQueryState } from '../../../core/utils/use-list-query-state'
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
  const listState = useListQueryState()
  const [formOpen, setFormOpen] = useState(false)
  const [deleting, setDeleting] = useState<RegionManager | null>(null)
  const filters = { search: listState.search || undefined }
  const query = useQuery({
    queryKey: regionManagerKeys.list(filters),
    queryFn: ({ signal }) => regionManagersApi.search(filters, signal),
    placeholderData: keepPreviousData,
  })
  const rows = query.data ?? []

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
          <span className="entity__avatar">{getInitials(manager.fullname)}</span>
          <div className="entity__details">
            <strong>{manager.fullname}</strong>
            <span>#{manager.id}</span>
          </div>
        </div>
      ),
    },
    { key: 'email', header: t('managers.email'), render: (item) => item.email },
    {
      key: 'created',
      header: t('managers.created'),
      render: (item) => formatDate(item.created_at),
    },
    {
      key: 'actions',
      header: t('managers.actions'),
      align: 'end',
      render: (manager) => (
        <Button
          variant="ghost"
          iconOnly
          aria-label={`${t('actions.delete')} ${manager.fullname}`}
          onClick={() => setDeleting(manager)}
        >
          <Trash2 size={17} />
        </Button>
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
        total={rows.length}
        loading={query.isLoading}
        fetching={query.isFetching}
        error={query.error ? normalizeApiError(query.error) : null}
        onRetry={() => void query.refetch()}
        emptyTitle={
          listState.search
            ? t('managers.noResultsTitle')
            : t('managers.emptyTitle')
        }
        emptyDescription={
          listState.search
            ? t('managers.noResultsDescription')
            : t('managers.emptyDescription')
        }
        toolbar={
          <FilterToolbar
            resultCount={rows.length}
            fetching={query.isFetching}
            hasFilters={Boolean(listState.search)}
            onClear={() => {
              listState.setSearchInput('')
              listState.commitSearch('')
            }}
            onRefresh={() => void query.refetch()}
          >
            <SearchInput
              value={listState.searchInput}
              onChange={listState.setSearchInput}
              onSearch={listState.commitSearch}
              loading={query.isFetching && !query.isLoading}
              placeholder={t('managers.searchPlaceholder')}
            />
          </FilterToolbar>
        }
      />
      <RegionManagerForm open={formOpen} onClose={() => setFormOpen(false)} />
      <ConfirmationDialog
        open={Boolean(deleting)}
        title={t('managers.deleteTitle')}
        description={t('managers.deleteDescription', {
          name: deleting?.fullname ?? '',
        })}
        loading={deleteMutation.isPending}
        onCancel={() => setDeleting(null)}
        onConfirm={() => deleting && deleteMutation.mutate(deleting.id)}
      />
    </>
  )
}
