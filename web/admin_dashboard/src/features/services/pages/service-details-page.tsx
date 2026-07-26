import { useQuery } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { Link, useParams } from 'react-router-dom'
import { routePaths } from '../../../app/router/route-paths'
import { normalizeApiError } from '../../../core/api/api-error'
import { Breadcrumbs, DefinitionGrid, DetailSection, EntityImage } from '../../../core/components/details'
import { ErrorState, PageSkeleton } from '../../../core/components/feedback'
import { formatDate, formatDecimal } from '../../../core/utils/formatters'
import { categoriesApi, categoryKeys } from '../../categories/api/categories-api'
import { serviceKeys, servicesApi } from '../api/services-api'

export default function ServiceDetailsPage() {
  const { t, i18n } = useTranslation()
  const { serviceId } = useParams()
  const id = Number(serviceId)
  const isArabic = i18n.language.startsWith('ar')
  const language = isArabic ? 'ar' : 'en'
  const query = useQuery({
    queryKey: serviceKeys.detail(id),
    queryFn: ({ signal }) => servicesApi.detail(id, signal),
    enabled: Number.isInteger(id) && id > 0,
  })
  const categories = useQuery({
    queryKey: categoryKeys.list(language),
    queryFn: ({ signal }) => categoriesApi.list(signal),
  })
  if (query.isLoading) return <PageSkeleton />
  if (query.error) return <ErrorState error={normalizeApiError(query.error)} onRetry={() => void query.refetch()} />
  if (!query.data) return null
  const service = query.data
  const name = isArabic ? service.name_ar : service.name_en
  const category = categories.data?.find((item) => item.id === service.category_id)
  const skills = service.required_skills ?? service.requiredskills ?? []
  return (
    <div className="detail-stack">
      <Breadcrumbs items={[
        { label: t('nav.dashboard'), to: routePaths.dashboard },
        { label: t('nav.services'), to: routePaths.services },
        { label: name },
      ]} />
      <header className="detail-hero">
        <EntityImage src={service.image} name={name} className="entity-image--hero" />
        <div className="detail-hero__content"><h1>{name}</h1><p>{isArabic ? service.name_en : service.name_ar}</p></div>
      </header>
      <DetailSection title={t('serviceDetails.overview')}>
        <DefinitionGrid items={[
          { label: t('services.company'), value: service.company ? <Link to={routePaths.companyDetail(service.company.id)}>{isArabic ? service.company.name_ar : service.company.name_en}</Link> : '—' },
          { label: t('services.category'), value: category ? <Link to={routePaths.categoryDetail(category.id)}>{category.name}</Link> : `#${service.category_id}` },
          { label: t('services.price'), value: formatDecimal(service.price) },
          { label: t('services.discount'), value: formatDecimal(service.discount) },
          { label: t('services.rating'), value: formatDecimal(service.rating) },
          { label: t('services.duration'), value: t('services.durationRange', { min: service.min_duration, max: service.max_duration }) },
          { label: t('companyDetails.descriptionAr'), value: service.description_ar || '—' },
          { label: t('companyDetails.descriptionEn'), value: service.description_en || '—' },
          { label: t('companies.created'), value: formatDate(service.created_at) },
        ]} />
      </DetailSection>
      <DetailSection title={t('serviceDetails.requiredSkills')}>
        {skills.length ? (
          <div className="entity-grid">
            {skills.map((skill) => <article className="entity-card" key={skill.id}><strong>{isArabic ? skill.name_ar : skill.name_en}</strong><span>{isArabic ? skill.name_en : skill.name_ar}</span></article>)}
          </div>
        ) : <p className="detail-empty">{t('serviceDetails.noSkills')}</p>}
      </DetailSection>
      <DetailSection title={t('serviceDetails.packages')}>
        {service.packages?.length ? (
          <div className="entity-grid">
            {service.packages.map((item) => (
              <article className="entity-card" key={item.id}>
                <strong>{isArabic ? item.name_ar : item.name_en}</strong>
                <span>{t('services.price')}: {formatDecimal(item.price)}</span>
                <span>{t('serviceDetails.packageDuration', { count: item.duration })}</span>
                <span>{t('serviceDetails.minimumWorkers', { count: item.minimum_workers })}</span>
              </article>
            ))}
          </div>
        ) : <p className="detail-empty">{t('serviceDetails.noPackages')}</p>}
      </DetailSection>
      <DetailSection title={t('companyDetails.reviews')}>
        {service.reviews?.length ? (
          <div className="entity-grid">
            {service.reviews.map((review) => (
              <article className="entity-card" key={review.id}>
                <strong>{review.client?.fullname || t('companyDetails.anonymousReviewer')}</strong>
                <span>{t('services.rating')}: {formatDecimal(review.rating)}</span>
                <p>{review.comment || '—'}</p>
              </article>
            ))}
          </div>
        ) : <p className="detail-empty">{t('companyDetails.noReviews')}</p>}
      </DetailSection>
    </div>
  )
}
