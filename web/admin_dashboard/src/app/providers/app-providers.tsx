import type { PropsWithChildren } from 'react'
import { ToastProvider } from '../../core/components/toast'
import { LocalizationProvider } from './localization-provider'
import { QueryProvider } from './query-provider'
import { ThemeProvider } from './theme-provider'

export function AppProviders({ children }: PropsWithChildren) {
  return (
    <LocalizationProvider>
      <ThemeProvider>
        <QueryProvider>
          <ToastProvider>{children}</ToastProvider>
        </QueryProvider>
      </ThemeProvider>
    </LocalizationProvider>
  )
}
