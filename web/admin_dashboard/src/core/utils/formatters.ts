import { i18n } from '../../app/providers/localization-provider'
import { env } from '../../config/env'

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

export const formatDecimal = (value: number | string | null | undefined) => {
  const parsed = typeof value === 'number' ? value : Number(value)
  return Number.isFinite(parsed)
    ? new Intl.NumberFormat(locale(), { maximumFractionDigits: 2 }).format(parsed)
    : '—'
}

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
    const apiUrl = new URL(env.apiBaseUrl)
    const origin = `${apiUrl.protocol}//${apiUrl.host}/`
    const normalized = value.replace(/^\/+/, '')
    return new URL(
      /^https?:\/\//i.test(value)
        ? value
        : normalized.startsWith('storage/')
          ? normalized
          : `storage/${normalized}`,
      origin,
    ).toString()
  } catch {
    return null
  }
}
