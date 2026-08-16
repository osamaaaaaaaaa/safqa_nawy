import type { SafqaAssetKey } from '../../config/safqaAssets'

export type Locale = 'ar' | 'en'

export type SafqaLandingCopy = {
  brand: string
  switchLanguage: string
  nav: {
    home: string
    decision: string
    paths: string
    opportunities: string
    howItWorks: string
    process: string
    brokers: string
  }
  hero: {
    eyebrow: string
    title: string
    body: string
    primaryCta: string
    secondaryCta: string
    proofLabel: string
    proofValue: string
    heroCard: {
      cancelTitle: string
      cancelDeductLabel: string
      cancelDeductValue: string
      cancelGetLabel: string
      cancelGetValue: string
      cancelYearsLabel: string
      cancelYearsValue: string
      cancelNote: string
      vsLabel: string
      transferTitle: string
      transferGetLabel: string
      transferGetValue: string
      transferGetSub: string
      transferNote: string
    }
  }
  search: {
    title: string
    location: string
    type: string
    status: string
    submit: string
  }
  stats: Array<{ value: string; label: string }>
  // Seller vs Buyer two-col section
  sellerBuyer: {
    eyebrow: string
    title: string
    subtitle: string
    seller: {
      tag: string
      title: string
      body: string
      features: string[]
      freeNote: string
      cta: string
    }
    buyer: {
      tag: string
      title: string
      body: string
      features: string[]
      cta: string
    }
  }
  // Comparison table section
  comparison: {
    eyebrow: string
    title: string
    subtitle: string
    rows: Array<{
      label: string
      regular: string
      safqa: string
    }>
  }
  // Numbers example section
  numbersExample: {
    eyebrow: string
    title: string
    subtitle: string
    cancelCard: {
      title: string
      deductLabel: string
      deductValue: string
      getLabel: string
      getValue: string
      yearsLabel: string
      yearsValue: string
      note: string
    }
    transferCard: {
      title: string
      getLabel: string
      getValue: string
      getSub: string
      feeLabel: string
      feeValue: string
      feeSub: string
      note: string
    }
    disclaimer: string
  }
  paths: {
    eyebrow: string
    title: string
    items: Array<{
      title: string
      body: string
      action: string
    }>
  }
  // Steps how-it-works section
  howItWorks: {
    eyebrow: string
    title: string
    subtitle: string
    steps: Array<{
      title: string
      body: string
    }>
  }
  // Fair exit standards section
  fairExit: {
    eyebrow: string
    title: string
    subtitle: string
    items: Array<{
      title: string
      body: string
    }>
  }
  // Calculator CTA
  calculatorCta: {
    title: string
    subtitle: string
    cta: string
  }
  // Dual action CTA
  dualCta: {
    seller: {
      title: string
      body: string
      cta: string
    }
    buyer: {
      title: string
      body: string
      cta: string
    }
  }
  opportunities: {
    eyebrow: string
    title: string
    items: Array<{
      imageKey: SafqaAssetKey
      title: string
      location: string
      price: string
      oldPrice: string
      meta: string
      badge: string
      type: string
    }>
  }
  process: {
    eyebrow: string
    title: string
    body: string
    items: Array<{
      title: string
      body: string
    }>
  }
  broker: {
    eyebrow: string
    title: string
    body: string
    cards: Array<{
      value: string
      label: string
    }>
  }
  command: {
    eyebrow: string
    title: string
    body: string
    metrics: Array<{
      value: string
      label: string
    }>
    queue: Array<{
      title: string
      meta: string
      status: string
    }>
  }
  guarantees: {
    eyebrow: string
    title: string
    items: Array<{
      title: string
      body: string
    }>
  }
  testimonials: {
    eyebrow: string
    title: string
    items: Array<{
      imageKey: SafqaAssetKey
      quote: string
      name: string
      role: string
    }>
  }
  cta: {
    title: string
    body: string
    primary: string
    secondary: string
  }
  footer: {
    title: string
    body: string
    phone: string
    email: string
  }
  sellersPage: {
    title: string
    subtitle: string
    points: Array<string>
    ownersOnlyTitle: string
    ownersOnlyDesc: string
    form: {
      stepOf: string
      step1Title: string
      step2Title: string
      step3Title: string
      developerName: string
      projectName: string
      totalPrice: string
      amountPaid: string
      currentPrice: string
      currentPriceHint: string
      zeroOverAck: string
      remainingPrice: string
      nextInstallment: string
      frequency: string
      freqMonthly: string
      freqQuarterly: string
      freqSemiannual: string
      freqAnnual: string
      unitType: string
      typeApartment: string
      typeVilla: string
      typeTownhouse: string
      typeTwinhouse: string
      typeDuplex: string
      typePenthouse: string
      typeChalet: string
      typeLand: string
      typeRetail: string
      typeClinic: string
      typeOffice: string
      location: string
      area: string
      gardenArea: string
      floor: string
      bedrooms: string
      bathrooms: string
      finishingType: string
      finishingCoreShell: string
      finishingSemi: string
      finishingFully: string
      finishingFurnished: string
      deliveryStatus: string
      deliveryReady: string
      deliveryUnderConst: string
      description: string
      amenitiesLabel: string
      amenityPool: string
      amenityGarden: string
      amenityRoof: string
      amenitySecurity: string
      amenityClub: string
      amenityGarage: string
      amenityElevator: string
      amenityServices: string
      contractYear: string
      nextInstallmentDate: string
      maintenancePaid: string
      maintenanceAmount: string
      uploadContract: string
      uploadReceipts: string
      uploadHint: string
      locNewCairo: string
      locZayed: string
      locOctober: string
      locShorouk: string
      locMostakbal: string
      locCapital: string
      locNorthCoast: string
      locSokhna: string
      locOther: string
      name: string
      phone: string
      email: string
      ownerConfirm: string
      nextBtn: string
      backBtn: string
      submitBtn: string
      successTitle: string
      successSubtitle: string
      whatsappCta: string
      backHome: string
    }
    auth: {
      loginTab: string
      registerTab: string
      loginTitle: string
      registerTitle: string
      password: string
      confirmPassword: string
      loginBtn: string
      registerBtn: string
      noAccount: string
      haveAccount: string
      benefitsTitle: string
      benefit1: string
      benefit2: string
      benefit3: string
    }
  }
}
