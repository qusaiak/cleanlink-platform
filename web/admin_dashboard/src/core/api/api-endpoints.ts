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
    detail: (id: number) => `/categories/${id}`,
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
  companies: {
    list: '/companies',
    detail: (id: number) => `/companies/${id}`,
    delete: (id: number) => `/companies/${id}`,
    managers: '/company/managers',
  },
  services: {
    list: '/services',
    detail: (id: number) => `/services/${id}`,
  },
  skills: {
    list: '/skills',
    create: '/skills',
    delete: (id: number) => `/skills/${id}`,
  },
  profile: {
    show: '/profile',
  },
} as const
