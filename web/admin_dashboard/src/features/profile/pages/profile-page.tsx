import { CalendarDays, Mail, MapPin, Phone, ShieldCheck } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import { useAuthStore } from '../../../core/auth/auth-store'
import { PageHeader } from '../../../core/components/page-header'
import {
  formatDate,
  getInitials,
  resolveImageUrl,
} from '../../../core/utils/formatters'
import './profile-page.css'

export default function ProfilePage() {
  const { t } = useTranslation()
  const user = useAuthStore((state) => state.user)
  if (!user) return null
  const image = resolveImageUrl(user.profile?.image)

  const details = [
    {
      icon: Mail,
      label: t('profile.email'),
      value: user.email,
    },
    {
      icon: ShieldCheck,
      label: t('profile.role'),
      value: t('profile.adminRole'),
    },
    {
      icon: Phone,
      label: t('profile.phone'),
      value: user.profile?.phone || t('profile.notProvided'),
    },
    {
      icon: MapPin,
      label: t('profile.address'),
      value: user.profile?.address || t('profile.notProvided'),
    },
    {
      icon: CalendarDays,
      label: t('profile.memberSince'),
      value: formatDate(user.created_at),
    },
  ]

  return (
    <>
      <PageHeader
        title={t('profile.title')}
        description={t('profile.description')}
      />
      <section className="profile-card">
        <div className="profile-card__identity">
          <div className="profile-card__avatar">
            {image ? (
              <img src={image} alt={user.fullname} />
            ) : (
              getInitials(user.fullname)
            )}
          </div>
          <div>
            <h2>{user.fullname}</h2>
            <p>{t('profile.adminRole')}</p>
          </div>
        </div>
        <div className="profile-card__details">
          {details.map(({ icon: Icon, label, value }) => (
            <div className="profile-detail" key={label}>
              <span><Icon size={18} /></span>
              <div>
                <small>{label}</small>
                <strong>{value}</strong>
              </div>
            </div>
          ))}
        </div>
        <p className="profile-card__note">{t('profile.readOnly')}</p>
      </section>
    </>
  )
}
