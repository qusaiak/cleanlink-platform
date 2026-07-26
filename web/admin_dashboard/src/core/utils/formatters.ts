import { i18n } from '../../app/providers/localization-provider'

const locale = () => (i18n.language.startsWith('ar') ? 'ar' : 'en')

export const formatDate = (value: string | null | undefined) => {
  if (!value) return '—'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return '—'
  return new Intl.DateTimeFormat(locale(), {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  }).format(date)
}

export const formatNumber = (value: number) =>
  new Intl.NumberFormat(locale()).format(value)

export const getInitials = (name: string) =>
  name
    .trim()
    .split(/\s+/)
    .slice(0, 2)
    .map((part) => part.charAt(0))
    .join('')
    .toUpperCase()

export const resolveImageUrl = (value: string | null | undefined) => {
  if (!value) return null
  try {
    return new URL(value).toString()
  } catch {
    return null
  }
}
