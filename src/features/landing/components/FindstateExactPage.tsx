import { useState } from 'react'
import type { Locale } from '../../../i18n/types'

type FindstateExactPageProps = {
  locale: Locale
  nextLocale: Locale
  onLocaleChange: (locale: Locale) => void
}

const propertyImages = ['work-1.jpg', 'work-2.jpg', 'work-3.jpg', 'work-4.jpg', 'work-5.jpg', 'work-6.jpg']
const listingImages = ['listing-1.jpg', 'listing-2.jpg', 'listing-3.jpg', 'listing-4.jpg', 'listing-5.jpg', 'listing-6.jpg']
const teamImages = ['team-1.jpg', 'team-2.jpg', 'team-3.jpg', 'team-4.jpg']
const blogImages = ['image_1.jpg', 'image_2.jpg', 'image_3.jpg', 'image_4.jpg']
const peopleImages = ['person_1.jpg', 'person_2.jpg', 'person_3.jpg']

const content = {
  ar: {
    switchLanguage: 'English',
    nav: ['الرئيسية', 'الخدمات', 'الفريق', 'الفرص', 'الدليل'],
    menu: 'القائمة',
    heroTitle: ['بيع وحدتك بدون خسارة', 'أو اشتري بسعر تعاقد قديم'],
    heroCta: 'ابحث عن فرصة',
    searchLabels: ['الموقع', 'نوع الوحدة', 'حالة الصفقة', 'حد السعر'],
    searchPlaceholder: 'المدينة أو الكمبوند',
    selectType: 'اختار النوع',
    selectBudget: 'اختار الميزانية',
    options: ['تنازل', 'متعثر في السداد', 'صفقة بروكر'],
    searchSubmit: 'ابحث عن صفقة',
    offersEyebrow: 'فرص مختارة',
    offersTitle: 'وحدات وصفقات متحققة بالمستندات',
    teamName: 'فريق صفقة',
    currency: ' جنيه',
    properties: [
      ['4,800,000', '3,950,000', 'وحدة جاهزة للتنازل', 'القاهرة الجديدة، عقد قديم'],
      ['6,200,000', '5,100,000', 'فرصة بسعر أقل من السوق', '6 أكتوبر، أقساط قائمة'],
      ['3,400,000', '2,850,000', 'عقد بروكر قابل للإغلاق', 'العاصمة الإدارية، عمولة واضحة'],
      ['5,700,000', '4,900,000', 'تنازل سريع بدون أوفر', 'زايد الجديدة، استلام قريب'],
      ['8,100,000', '6,950,000', 'فيلا بسعر تعاقد سابق', 'الساحل الشمالي، أقساط مرنة'],
      ['2,900,000', '2,350,000', 'وحدة لمشتري جاد', 'المستقبل، تنازل موثق'],
    ],
    servicesEyebrow: 'الخدمات',
    servicesTitle: 'ليه تختار صفقة؟',
    services: [
      ['flaticon-piggy-bank', 'خروج آمن من التعثر', 'نراجع عقدك ومدفوعاتك ونساعدك تعرض الوحدة للتنازل بدل خسارة الإلغاء.'],
      ['flaticon-wallet', 'فرص بسعر تعاقد قديم', 'المشتري يشوف وحدات بسعر أقدم من السوق ويكمل الأقساط بأرقام واضحة.'],
      ['flaticon-file', 'كل رقم بمستند', 'قبل العرض أو الشراء بنراجع العقد، المدفوع، المتبقي، وأي مصاريف تنازل.'],
      ['flaticon-locked', 'إغلاق صفقات البروكرز', 'البروكر الفريلانسر يسجل الصفقة وإحنا نقفلها من خلال الشركة ونتابع العمولة.'],
    ],
    stats: [
      ['305', 'ملف وحدة'],
      ['1090', 'فرصة مفهرسة'],
      ['209', 'صفقة جاهزة'],
      ['67', 'بروكر متعاون'],
    ],
    citiesEyebrow: 'ابحث بالمناطق',
    citiesTitle: 'فرص تنازل في أهم المناطق',
    cityAction: 'شوف الفرص',
    cities: [
      ['القاهرة الجديدة', '100 فرصة تنازل'],
      ['6 أكتوبر', '86 فرصة'],
      ['العاصمة الإدارية', '74 فرصة'],
      ['زايد الجديدة', '58 فرصة'],
      ['الساحل الشمالي', '44 فرصة'],
      ['المستقبل سيتي', '39 فرصة'],
    ],
    testimonialsEyebrow: 'آراء العملاء',
    testimonialsTitle: 'عملاء خرجوا من التعثر بهدوء',
    testimonial:
      'كنت داخل على إلغاء وخسارة كبيرة، لكن صفقة رتبت الورق وخلت التنازل واضح خطوة بخطوة.',
    clientName: 'عميل صفقة',
    clientRole: 'تجربة موثقة',
    agentsEyebrow: 'الفريق',
    agentsTitle: 'فريق الإغلاق والمتابعة',
    agents: ['فريق الفحص', 'إدارة التنازل', 'غرفة الصفقات', 'دعم البروكرز'],
    activeFiles: 'ملف نشط',
    blogEyebrow: 'الدليل',
    blogTitle: 'دليل التنازل والصفقات',
    blogMetaOne: 'صفقة',
    blogMetaTwo: 'تحديثات السوق',
    blogPosts: [
      'إزاي تبيع وحدتك قبل ما تخسر في الإلغاء؟',
      'يعني إيه تشتري بسعر تعاقد قديم؟',
      'خطوات التنازل من أول المستندات لحد الإمضاء',
      'دليل البروكر الفريلانسر لقفل صفقة آمنة',
    ],
    footerTitles: ['صفقة', 'المجتمع', 'عن صفقة', 'الشركة', 'عندك سؤال؟'],
    footerBody: 'منصة لتسهيل التنازل، حماية البائع المتعثر، ومساعدة البروكرز على إغلاق صفقاتهم.',
    footerLinks: ['ابحث عن وحدة', 'للبروكرز', 'تواصل معنا'],
    copyright: 'Copyright © All rights reserved | Safqa',
  },
  en: {
    switchLanguage: 'العربية',
    nav: ['Home', 'Services', 'Team', 'Listings', 'Guide'],
    menu: 'Menu',
    heroTitle: ['Sell your unit without loss', 'or buy at an older contract price'],
    heroCta: 'Search opportunities',
    searchLabels: ['Location', 'Unit Type', 'Deal Status', 'Price Limit'],
    searchPlaceholder: 'City or compound',
    selectType: 'Choose type',
    selectBudget: 'Choose budget',
    options: ['Transfer', 'Payment difficulty', 'Broker deal'],
    searchSubmit: 'Search Deal',
    offersEyebrow: 'Selected Offers',
    offersTitle: 'Verified units and broker deals',
    teamName: 'Safqa Team',
    currency: ' EGP',
    properties: [
      ['4,800,000', '3,950,000', 'Unit ready for transfer', 'New Cairo, older contract'],
      ['6,200,000', '5,100,000', 'Below-market opportunity', '6th October, active installments'],
      ['3,400,000', '2,850,000', 'Broker contract ready to close', 'New Capital, clear commission'],
      ['5,700,000', '4,900,000', 'Fast transfer with no overprice', 'New Zayed, near delivery'],
      ['8,100,000', '6,950,000', 'Villa at previous contract price', 'North Coast, flexible installments'],
      ['2,900,000', '2,350,000', 'Unit for a serious buyer', 'Mostakbal, documented transfer'],
    ],
    servicesEyebrow: 'Services',
    servicesTitle: 'Why Choose Safqa?',
    services: [
      ['flaticon-piggy-bank', 'Safe exit from difficulty', 'We review your contract and paid amounts before listing the unit for transfer.'],
      ['flaticon-wallet', 'Older contract prices', 'Buyers find units priced below today’s market and continue installments with clear numbers.'],
      ['flaticon-file', 'Every number documented', 'We verify the contract, paid amount, remaining balance, and transfer costs.'],
      ['flaticon-locked', 'Broker deal closing', 'Freelance brokers register deals and we close them through the company while tracking commission.'],
    ],
    stats: [
      ['305', 'Unit Files'],
      ['1090', 'Indexed Deals'],
      ['209', 'Ready Deals'],
      ['67', 'Partner Brokers'],
    ],
    citiesEyebrow: 'Find Properties',
    citiesTitle: 'Transfer opportunities in key areas',
    cityAction: 'See Listings',
    cities: [
      ['New Cairo', '100 transfer opportunities'],
      ['6th October', '86 opportunities'],
      ['New Capital', '74 opportunities'],
      ['New Zayed', '58 opportunities'],
      ['North Coast', '44 opportunities'],
      ['Mostakbal City', '39 opportunities'],
    ],
    testimonialsEyebrow: 'Testimonial',
    testimonialsTitle: 'Clients who exited difficulty calmly',
    testimonial:
      'I was close to cancellation and a major loss. Safqa organized the documents and made the transfer clear step by step.',
    clientName: 'Safqa Client',
    clientRole: 'Verified experience',
    agentsEyebrow: 'Team',
    agentsTitle: 'Closing and follow-up team',
    agents: ['Audit Team', 'Transfer Desk', 'Deal Room', 'Broker Support'],
    activeFiles: 'active files',
    blogEyebrow: 'Guide',
    blogTitle: 'Transfer and deal guide',
    blogMetaOne: 'Safqa',
    blogMetaTwo: 'Market updates',
    blogPosts: [
      'How to sell your unit before cancellation losses hit',
      'What buying at an older contract price really means',
      'Transfer steps from documents to signature',
      'A freelance broker guide to safer deal closing',
    ],
    footerTitles: ['Safqa', 'Community', 'About Safqa', 'Company', 'Questions?'],
    footerBody: 'A platform for property transfers, distressed seller protection, and broker deal closing.',
    footerLinks: ['Search units', 'For brokers', 'Contact us'],
    copyright: 'Copyright © All rights reserved | Safqa',
  },
} as const

export function FindstateExactPage({ locale, nextLocale, onLocaleChange }: FindstateExactPageProps) {
  const [isMenuOpen, setIsMenuOpen] = useState(false)
  const [selectedProperty, setSelectedProperty] = useState<number | null>(null)
  const copy = content[locale]
  const textDirection = locale === 'ar' ? 'rtl' : 'ltr'
  const openProperty = (index: number) => {
    setSelectedProperty(index)
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  if (selectedProperty !== null) {
    return (
      <PropertyDetailsPage
        copy={copy}
        image={propertyImages[selectedProperty]}
        property={copy.properties[selectedProperty]}
        textDirection={textDirection}
        isMenuOpen={isMenuOpen}
        locale={locale}
        nextLocale={nextLocale}
        onBack={() => setSelectedProperty(null)}
        onLocaleChange={onLocaleChange}
        onMenuToggle={() => setIsMenuOpen((value) => !value)}
      />
    )
  }

  return (
    <div dir="ltr">
      <nav className="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
        <div className="container">
          <a className="navbar-brand" href="/">
            Safqa
          </a>
          <button className="navbar-toggler" type="button" aria-label="Toggle navigation" onClick={() => setIsMenuOpen((value) => !value)}>
            <span className="oi oi-menu" /> {copy.menu}
          </button>
          <div className={`collapse navbar-collapse ${isMenuOpen ? 'show' : ''}`} id="ftco-nav">
            <ul className="navbar-nav ml-auto">
              {copy.nav.map((item, index) => (
                <li className={`nav-item ${index === 0 ? 'active' : ''}`} key={item}>
                  <a href={['#home', '#services', '#agents', '#listing', '#blog'][index]} className="nav-link">
                    {item}
                  </a>
                </li>
              ))}
              <li className="nav-item cta">
                <button className="nav-link" type="button" onClick={() => onLocaleChange(nextLocale)}>
                  {copy.switchLanguage}
                </button>
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <div className="hero-wrap" id="home" style={{ backgroundImage: "url('/findstate/images/bg_2.jpg')" }}>
        <div className="overlay" />
        <div className="overlay-2" />
        <div className="container">
          <div className="row no-gutters slider-text justify-content-center align-items-center">
            <div className="col-lg-8 col-md-6 ftco-animate d-flex align-items-end">
              <div className="text text-center w-100" dir={textDirection}>
                <h1 className="mb-4">
                  {copy.heroTitle[0]} <br />
                  {copy.heroTitle[1]}
                </h1>
                <p>
                  <a href="#search" className="btn btn-primary py-3 px-4">
                    {copy.heroCta}
                  </a>
                </p>
              </div>
            </div>
          </div>
        </div>
        <div className="mouse">
          <a href="#search" className="mouse-icon">
            <div className="mouse-wheel">
              <span className="ion-ios-arrow-round-down" />
            </div>
          </a>
        </div>
      </div>

      <section className="ftco-section ftco-no-pb" id="search" dir={textDirection}>
        <div className="container">
          <div className="row">
            <div className="col-md-12">
              <div className="search-wrap-1 ftco-animate">
                <form action="#" className="search-property-1">
                  <div className="row">
                    {copy.searchLabels.map((label, index) => (
                      <div className="col-lg align-items-end" key={label}>
                        <div className="form-group">
                          <label>{label}</label>
                          <div className="form-field">
                            {index === 0 ? (
                              <>
                                <div className="icon">
                                  <span className="ion-ios-search" />
                                </div>
                                <input type="text" className="form-control" placeholder={copy.searchPlaceholder} />
                              </>
                            ) : (
                              <div className="select-wrap">
                                <div className="icon">
                                  <span className="ion-ios-arrow-down" />
                                </div>
                                <select className="form-control" defaultValue="">
                                  <option value="">{index === 3 ? copy.selectBudget : copy.selectType}</option>
                                  {copy.options.map((option) => (
                                    <option key={option}>{option}</option>
                                  ))}
                                </select>
                              </div>
                            )}
                          </div>
                        </div>
                      </div>
                    ))}
                    <div className="col-lg align-self-end">
                      <div className="form-group">
                        <div className="form-field">
                          <input type="submit" value={copy.searchSubmit} className="form-control btn btn-primary" />
                        </div>
                      </div>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="ftco-section goto-here" dir={textDirection}>
        <div className="container">
          <div className="row justify-content-center">
            <div className="col-md-12 heading-section text-center ftco-animate mb-5">
              <span className="subheading">{copy.offersEyebrow}</span>
              <h2 className="mb-2">{copy.offersTitle}</h2>
            </div>
          </div>
          <div className="row">
            {propertyImages.map((image, index) => (
              <div className="col-md-4" key={image}>
                <div className="property-wrap ftco-animate">
                  <div className="img d-flex align-items-center justify-content-center" style={{ backgroundImage: `url('/findstate/images/${image}')` }}>
                    <a
                      href="#property-details"
                      className="icon d-flex align-items-center justify-content-center btn-custom"
                      onClick={(event) => {
                        event.preventDefault()
                        openProperty(index)
                      }}
                    >
                      <span className="ion-ios-link" />
                    </a>
                    <div className="list-agent d-flex align-items-center">
                      <a href="#home" className="agent-info d-flex align-items-center">
                        <div className="img-2 rounded-circle" style={{ backgroundImage: "url('/findstate/images/person_1.jpg')" }} />
                        <h3 className="mb-0 ml-2">{copy.teamName}</h3>
                      </a>
                    </div>
                  </div>
                  <div className="text">
                    <p className="price mb-3">
                      <span className="old-price">{copy.properties[index][0]}</span>
                      <span className="orig-price">
                        {copy.properties[index][1]}<small>{copy.currency}</small>
                      </span>
                    </p>
                    <h3 className="mb-0">
                      <a
                        href="#property-details"
                        onClick={(event) => {
                          event.preventDefault()
                          openProperty(index)
                        }}
                      >
                        {copy.properties[index][2]}
                      </a>
                    </h3>
                    <span className="location d-inline-block mb-3">
                      <i className="ion-ios-pin mr-2" />
                      {copy.properties[index][3]}
                    </span>
                    <ul className="property_list">
                      <li><span className="flaticon-bed" />3</li>
                      <li><span className="flaticon-bathtub" />2</li>
                      <li><span className="flaticon-floor-plan" />1,878 sqft</li>
                    </ul>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="ftco-section ftco-fullwidth" id="services" dir={textDirection}>
        <div className="overlay" />
        <div className="container">
          <div className="row justify-content-center">
            <div className="col-md-12 heading-section text-center ftco-animate mb-5">
              <span className="subheading">{copy.servicesEyebrow}</span>
              <h2 className="mb-2">{copy.servicesTitle}</h2>
            </div>
          </div>
        </div>
        <div className="container-fluid px-0">
          <div className="row d-md-flex text-wrapper align-items-stretch">
            <div className="one-half mb-md-0 mb-4 img d-flex align-self-stretch" style={{ backgroundImage: "url('/findstate/images/about.jpg')" }} />
            <div className="one-half half-text d-flex justify-content-end align-items-center">
              <div className="text-inner pl-md-5">
                <div className="row d-flex">
                  {copy.services.map(([icon, title, body]) => (
                    <div className="col-md-12 d-flex align-self-stretch ftco-animate" key={title}>
                      <div className="media block-6 services-wrap d-flex">
                        <div className="icon d-flex justify-content-center align-items-center">
                          <span className={icon} />
                        </div>
                        <div className="media-body pl-4">
                          <h3>{title}</h3>
                          <p>{body}</p>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="ftco-counter ftco-section img" id="section-counter" dir={textDirection}>
        <div className="overlay" />
        <div className="container">
          <div className="row">
            {copy.stats.map(([value, label], index) => (
              <div className="col-md-6 col-lg-3 justify-content-center counter-wrap ftco-animate" key={label}>
                <div className="block-18">
                  <div className={`text ${index < 3 ? 'text-border' : ''} d-flex align-items-center`}>
                    <strong className="number">{value}</strong>
                    <span>{label}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="ftco-section" id="listing" dir={textDirection}>
        <div className="container">
          <div className="row justify-content-center">
            <div className="col-md-12 heading-section text-center ftco-animate mb-5">
              <span className="subheading">{copy.citiesEyebrow}</span>
              <h2 className="mb-2">{copy.citiesTitle}</h2>
            </div>
          </div>
          <div className="row">
            {listingImages.map((image, index) => (
              <div className="col-md-4" key={image}>
                <div className="listing-wrap img rounded d-flex align-items-end ftco-animate" style={{ backgroundImage: `url('/findstate/images/${image}')` }}>
                  <div className="location">
                    <span className="rounded">{copy.cities[index][0]}</span>
                  </div>
                  <div className="text">
                    <h3><a href="#home">{copy.cities[index][1]}</a></h3>
                    <a href="#home" className="btn-link">
                      {copy.cityAction} <span className="ion-ios-arrow-round-forward" />
                    </a>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="ftco-section testimony-section bg-light" dir={textDirection}>
        <div className="container">
          <div className="row justify-content-center mb-5">
            <div className="col-md-7 text-center heading-section ftco-animate">
              <span className="subheading">{copy.testimonialsEyebrow}</span>
              <h2 className="mb-3">{copy.testimonialsTitle}</h2>
            </div>
          </div>
          <div className="row ftco-animate">
            {peopleImages.map((image) => (
              <div className="col-md-4" key={image}>
                <div className="testimony-wrap py-4">
                  <div className="text">
                    <p className="mb-4">{copy.testimonial}</p>
                    <div className="d-flex align-items-center">
                      <div className="user-img" style={{ backgroundImage: `url('/findstate/images/${image}')` }} />
                      <div className="pl-3">
                        <p className="name">{copy.clientName}</p>
                        <span className="position">{copy.clientRole}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="ftco-section ftco-agent" id="agents" dir={textDirection}>
        <div className="container">
          <div className="row justify-content-center pb-5">
            <div className="col-md-12 heading-section text-center ftco-animate">
              <span className="subheading">{copy.agentsEyebrow}</span>
              <h2 className="mb-4">{copy.agentsTitle}</h2>
            </div>
          </div>
          <div className="row">
            {teamImages.map((image, index) => (
              <div className="col-md-3 ftco-animate" key={image}>
                <div className="agent">
                  <div className="img">
                    <img src={`/findstate/images/${image}`} className="img-fluid" alt="" />
                  </div>
                  <div className="desc">
                    <h3><a href="#home">{copy.agents[index]}</a></h3>
                    <p className="h-info">
                      <span className="ion-ios-filing icon" /> <span className="details">{25 + index * 5} {copy.activeFiles}</span>
                    </p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="ftco-section ftco-no-pt" id="blog" dir={textDirection}>
        <div className="container">
          <div className="row justify-content-center mb-5">
            <div className="col-md-7 heading-section text-center ftco-animate">
              <span className="subheading">{copy.blogEyebrow}</span>
              <h2>{copy.blogTitle}</h2>
            </div>
          </div>
          <div className="row d-flex">
            {blogImages.map((image, index) => (
              <div className="col-md-3 d-flex ftco-animate" key={image}>
                <div className="blog-entry justify-content-end">
                  <div className="text">
                    <a href="#home" className="block-20 img" style={{ backgroundImage: `url('/findstate/images/${image}')` }} />
                    <h3 className="heading"><a href="#home">{copy.blogPosts[index]}</a></h3>
                    <div className="meta mb-3">
                      <div><a href="#home">{copy.blogMetaOne}</a></div>
                      <div><a href="#home">{copy.blogMetaTwo}</a></div>
                      <div><a href="#home" className="meta-chat"><span className="icon-chat" /> 3</a></div>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <footer className="ftco-footer ftco-section" dir={textDirection}>
        <div className="container">
          <div className="row mb-5">
            {copy.footerTitles.map((title) => (
              <div className="col-md" key={title}>
                <div className="ftco-footer-widget mb-4">
                  <h2 className="ftco-heading-2">{title}</h2>
                  {title === copy.footerTitles[0] ? (
                    <p>{copy.footerBody}</p>
                  ) : (
                    <ul className="list-unstyled">
                      {copy.footerLinks.map((link) => (
                        <li key={link}>
                          <a href="#home"><span className="icon-long-arrow-right mr-2" />{link}</a>
                        </li>
                      ))}
                    </ul>
                  )}
                </div>
              </div>
            ))}
          </div>
          <div className="row">
            <div className="col-md-12 text-center">
              <p>{copy.copyright}</p>
            </div>
          </div>
        </div>
      </footer>
    </div>
  )
}

type DetailCopy = (typeof content)[Locale]

type PropertyDetailsPageProps = {
  copy: DetailCopy
  image: string
  property: readonly string[]
  textDirection: 'rtl' | 'ltr'
  isMenuOpen: boolean
  locale: Locale
  nextLocale: Locale
  onBack: () => void
  onLocaleChange: (locale: Locale) => void
  onMenuToggle: () => void
}

function PropertyDetailsPage({
  copy,
  image,
  property,
  textDirection,
  isMenuOpen,
  locale,
  nextLocale,
  onBack,
  onLocaleChange,
  onMenuToggle,
}: PropertyDetailsPageProps) {
  const features =
    locale === 'ar'
      ? [
          ['المساحة: 1,878 قدم', 'غرف النوم: 3', 'الحمامات: 2', 'حالة العقد: قابل للتنازل', 'المدفوع: موثق'],
          ['المتبقي: أقساط قائمة', 'سنة التعاقد: قديم', 'المستندات: جاهزة', 'إجراء التنازل: قيد الفحص', 'العمولة: واضحة'],
          ['سعر السوق: أعلى', 'الأوفر: بدون مبالغة', 'الفحص: متاح', 'الاستلام: حسب العقد', 'المتابعة: من صفقة'],
        ]
      : [
          ['Area: 1,878 sqft', 'Bedrooms: 3', 'Bathrooms: 2', 'Contract: transferable', 'Paid amount: documented'],
          ['Remaining: active installments', 'Contract year: older price', 'Documents: ready', 'Transfer: under audit', 'Commission: clear'],
          ['Market price: higher', 'Overprice: controlled', 'Audit: available', 'Delivery: per contract', 'Follow-up: Safqa'],
        ]

  return (
    <div dir="ltr" id="property-details">
      <nav className="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
        <div className="container">
          <a
            className="navbar-brand"
            href="#home"
            onClick={(event) => {
              event.preventDefault()
              onBack()
            }}
          >
            Safqa
          </a>
          <button className="navbar-toggler" type="button" aria-label="Toggle navigation" onClick={onMenuToggle}>
            <span className="oi oi-menu" /> {copy.menu}
          </button>
          <div className={`collapse navbar-collapse ${isMenuOpen ? 'show' : ''}`} id="ftco-nav">
            <ul className="navbar-nav ml-auto">
              <li className="nav-item">
                <a
                  href="#home"
                  className="nav-link"
                  onClick={(event) => {
                    event.preventDefault()
                    onBack()
                  }}
                >
                  {copy.nav[0]}
                </a>
              </li>
              <li className="nav-item active">
                <a href="#property-details" className="nav-link">
                  {copy.nav[3]}
                </a>
              </li>
              <li className="nav-item cta">
                <button className="nav-link" type="button" onClick={() => onLocaleChange(nextLocale)}>
                  {copy.switchLanguage}
                </button>
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <section className="hero-wrap hero-wrap-2 ftco-degree-bg js-fullheight" style={{ backgroundImage: "url('/findstate/images/bg_1.jpg')" }}>
        <div className="overlay" />
        <div className="overlay-2" />
        <div className="container">
          <div className="row no-gutters slider-text js-fullheight align-items-end justify-content-center">
            <div className="col-md-9 ftco-animate pb-5 mb-5 text-center" dir={textDirection}>
              <h1 className="mb-3 bread">{locale === 'ar' ? 'تفاصيل الوحدة' : 'Property Details'}</h1>
              <p className="breadcrumbs">
                <span className="mr-2">
                  <a
                    href="#home"
                    onClick={(event) => {
                      event.preventDefault()
                      onBack()
                    }}
                  >
                    {copy.nav[0]} <i className="ion-ios-arrow-forward" />
                  </a>
                </span>
                <span>
                  {locale === 'ar' ? 'تفاصيل الوحدة' : 'Property Details'}
                  <i className="ion-ios-arrow-forward" />
                </span>
              </p>
            </div>
          </div>
        </div>
      </section>

      <section className="ftco-section ftco-property-details" dir={textDirection}>
        <div className="container">
          <div className="row justify-content-center">
            <div className="col-md-12">
              <div className="property-details">
                <div className="img rounded" style={{ backgroundImage: `url('/findstate/images/${image}')` }} />
                <div className="text">
                  <h2>{property[2]}</h2>
                  <span className="subheading">{property[3]}</span>
                </div>
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-md-12 pills">
              <div className="bd-example bd-example-tabs">
                <div className="d-flex">
                  <ul className="nav nav-pills mb-2" id="pills-tab" role="tablist">
                    <li className="nav-item">
                      <a className="nav-link active" href="#pills-description">
                        {locale === 'ar' ? 'المميزات' : 'Features'}
                      </a>
                    </li>
                    <li className="nav-item">
                      <a className="nav-link" href="#pills-manufacturer">
                        {locale === 'ar' ? 'الوصف' : 'Description'}
                      </a>
                    </li>
                    <li className="nav-item">
                      <a className="nav-link" href="#pills-review">
                        {locale === 'ar' ? 'المراجعات' : 'Review'}
                      </a>
                    </li>
                  </ul>
                </div>

                <div className="tab-content" id="pills-tabContent">
                  <div className="tab-pane fade show active" id="pills-description" role="tabpanel">
                    <div className="row">
                      {features.map((group, index) => (
                        <div className="col-md-4" key={index}>
                          <ul className="features">
                            {group.map((feature) => (
                              <li className="check" key={feature}>
                                <span className="ion-ios-checkmark-circle" />
                                {feature}
                              </li>
                            ))}
                          </ul>
                        </div>
                      ))}
                    </div>
                  </div>

                  <div className="tab-pane fade show" id="pills-manufacturer" role="tabpanel">
                    <p>
                      {locale === 'ar'
                        ? 'هذه الوحدة معروضة كفرصة تنازل موثقة. فريق صفقة يراجع العقد والمدفوع والمتبقي قبل أي خطوة، ثم ينسق إجراءات التنازل بين البائع والمشتري أو البروكر حتى الإتمام.'
                        : 'This unit is listed as a documented transfer opportunity. Safqa reviews the contract, paid amount, and remaining balance before any step, then coordinates transfer procedures until completion.'}
                    </p>
                    <p>
                      {locale === 'ar'
                        ? 'الأرقام المعروضة هنا مبدئية وتحتاج مراجعة المستندات الأصلية قبل الحجز أو التوقيع.'
                        : 'The figures shown here are preliminary and require original document review before reservation or signature.'}
                    </p>
                  </div>

                  <div className="tab-pane fade show" id="pills-review" role="tabpanel">
                    <div className="row">
                      <div className="col-md-7">
                        <h3 className="head">{locale === 'ar' ? 'مراجعات العملاء' : 'Client Reviews'}</h3>
                        {peopleImages.map((person) => (
                          <div className="review d-flex" key={person}>
                            <div className="user-img" style={{ backgroundImage: `url('/findstate/images/${person}')` }} />
                            <div className="desc">
                              <h4>
                                <span className="text-left">{copy.clientName}</span>
                                <span className="text-right">Safqa</span>
                              </h4>
                              <p className="star">
                                <span>
                                  <i className="ion-ios-star" />
                                  <i className="ion-ios-star" />
                                  <i className="ion-ios-star" />
                                  <i className="ion-ios-star" />
                                  <i className="ion-ios-star" />
                                </span>
                              </p>
                              <p>{copy.testimonial}</p>
                            </div>
                          </div>
                        ))}
                      </div>
                      <div className="col-md-5">
                        <div className="rating-wrap">
                          <h3 className="head">{locale === 'ar' ? 'تقييم الصفقة' : 'Deal Rating'}</h3>
                          <div className="wrap">
                            {['98%', '85%', '70%', '10%', '0%'].map((rating) => (
                              <p className="star" key={rating}>
                                <span>
                                  <i className="ion-ios-star" />
                                  <i className="ion-ios-star" />
                                  <i className="ion-ios-star" />
                                  <i className="ion-ios-star" />
                                  <i className="ion-ios-star" />({rating})
                                </span>
                                <span>{locale === 'ar' ? 'مراجعات' : 'Reviews'}</span>
                              </p>
                            ))}
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <footer className="ftco-footer ftco-section" dir={textDirection}>
        <div className="container">
          <div className="row mb-5">
            {copy.footerTitles.map((title) => (
              <div className="col-md" key={title}>
                <div className="ftco-footer-widget mb-4">
                  <h2 className="ftco-heading-2">{title}</h2>
                  {title === copy.footerTitles[0] ? (
                    <p>{copy.footerBody}</p>
                  ) : (
                    <ul className="list-unstyled">
                      {copy.footerLinks.map((link) => (
                        <li key={link}>
                          <a href="#home">
                            <span className="icon-long-arrow-right mr-2" />
                            {link}
                          </a>
                        </li>
                      ))}
                    </ul>
                  )}
                </div>
              </div>
            ))}
          </div>
          <div className="row">
            <div className="col-md-12 text-center">
              <p>{copy.copyright}</p>
            </div>
          </div>
        </div>
      </footer>
    </div>
  )
}
