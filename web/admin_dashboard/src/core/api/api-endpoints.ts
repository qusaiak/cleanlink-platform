export const apiEndpoints = {
  auth: {
    login: '/auth/login',
    logout: '/auth/logout',
    me: '/auth/me',
  },
  regionManagers: {
    list: '/managers',
    create: '/regions/managers',
    delete: (id: number) => `/regions/managers/${id}`,
  },
  categories: {
    list: '/categories',
    create: '/categories',
    delete: (id: number) => `/categories/${id}`,
  },
  regions: {
    list: '/regions',
    detail: (id: number) => `/regions/${id}`,
    create: '/regions',
    update: (id: number) => `/regions/${id}`,
    delete: (id: number) => `/regions/${id}`,
  },
  profile: {
    show: '/profile',
  },
} as const
