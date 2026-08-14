import { useEffect, useState } from 'react'

const animatedSelector = [
  '.ftco-animate',
  '.section-heading',
  '.findstate-search',
  '.mobile-search-card',
  '.property-card',
  '.mobile-property-card',
  '.service-row',
  '.stat-item',
  '.city-card',
  '.testimonial-card',
  '.agent-card',
  '.blog-card',
  '.route-card',
  '.trust-item',
  '.findstate-footer section',
].join(',')

export function useFindstateMotion() {
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    const loaderTimer = window.setTimeout(() => setIsLoading(false), 260)

    const nav = document.querySelector('.findstate-nav')
    const updateNav = () => {
      if (!nav) {
        return
      }

      const scrollTop = window.scrollY
      nav.classList.toggle('scrolled', scrollTop > 150)
      nav.classList.toggle('awake', scrollTop > 350)
      nav.classList.toggle('sleep', scrollTop > 150 && scrollTop <= 350)
    }

    const animatedElements = Array.from(document.querySelectorAll<HTMLElement>(animatedSelector))
    animatedElements.forEach((element, index) => {
      element.classList.add('ftco-animate')
      element.style.setProperty('--ftco-delay', `${(index % 6) * 50}ms`)
    })

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (!entry.isIntersecting) {
            return
          }

          const element = entry.target as HTMLElement
          element.classList.add('item-animate')
          window.setTimeout(() => {
            const effect = element.dataset.animateEffect ?? 'fadeInUp'
            element.classList.add(effect, 'ftco-animated')
            element.classList.remove('item-animate')
          }, 100)
          observer.unobserve(element)
        })
      },
      { threshold: 0.05, rootMargin: '0px 0px -5% 0px' },
    )

    animatedElements.forEach((element) => observer.observe(element))
    updateNav()
    window.addEventListener('scroll', updateNav, { passive: true })

    return () => {
      window.clearTimeout(loaderTimer)
      window.removeEventListener('scroll', updateNav)
      observer.disconnect()
    }
  }, [])

  return { isLoading }
}
