import { useCallback, useEffect, useState } from 'react'
import { useSearchParams } from 'react-router-dom'

const debounceMs = 400

export function useListQueryState() {
  const [params, setParams] = useSearchParams()
  const urlSearch = params.get('search') ?? ''
  const [searchDraft, setSearchDraft] = useState({
    source: urlSearch,
    value: urlSearch,
  })
  const searchInput =
    searchDraft.source === urlSearch ? searchDraft.value : urlSearch
  const setSearchInput = useCallback(
    (value: string) => setSearchDraft({ source: urlSearch, value }),
    [urlSearch],
  )

  const commitSearch = useCallback(
    (value = searchInput) => {
      const search = value.trim()
      if (search === urlSearch) return
      const next = new URLSearchParams(params)
      if (search) next.set('search', search)
      else next.delete('search')
      next.delete('page')
      setParams(next, { replace: true })
    },
    [params, searchInput, setParams, urlSearch],
  )

  useEffect(() => {
    const timer = window.setTimeout(() => commitSearch(), debounceMs)

    return () => window.clearTimeout(timer)
  }, [commitSearch])

  const updateParams = useCallback(
    (updates: Record<string, string>) => {
      const next = new URLSearchParams(params)
      Object.entries(updates).forEach(([key, value]) => {
        if (value) next.set(key, value)
        else next.delete(key)
      })
      setParams(next, { replace: true })
    },
    [params, setParams],
  )

  return {
    params,
    page: Math.max(1, Number(params.get('page')) || 1),
    search: urlSearch,
    searchInput,
    setSearchInput,
    commitSearch,
    updateParams,
  }
}
