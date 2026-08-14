import type { LandingCopy, Locale } from '../../../i18n/types'
import { FindstateExactPage } from './FindstateExactPage'

type MobileLandingProps = {
  copy: LandingCopy
  locale: Locale
  nextLocale: Locale
  onLocaleChange: (locale: Locale) => void
}

export function MobileLanding({ locale, nextLocale, onLocaleChange }: MobileLandingProps) {
  return <FindstateExactPage locale={locale} nextLocale={nextLocale} onLocaleChange={onLocaleChange} />
}
