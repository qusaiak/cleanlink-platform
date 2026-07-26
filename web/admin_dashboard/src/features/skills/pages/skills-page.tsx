import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { Plus, RefreshCw, Sparkles, Trash2 } from 'lucide-react'
import { useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { appConfig } from '../../../config/app-config'
import { normalizeApiError } from '../../../core/api/api-error'
import { Button } from '../../../core/components/button'
import { DataTable, type DataColumn } from '../../../core/components/data-table'
import { SearchInput } from '../../../core/components/form-controls'
import { ConfirmationDialog } from '../../../core/components/modal'
import { PageHeader } from '../../../core/components/page-header'
import { useToast } from '../../../core/components/toast'
import { formatDate } from '../../../core/utils/formatters'
import { skillKeys, skillsApi } from '../api/skills-api'
import { SkillForm } from '../components/skill-form'
import type { Skill } from '../types/skill'

export default function SkillsPage() {
  const { t, i18n } = useTranslation()
  const queryClient = useQueryClient()
  const { showToast } = useToast()
  const [search, setSearch] = useState('')
  const [page, setPage] = useState(1)
  const [formOpen, setFormOpen] = useState(false)
  const [deleting, setDeleting] = useState<Skill | null>(null)
  const isArabic = i18n.language.startsWith('ar')
  const query = useQuery({ queryKey: skillKeys.list(), queryFn: ({ signal }) => skillsApi.list(signal) })
  const filtered = useMemo(() => {
    const term = search.trim().toLocaleLowerCase()
    return (query.data ?? []).filter((skill) => !term || `${skill.name_ar} ${skill.name_en}`.toLocaleLowerCase().includes(term))
  }, [query.data, search])
  const pageCount = Math.max(1, Math.ceil(filtered.length / appConfig.defaultPageSize))
  const activePage = Math.min(page, pageCount)
  const rows = filtered.slice((activePage - 1) * appConfig.defaultPageSize, activePage * appConfig.defaultPageSize)
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
      showToast({ kind: 'error', title: t('feedback.unknownTitle'), message: normalized.message })
    },
  })
  const columns: DataColumn<Skill>[] = [
    {
      key: 'skill',
      header: t('skills.skill'),
      render: (skill) => <div className="entity__details"><strong>{isArabic ? skill.name_ar : skill.name_en}</strong><span>{isArabic ? skill.name_en : skill.name_ar}</span></div>,
    },
    { key: 'ar', header: t('skills.nameAr'), render: (skill) => skill.name_ar },
    { key: 'en', header: t('skills.nameEn'), render: (skill) => skill.name_en },
    { key: 'created', header: t('skills.created'), render: (skill) => formatDate(skill.created_at) },
    {
      key: 'actions',
      header: t('skills.actions'),
      align: 'end',
      render: (skill) => <Button variant="ghost" iconOnly aria-label={`${t('actions.delete')} ${isArabic ? skill.name_ar : skill.name_en}`} onClick={() => setDeleting(skill)}><Trash2 size={17} /></Button>,
    },
  ]
  return (
    <>
      <PageHeader
        title={t('skills.title')}
        description={t('skills.description')}
        actions={
          <div className="table-actions">
            <Button variant="secondary" loading={query.isFetching} onClick={() => void query.refetch()}><RefreshCw size={17} />{t('actions.refresh')}</Button>
            <Button onClick={() => setFormOpen(true)}><Plus size={17} />{t('skills.add')}</Button>
          </div>
        }
      />
      <div className="responsive-table">
        <DataTable
          data={rows}
          columns={columns}
          getRowKey={(skill) => skill.id}
          page={activePage}
          pageCount={pageCount}
          total={filtered.length}
          onPageChange={setPage}
          loading={query.isLoading}
          error={query.error ? normalizeApiError(query.error) : null}
          onRetry={() => void query.refetch()}
          emptyTitle={search ? t('skills.noResultsTitle') : t('skills.emptyTitle')}
          emptyDescription={search ? t('skills.noResultsDescription') : t('skills.emptyDescription')}
          toolbar={<><SearchInput value={search} onChange={(value) => { setSearch(value); setPage(1) }} placeholder={t('skills.searchPlaceholder')} /><span className="table-toolbar__meta"><Sparkles size={15} /> {t('table.results', { count: filtered.length })}</span></>}
        />
      </div>
      <div className="mobile-card-list">
        {rows.map((skill) => (
          <article className="entity-card" key={skill.id}>
            <strong>{isArabic ? skill.name_ar : skill.name_en}</strong>
            <span>{isArabic ? skill.name_en : skill.name_ar}</span>
            <Button variant="ghost" onClick={() => setDeleting(skill)}><Trash2 size={17} />{t('actions.delete')}</Button>
          </article>
        ))}
      </div>
      <SkillForm open={formOpen} onClose={() => setFormOpen(false)} />
      <ConfirmationDialog
        open={Boolean(deleting)}
        title={t('skills.deleteTitle')}
        description={t('skills.deleteDescription', { name: deleting ? (isArabic ? deleting.name_ar : deleting.name_en) : '' })}
        loading={deleteMutation.isPending}
        onCancel={() => setDeleting(null)}
        onConfirm={() => deleting && deleteMutation.mutate(deleting.id)}
      />
    </>
  )
}
