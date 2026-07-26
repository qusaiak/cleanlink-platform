import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { useEffect, useMemo } from 'react'
import { useForm } from 'react-hook-form'
import { useTranslation } from 'react-i18next'
import { z } from 'zod'
import { normalizeApiError } from '../../../core/api/api-error'
import { Button } from '../../../core/components/button'
import { TextInput } from '../../../core/components/form-controls'
import { Modal } from '../../../core/components/modal'
import { useToast } from '../../../core/components/toast'
import { skillKeys, skillsApi } from '../api/skills-api'
import type { SkillFormValues } from '../types/skill'

export function SkillForm({ open, onClose }: { open: boolean; onClose: () => void }) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const { showToast } = useToast()
  const schema = useMemo(
    () => z.object({
      name_ar: z.string().trim().min(1, t('validation.required')).max(255, t('validation.max255')),
      name_en: z.string().trim().min(1, t('validation.required')).max(255, t('validation.max255')),
    }),
    [t],
  )
  const { register, handleSubmit, reset, setError, formState: { errors } } = useForm<SkillFormValues>({
    resolver: zodResolver(schema),
    defaultValues: { name_ar: '', name_en: '' },
  })
  useEffect(() => {
    if (!open) reset()
  }, [open, reset])
  const mutation = useMutation({
    mutationFn: skillsApi.create,
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: skillKeys.all })
      showToast({ kind: 'success', title: t('skills.createdSuccess') })
      reset()
      onClose()
    },
    onError: (error) => {
      const normalized = normalizeApiError(error)
      Object.entries(normalized.fieldErrors).forEach(([field, message]) => {
        if (field === 'name_ar' || field === 'name_en') setError(field, { message })
      })
      if (!Object.keys(normalized.fieldErrors).length) setError('root', { message: normalized.message })
    },
  })
  return (
    <Modal
      open={open}
      title={t('skills.createTitle')}
      description={t('skills.formDescription')}
      onClose={mutation.isPending ? () => undefined : onClose}
      footer={
        <>
          <Button variant="ghost" disabled={mutation.isPending} onClick={onClose}>{t('actions.cancel')}</Button>
          <Button type="submit" form="skill-form" loading={mutation.isPending}>{t('actions.create')}</Button>
        </>
      }
    >
      <form id="skill-form" className="form-grid" onSubmit={handleSubmit((values) => mutation.mutate(values))}>
        <TextInput label={t('skills.nameEn')} required dir="ltr" error={errors.name_en?.message} {...register('name_en')} />
        <TextInput label={t('skills.nameAr')} required dir="rtl" error={errors.name_ar?.message} {...register('name_ar')} />
        {errors.root?.message ? <div className="form-error form-grid__full" role="alert">{errors.root.message}</div> : null}
      </form>
    </Modal>
  )
}
