import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useEffect, useId } from 'react'
import { Controller, useForm } from 'react-hook-form'
import { useTranslation } from 'react-i18next'
import { z } from 'zod'
import { normalizeApiError } from '../../../core/api/api-error'
import { Button } from '../../../core/components/button'
import {
  FileUpload,
  SelectInput,
  TextInput,
} from '../../../core/components/form-controls'
import { Modal } from '../../../core/components/modal'
import { useToast } from '../../../core/components/toast'
import {
  regionManagerKeys,
  regionManagersApi,
} from '../../region-managers/api/region-managers-api'
import { regionKeys, regionsApi } from '../api/regions-api'
import type { Region, RegionFormValues } from '../types/region'

interface RegionFormProps {
  open: boolean
  region: Region | null
  onClose: () => void
}

const defaults: RegionFormValues = {
  name_ar: '',
  name_en: '',
  manager_id: '',
  image: null,
}

export function RegionForm({ open, region, onClose }: RegionFormProps) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const { showToast } = useToast()
  const formId = useId()
  const managersQuery = useQuery({
    queryKey: regionManagerKeys.list(),
    queryFn: ({ signal }) => regionManagersApi.list(signal),
    enabled: open,
  })
  const schema = z.object({
    name_ar: z.string().min(1, t('validation.required')),
    name_en: z.string().min(1, t('validation.required')),
    manager_id: z.string().min(1, t('validation.required')),
    image: z.custom<File>().nullable(),
  })
  const {
    control,
    register,
    handleSubmit,
    reset,
    setError,
    formState: { errors },
  } = useForm<RegionFormValues>({
    resolver: zodResolver(schema),
    defaultValues: defaults,
  })

  useEffect(() => {
    if (!open) {
      reset(defaults)
      return
    }
    reset(
      region
        ? {
            name_ar: region.name_ar,
            name_en: region.name_en,
            manager_id: String(region.manager_id),
            image: null,
          }
        : defaults,
    )
  }, [open, region, reset])

  const mutation = useMutation({
    mutationFn: (values: RegionFormValues) =>
      region
        ? regionsApi.update(region.id, values)
        : regionsApi.create(values),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: regionKeys.all })
      showToast({
        kind: 'success',
        title: t(
          region ? 'regions.updatedSuccess' : 'regions.createdSuccess',
        ),
      })
      reset(defaults)
      onClose()
    },
    onError: (error) => {
      const normalized = normalizeApiError(error)
      Object.entries(normalized.fieldErrors).forEach(([field, message]) => {
        if (
          field === 'name_ar' ||
          field === 'name_en' ||
          field === 'manager_id' ||
          field === 'image'
        ) {
          setError(field, { message })
        }
      })
      setError('root', { message: normalized.message })
    },
  })

  return (
    <Modal
      open={open}
      title={t(region ? 'regions.editTitle' : 'regions.createTitle')}
      description={t('regions.formDescription')}
      onClose={mutation.isPending ? () => undefined : onClose}
      footer={
        <>
          <Button
            variant="ghost"
            onClick={onClose}
            disabled={mutation.isPending}
          >
            {t('actions.cancel')}
          </Button>
          <Button
            type="submit"
            form={formId}
            loading={mutation.isPending}
            disabled={
              managersQuery.isLoading ||
              (!region && (managersQuery.data?.length ?? 0) === 0)
            }
          >
            {mutation.isPending
              ? t('feedback.saving')
              : t(region ? 'actions.save' : 'actions.create')}
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
        <TextInput
          label={t('regions.nameEn')}
          required
          dir="ltr"
          error={errors.name_en?.message}
          {...register('name_en')}
        />
        <TextInput
          label={t('regions.nameAr')}
          required
          dir="rtl"
          error={errors.name_ar?.message}
          {...register('name_ar')}
        />
        <div className="form-grid__full">
          <SelectInput
            label={t('regions.manager')}
            required
            disabled={Boolean(region) || managersQuery.isLoading}
            hint={
              region
                ? t('regions.assignmentLocked')
                : managersQuery.data?.length === 0
                  ? t('regions.noManagers')
                  : undefined
            }
            error={errors.manager_id?.message}
            {...register('manager_id')}
          >
            <option value="">{t('regions.selectManager')}</option>
            {managersQuery.data?.map((manager) => (
              <option key={manager.id} value={manager.id}>
                {manager.fullname} · {manager.email}
              </option>
            ))}
          </SelectInput>
        </div>
        <Controller
          control={control}
          name="image"
          render={({ field }) => (
            <FileUpload
              value={field.value}
              existingUrl={region?.image}
              error={errors.image?.message}
              onChange={field.onChange}
            />
          )}
        />
        {errors.root?.message ? (
          <div className="form-error form-grid__full" role="alert">
            {errors.root.message}
          </div>
        ) : null}
      </form>
    </Modal>
  )
}
