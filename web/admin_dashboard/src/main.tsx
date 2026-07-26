import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { App } from './app/App'
import { AppProviders } from './app/providers/app-providers'
import './core/theme/global.css'
import './core/components/ui.css'
import './app/layouts/layouts.css'
import './features/errors/pages/error-page.css'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <AppProviders>
      <App />
    </AppProviders>
  </StrictMode>,
)
