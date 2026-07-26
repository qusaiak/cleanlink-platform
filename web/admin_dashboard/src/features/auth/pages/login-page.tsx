import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation } from '@tanstack/react-query'
import { ArrowRight, ShieldCheck } from 'lucide-react'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { useTranslation } from 'react-i18next'
import { useNavigate } from 'react-router-dom'
import { z } from 'zod'
import { routePaths } from '../../../app/router/route-paths'
import { normalizeApiError } from '../../../core/api/api-error'
import { useAuthStore } from '../../../core/auth/auth-store'
import { Button } from '../../../core/components/button'
import {
  Checkbox,
  PasswordInput,
  TextInput,
} from '../../../core/components/form-controls'
import { authApi } from '../api/auth-api'
import './login-page.css'

interface LoginForm {
  email: string
  password: string
  remember: boolean
}

export default function LoginPage() {
  const { t, i18n } = useTranslation()
  const navigate = useNavigate()
  const setSession = useAuthStore((state) => state.setSession)
  const [formError, setFormError] = useState('')
  const schema = z.object({
    email: z.string().min(1, t('validation.required')).email(t('validation.email')),
    password: z.string().min(1, t('validation.required')),
    remember: z.boolean(),
  })
  const {
    register,
    handleSubmit,
    setError,
    formState: { errors },
  } = useForm<LoginForm>({
    resolver: zodResolver(schema),
    defaultValues: { email: '', password: '', remember: true },
  })

  const mutation = useMutation({
    mutationFn: (values: LoginForm) =>
      authApi.login({ email: values.email, password: values.password }),
    onSuccess: (response, values) => {
      if (response.data.user.role !== 'admin') {
        setFormError(t('auth.invalidRole'))
        return
      }
      setSession(
        { token: response.data.access_token, user: response.data.user },
        values.remember,
      )
      navigate(routePaths.dashboard, { replace: true })
    },
    onError: (error) => {
      const normalized = normalizeApiError(error)
      Object.entries(normalized.fieldErrors).forEach(([field, message]) => {
        if (field === 'email' || field === 'password') {
          setError(field, { message })
        }
      })
      setFormError(
        normalized.kind === 'network'
          ? t('feedback.networkDescription')
          : normalized.kind === 'timeout'
            ? t('feedback.timeoutDescription')
            : normalized.message,
      )
    },
  })

  return (
    <section className="login-card">
      <div className="login-card__icon">
        <ShieldCheck size={23} />
      </div>
      <p className="login-card__eyebrow">{t('auth.eyebrow')}</p>
      <h1>{t('auth.title')}</h1>
      <p className="login-card__subtitle">{t('auth.subtitle')}</p>
      <form
        className="login-form"
        noValidate
        onSubmit={handleSubmit((values) => {
          setFormError('')
          mutation.mutate(values)
        })}
      >
        <TextInput
          label={t('auth.email')}
          placeholder={t('auth.emailPlaceholder')}
          type="email"
          autoComplete="email"
          required
          error={errors.email?.message}
          {...register('email')}
        />
        <PasswordInput
          label={t('auth.password')}
          placeholder={t('auth.passwordPlaceholder')}
          autoComplete="current-password"
          required
          error={errors.password?.message}
          {...register('password')}
        />
        <Checkbox label={t('auth.remember')} {...register('remember')} />
        {formError ? (
          <div className="form-error" role="alert">
            {formError}
          </div>
        ) : null}
        <Button type="submit" loading={mutation.isPending}>
          {t('auth.submit')}
          <ArrowRight
            className={i18n.dir() === 'rtl' ? 'icon--rtl' : ''}
            size={18}
          />
        </Button>
      </form>
    </section>
  )
}
