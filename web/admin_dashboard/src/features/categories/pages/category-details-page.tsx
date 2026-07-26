import { useQuery } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { Link, useParams } from 'react-router-dom'
import { routePaths } from '../../../app/router/route-paths'
import { normalizeApiError } from '../../../core/api/api-error'
import { Breadcrumbs, DefinitionGrid, DetailSection, EntityImage } from '../../../core/components/details'
import { ErrorState, PageSkeleton } from '../../../core/components/feedback'
import { formatDate, formatDecimal } from '../../../core/utils/formatters'
import { categoriesApi, categoryKeys } from '../api/categories-api'

export default function CategoryDetailsPage() {
  const { t, i18n } = useTranslation()
  const { categoryId } = useParams()
  const id = Number(categoryId)
  const isArabic = i18n.language.startsWith('ar')
  const query = useQuery({
    queryKey: categoryKeys.detail(id),
    queryFn: ({ signal }) => categoriesApi.detail(id, signal),
    enabled: Number.isInteger(id) && id > 0,
  })
  if (query.isLoading) return <PageSkeleton />
  if (query.error) return <ErrorState error={normalizeApiError(query.error)} onRetry={() => void query.refetch()} />
  if (!query.data) return null
  const category = query.data
  const name = isArabic ? category.name_ar : category.name_en
  return (
    <div className="detail-stack">
      <Breadcrumbs items={[
        { label: t('nav.dashboard'), to: routePaths.dashboard },
        { label: t('nav.categories'), to: routePaths.categories },
        { label: name },
      ]} />
      <header className="detail-hero">
        <EntityImage src={category.image} name={name} className="entity-image--hero" />
        <div className="detail-hero__content"><h1>{name}</h1><p>{isArabic ? category.name_en : category.name_ar}</p></div>
      </header>
      <DetailSection title={t('categoryDetails.overview')}>
        <DefinitionGrid items={[
          { label: t('categories.nameAr'), value: category.name_ar },
          { label: t('categories.nameEn'), value: category.name_en },
          { label: t('categoryDetails.servicesCount'), value: category.services?.length ?? 0 },
          { label: t('categories.created'), value: formatDate(category.created_at) },
          { label: t('companyDetails.updated'), value: formatDate(category.updated_at) },
          { label: t('categories.descriptionAr'), value: category.description_ar || '—' },
          { label: t('categories.descriptionEn'), value: category.description_en || '—' },
        ]} />
      </DetailSection>
      <DetailSection title={t('categoryDetails.services')}>
        {category.services?.length ? (
          <div className="entity-grid">
            {category.services.map((service) => (
              <Link className="entity-card" key={service.id} to={routePaths.serviceDetail(service.id)}>
                <div className="entity-card__head">
                  <EntityImage src={service.image} name={isArabic ? service.name_ar : service.name_en} />
                  <div><strong>{isArabic ? service.name_ar : service.name_en}</strong><p>{t('services.price')}: {formatDecimal(service.price)}</p></div>
                </div>
              </Link>
            ))}
          </div>
        ) : <p className="detail-empty">{t('categoryDetails.noServices')}</p>}
      </DetailSection>
    </div>
  )
}
