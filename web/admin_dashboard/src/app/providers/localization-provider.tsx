import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'
import type { PropsWithChildren } from 'react'
import { useEffect } from 'react'
import ar from '../../locales/ar/translation.json'
import en from '../../locales/en/translation.json'
import { appConfig } from '../../config/app-config'

const languageKey = 'cleanlink-admin-language'
const savedLanguage = window.localStorage.getItem(languageKey)
const initialLanguage = savedLanguage === 'ar' ? 'ar' : appConfig.defaultLanguage

void i18n.use(initReactI18next).init({
  resources: {
    en: { translation: en },
    ar: { translation: ar },
  },
  lng: initialLanguage,
  fallbackLng: appConfig.defaultLanguage,
  interpolation: { escapeValue: false },
})

export function LocalizationProvider({ children }: PropsWithChildren) {
  useEffect(() => {
    const syncDocument = (language: string) => {
      const normalized = language.startsWith('ar') ? 'ar' : 'en'
      document.documentElement.lang = normalized
      document.documentElement.dir = normalized === 'ar' ? 'rtl' : 'ltr'
      window.localStorage.setItem(languageKey, normalized)
    }

    syncDocument(i18n.language)
    i18n.on('languageChanged', syncDocument)
    return () => i18n.off('languageChanged', syncDocument)
  }, [])

  return children
}

export { i18n }
