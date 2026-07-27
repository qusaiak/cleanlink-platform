export type SortDirection = 'asc' | 'desc'

export interface ListFilters {
  search?: string
  page: number
  perPage: number
  sortBy?: string
  sortDirection?: SortDirection
}

type QueryValue = string | number | boolean | undefined

export function compactQueryParams(
  values: Record<string, QueryValue>,
): Record<string, string | number | boolean> {
  return Object.fromEntries(
    Object.entries(values).filter(
      ([, value]) => value !== undefined && value !== '',
    ),
  ) as Record<string, string | number | boolean>
}

export function toBaseQueryParams(filters: ListFilters) {
  return compactQueryParams({
    search: filters.search?.trim() || undefined,
    page: filters.page,
    per_page: filters.perPage,
    sort_by: filters.sortBy,
    sort_direction: filters.sortDirection,
  })
}
