export type Locale = 'ar' | 'en'

export type LandingCopy = {
  meta: {
    languageName: string
    switchLanguage: string
  }
  assets: {
    heroAlt: string
    propertyAlt: string
    aboutAlt: string
    listingAlt: string
    teamAlt: string
    personAlt: string
    blogAlt: string
  }
  nav: {
    exit: string
    deals: string
    trust: string
    start: string
  }
  hero: {
    eyebrow: string
    title: string
    body: string
    primaryCta: string
    secondaryCta: string
    proofLabel: string
    proofValue: string
  }
  search: {
    location: string
    locationPlaceholder: string
    type: string
    typePlaceholder: string
    status: string
    statusPlaceholder: string
    budget: string
    budgetPlaceholder: string
    submit: string
  }
  offers: {
    eyebrow: string
    title: string
    cards: Array<{
      oldPrice: string
      price: string
      installment: string
      title: string
      location: string
      specs: string[]
      agent: string
      badge: string
    }>
  }
  services: {
    eyebrow: string
    title: string
    items: Array<{ title: string; body: string }>
  }
  stats: Array<{ value: string; label: string }>
  cities: {
    eyebrow: string
    title: string
    action: string
    items: Array<{ location: string; count: string }>
  }
  testimonials: {
    eyebrow: string
    title: string
    items: Array<{ quote: string; name: string; position: string }>
  }
  agents: {
    eyebrow: string
    title: string
    items: Array<{ name: string; details: string }>
  }
  blog: {
    eyebrow: string
    title: string
    meta: string
    items: Array<{ title: string }>
  }
  footer: {
    body: string
    columns: Array<{ title: string; links: string[] }>
    contactTitle: string
    address: string
    phone: string
    email: string
    copyright: string
  }
  mobileHero: {
    title: string
    body: string
    primaryCta: string
  }
  routes: {
    distressed: {
      label: string
      title: string
      body: string
      action: string
    }
    buyer: {
      label: string
      title: string
      body: string
      action: string
    }
    broker: {
      label: string
      title: string
      body: string
      action: string
    }
  }
  trust: {
    title: string
    items: string[]
  }
  command: {
    title: string
    subtitle: string
    stages: Array<{
      label: string
      value: string
    }>
  }
  mobileDock: {
    sell: string
    buy: string
    close: string
  }
}
