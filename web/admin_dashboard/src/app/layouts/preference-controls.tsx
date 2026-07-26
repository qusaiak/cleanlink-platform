import { Languages, Moon, Sun } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import { Button } from '../../core/components/button'
import { useTheme } from '../providers/theme-provider'

export function ThemeToggle() {
  const { theme, toggleTheme } = useTheme()
  const { t } = useTranslation()
  const nextLabel =
    theme === 'light' ? t('preferences.dark') : t('preferences.light')

  return (
    <Button
      type="button"
      variant="ghost"
      iconOnly
      aria-label={nextLabel}
      title={nextLabel}
      onClick={toggleTheme}
    >
      {theme === 'light' ? <Moon size={18} /> : <Sun size={18} />}
    </Button>
  )
}

export function LanguageToggle() {
  const { t, i18n } = useTranslation()
  const isArabic = i18n.language.startsWith('ar')
  const label = isArabic
    ? t('preferences.english')
    : t('preferences.arabic')

  return (
    <Button
      type="button"
      variant="ghost"
      aria-label={`${t('preferences.language')}: ${label}`}
      title={`${t('preferences.language')}: ${label}`}
      onClick={() => void i18n.changeLanguage(isArabic ? 'en' : 'ar')}
    >
      <Languages size={18} />
      <span>{isArabic ? 'EN' : 'ع'}</span>
    </Button>
  )
}
