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
  icon: LucideIcon
}

export const navigationItems: NavigationItem[] = [
  {
    path: routePaths.dashboard,
    labelKey: 'nav.dashboard',
    icon: LayoutDashboard,
  },
  {
    path: routePaths.regionManagers,
    labelKey: 'nav.regionManagers',
    icon: UserCog,
  },
  {
    path: routePaths.regions,
    labelKey: 'nav.regions',
    icon: Map,
  },
  {
    path: routePaths.companies,
    labelKey: 'nav.companies',
    icon: Building2,
  },
  {
    path: routePaths.categories,
    labelKey: 'nav.categories',
    icon: Shapes,
  },
  {
    path: routePaths.services,
    labelKey: 'nav.services',
    icon: BriefcaseBusiness,
  },
  {
    path: routePaths.skills,
    labelKey: 'nav.skills',
    icon: Sparkles,
  },
  {
    path: routePaths.profile,
    labelKey: 'nav.profile',
    icon: UserRound,
  },
]
