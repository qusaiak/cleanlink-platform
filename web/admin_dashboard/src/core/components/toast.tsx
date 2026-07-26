import { CheckCircle2, CircleAlert, Info, X } from 'lucide-react'
import {
  createContext,
  useCallback,
  useContext,
  useMemo,
  useState,
} from 'react'
import type { PropsWithChildren } from 'react'
import { useTranslation } from 'react-i18next'
import { Button } from './button'

type ToastKind = 'success' | 'error' | 'info'

interface ToastInput {
  kind: ToastKind
  title: string
  message?: string
}

interface ToastItem extends ToastInput {
  id: number
}

interface ToastContextValue {
  showToast: (toast: ToastInput) => void
}

const ToastContext = createContext<ToastContextValue | null>(null)

export function ToastProvider({ children }: PropsWithChildren) {
  const [toasts, setToasts] = useState<ToastItem[]>([])
  const { t } = useTranslation()

  const dismiss = useCallback((id: number) => {
    setToasts((current) => current.filter((toast) => toast.id !== id))
  }, [])

  const showToast = useCallback(
    (toast: ToastInput) => {
      const id = Date.now() + Math.random()
      setToasts((current) => [
        ...current.filter(
          (item) => item.title !== toast.title || item.message !== toast.message,
        ),
        { ...toast, id },
      ])
      window.setTimeout(() => dismiss(id), 4500)
    },
    [dismiss],
  )

  const value = useMemo(() => ({ showToast }), [showToast])
  const icons = {
    success: CheckCircle2,
    error: CircleAlert,
    info: Info,
  }

  return (
    <ToastContext.Provider value={value}>
      {children}
      <div
        className="toast-viewport"
        aria-live="polite"
        aria-atomic="false"
      >
        {toasts.map((toast) => {
          const Icon = icons[toast.kind]
          return (
            <div className={`toast toast--${toast.kind}`} key={toast.id}>
              <Icon size={20} aria-hidden="true" />
              <div className="toast__body">
                <strong>{toast.title}</strong>
                {toast.message ? <span>{toast.message}</span> : null}
              </div>
              <Button
                type="button"
                variant="ghost"
                iconOnly
                aria-label={t('actions.close')}
                onClick={() => dismiss(toast.id)}
              >
                <X size={16} />
              </Button>
            </div>
          )
        })}
      </div>
    </ToastContext.Provider>
  )
}

export function useToast() {
  const context = useContext(ToastContext)
  if (!context) throw new Error('useToast must be used within ToastProvider')
  return context
}
