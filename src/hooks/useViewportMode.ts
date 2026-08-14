import { useEffect, useState } from 'react'

const mobileQuery = '(max-width: 767px)'

export function useViewportMode() {
  const [isMobile, setIsMobile] = useState(() => {
    if (typeof window === 'undefined') {
      return false
    }

    return window.matchMedia(mobileQuery).matches
  })

  useEffect(() => {
    const media = window.matchMedia(mobileQuery)
    const updateViewport = () => setIsMobile(media.matches)

    updateViewport()
    media.addEventListener('change', updateViewport)

    return () => media.removeEventListener('change', updateViewport)
  }, [])

  return {
    isMobile,
    mode: isMobile ? 'mobile' : 'desktop',
  } as const
}
