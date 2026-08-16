import { useState, useEffect, useRef } from 'react'
import {
  ArrowLeft,
  ArrowRight,
  BadgeCheck,
  Building2,
  CircleDollarSign,
  ClipboardCheck,
  FileUp,
  Globe2,
  Handshake,
  MapPin,
  Search,
  ShieldCheck,
  Calculator,
  Lock,
  Heart,
  User,
  Check,
  ChevronDown,
  LogOut,
  Menu,
  X,
} from 'lucide-react'
import './App.css'

interface CustomSelectProps {
  options: Array<{ value: string; label: string }>
  value: string
  onChange: (val: string) => void
  placeholder?: string
  hasError?: boolean
  required?: boolean
}

function CustomSelect({ options, value, onChange, placeholder, hasError, required }: CustomSelectProps) {
  const [isOpen, setIsOpen] = useState(false)
  const containerRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    function handleClickOutside(event: PointerEvent) {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false)
      }
    }
    document.addEventListener('pointerdown', handleClickOutside)
    return () => document.removeEventListener('pointerdown', handleClickOutside)
  }, [])

  const selectedOpt = options.find(o => o.value === value)

  return (
    <div 
      className={`custom-select-container ${isOpen ? 'is-open' : ''} ${hasError ? 'select-error' : ''}`} 
      ref={containerRef}
    >
      <div 
        className="custom-select-trigger" 
        onClick={() => setIsOpen(!isOpen)}
        tabIndex={0}
        onKeyDown={(e) => { if (e.key === 'Enter' || e.key === ' ') { setIsOpen(!isOpen); e.preventDefault(); } }}
      >
        <span className={!selectedOpt ? 'placeholder-active' : ''}>
          {selectedOpt ? selectedOpt.label : placeholder}
        </span>
        <ChevronDown className="select-arrow" size={16} />
      </div>
      {isOpen && (
        <div className="custom-select-options">
          {options.map((opt) => (
            <div 
              key={opt.value} 
              className={`custom-select-option ${value === opt.value ? 'selected' : ''}`}
              onClick={() => {
                onChange(opt.value)
                setIsOpen(false)
              }}
            >
              {opt.label}
            </div>
          ))}
        </div>
      )}
      {required && (
        <input
          type="text"
          value={value}
          onChange={() => {}}
          required
          style={{
            position: 'absolute',
            width: 0,
            height: 0,
            opacity: 0,
            pointerEvents: 'none',
          }}
        />
      )}
    </div>
  )
}
import { safqaAssets } from './config/safqaAssets'
import { safqaLandingCopy } from './features/landing/safqaLandingCopy'
import type { Locale } from './features/landing/safqaLandingTypes'

const pathIcons = [FileUp, Building2, Handshake] as const
const processIcons = [ClipboardCheck, BadgeCheck, ShieldCheck] as const
const fairExitIcons = [BadgeCheck, CircleDollarSign, Lock, Heart] as const

function CountUp({ end, duration = 1500 }: { end: number; duration?: number }) {
  const [count, setCount] = useState(0)
  useEffect(() => {
    let startTimestamp: number | null = null
    const step = (timestamp: number) => {
      if (!startTimestamp) startTimestamp = timestamp
      const progress = Math.min((timestamp - startTimestamp) / duration, 1)
      setCount(Math.floor(progress * end))
      if (progress < 1) window.requestAnimationFrame(step)
      else setCount(end)
    }
    window.requestAnimationFrame(step)
  }, [end, duration])
  return <>{count.toLocaleString()}</>
}

function AnimatedNumber({ value }: { value: string }) {
  const cleanValue = value.replace(/,/g, '')
  const numericValue = parseInt(cleanValue.replace(/[^0-9]/g, ''), 10)
  const suffix = cleanValue.replace(/[0-9]/g, '')
  const prefix = cleanValue.split(/[0-9]/)[0] || ''
  if (isNaN(numericValue)) return <>{value}</>
  return <>{prefix}<CountUp end={numericValue} />{suffix}</>
}

const countryCodes = [
  { code: '+20', flag: '🇪🇬' },
  { code: '+966', flag: '🇸🇦' },
  { code: '+971', flag: '🇦🇪' },
  { code: '+974', flag: '🇶🇦' },
  { code: '+965', flag: '🇰🇼' },
  { code: '+968', flag: '🇴🇲' },
  { code: '+973', flag: '🇧🇭' },
  { code: '+962', flag: '🇯🇴' },
  { code: '+961', flag: '🇱🇧' },
  { code: '+963', flag: '🇸🇾' },
  { code: '+964', flag: '🇮🇶' },
  { code: '+967', flag: '🇾🇪' },
  { code: '+970', flag: '🇵🇸' },
  { code: '+212', flag: '🇲🇦' },
  { code: '+213', flag: '🇩🇿' },
  { code: '+216', flag: '🇹🇳' },
  { code: '+218', flag: '🇱🇾' },
  { code: '+249', flag: '🇸🇩' },
  { code: '+1', flag: '🇺🇸' },
  { code: '+44', flag: '🇬🇧' },
  { code: '+49', flag: '🇩🇪' },
  { code: '+33', flag: '🇫🇷' },
  { code: '+39', flag: '🇮🇹' },
  { code: '+34', flag: '🇪🇸' },
  { code: '+7', flag: '🇷🇺' },
  { code: '+86', flag: '🇨🇳' },
  { code: '+91', flag: '🇮🇳' },
  { code: '+81', flag: '🇯🇵' },
  { code: '+90', flag: '🇹🇷' },
  { code: '+31', flag: '🇳🇱' },
  { code: '+32', flag: '🇧🇪' },
  { code: '+41', flag: '🇨🇭' },
  { code: '+46', flag: '🇸🇪' },
  { code: '+47', flag: '🇳🇴' },
  { code: '+45', flag: '🇩🇰' },
  { code: '+351', flag: '🇵🇹' },
  { code: '+30', flag: '🇬🇷' },
  { code: '+353', flag: '🇮🇪' },
  { code: '+358', flag: '🇫🇮' },
  { code: '+43', flag: '🇦🇹' },
  { code: '+61', flag: '🇦🇺' },
  { code: '+64', flag: '🇳🇿' },
  { code: '+55', flag: '🇧🇷' },
  { code: '+52', flag: '🇲🇽' },
  { code: '+27', flag: '🇿🇦' },
  { code: '+60', flag: '🇲🇾' },
  { code: '+65', flag: '🇸🇬' },
] as const

function App() {
  const [locale, setLocale] = useState<Locale>('ar')
  const [view, setView] = useState<'landing' | 'sell' | 'opportunities' | 'property-details'>('landing')
  const [activePropertyId, setActivePropertyId] = useState<string | null>(null)
  const [inquiryName, setInquiryName] = useState('')
  const [inquiryPhone, setInquiryPhone] = useState('')
  const [inquiryCountryCode, setInquiryCountryCode] = useState('+20')
  const [inquirySubmitted, setInquirySubmitted] = useState(false)
  const [step, setStep] = useState(1)
  const [isSubmitted, setIsSubmitted] = useState(false)
  const [showErrors, setShowErrors] = useState(false)
  const [formData, setFormData] = useState({
    developerName: '',
    projectName: '',
    totalPrice: '',
    amountPaid: '',
    currentPrice: '',
    zeroOverAck: false,
    remainingPrice: '',
    nextInstallment: '',
    frequency: 'quarterly',
    unitType: 'apartment',
    location: '',
    area: '',
    gardenArea: '',
    floor: '',
    bedrooms: '',
    bathrooms: '',
    finishingType: 'core_shell',
    deliveryStatus: 'ready',
    amenities: [] as string[],
    description: '',
    contractYear: '',
    nextInstallmentDate: '',
    maintenancePaid: false,
    maintenanceAmount: '',
    contractFile: null as File | null,
    receiptsFile: null as File | null,
    name: '',
    phone: '',
    email: '',
    ownerConfirm: false,
  })
  const [mousePos, setMousePos] = useState({ x: 0, y: 0 })
  const [isLoggedIn, setIsLoggedIn] = useState(() => localStorage.getItem('safqa_user_logged') === 'true')
  const [userProfile, setUserProfile] = useState(() => {
    try {
      const saved = localStorage.getItem('safqa_user_profile')
      return saved ? JSON.parse(saved) : null
    } catch {
      return null
    }
  })
  const [authMode, setAuthMode] = useState<'login' | 'register'>('login')
  const [authData, setAuthData] = useState({
    name: '',
    phone: '',
    email: '',
    password: '',
    confirmPassword: '',
  })
  const [authError, setAuthError] = useState('')
  const [authCountryCode, setAuthCountryCode] = useState('+20')
  const [userMenuOpen, setUserMenuOpen] = useState(false)
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)
  const userMenuRef = useRef<HTMLDivElement>(null)
  const [filterLocation, setFilterLocation] = useState('all')
  const [filterType, setFilterType] = useState('all')
  const [filterPrice, setFilterPrice] = useState('all')
  const [sortOrder, setSortOrder] = useState('default')

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (userMenuRef.current && !userMenuRef.current.contains(event.target as Node)) {
        setUserMenuOpen(false)
      }
    }
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  useEffect(() => {
    if (isLoggedIn && userProfile) {
      setFormData(prev => ({
        ...prev,
        name: prev.name || userProfile.name || '',
        phone: prev.phone || userProfile.phone || '',
        email: prev.email || userProfile.email || '',
      }))
    }
  }, [isLoggedIn, userProfile])
  const copy = safqaLandingCopy[locale]
  const isArabic = locale === 'ar'
  const arrowIcon = isArabic ? <ArrowLeft size={18} /> : <ArrowRight size={18} />

  useEffect(() => {
    const handleHash = () => {
      if (window.location.hash === '#/sell') {
        setView('sell')
        window.scrollTo(0, 0)
        setStep(1)
        setIsSubmitted(false)
        setShowErrors(false)
      } else if (window.location.hash === '#/opportunities') {
        setView('opportunities')
        window.scrollTo(0, 0)
      } else if (window.location.hash.startsWith('#/property/')) {
        const id = window.location.hash.replace('#/property/', '')
        setActivePropertyId(id)
        setView('property-details')
        window.scrollTo(0, 0)
      } else {
        setView('landing')
        const hash = window.location.hash
        if (hash && hash.startsWith('#') && !hash.startsWith('#/')) {
          const el = document.getElementById(hash.substring(1))
          if (el) {
            setTimeout(() => {
              el.scrollIntoView({ behavior: 'smooth' })
            }, 100)
          }
        }
      }
    }
    handleHash()
    window.addEventListener('hashchange', handleHash)
    return () => window.removeEventListener('hashchange', handleHash)
  }, [])

  const handleMouseMove = (e: React.MouseEvent) => {
    const rect = e.currentTarget.getBoundingClientRect()
    setMousePos({ x: e.clientX - rect.left, y: e.clientY - rect.top })
  }

  const renderHeroTitle = () => {
    if (locale === 'ar') return <><span className="highlight-underline">صفقة</span> للتنازل العقاري</>
    return <><span className="highlight-underline">Safqa</span> for Property Transfer</>
  }

  const handleInputChange = (field: string, value: any) => {
    setFormData(prev => ({ ...prev, [field]: value }))
  }

  const renderPropertyDetailsView = () => {
    const rawItems = copy.opportunities.items
    const property = rawItems.find(p => p.id === activePropertyId)
    
    if (!property) {
      return (
        <section className="catalog-page-section">
          <div className="section-frame">
            <div className="catalog-no-results">
              <h3 className="luxury-serif">{isArabic ? 'لم يتم العثور على الوحدة' : 'Property Not Found'}</h3>
              <a href="#/opportunities" onClick={(e) => { e.preventDefault(); window.location.hash = '#/opportunities'; setView('opportunities'); }} className="opp-card-cta-btn" style={{ maxWidth: '280px', margin: '20px auto 0' }}>
                {isArabic ? 'العودة للكتالوج' : 'Back to Catalog'}
              </a>
            </div>
          </div>
        </section>
      )
    }

    const priceVal = parseFloat(property.price.replace(/,/g, ''))
    const marketPriceVal = parseFloat(property.marketPrice.replace(/,/g, ''))
    
    // Savings calculation
    const savingsVal = marketPriceVal - priceVal
    const formattedSavings = isArabic 
      ? `+ ${savingsVal.toLocaleString('ar-EG')} ج.م` 
      : `+ ${savingsVal.toLocaleString('en-US')} EGP`

    // Commission 1.25%
    const commissionVal = Math.round(priceVal * 0.0125)
    const formattedCommission = isArabic
      ? `${commissionVal.toLocaleString('ar-EG')} ج.م`
      : `${commissionVal.toLocaleString('en-US')} EGP`

    // Total required now: Price + Commission
    const totalRequiredVal = priceVal + commissionVal
    const formattedTotalRequired = isArabic
      ? `${totalRequiredVal.toLocaleString('ar-EG')} ج.م`
      : `${totalRequiredVal.toLocaleString('en-US')} EGP`

    const handleFormSubmit = (e: React.FormEvent) => {
      e.preventDefault()
      if (!inquiryName || !inquiryPhone) return
      
      const text = isArabic
        ? `مرحباً صفقة، أنا مهتم بحجز الفرصة: "${property.title}" (كود: ${property.unitCode}) في ${property.location}.\nالاسم: ${inquiryName}\nالرقم: ${inquiryCountryCode}${inquiryPhone}`
        : `Hello Safqa, I am interested in reserving the opportunity: "${property.title}" (Code: ${property.unitCode}) in ${property.location}.\nName: ${inquiryName}\nPhone: ${inquiryCountryCode}${inquiryPhone}`

      setInquirySubmitted(true)
      setTimeout(() => {
        window.open(`https://wa.me/201018595959?text=${encodeURIComponent(text)}`, '_blank')
        setInquirySubmitted(false)
        setInquiryName('')
        setInquiryPhone('')
      }, 1000)
    }

    const copyUnitCode = () => {
      navigator.clipboard.writeText(property.unitCode)
      alert(isArabic ? 'تم نسخ كود الوحدة!' : 'Unit code copied!')
    }

    return (
      <section className="property-details-page">
        <div className="section-frame">
          
          <button 
            type="button" 
            className="property-back-btn"
            onClick={(e) => {
              e.preventDefault()
              window.location.hash = '#/opportunities'
              setView('opportunities')
              window.scrollTo(0, 0)
            }}
          >
            {isArabic ? <ArrowRight size={16} /> : <ArrowLeft size={16} />}
            <span>{isArabic ? 'رجوع للفرص' : 'Back to Opportunities'}</span>
          </button>

          <div className="property-header-row">
            <div className="header-info">
              <h1 className="luxury-serif">{property.project}</h1>
              <p className="header-subtitle">
                {property.developer} · {property.location} · {property.meta.split('/')[1]?.trim() || property.type}
              </p>
              <div className="header-meta-tags">
                <button type="button" onClick={copyUnitCode} className="copy-code-tag">
                  <span className="tnum" dir="ltr">{property.unitCode}</span>
                  <span className="copy-icon">⧉</span>
                </button>
              </div>
            </div>

            <div className="header-badges-row">
              <span className="badge-verified">{isArabic ? 'متحقق بالمستندات' : 'Verified Docs'}</span>
              <span className="badge-featured">⭐ {isArabic ? 'مميزة' : 'Featured'}</span>
            </div>
          </div>

          <div className="property-gallery-slider">
            {property.gallery.map((imgKey, idx) => (
              <div key={idx} className="gallery-slide-item">
                <img src={safqaAssets[imgKey]} alt={property.title} />
              </div>
            ))}
          </div>

          <div className="property-details-layout">
            
            {/* Left Column: Specs, Details, Amenities */}
            <div className="details-main-col">
              
              {/* Specs Grid */}
              <div className="specs-card-grid">
                <div className="spec-cell">
                  <span className="spec-cell-label">{isArabic ? 'النوع' : 'Type'}</span>
                  <strong className="spec-cell-val">{property.meta.split('/')[1]?.trim() || property.type}</strong>
                </div>
                <div className="spec-cell">
                  <span className="spec-cell-label">{isArabic ? 'المساحة' : 'Area'}</span>
                  <strong className="spec-cell-val">{property.meta.split('/')[0].trim()}</strong>
                </div>
                <div className="spec-cell">
                  <span className="spec-cell-label">{isArabic ? 'الدور' : 'Floor'}</span>
                  <strong className="spec-cell-val">{property.floor}</strong>
                </div>
                <div className="spec-cell">
                  <span className="spec-cell-label">{isArabic ? 'غرف' : 'Bedrooms'}</span>
                  <strong className="spec-cell-val">{property.bedrooms}</strong>
                </div>
                <div className="spec-cell">
                  <span className="spec-cell-label">{isArabic ? 'حمامات' : 'Bathrooms'}</span>
                  <strong className="spec-cell-val">{property.bathrooms}</strong>
                </div>
                <div className="spec-cell">
                  <span className="spec-cell-label">{isArabic ? 'التشطيب' : 'Finishing'}</span>
                  <strong className="spec-cell-val">{property.finishing || (isArabic ? 'كامل' : 'Finished')}</strong>
                </div>
                <div className="spec-cell">
                  <span className="spec-cell-label">{isArabic ? 'حالة الاستلام' : 'Delivery Status'}</span>
                  <strong className="spec-cell-val">{parseInt(property.deliveryYear) <= 2026 ? (isArabic ? 'جاهز' : 'Ready') : (isArabic ? 'تحت الإنشاء' : 'Under Construction')}</strong>
                </div>
                <div className="spec-cell">
                  <span className="spec-cell-label">{isArabic ? 'سنة التعاقد' : 'Contract Year'}</span>
                  <strong className="spec-cell-val">{property.contractYear}</strong>
                </div>
                <div className="spec-cell">
                  <span className="spec-cell-label">{isArabic ? 'سعر المتر بالتعاقد' : 'Contract Meter Price'}</span>
                  <strong className="spec-cell-val">{property.meterPrice} {isArabic ? 'ج.م' : 'EGP'}</strong>
                </div>
              </div>

              {/* Amenities & Description */}
              <div className="property-section-box">
                <div className="amenities-tags-wrapper">
                  {property.amenities.map((amenity, idx) => (
                    <span key={idx} className="amenity-tag-pill">✓ {amenity}</span>
                  ))}
                </div>
                <p className="property-description-para">{property.description}</p>
              </div>

            </div>

            {/* Right Column: Pricing & Lead Form */}
            <div className="details-side-col">
              
              {/* Cash Required Card */}
              <div className="premium-cash-card">
                <span className="cash-card-label">{isArabic ? 'المطلوب كاش دلوقتي' : 'Cash Required Now'}</span>
                <h2 className="cash-card-amount">{property.price} {isArabic ? 'ج.م' : 'EGP'}</h2>
                <p className="cash-card-note">
                  {isArabic 
                    ? 'ده نفس المبلغ اللي دفعه صاحب الوحدة — بدون أي أوفر' 
                    : 'This is the exact amount paid by the owner — no overprice'}
                </p>
                
                <div className="cash-savings-alert">
                  <span className="savings-title">
                    {isArabic ? 'مكسبك عن سعر السوق الحالي' : 'Your Profit Over Market Price'}
                  </span>
                  <strong className="savings-amount">{formattedSavings}</strong>
                  <p className="savings-market-ref">
                    {isArabic 
                      ? `سعر السوق اليوم: ${property.marketPrice} ج.م` 
                      : `Today's market price: ${property.marketPrice} EGP`}
                  </p>
                </div>
              </div>

              {/* Financial Breakdown Table */}
              <div className="financial-breakdown-card">
                <div className="breakdown-row">
                  <span className="row-label">{isArabic ? 'المتبقي للمطور (أقساط)' : 'Remaining to Developer'}</span>
                  <strong className="row-value">{property.remainingPrice} {isArabic ? 'ج.م' : 'EGP'}</strong>
                </div>
                <div className="breakdown-row">
                  <span className="row-label">{isArabic ? 'القسط' : 'Installment'}</span>
                  <strong className="row-value">{property.installment} {isArabic ? 'ج.م' : 'EGP'} · {property.frequency}</strong>
                </div>
                <div className="breakdown-row">
                  <span className="row-label">{isArabic ? 'الاستلام' : 'Delivery'}</span>
                  <strong className="row-value">{property.deliveryYear}</strong>
                </div>
                <div className="breakdown-row highlight-commission">
                  <div className="commission-label-group">
                    <span className="row-label">{isArabic ? 'عمولة صفقة على المشتري' : 'Safqa Buyer Commission (1.25%)'}</span>
                    <small className="commission-subtext">
                      {isArabic 
                        ? 'تستحق عند إتمام التنازل فقط — البايع لا يدفع عمولة.' 
                        : 'Due upon transfer completion only. Seller pays 0% commission.'}
                    </small>
                  </div>
                  <strong className="row-value">{formattedCommission}</strong>
                </div>
                <div className="breakdown-total-row">
                  <span className="total-label">{isArabic ? 'إجمالي المطلوب منك دلوقتي' : 'Total Required Now'}</span>
                  <strong className="total-value">{formattedTotalRequired}</strong>
                </div>
              </div>

              {/* Booking Lead Form */}
              <div className="booking-lead-form-card" id="booking-form-section">
                <h3>{isArabic ? 'عايز تلحق حجز الفرصة ديه؟' : 'Interested in this Opportunity?'}</h3>
                <p>
                  {isArabic 
                    ? 'سيب اسمك ورقم الواتساب، وفريقنا هيكلّمك يراجع معاك المطلوب كاش والأقساط — بنكلّم اللي جاهز يتحرّك على الوحدة دي.' 
                    : 'Leave your name and WhatsApp, our team will contact you to review cash and installment requirements.'}
                </p>
                
                {inquirySubmitted ? (
                  <div className="form-success-state">
                    <span className="success-icon">✓</span>
                    <h4>{isArabic ? 'تم إرسال طلبك بنجاح!' : 'Inquiry sent successfully!'}</h4>
                    <p>{isArabic ? 'جاري توجيهك إلى واتساب...' : 'Redirecting to WhatsApp...'}</p>
                  </div>
                ) : (
                  <form onSubmit={handleFormSubmit} className="booking-form-element">
                    <div className="form-input-group">
                      <label>{isArabic ? 'الاسم بالكامل' : 'Full Name'}</label>
                      <input 
                        type="text" 
                        required 
                        placeholder={isArabic ? 'اكتب اسمك هنا' : 'Your full name'} 
                        value={inquiryName} 
                        onChange={(e) => setInquiryName(e.target.value)} 
                      />
                    </div>
                    <div className="form-input-group">
                      <label>{isArabic ? 'رقم الواتساب' : 'WhatsApp Number'}</label>
                      <div className="phone-input-row" dir="ltr">
                        <select 
                          value={inquiryCountryCode} 
                          onChange={(e) => setInquiryCountryCode(e.target.value)}
                          className="country-code-select"
                        >
                          <option value="+20">🇪🇬 +20</option>
                          <option value="+966">🇸🇦 +966</option>
                          <option value="+971">🇦🇪 +971</option>
                          <option value="+965">🇰🇼 +965</option>
                          <option value="+974">🇶🇦 +974</option>
                        </select>
                        <input 
                          type="tel" 
                          required 
                          placeholder="1012345678" 
                          value={inquiryPhone} 
                          onChange={(e) => setInquiryPhone(e.target.value)} 
                          className="phone-number-field"
                        />
                      </div>
                    </div>
                    <button type="submit" className="booking-submit-btn">
                      {isArabic ? 'احجز الفرصة الآن' : 'Reserve Opportunity Now'}
                      {arrowIcon}
                    </button>
                  </form>
                )}
              </div>

            </div>

          </div>

          {/* Mobile Floating Sticky CTA */}
          <div className="mobile-sticky-action-bar">
            <div className="sticky-action-price">
              <span>{isArabic ? 'المطلوب كاش' : 'Cash Required'}</span>
              <strong>{property.price} {isArabic ? 'ج.م' : 'EGP'}</strong>
            </div>
            <button 
              type="button" 
              className="sticky-action-btn"
              onClick={() => {
                const el = document.getElementById('booking-form-section')
                if (el) el.scrollIntoView({ behavior: 'smooth' })
              }}
            >
              {isArabic ? 'احجز الآن' : 'Book Now'}
            </button>
          </div>

        </div>
      </section>
    )
  }

  const renderOpportunitiesCatalogView = () => {
    const rawItems = copy.opportunities.items

    let filtered = rawItems.filter(item => {
      if (filterLocation !== 'all' && item.location !== filterLocation) {
        return false
      }
      if (filterType !== 'all' && item.type !== filterType) {
        return false
      }
      const priceVal = parseFloat(item.price.replace(/,/g, ''))
      if (filterPrice === 'low' && priceVal >= 4000000) {
        return false
      }
      if (filterPrice === 'mid' && (priceVal < 4000000 || priceVal > 8000000)) {
        return false
      }
      if (filterPrice === 'high' && priceVal <= 8000000) {
        return false
      }
      return true
    })

    if (sortOrder === 'price-asc') {
      filtered.sort((a, b) => parseFloat(a.price.replace(/,/g, '')) - parseFloat(b.price.replace(/,/g, '')))
    } else if (sortOrder === 'price-desc') {
      filtered.sort((a, b) => parseFloat(b.price.replace(/,/g, '')) - parseFloat(a.price.replace(/,/g, '')))
    } else if (sortOrder === 'savings-desc') {
      filtered.sort((a, b) => {
        const savingsA = parseFloat(a.oldPrice.replace(/,/g, '')) - parseFloat(a.price.replace(/,/g, ''))
        const savingsB = parseFloat(b.oldPrice.replace(/,/g, '')) - parseFloat(b.price.replace(/,/g, ''))
        return savingsB - savingsA
      })
    }

    const locations = Array.from(new Set(rawItems.map(item => item.location)))
    const types = Array.from(new Set(rawItems.map(item => ({ val: item.type, label: item.meta.split('/').pop()?.trim() || item.type }))))
    const uniqueTypes = types.filter((t, index, self) => self.findIndex(s => s.val === t.val) === index)

    return (
      <section className="catalog-page-section">
        <div className="catalog-dashboard-header section-frame">
          <div className="catalog-header-content">
            <span className="eyebrow">{copy.opportunities.eyebrow}</span>
            <h1 className="luxury-serif">
              {isArabic ? 'كتالوج فرص التنازل العقاري' : 'Property Transfer Catalog'}
            </h1>
            <p className="catalog-dashboard-sub">
              {isArabic 
                ? 'تصفح وقارن بين الوحدات السكنية والساحلية المعروضة للتنازل مباشرة بسعر التعاقد وبدون أي أوفر'
                : 'Browse and compare residential and coastal units offered for transfer directly at contract price without overprice'}
            </p>
          </div>
        </div>

        <div className="catalog-filters-container section-frame">
          <div className="filter-row-dropdowns">
            
            <div className="dropdown-filter-item">
              <label className="filter-label">{isArabic ? 'المنطقة / الموقع' : 'Location'}</label>
              <CustomSelect 
                value={filterLocation}
                onChange={setFilterLocation}
                options={[
                  { value: 'all', label: isArabic ? 'كل المناطق' : 'All Regions' },
                  ...locations.map(loc => ({ value: loc, label: loc }))
                ]}
              />
            </div>

            <div className="dropdown-filter-item">
              <label className="filter-label">{isArabic ? 'نوع العقار' : 'Property Type'}</label>
              <CustomSelect 
                value={filterType}
                onChange={setFilterType}
                options={[
                  { value: 'all', label: isArabic ? 'كل الأنواع' : 'All Types' },
                  ...uniqueTypes.map(t => ({ value: t.val, label: t.label }))
                ]}
              />
            </div>

            <div className="dropdown-filter-item">
              <label className="filter-label">{isArabic ? 'نطاق السعر' : 'Price Range'}</label>
              <CustomSelect 
                value={filterPrice}
                onChange={setFilterPrice}
                options={[
                  { value: 'all', label: isArabic ? 'كل الأسعار' : 'All Prices' },
                  { value: 'low', label: isArabic ? 'أقل من 4 مليون ج.م' : 'Under 4M EGP' },
                  { value: 'mid', label: isArabic ? 'من 4 إلى 8 مليون ج.م' : '4M to 8M EGP' },
                  { value: 'high', label: isArabic ? 'أكثر من 8 مليون ج.م' : 'Above 8M EGP' }
                ]}
              />
            </div>

            <div className="dropdown-filter-item">
              <label className="filter-label">{isArabic ? 'ترتيب حسب' : 'Sort By'}</label>
              <CustomSelect 
                value={sortOrder}
                onChange={setSortOrder}
                options={[
                  { value: 'default', label: isArabic ? 'الافتراضي' : 'Default' },
                  { value: 'price-asc', label: isArabic ? 'السعر: من الأقل للأعلى' : 'Price: Low to High' },
                  { value: 'price-desc', label: isArabic ? 'السعر: من الأعلى للأقل' : 'Price: High to Low' },
                  { value: 'savings-desc', label: isArabic ? 'الأعلى توفيراً' : 'Highest Savings' }
                ]}
              />
            </div>

          </div>
        </div>

        <div className="catalog-results-grid section-frame">
          {filtered.length > 0 ? (
            <div className="opportunities-modern-grid">
              {filtered.map((item) => {
                const priceVal = parseFloat(item.price.replace(/,/g, ''))
                const oldPriceVal = parseFloat(item.oldPrice.replace(/,/g, ''))
                const savedVal = oldPriceVal - priceVal
                const formattedSaved = isArabic 
                  ? `وفر ${savedVal.toLocaleString('ar-EG')} ج.م` 
                  : `Save ${savedVal.toLocaleString('en-US')} EGP`

                return (
                  <div className="opp-card-modern" key={item.title}>
                    <div className="opp-card-img-wrapper">
                      <img 
                        src={safqaAssets[item.imageKey]} 
                        alt={item.title} 
                        className="opp-card-img"
                      />
                      <span className="opp-card-badge">{item.badge}</span>
                      <span className="opp-card-location">
                        <MapPin size={12} style={{ marginInlineEnd: '4px' }} />
                        {item.location}
                      </span>
                    </div>

                    <div className="opp-card-content">
                      <h3 className="opp-card-title luxury-serif">{item.title}</h3>
                      
                      <div className="opp-card-specs">
                        {item.meta.split('/').map((spec, sIdx) => (
                          <span className="opp-spec-badge" key={sIdx}>
                            {spec.trim()}
                          </span>
                        ))}
                      </div>

                      <div className="opp-card-pricing-box">
                        <div className="opp-pricing-item">
                          <span className="opp-price-label">{isArabic ? 'السعر القديم للمطور' : 'Developer Price'}</span>
                          <span className="opp-old-price">{item.oldPrice} {isArabic ? 'ج.م' : 'EGP'}</span>
                        </div>
                        <div className="opp-pricing-item">
                          <span className="opp-price-label highlight-gold">{isArabic ? 'سعر صفقة (بدون أوفر)' : 'Safqa Price'}</span>
                          <strong className="opp-new-price">{item.price} {isArabic ? 'ج.م' : 'EGP'}</strong>
                        </div>
                      </div>

                      <div className="opp-save-tag">
                        <span className="save-icon">💎</span>
                        <span>{formattedSaved}</span>
                      </div>

                      <a 
                        href={`#/property/${item.id}`}
                        className="opp-card-cta-btn"
                        onClick={(e) => {
                          e.preventDefault();
                          window.location.hash = `#/property/${item.id}`;
                          setActivePropertyId(item.id);
                          setView('property-details');
                          window.scrollTo(0, 0);
                        }}
                      >
                        {isArabic ? 'مشاهدة التفاصيل' : 'View Details'}
                        {arrowIcon}
                      </a>
                    </div>
                  </div>
                )
              })}
            </div>
          ) : (
            <div className="catalog-no-results">
              <div className="no-results-icon-box">🔍</div>
              <h3 className="luxury-serif">{isArabic ? 'لم نجد وحدات تطابق اختياراتك' : 'No properties match your filter'}</h3>
              <p>
                {isArabic 
                  ? 'ولكن لا تقلق، يمكنك إخبارنا بميزانيتك والمنطقة المفضلة، وسنقوم بالبحث عنها فوراً من عقود التنازل المعروضة لدينا.'
                  : 'Do not worry, tell us your budget and preferred location, and we will find matching units from our offline inventory.'}
              </p>
              <a 
                href={`https://wa.me/201018595959?text=${isArabic ? encodeURIComponent('أبحث عن وحدة تنازل بمواصفات خاصة') : encodeURIComponent('I am looking for a custom property transfer opportunity')}`}
                target="_blank"
                rel="noopener noreferrer"
                className="opp-card-cta-btn"
                style={{ maxWidth: '280px', margin: '20px auto 0' }}
              >
                {isArabic ? 'تواصل معنا على واتساب' : 'Contact Us on WhatsApp'}
                {arrowIcon}
              </a>
            </div>
          )}
        </div>
      </section>
    )
  }

  const renderSellView = () => {
    const sCopy = copy.sellersPage

    const getPhoneSpec = (countryCode: string) => {
      switch (countryCode) {
        case '+20':
          return {
            placeholder: isArabic ? 'مثال: 1012345678' : 'e.g. 1012345678',
            hint: isArabic ? 'رقم الهاتف المصري يتكون من 10 أرقام (بدون 0 في الأول)' : 'Egyptian number must be 10 digits (without leading 0)',
            validate: (val: string) => /^[1][0-9]{9}$/.test(val)
          }
        case '+966':
          return {
            placeholder: isArabic ? 'مثال: 512345678' : 'e.g. 512345678',
            hint: isArabic ? 'رقم الهاتف السعودي يتكون من 9 أرقام تبدأ بـ 5' : 'Saudi number must be 9 digits starting with 5',
            validate: (val: string) => /^[5][0-9]{8}$/.test(val)
          }
        case '+971':
          return {
            placeholder: isArabic ? 'مثال: 512345678' : 'e.g. 512345678',
            hint: isArabic ? 'رقم الهاتف الإماراتي يتكون من 9 أرقام تبدأ بـ 5' : 'UAE number must be 9 digits starting with 5',
            validate: (val: string) => /^[5][0-9]{8}$/.test(val)
          }
        case '+974':
        case '+965':
        case '+968':
        case '+973':
          return {
            placeholder: isArabic ? 'يتكون من 8 أرقام' : '8 digits number',
            hint: isArabic ? 'يجب أن يتكون رقم الهاتف من 8 أرقام' : 'Phone number must be 8 digits',
            validate: (val: string) => /^[0-9]{8}$/.test(val)
          }
        case '+1':
          return {
            placeholder: 'e.g. 2015550123',
            hint: isArabic ? 'يتكون من 10 أرقام' : 'Must be 10 digits',
            validate: (val: string) => /^[0-9]{10}$/.test(val)
          }
        case '+44':
          return {
            placeholder: 'e.g. 7123456789',
            hint: isArabic ? 'يتكون من 10 أرقام تبدأ بـ 7' : 'Must be 10 digits starting with 7',
            validate: (val: string) => /^[7][0-9]{9}$/.test(val)
          }
        default:
          return {
            placeholder: isArabic ? 'أدخل رقم الموبايل' : 'Enter mobile number',
            hint: isArabic ? 'يجب أن يتكون رقم الهاتف من 7 إلى 11 رقماً' : 'Phone number must be 7 to 11 digits',
            validate: (val: string) => /^[0-9]{7,11}$/.test(val)
          }
      }
    }

    const handleAuthSubmit = (e: React.FormEvent) => {
      e.preventDefault()
      setAuthError('')

      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

      if (authMode === 'register') {
        if (!authData.name || !authData.email || !authData.password || !authData.confirmPassword) {
          setAuthError(isArabic ? 'برجاء ملء جميع الحقول المطلوبة' : 'Please fill all required fields')
          return
        }
        if (!emailRegex.test(authData.email)) {
          setAuthError(isArabic ? 'صيغة البريد الإلكتروني غير صحيحة' : 'Invalid email format')
          return
        }
        if (authData.phone) {
          const phoneSpec = getPhoneSpec(authCountryCode)
          if (!phoneSpec.validate(authData.phone)) {
            setAuthError(phoneSpec.hint)
            return
          }
        }
        if (authData.password.length < 6) {
          setAuthError(isArabic ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' : 'Password must be at least 6 characters')
          return
        }
        if (authData.password !== authData.confirmPassword) {
          setAuthError(isArabic ? 'كلمات المرور غير متطابقة' : 'Passwords do not match')
          return
        }

        const users = JSON.parse(localStorage.getItem('safqa_users') || '[]')
        const exists = users.find((u: any) => u.email.toLowerCase() === authData.email.toLowerCase())
        if (exists) {
          setAuthError(isArabic ? 'هذا البريد الإلكتروني مسجل بالفعل' : 'This email is already registered')
          return
        }
        
        const fullPhone = authData.phone ? `${authCountryCode} ${authData.phone}` : ''
        const profile = { name: authData.name, phone: fullPhone, email: authData.email }
        localStorage.setItem('safqa_user_logged', 'true')
        localStorage.setItem('safqa_user_profile', JSON.stringify(profile))
        
        users.push({ ...profile, password: authData.password })
        localStorage.setItem('safqa_users', JSON.stringify(users))

        setUserProfile(profile)
        setIsLoggedIn(true)
      } else {
        if (!authData.email || !authData.password) {
          setAuthError(isArabic ? 'برجاء إدخال البريد الإلكتروني وكلمة المرور' : 'Please enter email and password')
          return
        }
        if (!emailRegex.test(authData.email)) {
          setAuthError(isArabic ? 'صيغة البريد الإلكتروني غير صحيحة' : 'Invalid email format')
          return
        }

        const users = JSON.parse(localStorage.getItem('safqa_users') || '[]')
        const found = users.find((u: any) => u.email.toLowerCase() === authData.email.toLowerCase() && u.password === authData.password)

        if (users.length > 0 && !found) {
          setAuthError(isArabic ? 'البريد الإلكتروني أو كلمة المرور غير صحيحة' : 'Incorrect email or password')
          return
        }

        const profile = found || { name: isArabic ? 'مستخدم تجريبي' : 'Demo User', phone: '', email: authData.email }
        localStorage.setItem('safqa_user_logged', 'true')
        localStorage.setItem('safqa_user_profile', JSON.stringify(profile))

        setUserProfile(profile)
        setIsLoggedIn(true)
      }
    }

    const renderAuthPortal = () => {
      const authCopy = copy.sellersPage.auth
      const phoneSpec = getPhoneSpec(authCountryCode)
      return (
        <section className="auth-portal-section section-frame">
          <div className="auth-portal-card">
            <div className="auth-portal-benefits">
              <h2 className="luxury-serif">{authCopy.benefitsTitle}</h2>
              <div className="auth-benefits-list">
                <div className="benefit-item">
                  <div className="benefit-icon-box">✓</div>
                  <p>{authCopy.benefit1}</p>
                </div>
                <div className="benefit-item">
                  <div className="benefit-icon-box">✓</div>
                  <p>{authCopy.benefit2}</p>
                </div>
                <div className="benefit-item">
                  <div className="benefit-icon-box">✓</div>
                  <p>{authCopy.benefit3}</p>
                </div>
              </div>
            </div>

            <div className="auth-portal-form-pane">
              <div className="auth-tabs">
                <button 
                  type="button" 
                  className={`auth-tab-btn ${authMode === 'login' ? 'active' : ''}`}
                  onClick={() => { setAuthMode('login'); setAuthError(''); }}
                >
                  {authCopy.loginTab}
                </button>
                <button 
                  type="button" 
                  className={`auth-tab-btn ${authMode === 'register' ? 'active' : ''}`}
                  onClick={() => { setAuthMode('register'); setAuthError(''); }}
                >
                  {authCopy.registerTab}
                </button>
              </div>

              <h3 className="auth-title">
                {authMode === 'login' ? authCopy.loginTitle : authCopy.registerTitle}
              </h3>

              {authError && <div className="auth-error-banner">{authError}</div>}

              <form onSubmit={handleAuthSubmit} className="auth-form-fields">
                {authMode === 'register' && (
                  <div className="form-canvas-group">
                    <label className="canvas-label">{copy.sellersPage.form.name} *</label>
                    <input 
                      type="text" 
                      required
                      placeholder={isArabic ? "اكتب اسمك الثلاثي" : "Your full name"}
                      value={authData.name} 
                      onChange={(e) => setAuthData(prev => ({ ...prev, name: e.target.value }))}
                      className="premium-canvas-input"
                    />
                  </div>
                )}

                <div className="form-canvas-group">
                  <label className="canvas-label">{isArabic ? 'البريد الإلكتروني *' : 'Email Address *'}</label>
                  <input 
                    type="email" 
                    required
                    placeholder="name@domain.com"
                    value={authData.email} 
                    onChange={(e) => setAuthData(prev => ({ ...prev, email: e.target.value }))}
                    className="premium-canvas-input"
                  />
                </div>

                {authMode === 'register' && (
                  <div className="form-canvas-group">
                    <label className="canvas-label">{copy.sellersPage.form.phone}</label>
                    <div className="phone-input-with-country">
                      <select 
                        value={authCountryCode} 
                        onChange={(e) => setAuthCountryCode(e.target.value)}
                        className="country-code-select"
                      >
                        {countryCodes.map((c) => (
                          <option key={c.code} value={c.code}>
                            {c.flag} {c.code}
                          </option>
                        ))}
                      </select>
                      <input 
                        type="tel" 
                        placeholder={phoneSpec.placeholder}
                        value={authData.phone} 
                        onChange={(e) => setAuthData(prev => ({ ...prev, phone: e.target.value }))}
                        className="premium-canvas-input"
                      />
                    </div>
                    <span className="field-hint" style={{ marginTop: '6px', display: 'block', fontSize: '0.82rem', color: 'var(--muted)' }}>
                      {phoneSpec.hint}
                    </span>
                  </div>
                )}

                <div className="form-canvas-group">
                  <label className="canvas-label">{authCopy.password} *</label>
                  <input 
                    type="password" 
                    required
                    placeholder="••••••••"
                    value={authData.password} 
                    onChange={(e) => setAuthData(prev => ({ ...prev, password: e.target.value }))}
                    className="premium-canvas-input"
                  />
                </div>

                {authMode === 'register' && (
                  <div className="form-canvas-group">
                    <label className="canvas-label">{authCopy.confirmPassword} *</label>
                    <input 
                      type="password" 
                      required
                      placeholder="••••••••"
                      value={authData.confirmPassword} 
                      onChange={(e) => setAuthData(prev => ({ ...prev, confirmPassword: e.target.value }))}
                      className="premium-canvas-input"
                    />
                  </div>
                )}

                <button type="submit" className="auth-submit-btn" style={{ marginTop: '16px' }}>
                  <span>{authMode === 'login' ? authCopy.loginBtn : authCopy.registerBtn}</span>
                </button>

                <p 
                  className="auth-switch-link"
                  onClick={() => {
                    setAuthMode(authMode === 'login' ? 'register' : 'login');
                    setAuthError('');
                  }}
                >
                  {authMode === 'login' ? authCopy.noAccount : authCopy.haveAccount}
                </p>
              </form>
            </div>
          </div>
        </section>
      )
    }

    if (!isLoggedIn) {
      return renderAuthPortal()
    }

    const formatNumberLive = (val: string) => {
      if (!val) return ''
      const num = parseFloat(val)
      if (isNaN(num)) return ''
      return num.toLocaleString(isArabic ? 'ar-EG' : 'en-US') + ' ' + (isArabic ? 'ج.م' : 'EGP')
    }

    const handleNext = () => {
      setStep(prev => prev + 1)
      setShowErrors(false)
    }

    const handleFormSubmit = (e: React.FormEvent) => {
      e.preventDefault()
      
      const hasMissingFields = 
        !formData.unitType ||
        !formData.location ||
        !formData.developerName ||
        !formData.projectName ||
        !formData.area ||
        !formData.bedrooms ||
        !formData.bathrooms ||
        !formData.floor ||
        !formData.totalPrice ||
        !formData.amountPaid ||
        !formData.remainingPrice ||
        !formData.nextInstallment ||
        !formData.contractYear ||
        !formData.nextInstallmentDate ||
        !formData.contractFile ||
        !formData.ownerConfirm;

      if (hasMissingFields) {
        setShowErrors(true)
        return
      }

      setIsSubmitted(true)
      setShowErrors(false)
    }
    
    if (isSubmitted) {
      return (
        <section className="sell-success-section section-frame">
          <div className="sell-success-card">
            <div className="success-icon-wrapper">
              <Check size={36} />
            </div>
            <h2 className="luxury-serif">{sCopy.form.successTitle}</h2>
            <p>{sCopy.form.successSubtitle}</p>
            <div className="success-actions">
              <a 
                href="https://wa.me/201018595959" 
                target="_blank" 
                rel="noopener noreferrer" 
                className="whatsapp-btn"
              >
                {sCopy.form.whatsappCta}
              </a>
              <button 
                type="button" 
                className="back-home-btn"
                onClick={() => { setView('landing'); window.location.hash = ''; }}
              >
                {sCopy.form.backHome}
              </button>
            </div>
          </div>
        </section>
      )
    }

    return (
      <section className="sell-page-section">
        {/* Top Header Section */}
        <div className="sell-dashboard-header section-frame">
          <div className="sell-header-content">
            <h1 className="luxury-serif">{sCopy.title}</h1>
            <p className="sell-dashboard-sub">{sCopy.subtitle}</p>
          </div>
        </div>

        {/* Cinematic Pipeline Nav Tracker */}
        <div className="sell-pipeline-tracker section-frame">
          <div className={`pipeline-step ${step >= 1 ? 'active' : ''} ${step === 1 ? 'current' : ''}`}>
            <span className="step-num">01</span>
            <span className="step-label">{isArabic ? 'مواصفات العقار' : 'Property Identity'}</span>
          </div>
          <div className="pipeline-connector-line"><div className="connector-fill" style={{ width: step === 2 ? '50%' : step === 3 ? '100%' : '0%' }} /></div>
          <div className={`pipeline-step ${step >= 2 ? 'active' : ''} ${step === 2 ? 'current' : ''}`}>
            <span className="step-num">02</span>
            <span className="step-label">{isArabic ? 'المعطيات المالية' : 'Financial Ledger'}</span>
          </div>
          <div className="pipeline-connector-line"><div className="connector-fill" style={{ width: step === 3 ? '100%' : '0%' }} /></div>
          <div className={`pipeline-step ${step >= 3 ? 'active' : ''} ${step === 3 ? 'current' : ''}`}>
            <span className="step-num">03</span>
            <span className="step-label">{isArabic ? 'توثيق المالك' : 'Owner Authentication'}</span>
          </div>
        </div>

        {/* Dashboard Shell Wrapper */}
        <div className="sell-spec-sheet section-frame">
          <div className="corner-mark top-left" aria-hidden="true">+</div>
          <div className="corner-mark top-right" aria-hidden="true">+</div>
          <div className="corner-mark bottom-left" aria-hidden="true">+</div>
          <div className="corner-mark bottom-right" aria-hidden="true">+</div>

          <div className="sell-dashboard-grid">
            {/* Left: Guide parameters catalog */}
            <div className="sell-guide-catalog">
              <div className="catalog-header">
                <h3>{isArabic ? 'تعليمات وضمانات الخروج العقاري' : 'Exit Parameter Guidelines'}</h3>
              </div>
              <div className="catalog-list">
                {sCopy.points.map((p, idx) => (
                  <div key={idx} className="catalog-item">
                    <span className="catalog-index">0{idx + 1}</span>
                    <p>{p}</p>
                  </div>
                ))}
              </div>
              <div className="catalog-footer-notice">
                <div className="warning-hdr">
                  <User size={18} className="warning-icon" />
                  <h4>{sCopy.ownersOnlyTitle}</h4>
                </div>
                <p>{sCopy.ownersOnlyDesc}</p>
              </div>
            </div>

            {/* Right: Immersive Interactive Canvas */}
            <div className="sell-form-canvas">
              <form onSubmit={handleFormSubmit}>
                {step === 1 && (
                  <div className="form-canvas-fields">
                    <div className="form-canvas-row">
                      <div className="form-canvas-group">
                        <label className="canvas-label">{isArabic ? 'نوع العقار الاستثماري *' : 'Investment Unit Type *'}</label>
                        <CustomSelect
                          required
                          options={[
                            { value: 'apartment', label: sCopy.form.typeApartment },
                            { value: 'duplex', label: sCopy.form.typeDuplex },
                            { value: 'penthouse', label: sCopy.form.typePenthouse },
                            { value: 'townhouse', label: sCopy.form.typeTownhouse },
                            { value: 'twinhouse', label: sCopy.form.typeTwinhouse },
                            { value: 'villa', label: sCopy.form.typeVilla },
                            { value: 'chalet', label: sCopy.form.typeChalet },
                            { value: 'land', label: sCopy.form.typeLand },
                            { value: 'retail', label: sCopy.form.typeRetail },
                            { value: 'clinic', label: sCopy.form.typeClinic },
                            { value: 'office', label: sCopy.form.typeOffice },
                          ]}
                          value={formData.unitType}
                          onChange={(val) => handleInputChange('unitType', val)}
                          placeholder={isArabic ? "اختر نوع العقار" : "Select Unit Type"}
                          hasError={showErrors && !formData.unitType}
                        />
                      </div>

                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.location} *</label>
                        <CustomSelect
                          required
                          options={[
                            { value: 'new_cairo', label: sCopy.form.locNewCairo },
                            { value: 'zayed', label: sCopy.form.locZayed },
                            { value: 'october', label: sCopy.form.locOctober },
                            { value: 'shorouk', label: sCopy.form.locShorouk },
                            { value: 'mostakbal', label: sCopy.form.locMostakbal },
                            { value: 'capital', label: sCopy.form.locCapital },
                            { value: 'north_coast', label: sCopy.form.locNorthCoast },
                            { value: 'sokhna', label: sCopy.form.locSokhna },
                            { value: 'other', label: sCopy.form.locOther },
                          ]}
                          value={formData.location}
                          onChange={(val) => handleInputChange('location', val)}
                          placeholder={isArabic ? "اختر المنطقة" : "Select Region"}
                          hasError={showErrors && !formData.location}
                        />
                      </div>
                    </div>

                    <div className="form-canvas-row">
                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.developerName} *</label>
                        <input 
                          type="text" 
                          required
                          placeholder={isArabic ? "مثال: إعمار، سوديك..." : "e.g. Emaar, SODIC..."}
                          value={formData.developerName} 
                          onChange={(e) => handleInputChange('developerName', e.target.value)} 
                          className={`premium-canvas-input ${showErrors && !formData.developerName ? 'canvas-input-error' : ''}`}
                        />
                      </div>

                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.projectName} *</label>
                        <input 
                          type="text" 
                          required
                          placeholder={isArabic ? "مثال: مراسي، فيليت..." : "e.g. Villette, Marassi..."}
                          value={formData.projectName} 
                          onChange={(e) => handleInputChange('projectName', e.target.value)} 
                          className={`premium-canvas-input ${showErrors && !formData.projectName ? 'canvas-input-error' : ''}`}
                        />
                      </div>
                    </div>

                    <div className="form-canvas-row">
                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.area} *</label>
                        <div className="input-currency-wrapper">
                          <input 
                            type="number" 
                            required
                            min="10"
                            placeholder={isArabic ? "مثال: 150" : "e.g. 150"}
                            value={formData.area} 
                            onChange={(e) => handleInputChange('area', e.target.value)} 
                            className={`premium-canvas-input ${showErrors && !formData.area ? 'canvas-input-error' : ''}`}
                          />
                          <span className="currency-tag">{isArabic ? 'م²' : 'sqm'}</span>
                        </div>
                      </div>

                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.gardenArea}</label>
                        <div className="input-currency-wrapper">
                          <input 
                            type="number" 
                            min="0"
                            placeholder={isArabic ? "مثال: 50 (سيبه فاضي لو مفيش)" : "e.g. 50 (leave empty if none)"}
                            value={formData.gardenArea} 
                            onChange={(e) => handleInputChange('gardenArea', e.target.value)} 
                            className="premium-canvas-input"
                          />
                          <span className="currency-tag">{isArabic ? 'م²' : 'sqm'}</span>
                        </div>
                      </div>
                    </div>

                    <div className="form-canvas-row">
                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.deliveryStatus} *</label>
                        <CustomSelect
                          options={[
                            { value: 'ready', label: sCopy.form.deliveryReady },
                            { value: 'under_construction', label: sCopy.form.deliveryUnderConst },
                          ]}
                          value={formData.deliveryStatus}
                          onChange={(val) => handleInputChange('deliveryStatus', val)}
                          hasError={showErrors && !formData.deliveryStatus}
                        />
                      </div>

                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.finishingType} *</label>
                        <CustomSelect
                          options={[
                            { value: 'core_shell', label: sCopy.form.finishingCoreShell },
                            { value: 'semi_finished', label: sCopy.form.finishingSemi },
                            { value: 'fully_finished', label: sCopy.form.finishingFully },
                            { value: 'furnished', label: sCopy.form.finishingFurnished },
                          ]}
                          value={formData.finishingType}
                          onChange={(val) => handleInputChange('finishingType', val)}
                          hasError={showErrors && !formData.finishingType}
                        />
                      </div>
                    </div>

                    <div className="form-canvas-row form-canvas-row--three">
                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.bedrooms} *</label>
                        <CustomSelect
                          required
                          options={[
                            { value: '1', label: '1' },
                            { value: '2', label: '2' },
                            { value: '3', label: '3' },
                            { value: '4', label: '4' },
                            { value: '5', label: '5' },
                            { value: '6+', label: '6+' },
                          ]}
                          value={formData.bedrooms}
                          onChange={(val) => handleInputChange('bedrooms', val)}
                          placeholder={isArabic ? "اختر عدد الغرف" : "Select bedrooms"}
                          hasError={showErrors && !formData.bedrooms}
                        />
                      </div>

                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.bathrooms} *</label>
                        <CustomSelect
                          required
                          options={[
                            { value: '1', label: '1' },
                            { value: '2', label: '2' },
                            { value: '3', label: '3' },
                            { value: '4', label: '4' },
                            { value: '5+', label: '5+' },
                          ]}
                          value={formData.bathrooms}
                          onChange={(val) => handleInputChange('bathrooms', val)}
                          placeholder={isArabic ? "اختر الحمامات" : "Select bathrooms"}
                          hasError={showErrors && !formData.bathrooms}
                        />
                      </div>

                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.floor} *</label>
                        <CustomSelect
                          options={[
                            { value: 'ground', label: isArabic ? "الأرضي" : "Ground" },
                            { value: '1', label: isArabic ? "الأول" : "1st Floor" },
                            { value: '2', label: isArabic ? "الثاني" : "2nd Floor" },
                            { value: '3', label: isArabic ? "الثالث" : "3rd Floor" },
                            { value: '4', label: isArabic ? "الرابع" : "4th Floor" },
                            { value: '5', label: isArabic ? "الخامس" : "5th Floor" },
                            { value: '6', label: isArabic ? "السادس" : "6th Floor" },
                            { value: '7', label: isArabic ? "السابع" : "7th Floor" },
                            { value: '8', label: isArabic ? "الثامن" : "8th Floor" },
                            { value: '9', label: isArabic ? "التاسع" : "9th Floor" },
                            { value: '10', label: isArabic ? "العاشر" : "10th Floor" },
                            { value: '10+', label: isArabic ? "العاشر فأعلى" : "10th+ Floor" },
                            { value: 'duplex', label: isArabic ? "دوبلكس" : "Duplex" },
                            { value: 'penthouse', label: isArabic ? "بنتهاوس" : "Penthouse" },
                            { value: 'n_a', label: isArabic ? "فيلا مستقلة / لا ينطبق" : "Standalone / N/A" },
                          ]}
                          value={formData.floor}
                          onChange={(val) => handleInputChange('floor', val)}
                          placeholder={isArabic ? "اختر الطابق" : "Select Floor"}
                          hasError={showErrors && !formData.floor}
                        />
                      </div>
                    </div>

                    <div className="form-canvas-group">
                      <label className="canvas-label">{sCopy.form.amenitiesLabel}</label>
                      <div className="amenities-badge-grid">
                        {[
                          { key: 'pool', label: sCopy.form.amenityPool },
                          { key: 'garden', label: sCopy.form.amenityGarden },
                          { key: 'roof', label: sCopy.form.amenityRoof },
                          { key: 'security', label: sCopy.form.amenitySecurity },
                          { key: 'club', label: sCopy.form.amenityClub },
                          { key: 'garage', label: sCopy.form.amenityGarage },
                          { key: 'elevator', label: sCopy.form.amenityElevator },
                          { key: 'services', label: sCopy.form.amenityServices },
                        ].map((item) => {
                          const isActive = formData.amenities.includes(item.key)
                          return (
                            <button
                              key={item.key}
                              type="button"
                              className={`amenity-badge ${isActive ? 'active' : ''}`}
                              onClick={() => {
                                const next = isActive
                                  ? formData.amenities.filter(k => k !== item.key)
                                  : [...formData.amenities, item.key]
                                handleInputChange('amenities', next)
                              }}
                            >
                              {item.label}
                            </button>
                          )
                        })}
                      </div>
                    </div>

                    <div className="form-canvas-group">
                      <label className="canvas-label">{sCopy.form.description} *</label>
                      <textarea
                        required
                        placeholder={isArabic ? "مثال: شقة للبيع في كمبوند مميز بفيو على بحيرة ونظام دفع ميسر..." : "e.g. Apartment for sale in premium compound with lake view..."}
                        value={formData.description}
                        onChange={(e) => handleInputChange('description', e.target.value)}
                        className={`premium-canvas-textarea ${showErrors && !formData.description ? 'canvas-input-error' : ''}`}
                        rows={3}
                      />
                    </div>

                    <div className="form-canvas-group">
                      <div 
                        className={`interactive-seal-checkbox ${formData.zeroOverAck ? 'active' : ''} ${showErrors && !formData.zeroOverAck ? 'seal-error' : ''}`}
                        onClick={() => handleInputChange('zeroOverAck', !formData.zeroOverAck)}
                      >
                        <div className="seal-box">
                          {formData.zeroOverAck && <Check size={14} />}
                        </div>
                        <div className="seal-text-content">
                          <strong>{isArabic ? 'تعهد سعر التنازل (0% أوفر)' : 'Zero-Overprice Guarantee'}</strong>
                          <p>{sCopy.form.zeroOverAck}</p>
                        </div>
                      </div>
                    </div>
                  </div>
                )}

                {step === 2 && (
                  <div className="form-canvas-fields">
                    <div className="form-canvas-row">
                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.totalPrice} *</label>
                        <div className="input-currency-wrapper">
                          <input 
                            type="number" 
                            required
                            value={formData.totalPrice} 
                            onChange={(e) => handleInputChange('totalPrice', e.target.value)} 
                            className={`premium-canvas-input ${showErrors && !formData.totalPrice ? 'canvas-input-error' : ''}`}
                          />
                          <span className="currency-tag">{isArabic ? 'ج.م' : 'EGP'}</span>
                        </div>
                        {formData.totalPrice && <span className="number-live-helper">{formatNumberLive(formData.totalPrice)}</span>}
                      </div>

                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.amountPaid} *</label>
                        <div className="input-currency-wrapper">
                          <input 
                            type="number" 
                            required
                            value={formData.amountPaid} 
                            onChange={(e) => handleInputChange('amountPaid', e.target.value)} 
                            className={`premium-canvas-input ${showErrors && !formData.amountPaid ? 'canvas-input-error' : ''}`}
                          />
                          <span className="currency-tag">{isArabic ? 'ج.م' : 'EGP'}</span>
                        </div>
                        {formData.amountPaid && <span className="number-live-helper">{formatNumberLive(formData.amountPaid)}</span>}
                      </div>
                    </div>

                    <div className="form-canvas-row">
                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.remainingPrice} *</label>
                        <div className="input-currency-wrapper">
                          <input 
                            type="number" 
                            required
                            value={formData.remainingPrice} 
                            onChange={(e) => handleInputChange('remainingPrice', e.target.value)} 
                            className={`premium-canvas-input ${showErrors && !formData.remainingPrice ? 'canvas-input-error' : ''}`}
                          />
                          <span className="currency-tag">{isArabic ? 'ج.م' : 'EGP'}</span>
                        </div>
                        {formData.remainingPrice && <span className="number-live-helper">{formatNumberLive(formData.remainingPrice)}</span>}
                      </div>

                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.nextInstallment} *</label>
                        <div className="input-currency-wrapper">
                          <input 
                            type="number" 
                            required
                            value={formData.nextInstallment} 
                            onChange={(e) => handleInputChange('nextInstallment', e.target.value)} 
                            className={`premium-canvas-input ${showErrors && !formData.nextInstallment ? 'canvas-input-error' : ''}`}
                          />
                          <span className="currency-tag">{isArabic ? 'ج.م' : 'EGP'}</span>
                        </div>
                        {formData.nextInstallment && <span className="number-live-helper">{formatNumberLive(formData.nextInstallment)}</span>}
                      </div>
                    </div>

                    <div className="form-canvas-row">
                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.contractYear} *</label>
                        <CustomSelect
                          required
                          options={[
                            { value: '2015', label: '2015' },
                            { value: '2016', label: '2016' },
                            { value: '2017', label: '2017' },
                            { value: '2018', label: '2018' },
                            { value: '2019', label: '2019' },
                            { value: '2020', label: '2020' },
                            { value: '2021', label: '2021' },
                            { value: '2022', label: '2022' },
                            { value: '2023', label: '2023' },
                            { value: '2024', label: '2024' },
                            { value: '2025', label: '2025' },
                            { value: '2026', label: '2026' },
                          ]}
                          value={formData.contractYear}
                          onChange={(val) => handleInputChange('contractYear', val)}
                          placeholder={isArabic ? "اختر سنة التعاقد" : "Select Contract Year"}
                          hasError={showErrors && !formData.contractYear}
                        />
                      </div>

                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.nextInstallmentDate} *</label>
                        <input
                          type="date"
                          required
                          value={formData.nextInstallmentDate}
                          onChange={(e) => handleInputChange('nextInstallmentDate', e.target.value)}
                          className={`premium-canvas-input ${showErrors && !formData.nextInstallmentDate ? 'canvas-input-error' : ''}`}
                        />
                      </div>
                    </div>

                    <div className="form-canvas-row">
                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.currentPrice}</label>
                        <div className="input-currency-wrapper">
                          <input 
                            type="number" 
                            value={formData.currentPrice} 
                            onChange={(e) => handleInputChange('currentPrice', e.target.value)} 
                            className="premium-canvas-input"
                          />
                          <span className="currency-tag">{isArabic ? 'ج.م' : 'EGP'}</span>
                        </div>
                        {formData.currentPrice && <span className="number-live-helper">{formatNumberLive(formData.currentPrice)}</span>}
                        <span className="field-hint">{sCopy.form.currentPriceHint}</span>
                      </div>

                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.frequency} *</label>
                        <CustomSelect
                          required
                          options={[
                            { value: 'monthly', label: sCopy.form.freqMonthly },
                            { value: 'quarterly', label: sCopy.form.freqQuarterly },
                            { value: 'semiannual', label: sCopy.form.freqSemiannual },
                            { value: 'annual', label: sCopy.form.freqAnnual },
                          ]}
                          value={formData.frequency}
                          onChange={(val) => handleInputChange('frequency', val)}
                          placeholder={isArabic ? "اختر نظام القسط" : "Select Installment System"}
                          hasError={showErrors && !formData.frequency}
                        />
                      </div>
                    </div>

                    <div className="maintenance-box-container">
                      <div 
                        className={`interactive-seal-checkbox ${formData.maintenancePaid ? 'active' : ''}`}
                        onClick={() => {
                          const nextVal = !formData.maintenancePaid
                          handleInputChange('maintenancePaid', nextVal)
                          if (!nextVal) handleInputChange('maintenanceAmount', '')
                        }}
                      >
                        <div className="seal-box">
                          {formData.maintenancePaid && <Check size={14} />}
                        </div>
                        <div className="seal-text-content">
                          <strong>{sCopy.form.maintenancePaid}</strong>
                        </div>
                      </div>

                      {formData.maintenancePaid && (
                        <div className="maintenance-amount-field" style={{ marginTop: '14px', animation: 'selectMenuFade 200ms ease' }}>
                          <label className="canvas-label">{sCopy.form.maintenanceAmount} *</label>
                          <div className="input-currency-wrapper">
                            <input 
                              type="number" 
                              required
                              value={formData.maintenanceAmount} 
                              onChange={(e) => handleInputChange('maintenanceAmount', e.target.value)} 
                              className={`premium-canvas-input ${showErrors && !formData.maintenanceAmount ? 'canvas-input-error' : ''}`}
                            />
                            <span className="currency-tag">{isArabic ? 'ج.م' : 'EGP'}</span>
                          </div>
                          {formData.maintenanceAmount && <span className="number-live-helper">{formatNumberLive(formData.maintenanceAmount)}</span>}
                        </div>
                      )}
                    </div>
                  </div>
                )}

                {step === 3 && (
                  <div className="form-canvas-fields">
                    <div className="form-canvas-group">
                      <label className="canvas-label">{sCopy.form.name} *</label>
                      <input 
                        type="text" 
                        required
                        placeholder={isArabic ? "اكتب اسمك الثلاثي" : "Your full name"}
                        value={formData.name} 
                        onChange={(e) => handleInputChange('name', e.target.value)} 
                        className={`premium-canvas-input ${showErrors && !formData.name ? 'canvas-input-error' : ''}`}
                      />
                    </div>

                    <div className="form-canvas-row">
                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.phone} *</label>
                        <input 
                          type="tel" 
                          required
                          placeholder={isArabic ? "مثال: 010xxxxxxxx" : "e.g. +2010xxxxxxxx"}
                          value={formData.phone} 
                          onChange={(e) => handleInputChange('phone', e.target.value)} 
                          className={`premium-canvas-input ${showErrors && !formData.phone ? 'canvas-input-error' : ''}`}
                        />
                      </div>

                      <div className="form-canvas-group">
                        <label className="canvas-label">{sCopy.form.email}</label>
                        <input 
                          type="email" 
                          placeholder="name@domain.com"
                          value={formData.email} 
                          onChange={(e) => handleInputChange('email', e.target.value)} 
                          className="premium-canvas-input"
                        />
                      </div>
                    </div>

                    <div className="form-canvas-group">
                      <label className="canvas-label">{isArabic ? 'توثيق مستندات الوحدة' : 'Verification Documents'}</label>
                      <span className="field-hint" style={{ marginBottom: '12px', display: 'block' }}>{sCopy.form.uploadHint}</span>
                      
                      <div className="upload-grid-container">
                        {/* Contract Upload */}
                        <div className={`upload-card-box ${formData.contractFile ? 'has-file' : ''} ${showErrors && !formData.contractFile ? 'upload-error' : ''}`}>
                          <input 
                            type="file" 
                            id="contract-file" 
                            accept=".pdf,image/*"
                            style={{ display: 'none' }}
                            onChange={(e) => {
                              const file = e.target.files?.[0] || null
                              handleInputChange('contractFile', file)
                            }}
                          />
                          <label htmlFor="contract-file" className="upload-card-label">
                            <FileUp className="upload-icon" size={20} />
                            <strong>{sCopy.form.uploadContract} *</strong>
                            <p className="file-name-indicator">
                              {formData.contractFile ? formData.contractFile.name : (isArabic ? 'اضغط لرفع الملف (PDF أو صورة)' : 'Click to upload (PDF/Image)')}
                            </p>
                          </label>
                        </div>

                        {/* Receipts Upload */}
                        <div className={`upload-card-box ${formData.receiptsFile ? 'has-file' : ''}`}>
                          <input 
                            type="file" 
                            id="receipts-file" 
                            accept=".pdf,image/*"
                            style={{ display: 'none' }}
                            onChange={(e) => {
                              const file = e.target.files?.[0] || null
                              handleInputChange('receiptsFile', file)
                            }}
                          />
                          <label htmlFor="receipts-file" className="upload-card-label">
                            <FileUp className="upload-icon" size={20} />
                            <strong>{sCopy.form.uploadReceipts}</strong>
                            <p className="file-name-indicator">
                              {formData.receiptsFile ? formData.receiptsFile.name : (isArabic ? 'اضغط لرفع الملف (PDF أو صورة)' : 'Click to upload (PDF/Image)')}
                            </p>
                          </label>
                        </div>
                      </div>
                    </div>

                    <div className="form-canvas-group">
                      <div 
                        className={`interactive-seal-checkbox ${formData.ownerConfirm ? 'active' : ''} ${showErrors && !formData.ownerConfirm ? 'seal-error' : ''}`}
                        onClick={() => handleInputChange('ownerConfirm', !formData.ownerConfirm)}
                      >
                        <div className="seal-box">
                          {formData.ownerConfirm && <Check size={14} />}
                        </div>
                        <div className="seal-text-content">
                          <strong>{isArabic ? 'إقرار ملكية الوحدة' : 'Ownership Guarantee Seal'}</strong>
                          <p>{sCopy.form.ownerConfirm}</p>
                        </div>
                      </div>
                    </div>
                  </div>
                )}

                <div className="form-actions-buttons">
                  {step > 1 && (
                    <button 
                      type="button" 
                      className="sell-form-btn sell-form-btn--back"
                      onClick={() => setStep(prev => prev - 1)}
                    >
                      {sCopy.form.backBtn}
                    </button>
                  )}
                  
                  {step < 3 ? (
                    <button 
                      type="button" 
                      className="sell-form-btn sell-form-btn--next"
                      onClick={handleNext}
                    >
                      {sCopy.form.nextBtn}
                    </button>
                  ) : (
                    <button 
                      type="submit" 
                      className="sell-form-btn sell-form-btn--submit"
                    >
                      {sCopy.form.submitBtn}
                    </button>
                  )}
                </div>
              </form>
            </div>
          </div>
        </div>
      </section>
    )
  }

  return (
    <div
      className="site"
      dir={isArabic ? 'rtl' : 'ltr'}
      lang={locale}
      onMouseMove={handleMouseMove}
      style={{ '--mouse-x': `${mousePos.x}px`, '--mouse-y': `${mousePos.y}px` } as React.CSSProperties}
    >
      {/* Architectural gridlines */}
      <div className="site-gridlines" aria-hidden="true">
        <span className="gridline" /><span className="gridline" /><span className="gridline" />
      </div>

      <header className="site-nav">
        <a className="brand-lockup" href="#home" onClick={() => { setView('landing'); window.location.hash = ''; }} aria-label="SAFQA">
          <span className="brand-logo-text">
            SAFQA
            <span className="brand-logo-dot">.</span>
          </span>
        </a>
        <nav className="nav-links" aria-label="Primary">
          <a href="#home">{copy.nav.home}</a>
          <a href="#decision">{copy.nav.decision}</a>
          <a href="#paths">{copy.nav.paths}</a>
          <a href="#opportunities">{copy.nav.opportunities}</a>
          <a href="#how-it-works">{copy.nav.howItWorks}</a>
          <a href="#process">{copy.nav.process}</a>
          <a href="#brokers">{copy.nav.brokers}</a>
        </nav>
        <div className="nav-actions">
          {isLoggedIn && userProfile && (
            <div className="nav-user-menu-container" ref={userMenuRef}>
              <button 
                type="button" 
                className="nav-avatar-btn" 
                onClick={() => setUserMenuOpen(!userMenuOpen)}
                aria-label="User Menu"
              >
                <User size={16} />
              </button>
              {userMenuOpen && (
                <div className="nav-user-dropdown">
                  <div className="dropdown-user-info">
                    <span className="dropdown-username">{userProfile.name}</span>
                    <span className="dropdown-email">{userProfile.email || (isArabic ? 'حساب موثق' : 'Verified Account')}</span>
                  </div>
                  <div className="dropdown-divider" />
                  <button 
                    type="button" 
                    className="dropdown-logout-btn" 
                    onClick={() => {
                      localStorage.removeItem('safqa_user_logged')
                      localStorage.removeItem('safqa_user_profile')
                      setIsLoggedIn(false)
                      setUserProfile(null)
                      setUserMenuOpen(false)
                    }}
                  >
                    <LogOut size={14} />
                    <span>{isArabic ? 'تسجيل الخروج' : 'Logout'}</span>
                  </button>
                </div>
              )}
            </div>
          )}
          <button className="language-button" type="button" onClick={() => setLocale(isArabic ? 'en' : 'ar')}>
            <Globe2 size={16} /><span>{copy.switchLanguage}</span>
          </button>
          <button 
            className="mobile-menu-toggle" 
            type="button" 
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            aria-label="Toggle mobile menu"
          >
            {mobileMenuOpen ? <X size={20} /> : <Menu size={20} />}
          </button>
        </div>
      </header>

      {mobileMenuOpen && (
        <div className="mobile-menu-overlay">
          <nav className="mobile-nav-links">
            <a href="#home" onClick={() => setMobileMenuOpen(false)}>{copy.nav.home}</a>
            <a href="#decision" onClick={() => setMobileMenuOpen(false)}>{copy.nav.decision}</a>
            <a href="#paths" onClick={() => setMobileMenuOpen(false)}>{copy.nav.paths}</a>
            <a href="#opportunities" onClick={() => setMobileMenuOpen(false)}>{copy.nav.opportunities}</a>
            <a href="#how-it-works" onClick={() => setMobileMenuOpen(false)}>{copy.nav.howItWorks}</a>
            <a href="#process" onClick={() => setMobileMenuOpen(false)}>{copy.nav.process}</a>
            <a href="#brokers" onClick={() => setMobileMenuOpen(false)}>{copy.nav.brokers}</a>
            
            {isLoggedIn && userProfile ? (
              <div className="mobile-menu-user-section">
                <div className="dropdown-user-info" style={{ padding: '0 12px 12px' }}>
                  <span className="dropdown-username" style={{ display: 'block', fontWeight: 'bold' }}>{userProfile.name}</span>
                  <span className="dropdown-email" style={{ display: 'block', fontSize: '0.8rem', color: 'var(--muted)' }}>
                    {userProfile.email || (isArabic ? 'حساب موثق' : 'Verified Account')}
                  </span>
                </div>
                <button 
                  type="button" 
                  className="dropdown-logout-btn" 
                  style={{ width: '100%', display: 'flex', alignItems: 'center', gap: '8px', padding: '10px 12px' }}
                  onClick={() => {
                    localStorage.removeItem('safqa_user_logged')
                    localStorage.removeItem('safqa_user_profile')
                    setIsLoggedIn(false)
                    setUserProfile(null)
                    setMobileMenuOpen(false)
                  }}
                >
                  <LogOut size={14} />
                  <span>{isArabic ? 'تسجيل الخروج' : 'Logout'}</span>
                </button>
              </div>
            ) : null}
          </nav>
        </div>
      )}

      <main>
        {view === 'landing' ? (
          <>
            {/* ─── HERO ─── */}
        <section className="hero-section" id="home">
          <div className="hero-overlay" />
          <div className="hero-sheen" aria-hidden="true" />

          <div className="hero-stage hero-stage--single">
            <div className="hero-content hero-content--centered">
              <span className="eyebrow">{copy.hero.eyebrow}</span>
              <h1 className="luxury-serif">{renderHeroTitle()}</h1>
              <p>{copy.hero.body}</p>
              <div className="hero-actions">
                <a className="primary-action" href="#/sell" onClick={() => { setStep(1); setIsSubmitted(false); }}>{copy.hero.primaryCta}{arrowIcon}</a>
                <a className="ghost-action" href="#opportunities">{copy.hero.secondaryCta}</a>
              </div>
            </div>
          </div>

          {/* Full-width blueprint backdrop */}
          <div className="hero-blueprint-masterplan" aria-hidden="true">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1920 600" fill="none" preserveAspectRatio="xMidYMid slice">
              <line x1="0" y1="150" x2="1920" y2="150" stroke="var(--primary)" strokeWidth="0.8" opacity="0.08" />
              <line x1="0" y1="350" x2="1920" y2="350" stroke="var(--primary)" strokeWidth="0.8" opacity="0.08" />
              <line x1="350" y1="0" x2="350" y2="600" stroke="var(--primary)" strokeWidth="0.8" opacity="0.08" />
              <line x1="960" y1="0" x2="960" y2="600" stroke="var(--primary)" strokeWidth="0.8" opacity="0.08" />
              <line x1="1550" y1="0" x2="1550" y2="600" stroke="var(--primary)" strokeWidth="0.8" opacity="0.08" />
              <line x1="0" y1="250" x2="1920" y2="250" stroke="var(--primary)" strokeWidth="0.5" strokeDasharray="10 10" opacity="0.05" />
              <line x1="650" y1="0" x2="650" y2="600" stroke="var(--primary)" strokeWidth="0.5" strokeDasharray="10 10" opacity="0.05" />
              <line x1="1250" y1="0" x2="1250" y2="600" stroke="var(--primary)" strokeWidth="0.5" strokeDasharray="10 10" opacity="0.05" />
              <g opacity="0.12">
                <rect x="100" y="80" width="200" height="150" stroke="var(--primary)" strokeWidth="1.5" />
                <line x1="200" y1="80" x2="200" y2="230" stroke="var(--primary)" strokeWidth="1.2" />
                <line x1="100" y1="170" x2="300" y2="170" stroke="var(--primary)" strokeWidth="1.2" />
                <path d="M 200,120 A 30,30 0 0,1 230,150" stroke="var(--primary)" strokeWidth="1" />
                <text x="215" y="110" fill="var(--primary)" fontSize="8" fontFamily="monospace">LOBBY</text>
                <text x="120" y="210" fill="var(--primary)" fontSize="8" fontFamily="monospace">SUITE</text>
              </g>
              <g opacity="0.1">
                <line x1="1600" y1="100" x2="1850" y2="100" stroke="var(--primary)" strokeWidth="1" strokeDasharray="8 4" />
                <line x1="1600" y1="180" x2="1850" y2="180" stroke="var(--primary)" strokeWidth="1" strokeDasharray="8 4" />
                <line x1="1600" y1="260" x2="1850" y2="260" stroke="var(--primary)" strokeWidth="1" strokeDasharray="8 4" />
                <line x1="1620" y1="80" x2="1620" y2="280" stroke="var(--primary)" strokeWidth="1" strokeDasharray="8 4" />
                <line x1="1720" y1="80" x2="1720" y2="280" stroke="var(--primary)" strokeWidth="1" strokeDasharray="8 4" />
                <line x1="1820" y1="80" x2="1820" y2="280" stroke="var(--primary)" strokeWidth="1" strokeDasharray="8 4" />
                <rect x="1615" y="95" width="10" height="10" fill="var(--primary)" />
                <rect x="1715" y="95" width="10" height="10" fill="var(--primary)" />
                <rect x="1815" y="95" width="10" height="10" fill="var(--primary)" />
                <rect x="1615" y="175" width="10" height="10" fill="var(--primary)" />
                <rect x="1715" y="175" width="10" height="10" fill="var(--primary)" />
                <rect x="1815" y="175" width="10" height="10" fill="var(--primary)" />
              </g>
              <g opacity="0.18">
                <text x="50" y="30" fill="var(--primary)" fontSize="8" fontFamily="monospace">LAT: 30° 02' 40" N</text>
                <text x="350" y="30" fill="var(--primary)" fontSize="8" fontFamily="monospace">CAIRO EAST REGION MAP / REGISTRY DEPT</text>
                <text x="1700" y="30" fill="var(--primary)" fontSize="8" fontFamily="monospace">LNG: 31° 14' 09" E</text>
                <text x="50" y="580" fill="var(--primary)" fontSize="8" fontFamily="monospace">SAFQA CONTRACT ESCROW REGISTRY</text>
                <text x="960" y="580" fill="var(--primary)" fontSize="8" fontFamily="monospace" textAnchor="middle">VERIFIED ASSETS LAYER 2</text>
                <circle cx="960" cy="50" r="15" stroke="var(--primary)" strokeWidth="1" fill="none" />
                <line x1="960" y1="30" x2="960" y2="70" stroke="var(--primary)" strokeWidth="1" />
                <line x1="945" y1="50" x2="975" y2="50" stroke="var(--primary)" strokeWidth="1" />
                <text x="960" y="25" fill="var(--primary)" fontSize="8" fontFamily="monospace" textAnchor="middle" fontWeight="700">N</text>
              </g>
              <circle cx="0" cy="350" r="3" fill="var(--primary)" opacity="0.8">
                <animate attributeName="cx" from="0" to="1920" dur="18s" repeatCount="indefinite" />
              </circle>
              <circle cx="1920" cy="150" r="3.5" fill="var(--accent)" opacity="0.7">
                <animate attributeName="cx" from="1920" to="0" dur="22s" repeatCount="indefinite" />
              </circle>
              <circle cx="350" cy="0" r="3" fill="var(--primary)" opacity="0.6">
                <animate attributeName="cy" from="0" to="600" dur="12s" repeatCount="indefinite" />
              </circle>
              <circle cx="960" cy="600" r="3.5" fill="var(--primary)" opacity="0.8">
                <animate attributeName="cy" from="600" to="0" dur="15s" repeatCount="indefinite" />
              </circle>
            </svg>
          </div>
        </section>

        {/* ─── SEARCH ─── */}
        <section className="search-band" id="search">
          <div className="search-panel">
            <strong>{copy.search.title}</strong>
            <label><MapPin size={17} /><span>{copy.search.location}</span></label>
            <label><Building2 size={17} /><span>{copy.search.type}</span></label>
            <label><ShieldCheck size={17} /><span>{copy.search.status}</span></label>
            <button type="button"><Search size={17} /><span>{copy.search.submit}</span></button>
          </div>
        </section>

        {/* ─── STATS STRIP ─── */}
        <section className="stats-strip section-frame">
          {copy.stats.map((stat) => (
            <div className="stat-strip-item" key={stat.label}>
              <div className="stat-val luxury-serif"><AnimatedNumber value={stat.value} /></div>
              <div className="stat-lbl">{stat.label}</div>
            </div>
          ))}
        </section>

        {/* ─── DECISION ARENA — Standalone full-width interactive comparison ─── */}
        <section className="decision-arena" id="decision">
          <div className="arena-inner section-frame">
            <div className="arena-eyebrow-row">
              <span className="eyebrow">{isArabic ? 'اتخذ قرارك بمعلومات' : 'Make an Informed Decision'}</span>
              <h2 className="luxury-serif arena-headline">
                {isArabic ? 'الفرق الحقيقي بين خيارَيك' : 'The Real Difference Between Your Two Choices'}
              </h2>
            </div>

            <div className="arena-stage">
              {/* OPTION A — Cancel */}
              <div className="arena-card arena-card--loss">
                <div className="arena-card-badge">
                  <span className="arena-badge-icon">✕</span>
                  <span className="arena-badge-label">{isArabic ? 'الخيار أ' : 'Option A'}</span>
                </div>
                <h3 className="arena-card-title">{copy.hero.heroCard.cancelTitle}</h3>
                <div className="arena-figure">
                  <span className="arena-figure-value text-red">{copy.hero.heroCard.cancelDeductValue}</span>
                  <span className="arena-figure-note">{copy.hero.heroCard.cancelDeductLabel}</span>
                </div>
                <div className="arena-bar-track">
                  <div className="arena-bar arena-bar--loss" style={{ '--arena-bar-width': '25%' } as React.CSSProperties} />
                </div>
                <p className="arena-outcome">{copy.hero.heroCard.cancelNote}</p>
              </div>

              {/* Central Axis */}
              <div className="arena-axis">
                <div className="axis-line" />
                <div className="axis-vs">
                  <span>{copy.hero.heroCard.vsLabel}</span>
                </div>
                <div className="axis-line" />
              </div>

              {/* OPTION B — Transfer */}
              <div className="arena-card arena-card--gain">
                <div className="arena-card-badge">
                  <span className="arena-badge-icon arena-badge-icon--gold">✓</span>
                  <span className="arena-badge-label">{isArabic ? 'الخيار ب' : 'Option B'}</span>
                </div>
                <h3 className="arena-card-title">{copy.hero.heroCard.transferTitle}</h3>
                <div className="arena-figure">
                  <span className="arena-figure-value text-gold">{copy.hero.heroCard.transferGetValue}</span>
                  <span className="arena-figure-note">{copy.hero.heroCard.transferGetLabel}</span>
                </div>
                <div className="arena-bar-track">
                  <div className="arena-bar arena-bar--gain" style={{ '--arena-bar-width': '100%' } as React.CSSProperties} />
                </div>
                <p className="arena-outcome">{copy.hero.heroCard.transferNote}</p>
              </div>
            </div>

            <div className="arena-cta-row">
              <a className="primary-action" href="#search">
                {isArabic ? 'ابدأ التنازل بصفقة' : 'Start Your Transfer with Safqa'}{arrowIcon}
              </a>
            </div>
          </div>
        </section>

        {/* ─── SELLER vs BUYER — Custom Safqa Architecture Split Panel ─── */}
        <section className="section-frame seller-buyer-section" id="paths">
          <div className="section-heading">
            <span className="eyebrow">{copy.sellerBuyer.eyebrow}</span>
            <h2 className="luxury-serif">{copy.sellerBuyer.title}</h2>
            <p>{copy.sellerBuyer.subtitle}</p>
          </div>
          
          <div className="safqa-split-elevation-panel">
            {/* Seller Area (Warm Blueprint Off-White) */}
            <div className="elevation-block elevation-block--seller">
              <div className="elevation-meta">
                <span className="elevation-tag">{copy.sellerBuyer.seller.tag}</span>
                <span className="elevation-index">EL-01</span>
              </div>
              <h3 className="elevation-title">{copy.sellerBuyer.seller.title}</h3>
              <p className="elevation-desc">{copy.sellerBuyer.seller.body}</p>
              
              <div className="elevation-specs">
                {copy.sellerBuyer.seller.features.map((f, i) => (
                  <div key={i} className="spec-line">
                    <span className="spec-bullet">{i + 1}</span>
                    <p>{f}</p>
                  </div>
                ))}
              </div>
              
              <div className="elevation-notice">
                <span className="notice-icon">i</span>
                <p>{copy.sellerBuyer.seller.freeNote}</p>
              </div>
              
              <a className="safqa-solid-btn" href="#/sell" onClick={() => { setStep(1); setIsSubmitted(false); }}>{copy.sellerBuyer.seller.cta}</a>
            </div>

            {/* Buyer Area (Safqa Dark Slate Navy Blueprint) */}
            <div className="elevation-block elevation-block--buyer">
              <div className="elevation-meta">
                <span className="elevation-tag">{copy.sellerBuyer.buyer.tag}</span>
                <span className="elevation-index">EL-02</span>
              </div>
              <h3 className="elevation-title">{copy.sellerBuyer.buyer.title}</h3>
              <p className="elevation-desc">{copy.sellerBuyer.buyer.body}</p>
              
              <div className="elevation-specs">
                {copy.sellerBuyer.buyer.features.map((f, i) => (
                  <div key={i} className="spec-line">
                    <span className="spec-bullet spec-bullet--gold">{i + 1}</span>
                    <p>{f}</p>
                  </div>
                ))}
              </div>
              
              <a className="safqa-outline-btn" href="#opportunities">{copy.sellerBuyer.buyer.cta}</a>
            </div>
          </div>
        </section>

        {/* ─── COMPARISON TABLE — Structural Spec Sheet ─── */}
        <section className="comparison-section">
          <div className="comparison-inner section-frame">
            <div className="section-heading">
              <span className="eyebrow">{copy.comparison.eyebrow}</span>
              <h2 className="luxury-serif">{copy.comparison.title}</h2>
              <p>{copy.comparison.subtitle}</p>
            </div>
            
            <div className="structural-spec-sheet">
              {/* Header row */}
              <div className="spec-sheet-row spec-sheet-row--header">
                <div className="spec-sheet-cell cell-category">{isArabic ? 'المعيار الفني' : 'Technical Criteria'}</div>
                <div className="spec-sheet-cell cell-regular">{isArabic ? 'الريسيل التقليدي' : 'Traditional Resale'}</div>
                <div className="spec-sheet-cell cell-safqa">{isArabic ? 'منصة صفقة' : 'Safqa Platform'}</div>
              </div>
              
              {/* Data rows */}
              {copy.comparison.rows.map((row, idx) => (
                <div className="spec-sheet-row" key={row.label}>
                  <div className="spec-sheet-cell cell-category">
                    <span className="cell-index">0{idx + 1}</span>
                    <strong>{row.label}</strong>
                  </div>
                  <div className="spec-sheet-cell cell-regular">
                    <span className="status-marker status-marker--neg">✕</span>
                    <p>{row.regular}</p>
                  </div>
                  <div className="spec-sheet-cell cell-safqa">
                    <span className="status-marker status-marker--pos">✓</span>
                    <p>{row.safqa}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* ─── NUMBERS EXAMPLE — Financial Blueprint Visualizer ─── */}
        <section className="section-frame numbers-section">
          <div className="section-heading">
            <span className="eyebrow">{copy.numbersExample.eyebrow}</span>
            <h2 className="luxury-serif">{copy.numbersExample.title}</h2>
            <p>{copy.numbersExample.subtitle}</p>
          </div>
          
          <div className="financial-blueprint-visualizer">
            {/* Axis Header */}
            <div className="visualizer-header">
              <span className="hdr-tag">{isArabic ? 'مخطط مقارنة التدفق النقدي' : 'Cash Flow Blueprint comparison'}</span>
              <span className="hdr-value">{isArabic ? 'القيمة الافتراضية: 10,000,000 ج.م' : 'Reference Unit: 10,000,000 EGP'}</span>
            </div>

            <div className="visualizer-lanes">
              {/* Cancel Scenario */}
              <div className="visualizer-lane lane-cancel">
                <div className="lane-info">
                  <h3>{copy.numbersExample.cancelCard.title}</h3>
                  <p>{copy.numbersExample.cancelCard.note}</p>
                </div>
                <div className="lane-bar-container">
                  <div className="lane-bar-bar lane-bar-bar--danger" style={{ width: '25%' }}>
                    <span className="lane-bar-value">{copy.numbersExample.cancelCard.getValue}</span>
                  </div>
                  <span className="lane-bar-cost">{copy.numbersExample.cancelCard.deductValue} ({copy.numbersExample.cancelCard.deductLabel})</span>
                </div>
                <div className="lane-meta-details">
                  <span>{copy.numbersExample.cancelCard.yearsLabel}: <strong>{copy.numbersExample.cancelCard.yearsValue}</strong></span>
                </div>
              </div>

              {/* Transfer Scenario */}
              <div className="visualizer-lane lane-transfer">
                <div className="lane-info">
                  <h3>{copy.numbersExample.transferCard.title}</h3>
                  <p>{copy.numbersExample.transferCard.note}</p>
                </div>
                <div className="lane-bar-container">
                  <div className="lane-bar-bar lane-bar-bar--success" style={{ width: '25%' }}>
                    <span className="lane-bar-value">{copy.numbersExample.transferCard.getValue}</span>
                  </div>
                  <span className="lane-bar-cost">{copy.numbersExample.transferCard.feeLabel}: {copy.numbersExample.transferCard.feeValue}</span>
                </div>
                <div className="lane-meta-details">
                  <span>{copy.numbersExample.transferCard.getSub}</span>
                </div>
              </div>
            </div>
            
            <p className="numbers-disclaimer">{copy.numbersExample.disclaimer}</p>
          </div>
        </section>

        {/* ─── PATHS ACCORDION ─── */}
        <section className="section-frame" id="paths-accordion">
          <SectionHeading eyebrow={copy.paths.eyebrow} title={copy.paths.title} />
          <div className="paths-accordion">
            {copy.paths.items.map((item, index) => {
              const Icon = pathIcons[index]
              return (
                <div className="accordion-pillar" key={item.title}>
                  <div className="pillar-blueprint-bg" aria-hidden="true" />
                  <div className="pillar-content">
                    <div className="pillar-top-row">
                      <div className="pillar-icon-wrapper"><Icon size={22} className="pillar-icon" /></div>
                      <div className="pillar-num luxury-serif">0{index + 1}</div>
                    </div>
                    <h2>{item.title}</h2>
                    <p className="pillar-desc">{item.body}</p>
                    <button type="button" className="pillar-action"><span>{item.action}</span>{arrowIcon}</button>
                  </div>
                </div>
              )
            })}
          </div>
        </section>

        {/* ─── HOW IT WORKS — Construction Workflow Pipeline ─── */}
        <section className="how-it-works-section" id="how-it-works">
          <div className="hiw-inner section-frame">
            <div className="section-heading">
              <span className="eyebrow">{copy.howItWorks.eyebrow}</span>
              <h2 className="luxury-serif">{copy.howItWorks.title}</h2>
              <p>{copy.howItWorks.subtitle}</p>
            </div>
            
            <div className="construction-pipeline">
              {copy.howItWorks.steps.map((step, i) => (
                <div className="pipeline-node" key={step.title}>
                  <div className="pipeline-dot-row">
                    <div className="pipeline-circle">0{i + 1}</div>
                    {i < copy.howItWorks.steps.length - 1 && <div className="pipeline-pipe" />}
                  </div>
                  <div className="pipeline-content-card">
                    <h4>{step.title}</h4>
                    <p>{step.body}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* ─── FAIR EXIT STANDARDS ─── */}
        <section className="fair-exit-section">
          <div className="fair-exit-inner section-frame">
            <div className="section-heading">
              <span className="eyebrow">{copy.fairExit.eyebrow}</span>
              <h2 className="luxury-serif">{copy.fairExit.title}</h2>
              <p>{copy.fairExit.subtitle}</p>
            </div>
            <div className="fair-exit-grid">
              {copy.fairExit.items.map((item, i) => {
                const Icon = fairExitIcons[i]
                return (
                  <div className="fe-item" key={item.title}>
                    <span className="fe-icon"><Icon size={20} /></span>
                    <div>
                      <h3>{item.title}</h3>
                      <p>{item.body}</p>
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        </section>

        {/* ─── CALCULATOR CTA ─── */}
        <section className="calc-cta-section">
          <div className="calc-cta-inner section-frame">
            <div className="calc-cta-glow" aria-hidden="true" />
            <Calculator size={32} className="calc-cta-icon" />
            <h2>{copy.calculatorCta.title}</h2>
            <p>{copy.calculatorCta.subtitle}</p>
            <a className="teal-action calc-cta-btn" href="#/sell" onClick={() => { setStep(1); setIsSubmitted(false); }}>
              {copy.calculatorCta.cta}{arrowIcon}
            </a>
          </div>
        </section>

        {/* ─── DUAL ACTION CTA ─── */}
        <section className="dual-cta-section section-frame">
          <div className="dual-cta-card">
            <h3>{copy.dualCta.seller.title}</h3>
            <p>{copy.dualCta.seller.body}</p>
            <a className="primary-action" href="#/sell" onClick={(e) => { e.preventDefault(); window.location.hash = '#/sell'; setView('sell'); window.scrollTo(0, 0); setStep(1); setIsSubmitted(false); }}>{copy.dualCta.seller.cta}{arrowIcon}</a>
          </div>
          <div className="dual-cta-card">
            <h3>{copy.dualCta.buyer.title}</h3>
            <p>{copy.dualCta.buyer.body}</p>
            <a className="ghost-action" href="#opportunities">{copy.dualCta.buyer.cta}{arrowIcon}</a>
          </div>
        </section>

        {/* ─── OPPORTUNITIES SHOWCASE ─── */}
        <section className="section-frame" id="opportunities">
          <SectionHeading eyebrow={copy.opportunities.eyebrow} title={copy.opportunities.title} />
          
          <div className="opportunities-modern-grid">
            {copy.opportunities.items.slice(0, 3).map((item) => {
              const priceVal = parseFloat(item.price.replace(/,/g, ''))
              const oldPriceVal = parseFloat(item.oldPrice.replace(/,/g, ''))
              const savedVal = oldPriceVal - priceVal
              const formattedSaved = isArabic 
                ? `وفر ${savedVal.toLocaleString('ar-EG')} ج.م` 
                : `Save ${savedVal.toLocaleString('en-US')} EGP`

              return (
                <div className="opp-card-modern" key={item.title}>
                  <div className="opp-card-img-wrapper">
                    <img 
                      src={safqaAssets[item.imageKey]} 
                      alt={item.title} 
                      className="opp-card-img"
                    />
                    <span className="opp-card-badge">{item.badge}</span>
                    <span className="opp-card-location">
                      <MapPin size={12} style={{ marginInlineEnd: '4px' }} />
                      {item.location}
                    </span>
                  </div>

                  <div className="opp-card-content">
                    <h3 className="opp-card-title luxury-serif">{item.title}</h3>
                    
                    <div className="opp-card-specs">
                      {item.meta.split('/').map((spec, sIdx) => (
                        <span className="opp-spec-badge" key={sIdx}>
                          {spec.trim()}
                        </span>
                      ))}
                    </div>

                    <div className="opp-card-pricing-box">
                      <div className="opp-pricing-item">
                        <span className="opp-price-label">{isArabic ? 'السعر القديم للمطور' : 'Developer Price'}</span>
                        <span className="opp-old-price">{item.oldPrice} {isArabic ? 'ج.م' : 'EGP'}</span>
                      </div>
                      <div className="opp-pricing-item">
                        <span className="opp-price-label highlight-gold">{isArabic ? 'سعر صفقة (بدون أوفر)' : 'Safqa Price'}</span>
                        <strong className="opp-new-price">{item.price} {isArabic ? 'ج.م' : 'EGP'}</strong>
                      </div>
                    </div>

                    <div className="opp-save-tag">
                      <span className="save-icon">💎</span>
                      <span>{formattedSaved}</span>
                    </div>

                    <a 
                      href={`#/property/${item.id}`}
                      className="opp-card-cta-btn"
                      onClick={(e) => {
                        e.preventDefault();
                        window.location.hash = `#/property/${item.id}`;
                        setActivePropertyId(item.id);
                        setView('property-details');
                        window.scrollTo(0, 0);
                      }}
                    >
                      {isArabic ? 'مشاهدة التفاصيل' : 'View Details'}
                      {arrowIcon}
                    </a>
                  </div>
                </div>
              )
            })}
          </div>
          
          <div className="opp-view-all-container">
            <a 
              href="#/opportunities" 
              className="opp-view-all-btn"
              onClick={(e) => {
                e.preventDefault();
                window.location.hash = '#/opportunities';
                setView('opportunities');
                window.scrollTo(0, 0);
              }}
            >
              <span>{isArabic ? 'مشاهدة كل الفرص المتاحة (8 فرص)' : 'View All Available Opportunities (8 units)'}</span>
              {arrowIcon}
            </a>
          </div>

          <div className="market-strip" aria-hidden="true">
            {copy.stats.map((stat) => (
              <span key={stat.label}>{stat.value} / {stat.label}</span>
            ))}
          </div>
        </section>

        {/* ─── PROCESS SECTION — Clean Centered Steps Grid (No Image) ─── */}
        <section className="process-section" id="process">
          <div className="process-inner section-frame">
            <div className="section-heading section-heading--centered">
              <span className="eyebrow">{copy.process.eyebrow}</span>
              <h2 className="luxury-serif">{copy.process.title}</h2>
              <p>{copy.process.body}</p>
            </div>
            
            <div className="process-cards-grid">
              {copy.process.items.map((item, index) => {
                const Icon = processIcons[index]
                return (
                  <article key={item.title} className="process-card">
                    <div className="process-card-header">
                      <span className="process-card-num">0{index + 1}</span>
                      <span className="process-card-icon-box"><Icon size={22} /></span>
                    </div>
                    <h3 className="luxury-serif">{item.title}</h3>
                    <p>{item.body}</p>
                  </article>
                )
              })}
            </div>
          </div>
        </section>

        {/* ─── BROKER SECTION ─── */}
        <section className="broker-section section-frame" id="brokers">
          <div>
            <SectionHeading eyebrow={copy.broker.eyebrow} title={copy.broker.title} body={copy.broker.body} />
            <a className="primary-action" href="#search">{copy.hero.primaryCta}{arrowIcon}</a>
          </div>
          <div className="broker-metrics-strip">
            {copy.broker.cards.map((card) => (
              <div className="broker-metric-item" key={card.label}>
                <CircleDollarSign size={24} />
                <strong className="luxury-serif"><AnimatedNumber value={card.value} /></strong>
                <span>{card.label}</span>
              </div>
            ))}
          </div>
        </section>

        {/* ─── GUARANTEES ─── */}
        <section className="guarantee-section section-frame">
          <SectionHeading eyebrow={copy.guarantees.eyebrow} title={copy.guarantees.title} />
          <div className="guarantee-gridlines">
            {copy.guarantees.items.map((item) => (
              <article key={item.title} className="guarantee-item-column">
                <ShieldCheck size={26} />
                <h2 className="luxury-serif">{item.title}</h2>
                <p>{item.body}</p>
              </article>
            ))}
          </div>
        </section>

        {/* ─── TESTIMONIAL ─── */}
        <section className="section-frame testimonials-section">
          <div className="testimonial-focal">
            <span className="quote-sign luxury-serif">"</span>
            <p className="quote-text luxury-serif">{copy.testimonials.items[0].quote}</p>
            <div className="testifier-meta">
              <img src={safqaAssets[copy.testimonials.items[0].imageKey]} alt="" className="testifier-avatar" />
              <div className="testifier-text">
                <strong>{copy.testimonials.items[0].name}</strong>
                <small>{copy.testimonials.items[0].role}</small>
              </div>
            </div>
          </div>
        </section>

        {/* ─── FINAL CTA ─── */}
        <section className="final-cta">
          <div>
            <span className="eyebrow">{copy.hero.eyebrow}</span>
            <h2 className="luxury-serif">{copy.cta.title}</h2>
            <p>{copy.cta.body}</p>
          </div>
          <div className="final-actions">
            <a className="primary-action" href="#/sell" onClick={() => { setStep(1); setIsSubmitted(false); }}>{copy.cta.primary}{arrowIcon}</a>
            <a className="ghost-action" href={`mailto:${copy.footer.email}`}>{copy.cta.secondary}</a>
          </div>
        </section>
          </>
        ) : view === 'opportunities' ? (
          renderOpportunitiesCatalogView()
        ) : view === 'property-details' ? (
          renderPropertyDetailsView()
        ) : (
          renderSellView()
        )}
      </main>

      {/* ─── FOOTER ─── */}
      <footer className="site-footer">
        <div>
          <strong className="luxury-serif">{copy.footer.title}</strong>
          <p>{copy.footer.body}</p>
        </div>
        <div className="footer-contacts">
          <a href={`tel:${copy.footer.phone}`}>{copy.footer.phone}</a>
          <a href={`mailto:${copy.footer.email}`}>{copy.footer.email}</a>
        </div>
      </footer>
    </div>
  )
}

type SectionHeadingProps = { eyebrow: string; title: string; body?: string }
function SectionHeading({ eyebrow, title, body }: SectionHeadingProps) {
  return (
    <div className="section-heading">
      <span className="eyebrow">{eyebrow}</span>
      <h2 className="luxury-serif">{title}</h2>
      {body ? <p>{body}</p> : null}
    </div>
  )
}

export default App
