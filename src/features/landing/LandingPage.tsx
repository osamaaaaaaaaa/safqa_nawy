import { getCopy, type Locale } from '../../i18n'
import { useFindstateMotion } from '../../hooks/useFindstateMotion'
import { useViewportMode } from '../../hooks/useViewportMode'
import { DesktopLanding } from './components/DesktopLanding'
import { MobileLanding } from './components/MobileLanding'

type LandingPageProps = {
  locale: Locale
  onLocaleChange: (locale: Locale) => void
}

export function LandingPage({ locale, onLocaleChange }: LandingPageProps) {
  const copy = getCopy(locale)
  const { isMobile } = useViewportMode()
  const { isLoading } = useFindstateMotion()
  const nextLocale = locale === 'ar' ? 'en' : 'ar'

  return (
    <main className="app-shell" dir="ltr" lang={locale}>
      <div id="ftco-loader" className={`${isLoading ? 'show ' : ''}fullscreen`} aria-hidden="true">
        <svg className="circular" width="48" height="48">
          <circle className="path-bg" cx="24" cy="24" r="22" fill="none" strokeWidth="4" />
          <circle className="path" cx="24" cy="24" r="22" fill="none" strokeWidth="4" strokeMiterlimit="10" />
        </svg>
      </div>
      {isMobile ? (
        <MobileLanding
          copy={copy}
          locale={locale}
          nextLocale={nextLocale}
          onLocaleChange={onLocaleChange}
        />
      ) : (
        <DesktopLanding
          copy={copy}
          locale={locale}
          nextLocale={nextLocale}
          onLocaleChange={onLocaleChange}
        />
      )}
    </main>
  )
}
