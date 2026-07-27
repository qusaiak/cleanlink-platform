import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { Mail, Trash2, UserRound } from 'lucide-react'
import { useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { Link, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { routePaths } from '../../../app/router/route-paths'
import { normalizeApiError } from '../../../core/api/api-error'
import { Button } from '../../../core/components/button'
import { Breadcrumbs, DefinitionGrid, DetailSection, EntityImage } from '../../../core/components/details'
import { ErrorState, PageSkeleton } from '../../../core/components/feedback'
import { ConfirmationDialog } from '../../../core/components/modal'
import { useToast } from '../../../core/components/toast'
import { formatDate, formatDecimal } from '../../../core/utils/formatters'
import { regionKeys } from '../../regions/api/regions-api'
import { companiesApi, companyKeys } from '../api/companies-api'

export default function CompanyDetailsPage() {
  const { t, i18n } = useTranslation()
  const { companyId } = useParams()
  const id = Number(companyId)
  const [searchParams] = useSearchParams()
  const from = searchParams.toString()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const { showToast } = useToast()
  const [confirming, setConfirming] = useState(false)
  const isArabic = i18n.language.startsWith('ar')
  const query = useQuery({
    queryKey: companyKeys.detail(id),
    queryFn: ({ signal }) => companiesApi.detail(id, signal),
    enabled: Number.isInteger(id) && id > 0,
  })
  const managers = useQuery({
    queryKey: companyKeys.managers(),
    queryFn: ({ signal }) => companiesApi.managers(signal),
  })
  const company = query.data
  const manager = useMemo(
    () => managers.data?.find((item) => item.id === company?.manager_id),
    [company?.manager_id, managers.data],
  )
  const name = company ? (isArabic ? company.name_ar : company.name_en) : ''
  const otherName = company ? (isArabic ? company.name_en : company.name_ar) : ''
  const backToCompanies = `${routePaths.companies}${from ? `?${from}` : ''}`

  const deleteMutation = useMutation({
    mutationFn: companiesApi.delete,
    onSuccess: async () => {
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: companyKeys.all }),
        queryClient.invalidateQueries({ queryKey: regionKeys.all }),
        queryClient.invalidateQueries({ queryKey: ['dashboard'] }),
      ])
      showToast({ kind: 'success', title: t('companies.deletedSuccess') })
      navigate(backToCompanies, { replace: true })
    },
    onError: (error) => {
      const normalized = normalizeApiError(error)
      showToast({ kind: 'error', title: t('feedback.unknownTitle'), message: normalized.message })
    },
  })

  if (query.isLoading) return <PageSkeleton />
  if (query.error) return <ErrorState error={normalizeApiError(query.error)} onRetry={() => void query.refetch()} />
  if (!company) return null

  return (
    <div className="detail-stack">
      <Breadcrumbs
        items={[
          { label: t('nav.dashboard'), to: routePaths.dashboard },
          { label: t('nav.companies'), to: backToCompanies },
          { label: name },
        ]}
      />
      <header className="detail-hero">
        <EntityImage src={company.image} name={name} className="entity-image--hero" />
        <div className="detail-hero__content">
          <h1>{name}</h1>
          <p>{otherName}</p>
        </div>
      </header>

      <DetailSection title={t('companyDetails.overview')}>
        <DefinitionGrid
          items={[
            { label: t('companies.rating'), value: formatDecimal(company.rating) },
            {
              label: t('companies.region'),
              value: company.region ? (
                <Link to={routePaths.regionDetail(company.region.id)}>
                  {isArabic ? company.region.name_ar : company.region.name_en}
                </Link>
              ) : '—',
            },
            { label: t('companies.created'), value: formatDate(company.created_at) },
            { label: t('companyDetails.locationAr'), value: company.location_ar || '—' },
            { label: t('companyDetails.locationEn'), value: company.location_en || '—' },
            { label: t('companyDetails.updated'), value: formatDate(company.updated_at) },
          ]}
        />
      </DetailSection>

      <DetailSection title={t('companyDetails.descriptions')}>
        <DefinitionGrid
          items={[
            { label: t('companyDetails.descriptionAr'), value: company.description_ar || '—' },
            { label: t('companyDetails.descriptionEn'), value: company.description_en || '—' },
          ]}
        />
      </DetailSection>

      <DetailSection title={t('companyDetails.manager')}>
        {manager ? (
          <div className="entity-card">
            <div className="entity-card__head">
              <EntityImage src={manager.profile?.image} name={manager.fullname} />
              <div><strong>{manager.fullname}</strong><p><Mail size={12} /> {manager.email}</p></div>
            </div>
            <span>{manager.profile?.phone || t('profile.notProvided')}</span>
          </div>
        ) : (
          <p className="detail-empty">{t('companyDetails.managerUnavailable')}</p>
        )}
      </DetailSection>

      <DetailSection title={t('companyDetails.workingHours')}>
        {company.work_times?.length ? (
          <div className="work-hours">
            {[0, 1, 2, 3, 4, 5, 6].map((day) => {
              const item = company.work_times?.find((time) => time.day_of_week === day)
              return (
                <div className="work-hour" key={day}>
                  <strong>{t(`days.${day}`)}</strong>
                  <span>{!item || Boolean(item.is_holiday) ? t('companyDetails.closed') : `${item.open_at?.slice(0, 5)} – ${item.close_at?.slice(0, 5)}`}</span>
                </div>
              )
            })}
          </div>
        ) : <p className="detail-empty">{t('companyDetails.noWorkingHours')}</p>}
      </DetailSection>

      <DetailSection title={t('companyDetails.services')}>
        {company.services?.length ? (
          <div className="entity-grid">
            {company.services.map((service) => (
              <Link className="entity-card" key={service.id} to={routePaths.serviceDetail(service.id)}>
                <div className="entity-card__head">
                  <EntityImage src={service.image} name={isArabic ? service.name_ar : service.name_en} />
                  <div><strong>{isArabic ? service.name_ar : service.name_en}</strong><p>{t('services.price')}: {formatDecimal(service.price)}</p></div>
                </div>
              </Link>
            ))}
          </div>
        ) : <p className="detail-empty">{t('companyDetails.noServices')}</p>}
      </DetailSection>

      <DetailSection title={t('companyDetails.workers')}>
        {company.workers?.length ? (
          <div className="entity-grid">
            {company.workers.map((worker) => (
              <article className="entity-card" key={worker.id}>
                <div className="entity-card__head">
                  <EntityImage src={worker.user?.profile?.image} name={worker.user?.fullname || String(worker.id)} />
                  <div><strong>{worker.user?.fullname || `#${worker.id}`}</strong><p>{worker.user?.email || '—'}</p></div>
                </div>
                <span><UserRound size={12} /> {t('companyDetails.experience', { count: worker.experience_years })}</span>
                <span>{t('companies.rating')}: {formatDecimal(worker.rating)}</span>
              </article>
            ))}
          </div>
        ) : <p className="detail-empty">{t('companyDetails.noWorkers')}</p>}
      </DetailSection>

      <DetailSection title={t('companyDetails.reviews')}>
        {company.reviews?.length ? (
          <div className="entity-grid">
            {company.reviews.map((review) => (
              <article className="entity-card" key={review.id}>
                <strong>{review.client?.fullname || t('companyDetails.anonymousReviewer')}</strong>
                <span>{t('companies.rating')}: {formatDecimal(review.rating)}</span>
                <p>{review.comment || '—'}</p>
                <span>{formatDate(review.created_at)}</span>
              </article>
            ))}
          </div>
        ) : <p className="detail-empty">{t('companyDetails.noReviews')}</p>}
      </DetailSection>

      <DetailSection title={t('companyDetails.dangerZone')} className="danger-zone">
        <div className="danger-zone__content">
          <p>{t('companyDetails.dangerDescription')}</p>
          <Button variant="danger" onClick={() => setConfirming(true)}>
            <Trash2 size={17} /> {t('actions.delete')}
          </Button>
        </div>
      </DetailSection>

      <ConfirmationDialog
        open={confirming}
        title={t('companies.deleteTitle')}
        description={t('companies.deleteDescription', { name })}
        loading={deleteMutation.isPending}
        onCancel={() => setConfirming(false)}
        onConfirm={() => deleteMutation.mutate(company.id)}
      />
    </div>
  )
}
