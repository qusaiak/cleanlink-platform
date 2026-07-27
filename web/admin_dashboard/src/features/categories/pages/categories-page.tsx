import {
  keepPreviousData,
  useMutation,
  useQuery,
  useQueryClient,
} from '@tanstack/react-query'
import { Eye, Plus, Trash2 } from 'lucide-react'
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
import { categoriesApi, categoryKeys } from '../api/categories-api'
import { CategoryForm } from '../components/category-form'
import type { AdminCategory } from '../types/category'

export default function CategoriesPage() {
  const { t, i18n } = useTranslation()
  const queryClient = useQueryClient()
  const { showToast } = useToast()
  const listState = useListQueryState()
  const [formOpen, setFormOpen] = useState(false)
  const [deleting, setDeleting] = useState<AdminCategory | null>(null)
  const isArabic = i18n.language.startsWith('ar')
  const nameOf = (category: AdminCategory) =>
    isArabic ? category.name_ar : category.name_en
  const descriptionOf = (category: AdminCategory) =>
    isArabic ? category.description_ar : category.description_en
  const filters = { search: listState.search || undefined }
  const query = useQuery({
    queryKey: categoryKeys.list(filters),
    queryFn: ({ signal }) => categoriesApi.search(filters, signal),
    placeholderData: keepPreviousData,
  })
  const rows = query.data ?? []

  const deleteMutation = useMutation({
    mutationFn: categoriesApi.delete,
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: categoryKeys.all })
      showToast({ kind: 'success', title: t('categories.deletedSuccess') })
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

  const columns: DataColumn<AdminCategory>[] = [
    {
      key: 'name',
      header: t('categories.name'),
      render: (category) => {
        const image = resolveImageUrl(category.image)
        const name = nameOf(category)
        return (
          <div className="entity">
            <span className="entity__avatar">
              {image ? <img src={image} alt="" /> : getInitials(name)}
            </span>
            <div className="entity__details">
              <strong>{name}</strong>
              <span>{isArabic ? category.name_en : category.name_ar}</span>
            </div>
          </div>
        )
      },
    },
    {
      key: 'description',
      header: t('categories.descriptionLabel'),
      render: (category) => descriptionOf(category) || '—',
    },
    {
      key: 'created',
      header: t('categories.created'),
      render: (category) => formatDate(category.created_at),
    },
    {
      key: 'actions',
      header: t('categories.actions'),
      align: 'end',
      render: (category) => (
        <div className="table-actions">
          <Link
            className="button button--ghost button--icon"
            to={`${routePaths.categoryDetail(category.id)}?${listState.params}`}
            aria-label={`${t('actions.view')} ${nameOf(category)}`}
          >
            <Eye size={17} />
          </Link>
          <Button
            variant="ghost"
            iconOnly
            aria-label={`${t('actions.delete')} ${nameOf(category)}`}
            onClick={() => setDeleting(category)}
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
        title={t('categories.title')}
        description={t('categories.description')}
        actions={
          <Button onClick={() => setFormOpen(true)}>
            <Plus size={18} />
            {t('categories.add')}
          </Button>
        }
      />
      <DataTable
        data={rows}
        columns={columns}
        getRowKey={(category) => category.id}
        total={rows.length}
        loading={query.isLoading}
        fetching={query.isFetching}
        error={query.error ? normalizeApiError(query.error) : null}
        onRetry={() => void query.refetch()}
        emptyTitle={
          listState.search
            ? t('categories.noResultsTitle')
            : t('categories.emptyTitle')
        }
        emptyDescription={
          listState.search
            ? t('categories.noResultsDescription')
            : t('categories.emptyDescription')
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
              placeholder={t('categories.searchPlaceholder')}
            />
          </FilterToolbar>
        }
      />
      <CategoryForm open={formOpen} onClose={() => setFormOpen(false)} />
      <ConfirmationDialog
        open={Boolean(deleting)}
        title={t('categories.deleteTitle')}
        description={t('categories.deleteDescription', {
          name: deleting ? nameOf(deleting) : '',
        })}
        loading={deleteMutation.isPending}
        onCancel={() => setDeleting(null)}
        onConfirm={() => deleting && deleteMutation.mutate(deleting.id)}
      />
    </>
  )
}
