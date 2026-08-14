(function () {
  var currentLang = localStorage.getItem('safqa-lang') || 'ar';

  var copy = {
    en: {
      brand: 'Safqa',
      nav: {
        Home: 'Home',
        About: 'About',
        Services: 'Services',
        Agent: 'Team',
        Listing: 'Listings',
        Blog: 'Guide',
        Contact: 'Contact',
      },
      text: {
        'Find Properties': 'Sell Your Unit',
        'That Make You Money': 'Without Losing Your Money',
        'Search Properties': 'Search Opportunities',
        Location: 'Location',
        'City/Locality Name': 'City or compound',
        'Property Type': 'Unit Type',
        'Property Status': 'Deal Status',
        'Price Limit': 'Price Limit',
        'Search Property': 'Search Deal',
        'What we offer': 'Selected Offers',
        'Exclusive Offer For You': 'Verified Units and Broker Deals',
        'Blue View Home': 'Documented Transfer Opportunity',
        '2854 Meadow View Drive, Hartford, USA': 'New Cairo, Egypt',
        Services: 'Services',
        'Why Choose Us?': 'Why Choose Safqa?',
        'No Downpayment': 'Safe Exit From Installments',
        'All Cash Offer': 'Older Contract Prices',
        'Experts in Your Corner': 'Documents Checked',
        'Locked in Pricing': 'Broker Deal Closing',
        'Find Properties': 'Find Opportunities',
        'Find Properties In Your City': 'Transfer Opportunities in Key Areas',
        '100 Property Listing': '100 Transfer Opportunities',
        'See All Listing': 'See Opportunities',
        Testimonial: 'Testimonial',
        'Happy Clients': 'Clients Who Exited Safely',
        Agents: 'Team',
        'Our Agents': 'Closing Team',
        'Recent Blog': 'Transfer and Deal Guide',
        'Why Lead Generation is Key for Business Growth': 'How to Sell Before Cancellation Losses',
        Findstate: 'Safqa',
        Community: 'Community',
        'About Us': 'About Safqa',
        Company: 'Company',
        'Have a Questions?': 'Questions?',
        'For Agents': 'For Brokers',
        Reviews: 'Reviews',
        FAQs: 'FAQs',
        'Our Story': 'Our Story',
        'Meet the team': 'Meet the team',
        Careers: 'Careers',
        Press: 'Press',
        'Properties Details': 'Property Details',
        Features: 'Features',
        Description: 'Description',
        Review: 'Review',
        'Green Valey Home': 'Documented Transfer Unit',
        'Lot Area: 1,250 SQ FT': 'Transfer status: under review',
        'Bed Rooms: 4': 'Bedrooms: 3',
        'Bath Rooms: 4': 'Bathrooms: 2',
        Luggage: 'Documents: available',
        'Garage: 2': 'Commission: clear',
        'Give a Review': 'Deal Rating',
        '23 Reviews': 'Client Reviews',
        'Mobile App': 'Mobile App',
        'Manage Your Property Deal From Your Phone': 'Manage Your Property Deal From Your Phone',
        'Transfer Deal': 'Transfer Deal',
        'New Cairo Unit': 'New Cairo Unit',
        'Documents checked': 'Documents checked',
        'Next Step': 'Next Step',
        'Developer Review': 'Developer Review',
        '48 hours remaining': '48 hours remaining',
        Sell: 'Sell',
        Buy: 'Buy',
        Close: 'Close',
        'Track Transfer Documents': 'Track Transfer Documents',
        'Compare Old Contract Prices': 'Compare Old Contract Prices',
        'Broker Deal Room': 'Broker Deal Room',
      },
      paragraphs: {
        footer:
          'A platform for property transfers, distressed seller protection, and freelance broker deal closing.',
        service:
          'We review contracts, payments, remaining installments, and transfer steps before any deal moves forward.',
        review:
          'Safqa organized the paperwork, clarified the numbers, and made the transfer process easier to follow.',
        appDocuments:
          'Follow contract, paid amounts, remaining installments, and transfer status in one clear screen.',
        appPrices:
          'Buyers can review verified opportunities and understand the real difference from market prices.',
        appBroker:
          'Freelance brokers register deals, track closing steps, and keep commission status visible.',
      },
      toggle: 'العربية',
    },
    ar: {
      brand: 'صفقة',
      nav: {
        Home: 'الرئيسية',
        About: 'عن صفقة',
        Services: 'الخدمات',
        Agent: 'الفريق',
        Listing: 'الفرص',
        Blog: 'الدليل',
        Contact: 'تواصل معنا',
      },
      text: {
        'Find Properties': 'بيع وحدتك',
        'That Make You Money': 'بدون خسارة فلوسك',
        'Search Properties': 'ابحث عن فرصة',
        Location: 'الموقع',
        'City/Locality Name': 'المدينة أو الكمبوند',
        'Property Type': 'نوع الوحدة',
        'Property Status': 'حالة الصفقة',
        'Price Limit': 'حد السعر',
        'Search Property': 'ابحث عن صفقة',
        'What we offer': 'فرص مختارة',
        'Exclusive Offer For You': 'وحدات وصفقات متحققة بالمستندات',
        'Blue View Home': 'فرصة تنازل موثقة',
        '2854 Meadow View Drive, Hartford, USA': 'القاهرة الجديدة، مصر',
        Services: 'الخدمات',
        'Why Choose Us?': 'ليه تختار صفقة؟',
        'No Downpayment': 'خروج آمن من الأقساط',
        'All Cash Offer': 'سعر تعاقد قديم',
        'Experts in Your Corner': 'مستندات متحققة',
        'Locked in Pricing': 'إغلاق صفقات البروكرز',
        'Find Properties': 'ابحث عن فرص',
        'Find Properties In Your City': 'فرص تنازل في أهم المناطق',
        '100 Property Listing': '100 فرصة تنازل',
        'See All Listing': 'شوف الفرص',
        Testimonial: 'آراء العملاء',
        'Happy Clients': 'عملاء خرجوا بأمان',
        Agents: 'الفريق',
        'Our Agents': 'فريق الإغلاق',
        'Recent Blog': 'دليل التنازل والصفقات',
        'Why Lead Generation is Key for Business Growth': 'إزاي تبيع قبل خسارة الإلغاء؟',
        Findstate: 'صفقة',
        Community: 'المجتمع',
        'About Us': 'عن صفقة',
        Company: 'الشركة',
        'Have a Questions?': 'عندك سؤال؟',
        'For Agents': 'للبروكرز',
        Reviews: 'آراء العملاء',
        FAQs: 'أسئلة شائعة',
        'Our Story': 'قصتنا',
        'Meet the team': 'الفريق',
        Careers: 'الوظائف',
        Press: 'الأخبار',
        'Properties Details': 'تفاصيل الوحدة',
        Features: 'المميزات',
        Description: 'الوصف',
        Review: 'المراجعات',
        'Green Valey Home': 'وحدة تنازل موثقة',
        'Lot Area: 1,250 SQ FT': 'حالة التنازل: قيد الفحص',
        'Bed Rooms: 4': 'غرف النوم: 3',
        'Bath Rooms: 4': 'الحمامات: 2',
        Luggage: 'المستندات: متاحة',
        'Garage: 2': 'العمولة: واضحة',
        'Give a Review': 'تقييم الصفقة',
        '23 Reviews': 'مراجعات العملاء',
        'Mobile App': 'تطبيق الموبايل',
        'Manage Your Property Deal From Your Phone': 'تابع صفقتك العقارية من موبايلك',
        'Transfer Deal': 'صفقة تنازل',
        'New Cairo Unit': 'وحدة القاهرة الجديدة',
        'Documents checked': 'المستندات متحققة',
        'Next Step': 'الخطوة التالية',
        'Developer Review': 'مراجعة المطور',
        '48 hours remaining': 'متبقي 48 ساعة',
        Sell: 'بيع',
        Buy: 'شراء',
        Close: 'إغلاق',
        'Track Transfer Documents': 'تابع مستندات التنازل',
        'Compare Old Contract Prices': 'قارن أسعار التعاقد القديم',
        'Broker Deal Room': 'غرفة صفقات البروكر',
      },
      paragraphs: {
        footer:
          'منصة لتسهيل التنازل، حماية البائع المتعثر، ومساعدة البروكر الفريلانسر على إغلاق صفقته.',
        service:
          'نراجع العقد والمدفوع والمتبقي وإجراءات التنازل قبل تحريك أي صفقة للطرفين.',
        review:
          'صفقة رتبت الورق، وضحت الأرقام، وسهلت متابعة إجراءات التنازل خطوة بخطوة.',
        appDocuments:
          'تابع العقد والمدفوع والمتبقي وحالة التنازل في شاشة واحدة واضحة.',
        appPrices:
          'المشتري يراجع الفرص المتحققة ويفهم الفرق الحقيقي عن سعر السوق.',
        appBroker:
          'البروكر الفريلانسر يسجل الصفقة ويتابع خطوات الإغلاق وحالة العمولة.',
      },
      toggle: 'English',
    },
  };

  function normalize(value) {
    return value.replace(/\s+/g, ' ').trim();
  }

  function replaceTextNodes(root, dictionary) {
    var walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT);
    var node;
    while ((node = walker.nextNode())) {
      var text = normalize(node.nodeValue || '');
      if (!text) continue;
      if (dictionary.text[text]) {
        node.nodeValue = node.nodeValue.replace(text, dictionary.text[text]);
      } else if (text.indexOf('A small river named Duden') === 0) {
        node.nodeValue = dictionary.paragraphs.service;
      } else if (text.indexOf('Far far away') === 0) {
        node.nodeValue = dictionary.paragraphs.footer;
      } else if (text.indexOf('When she reached') === 0) {
        node.nodeValue = dictionary.paragraphs.review;
      } else if (text === 'Follow contract, paid amounts, remaining installments, and transfer status in one clear screen.') {
        node.nodeValue = dictionary.paragraphs.appDocuments;
      } else if (text === 'Buyers can review verified opportunities and understand the real difference from market prices.') {
        node.nodeValue = dictionary.paragraphs.appPrices;
      } else if (text === 'Freelance brokers register deals, track closing steps, and keep commission status visible.') {
        node.nodeValue = dictionary.paragraphs.appBroker;
      }
    }
  }

  function replaceAttributes(dictionary) {
    Array.prototype.forEach.call(document.querySelectorAll('[placeholder]'), function (element) {
      var value = element.getAttribute('placeholder');
      if (dictionary.text[value]) element.setAttribute('placeholder', dictionary.text[value]);
    });

    Array.prototype.forEach.call(document.querySelectorAll('input[value]'), function (element) {
      var value = element.getAttribute('value');
      if (dictionary.text[value]) element.setAttribute('value', dictionary.text[value]);
    });
  }

  function updateNavigation(dictionary) {
    var brand = document.querySelector('.navbar-brand');
    if (brand) brand.textContent = dictionary.brand;

    Array.prototype.forEach.call(document.querySelectorAll('.navbar-nav .nav-link'), function (link) {
      var text = normalize(link.textContent || '');
      if (dictionary.nav[text]) link.textContent = dictionary.nav[text];
    });

    var nav = document.querySelector('.navbar-nav');
    if (!nav || document.querySelector('.safqa-lang-toggle')) return;

    var item = document.createElement('li');
    item.className = 'nav-item safqa-lang-toggle';
    var button = document.createElement('button');
    button.className = 'nav-link';
    button.type = 'button';
    button.textContent = dictionary.toggle;
    button.style.background = 'transparent';
    button.style.border = '0';
    button.style.cursor = 'pointer';
    button.onclick = function () {
      localStorage.setItem('safqa-lang', currentLang === 'ar' ? 'en' : 'ar');
      window.location.reload();
    };
    item.appendChild(button);
    nav.appendChild(item);
  }

  function applyCopy() {
    var dictionary = copy[currentLang] || copy.ar;
    document.documentElement.lang = currentLang;
    document.documentElement.dir = currentLang === 'ar' ? 'rtl' : 'ltr';
    document.title = dictionary.brand;
    document.body.classList.toggle('safqa-rtl', currentLang === 'ar');
    document.body.classList.toggle('safqa-ltr', currentLang !== 'ar');
    updateNavigation(dictionary);
    replaceAttributes(dictionary);
    replaceTextNodes(document.body, dictionary);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', applyCopy);
  } else {
    applyCopy();
  }
})();
