import { brand } from '../config/brand'
import { ar } from './locales/ar'
import { en } from './locales/en'
import type { LandingCopy, Locale } from './types'

export type { Locale } from './types'

export const defaultLocale = brand.defaultLocale as Locale

const dictionaries: Record<Locale, LandingCopy> = {
  ar,
  en,
}

export function getCopy(locale: Locale) {
  return dictionaries[locale]
}

export function getDirection(locale: Locale) {
  return locale === 'ar' ? 'rtl' : 'ltr'
}
