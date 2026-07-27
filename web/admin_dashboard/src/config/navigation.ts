import {
  LayoutDashboard,
  Map,
  Building2,
  BriefcaseBusiness,
  Sparkles,
  Shapes,
  UserCog,
  UserRound,
} from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import { routePaths } from '../app/router/route-paths'

export interface NavigationItem {
  path: string
  labelKey: string
  sectionKey: string
  icon: LucideIcon
}

export const navigationItems: NavigationItem[] = [
  {
    path: routePaths.dashboard,
    labelKey: 'nav.dashboard',
    sectionKey: 'nav.overview',
    icon: LayoutDashboard,
  },
  {
    path: routePaths.regionManagers,
    labelKey: 'nav.regionManagers',
    sectionKey: 'nav.management',
    icon: UserCog,
  },
  {
    path: routePaths.regions,
    labelKey: 'nav.regions',
    sectionKey: 'nav.management',
    icon: Map,
  },
  {
    path: routePaths.companies,
    labelKey: 'nav.companies',
    sectionKey: 'nav.management',
    icon: Building2,
  },
  {
    path: routePaths.categories,
    labelKey: 'nav.categories',
    sectionKey: 'nav.management',
    icon: Shapes,
  },
  {
    path: routePaths.services,
    labelKey: 'nav.services',
    sectionKey: 'nav.management',
    icon: BriefcaseBusiness,
  },
  {
    path: routePaths.skills,
    labelKey: 'nav.skills',
    sectionKey: 'nav.management',
    icon: Sparkles,
  },
  {
    path: routePaths.profile,
    labelKey: 'nav.profile',
    sectionKey: 'nav.account',
    icon: UserRound,
  },
]
