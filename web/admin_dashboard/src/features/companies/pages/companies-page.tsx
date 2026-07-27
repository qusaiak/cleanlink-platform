import {
  keepPreviousData,
  useMutation,
  useQuery,
  useQueryClient,
} from '@tanstack/react-query'
import { Eye, Trash2 } from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'
import { routePaths } from '../../../app/router/route-paths'
import { normalizeApiError } from '../../../core/api/api-error'
import { Button } from '../../../core/components/button'
import { DataTable, type DataColumn } from '../../../core/components/data-table'
import { EntityImage } from '../../../core/components/details'
import { FilterToolbar } from '../../../core/components/filter-toolbar'
import { SearchInput } from '../../../core/components/form-controls'
import { ConfirmationDialog } from '../../../core/components/modal'
import { PageHeader } from '../../../core/components/page-header'
import { useToast } from '../../../core/components/toast'
import { formatDecimal } from '../../../core/utils/formatters'
import { useListQueryState } from '../../../core/utils/use-list-query-state'
import { regionKeys, regionsApi } from '../../regions/api/regions-api'
import { companiesApi, companyKeys } from '../api/companies-api'
import type { CompanyListItem } from '../types/company'

export default function CompaniesPage() {
  const { t, i18n } = useTranslation()
  const queryClient = useQueryClient()
  const { showToast } = useToast()
  const listState = useListQueryState()
  const [deleting, setDeleting] = useState<CompanyListItem | null>(null)
  const regionId = listState.params.get('region_id') ?? ''
  const isArabic = i18n.language.startsWith('ar')
  const nameOf = (company: CompanyListItem) =>
    isArabic ? company.name_ar : company.name_en
  const filters = {
    search: listState.search || undefined,
    regionId: regionId ? Number(regionId) : undefined,
  }
  const query = useQuery({
    queryKey: companyKeys.list(filters),
    queryFn: ({ signal }) => companiesApi.search(filters, signal),
    placeholderData: keepPreviousData,
  })
  const regions = useQuery({
    queryKey: regionKeys.list({}),
    queryFn: ({ signal }) => regionsApi.search({}, signal),
    staleTime: 5 * 60 * 1000,
  })
  const rows = query.data ?? []

  const deleteMutation = useMutation({
    mutationFn: companiesApi.delete,
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: companyKeys.all })
      showToast({ kind: 'success', title: t('companies.deletedSuccess') })
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

  const columns: DataColumn<CompanyListItem>[] = [
    {
      key: 'company',
      header: t('companies.company'),
      render: (company) => (
        <div className="entity">
          <EntityImage src={company.image} name={nameOf(company)} />
          <div className="entity__details">
            <strong>{nameOf(company)}</strong>
            <span>{isArabic ? company.name_en : company.name_ar}</span>
          </div>
        </div>
      ),
    },
    {
      key: 'region',
      header: t('companies.region'),
      render: (company) =>
        company.region
          ? isArabic
            ? company.region.name_ar
            : company.region.name_en
          : '—',
    },
    {
      key: 'location',
      header: t('companies.location'),
      render: (company) =>
        (isArabic ? company.location_ar : company.location_en) || '—',
    },
    {
      key: 'rating',
      header: t('companies.rating'),
      render: (company) => formatDecimal(company.rating),
    },
    {
      key: 'actions',
      header: t('companies.actions'),
      align: 'end',
      render: (company) => (
        <div className="table-actions">
          <Link
            className="button button--ghost button--icon"
            to={`${routePaths.companyDetail(company.id)}?${listState.params}`}
            aria-label={`${t('actions.view')} ${nameOf(company)}`}
          >
            <Eye size={17} />
          </Link>
          <Button
            variant="ghost"
            iconOnly
            aria-label={`${t('actions.delete')} ${nameOf(company)}`}
            onClick={() => setDeleting(company)}
          >
            <Trash2 size={17} />
          </Button>
        </div>
      ),
    },
  ]

  const hasFilters = Boolean(listState.search || regionId)

  return (
    <>
      <PageHeader
        title={t('companies.title')}
        description={t('companies.description')}
      />
      <DataTable
        data={rows}
        columns={columns}
        getRowKey={(company) => company.id}
        total={rows.length}
        loading={query.isLoading}
        fetching={query.isFetching}
        error={query.error ? normalizeApiError(query.error) : null}
        onRetry={() => void query.refetch()}
        emptyTitle={
          hasFilters ? t('companies.noResultsTitle') : t('companies.emptyTitle')
        }
        emptyDescription={
          hasFilters
            ? t('companies.noResultsDescription')
            : t('companies.emptyDescription')
        }
        toolbar={
          <FilterToolbar
            resultCount={rows.length}
            fetching={query.isFetching}
            hasFilters={hasFilters}
            onClear={() => {
              listState.setSearchInput('')
              listState.updateParams({ search: '', region_id: '' })
            }}
            onRefresh={() => void query.refetch()}
          >
            <SearchInput
              value={listState.searchInput}
              onChange={listState.setSearchInput}
              onSearch={listState.commitSearch}
              loading={query.isFetching && !query.isLoading}
              placeholder={t('companies.searchPlaceholder')}
            />
            <select
              className="field__control filter-toolbar__select"
              aria-label={t('companies.regionFilter')}
              value={regionId}
              onChange={(event) =>
                listState.updateParams({ region_id: event.target.value })
              }
            >
              <option value="">{t('companies.allRegions')}</option>
              {(regions.data ?? []).map((region) => (
                <option key={region.id} value={region.id}>
                  {isArabic ? region.name_ar : region.name_en}
                </option>
              ))}
            </select>
          </FilterToolbar>
        }
      />
      <ConfirmationDialog
        open={Boolean(deleting)}
        title={t('companies.deleteTitle')}
        description={t('companies.deleteDescription', {
          name: deleting ? nameOf(deleting) : '',
        })}
        loading={deleteMutation.isPending}
        onCancel={() => setDeleting(null)}
        onConfirm={() => deleting && deleteMutation.mutate(deleting.id)}
      />
    </>
  )
}
