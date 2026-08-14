import type { LandingCopy, Locale } from '../../../i18n/types'
import { FindstateExactPage } from './FindstateExactPage'

type DesktopLandingProps = {
  copy: LandingCopy
  locale: Locale
  nextLocale: Locale
  onLocaleChange: (locale: Locale) => void
}

export function DesktopLanding({ locale, nextLocale, onLocaleChange }: DesktopLandingProps) {
  return <FindstateExactPage locale={locale} nextLocale={nextLocale} onLocaleChange={onLocaleChange} />
}
