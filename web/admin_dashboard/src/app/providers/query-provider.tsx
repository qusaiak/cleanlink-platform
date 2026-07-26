import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import type { PropsWithChildren } from 'react'
import { useState } from 'react'
import { appConfig } from '../../config/app-config'

export function QueryProvider({ children }: PropsWithChildren) {
  const [client] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: appConfig.queryStaleTimeMs,
            retry: (failureCount, error) => {
              const status =
                typeof error === 'object' &&
                error &&
                'response' in error &&
                typeof error.response === 'object' &&
                error.response &&
                'status' in error.response
                  ? error.response.status
                  : undefined
              return status === 401 || status === 403
                ? false
                : failureCount < 1
            },
            refetchOnWindowFocus: false,
          },
          mutations: { retry: false },
        },
      }),
  )

  return <QueryClientProvider client={client}>{children}</QueryClientProvider>
}
