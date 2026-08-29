# Calciverse

## المواصفات الشاملة للنسخة الحالية والنسخة النهائية المقترحة

---

# 1. تعريف المنتج

**Calciverse** هو تطبيق Utility متعدد الاستخدامات مبني باستخدام Flutter، هدفه جمع أدوات الحساب والتحويل والتاريخ والعملات والصحة والملفات في تطبيق واحد، مع تجربة موحدة وسريعة، ودعم كامل للعربية والإنجليزية.

الفكرة الأساسية ليست أن التطبيق يحتوي على عدد كبير من الأدوات فقط، وإنما أن كل الأدوات تعمل بنفس فلسفة الاستخدام:

**Input → Calculate/Convert → Result → Details → Actions**

أي أن المستخدم يدخل البيانات، يحصل على نتيجة واضحة، يرى التفاصيل عند الحاجة، ثم يستطيع نسخ النتيجة أو مشاركتها أو حفظها.

---

# 2. ما يميز Calciverse حاليًا

المشروع الحالي يمتلك بالفعل مجموعة نقاط قوية جدًا:

* Flutter متعدد المنصات.
* عربي + إنجليزي.
* RTL كامل.
* Dark / Light Mode.
* نظام تصميم موحد.
* 19 صفحة حاليًا.
* محولات وحدات متعددة.
* حاسبات عمر وتاريخ وصحة ونسب وضريبة.
* محول عملات بأكثر من 160 عملة.
* File Converter حقيقي يعتمد على CloudConvert.
* أكثر من 200 صيغة تحويل.
* نظام رصيد يومي للتحويلات.
* ترجمة كبيرة تشمل حتى الوحدات والعملات والدول والأخطاء.
* دعم تنسيق الأرقام والتواريخ بحسب اللغة.
* بنية كود واضحة نسبيًا.
* مكونات UI موحدة مثل:

  * UnifiedInputSection
  * UnifiedInputField
  * UnifiedDropdownField
  * UnifiedPrimaryButton
  * UnifiedResultCard

لذلك المطلوب ليس إعادة بناء التطبيق من الصفر، وإنما **توسيع الأساس الحالي وتحويله إلى منتج متكامل وناضج**.

---

# 3. الرؤية النهائية للتطبيق

في النسخة النهائية لا يكون Calciverse مجرد:

> Calculator + Converter

بل:

> **All-in-One Calculation, Conversion & Utility App**

ويتم تقسيمه وظيفيًا إلى:

1. Calculators
2. Unit Converters
3. Currency
4. Date & Time
5. Health
6. Finance
7. File Tools
8. Scan Tools
9. Everyday Tools
10. Personalization

---

# 4. بنية التطبيق النهائية

الـ Navigation الرئيسي المقترح:

### Home

المركز الرئيسي.

### Tools

جميع الأدوات مصنفة.

### Smart

البحث والحساب الذكي.

### History

كل العمليات السابقة.

### Favorites

الأدوات والعمليات المحفوظة.

### Settings

الإعدادات والخصوصية والتخصيص.

على الهاتف يكون هذا Bottom Navigation.

وعلى Tablet/Desktop يمكن تحويله إلى Navigation Rail أو Side Navigation.

---

# 5. الصفحة الرئيسية Home

## الهدف

Home ليست قائمة طويلة بجميع الأدوات.

هي صفحة وصول سريعة إلى أكثر ما يحتاجه المستخدم.

## ترتيبها

### Header

يظهر:

**Calciverse**

ثم وصف قصير:

> Calculate, Convert, Track & Transform.

أو بالعربية:

> احسب، حوّل، ونفّذ أدواتك اليومية من مكان واحد.

---

## Search / Smart Input

أهم عنصر بعد الـ Header.

حقل كبير:

> ماذا تريد أن تحسب أو تحوّل؟

ويعمل كـ:

* Search.
* Tool finder.
* Expression input.
* Universal Input.

---

# 6. قسم Quick Tools

يعرض الأدوات الأكثر استخدامًا.

في البداية يمكن أن يكون ترتيبًا افتراضيًا:

* Currency
* Calculator
* Age
* BMI
* Percentage
* VAT
* Length
* Weight

لكن بعد استخدام التطبيق يتغير الترتيب حسب الاستخدام.

مثلاً الأداة التي يستخدمها المستخدم باستمرار تنتقل تلقائيًا للأعلى.

---

# 7. قسم Recent Tools

يعرض آخر الأدوات التي استخدمها.

كل Card تحتوي على:

* اسم الأداة.
* الأيقونة.
* آخر استخدام.
* آخر مدخلات إن كانت بسيطة.
* زر فتح سريع.

الغرض هو عدم إجبار المستخدم على البحث عن نفس الأداة كل مرة.

---

# 8. Categories

بعد Quick Tools تظهر التصنيفات:

### Calculators

الحاسبات.

### Converters

محولات الوحدات.

### Finance

المالية.

### Health

الصحة.

### Date & Time

التاريخ والوقت.

### Currency

العملات.

### Files

الملفات.

### Scan

المسح.

### Everyday

الأدوات اليومية.

---

# 9. البحث العام Global Search

هذه إضافة أساسية.

عند دخول Search لا يبحث التطبيق فقط عن اسم الصفحة.

يبحث داخل:

* أسماء الأدوات.
* أسماء الوحدات.
* أسماء العملات.
* الكلمات العربية.
* الكلمات الإنجليزية.
* الاختصارات.
* العمليات الحسابية.
* Presets.
* Favorites.

ويجب أن يكون Search قادرًا على الوصول للأداة المناسبة حتى لو المستخدم لم يعرف اسمها الرسمي.

---

# 10. Universal Input

هذه الطبقة يجب أن تكون فوق جميع أدوات Calciverse.

وظيفتها التعرف على نوع طلب المستخدم.

المحرك يحدد:

* هل الطلب عملية حسابية؟
* تحويل وحدة؟
* تحويل عملة؟
* نسبة؟
* ضريبة؟
* تاريخ؟
* مدة؟
* أداة معينة؟

ثم ينفذ الطلب أو يفتح الأداة المناسبة مع تعبئة المدخلات تلقائيًا.

---

# 11. Smart Page

يكون هناك قسم مستقل:

# Smart

الغرض منه:

> اكتب ما تريد، وCalciverse يحدد الأداة المناسبة.

الواجهة:

### Input

حقل كبير.

### Parsed Result

يعرض النظام ماذا فهم.

### Result

النتيجة.

### Open Tool

لفتح الأداة الرسمية المستخدمة.

### Copy

### Save

### Share

---

# 12. Smart Calculator

يجب أن يكون أكثر من Calculator تقليدية.

يشمل:

* Arithmetic.
* Percentages.
* Unit conversions.
* Currency conversions.
* Date operations.
* Basic financial calculations.

وهو المدخل السريع للتطبيق.

---

# 13. Scientific Calculator

إضافة مستقلة.

تحتوي على:

* جمع.
* طرح.
* ضرب.
* قسمة.
* أقواس.
* أسس.
* جذر.
* Pi.
* e.
* Factorial.
* Percentage.
* sin.
* cos.
* tan.
* inverse trigonometry.
* log.
* ln.
* exp.

مع اختيار:

### Degrees

### Radians

---

# 14. Calculator Memory

Scientific Calculator تدعم:

* MC
* MR
* M+
* M-
* MS

وتحتوي على History خاص بالعمليات الحسابية.

---

# 15. صفحة History

يجب أن تكون الصفحة شاملة لكل التطبيق.

بدل وجود History منفصل لكل أداة فقط.

كل سجل يحتوي على:

* Tool.
* Date.
* Time.
* Input.
* Result.

مثلاً في الواجهة تظهر العملية والنتيجة بشكل مختصر.

عند الضغط:

يفتح التفاصيل الكاملة.

---

# 16. History Actions

كل عنصر History يستطيع المستخدم:

* فتح العملية.
* إعادة استخدامها.
* نسخ النتيجة.
* مشاركتها.
* حفظها كمفضلة.
* حذفه.

وفي أعلى الصفحة:

### Search

### Filter

### Clear All

---

# 17. Favorites

قسم مستقل.

هناك نوعان:

## Favorite Tools

الأدوات التي يضيفها المستخدم للمفضلة.

## Saved Calculations

عمليات كاملة قام المستخدم بحفظها.

ويجب أن يكون الوصول لها سريعًا جدًا من Home.

---

# 18. Presets

Presets مهمة جدًا في Calciverse.

الغرض هو حفظ البيانات التي تتكرر.

Preset يمكن أن يحتوي على:

* قيم.
* وحدات.
* عملات.
* بيانات شخصية.
* إعدادات.

ثم يمكن إعادة استعماله داخل الأداة.

---

# 19. Custom Units

ميزة متقدمة.

يسمح للمستخدم بإنشاء وحدة مخصصة عندما تكون العلاقة بالوحدة الأساسية قابلة للتمثيل بتحويل معروف.

كل Custom Unit تحتوي على:

* Name.
* Symbol.
* Base Unit.
* Conversion factor.
* Optional description.

وتظهر في:

**My Units**

---

# 20. قسم Unit Converters

كل محولات الوحدات يجب أن تستخدم نفس التصميم.

الشكل:

### From

Value
Unit

ثم:

### ⇄ Swap

ثم:

### To

Value
Unit

ثم:

### Result

مع:

Copy
Share
Favorite

---

# 21. Length Converter الحالي

يحتوي على:

* Millimeter.
* Centimeter.
* Meter.
* Kilometer.
* Inch.
* Foot.
* Yard.
* Mile.
* Nautical Mile.

يجب الحفاظ عليه كما هو، مع إضافة:

* Search.
* Favorite Units.
* Recent Units.
* Swap.
* Copy.
* Share.
* Precision control.

---

# 22. Area Converter الحالي

الوحدات الحالية تشمل:

* Square Meter.
* Hectare.
* Square Foot.
* Square Kilometer.
* Square Mile.
* Acre.
* Qirat.
* Donum.
* وغيرها.

التحسين المطلوب:

### Unit Information

عند اختيار وحدة غير شائعة يمكن إظهار تعريف مختصر لها.

لأن بعض الوحدات المحلية قد يكون معناها أو استخدامها مختلفًا حسب المنطقة.

---

# 23. Weight & Mass الحالي

يشمل:

* Milligram.
* Gram.
* Kilogram.
* Metric Ton.
* Ounce.
* Pound.
* Stone.
* US Ton.
* Imperial Ton.

ويجب الحفاظ على الفصل الواضح بين الوحدات المتشابهة.

---

# 24. Volume الحالي

يشمل:

* ml.
* L.
* cm³.
* m³.
* Fluid Ounce.
* Cup.
* Pint.
* Quart.
* US Gallon.
* Imperial Gallon.

من المهم إظهار:

**US** و **Imperial**

بشكل واضح وعدم وضعهما تحت اسم "Gallon" فقط.

---

# 25. Temperature الحالي

يدعم:

* Celsius.
* Fahrenheit.
* Kelvin.
* Rankine.

وهذا ممتاز بالفعل.

يجب فقط تحسين:

* Swap.
* Precision.
* Unit search.
* Formula explanation.

---

# 26. Time Converter الحالي

يدعم:

* Millisecond.
* Second.
* Minute.
* Hour.
* Day.
* Week.
* Month.
* Year.
* Decade.
* Century.

لكن هناك نقطة تقنية مهمة:

**الشهر والسنة ليسا دائمًا وحدتين ثابتتين عند التعامل مع تاريخ فعلي.**

لذلك يجب أن يكون Time Converter مسؤولًا عن التحويلات التقريبية أو المحددة بحسب النظام، بينما العمليات التي تعتمد على تاريخ حقيقي يجب أن تمر من Date Engine.

---

# 27. Data Converter الحالي

يدعم من Bit حتى وحدات ضخمة مثل Yottabyte.

التحسين المهم:

تمييز:

### Decimal

KB = 1000 bytes

عن:

### Binary

KiB = 1024 bytes

ويفضل أن تظهر الوحدات مثل:

KB / MB / GB

و:

KiB / MiB / GiB

بوضوح.

---

# 28. محولات علمية جديدة

أضيف إلى Calciverse قسم:

# Advanced Converters

---

## Speed

الوحدات:

* m/s
* km/h
* mph
* knots

---

## Pressure

* Pa
* kPa
* MPa
* bar
* atm
* psi
* mmHg

---

## Energy

* Joule
* Kilojoule
* Calorie
* Kilocalorie
* Wh
* kWh
* BTU

---

## Power

* Watt
* Kilowatt
* Megawatt
* Horsepower

---

## Force

* Newton
* Kilonewton
* Pound-force

---

## Frequency

* Hz
* kHz
* MHz
* GHz

---

## Angle

* Degree
* Radian
* Gradian

---

## Torque

* N·m
* lb·ft

---

## Density

* kg/m³
* g/cm³
* lb/ft³

---

## Fuel Economy

* L/100 km
* km/L
* MPG

مع التنبيه أن تحويلات استهلاك الوقود ليست مجرد عامل ضرب ثابت في الاتجاهين.

---

# 29. Cooking Converter

صفحة:

# Cooking

تدعم:

* Cups.
* Tablespoons.
* Teaspoons.
* ml.
* Liters.
* Ounces.
* Grams.

الأفضل أن يكون هناك اختيار للمادة في حالة التحويل بين الحجم والوزن.

مثل:

Flour
Sugar
Rice
Water
Milk

وذلك لأن الحجم لا يساوي وزنًا ثابتًا لجميع المواد.

---

# 30. Age Calculator الحالي

الأداة الحالية جيدة، لكن النسخة النهائية يجب أن تحتوي على:

## Inputs

* Birth Date.
* Optional Birth Time.
* Calculation Date.
* Calculation Time.

---

## Main Result

العمر الحالي:

* Years.
* Months.
* Days.

---

## Detailed Result

* Total Days.
* Total Weeks.
* Total Hours.
* Total Minutes.

والثواني يمكن جعلها اختيارية لأنها تتغير باستمرار.

---

## Next Birthday

يعرض:

* Date.
* Day.
* Remaining Duration.
* Age at next birthday.

---

# 31. Age Difference الحالي

يدخل المستخدم:

Person A Birth Date

و:

Person B Birth Date

ثم تظهر:

* Age Difference.
* Years.
* Months.
* Days.
* Total Days.

مع زر:

**Swap**

لتبديل الشخصين.

---

# 32. Duration Calculator الحالي

يدخل:

Start Date
Start Time

End Date
End Time

ثم تعرض:

* Days.
* Hours.
* Minutes.
* Seconds.
* Total Hours.
* Total Minutes.

ويجب أيضًا توفير:

### Include Start / Exclude Start

للحالات التي يكون فيها الفرق بين الأحداث والتواريخ حساسًا للعد الشامل أو غير الشامل.

---

# 33. Add / Subtract Date

إضافة جديدة مهمة جدًا.

المستخدم يحدد:

Date

ثم:

Add / Subtract

ثم:

* Years.
* Months.
* Weeks.
* Days.
* Hours.
* Minutes.

والنتيجة:

**Calculated Date**

---

# 34. Business Days Calculator

صفحة إضافية.

المستخدم يحدد:

Start Date
End Date

ثم يحدد:

Working Days

مثل:

* Sunday–Thursday.
* Monday–Friday.

مع إمكانية تحديد Holidays.

النتيجة:

* Calendar Days.
* Working Days.
* Weekend Days.
* Holidays.

---

# 35. Event Countdown الحالي

النسخة الحالية تعتمد على:

Name
Date

يجب تطويرها لتدعم:

* Date.
* Time.
* Event icon.
* Repeat.
* Notifications.
* Edit.
* Pause/Resume.
* Delete.

---

# 36. Countdown List

بدل عداد واحد فقط.

المستخدم يستطيع إنشاء عدة عدادات:

Birthday
Exam
Trip
Wedding
Project Deadline

وكل واحد يظهر في Card مستقل.

---

# 37. Countdown Notifications

يستطيع المستخدم اختيار:

* Notify on event.
* Notify before event.
* Multiple reminders.

مع احترام إعدادات النظام.

---

# 38. Zodiac الحالي

الأداة تقوم بـ:

Birth Date → Zodiac Sign

ويجب تنظيمها إلى:

### Zodiac Information

* Sign name.
* Date range.
* Symbol.
* Description.

والأفضل أن تكون الشخصية والوصف مصنفة باعتبارها **محتوى ترفيهيًا** وليست تشخيصًا أو استنتاجًا علميًا للشخصية.

---

# 39. BMI الحالي

المدخلات:

* Height.
* Weight.

مع:

Metric
Imperial

النتيجة:

### BMI

### Classification

### Healthy Range

### Weight Range

ويجب أن يظهر disclaimer صحي واضح لأن BMI مؤشر تقديري وليس تشخيصًا طبيًا.

---

# 40. تحسين BMI

بعد ظهور النتيجة يمكن تقديم:

### Related Tools

Calculate BMR
Calculate TDEE
Calculate Calories

وبذلك يصبح Health workflow مترابطًا.

---

# 41. Calorie Calculator الحالي

المدخلات:

* Sex.
* Age.
* Weight.
* Height.
* Activity Level.
* BMR Formula.

ثم:

### BMR

### Daily Calories

### Goal

* Maintain.
* Lose.
* Gain.

---

# 42. تطوير Health Suite

بدل أن تكون Calorie Calculator أداة منفصلة، يصبح قسم Health متكاملًا:

### BMI

### BMR

### TDEE

### Calories

### Macros

---

# 43. Macro Calculator

أداة جديدة.

المدخلات الأساسية تعتمد على السعرات المستهدفة وهدف المستخدم.

النتائج:

* Calories.
* Protein.
* Carbohydrates.
* Fat.

ويجب تقديمها كحسابات تقديرية وليست توصيات طبية.

---

# 44. Percentage Calculator الحالي

لا تجعلها شاشة واحدة فقط.

تقسم إلى Modes:

### Percentage of Value

### Percentage Increase

### Percentage Decrease

### Percentage Difference

### Discount

### Markup

وكل Mode يغير الحقول حسب العملية.

---

# 45. Tax Calculator الحالي

حاليًا لديه:

* Salary Tax.
* Product Tax.
* Reverse Tax.

وهذا ممتاز.

لكن يجب تحسين الواجهة إلى:

### Tax on Price

Price
Tax Rate

→ Net / Tax / Gross

### Reverse Tax

Final Price
Tax Rate

→ Original Price / Tax

### Salary Tax

Gross Salary
Tax Rate / deductions

→ Net Salary.

مهم أن تكون Salary Tax عامة وليست مدعية أنها تمثل قانون دولة معينة إلا إذا تم تعريف النظام الضريبي لتلك الدولة بشكل رسمي.

---

# 46. Currency Converter الحالي

هذه بالفعل واحدة من أقوى صفحات المشروع.

حاليًا:

* 160+ عملة.
* Flag.
* Code.
* Name.
* Country.
* Regions.
* Arabic translations.
* English translations.
* Demo rates.

الواجهة النهائية يجب أن تحافظ على هذه القوة.

---

# 47. Currency Search

يكون البحث قادرًا على:

* Currency name.
* Country name.
* Currency code.
* Arabic name.
* English name.

ويجب عدم الاعتماد على اسم العملة فقط.

---

# 48. Currency Favorites

المستخدم يحدد العملات التي يستخدمها باستمرار.

مثل:

Primary Currency
Favorite Currencies

وتظهر في بداية القائمة.

---

# 49. Multi-Currency

إضافة مهمة:

بدل اختيار عملة واحدة للهدف، يسمح للمستخدم بعرض مبلغ واحد في عدة عملات في نفس الوقت.

مثلاً:

Amount

ثم قائمة عملات.

فتظهر نتائج متعددة.

---

# 50. Currency Dashboard

يظهر:

* Current stored rate.
* Last updated.
* Rate source.
* Cached status.

وفي حال كانت الأسعار Demo حاليًا:

يجب **عدم تسمية النتيجة Live Rate**.

تكون الواجهة صريحة:

> Demo rate

أو:

> Sample rate

إلى أن يتم ربط API فعلي.

---

# 51. Real Currency API

الإضافة المستقبلية يجب أن تكون:

Rate Provider Layer

بحيث يمكن تغيير مزود الأسعار بدون تعديل صفحة Currency نفسها.

المكونات:

Currency API
↓
Normalization
↓
Cache
↓
Currency Engine
↓
UI

---

# 52. Offline Currency

إذا لم يوجد Internet:

يستخدم التطبيق آخر أسعار محفوظة فعليًا.

ويظهر:

> Using cached rates

مع وقت آخر تحديث.

---

# 53. أهم مشكلة تقنية حاليًا: API Key

عندك:

`.env`

وفيه:

`CLOUDCONVERT_API_KEY`

هذا جيد في التطوير، لكنه **ليس حماية حقيقية للمفتاح داخل تطبيق Flutter الموزع**.

عند Build للتطبيق، أي Secret موجود في Client يمكن استخراجه بدرجات مختلفة، وبالأخص تطبيقات Web تكون أكثر وضوحًا في هذا الجانب.

لذلك النسخة الإنتاجية الأفضل تكون:

**Flutter App → Your Backend / Proxy → CloudConvert**

بدل:

**Flutter App → CloudConvert مباشرة باستخدام Secret Key**

الخادم يحتفظ بالـ API Key الحقيقي.

---

# 54. File Converter الحالي

هذه بالفعل ميزة رئيسية ويجب التعامل معها كمنتج داخل التطبيق.

الواجهة المثالية:

### Select File

المستخدم يختار الملف.

ثم تظهر:

* File Name.
* File Type.
* File Size.

ثم:

### Convert To

قائمة الصيغ المتاحة.

ثم:

### Convert

---

# 55. Conversion Progress

أثناء العملية:

* Uploading.
* Processing.
* Finalizing.
* Completed.

مع Progress Bar.

ولا تجعل النسبة وحدها هي المعلومة الوحيدة؛ الحالة الحالية مهمة جدًا.

---

# 56. File Converter Credit System

حاليًا:

10 conversions/day.

يجب إظهارها بشكل واضح:

### Daily Credits

`7 / 10 remaining`

مع:

Reset Time.

ولا تجعل المستخدم يكتشف limit بعد اختيار الملف.

---

# 57. Credit Handling

يجب ألا يتم خصم Conversion Credit عند مجرد الضغط على Convert.

بل عند بدء عملية صالحة وفق السياسة المحددة.

ويجب التعامل مع:

* Failed upload.
* Failed conversion.
* Network timeout.
* API error.

بشكل عادل.

---

# 58. File Conversion Categories

الحالي ممتاز:

### Audio

MP3
WAV
FLAC
AAC
M4A
WMA
OGA

### Video

MP4
MKV
AVI
MOV
WebM
FLV
3GP

### Image

PNG
JPG
WebP
BMP
HEIC
TIFF
GIF
PSD
SVG
ICO

### Documents

PDF
DOCX
XLSX
PPTX
ODT
RTF
HTML
TXT
CSV

### Books

EPUB
MOBI
AZW3

### Archives

ZIP
7Z
TAR
RAR
GZ

### Fonts

TTF
OTF
WOFF
WOFF2
EOT

---

# 59. File Search

نظرًا لأن لديك 200+ صيغة، لا تضعها كلها في Dropdown واحد فقط.

يجب أن يوجد:

### Search Format

مع:

* Format.
* Category.
* Description.

ويستطيع المستخدم كتابة:

PDF

أو:

Word

أو:

Audio

---

# 60. Format Information

عند تحديد نوع التحويل، يمكن عرض:

**From: DOCX**

**To: PDF**

مع وصف مختصر.

وهذا يمنع اللبس.

---

# 61. Conversion History

كل عملية ناجحة أو فاشلة يمكن تسجيلها:

* File name.
* From format.
* To format.
* Date.
* Status.

ويمكن للمستخدم إعادة التحويل أو فتح النتيجة.

---

# 62. File Results

عند النجاح:

### Conversion Complete

ثم:

Download

Share

Open

Delete Temporary File

ويجب إظهار انتهاء الرابط إذا كان الرابط مؤقتًا.

---

# 63. File Privacy

هذه نقطة ضرورية جدًا بسبب CloudConvert.

يجب أن تكون واجهة File Converter شفافة:

> Files are processed using cloud conversion services.

وليست:

> Everything stays on your device

لأن ذلك غير صحيح في التحويل السحابي.

---

# 64. Image Tools

إضافة مهمة لـ File Tools.

### Image Converter

* JPG.
* PNG.
* WebP.
* HEIC.

### Image Resize

Width
Height
Maintain Aspect Ratio

### Compression

Quality
Target size إن أمكن.

### Rotate

### Crop

---

# 65. PDF Tools

قسم مستقل:

### Merge PDF

اختيار أكثر من PDF وترتيبها.

### Split PDF

تقسيم حسب الصفحات.

### Extract Pages

استخراج صفحات محددة.

### Rotate Pages

### PDF Compression

هذه ميزات مفيدة جدًا للمستخدم النهائي، لكن يجب التأكد من مكان تنفيذها ومن حدود الخدمة قبل الوعد بها.

---

# 66. OCR

إضافة:

# Scan Text

المستخدم:

Camera أو Gallery

ثم OCR.

النتيجة:

Editable Text

مع:

* Copy.
* Share.
* Save.
* Export TXT.
* Export PDF.

---

# 67. OCR Privacy

بوضوح شديد:

### On Device

إذا كان OCR محليًا.

أو:

### Cloud OCR

إذا كان يعتمد على Server.

ولا ينبغي استخدام عبارة "Private" أو "Offline" إلا إذا كانت صحيحة تقنيًا.

---

# 68. QR Tools

صفحة:

# QR & Scanner

تحتوي على:

### Scan QR

### Generate QR

---

# 69. QR Scanner

يتعرف على:

* URL.
* Text.
* Phone.
* Email.
* Wi-Fi.
* Contact.

بعد المسح لا تفتح الرابط فورًا.

اعرض:

### Scanned Content

ثم:

Open
Copy
Share

وهذا أكثر أمانًا.

---

# 70. QR Generator

يدعم:

* URL.
* Text.
* Wi-Fi.
* Contact.
* Email.
* Phone.

ثم:

Generate

وبعدها:

Save Image
Share

---

# 71. Barcode Scanner

إضافة منطقية.

يفتح نتيجة Barcode ويعرض البيانات الخام.

إذا لم توجد خدمة خارجية لمعرفة المنتج، لا تدّعي أنه سيعرض اسم المنتج أو السعر.

---

# 72. Finance Section

قسم جديد مستقل:

# Finance

يحتوي على:

* Loan.
* EMI.
* Interest.
* Compound Interest.
* Investment.
* ROI.
* Profit.
* Margin.
* Markup.
* Salary.
* Tip.
* Bill Split.
* Savings.

---

# 73. Loan Calculator

المدخلات:

* Principal.
* Interest Rate.
* Duration.
* Payment Frequency.

النتائج:

* Payment Amount.
* Total Payment.
* Total Interest.

ثم:

### Amortization Schedule

يظهر:

Period
Principal
Interest
Remaining Balance

---

# 74. EMI Calculator

صفحة مخصصة إذا كان مصطلح EMI مهمًا للسوق المستهدف.

النتيجة:

Monthly Payment
Total Interest
Total Amount

---

# 75. Simple Interest

المدخلات:

Principal
Rate
Duration

النتيجة:

Interest
Final Amount

---

# 76. Compound Interest

المدخلات:

Initial Amount
Contribution
Interest Rate
Compounding Frequency
Duration

النتائج:

Total Contribution
Interest Earned
Final Balance

---

# 77. Investment Calculator

يقبل:

Initial Investment
Periodic Contribution
Expected Return
Duration

ويعرض:

Contributed Amount
Estimated Growth
Estimated Final Value

ويجب توضيح أن العائد المدخل مجرد افتراض وليس ضمانًا.

---

# 78. ROI

المدخلات:

Initial Cost
Final Value

النتائج:

Profit
ROI %

مع إمكانية إضافة:

Expenses.

---

# 79. Profit / Margin / Markup

يجب الفصل بوضوح بين:

Cost
Selling Price
Profit
Margin
Markup

ويمكن أن تحتوي الصفحة على Modes واضحة.

---

# 80. Salary Calculator

المدخلات:

Gross Salary
Deductions
Tax
Other Contributions

النتيجة:

Net Salary

ويدعم:

Monthly
Yearly
Hourly

لكن بدون افتراض قواعد ضريبية لدولة معينة ما لم يتم تحديدها.

---

# 81. Tip & Bill Split

المدخلات:

Bill
Tip %
Number of People

النتائج:

Tip
Total
Per Person

مع إمكانية إضافة Tax.

---

# 82. Savings Goal

إضافة ممتازة:

المستخدم يحدد:

Target Amount
Current Savings
Periodic Contribution

ثم يحسب:

Time to Goal

أو:

Required Contribution.

---

# 83. Everyday Tools

قسم:

# Everyday

---

## Timer

* Hours.
* Minutes.
* Seconds.
* Start.
* Pause.
* Resume.
* Reset.

مع Notification عند الانتهاء.

---

# 84. Stopwatch

* Start.
* Pause.
* Resume.
* Lap.
* Reset.

مع حفظ Laps.

---

# 85. Counter

* Increase.
* Decrease.
* Reset.
* Target.

ويمكن إنشاء عدة Counters محفوظة.

---

# 86. Random Generator

يدعم:

Minimum
Maximum

مع خيارات:

* Single.
* Multiple.
* Unique results.

---

# 87. Dice

يدعم أنواع dice الشائعة، مع إمكانية تحديد عدد الرميات.

---

# 88. Coin Flip

أداة بسيطة:

Heads / Tails

مع History اختياري.

---

# 89. Time Zone

صفحة جديدة.

المستخدم يختار منطقتين زمنيتين.

يحدد الوقت.

تظهر:

* Time A.
* Time B.
* Date A.
* Date B.
* Time Difference.

ويجب الاعتماد على Time Zone database الفعلية وليس فرقًا ثابتًا.

---

# 90. Cross-tool Workflows

من أهم التحسينات.

الأدوات يجب أن تعرف بعضها.

مثلاً:

### BMI

يوفر انتقالًا إلى BMR/TDEE.

### Age

يوفر انتقالًا إلى Zodiac.

### Date Difference

يوفر إنشاء Countdown.

### OCR

يوفر Export to PDF.

### Image Converter

يوفر إنشاء PDF.

### Currency

يمكن الانتقال منه إلى Finance.

هذا يجعل Calciverse منصة مترابطة.

---

# 91. Universal Result Card

أنت بالفعل عندك:

`UnifiedResultCard`

وهذا ممتاز.

يجب توسيعه ليكون Component قياسيًا يحتوي على:

### Main Result

### Secondary Details

### Formula / Explanation

### Actions

* Copy.
* Share.
* Save.
* Favorite.

---

# 92. Copy Result

كل نتيجة لها:

### Copy Result

والأفضل إضافة:

### Copy Details

بحيث يقرر المستخدم هل يريد الرقم فقط أو العملية كاملة.

---

# 93. Share Result

نوعان:

### Share as Text

### Share as Image

Share Image يمكن أن تكون Card بنفس Design System.

---

# 94. Explain Result

زر:

### How is this calculated?

يفتح Bottom Sheet أو Section.

يعرض:

* Formula.
* Inputs.
* Process.
* Rounding.

وهذا مهم جدًا للحاسبات العلمية والمالية والصحية.

---

# 95. Precision Settings

في الإعدادات:

### Result Precision

* Automatic.
* 0 decimals.
* 1.
* 2.
* 3.
* 4.
* 6.
* Maximum.

لكن يجب ألا يتم إجبار جميع الأدوات على Precision واحدة.

---

# 96. Measurement Preferences

داخل Settings:

### Default Units

Metric
Imperial

والاختيار يؤثر على الأدوات ذات العلاقة.

---

# 97. Default Currency

المستخدم يحدد عملته الأساسية.

مثلاً:

EGP

ثم تصبح هي الافتراضية في الأدوات المالية والعملات.

---

# 98. Language

حاليًا جيد جدًا.

يجب الحفاظ على:

* Arabic.
* English.
* RTL.
* Localized numbers.
* Localized dates.
* Localized currency names.
* Localized unit names.
* Localized error messages.

ومن المهم أن يكون لدى كل قيمة:

* Display Name Arabic.
* Display Name English.
* Symbol.
* Search aliases.

---

# 99. Translation Architecture

الـ `translations.dart` الحالي كبير، وهذا جيد كبداية، لكن على المدى الطويل من الأفضل فصل الترجمات إلى ملفات/كيانات منطقية.

مثل:

core
calculators
units
currencies
files
settings
errors

هذا يجعل الصيانة أفضل من ملف واحد ضخم.

---

# 100. Theme

الحالي:

Dark / Light.

الأفضل إضافة:

### System Default

حتى يتبع التطبيق إعداد النظام تلقائيًا.

---

# 101. Custom Theme

ميزة مستقبلية:

Accent Color

مع الحفاظ على Design System.

لكن لا تسمح للمستخدم باختيار أي لون يخرب Contrast أو Accessibility.

---

# 102. Accessibility

يجب دعم:

* تكبير النص.
* Touch targets مناسبة.
* Screen Reader.
* Semantic labels.
* Contrast.
* عدم الاعتماد على اللون وحده.

وخصوصًا Result Cards.

---

# 103. Responsive Layout

بما أن المشروع Flutter متعدد المنصات:

### Mobile

Bottom Navigation.

### Tablet

Navigation Rail.

### Desktop

Sidebar.

### Web

Responsive layout بدون تمدد مبالغ فيه.

---

# 104. Desktop Layout

في شاشات كبيرة يمكن:

Left:
Categories / Tools

Center:
Current Tool

Right:
History / Result Details

بدل تكبير واجهة الهاتف.

---

# 105. Settings Page الحالية

حاليًا تحتوي على:

* Language.
* Theme.
* API security information.
* About.

يجب تطويرها لتصبح:

### Appearance

Language
Theme
Font size

### Defaults

Default currency
Default measurement system
Precision

### History

Enable
Clear
Auto cleanup

### Notifications

Countdown
Timer

### Privacy

Privacy Center
Data controls

### Files

Cloud processing information

### About

Version
Changelog
Licenses
Contact

---

# 106. Privacy Center

يجب إنشاء صفحة مستقلة.

توضح:

### Local Data

* Settings.
* Favorites.
* History.
* Presets.
* Cached data.

### Cloud Data

* File conversion data.
* Currency API requests إذا وجدت.
* OCR إذا كان سحابيًا.

### Delete Data

* History.
* Favorites.
* Presets.
* Cache.
* All.

---

# 107. File Data Lifecycle

بسبب CloudConvert، يجب تحديد:

* متى يتم رفع الملف؟
* متى يتم بدء التحويل؟
* أين يوجد الملف أثناء العملية؟
* متى يتم حذف البيانات المؤقتة؟
* مدة صلاحية رابط التحميل.

والواجهة يجب أن تعكس ذلك بوضوح بدل استخدام عبارة عامة مثل "آمن تمامًا".

---

# 108. Error System

يجب توحيد الأخطاء على مستوى التطبيق.

الأنواع:

### Validation Error

البيانات ناقصة أو غير صحيحة.

### Network Error

لا يوجد اتصال.

### Service Error

الخدمة الخارجية فشلت.

### Authentication Error

مشكلة API credentials.

### Rate Limit

الخدمة أو المستخدم وصل للحد.

### Unsupported Format

الصيغة غير مدعومة.

### Timeout

انتهاء المهلة.

---

# 109. Error UI

بدل إظهار Exception.

تظهر:

### Something went wrong

ثم:

شرح مفهوم للمشكلة.

ثم:

Retry

أو:

Back

أو:

Use Cached Data

بحسب الحالة.

---

# 110. Loading States

كل العمليات الطويلة يجب أن تحتوي على حالة واضحة.

خاصة:

* File upload.
* File conversion.
* OCR.
* Currency update.

ويفضل استخدام:

Skeleton / Progress / Status

بدل شاشة فارغة.

---

# 111. Home Personalization

إضافة:

# Customize Home

المستخدم يحدد:

* الأدوات.
* ترتيبها.
* الأقسام.
* عدد العناصر في Quick Tools.

ولا تحتاج هذه الوظيفة إلى حساب سحابي.

---

# 112. Local Learning

التطبيق يتعلم فقط من الاستخدام المحلي:

* Most used tools.
* Recent tools.
* Frequent units.
* Frequent currencies.

ولا يحتاج إرسال هذه المعلومات إلى Server.

---

# 113. Export / Import Settings

ميزة مستقبلية قوية.

يمكن للمستخدم تصدير:

* Favorites.
* Presets.
* Custom units.
* Preferences.
* Countdown events.

ثم استيرادها على جهاز آخر.

---

# 114. Widgets

إذا كانت المنصة المستهدفة تدعمها:

Widgets:

### Currency

يعرض زوجًا محفوظًا.

### Countdown

يعرض مناسبة محفوظة.

### Favorite Tools

اختصارات.

### Calculator

فتح مباشر.

---

# 115. Quick Actions

اختصارات التطبيق:

* Smart Calculate.
* Currency.
* File Converter.
* QR Scanner.
* Calculator.

---

# 116. Notifications

تستخدم فقط للأشياء التي تحتاجها فعلًا:

* Countdown.
* Timer.
* Event reminder.

وتكون اختيارية بالكامل.

---

# 117. Onboarding

ثلاث شاشات تقريبًا:

### Screen 1

Calciverse في تطبيق واحد.

### Screen 2

احسب وحوّل بسرعة.

### Screen 3

اختر أدواتك المفضلة.

ثم:

**Get Started**

ولا تجعل المستخدم يمر بإعدادات طويلة.

---

# 118. First Launch

بعد البداية:

Language
Theme
Favorite Categories

ثم يدخل Home.

---

# 119. Empty States

كل قسم يحتاج Empty State.

### History

> No calculations yet.

### Favorites

> Add tools to access them quickly.

### Countdown

> Create your first event.

### Presets

> Save repeated information here.

---

# 120. Security Architecture

أهم تعديل تقني مقترح هو:

عدم وضع أسرار الخدمات داخل تطبيق العميل.

الهدف النهائي:

### Flutter

UI + local logic + client-side engines

### Backend

Secrets + cloud service access

خصوصًا:

CloudConvert API.

---

# 121. Service Layer

بدل وضع HTTP calls مباشرة داخل الصفحة:

`file_converter_page.dart`

اجعل:

### CloudConvertService

مسؤولًا عن API.

والصفحة مسؤولة فقط عن UI.

---

# 122. Repository / Engine Architecture

الهيكل المقترح:

```text
lib/
│
├── core/
│   ├── localization/
│   ├── theme/
│   ├── formatting/
│   ├── errors/
│   └── storage/
│
├── engines/
│   ├── calculator/
│   ├── conversion/
│   ├── date/
│   ├── currency/
│   ├── finance/
│   └── health/
│
├── services/
│   ├── cloudconvert/
│   ├── currency_api/
│   └── scanner/
│
├── models/
│
├── pages/
│
└── widgets/
```

الفكرة ليست فرض أسماء مجلدات معينة، وإنما الفصل بين:

**UI / Business Logic / External Services / Data**

---

# 123. Unit Engine

كل الوحدات تمر بنفس المسار:

Input
→ Validate
→ Normalize
→ Base Unit
→ Target Unit
→ Format
→ Result

وهذا يمنع اختلاف النتائج بين الصفحات.

---

# 124. Date Engine

مستقل عن Unit Engine.

مسؤول عن:

* Leap years.
* Month lengths.
* Date difference.
* Add/subtract.
* Business days.
* Time zones.
* DST.

---

# 125. Currency Engine

مسؤول عن:

* Rates.
* Cache.
* Last updated.
* Currency metadata.
* Conversion.
* Favorites.
* Multiple conversions.

---

# 126. Finance Engine

مسؤول عن:

* Interest.
* Loans.
* Amortization.
* ROI.
* Margin.
* Markup.
* Savings.

---

# 127. Health Engine

مسؤول عن:

* BMI.
* BMR.
* TDEE.
* Calories.
* Macros.

ويفصل عن UI.

---

# 128. Local Storage

يجب أن تحفظ محليًا:

* Theme.
* Language.
* History.
* Favorites.
* Presets.
* Countdown events.
* Custom units.
* Cached currency rates.
* Preferences.

---

# 129. SharedPreferences الحالية

مناسبة للإعدادات البسيطة.

لكن عندما يزيد حجم:

History
Favorites
Presets
Events

من الأفضل الانتقال إلى Local Database مخصصة بدل وضع كل شيء داخل SharedPreferences.

مثلاً:

SQLite / Drift / Hive / Isar

بحسب الـ architecture الذي تختاره.

---

# 130. Performance

لأن التطبيق يحتوي على:

* 200+ formats.
* 160+ currencies.
* 4,000+ lines conversion mapping.
* Large translation file.

يجب تجنب تحميل كل شيء في الواجهة في نفس الوقت.

الأفضل:

Lazy loading
Caching
Memoization
Pagination حيث يلزم

خصوصًا في Currency وFile Format lists.

---

# 131. File Conversion Mapping

`conversion_mapping.dart` الضخم يعمل، لكن مستقبلاً الأفضل تقسيم معلومات الصيغ إلى Data Models منظمة حسب:

Audio
Video
Image
Documents
Books
Archives
Fonts

حتى يسهل:

* Search.
* Filtering.
* Validation.
* UI generation.

---

# 132. Automated Tests

هذه من أهم الإضافات التقنية.

يجب كتابة Unit Tests للمحركات:

### Conversion Tests

كل وحدة مقابل Base Unit.

### Date Tests

Leap Years
Month boundaries
Date difference

### Financial Tests

Interest
Loan
Amortization

### Health Tests

BMI
BMR

### Currency Tests

Parsing
Conversion.

---

# 133. Golden / Widget Tests

يتم اختبار:

* Light Mode.
* Dark Mode.
* Arabic.
* English.
* RTL.
* Small screen.
* Large screen.

وبالأخص الصفحات التي تتغير جذريًا عند تغيير اللغة.

---

# 134. Test Matrix

Calciverse يحتاج اختبارًا فعليًا على:

### Android

Phones
Tablets

### iOS

Phones
iPad

### Desktop

Windows
macOS
Linux

### Web

Chrome / Edge / Safari حسب الحاجة.

ومهم جدًا ألا تفترض أن File Picker أو Notifications أو Camera تعمل بنفس الطريقة عبر جميع المنصات.

---

# 135. Platform Capability Matrix

بعض الميزات يجب تعريف دعمها حسب النظام:

| Feature               | Android     | iOS         | Web         | Desktop    |
| --------------------- | ----------- | ----------- | ----------- | ---------- |
| Unit conversion       | نعم         | نعم         | نعم         | نعم        |
| Currency              | نعم         | نعم         | نعم         | نعم        |
| Cloud File Conversion | نعم         | نعم         | نعم         | نعم        |
| Camera OCR            | حسب التنفيذ | حسب التنفيذ | محدود/مختلف | محدود      |
| QR Camera             | نعم         | نعم         | حسب المتصفح | محدود      |
| Notifications         | نعم         | نعم         | حسب المتصفح | حسب النظام |
| Widgets               | حسب النظام  | حسب النظام  | لا          | لا         |

الجدول النهائي يجب أن يعكس التنفيذ الحقيقي وليس مجرد وعد تسويقي.

---

# 136. ....
---

# 137. ....
---

# 138. صفحة About

تحتوي على:

Calciverse

Version
Build
Tools count
Supported formats
Supported currencies

ثم:

Privacy
Terms
Licenses
Contact
Rate App

---

# 139. What's New

داخل About أو Settings:

### What's New

يعرض آخر التحديثات:

* New converters.
* New calculators.
* Performance improvements.
* Bug fixes.

---

# 140. Tool Statistics

ميزة اختيارية داخل Home أو About:

بدون كشف بيانات خاصة، يمكن عرض:

عدد الأدوات المتاحة.

عدد صيغ الملفات.

عدد العملات المدعومة.

---

# 141. العدد الكبير من الأدوات لا يجب أن يظهر في Home

هذه قاعدة مهمة.

Home:

10–15 عنصرًا.

Tools:

كل شيء.

Search:

الوصول المباشر.

Favorites:

المستخدم يقرر.

---

# 142. تصميم أداة موحدة

كل صفحة Tool جديدة يجب أن تتبع Template ثابت:

```text
Header
↓
Tool Description
↓
Input Section
↓
Options
↓
Calculate / Convert
↓
Result Card
↓
Details
↓
Actions
↓
Related Tools
```

هذا يجعل إضافة أي أداة مستقبلية أسرع بكثير.

---

# 143. Related Tools

في أسفل كل أداة:

### Related Tools

مثلاً:

BMI:

BMR
TDEE
Calories

Age:

Age Difference
Zodiac
Countdown

Length:

Area
Weight
Volume

Currency:

Finance

---

# 144. Tool Favorites

في Header كل Tool:

⭐

وبالتالي يستطيع المستخدم إضافة الأداة للمفضلة دون الدخول إلى Settings.

---

# 145. Recent Values

يمكن للأداة الاحتفاظ بآخر مدخلات الاستخدام محليًا.

لكن يجب أن يكون ذلك اختياريًا في Settings.

---

# 146. Auto Restore

خيار:

### Restore Last Input

عند العودة إلى الأداة يعيد آخر بيانات.

ويكون هناك:

Clear

لحذفها.

---

# 147. Accessibility للرقم والنتيجة

النتيجة يجب أن تكون قابلة للقراءة بواسطة Screen Reader، وليس فقط شكلًا بصريًا.

---

# 148. Haptic Feedback

خيار:

### Haptic Feedback

لأزرار مهمة مثل:

Calculate
Copy
Swap
Start Timer

ويكون قابلاً للإيقاف.

---

# 149. Copy Feedback

عند النسخ:

بدل Notification مزعج، يظهر:

> Copied

في SnackBar صغيرة.

---

# 150. Swap Behavior

كل Converter يجب أن يحتوي على:

### Swap

وعند الضغط:

From ↔ To

مع تغيير القيم بشكل منطقي.

---

# 151. Clear Input

في كل Input:

Clear

لتصفير القيمة بسرعة.

---

# 152. Input Validation

مثلاً:

Age:

منع تاريخ مستقبلي.

BMI:

منع صفر أو قيم غير منطقية.

Percentage:

منع القسمة على صفر.

Date:

منع تاريخ غير صالح.

File:

منع صيغة غير مدعومة.

---

# 153. Error Messages بالعربي والإنجليزي

لا تستخدم:

"Invalid input"

فقط.

في العربية:

> يرجى إدخال قيمة صحيحة.

وفي الإنجليزية:

> Please enter a valid value.

وهذا ينسجم مع نظام الترجمة الحالي.

---

# 154. التسميات

لا تستخدم نفس الكلمة عربيًا بطريقة غير متناسقة.

مثلاً:

Weight

يفضل:

**الوزن والكتلة**

أو اختيار تسمية ثابتة على مستوى التطبيق.

ونفس الشيء:

Volume
Data
Area
Duration

---

# 155. عدد الصفحات النهائي

لا أنصح أن يصل التطبيق إلى 80 ملف Page منفصل.

الأفضل:

Pages رئيسية + reusable tool templates + engines.

قد توجد عشرات الأدوات فعليًا، لكن architecture لا تصبح عشرات الأكواد المكررة.

---

# 156. الأولوية الأولى

أهم ما يجب تنفيذه أولًا:

### Phase 1

* Home redesign.
* Global Search.
* Universal Input.
* History.
* Favorites.
* Presets.
* Scientific Calculator.
* Unified Result Actions.
* Better Settings.
* Privacy Center.

---

# 157. الأولوية الثانية

### Phase 2

* Finance.
* Advanced Converters.
* Time Zone.
* Business Days.
* Add/Subtract Date.
* Cooking.
* Multi-Currency.
* Live Currency API.
* Cached currency rates.

---

# 158. الأولوية الثالثة

### Phase 3

* OCR.
* QR.
* Barcode.
* Image Tools.
* PDF Tools.
* More File workflows.

---

# 159. الأولوية الرابعة

### Phase 4

* Widgets.
* Quick Actions.
* Export / Import.
* Smart suggestions.
* Advanced personalization.
* Premium layer.

---

# 160. الصفحة الرئيسية في الشكل النهائي

الـ Home النهائية يجب أن تكون تقريبًا:

```text
┌─────────────────────────────────┐
│ Calciverse                  ⚙ │
│                                 │
│ ماذا تريد أن تحسب أو تحوّل؟ 🔍 │
│                                 │
│ ⭐ الأكثر استخدامًا             │
│                                 │
│ [Currency] [Calculator]         │
│ [Age]      [BMI]                │
│ [VAT]      [Length]             │
│                                 │
│ ↻ آخر الأدوات                   │
│                                 │
│ Age Calculator                  │
│ Last used...                    │
│                                 │
│ 🧮 Calculators                  │
│ 📏 Converters                   │
│ 💰 Finance                      │
│ 💱 Currency                     │
│ ❤️ Health                       │
│ 📅 Date & Time                  │
│ 📁 Files                        │
│ 📷 Scan                         │
│ 🧰 Everyday                     │
└─────────────────────────────────┘
```

مع تصميم حقيقي نظيف ومتناسق، وليس بهذه البساطة البصرية نفسها.

---

# 161. الشكل النهائي لتجربة المستخدم

المستخدم الجديد:

يدخل التطبيق.

يرى Home بسيطة.

يبحث عن شيء.

يفتح الأداة.

يدخل البيانات.

يحصل على النتيجة.

يستطيع:

Copy
Share
Save
Favorite

المستخدم المتكرر:

يفتح التطبيق.

يجد أداته في Quick Tools.

أو يجد آخر عملية.

أو يستعمل Preset.

أو يدخل Smart مباشرة.

هذه هي تجربة Calciverse المثالية.

---

# 162. ما الذي يجب تغييره في وصف التطبيق الحالي؟

هناك بعض عبارات الوصف الحالية التي ينبغي عدم استخدامها بصيغة مطلقة.

### بدل:

"يعمل على كل المنصات"

الأفضل:

> "تم تطوير Calciverse باستخدام Flutter مع دعم Android وiOS وDesktop وWeb، مع اختلاف توفر بعض الميزات حسب النظام."

---

### بدل:

"حماية API keys"

إذا كان المفتاح داخل Client:

هذه ليست حماية فعلية للمستخدم النهائي.

الأفضل:

> "مفاتيح الخدمات الحساسة تتم إدارتها عبر طبقة الخادم في النسخة الإنتاجية."

---

### بدل:

"المحول حقيقي وآمن"

الأفضل:

> "يستخدم Calciverse خدمة CloudConvert لمعالجة التحويلات السحابية."

ثم توضيح دورة التعامل مع الملفات.

---

### بدل:

"أسعار العملات"

طالما أنها Demo:

> "أسعار تجريبية ثابتة حاليًا، مع دعم بنية قابلة لربط مزود أسعار صرف مباشر."

---

# 163. الهوية التسويقية النهائية

أفضل وصف مختصر للمشروع:

> **Calciverse هو تطبيق أدوات شامل يجمع بين الحاسبات، محولات الوحدات، العملات، أدوات التاريخ والصحة والمالية، بالإضافة إلى محول ملفات يدعم مئات الصيغ، ضمن واجهة عربية وإنجليزية موحدة وسريعة.**

ثم يتم إبراز:

**Smart Search**

**Universal Input**

**160+ Currencies**

**200+ File Formats**

**Offline-capable Calculations**

**Arabic + English**

**Dark + Light**

---

# 164. وصف أطول للمتجر

Calciverse هو مركز أدوات متكامل للحساب والتحويل والاستخدام اليومي، يجمع مجموعة واسعة من الحاسبات ومحولات الوحدات والعملات والتاريخ والصحة والمالية داخل تطبيق واحد.

يشمل التطبيق محولات للطول والمساحة والوزن والحجم ودرجات الحرارة والوقت والبيانات، بالإضافة إلى حاسبات العمر وفارق العمر والمدة والـ BMI والسعرات والنسب المئوية والضريبة، مع دعم أكثر من 160 عملة وأكثر من 200 صيغة لتحويل الملفات عبر خدمة CloudConvert.

يدعم Calciverse العربية والإنجليزية مع RTL كامل، وتنسيق الأرقام والتواريخ حسب اللغة، بالإضافة إلى الوضع الداكن والفاتح ونظام تصميم موحد لجميع الأدوات.

النسخة المستقبلية من Calciverse توسع هذه المنظومة لتشمل حاسبة علمية، أدوات مالية متقدمة، محولات علمية وهندسية إضافية، OCR، أدوات PDF والصور، QR وBarcode، البحث الذكي، الإدخال الموحد، السجل والمفضلة، Presets، والتخصيص الشخصي.

---

# 165. أهم 10 إضافات في المشروع كله

لو أردت ترتيب كل ما سبق حسب تأثيره الفعلي على جودة التطبيق:

### 1. Universal Search

لأنه يحل مشكلة العثور على الأدوات.

### 2. Universal Input / Smart

لأنه يجعل Calciverse "ذكيًا" بدل مجرد قائمة أدوات.

### 3. History

لأن العمليات المتكررة تحتاج إعادة استخدام.

### 4. Favorites

لتقليل وقت الوصول.

### 5. Presets

لتقليل إدخال البيانات.

### 6. Scientific Calculator

تكمل قسم Calculator.

### 7. Finance Suite

توسّع الاستخدام اليومي بشكل كبير.

### 8. Live Currency + Cache

تحول Currency من Demo إلى Feature حقيقية.

### 9. OCR + QR + PDF/Image Tools

توسع معنى "Utility App".

### 10. Backend للـ CloudConvert

لأنه أهم تحسين أمني معماري في المشروع الحالي.

---

# 166. الأولويات التي لا أنصح بتأجيلها

هناك فرق بين "ميزة جديدة" و"مشكلة يجب إصلاحها".

أهم الأشياء التي أتعامل معها كمشاكل يجب حلها قبل التوسع الكبير:

### API Secret Exposure

لا تعتمد على `.env` كحماية لسر داخل Client.

### Currency Demo Labeling

لا تستخدم Live أو Real-time طالما الأسعار ثابتة.

### Cloud File Privacy

وضح أن الملفات تعالج عبر خدمة سحابية.

### SharedPreferences Scalability

استخدم Local DB عند توسع History/Presets/Events.

### Duplicate Logic

انقل الحسابات والتحويلات إلى Engines مركزية.

---

# 167. النتيجة النهائية التي يجب أن تصل إليها

Calciverse في النهاية يجب أن يبدو كالتالي:

## Home

الوصول الذكي.

## Smart

الفهم والتنفيذ السريع.

## Tools

كل الأدوات.

## History

كل عملياتك السابقة.

## Favorites

أدواتك المفضلة.

## Settings

التخصيص والخصوصية.

وفي الداخل:

### Calculators

حسابات رياضية وصحية ومالية.

### Converters

محولات وحدات عامة وعلمية.

### Currency

عملات عالمية مع Cache وتحديث فعلي.

### Date & Time

تاريخ ووقت وCountdown.

### Files

تحويل حقيقي للملفات.

### Scan

OCR / QR / Barcode.

### Everyday

Timer / Stopwatch / Counter وغيرها.

### Personalization

Favorites / Presets / Custom Units / Dashboard.

---

# 168. المبدأ النهائي للمشروع

كل ميزة جديدة في Calciverse يجب أن تجتاز 5 أسئلة:

### هل هي واضحة؟

المستخدم يفهم ما تفعله فورًا.

### هل تستخدم نفس Design System؟

لا توجد صفحة تبدو كأنها من تطبيق آخر.

### هل لها Result واضح؟

النتيجة هي أهم عنصر في الشاشة.

### هل يمكن إعادة استخدامها؟

History / Favorites / Presets.

### هل تعمل مع بقية التطبيق؟

Related Tools / Cross-tool Workflow.

إذا كانت الإجابة نعم، فالميزة تنتمي فعلًا إلى Calciverse.

---

# 169. الشكل المثالي لـ Calciverse

**Calciverse ليس تطبيقًا يحوي 50 أو 100 أداة.**

الهدف هو أن يشعر المستخدم أن لديه:

> **محركًا واحدًا يفهم الحساب والتحويل والأدوات اليومية، وتحت هذا المحرك مجموعة من الأدوات المتخصصة.**

لذلك أهم إضافة في المشروع ليست Calculator رقم 31 أو Converter رقم 22.

أهم إضافة هي:

**طبقة ذكية وموحدة تربط جميع الأدوات الموجودة والجديدة.**

وهذه الطبقة هي:

**Search + Universal Input + Engines + History + Favorites + Presets + Cross-tool Actions**

وبوجودها يصبح كل شيء بنيته بالفعل أكثر قيمة، لأن **Length وBMI وCurrency وFile Converter وغيرها لن تبدو وكأنها صفحات منفصلة؛ ستصبح أجزاء من نظام Calciverse واحد.**