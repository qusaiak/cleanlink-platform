import {
  keepPreviousData,
  useMutation,
  useQuery,
  useQueryClient,
} from '@tanstack/react-query'
import { Eye, Pencil, Plus, Trash2 } from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'
import { routePaths } from '../../../app/router/route-paths'
import { normalizeApiError } from '../../../core/api/api-error'
import { Button } from '../../../core/components/button'
import { DataTable, type DataColumn } from '../../../core/components/data-table'
import { FilterToolbar } from '../../../core/components/filter-toolbar'
import { SearchInput } from '../../../core/components/form-controls'
import { ConfirmationDialog } from '../../../core/components/modal'
import { PageHeader } from '../../../core/components/page-header'
import { useToast } from '../../../core/components/toast'
import {
  formatDate,
  getInitials,
  resolveImageUrl,
} from '../../../core/utils/formatters'
import { useListQueryState } from '../../../core/utils/use-list-query-state'
import { regionKeys, regionsApi } from '../api/regions-api'
import { RegionForm } from '../components/region-form'
import type { Region } from '../types/region'

export default function RegionsPage() {
  const { t, i18n } = useTranslation()
  const queryClient = useQueryClient()
  const { showToast } = useToast()
  const listState = useListQueryState()
  const [formOpen, setFormOpen] = useState(false)
  const [editing, setEditing] = useState<Region | null>(null)
  const [deleting, setDeleting] = useState<Region | null>(null)
  const isArabic = i18n.language.startsWith('ar')
  const nameOf = (region: Region) =>
    isArabic ? region.name_ar : region.name_en
  const filters = { search: listState.search || undefined }
  const query = useQuery({
    queryKey: regionKeys.list(filters),
    queryFn: ({ signal }) => regionsApi.search(filters, signal),
    placeholderData: keepPreviousData,
  })
  const rows = query.data ?? []

  const deleteMutation = useMutation({
    mutationFn: regionsApi.delete,
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: regionKeys.all })
      showToast({ kind: 'success', title: t('regions.deletedSuccess') })
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

  const columns: DataColumn<Region>[] = [
    {
      key: 'name',
      header: t('regions.name'),
      render: (region) => {
        const image = resolveImageUrl(region.image)
        const name = nameOf(region)
        return (
          <div className="entity">
            <span className="entity__avatar">
              {image ? <img src={image} alt="" /> : getInitials(name)}
            </span>
            <div className="entity__details">
              <strong>{name}</strong>
              <span>{isArabic ? region.name_en : region.name_ar}</span>
            </div>
          </div>
        )
      },
    },
    {
      key: 'manager',
      header: t('regions.manager'),
      render: (region) => region.manager?.fullname || '—',
    },
    {
      key: 'created',
      header: t('regions.created'),
      render: (region) => formatDate(region.created_at),
    },
    {
      key: 'actions',
      header: t('regions.actions'),
      align: 'end',
      render: (region) => (
        <div className="table-actions">
          <Link
            className="button button--ghost button--icon"
            to={`${routePaths.regionDetail(region.id)}?${listState.params}`}
            aria-label={`${t('actions.view')} ${nameOf(region)}`}
          >
            <Eye size={17} />
          </Link>
          <Button
            variant="ghost"
            iconOnly
            aria-label={`${t('actions.edit')} ${nameOf(region)}`}
            onClick={() => {
              setEditing(region)
              setFormOpen(true)
            }}
          >
            <Pencil size={17} />
          </Button>
          <Button
            variant="ghost"
            iconOnly
            aria-label={`${t('actions.delete')} ${nameOf(region)}`}
            onClick={() => setDeleting(region)}
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
        title={t('regions.title')}
        description={t('regions.description')}
        actions={
          <Button
            onClick={() => {
              setEditing(null)
              setFormOpen(true)
            }}
          >
            <Plus size={18} />
            {t('regions.add')}
          </Button>
        }
      />
      <DataTable
        data={rows}
        columns={columns}
        getRowKey={(region) => region.id}
        total={rows.length}
        loading={query.isLoading}
        fetching={query.isFetching}
        error={query.error ? normalizeApiError(query.error) : null}
        onRetry={() => void query.refetch()}
        emptyTitle={
          listState.search ? t('regions.noResultsTitle') : t('regions.emptyTitle')
        }
        emptyDescription={
          listState.search
            ? t('regions.noResultsDescription')
            : t('regions.emptyDescription')
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
              placeholder={t('regions.searchPlaceholder')}
            />
          </FilterToolbar>
        }
      />
      <RegionForm
        open={formOpen}
        region={editing}
        onClose={() => {
          setFormOpen(false)
          setEditing(null)
        }}
      />
      <ConfirmationDialog
        open={Boolean(deleting)}
        title={t('regions.deleteTitle')}
        description={t('regions.deleteDescription', {
          name: deleting ? nameOf(deleting) : '',
        })}
        loading={deleteMutation.isPending}
        onCancel={() => setDeleting(null)}
        onConfirm={() => deleting && deleteMutation.mutate(deleting.id)}
      />
    </>
  )
}
