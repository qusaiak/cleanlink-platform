import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { useEffect, useId } from 'react'
import { useForm } from 'react-hook-form'
import { useTranslation } from 'react-i18next'
import { z } from 'zod'
import { normalizeApiError } from '../../../core/api/api-error'
import { Button } from '../../../core/components/button'
import {
  PasswordInput,
  TextInput,
} from '../../../core/components/form-controls'
import { Modal } from '../../../core/components/modal'
import { useToast } from '../../../core/components/toast'
import {
  regionManagerKeys,
  regionManagersApi,
} from '../api/region-managers-api'
import type { CreateRegionManagerInput } from '../types/region-manager'

interface RegionManagerFormProps {
  open: boolean
  onClose: () => void
}

export function RegionManagerForm({
  open,
  onClose,
}: RegionManagerFormProps) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const { showToast } = useToast()
  const formId = useId()
  const schema = z.object({
    fullname: z
      .string()
      .min(1, t('validation.required'))
      .max(255, t('validation.max255')),
    email: z.string().min(1, t('validation.required')).email(t('validation.email')),
    password: z.string().min(8, t('validation.passwordMin')),
  })
  const {
    register,
    handleSubmit,
    reset,
    setError,
    formState: { errors },
  } = useForm<CreateRegionManagerInput>({
    resolver: zodResolver(schema),
    defaultValues: { fullname: '', email: '', password: '' },
  })

  useEffect(() => {
    if (!open) reset()
  }, [open, reset])

  const mutation = useMutation({
    mutationFn: regionManagersApi.create,
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: regionManagerKeys.all })
      showToast({ kind: 'success', title: t('managers.createdSuccess') })
      reset()
      onClose()
    },
    onError: (error) => {
      const normalized = normalizeApiError(error)
      Object.entries(normalized.fieldErrors).forEach(([field, message]) => {
        if (field === 'fullname' || field === 'email' || field === 'password') {
          setError(field, { message })
        }
      })
      setError('root', { message: normalized.message })
    },
  })

  return (
    <Modal
      open={open}
      title={t('managers.formTitle')}
      description={t('managers.formDescription')}
      onClose={mutation.isPending ? () => undefined : onClose}
      footer={
        <>
          <Button variant="ghost" onClick={onClose} disabled={mutation.isPending}>
            {t('actions.cancel')}
          </Button>
          <Button
            type="submit"
            form={formId}
            loading={mutation.isPending}
          >
            {mutation.isPending ? t('feedback.saving') : t('actions.create')}
          </Button>
        </>
      }
    >
      <form
        id={formId}
        className="form-grid"
        noValidate
        onSubmit={handleSubmit((values) => mutation.mutate(values))}
      >
        <div className="form-grid__full">
          <TextInput
            label={t('managers.name')}
            autoComplete="name"
            required
            error={errors.fullname?.message}
            {...register('fullname')}
          />
        </div>
        <div className="form-grid__full">
          <TextInput
            label={t('managers.email')}
            type="email"
            autoComplete="email"
            required
            error={errors.email?.message}
            {...register('email')}
          />
        </div>
        <div className="form-grid__full">
          <PasswordInput
            label={t('managers.password')}
            autoComplete="new-password"
            required
            error={errors.password?.message}
            {...register('password')}
          />
        </div>
        {errors.root?.message ? (
          <div className="form-error form-grid__full" role="alert">
            {errors.root.message}
          </div>
        ) : null}
      </form>
    </Modal>
  )
}
