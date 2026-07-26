import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { Eye, Plus, Shapes, Trash2 } from 'lucide-react'
import { useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'
import { routePaths } from '../../../app/router/route-paths'
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
  resolveImageUrl,
} from '../../../core/utils/formatters'
import { categoriesApi, categoryKeys } from '../api/categories-api'
import { CategoryForm } from '../components/category-form'
import type { Category } from '../types/category'

export default function CategoriesPage() {
  const { t, i18n } = useTranslation()
  const queryClient = useQueryClient()
  const { showToast } = useToast()
  const [search, setSearch] = useState('')
  const [page, setPage] = useState(1)
  const [formOpen, setFormOpen] = useState(false)
  const [deleting, setDeleting] = useState<Category | null>(null)
  const language = i18n.language.startsWith('ar') ? 'ar' : 'en'
  const query = useQuery({
    queryKey: categoryKeys.list(language),
    queryFn: ({ signal }) => categoriesApi.list(signal),
  })

  const filtered = useMemo(() => {
    const term = search.trim().toLocaleLowerCase()
    if (!term) return query.data ?? []
    return (query.data ?? []).filter((category) =>
      `${category.name} ${category.description ?? ''}`
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

  const columns: DataColumn<Category>[] = [
    {
      key: 'name',
      header: t('categories.name'),
      render: (category) => {
        const image = resolveImageUrl(category.image)
        return (
          <div className="entity">
            <span className="entity__avatar">
              {image ? (
                <img src={image} alt="" />
              ) : (
                getInitials(category.name)
              )}
            </span>
            <div className="entity__details">
              <strong>{category.name}</strong>
              <span>#{category.id}</span>
            </div>
          </div>
        )
      },
    },
    {
      key: 'description',
      header: t('categories.descriptionLabel'),
      render: (category) => category.description || '—',
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
            to={routePaths.categoryDetail(category.id)}
            aria-label={`${t('actions.view')} ${category.name}`}
          >
            <Eye size={17} />
          </Link>
          <Button
            variant="ghost"
            iconOnly
            aria-label={`${t('actions.delete')} ${category.name}`}
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
          <Button
            onClick={() => {
              setFormOpen(true)
            }}
          >
            <Plus size={18} />
            {t('categories.add')}
          </Button>
        }
      />
      <DataTable
        data={rows}
        columns={columns}
        getRowKey={(category) => category.id}
        page={activePage}
        pageCount={pageCount}
        total={filtered.length}
        onPageChange={setPage}
        loading={query.isLoading}
        error={query.error ? normalizeApiError(query.error) : null}
        onRetry={() => void query.refetch()}
        emptyTitle={
          search ? t('categories.noResultsTitle') : t('categories.emptyTitle')
        }
        emptyDescription={
          search
            ? t('categories.noResultsDescription')
            : t('categories.emptyDescription')
        }
        toolbar={
          <>
            <SearchInput
              value={search}
              onChange={(value) => {
                setSearch(value)
                setPage(1)
              }}
              placeholder={t('categories.searchPlaceholder')}
            />
            <span className="table-toolbar__meta">
              <Shapes size={15} aria-hidden="true" />{' '}
              {t('table.results', { count: filtered.length })}
            </span>
          </>
        }
      />
      <CategoryForm
        open={formOpen}
        onClose={() => {
          setFormOpen(false)
        }}
      />
      <ConfirmationDialog
        open={Boolean(deleting)}
        title={t('categories.deleteTitle')}
        description={t('categories.deleteDescription', {
          name: deleting?.name ?? '',
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
