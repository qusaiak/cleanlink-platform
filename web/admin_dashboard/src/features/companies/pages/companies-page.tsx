import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { Eye, RefreshCw, Trash2 } from 'lucide-react'
import { useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { Link, useSearchParams } from 'react-router-dom'
import { routePaths } from '../../../app/router/route-paths'
import { appConfig } from '../../../config/app-config'
import { normalizeApiError } from '../../../core/api/api-error'
import { Button } from '../../../core/components/button'
import { DataTable, type DataColumn } from '../../../core/components/data-table'
import { EntityImage } from '../../../core/components/details'
import { SearchInput } from '../../../core/components/form-controls'
import { ConfirmationDialog } from '../../../core/components/modal'
import { PageHeader } from '../../../core/components/page-header'
import { useToast } from '../../../core/components/toast'
import { formatDecimal } from '../../../core/utils/formatters'
import { regionKeys, regionsApi } from '../../regions/api/regions-api'
import { companiesApi, companyKeys } from '../api/companies-api'
import type { CompanyListItem } from '../types/company'

export default function CompaniesPage() {
  const { t, i18n } = useTranslation()
  const queryClient = useQueryClient()
  const { showToast } = useToast()
  const [params, setParams] = useSearchParams()
  const [deleting, setDeleting] = useState<CompanyListItem | null>(null)
  const search = params.get('search') ?? ''
  const regionId = params.get('region_id') ?? ''
  const page = Math.max(1, Number(params.get('page')) || 1)
  const isArabic = i18n.language.startsWith('ar')
  const nameOf = (company: CompanyListItem) =>
    isArabic ? company.name_ar : company.name_en

  const query = useQuery({
    queryKey: companyKeys.list(),
    queryFn: ({ signal }) => companiesApi.list(signal),
  })
  const regions = useQuery({
    queryKey: regionKeys.list(),
    queryFn: ({ signal }) => regionsApi.list(signal),
  })

  const updateParams = (updates: Record<string, string>) => {
    const next = new URLSearchParams(params)
    Object.entries(updates).forEach(([key, value]) => {
      if (value) next.set(key, value)
      else next.delete(key)
    })
    setParams(next, { replace: true })
  }

  const filtered = useMemo(() => {
    const term = search.trim().toLocaleLowerCase()
    return (query.data ?? []).filter((company) => {
      const matchesSearch =
        !term ||
        `${company.name_ar} ${company.name_en} ${company.location_ar ?? ''} ${company.location_en ?? ''}`
          .toLocaleLowerCase()
          .includes(term)
      return matchesSearch && (!regionId || String(company.region_id) === regionId)
    })
  }, [query.data, regionId, search])
  const pageCount = Math.max(1, Math.ceil(filtered.length / appConfig.defaultPageSize))
  const activePage = Math.min(page, pageCount)
  const rows = filtered.slice(
    (activePage - 1) * appConfig.defaultPageSize,
    activePage * appConfig.defaultPageSize,
  )
  const listSearch = params.toString()
  const detailLink = (id: number) =>
    `${routePaths.companyDetail(id)}${listSearch ? `?from=${encodeURIComponent(`?${listSearch}`)}` : ''}`

  const deleteMutation = useMutation({
    mutationFn: companiesApi.delete,
    onSuccess: async () => {
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: companyKeys.all }),
        queryClient.invalidateQueries({ queryKey: regionKeys.all }),
        queryClient.invalidateQueries({ queryKey: ['dashboard'] }),
      ])
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
          <Link className="button button--ghost button--icon" to={detailLink(company.id)} aria-label={`${t('actions.view')} ${nameOf(company)}`}>
            <Eye size={17} />
          </Link>
          <Button variant="ghost" iconOnly aria-label={`${t('actions.delete')} ${nameOf(company)}`} onClick={() => setDeleting(company)}>
            <Trash2 size={17} />
          </Button>
        </div>
      ),
    },
  ]

  return (
    <>
      <PageHeader
        title={t('companies.title')}
        description={t('companies.description')}
        actions={
          <Button variant="secondary" loading={query.isFetching} onClick={() => void query.refetch()}>
            <RefreshCw size={17} />
            {t('actions.refresh')}
          </Button>
        }
      />
      <div className="responsive-table">
        <DataTable
          data={rows}
          columns={columns}
          getRowKey={(company) => company.id}
          page={activePage}
          pageCount={pageCount}
          total={filtered.length}
          onPageChange={(next) => updateParams({ page: String(next) })}
          loading={query.isLoading}
          error={query.error ? normalizeApiError(query.error) : null}
          onRetry={() => void query.refetch()}
          emptyTitle={search || regionId ? t('companies.noResultsTitle') : t('companies.emptyTitle')}
          emptyDescription={search || regionId ? t('companies.noResultsDescription') : t('companies.emptyDescription')}
          toolbar={
            <div className="filter-row">
              <SearchInput value={search} onChange={(value) => updateParams({ search: value, page: '' })} placeholder={t('companies.searchPlaceholder')} />
              <select className="field__control" aria-label={t('companies.regionFilter')} value={regionId} onChange={(event) => updateParams({ region_id: event.target.value, page: '' })}>
                <option value="">{t('companies.allRegions')}</option>
                {(regions.data ?? []).map((region) => (
                  <option key={region.id} value={region.id}>
                    {isArabic ? region.name_ar : region.name_en}
                  </option>
                ))}
              </select>
            </div>
          }
        />
      </div>
      <div className="mobile-card-list" aria-busy={query.isLoading}>
        {rows.map((company) => (
          <article className="entity-card" key={company.id}>
            <div className="entity-card__head">
              <EntityImage src={company.image} name={nameOf(company)} />
              <div>
                <strong>{nameOf(company)}</strong>
                <p>{company.region ? (isArabic ? company.region.name_ar : company.region.name_en) : '—'}</p>
              </div>
            </div>
            <span>{t('companies.rating')}: {formatDecimal(company.rating)}</span>
            <div className="table-actions">
              <Link className="button button--secondary" to={detailLink(company.id)}>
                <Eye size={17} /> {t('actions.view')}
              </Link>
              <Button variant="ghost" onClick={() => setDeleting(company)}>
                <Trash2 size={17} /> {t('actions.delete')}
              </Button>
            </div>
          </article>
        ))}
      </div>
      {!query.isLoading && filtered.length === 0 ? (
        <div className="mobile-card-list">
          <p className="detail-empty">{t(search || regionId ? 'companies.noResultsDescription' : 'companies.emptyDescription')}</p>
        </div>
      ) : null}
      <ConfirmationDialog
        open={Boolean(deleting)}
        title={t('companies.deleteTitle')}
        description={t('companies.deleteDescription', { name: deleting ? nameOf(deleting) : '' })}
        loading={deleteMutation.isPending}
        onCancel={() => setDeleting(null)}
        onConfirm={() => deleting && deleteMutation.mutate(deleting.id)}
      />
    </>
  )
}
