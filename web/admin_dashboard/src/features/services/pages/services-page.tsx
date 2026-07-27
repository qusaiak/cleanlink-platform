import { keepPreviousData, useQuery } from '@tanstack/react-query'
import { Eye } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'
import { routePaths } from '../../../app/router/route-paths'
import { normalizeApiError } from '../../../core/api/api-error'
import { DataTable, type DataColumn } from '../../../core/components/data-table'
import { EntityImage } from '../../../core/components/details'
import { FilterToolbar } from '../../../core/components/filter-toolbar'
import { SearchInput } from '../../../core/components/form-controls'
import { PageHeader } from '../../../core/components/page-header'
import { formatDecimal } from '../../../core/utils/formatters'
import { useListQueryState } from '../../../core/utils/use-list-query-state'
import { categoriesApi, categoryKeys } from '../../categories/api/categories-api'
import { companiesApi, companyKeys } from '../../companies/api/companies-api'
import { serviceKeys, servicesApi } from '../api/services-api'
import type { ServiceListItem } from '../types/service'

export default function ServicesPage() {
  const { t, i18n } = useTranslation()
  const listState = useListQueryState()
  const categoryId = listState.params.get('category_id') ?? ''
  const companyId = listState.params.get('company_id') ?? ''
  const isArabic = i18n.language.startsWith('ar')
  const filters = {
    search: listState.search || undefined,
    categoryId: categoryId ? Number(categoryId) : undefined,
    companyId: companyId ? Number(companyId) : undefined,
  }
  const query = useQuery({
    queryKey: serviceKeys.list(filters),
    queryFn: ({ signal }) => servicesApi.search(filters, signal),
    placeholderData: keepPreviousData,
  })
  const categories = useQuery({
    queryKey: categoryKeys.list({}),
    queryFn: ({ signal }) => categoriesApi.search({}, signal),
    staleTime: 5 * 60 * 1000,
  })
  const companies = useQuery({
    queryKey: companyKeys.list({}),
    queryFn: ({ signal }) => companiesApi.search({}, signal),
    staleTime: 5 * 60 * 1000,
  })
  const rows = query.data ?? []
  const nameOf = (service: ServiceListItem) =>
    isArabic ? service.name_ar : service.name_en

  const columns: DataColumn<ServiceListItem>[] = [
    {
      key: 'service',
      header: t('services.service'),
      render: (service) => (
        <div className="entity">
          <EntityImage src={service.image} name={nameOf(service)} />
          <div className="entity__details">
            <strong>{nameOf(service)}</strong>
            <span>{isArabic ? service.name_en : service.name_ar}</span>
          </div>
        </div>
      ),
    },
    {
      key: 'company',
      header: t('services.company'),
      render: (service) =>
        service.company
          ? isArabic
            ? service.company.name_ar
            : service.company.name_en
          : '—',
    },
    {
      key: 'category',
      header: t('services.category'),
      render: (service) =>
        service.category
          ? isArabic
            ? service.category.name_ar
            : service.category.name_en
          : '—',
    },
    {
      key: 'price',
      header: t('services.price'),
      render: (service) => formatDecimal(service.price),
    },
    {
      key: 'rating',
      header: t('services.rating'),
      render: (service) => formatDecimal(service.rating),
    },
    {
      key: 'actions',
      header: t('services.actions'),
      align: 'end',
      render: (service) => (
        <Link
          className="button button--ghost button--icon"
          to={`${routePaths.serviceDetail(service.id)}?${listState.params}`}
          aria-label={`${t('actions.view')} ${nameOf(service)}`}
        >
          <Eye size={17} />
        </Link>
      ),
    },
  ]

  const hasFilters = Boolean(listState.search || categoryId || companyId)

  return (
    <>
      <PageHeader
        title={t('services.title')}
        description={t('services.description')}
      />
      <DataTable
        data={rows}
        columns={columns}
        getRowKey={(service) => service.id}
        total={rows.length}
        loading={query.isLoading}
        fetching={query.isFetching}
        error={query.error ? normalizeApiError(query.error) : null}
        onRetry={() => void query.refetch()}
        emptyTitle={
          hasFilters ? t('services.noResultsTitle') : t('services.emptyTitle')
        }
        emptyDescription={
          hasFilters
            ? t('services.noResultsDescription')
            : t('services.emptyDescription')
        }
        toolbar={
          <FilterToolbar
            resultCount={rows.length}
            fetching={query.isFetching}
            hasFilters={hasFilters}
            onClear={() => {
              listState.setSearchInput('')
              listState.updateParams({
                search: '',
                category_id: '',
                company_id: '',
              })
            }}
            onRefresh={() => void query.refetch()}
          >
            <SearchInput
              value={listState.searchInput}
              onChange={listState.setSearchInput}
              onSearch={listState.commitSearch}
              loading={query.isFetching && !query.isLoading}
              placeholder={t('services.searchPlaceholder')}
            />
            <select
              className="field__control filter-toolbar__select"
              aria-label={t('services.categoryFilter')}
              value={categoryId}
              onChange={(event) =>
                listState.updateParams({ category_id: event.target.value })
              }
            >
              <option value="">{t('services.allCategories')}</option>
              {(categories.data ?? []).map((category) => (
                <option key={category.id} value={category.id}>
                  {isArabic ? category.name_ar : category.name_en}
                </option>
              ))}
            </select>
            <select
              className="field__control filter-toolbar__select"
              aria-label={t('services.companyFilter')}
              value={companyId}
              onChange={(event) =>
                listState.updateParams({ company_id: event.target.value })
              }
            >
              <option value="">{t('services.allCompanies')}</option>
              {(companies.data ?? []).map((company) => (
                <option key={company.id} value={company.id}>
                  {isArabic ? company.name_ar : company.name_en}
                </option>
              ))}
            </select>
          </FilterToolbar>
        }
      />
    </>
  )
}
