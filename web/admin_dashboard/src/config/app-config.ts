export const appConfig = {
  name: 'CleanLink Admin',
  shortName: 'CleanLink',
  supportedLanguages: ['en', 'ar'] as const,
  defaultLanguage: 'en' as const,
  queryStaleTimeMs: 30_000,
  defaultPageSize: 8,
  maxUploadBytes: 2 * 1024 * 1024,
} as const
