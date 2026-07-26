import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { useEffect, useId } from 'react'
import { Controller, useForm } from 'react-hook-form'
import { useTranslation } from 'react-i18next'
import { z } from 'zod'
import { normalizeApiError } from '../../../core/api/api-error'
import { Button } from '../../../core/components/button'
import {
  FileUpload,
  TextArea,
  TextInput,
} from '../../../core/components/form-controls'
import { Modal } from '../../../core/components/modal'
import { useToast } from '../../../core/components/toast'
import { categoriesApi, categoryKeys } from '../api/categories-api'
import type { CategoryFormValues } from '../types/category'

interface CategoryFormProps {
  open: boolean
  onClose: () => void
}

const defaults: CategoryFormValues = {
  name_ar: '',
  name_en: '',
  description_ar: '',
  description_en: '',
  image: null,
}

export function CategoryForm({
  open,
  onClose,
}: CategoryFormProps) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const { showToast } = useToast()
  const formId = useId()
  const schema = z.object({
    name_ar: z
      .string()
      .min(1, t('validation.required'))
      .max(255, t('validation.max255')),
    name_en: z
      .string()
      .min(1, t('validation.required'))
      .max(255, t('validation.max255')),
    description_ar: z.string(),
    description_en: z.string(),
    image: z.custom<File>().nullable(),
  })
  const {
    control,
    register,
    handleSubmit,
    reset,
    setError,
    formState: { errors },
  } = useForm<CategoryFormValues>({
    resolver: zodResolver(schema),
    defaultValues: defaults,
  })

  useEffect(() => {
    if (!open) {
      reset(defaults)
      return
    }
  }, [open, reset])

  const mutation = useMutation({
    mutationFn: categoriesApi.create,
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: categoryKeys.all })
      showToast({
        kind: 'success',
        title: t('categories.createdSuccess'),
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
          field === 'description_ar' ||
          field === 'description_en' ||
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
      title={t('categories.createTitle')}
      description={t('categories.formDescription')}
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
          >
            {mutation.isPending
              ? t('feedback.saving')
              : t('actions.create')}
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
            label={t('categories.nameEn')}
            required
            dir="ltr"
            error={errors.name_en?.message}
            {...register('name_en')}
          />
          <TextInput
            label={t('categories.nameAr')}
            required
            dir="rtl"
            error={errors.name_ar?.message}
            {...register('name_ar')}
          />
          <TextArea
            label={t('categories.descriptionEn')}
            dir="ltr"
            error={errors.description_en?.message}
            {...register('description_en')}
          />
          <TextArea
            label={t('categories.descriptionAr')}
            dir="rtl"
            error={errors.description_ar?.message}
            {...register('description_ar')}
          />
          <Controller
            control={control}
            name="image"
            render={({ field }) => (
              <FileUpload
                value={field.value}
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
