import { useQuery } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { Link, useParams } from 'react-router-dom'
import { routePaths } from '../../../app/router/route-paths'
import { normalizeApiError } from '../../../core/api/api-error'
import { Breadcrumbs, DefinitionGrid, DetailSection, EntityImage } from '../../../core/components/details'
import { ErrorState, PageSkeleton } from '../../../core/components/feedback'
import { formatDate, formatDecimal } from '../../../core/utils/formatters'
import { regionKeys, regionsApi } from '../api/regions-api'

export default function RegionDetailsPage() {
  const { t, i18n } = useTranslation()
  const { regionId } = useParams()
  const id = Number(regionId)
  const isArabic = i18n.language.startsWith('ar')
  const query = useQuery({
    queryKey: regionKeys.detail(id),
    queryFn: ({ signal }) => regionsApi.detail(id, signal),
    enabled: Number.isInteger(id) && id > 0,
  })

  if (query.isLoading) return <PageSkeleton />
  if (query.error) return <ErrorState error={normalizeApiError(query.error)} onRetry={() => void query.refetch()} />
  if (!query.data) return null
  const region = query.data
  const name = isArabic ? region.name_ar : region.name_en

  return (
    <div className="detail-stack">
      <Breadcrumbs items={[
        { label: t('nav.dashboard'), to: routePaths.dashboard },
        { label: t('nav.regions'), to: routePaths.regions },
        { label: name },
      ]} />
      <header className="detail-hero">
        <EntityImage src={region.image} name={name} className="entity-image--hero" />
        <div className="detail-hero__content"><h1>{name}</h1><p>{isArabic ? region.name_en : region.name_ar}</p></div>
      </header>
      <DetailSection title={t('regionDetails.overview')}>
        <DefinitionGrid items={[
          { label: t('regions.nameAr'), value: region.name_ar },
          { label: t('regions.nameEn'), value: region.name_en },
          { label: t('regionDetails.companyCount'), value: region.companies?.length ?? 0 },
          { label: t('regions.created'), value: formatDate(region.created_at) },
          { label: t('companyDetails.updated'), value: formatDate(region.updated_at) },
        ]} />
      </DetailSection>
      <DetailSection title={t('regionDetails.manager')}>
        {region.manager ? (
          <div className="entity-card">
            <div className="entity-card__head">
              <EntityImage src={region.manager.profile?.image} name={region.manager.fullname} />
              <div><strong>{region.manager.fullname}</strong><p>{region.manager.email}</p></div>
            </div>
          </div>
        ) : <p className="detail-empty">{t('regionDetails.noManager')}</p>}
      </DetailSection>
      <DetailSection title={t('regionDetails.companies')}>
        {region.companies?.length ? (
          <div className="entity-grid">
            {region.companies.map((company) => (
              <Link className="entity-card" key={company.id} to={routePaths.companyDetail(company.id)}>
                <div className="entity-card__head">
                  <EntityImage src={company.image} name={isArabic ? company.name_ar : company.name_en} />
                  <div><strong>{isArabic ? company.name_ar : company.name_en}</strong><p>{t('companies.rating')}: {formatDecimal(company.rating)}</p></div>
                </div>
              </Link>
            ))}
          </div>
        ) : <p className="detail-empty">{t('regionDetails.noCompanies')}</p>}
      </DetailSection>
    </div>
  )
}
