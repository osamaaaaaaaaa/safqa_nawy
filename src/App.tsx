import { useState, useEffect } from 'react'
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
} from 'lucide-react'
import './App.css'
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

function App() {
  const [locale, setLocale] = useState<Locale>('ar')
  const [view, setView] = useState<'landing' | 'sell'>('landing')
  const [step, setStep] = useState(1)
  const [isSubmitted, setIsSubmitted] = useState(false)
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
    name: '',
    phone: '',
    email: '',
    ownerConfirm: false,
  })
  const [activeOpp, setActiveOpp] = useState(0)
  const [mousePos, setMousePos] = useState({ x: 0, y: 0 })
  const copy = safqaLandingCopy[locale]
  const isArabic = locale === 'ar'
  const arrowIcon = isArabic ? <ArrowLeft size={18} /> : <ArrowRight size={18} />

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

  const isStepValid = () => {
    if (step === 1) {
      return (
        formData.developerName.trim() !== '' &&
        formData.projectName.trim() !== '' &&
        formData.totalPrice.trim() !== '' &&
        formData.amountPaid.trim() !== '' &&
        formData.zeroOverAck
      )
    }
    if (step === 2) {
      return (
        formData.remainingPrice.trim() !== '' &&
        formData.nextInstallment.trim() !== ''
      )
    }
    if (step === 3) {
      return (
        formData.name.trim() !== '' &&
        formData.phone.trim() !== '' &&
        formData.email.trim() !== '' &&
        formData.ownerConfirm
      )
    }
    return false
  }

  const renderSellView = () => {
    const sCopy = copy.sellersPage
    
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
                onClick={() => setView('landing')}
              >
                {sCopy.form.backHome}
              </button>
            </div>
          </div>
        </section>
      )
    }

    return (
      <section className="sell-page-section section-frame">
        <div className="sell-page-grid">
          {/* Left Column: Copys & Rules */}
          <div className="sell-page-info">
            <h1 className="luxury-serif">{sCopy.title}</h1>
            <p className="sell-page-sub">{sCopy.subtitle}</p>
            
            <ul className="sell-points-list">
              {sCopy.points.map((p, idx) => (
                <li key={idx} className="sell-point-item">
                  <span className="point-check-icon"><Check size={16} /></span>
                  <span>{p}</span>
                </li>
              ))}
            </ul>

            <div className="owners-only-warning">
              <div className="warning-hdr">
                <User size={20} className="warning-icon" />
                <h3>{sCopy.ownersOnlyTitle}</h3>
              </div>
              <p>{sCopy.ownersOnlyDesc}</p>
            </div>
          </div>

          {/* Right Column: Interactive Form Card */}
          <div className="sell-form-card">
            <div className="form-card-header">
              <span className="step-indicator">
                {sCopy.form.stepOf.replace('{current}', String(step)).replace('{total}', '3')}
              </span>
              <div className="step-progress-bar">
                <div className="step-progress-fill" style={{ width: `${(step / 3) * 100}%` }} />
              </div>
              <h2 className="step-title">
                {step === 1 && sCopy.form.step1Title}
                {step === 2 && sCopy.form.step2Title}
                {step === 3 && sCopy.form.step3Title}
              </h2>
            </div>

            <form onSubmit={(e) => { e.preventDefault(); if (step === 3) setIsSubmitted(true); }}>
              {step === 1 && (
                <div className="form-step-fields">
                  <div className="form-group">
                    <label>{sCopy.form.developerName}</label>
                    <input 
                      type="text" 
                      required
                      placeholder={isArabic ? "مثال: إعمار، سوديك..." : "e.g. Emaar, SODIC..."}
                      value={formData.developerName} 
                      onChange={(e) => handleInputChange('developerName', e.target.value)} 
                    />
                  </div>

                  <div className="form-group">
                    <label>{sCopy.form.projectName}</label>
                    <input 
                      type="text" 
                      required
                      placeholder={isArabic ? "مثال: مراسي، فيليت..." : "e.g. Marassi, Villette..."}
                      value={formData.projectName} 
                      onChange={(e) => handleInputChange('projectName', e.target.value)} 
                    />
                  </div>

                  <div className="form-row-2">
                    <div className="form-group">
                      <label>{sCopy.form.totalPrice}</label>
                      <div className="input-currency-wrapper">
                        <input 
                          type="number" 
                          required
                          value={formData.totalPrice} 
                          onChange={(e) => handleInputChange('totalPrice', e.target.value)} 
                        />
                        <span className="currency-tag">{isArabic ? 'ج.م' : 'EGP'}</span>
                      </div>
                    </div>

                    <div className="form-group">
                      <label>{sCopy.form.amountPaid}</label>
                      <div className="input-currency-wrapper">
                        <input 
                          type="number" 
                          required
                          value={formData.amountPaid} 
                          onChange={(e) => handleInputChange('amountPaid', e.target.value)} 
                        />
                        <span className="currency-tag">{isArabic ? 'ج.م' : 'EGP'}</span>
                      </div>
                    </div>
                  </div>

                  <div className="form-group">
                    <label>{sCopy.form.currentPrice}</label>
                    <div className="input-currency-wrapper">
                      <input 
                        type="number" 
                        value={formData.currentPrice} 
                        onChange={(e) => handleInputChange('currentPrice', e.target.value)} 
                      />
                      <span className="currency-tag">{isArabic ? 'ج.م' : 'EGP'}</span>
                    </div>
                    <span className="field-hint">{sCopy.form.currentPriceHint}</span>
                  </div>

                  <label className="checkbox-label-block">
                    <input 
                      type="checkbox" 
                      checked={formData.zeroOverAck} 
                      onChange={(e) => handleInputChange('zeroOverAck', e.target.checked)} 
                    />
                    <span className="checkbox-text">{sCopy.form.zeroOverAck}</span>
                  </label>
                </div>
              )}

              {step === 2 && (
                <div className="form-step-fields">
                  <div className="form-group">
                    <label>{sCopy.form.remainingPrice}</label>
                    <div className="input-currency-wrapper">
                      <input 
                        type="number" 
                        required
                        value={formData.remainingPrice} 
                        onChange={(e) => handleInputChange('remainingPrice', e.target.value)} 
                      />
                      <span className="currency-tag">{isArabic ? 'ج.م' : 'EGP'}</span>
                    </div>
                  </div>

                  <div className="form-group">
                    <label>{sCopy.form.nextInstallment}</label>
                    <div className="input-currency-wrapper">
                      <input 
                        type="number" 
                        required
                        value={formData.nextInstallment} 
                        onChange={(e) => handleInputChange('nextInstallment', e.target.value)} 
                      />
                      <span className="currency-tag">{isArabic ? 'ج.م' : 'EGP'}</span>
                    </div>
                  </div>

                  <div className="form-group">
                    <label>{sCopy.form.frequency}</label>
                    <select 
                      value={formData.frequency} 
                      onChange={(e) => handleInputChange('frequency', e.target.value)}
                    >
                      <option value="monthly">{sCopy.form.freqMonthly}</option>
                      <option value="quarterly">{sCopy.form.freqQuarterly}</option>
                      <option value="semiannual">{sCopy.form.freqSemiannual}</option>
                      <option value="annual">{sCopy.form.freqAnnual}</option>
                    </select>
                  </div>

                  <div className="form-group">
                    <label>{sCopy.form.unitType}</label>
                    <select 
                      value={formData.unitType} 
                      onChange={(e) => handleInputChange('unitType', e.target.value)}
                    >
                      <option value="apartment">{sCopy.form.typeApartment}</option>
                      <option value="villa">{sCopy.form.typeVilla}</option>
                      <option value="townhouse">{sCopy.form.typeTownhouse}</option>
                      <option value="twinhouse">{sCopy.form.typeTwinhouse}</option>
                    </select>
                  </div>
                </div>
              )}

              {step === 3 && (
                <div className="form-step-fields">
                  <div className="form-group">
                    <label>{sCopy.form.name}</label>
                    <input 
                      type="text" 
                      required
                      placeholder={isArabic ? "اكتب اسمك الثلاثي" : "Your full name"}
                      value={formData.name} 
                      onChange={(e) => handleInputChange('name', e.target.value)} 
                    />
                  </div>

                  <div className="form-group">
                    <label>{sCopy.form.phone}</label>
                    <input 
                      type="tel" 
                      required
                      placeholder={isArabic ? "مثال: 010xxxxxxxx" : "e.g. +2010xxxxxxxx"}
                      value={formData.phone} 
                      onChange={(e) => handleInputChange('phone', e.target.value)} 
                    />
                  </div>

                  <div className="form-group">
                    <label>{sCopy.form.email}</label>
                    <input 
                      type="email" 
                      required
                      placeholder="name@domain.com"
                      value={formData.email} 
                      onChange={(e) => handleInputChange('email', e.target.value)} 
                    />
                  </div>

                  <label className="checkbox-label-block">
                    <input 
                      type="checkbox" 
                      checked={formData.ownerConfirm} 
                      onChange={(e) => handleInputChange('ownerConfirm', e.target.checked)} 
                    />
                    <span className="checkbox-text">{sCopy.form.ownerConfirm}</span>
                  </label>
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
                    disabled={!isStepValid()}
                    onClick={() => setStep(prev => prev + 1)}
                  >
                    {sCopy.form.nextBtn}
                  </button>
                ) : (
                  <button 
                    type="submit" 
                    className="sell-form-btn sell-form-btn--submit"
                    disabled={!isStepValid()}
                  >
                    {sCopy.form.submitBtn}
                  </button>
                )}
              </div>
            </form>
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
        <a className="brand-lockup" href="#home" onClick={() => setView('landing')} aria-label="SAFQA">
          <span className="brand-logo-text">
            SAFQA
            <span className="brand-logo-dot">.</span>
          </span>
        </a>
        <nav className="nav-links" aria-label="Primary">
          <a href="#home" onClick={() => setView('landing')}>{copy.nav.home}</a>
          <a href="#decision" onClick={() => setView('landing')}>{copy.nav.decision}</a>
          <a href="#paths" onClick={() => setView('landing')}>{copy.nav.paths}</a>
          <a href="#opportunities" onClick={() => setView('landing')}>{copy.nav.opportunities}</a>
          <a href="#how-it-works" onClick={() => setView('landing')}>{copy.nav.howItWorks}</a>
          <a href="#process" onClick={() => setView('landing')}>{copy.nav.process}</a>
          <a href="#brokers" onClick={() => setView('landing')}>{copy.nav.brokers}</a>
        </nav>
        <div className="nav-actions">
          <button className="language-button" type="button" onClick={() => setLocale(isArabic ? 'en' : 'ar')}>
            <Globe2 size={16} /><span>{copy.switchLanguage}</span>
          </button>
          <button
            type="button"
            className="nav-cta-button"
            onClick={() => { setView('sell'); setStep(1); setIsSubmitted(false); }}
          >
            {isArabic ? 'بيع وحدتك' : 'Sell Unit'}
          </button>
        </div>
      </header>

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
                <a className="primary-action" href="#sell" onClick={(e) => { e.preventDefault(); setView('sell'); setStep(1); setIsSubmitted(false); }}>{copy.hero.primaryCta}{arrowIcon}</a>
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
              
              <a className="safqa-solid-btn" href="#sell" onClick={(e) => { e.preventDefault(); setView('sell'); setStep(1); setIsSubmitted(false); }}>{copy.sellerBuyer.seller.cta}</a>
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
                  <div className="lane-bar-bar lane-bar-bar--success" style={{ width: '100%' }}>
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
            <a className="teal-action calc-cta-btn" href="#sell" onClick={(e) => { e.preventDefault(); setView('sell'); setStep(1); setIsSubmitted(false); }}>
              {copy.calculatorCta.cta}{arrowIcon}
            </a>
          </div>
        </section>

        {/* ─── DUAL ACTION CTA ─── */}
        <section className="dual-cta-section section-frame">
          <div className="dual-cta-card">
            <h3>{copy.dualCta.seller.title}</h3>
            <p>{copy.dualCta.seller.body}</p>
            <a className="primary-action" href="#sell" onClick={(e) => { e.preventDefault(); setView('sell'); setStep(1); setIsSubmitted(false); }}>{copy.dualCta.seller.cta}{arrowIcon}</a>
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
          <div className="opp-split-showcase">
            <div className="opp-showcase-frame">
              <div className="showcase-img-container">
                <img
                  key={activeOpp}
                  src={safqaAssets[copy.opportunities.items[activeOpp].imageKey]}
                  alt={copy.opportunities.items[activeOpp].title}
                  className="showcase-img fade-zoom-in"
                />
                <span className="showcase-badge">{copy.opportunities.items[activeOpp].badge}</span>
              </div>
              <div className="showcase-details">
                <div className="showcase-details-top">
                  <h2 className="luxury-serif">{copy.opportunities.items[activeOpp].title}</h2>
                  <span className="showcase-location">{copy.opportunities.items[activeOpp].location}</span>
                </div>
                <div className="showcase-pricing">
                  <div className="showcase-pricing-left">
                    <span className="showcase-price-label">Net Value</span>
                    <strong className="showcase-price">{copy.opportunities.items[activeOpp].price}</strong>
                  </div>
                  <div className="showcase-pricing-right">
                    <span className="showcase-oldprice-label">Old Price</span>
                    <span className="showcase-oldprice">{copy.opportunities.items[activeOpp].oldPrice}</span>
                  </div>
                </div>
                <div className="showcase-meta">
                  <ShieldCheck size={14} className="showcase-meta-icon" />
                  <span>{copy.opportunities.items[activeOpp].meta}</span>
                </div>
              </div>
            </div>
            <div className="opp-showcase-list">
              {copy.opportunities.items.map((item, index) => {
                const isActive = activeOpp === index
                return (
                  <button
                    type="button" key={item.title}
                    className={`opp-list-item ${isActive ? 'is-active' : ''}`}
                    onClick={() => setActiveOpp(index)}
                  >
                    <div className="opp-item-left">
                      <span className="opp-item-index luxury-serif">0{index + 1}</span>
                      <div className="opp-item-title-block">
                        <strong>{item.title}</strong>
                        <small>{item.location}</small>
                      </div>
                    </div>
                    <div className="opp-item-right">
                      <strong className="opp-item-price">{item.price}</strong>
                      <span className="opp-item-badge">{item.badge}</span>
                    </div>
                  </button>
                )
              })}
            </div>
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
            <a className="primary-action" href="#sell" onClick={(e) => { e.preventDefault(); setView('sell'); setStep(1); setIsSubmitted(false); }}>{copy.cta.primary}{arrowIcon}</a>
            <a className="ghost-action" href={`mailto:${copy.footer.email}`}>{copy.cta.secondary}</a>
          </div>
        </section>
          </>
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
