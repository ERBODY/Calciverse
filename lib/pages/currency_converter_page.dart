import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class CurrencyConverterPage extends StatefulWidget {
  final String currentLanguage;
  const CurrencyConverterPage({super.key, required this.currentLanguage});

  @override
  State<CurrencyConverterPage> createState() => CurrencyConverterPageState();
}

class CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _inputController = TextEditingController();
  String? _fromCurrency;
  String? _toCurrency;
  double _convertedValue = 0;
  bool _hasCalculated = false;
  Map<String, double> _results = {};

  // Country flag emojis mapping
  final Map<String, String> _countryFlags = {
    'USD': '🇺🇸',
    'EUR': '🇪🇺',
    'GBP': '🇬🇧',
    'JPY': '🇯🇵',
    'AUD': '🇦🇺',
    'CAD': '🇨🇦',
    'CHF': '🇨🇭',
    'CNY': '🇨🇳',
    'INR': '🇮🇳',
    'NZD': '🇳🇿',
    'AED': '🇦🇪',
    'AFN': '🇦🇫',
    'ALL': '🇦🇱',
    'AMD': '🇦🇲',
    'ANG': '🇧🇶',
    'AOA': '🇦🇴',
    'ARS': '🇦🇷',
    'AWG': '🇦🇼',
    'AZN': '🇦🇿',
    'BAM': '🇧🇦',
    'BBD': '🇧🇧',
    'BDT': '🇧🇩',
    'BGN': '🇧🇬',
    'BHD': '🇧🇭',
    'BIF': '🇧🇮',
    'BMD': '🇧🇲',
    'BND': '🇧🇳',
    'BOB': '🇧🇴',
    'BRL': '🇧🇷',
    'BSD': '🇧🇸',
    'BTN': '🇧🇹',
    'BWP': '🇧🇼',
    'BYN': '🇧🇾',
    'BZD': '🇧🇿',
    'CDF': '🇨🇩',
    'CLF': '🇨🇱',
    'CLP': '🇨🇱',
    'CNH': '🇨🇳',
    'COP': '🇨🇴',
    'CRC': '🇨🇷',
    'CUP': '🇨🇺',
    'CVE': '🇨🇻',
    'CZK': '🇨🇿',
    'DJF': '🇩🇯',
    'DKK': '🇩🇰',
    'DOP': '🇩🇴',
    'DZD': '🇩🇿',
    'EGP': '🇪🇬',
    'ERN': '🇪🇷',
    'ETB': '🇪🇹',
    'FJD': '🇫🇯',
    'FKP': '🇫🇰',
    'FOK': '🇫🇴',
    'GEL': '🇬🇪',
    'GGP': '🇬🇬',
    'GHS': '🇬🇭',
    'GIP': '🇬🇮',
    'GMD': '🇬🇲',
    'GNF': '🇬🇳',
    'GTQ': '🇬🇹',
    'GYD': '🇬🇾',
    'HKD': '🇭🇰',
    'HNL': '🇭🇳',
    'HRK': '🇭🇷',
    'HTG': '🇭🇹',
    'HUF': '🇭🇺',
    'IDR': '🇮🇩',
    'IMP': '🇮🇲',
    'IQD': '🇮🇶',
    'IRR': '🇮🇷',
    'ISK': '🇮🇸',
    'JEP': '🇯🇪',
    'JMD': '🇯🇲',
    'JOD': '🇯🇴',
    'KES': '🇰🇪',
    'KGS': '🇰🇬',
    'KHR': '🇰🇭',
    'KID': '🇰🇮',
    'KMF': '🇰🇲',
    'KRW': '🇰🇷',
    'KWD': '🇰🇼',
    'KYD': '🇰🇾',
    'KZT': '🇰🇿',
    'LAK': '🇱🇦',
    'LBP': '🇱🇧',
    'LKR': '🇱🇰',
    'LRD': '🇱🇷',
    'LSL': '🇱🇸',
    'LYD': '🇱🇾',
    'MAD': '🇲🇦',
    'MDL': '🇲🇩',
    'MGA': '🇲🇬',
    'MKD': '🇲🇰',
    'MMK': '🇲🇲',
    'MNT': '🇲🇳',
    'MOP': '🇲🇴',
    'MRU': '🇲🇷',
    'MUR': '🇲🇺',
    'MVR': '🇲🇻',
    'MWK': '🇲🇼',
    'MXN': '🇲🇽',
    'MYR': '🇲🇾',
    'MZN': '🇲🇿',
    'NAD': '🇳🇦',
    'NGN': '🇳🇬',
    'NIO': '🇳🇮',
    'NOK': '🇳🇴',
    'NPR': '🇳🇵',
    'OMR': '🇴🇲',
    'PAB': '🇵🇦',
    'PEN': '🇵🇪',
    'PGK': '🇵🇬',
    'PHP': '🇵🇭',
    'PKR': '🇵🇰',
    'PLN': '🇵🇱',
    'PYG': '🇵🇾',
    'QAR': '🇶🇦',
    'QAT': '🇶🇦',
    'RON': '🇷🇴',
    'RSD': '🇷🇸',
    'RUB': '🇷🇺',
    'RWF': '🇷🇼',
    'SAR': '🇸🇦',
    'SBD': '🇸🇧',
    'SCR': '🇸🇨',
    'SDG': '🇸🇩',
    'SEK': '🇸🇪',
    'SGD': '🇸🇬',
    'SHP': '🇸🇭',
    'SLE': '🇸🇱',
    'SLL': '🇸🇱',
    'SOS': '🇸🇴',
    'SRD': '🇸🇷',
    'SSP': '🇸🇸',
    'STN': '🇸🇹',
    'SYP': '🇸🇾',
    'SZL': '🇸🇿',
    'THB': '🇹🇭',
    'TJS': '🇹🇯',
    'TMT': '🇹🇲',
    'TND': '🇹🇳',
    'TOP': '🇹🇴',
    'TRY': '🇹🇷',
    'TTD': '🇹🇹',
    'TVD': '🇹🇻',
    'TWD': '🇹🇼',
    'TZS': '🇹🇿',
    'UAH': '🇺🇦',
    'UGX': '🇺🇬',
    'UYU': '🇺🇾',
    'UZS': '🇺🇿',
    'VES': '🇻🇪',
    'VND': '🇻🇳',
    'VUV': '🇻🇺',
    'WST': '🇼🇸',
    'XAF': '🇨🇲',
    'XCD': '🇦🇬',
    'XCG': '💰',
    'XDR': '🏦',
    'XOF': '🇧🇯',
    'XPF': '🇵🇫',
    'YER': '🇾🇪',
    'ZAR': '🇿🇦',
    'ZMW': '🇿🇲',
    'ZWL': '🇿🇼',
    'ZWG': '🇿🇼',
  };

  // Arabic names for currencies and countries keyed by code
  final Map<String, String> _currencyNamesAr = {
    'USD': 'الدولار الأمريكي',
    'EUR': 'اليورو',
    'GBP': 'الجنيه الإسترليني',
    'JPY': 'الين الياباني',
    'CHF': 'الفرنك السويسري',
    'CNY': 'اليوان الصيني',
    'INR': 'الروبية الهندية',
    'AUD': 'الدولار الأسترالي',
    'CAD': 'الدولار الكندي',
    'NZD': 'الدولار النيوزيلندي',
    // Asia
    'KRW': 'الون الكوري الجنوبي',
    'THB': 'البات التايلاندي',
    'MYR': 'الرينغيت الماليزي',
    'SGD': 'الدولار السنغافوري',
    'PHP': 'البيزو الفلبيني',
    'IDR': 'الروبية الإندونيسية',
    'PKR': 'الروبية الباكستانية',
    'BDT': 'التاكا البنغالي',
    'LKR': 'الروبية السريلانكية',
    'KHR': 'الريال الكمبودي',
    'LAK': 'الكيب اللاوسي',
    'MMK': 'الكيات الميانماري',
    'HKD': 'الدولار الهونغ كونغي',
    'TWD': 'الدولار التايواني الجديد',
    'MOP': 'باتاكا ماكاو',
    'KGS': 'السوم القيرغيزي',
    'UZS': 'السوم الأوزبكي',
    'TJS': 'السوموني الطاجيكي',
    'TMT': 'المنات التركماني',
    'AZN': 'المانات الأذربيجاني',
    'CNH': 'اليوان الصيني (خارجي)',
    // ME/Gulf
    'IQD': 'الدينار العراقي',
    'IRR': 'الريال الإيراني',
    'JOD': 'الدينار الأردني',
    'KWD': 'الدينار الكويتي',
    'OMR': 'الريال العماني',
    'QAR': 'الريال القطري',
    'SAR': 'الريال السعودي',
    'AED': 'الدرهم الإماراتي',
    'BHD': 'الدينار البحريني',
    'VND': 'الدونغ الفيتنامي',
    // Americas
    'MXN': 'البيزو المكسيكي',
    'BRL': 'الريال البرازيلي',
    'ARS': 'البيزو الأرجنتيني',
    'CLF': 'وحدة الحساب التشيلية',
    'CLP': 'البيزو التشيلي',
    'COP': 'البيزو الكولومبي',
    'PEN': 'السول البيروفي',
    'UYU': 'البيزو الأوروغواياني',
    'VES': 'البوليفار الفنزويلي',
    'BOB': 'البوليفيانو البوليفي',
    'PYG': 'الغواراني الباراغوايي',
    'GTQ': 'الكيتزال الغواتيمالي',
    'HNL': 'الليمبيرا الهندوراسية',
    'NIO': 'الكوردوبا النيكاراغوي',
    'CRC': 'الكولون الكوستاريكي',
    'PAB': 'البالبوا البنمي',
    'JMD': 'الدولار الجامايكي',
    'TTD': 'دولار ترينيداد وتوباغو',
    'BSD': 'الدولار البهامي',
    'BBD': 'دولار بربادوسي',
    'GYD': 'الدولار الغياني',
    'SRD': 'الدولار السورينامي',
    'CUP': 'البيزو الكوبي',
    'HTG': 'الغوردة الهايتية',
    // Europe
    'SEK': 'الكرونة السويدية',
    'NOK': 'الكرونة النرويجية',
    'DKK': 'الكرونة الدنماركية',
    'ISK': 'الكرونة الآيسلندية',
    'PLN': 'الزلوتي البولندي',
    'CZK': 'الكرونة التشيكية',
    'HUF': 'الفورنت المجري',
    'RON': 'الليو الروماني',
    'BGN': 'الليف البلغاري',
    'HRK': 'الكونا الكرواتية',
    'RSD': 'الدينار الصربي',
    'BAM': 'المارك البوسني القابل للتحويل',
    'ALL': 'الليك الألباني',
    'MDL': 'الليو المولدوفي',
    'UAH': 'الهريفنيا الأوكرانية',
    'RUB': 'الروبل الروسي',
    'BYN': 'الروبل البيلاروسي',
    // Africa
    'ZAR': 'الراند الجنوب أفريقي',
    'EGP': 'الجنيه المصري',
    'NGN': 'النيرة النيجيرية',
    'GHS': 'السيدي الغاني',
    'KES': 'الشلن الكيني',
    'UGX': 'الشلن الأوغندي',
    'TZS': 'الشلن التنزاني',
    'ETB': 'البر الإثيوبي',
    'MAD': 'الدرهم المغربي',
    'TND': 'الدينار التونسي',
    'DZD': 'الدينار الجزائري',
    'LYD': 'الدينار الليبي',
    'SDG': 'الجنيه السوداني',
    'GMD': 'الدالاسي الغامبي',
    'SOS': 'الشلن الصومالي',
    'MUR': 'الروبية الموريشيوسية',
    'SCR': 'الروبية السيشلية',
    'MGA': 'الأرياري الملغاشي',
    'MWK': 'الكواشا المالاوية',
    'ZMW': 'الكواشا الزامبية',
    'ZWL': 'الدولار الزيمبابوي',
    'BWP': 'البولا البوتسوانية',
    'NAD': 'الدولار الناميبي',
    'LSL': 'اللوطي اللسوتي',
    'SZL': 'الللانجيني الإسواتيني',
    'RWF': 'الفرنك الرواندي',
    'BIF': 'الفرنك البوروندي',
    'DJF': 'الفرنك الجيبوتي',
    'KMF': 'الفرنك القمري',
    'ERN': 'الناكفا الإريتري',
    'GNF': 'الفرنك الغيني',
    'AOA': 'الكوانزا الأنغولي',
    // Oceania
    'FJD': 'الدولار الفيجيني',
    'PGK': 'الكينا البابوا غينية',
    'SBD': 'دولار جزر سليمان',
    'TOP': 'بانغا تونغا',
    'WST': 'تالا ساموا',
    'VUV': 'الفاتو الفانواتي',
    'KID': 'الدولار الكيريباتي',
    'TVD': 'الدولار التوفالي',
    // Special
    'XAF': 'فرنك إفريقيا الوسطى (CFA)',
    'XCD': 'دولار شرق الكاريبي',
    'XCG': 'كريبتو غولد',
    'XDR': 'حقوق السحب الخاصة',
    'XOF': 'فرنك غرب إفريقيا (CFA)',
    'XPF': 'فرنك المحيط الهادئ (CFP)',
    'ZWG': 'الذهب الزيمبابوي',
  };

  final Map<String, String> _countryNamesAr = {
    'USD': 'الولايات المتحدة الأمريكية',
    'EUR': 'الاتحاد الأوروبي',
    'GBP': 'المملكة المتحدة',
    'JPY': 'اليابان',
    'CHF': 'سويسرا',
    'CNY': 'الصين',
    'INR': 'الهند',
    'AUD': 'أستراليا',
    'CAD': 'كندا',
    'NZD': 'نيوزيلندا',
    // Asia
    'KRW': 'كوريا الجنوبية',
    'THB': 'تايلاند',
    'MYR': 'ماليزيا',
    'SGD': 'سنغافورة',
    'PHP': 'الفلبين',
    'IDR': 'إندونيسيا',
    'PKR': 'باكستان',
    'BDT': 'بنغلاديش',
    'LKR': 'سريلانكا',
    'KHR': 'كمبوديا',
    'LAK': 'لاوس',
    'MMK': 'ميانمار',
    'HKD': 'هونغ كونغ',
    'TWD': 'تايوان',
    'MOP': 'ماكاو',
    'KGS': 'قيرغيزستان',
    'UZS': 'أوزبكستان',
    'TJS': 'طاجيكستان',
    'TMT': 'تركمانستان',
    'AZN': 'أذربيجان',
    'CNH': 'الصين (خارجي)',
    // ME/Gulf
    'IQD': 'العراق',
    'IRR': 'إيران',
    'JOD': 'الأردن',
    'KWD': 'الكويت',
    'OMR': 'عُمان',
    'QAR': 'قطر',
    'SAR': 'السعودية',
    'AED': 'الإمارات',
    'BHD': 'البحرين',
    'VND': 'فيتنام',
    // Americas
    'MXN': 'المكسيك',
    'BRL': 'البرازيل',
    'ARS': 'الأرجنتين',
    'CLF': 'تشيلي',
    'CLP': 'تشيلي',
    'COP': 'كولومبيا',
    'PEN': 'بيرو',
    'UYU': 'أوروغواي',
    'VES': 'فنزويلا',
    'BOB': 'بوليفيا',
    'PYG': 'باراغواي',
    'GTQ': 'غواتيمالا',
    'HNL': 'هندوراس',
    'NIO': 'نيكاراغوا',
    'CRC': 'كوستاريكا',
    'PAB': 'بنما',
    'JMD': 'جامايكا',
    'TTD': 'ترينيداد وتوباغو',
    'BSD': 'جزر البهاما',
    'BBD': 'بربادوس',
    'GYD': 'غيانا',
    'SRD': 'سورينام',
    'CUP': 'كوبا',
    'HTG': 'هايتي',
    // Europe
    'SEK': 'السويد',
    'NOK': 'النرويج',
    'DKK': 'الدنمارك',
    'ISK': 'آيسلندا',
    'PLN': 'بولندا',
    'CZK': 'جمهورية التشيك',
    'HUF': 'المجر',
    'RON': 'رومانيا',
    'BGN': 'بلغاريا',
    'HRK': 'كرواتيا',
    'RSD': 'صربيا',
    'BAM': 'البوسنة والهرسك',
    'ALL': 'ألبانيا',
    'MDL': 'مولدوفا',
    'UAH': 'أوكرانيا',
    'RUB': 'روسيا',
    'BYN': 'بيلاروسيا',
    // Africa
    'ZAR': 'جنوب أفريقيا',
    'EGP': 'مصر',
    'NGN': 'نيجيريا',
    'GHS': 'غانا',
    'KES': 'كينيا',
    'UGX': 'أوغندا',
    'TZS': 'تنزانيا',
    'ETB': 'إثيوبيا',
    'MAD': 'المغرب',
    'TND': 'تونس',
    'DZD': 'الجزائر',
    'LYD': 'ليبيا',
    'SDG': 'السودان',
    'GMD': 'غامبيا',
    'SOS': 'الصومال',
    'MUR': 'موريشيوس',
    'SCR': 'سيشل',
    'MGA': 'مدغشقر',
    'MWK': 'مالاوي',
    'ZMW': 'زامبيا',
    'ZWL': 'زيمبابوي',
    'BWP': 'بوتسوانا',
    'NAD': 'ناميبيا',
    'LSL': 'ليسوتو',
    'SZL': 'إسواتيني',
    'RWF': 'رواندا',
    'BIF': 'بوروندي',
    'DJF': 'جيبوتي',
    'KMF': 'جزر القمر',
    'ERN': 'إريتريا',
    'GNF': 'غينيا',
    'AOA': 'أنغولا',
    // Oceania
    'FJD': 'فيجي',
    'PGK': 'بابوا غينيا الجديدة',
    'SBD': 'جزر سليمان',
    'TOP': 'تونغا',
    'WST': 'ساموا',
    'VUV': 'فانواتو',
    'KID': 'كيريباتي',
    'TVD': 'توفالو',
    // Special
    'XAF': 'دول وسط أفريقيا (CEMAC)',
    'XCD': 'منظمة دول شرق الكاريبي',
    'XCG': 'عملة رقمية',
    'XDR': 'صندوق النقد الدولي',
    'XOF': 'دول غرب أفريقيا (CFA)',
    'XPF': 'الأقاليم الفرنسية ما وراء البحار',
    'ZWG': 'زيمبابوي',
  };

  String _localizedCurrencyName(String code) {
    final name = _currencies[code]?['name'] as String?;
    if (name == null) return code;
    if (widget.currentLanguage == 'ar') {
      return _currencyNamesAr[code] ??
          Translations.getTranslation(widget.currentLanguage, name);
    }
    return name;
  }

  String _localizedCountryName(String code) {
    final country = _currencies[code]?['country'] as String?;
    if (country == null) return '';
    if (widget.currentLanguage == 'ar') {
      return _countryNamesAr[code] ??
          Translations.getTranslation(widget.currentLanguage, country);
    }
    return country;
  }

  String _getCountryFlag(String currencyCode) {
    return _countryFlags[currencyCode] ?? '🌍';
  }

  List<DropdownMenuItem<String>> _buildGroupedDropdownItems() {
    final items = <DropdownMenuItem<String>>[];

    _currencyRegions.forEach((region, currencies) {
      // Add region header
      items.add(
        DropdownMenuItem<String>(
          enabled: false,
          child: Text(
            Translations.getTranslation(widget.currentLanguage, region),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      );

      // Add currencies in this region
      for (final currency in currencies) {
        if (_currencies.containsKey(currency)) {
          items.add(
            DropdownMenuItem<String>(
              value: currency,
              child: Directionality(
                textDirection: Translations.isRTL(widget.currentLanguage)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Text(
                  '${_getCountryFlag(currency)} $currency - '
                  '${_localizedCurrencyName(currency)} '
                  '(${_localizedCountryName(currency)})',
                  softWrap: true,
                  maxLines: 3,
                ),
              ),
            ),
          );
        }
      }
    });

    return items;
  }

  // Region grouping for currencies
  final Map<String, List<String>> _currencyRegions = {
    '🌍 Popular': [
      'USD',
      'EUR',
      'GBP',
      'JPY',
      'CHF',
      'CNY',
      'INR',
      'AUD',
      'CAD'
    ],
    '🌏 Asia': [
      'KRW',
      'THB',
      'MYR',
      'SGD',
      'PHP',
      'IDR',
      'VND',
      'PKR',
      'BDT',
      'LKR',
      'KHR',
      'LAK',
      'MMK',
      'HKD',
      'TWD',
      'MOP',
      'KGS',
      'UZS',
      'TJS',
      'TMT',
      'AZN',
      'CNH',
      'IQD',
      'IRR',
      'JOD',
      'KWD',
      'OMR',
      'QAR',
      'SAR',
      'AED',
      'BHD'
    ],
    '🌎 Americas': [
      'MXN',
      'BRL',
      'ARS',
      'CLF',
      'CLP',
      'COP',
      'PEN',
      'UYU',
      'VES',
      'BOB',
      'PYG',
      'GTQ',
      'HNL',
      'NIO',
      'CRC',
      'PAB',
      'JMD',
      'TTD',
      'BSD',
      'BBD',
      'GYD',
      'SRD',
      'CUP',
      'HTG'
    ],
    '🌍 Europe': [
      'SEK',
      'NOK',
      'DKK',
      'ISK',
      'PLN',
      'CZK',
      'HUF',
      'RON',
      'BGN',
      'HRK',
      'RSD',
      'BAM',
      'ALL',
      'MDL',
      'UAH',
      'RUB',
      'BYN'
    ],
    '🌍 Africa': [
      'ZAR',
      'EGP',
      'NGN',
      'GHS',
      'KES',
      'UGX',
      'TZS',
      'ETB',
      'MAD',
      'TND',
      'DZD',
      'LYD',
      'SDG',
      'GMD',
      'SOS',
      'MUR',
      'SCR',
      'MGA',
      'MWK',
      'ZMW',
      'ZWL',
      'BWP',
      'NAD',
      'LSL',
      'SZL',
      'RWF',
      'BIF',
      'DJF',
      'KMF',
      'ERN',
      'GNF',
      'AOA'
    ],
    '🌏 Oceania': [
      'NZD',
      'FJD',
      'PGK',
      'SBD',
      'TOP',
      'WST',
      'VUV',
      'KID',
      'TVD'
    ],
    '💱 Special': ['XAF', 'XCD', 'XCG', 'XDR', 'XOF', 'XPF', 'ZWG'],
  };

  @override
  void initState() {
    super.initState();
    _fromCurrency = 'USD';
    _toCurrency = 'EUR';
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  // Note: These are example rates. In a real app, you'd fetch current rates from an API
  final Map<String, Map<String, dynamic>> _currencies = {
    'USD': {'name': 'US Dollar', 'country': 'United States', 'rate': 1.0},
    'EUR': {'name': 'Euro', 'country': 'European Union', 'rate': 0.92},
    'GBP': {'name': 'British Pound', 'country': 'United Kingdom', 'rate': 0.79},
    'JPY': {'name': 'Japanese Yen', 'country': 'Japan', 'rate': 150.27},
    'AUD': {'name': 'Australian Dollar', 'country': 'Australia', 'rate': 1.53},
    'CAD': {'name': 'Canadian Dollar', 'country': 'Canada', 'rate': 1.35},
    'CHF': {'name': 'Swiss Franc', 'country': 'Switzerland', 'rate': 0.88},
    'CNY': {'name': 'Chinese Yuan', 'country': 'China', 'rate': 7.20},
    'INR': {'name': 'Indian Rupee', 'country': 'India', 'rate': 82.89},
    'NZD': {
      'name': 'New Zealand Dollar',
      'country': 'New Zealand',
      'rate': 1.64
    },
    'AED': {
      'name': 'UAE Dirham',
      'country': 'United Arab Emirates',
      'rate': 3.67
    },
    'AFN': {'name': 'Afghan Afghani', 'country': 'Afghanistan', 'rate': 73.50},
    'ALL': {'name': 'Albanian Lek', 'country': 'Albania', 'rate': 95.80},
    'AMD': {'name': 'Armenian Dram', 'country': 'Armenia', 'rate': 386.50},
    'ANG': {
      'name': 'Netherlands Antillean Guilder',
      'country': 'Netherlands Antilles',
      'rate': 1.79
    },
    'AOA': {'name': 'Angolan Kwanza', 'country': 'Angola', 'rate': 825.00},
    'ARS': {'name': 'Argentine Peso', 'country': 'Argentina', 'rate': 870.00},
    'AWG': {'name': 'Aruban Florin', 'country': 'Aruba', 'rate': 1.80},
    'AZN': {'name': 'Azerbaijani Manat', 'country': 'Azerbaijan', 'rate': 1.70},
    'BAM': {
      'name': 'Bosnia-Herzegovina Convertible Mark',
      'country': 'Bosnia & Herzegovina',
      'rate': 1.80
    },
    'BBD': {'name': 'Barbadian Dollar', 'country': 'Barbados', 'rate': 2.00},
    'BDT': {
      'name': 'Bangladeshi Taka',
      'country': 'Bangladesh',
      'rate': 109.50
    },
    'BGN': {'name': 'Bulgarian Lev', 'country': 'Bulgaria', 'rate': 1.80},
    'BHD': {'name': 'Bahraini Dinar', 'country': 'Bahrain', 'rate': 0.38},
    'BIF': {'name': 'Burundian Franc', 'country': 'Burundi', 'rate': 2850.00},
    'BMD': {'name': 'Bermudan Dollar', 'country': 'Bermuda', 'rate': 1.00},
    'BND': {'name': 'Brunei Dollar', 'country': 'Brunei', 'rate': 1.35},
    'BOB': {'name': 'Bolivian Boliviano', 'country': 'Bolivia', 'rate': 6.91},
    'BRL': {'name': 'Brazilian Real', 'country': 'Brazil', 'rate': 5.40},
    'BSD': {'name': 'Bahamian Dollar', 'country': 'Bahamas', 'rate': 1.00},
    'BTN': {'name': 'Bhutanese Ngultrum', 'country': 'Bhutan', 'rate': 83.00},
    'BWP': {'name': 'Botswanan Pula', 'country': 'Botswana', 'rate': 13.50},
    'BYN': {'name': 'Belarusian Ruble', 'country': 'Belarus', 'rate': 3.20},
    'BZD': {'name': 'Belize Dollar', 'country': 'Belize', 'rate': 2.00},
    'CDF': {
      'name': 'Congolese Franc',
      'country': 'Democratic Republic of the Congo',
      'rate': 2500.00
    },
    'CLF': {
      'name': 'Chilean Unit of Account',
      'country': 'Chile',
      'rate': 35.00
    },
    'CLP': {'name': 'Chilean Peso', 'country': 'Chile', 'rate': 920.00},
    'CNH': {
      'name': 'Chinese Yuan (Offshore)',
      'country': 'China',
      'rate': 7.25
    },
    'COP': {'name': 'Colombian Peso', 'country': 'Colombia', 'rate': 3900.00},
    'CRC': {
      'name': 'Costa Rican Colón',
      'country': 'Costa Rica',
      'rate': 520.00
    },
    'CUP': {'name': 'Cuban Peso', 'country': 'Cuba', 'rate': 24.00},
    'CVE': {
      'name': 'Cape Verdean Escudo',
      'country': 'Cape Verde',
      'rate': 101.00
    },
    'CZK': {'name': 'Czech Koruna', 'country': 'Czech Republic', 'rate': 23.00},
    'DJF': {'name': 'Djiboutian Franc', 'country': 'Djibouti', 'rate': 178.00},
    'DKK': {'name': 'Danish Krone', 'country': 'Denmark', 'rate': 6.85},
    'DOP': {
      'name': 'Dominican Peso',
      'country': 'Dominican Republic',
      'rate': 58.50
    },
    'DZD': {'name': 'Algerian Dinar', 'country': 'Algeria', 'rate': 134.00},
    'EGP': {'name': 'Egyptian Pound', 'country': 'Egypt', 'rate': 47.00},
    'ERN': {'name': 'Eritrean Nakfa', 'country': 'Eritrea', 'rate': 15.00},
    'ETB': {'name': 'Ethiopian Birr', 'country': 'Ethiopia', 'rate': 56.00},
    'FJD': {'name': 'Fijian Dollar', 'country': 'Fiji', 'rate': 2.25},
    'FKP': {
      'name': 'Falkland Islands Pound',
      'country': 'Falkland Islands',
      'rate': 0.79
    },
    'FOK': {'name': 'Faroese Króna', 'country': 'Faroe Islands', 'rate': 6.85},
    'GEL': {'name': 'Georgian Lari', 'country': 'Georgia', 'rate': 2.70},
    'GGP': {'name': 'Guernsey Pound', 'country': 'Guernsey', 'rate': 0.79},
    'GHS': {'name': 'Ghanaian Cedi', 'country': 'Ghana', 'rate': 13.00},
    'GIP': {'name': 'Gibraltar Pound', 'country': 'Gibraltar', 'rate': 0.79},
    'GMD': {'name': 'Gambian Dalasi', 'country': 'Gambia', 'rate': 67.00},
    'GNF': {'name': 'Guinean Franc', 'country': 'Guinea', 'rate': 8600.00},
    'GTQ': {'name': 'Guatemalan Quetzal', 'country': 'Guatemala', 'rate': 7.80},
    'GYD': {'name': 'Guyanaese Dollar', 'country': 'Guyana', 'rate': 209.00},
    'HKD': {'name': 'Hong Kong Dollar', 'country': 'Hong Kong', 'rate': 7.80},
    'HNL': {'name': 'Honduran Lempira', 'country': 'Honduras', 'rate': 24.70},
    'HRK': {'name': 'Croatian Kuna', 'country': 'Croatia', 'rate': 7.00},
    'HTG': {'name': 'Haitian Gourde', 'country': 'Haiti', 'rate': 132.00},
    'HUF': {'name': 'Hungarian Forint', 'country': 'Hungary', 'rate': 360.00},
    'IDR': {
      'name': 'Indonesian Rupiah',
      'country': 'Indonesia',
      'rate': 15700.00
    },
    'IMP': {'name': 'Manx pound', 'country': 'Isle of Man', 'rate': 0.79},
    'IQD': {'name': 'Iraqi Dinar', 'country': 'Iraq', 'rate': 1310.00},
    'IRR': {'name': 'Iranian Rial', 'country': 'Iran', 'rate': 42000.00},
    'ISK': {'name': 'Icelandic Króna', 'country': 'Iceland', 'rate': 138.00},
    'JEP': {'name': 'Jersey Pound', 'country': 'Jersey', 'rate': 0.79},
    'JMD': {'name': 'Jamaican Dollar', 'country': 'Jamaica', 'rate': 155.00},
    'JOD': {'name': 'Jordanian Dinar', 'country': 'Jordan', 'rate': 0.71},
    'KES': {'name': 'Kenyan Shilling', 'country': 'Kenya', 'rate': 129.00},
    'KGS': {'name': 'Kyrgystani Som', 'country': 'Kyrgyzstan', 'rate': 89.00},
    'KHR': {'name': 'Cambodian Riel', 'country': 'Cambodia', 'rate': 4100.00},
    'KID': {'name': 'Kiribati Dollar', 'country': 'Kiribati', 'rate': 1.53},
    'KMF': {'name': 'Comorian Franc', 'country': 'Comoros', 'rate': 453.00},
    'KRW': {
      'name': 'South Korean Won',
      'country': 'South Korea',
      'rate': 1350.00
    },
    'KWD': {'name': 'Kuwaiti Dinar', 'country': 'Kuwait', 'rate': 0.31},
    'KYD': {
      'name': 'Cayman Islands Dollar',
      'country': 'Cayman Islands',
      'rate': 0.83
    },
    'KZT': {
      'name': 'Kazakhstani Tenge',
      'country': 'Kazakhstan',
      'rate': 450.00
    },
    'LAK': {'name': 'Laotian Kip', 'country': 'Laos', 'rate': 20500.00},
    'LBP': {'name': 'Lebanese Pound', 'country': 'Lebanon', 'rate': 15000.00},
    'LKR': {'name': 'Sri Lankan Rupee', 'country': 'Sri Lanka', 'rate': 310.00},
    'LRD': {'name': 'Liberian Dollar', 'country': 'Liberia', 'rate': 190.00},
    'LSL': {'name': 'Lesotho Loti', 'country': 'Lesotho', 'rate': 18.50},
    'LYD': {'name': 'Libyan Dinar', 'country': 'Libya', 'rate': 4.80},
    'MAD': {'name': 'Moroccan Dirham', 'country': 'Morocco', 'rate': 10.00},
    'MDL': {'name': 'Moldovan Leu', 'country': 'Moldova', 'rate': 17.80},
    'MGA': {
      'name': 'Malagasy Ariary',
      'country': 'Madagascar',
      'rate': 4400.00
    },
    'MKD': {
      'name': 'Macedonian Denar',
      'country': 'North Macedonia',
      'rate': 57.00
    },
    'MMK': {'name': 'Myanmar Kyat', 'country': 'Myanmar', 'rate': 2100.00},
    'MNT': {'name': 'Mongolian Tugrik', 'country': 'Mongolia', 'rate': 3400.00},
    'MOP': {'name': 'Macanese Pataca', 'country': 'Macao', 'rate': 8.05},
    'MRU': {
      'name': 'Mauritanian Ouguiya',
      'country': 'Mauritania',
      'rate': 39.00
    },
    'MUR': {'name': 'Mauritian Rupee', 'country': 'Mauritius', 'rate': 45.50},
    'MVR': {'name': 'Maldivian Rufiyaa', 'country': 'Maldives', 'rate': 15.40},
    'MWK': {'name': 'Malawian Kwacha', 'country': 'Malawi', 'rate': 1650.00},
    'MXN': {'name': 'Mexican Peso', 'country': 'Mexico', 'rate': 16.80},
    'MYR': {'name': 'Malaysian Ringgit', 'country': 'Malaysia', 'rate': 4.70},
    'MZN': {
      'name': 'Mozambican Metical',
      'country': 'Mozambique',
      'rate': 63.50
    },
    'NAD': {'name': 'Namibian Dollar', 'country': 'Namibia', 'rate': 18.50},
    'NGN': {'name': 'Nigerian Naira', 'country': 'Nigeria', 'rate': 1450.00},
    'NIO': {
      'name': 'Nicaraguan Córdoba',
      'country': 'Nicaragua',
      'rate': 36.50
    },
    'NOK': {'name': 'Norwegian Krone', 'country': 'Norway', 'rate': 10.70},
    'NPR': {'name': 'Nepalese Rupee', 'country': 'Nepal', 'rate': 133.00},
    'OMR': {'name': 'Omani Rial', 'country': 'Oman', 'rate': 0.38},
    'PAB': {'name': 'Panamanian Balboa', 'country': 'Panama', 'rate': 1.00},
    'PEN': {'name': 'Peruvian Sol', 'country': 'Peru', 'rate': 3.70},
    'PGK': {
      'name': 'Papua New Guinean Kina',
      'country': 'Papua New Guinea',
      'rate': 3.70
    },
    'PHP': {'name': 'Philippine Peso', 'country': 'Philippines', 'rate': 56.50},
    'PKR': {'name': 'Pakistani Rupee', 'country': 'Pakistan', 'rate': 278.00},
    'PLN': {'name': 'Polish Złoty', 'country': 'Poland', 'rate': 3.95},
    'PYG': {
      'name': 'Paraguayan Guarani',
      'country': 'Paraguay',
      'rate': 7300.00
    },
    'QAR': {'name': 'Qatari Rial', 'country': 'Qatar', 'rate': 3.64},
    'RON': {'name': 'Romanian Leu', 'country': 'Romania', 'rate': 4.60},
    'RSD': {'name': 'Serbian Dinar', 'country': 'Serbia', 'rate': 108.00},
    'RUB': {'name': 'Russian Ruble', 'country': 'Russia', 'rate': 92.00},
    'RWF': {'name': 'Rwandan Franc', 'country': 'Rwanda', 'rate': 1250.00},
    'SAR': {'name': 'Saudi Riyal', 'country': 'Saudi Arabia', 'rate': 3.75},
    'SBD': {
      'name': 'Solomon Islands Dollar',
      'country': 'Solomon Islands',
      'rate': 8.40
    },
    'SCR': {
      'name': 'Seychellois Rupee',
      'country': 'Seychelles',
      'rate': 13.20
    },
    'SDG': {'name': 'Sudanese Pound', 'country': 'Sudan', 'rate': 600.00},
    'SEK': {'name': 'Swedish Krona', 'country': 'Sweden', 'rate': 10.50},
    'SGD': {'name': 'Singapore Dollar', 'country': 'Singapore', 'rate': 1.35},
    'SHP': {
      'name': 'Saint Helena Pound',
      'country': 'Saint Helena',
      'rate': 0.79
    },
    'SLE': {
      'name': 'Sierra Leonean Leone',
      'country': 'Sierra Leone',
      'rate': 22.50
    },
    'SLL': {
      'name': 'Sierra Leonean Leone (old)',
      'country': 'Sierra Leone',
      'rate': 19500.00
    },
    'SOS': {'name': 'Somali Shilling', 'country': 'Somalia', 'rate': 570.00},
    'SRD': {'name': 'Surinamese Dollar', 'country': 'Suriname', 'rate': 36.50},
    'SSP': {
      'name': 'South Sudanese Pound',
      'country': 'South Sudan',
      'rate': 990.00
    },
    'STN': {
      'name': 'São Tomé & Príncipe Dobra',
      'country': 'São Tomé & Príncipe',
      'rate': 22.70
    },
    'SYP': {'name': 'Syrian Pound', 'country': 'Syria', 'rate': 13000.00},
    'SZL': {'name': 'Swazi Lilangeni', 'country': 'Eswatini', 'rate': 18.50},
    'THB': {'name': 'Thai Baht', 'country': 'Thailand', 'rate': 35.80},
    'TJS': {
      'name': 'Tajikistani Somoni',
      'country': 'Tajikistan',
      'rate': 11.00
    },
    'TMT': {
      'name': 'Turkmenistani Manat',
      'country': 'Turkmenistan',
      'rate': 3.50
    },
    'TND': {'name': 'Tunisian Dinar', 'country': 'Tunisia', 'rate': 3.10},
    'TOP': {'name': 'Tongan Paʻanga', 'country': 'Tonga', 'rate': 2.40},
    'TRY': {'name': 'Turkish Lira', 'country': 'Turkey', 'rate': 32.00},
    'TTD': {
      'name': 'Trinidad & Tobago Dollar',
      'country': 'Trinidad & Tobago',
      'rate': 6.80
    },
    'TVD': {'name': 'Tuvaluan Dollar', 'country': 'Tuvalu', 'rate': 1.53},
    'TWD': {'name': 'New Taiwan Dollar', 'country': 'Taiwan', 'rate': 32.00},
    'TZS': {
      'name': 'Tanzanian Shilling',
      'country': 'Tanzania',
      'rate': 2550.00
    },
    'UAH': {'name': 'Ukrainian Hryvnia', 'country': 'Ukraine', 'rate': 39.50},
    'UGX': {'name': 'Ugandan Shilling', 'country': 'Uganda', 'rate': 3800.00},
    'UYU': {'name': 'Uruguayan Peso', 'country': 'Uruguay', 'rate': 39.00},
    'UZS': {
      'name': 'Uzbekistani Som',
      'country': 'Uzbekistan',
      'rate': 12500.00
    },
    'VES': {
      'name': 'Venezuelan Bolívar',
      'country': 'Venezuela',
      'rate': 36.50
    },
    'VND': {'name': 'Vietnamese Đồng', 'country': 'Vietnam', 'rate': 25000.00},
    'VUV': {'name': 'Vanuatu Vatu', 'country': 'Vanuatu', 'rate': 120.00},
    'WST': {'name': 'Samoan Tala', 'country': 'Samoa', 'rate': 2.75},
    'XAF': {
      'name': 'Central African CFA Franc',
      'country': 'CEMAC',
      'rate': 605.00
    },
    'XCD': {
      'name': 'East Caribbean Dollar',
      'country': 'Organisation of Eastern Caribbean States',
      'rate': 2.70
    },
    'XCG': {'name': 'Crypto Gold', 'country': 'Cryptocurrency', 'rate': 0.05},
    'XDR': {
      'name': 'Special Drawing Rights',
      'country': 'International Monetary Fund',
      'rate': 0.74
    },
    'XOF': {'name': 'West African CFA franc', 'country': 'CFA', 'rate': 605.00},
    'XPF': {
      'name': 'CFP Franc',
      'country': 'Collectivités d\'Outre-Mer',
      'rate': 110.00
    },
    'YER': {'name': 'Yemeni Rial', 'country': 'Yemen', 'rate': 250.00},
    'ZAR': {
      'name': 'South African Rand',
      'country': 'South Africa',
      'rate': 18.50
    },
    'ZMW': {'name': 'Zambian Kwacha', 'country': 'Zambia', 'rate': 26.00},
    'ZWL': {
      'name': 'Zimbabwean Dollar',
      'country': 'Zimbabwe',
      'rate': 9650.00
    },
    'ZWG': {'name': 'Zimbabwean Gold', 'country': 'Zimbabwe', 'rate': 1.0},
  };

  void _resetCalculator() {
    setState(() {
      _inputController.clear();
      _fromCurrency = 'USD';
      _toCurrency = 'EUR';
      _convertedValue = 0;
      _hasCalculated = false;
    });
  }

  void _convertCurrency() {
    if (_fromCurrency == null || _toCurrency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please select both currencies')),
        ),
      );
      return;
    }

    final inputValue = double.tryParse(_inputController.text);
    if (inputValue == null || inputValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please enter a valid amount')),
        ),
      );
      setState(() {
        _results = {};
        _hasCalculated = false;
      });
      return;
    }

    setState(() {
      // Convert to USD first (as base currency), then to target currency
      final inUSD = inputValue / _currencies[_fromCurrency]!['rate'];
      _convertedValue = inUSD * _currencies[_toCurrency]!['rate'];
      _results = {'converted': _convertedValue};
      _hasCalculated = true;
    });
  }

  Widget _buildAmountCard() {
    return UnifiedInputSection(
      title: Translations.getTranslation(widget.currentLanguage, 'Amount'),
      icon: Icons.attach_money,
      children: [
        UnifiedInputField(
          label: Translations.getTranslation(widget.currentLanguage, 'Amount'),
          hintText: Translations.getTranslation(
              widget.currentLanguage, 'enter_amount'),
          prefixIcon: Icons.attach_money,
          controller: _inputController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            setState(() {
              _hasCalculated = false;
              _results.clear();
            });
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return Translations.getTranslation(
                  widget.currentLanguage, 'Please enter a valid amount');
            }
            final parsed = double.tryParse(value.replaceAll(',', ''));
            if (parsed == null || parsed <= 0) {
              return Translations.getTranslation(widget.currentLanguage,
                  'Invalid input. Please enter a valid number.');
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFromCurrencyCard() {
    return UnifiedInputSection(
      title:
          Translations.getTranslation(widget.currentLanguage, 'From Currency'),
      icon: Icons.arrow_downward,
      children: [
        UnifiedDropdownField<String>(
          label: Translations.getTranslation(
              widget.currentLanguage, 'From Currency'),
          value: _fromCurrency,
          items: _buildGroupedDropdownItems(),
          onChanged: (value) {
            setState(() {
              _fromCurrency = value;
              _results.clear();
              _hasCalculated = false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildToCurrencyCard() {
    return UnifiedInputSection(
      title: Translations.getTranslation(widget.currentLanguage, 'To Currency'),
      icon: Icons.arrow_upward,
      children: [
        UnifiedDropdownField<String>(
          label: Translations.getTranslation(
              widget.currentLanguage, 'To Currency'),
          value: _toCurrency,
          items: _buildGroupedDropdownItems(),
          onChanged: (value) {
            setState(() {
              _toCurrency = value;
              _results.clear();
              _hasCalculated = false;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(
              widget.currentLanguage, 'Currency Converter'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCalculator,
            tooltip:
                Translations.getTranslation(widget.currentLanguage, 'Reset'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAmountCard(),
            const SizedBox(height: 16),
            _buildFromCurrencyCard(),
            const SizedBox(height: 16),
            _buildToCurrencyCard(),
            const SizedBox(height: 24),
            UnifiedPrimaryButton(
              text: Translations.getTranslation(
                  widget.currentLanguage, 'Convert'),
              icon: Icons.currency_exchange,
              onPressed: _convertCurrency,
            ),
            if (_hasCalculated && _results.isNotEmpty) ...[
              const SizedBox(height: 24),
              UnifiedResultCard(
                title: Translations.getTranslation(
                    widget.currentLanguage, 'Converted Amount'),
                value:
                    '${Translations.formatNumber(widget.currentLanguage, _convertedValue, decimalDigits: 2)} $_toCurrency',
                icon: Icons.calculate,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: UnifiedPageDesign.primaryColor.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Translations.getTranslation(widget.currentLanguage, 'Original')}: '
                      '${_inputController.text.isEmpty ? '' : Translations.formatNumber(widget.currentLanguage, double.tryParse(_inputController.text) ?? 0, decimalDigits: 2)} '
                      '$_fromCurrency',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Translations.getTranslation(widget.currentLanguage,
                          'Note: Exchange rates are for demonstration only'),
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
