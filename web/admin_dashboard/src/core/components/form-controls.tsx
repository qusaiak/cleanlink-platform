import {
  Eye,
  EyeOff,
  ImagePlus,
  LoaderCircle,
  Search,
  Trash2,
  Upload,
  X,
} from 'lucide-react'
import {
  forwardRef,
  useEffect,
  useId,
  useMemo,
  useRef,
  useState,
} from 'react'
import type {
  InputHTMLAttributes,
  SelectHTMLAttributes,
  TextareaHTMLAttributes,
} from 'react'
import { useTranslation } from 'react-i18next'
import { appConfig } from '../../config/app-config'
import { resolveImageUrl } from '../utils/formatters'
import { Button } from './button'

interface BaseFieldProps {
  label: string
  error?: string
  hint?: string
  required?: boolean
}

type InputProps = BaseFieldProps & InputHTMLAttributes<HTMLInputElement>

export const TextInput = forwardRef<HTMLInputElement, InputProps>(
  ({ label, error, hint, required, id, ...props }, ref) => {
    const generatedId = useId()
    const inputId = id ?? generatedId
    const errorId = `${inputId}-error`
    const hintId = `${inputId}-hint`

    return (
      <div className="field">
        <label className="field__label" htmlFor={inputId}>
          {label}{' '}
          {required ? (
            <span className="field__required" aria-hidden="true">
              *
            </span>
          ) : null}
        </label>
        <input
          ref={ref}
          id={inputId}
          className="field__control"
          aria-invalid={Boolean(error)}
          aria-describedby={error ? errorId : hint ? hintId : undefined}
          {...props}
        />
        {error ? (
          <p id={errorId} className="field__error" role="alert">
            {error}
          </p>
        ) : hint ? (
          <p id={hintId} className="field__hint">
            {hint}
          </p>
        ) : null}
      </div>
    )
  },
)
TextInput.displayName = 'TextInput'

export const PasswordInput = forwardRef<HTMLInputElement, InputProps>(
  (props, ref) => {
    const { t } = useTranslation()
    const [visible, setVisible] = useState(false)
    return (
      <div className="field__control-wrap">
        <TextInput ref={ref} {...props} type={visible ? 'text' : 'password'} />
        <Button
          className="field__adornment"
          type="button"
          variant="ghost"
          iconOnly
          aria-label={t(
            visible ? 'actions.hidePassword' : 'actions.showPassword',
          )}
          onClick={() => setVisible((current) => !current)}
        >
          {visible ? <EyeOff size={18} /> : <Eye size={18} />}
        </Button>
      </div>
    )
  },
)
PasswordInput.displayName = 'PasswordInput'

type TextAreaProps = BaseFieldProps &
  TextareaHTMLAttributes<HTMLTextAreaElement>

export const TextArea = forwardRef<HTMLTextAreaElement, TextAreaProps>(
  ({ label, error, hint, required, id, ...props }, ref) => {
    const generatedId = useId()
    const inputId = id ?? generatedId
    return (
      <div className="field">
        <label className="field__label" htmlFor={inputId}>
          {label}{' '}
          {required ? <span className="field__required">*</span> : null}
        </label>
        <textarea
          ref={ref}
          id={inputId}
          className="field__control"
          aria-invalid={Boolean(error)}
          {...props}
        />
        {error ? (
          <p className="field__error" role="alert">
            {error}
          </p>
        ) : hint ? (
          <p className="field__hint">{hint}</p>
        ) : null}
      </div>
    )
  },
)
TextArea.displayName = 'TextArea'

type SelectProps = BaseFieldProps & SelectHTMLAttributes<HTMLSelectElement>

export const SelectInput = forwardRef<HTMLSelectElement, SelectProps>(
  ({ label, error, hint, required, id, children, ...props }, ref) => {
    const generatedId = useId()
    const inputId = id ?? generatedId
    return (
      <div className="field">
        <label className="field__label" htmlFor={inputId}>
          {label}{' '}
          {required ? <span className="field__required">*</span> : null}
        </label>
        <select
          ref={ref}
          id={inputId}
          className="field__control"
          aria-invalid={Boolean(error)}
          {...props}
        >
          {children}
        </select>
        {error ? (
          <p className="field__error" role="alert">
            {error}
          </p>
        ) : hint ? (
          <p className="field__hint">{hint}</p>
        ) : null}
      </div>
    )
  },
)
SelectInput.displayName = 'SelectInput'

interface SearchInputProps {
  value: string
  onChange: (value: string) => void
  placeholder: string
  loading?: boolean
  onSearch?: (value: string) => void
}

export function SearchInput({
  value,
  onChange,
  placeholder,
  loading = false,
  onSearch,
}: SearchInputProps) {
  const { t } = useTranslation()
  return (
    <div className="search">
      {loading ? (
        <LoaderCircle className="search__spinner" size={18} aria-hidden="true" />
      ) : (
        <Search size={18} aria-hidden="true" />
      )}
      <input
        className="field__control"
        type="search"
        value={value}
        onChange={(event) => onChange(event.target.value)}
        onKeyDown={(event) => {
          if (event.key === 'Enter') onSearch?.(value)
        }}
        placeholder={placeholder}
        aria-label={t('actions.search')}
      />
      {value ? (
        <button
          className="search__clear"
          type="button"
          aria-label={t('actions.clear')}
          onClick={() => {
            onChange('')
            onSearch?.('')
          }}
        >
          <X size={17} />
        </button>
      ) : null}
    </div>
  )
}

interface CheckboxProps extends InputHTMLAttributes<HTMLInputElement> {
  label: string
}

export const Checkbox = forwardRef<HTMLInputElement, CheckboxProps>(
  ({ label, ...props }, ref) => (
    <label className="checkbox">
      <input ref={ref} type="checkbox" {...props} />
      <span>{label}</span>
    </label>
  ),
)
Checkbox.displayName = 'Checkbox'

interface FileUploadProps {
  value: File | null
  existingUrl?: string | null
  error?: string
  onChange: (file: File | null) => void
}

export function FileUpload({
  value,
  existingUrl,
  error,
  onChange,
}: FileUploadProps) {
  const { t } = useTranslation()
  const inputRef = useRef<HTMLInputElement>(null)
  const [localError, setLocalError] = useState('')
  const preview = useMemo(
    () => (value ? URL.createObjectURL(value) : resolveImageUrl(existingUrl)),
    [existingUrl, value],
  )

  useEffect(
    () => () => {
      if (value && preview) URL.revokeObjectURL(preview)
    },
    [preview, value],
  )

  const selectFile = (file: File | undefined) => {
    setLocalError('')
    if (!file) return
    if (!['image/jpeg', 'image/png', 'image/svg+xml'].includes(file.type)) {
      setLocalError(t('upload.invalidType'))
      return
    }
    if (file.size > appConfig.maxUploadBytes) {
      setLocalError(t('upload.tooLarge'))
      return
    }
    onChange(file)
  }

  return (
    <div className="field form-grid__full">
      <span className="field__label">{t('upload.label')}</span>
      <div className="file-upload">
        <div className="file-upload__preview">
          {preview ? (
            <img src={preview} alt={t('upload.selected')} />
          ) : (
            <ImagePlus size={24} aria-hidden="true" />
          )}
        </div>
        <div className="file-upload__content">
          <span className="field__hint">{t('upload.hint')}</span>
          <div className="file-upload__actions">
            <Button
              type="button"
              variant="secondary"
              onClick={() => inputRef.current?.click()}
            >
              <Upload size={16} />
              {preview ? t('actions.changeImage') : t('upload.label')}
            </Button>
            {value ? (
              <Button
                type="button"
                variant="ghost"
                onClick={() => onChange(null)}
              >
                <Trash2 size={16} />
                {t('actions.removeImage')}
              </Button>
            ) : null}
          </div>
        </div>
        <input
          ref={inputRef}
          className="sr-only"
          type="file"
          accept=".jpg,.jpeg,.png,.svg,image/jpeg,image/png,image/svg+xml"
          onChange={(event) => selectFile(event.target.files?.[0])}
        />
      </div>
      {localError || error ? (
        <p className="field__error" role="alert">
          {localError || error}
        </p>
      ) : null}
    </div>
  )
}
