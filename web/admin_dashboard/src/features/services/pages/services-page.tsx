import { useQuery } from '@tanstack/react-query'
import { BriefcaseBusiness, Eye, RefreshCw } from 'lucide-react'
import { useMemo } from 'react'
import { useTranslation } from 'react-i18next'
import { Link, useSearchParams } from 'react-router-dom'
import { routePaths } from '../../../app/router/route-paths'
import { appConfig } from '../../../config/app-config'
import { normalizeApiError } from '../../../core/api/api-error'
import { Button } from '../../../core/components/button'
import { DataTable, type DataColumn } from '../../../core/components/data-table'
import { EntityImage } from '../../../core/components/details'
import { SearchInput } from '../../../core/components/form-controls'
import { PageHeader } from '../../../core/components/page-header'
import { formatDecimal } from '../../../core/utils/formatters'
import { categoriesApi, categoryKeys } from '../../categories/api/categories-api'
import { companiesApi, companyKeys } from '../../companies/api/companies-api'
import { serviceKeys, servicesApi } from '../api/services-api'
import type { ServiceListItem } from '../types/service'

export default function ServicesPage() {
  const { t, i18n } = useTranslation()
  const [params, setParams] = useSearchParams()
  const search = params.get('search') ?? ''
  const categoryId = params.get('category_id') ?? ''
  const companyId = params.get('company_id') ?? ''
  const page = Math.max(1, Number(params.get('page')) || 1)
  const isArabic = i18n.language.startsWith('ar')
  const language = isArabic ? 'ar' : 'en'
  const query = useQuery({
    queryKey: serviceKeys.list(),
    queryFn: ({ signal }) => servicesApi.list(signal),
  })
  const categories = useQuery({
    queryKey: categoryKeys.list(language),
    queryFn: ({ signal }) => categoriesApi.list(signal),
  })
  const companies = useQuery({
    queryKey: companyKeys.list(),
    queryFn: ({ signal }) => companiesApi.list(signal),
  })
  const updateParams = (updates: Record<string, string>) => {
    const next = new URLSearchParams(params)
    Object.entries(updates).forEach(([key, value]) => value ? next.set(key, value) : next.delete(key))
    setParams(next, { replace: true })
  }
  const filtered = useMemo(() => {
    const term = search.trim().toLocaleLowerCase()
    return (query.data ?? []).filter((service) =>
      (!term || `${service.name_ar} ${service.name_en}`.toLocaleLowerCase().includes(term)) &&
      (!categoryId || String(service.category_id) === categoryId) &&
      (!companyId || String(service.company_id) === companyId),
    )
  }, [categoryId, companyId, query.data, search])
  const pageCount = Math.max(1, Math.ceil(filtered.length / appConfig.defaultPageSize))
  const activePage = Math.min(page, pageCount)
  const rows = filtered.slice((activePage - 1) * appConfig.defaultPageSize, activePage * appConfig.defaultPageSize)
  const categoryName = (id: number) => categories.data?.find((item) => item.id === id)?.name ?? '—'
  const companyName = (service: ServiceListItem) => {
    const company = service.company ?? companies.data?.find((item) => item.id === service.company_id)
    return company ? (isArabic ? company.name_ar : company.name_en) : '—'
  }
  const columns: DataColumn<ServiceListItem>[] = [
    {
      key: 'service',
      header: t('services.service'),
      render: (service) => (
        <div className="entity">
          <EntityImage src={service.image} name={isArabic ? service.name_ar : service.name_en} />
          <div className="entity__details"><strong>{isArabic ? service.name_ar : service.name_en}</strong><span>{isArabic ? service.name_en : service.name_ar}</span></div>
        </div>
      ),
    },
    { key: 'company', header: t('services.company'), render: companyName },
    { key: 'category', header: t('services.category'), render: (service) => categoryName(service.category_id) },
    { key: 'price', header: t('services.price'), render: (service) => formatDecimal(service.price) },
    { key: 'rating', header: t('services.rating'), render: (service) => formatDecimal(service.rating) },
    {
      key: 'actions',
      header: t('services.actions'),
      align: 'end',
      render: (service) => (
        <Link className="button button--ghost button--icon" to={routePaths.serviceDetail(service.id)} aria-label={`${t('actions.view')} ${isArabic ? service.name_ar : service.name_en}`}>
          <Eye size={17} />
        </Link>
      ),
    },
  ]
  return (
    <>
      <PageHeader
        title={t('services.title')}
        description={t('services.description')}
        actions={<Button variant="secondary" loading={query.isFetching} onClick={() => void query.refetch()}><RefreshCw size={17} />{t('actions.refresh')}</Button>}
      />
      <DataTable
        data={rows}
        columns={columns}
        getRowKey={(service) => service.id}
        page={activePage}
        pageCount={pageCount}
        total={filtered.length}
        onPageChange={(next) => updateParams({ page: String(next) })}
        loading={query.isLoading}
        error={query.error ? normalizeApiError(query.error) : null}
        onRetry={() => void query.refetch()}
        emptyTitle={search || categoryId || companyId ? t('services.noResultsTitle') : t('services.emptyTitle')}
        emptyDescription={search || categoryId || companyId ? t('services.noResultsDescription') : t('services.emptyDescription')}
        toolbar={
          <div className="filter-row">
            <SearchInput value={search} onChange={(value) => updateParams({ search: value, page: '' })} placeholder={t('services.searchPlaceholder')} />
            <select className="field__control" aria-label={t('services.categoryFilter')} value={categoryId} onChange={(event) => updateParams({ category_id: event.target.value, page: '' })}>
              <option value="">{t('services.allCategories')}</option>
              {(categories.data ?? []).map((category) => <option key={category.id} value={category.id}>{category.name}</option>)}
            </select>
            <select className="field__control" aria-label={t('services.companyFilter')} value={companyId} onChange={(event) => updateParams({ company_id: event.target.value, page: '' })}>
              <option value="">{t('services.allCompanies')}</option>
              {(companies.data ?? []).map((company) => <option key={company.id} value={company.id}>{isArabic ? company.name_ar : company.name_en}</option>)}
            </select>
            <span className="table-toolbar__meta"><BriefcaseBusiness size={15} /> {t('table.results', { count: filtered.length })}</span>
          </div>
        }
      />
    </>
  )
}
