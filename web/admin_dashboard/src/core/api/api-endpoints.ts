export const apiEndpoints = {
  auth: {
    login: '/auth/login',
    logout: '/auth/logout',
    me: '/auth/me',
  },
  regionManagers: {
    list: '/managers',
    adminList: '/admin/search/region-managers',
    create: '/regions/managers',
    delete: (id: number) => `/regions/managers/${id}`,
  },
  categories: {
    list: '/categories',
    adminList: '/admin/search/categories',
    detail: (id: number) => `/categories/${id}`,
    create: '/categories',
    delete: (id: number) => `/categories/${id}`,
  },
  regions: {
    list: '/regions',
    adminList: '/admin/search/regions',
    detail: (id: number) => `/regions/${id}`,
    create: '/regions',
    update: (id: number) => `/regions/${id}`,
    delete: (id: number) => `/regions/${id}`,
  },
  companies: {
    list: '/companies',
    adminList: '/admin/search/companies',
    detail: (id: number) => `/companies/${id}`,
    delete: (id: number) => `/companies/${id}`,
    managers: '/company/managers',
  },
  services: {
    list: '/services',
    adminList: '/admin/search/services',
    detail: (id: number) => `/services/${id}`,
  },
  skills: {
    list: '/skills',
    adminList: '/admin/search/skills',
    create: '/skills',
    delete: (id: number) => `/skills/${id}`,
  },
  profile: {
    show: '/profile',
  },
} as const
