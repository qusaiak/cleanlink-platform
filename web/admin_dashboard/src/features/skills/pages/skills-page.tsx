import {
  keepPreviousData,
  useMutation,
  useQuery,
  useQueryClient,
} from '@tanstack/react-query'
import { Plus, Trash2 } from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { normalizeApiError } from '../../../core/api/api-error'
import { Button } from '../../../core/components/button'
import { DataTable, type DataColumn } from '../../../core/components/data-table'
import { FilterToolbar } from '../../../core/components/filter-toolbar'
import { SearchInput } from '../../../core/components/form-controls'
import { ConfirmationDialog } from '../../../core/components/modal'
import { PageHeader } from '../../../core/components/page-header'
import { useToast } from '../../../core/components/toast'
import { formatDate } from '../../../core/utils/formatters'
import { useListQueryState } from '../../../core/utils/use-list-query-state'
import { skillKeys, skillsApi } from '../api/skills-api'
import { SkillForm } from '../components/skill-form'
import type { Skill } from '../types/skill'

export default function SkillsPage() {
  const { t, i18n } = useTranslation()
  const queryClient = useQueryClient()
  const { showToast } = useToast()
  const listState = useListQueryState()
  const [formOpen, setFormOpen] = useState(false)
  const [deleting, setDeleting] = useState<Skill | null>(null)
  const isArabic = i18n.language.startsWith('ar')
  const filters = { search: listState.search || undefined }
  const query = useQuery({
    queryKey: skillKeys.list(filters),
    queryFn: ({ signal }) => skillsApi.search(filters, signal),
    placeholderData: keepPreviousData,
  })
  const rows = query.data ?? []

  const deleteMutation = useMutation({
    mutationFn: skillsApi.delete,
    onSuccess: async () => {
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: skillKeys.all }),
        queryClient.invalidateQueries({ queryKey: ['services'] }),
        queryClient.invalidateQueries({ queryKey: ['dashboard'] }),
      ])
      showToast({ kind: 'success', title: t('skills.deletedSuccess') })
      setDeleting(null)
    },
    onError: (error) => {
      const normalized = normalizeApiError(error)
      showToast({
        kind: 'error',
        title: t('feedback.unknownTitle'),
        message: normalized.message,
      })
    },
  })

  const columns: DataColumn<Skill>[] = [
    {
      key: 'skill',
      header: t('skills.skill'),
      render: (skill) => (
        <div className="entity__details">
          <strong>{isArabic ? skill.name_ar : skill.name_en}</strong>
          <span>{isArabic ? skill.name_en : skill.name_ar}</span>
        </div>
      ),
    },
    { key: 'ar', header: t('skills.nameAr'), render: (skill) => skill.name_ar },
    { key: 'en', header: t('skills.nameEn'), render: (skill) => skill.name_en },
    {
      key: 'created',
      header: t('skills.created'),
      render: (skill) => formatDate(skill.created_at),
    },
    {
      key: 'actions',
      header: t('skills.actions'),
      align: 'end',
      render: (skill) => (
        <Button
          variant="ghost"
          iconOnly
          aria-label={`${t('actions.delete')} ${isArabic ? skill.name_ar : skill.name_en}`}
          onClick={() => setDeleting(skill)}
        >
          <Trash2 size={17} />
        </Button>
      ),
    },
  ]

  return (
    <>
      <PageHeader
        title={t('skills.title')}
        description={t('skills.description')}
        actions={
          <Button onClick={() => setFormOpen(true)}>
            <Plus size={17} />
            {t('skills.add')}
          </Button>
        }
      />
      <DataTable
        data={rows}
        columns={columns}
        getRowKey={(skill) => skill.id}
        total={rows.length}
        loading={query.isLoading}
        fetching={query.isFetching}
        error={query.error ? normalizeApiError(query.error) : null}
        onRetry={() => void query.refetch()}
        emptyTitle={
          listState.search ? t('skills.noResultsTitle') : t('skills.emptyTitle')
        }
        emptyDescription={
          listState.search
            ? t('skills.noResultsDescription')
            : t('skills.emptyDescription')
        }
        toolbar={
          <FilterToolbar
            resultCount={rows.length}
            fetching={query.isFetching}
            hasFilters={Boolean(listState.search)}
            onClear={() => {
              listState.setSearchInput('')
              listState.commitSearch('')
            }}
            onRefresh={() => void query.refetch()}
          >
            <SearchInput
              value={listState.searchInput}
              onChange={listState.setSearchInput}
              onSearch={listState.commitSearch}
              loading={query.isFetching && !query.isLoading}
              placeholder={t('skills.searchPlaceholder')}
            />
          </FilterToolbar>
        }
      />
      <SkillForm open={formOpen} onClose={() => setFormOpen(false)} />
      <ConfirmationDialog
        open={Boolean(deleting)}
        title={t('skills.deleteTitle')}
        description={t('skills.deleteDescription', {
          name: deleting
            ? isArabic
              ? deleting.name_ar
              : deleting.name_en
            : '',
        })}
        loading={deleteMutation.isPending}
        onCancel={() => setDeleting(null)}
        onConfirm={() => deleting && deleteMutation.mutate(deleting.id)}
      />
    </>
  )
}
