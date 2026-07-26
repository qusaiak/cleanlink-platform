import {
  AlertTriangle,
  Ban,
  CircleOff,
  Clock3,
  Inbox,
  ServerCrash,
  WifiOff,
} from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import type { ApiError } from '../api/api-error'
import { Button } from './button'

interface StateProps {
  title: string
  description: string
  actionLabel?: string
  onAction?: () => void
  icon?: LucideIcon
}

export function EmptyState({
  title,
  description,
  actionLabel,
  onAction,
  icon: Icon = Inbox,
}: StateProps) {
  return (
    <div className="feedback-state">
      <div className="feedback-state__content">
        <div className="feedback-state__icon">
          <Icon size={25} />
        </div>
        <h3>{title}</h3>
        <p>{description}</p>
        {actionLabel && onAction ? (
          <Button onClick={onAction}>{actionLabel}</Button>
        ) : null}
      </div>
    </div>
  )
}

interface ErrorStateProps {
  error: ApiError
  onRetry?: () => void
}

export function ErrorState({ error, onRetry }: ErrorStateProps) {
  const { t } = useTranslation()
  const map: Record<
    ApiError['kind'],
    { title: string; description: string; icon: LucideIcon }
  > = {
    network: {
      title: t('feedback.networkTitle'),
      description: t('feedback.networkDescription'),
      icon: WifiOff,
    },
    timeout: {
      title: t('feedback.timeoutTitle'),
      description: t('feedback.timeoutDescription'),
      icon: Clock3,
    },
    unauthorized: {
      title: t('feedback.unauthorizedTitle'),
      description: t('feedback.unauthorizedDescription'),
      icon: Ban,
    },
    forbidden: {
      title: t('feedback.forbiddenTitle'),
      description: t('feedback.forbiddenDescription'),
      icon: Ban,
    },
    notFound: {
      title: t('feedback.notFoundTitle'),
      description: t('feedback.notFoundDescription'),
      icon: CircleOff,
    },
    validation: {
      title: t('feedback.unknownTitle'),
      description: error.message,
      icon: AlertTriangle,
    },
    rateLimit: {
      title: t('feedback.rateLimitTitle'),
      description: t('feedback.rateLimitDescription'),
      icon: Clock3,
    },
    server: {
      title: t('feedback.serverTitle'),
      description: t('feedback.serverDescription'),
      icon: ServerCrash,
    },
    unknown: {
      title: t('feedback.unknownTitle'),
      description: error.message || t('feedback.unknownDescription'),
      icon: AlertTriangle,
    },
  }
  const content = map[error.kind]

  return (
    <div className="feedback-state feedback-state--error">
      <div className="feedback-state__content">
        <div className="feedback-state__icon">
          <content.icon size={25} />
        </div>
        <h3>{content.title}</h3>
        <p>{content.description}</p>
        {onRetry ? (
          <Button onClick={onRetry}>{t('actions.retry')}</Button>
        ) : null}
      </div>
    </div>
  )
}

export function PageSkeleton() {
  const { t } = useTranslation()
  return (
    <div className="page-skeleton" aria-label={t('feedback.loading')} role="status">
      <div className="skeleton page-skeleton__head" />
      <div className="page-skeleton__grid">
        {Array.from({ length: 3 }, (_, index) => (
          <div className="skeleton page-skeleton__card" key={index} />
        ))}
      </div>
    </div>
  )
}
