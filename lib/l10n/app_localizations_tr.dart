// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'EvKasa';

  @override
  String get tabHome => 'Ana sayfa';

  @override
  String get tabExpenses => 'Giderler';

  @override
  String get tabHouse => 'Ev';

  @override
  String get tabAccount => 'Hesap';

  @override
  String get add => 'Ekle';

  @override
  String get back => 'Geri';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get clear => 'Temizle';

  @override
  String get close => 'Kapat';

  @override
  String get copy => 'Kopyala';

  @override
  String get copied => 'Kopyalandı';

  @override
  String get delete => 'Sil';

  @override
  String get edit => 'Düzenle';

  @override
  String get next => 'İleri';

  @override
  String get ok => 'Tamam';

  @override
  String get or => 'veya';

  @override
  String get remove => 'Çıkar';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get save => 'Kaydet';

  @override
  String get share => 'Paylaş';

  @override
  String get skip => 'Geç';

  @override
  String get seeAll => 'Tümü';

  @override
  String get requiredField => 'Bu alan zorunlu';

  @override
  String get you => 'Sen';

  @override
  String youSuffix(String name) {
    return '$name (sen)';
  }

  @override
  String get unknownMember => 'Bilinmeyen üye';

  @override
  String get deletedUser => 'Silinmiş kullanıcı';

  @override
  String get admin => 'Yönetici';

  @override
  String get errorNetwork => 'Şu an bağlanılamıyor, tekrar dene.';

  @override
  String get errorPermission => 'Bu işlem için yetkin yok.';

  @override
  String get errorNotFound => 'Aradığın kayıt bulunamadı.';

  @override
  String get errorInvalidCredentials => 'E-posta veya şifre hatalı.';

  @override
  String get errorEmailInUse => 'Bu e-posta ile zaten bir hesap var.';

  @override
  String get errorWeakPassword => 'Şifre en az 6 karakter olmalı.';

  @override
  String get errorInvalidEmail => 'Geçerli bir e-posta adresi gir.';

  @override
  String get errorTooManyRequests =>
      'Çok fazla deneme yapıldı, biraz sonra tekrar dene.';

  @override
  String get errorCancelled => 'İşlem iptal edildi.';

  @override
  String get errorRequiresRecentLogin =>
      'Güvenlik için çıkış yapıp tekrar giriş yapmalısın.';

  @override
  String get errorHouseholdLimit =>
      'Ücretsiz planda tek eve üye olabilirsin. Daha fazlası için Pro\'ya geç.';

  @override
  String get errorHouseholdFull => 'Bu ev dolu (en fazla 12 üye).';

  @override
  String get errorInviteInvalid => 'Davet kodu geçersiz. Kodu kontrol et.';

  @override
  String get errorBalanceNotZero =>
      'Bakiye sıfır değil. Önce ödeşmeniz gerekiyor.';

  @override
  String get errorReceiptQuota => 'Bu ayki fiş okuma hakkın doldu.';

  @override
  String get errorReceiptUnreadable => 'Fiş okunamadı.';

  @override
  String get errorReminderAlreadySent =>
      'Bugün bu kişiye zaten hatırlatma gönderdin.';

  @override
  String get errorNothingOwed => 'Bu kişinin borcu yok.';

  @override
  String get errorUnknown => 'Bir şeyler ters gitti, tekrar dene.';

  @override
  String get welcomeTitle1 => 'Giderleri tek yerde topla';

  @override
  String get welcomeBody1 =>
      'Kira, faturalar ve market alışverişini ekle; kim ne ödedi hep belli olsun.';

  @override
  String get welcomeTitle2 => 'Kuruşu kuruşuna adil';

  @override
  String get welcomeBody2 =>
      'Eşit, tutar, yüzde veya oda büyüklüğüne göre bölüş; borçlar en az transferle sadeleşsin.';

  @override
  String get welcomeTitle3 => 'Ev işleri de burada';

  @override
  String get welcomeBody3 =>
      'Ortak alışveriş listesi ve \"sıra kimde\" takibi. Gider eklemek her zaman ücretsiz ve sınırsız.';

  @override
  String get getStarted => 'Başla';

  @override
  String pageIndicator(int current, int total) {
    return 'Sayfa $current / $total';
  }

  @override
  String get authSubtitle => 'Ev arkadaşlarınla masrafları adilce bölüş.';

  @override
  String get signIn => 'Giriş yap';

  @override
  String get register => 'Kayıt ol';

  @override
  String get signOut => 'Çıkış yap';

  @override
  String get yourName => 'Adın';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get showPassword => 'Şifreyi göster';

  @override
  String get hidePassword => 'Şifreyi gizle';

  @override
  String get forgotPassword => 'Şifremi unuttum';

  @override
  String get enterEmailFirst => 'Önce e-posta adresini yaz.';

  @override
  String get passwordResetSent =>
      'Şifre sıfırlama bağlantısı e-postana gönderildi.';

  @override
  String get continueWithGoogle => 'Google ile devam et';

  @override
  String get continueWithApple => 'Apple ile devam et';

  @override
  String get onboardingTitle => 'Evini kur';

  @override
  String get onboardingBody =>
      'Yeni bir ev oluştur ya da ev arkadaşının paylaştığı 6 haneli kodla katıl.';

  @override
  String get createHousehold => 'Ev oluştur';

  @override
  String get joinWithCode => 'Kodla katıl';

  @override
  String get join => 'Katıl';

  @override
  String get householdName => 'Ev adı';

  @override
  String get householdNameHint => 'ör. Moda\'daki ev';

  @override
  String get currency => 'Para birimi';

  @override
  String get inviteCode => 'Davet kodu';

  @override
  String get inviteCodeLength => 'Kod 6 karakter olmalı';

  @override
  String inviteCodeSemantics(String code) {
    return 'Davet kodu: $code';
  }

  @override
  String get inviteTitle => 'Evin hazır!';

  @override
  String get inviteBody =>
      'Ev arkadaşlarını davet et: bu kodu paylaş, uygulamada \"Kodla katıl\" ile girsinler.';

  @override
  String inviteShareText(String code) {
    return 'EvKasa\'da evimize katıl! Uygulamayı aç, \"Kodla katıl\"a dokun ve şu kodu gir: $code';
  }

  @override
  String get continueToHome => 'Ana sayfaya geç';

  @override
  String get regenerateCode => 'Kodu yenile';

  @override
  String get regenerateCodeBody =>
      'Eski kod çalışmayı bırakır. Yeni kodu ev arkadaşlarınla tekrar paylaşman gerekir.';

  @override
  String get addHousehold => 'Başka bir ev ekle';

  @override
  String get myHouseholds => 'Evlerim';

  @override
  String get switchHousehold => 'Ev değiştir';

  @override
  String get houseSettings => 'Ev ayarları';

  @override
  String get editHousehold => 'Evi düzenle';

  @override
  String membersCount(int count, int max) {
    return 'Üyeler ($count/$max)';
  }

  @override
  String get rentWeightHelp =>
      'Kira payı: kira giderleri bu ağırlıklara göre bölünür (ör. büyük oda 3, küçük oda 2).';

  @override
  String rentWeightValue(int weight) {
    return 'Kira payı: $weight';
  }

  @override
  String decreaseRentWeight(String name) {
    return '$name için kira payını azalt';
  }

  @override
  String increaseRentWeight(String name) {
    return '$name için kira payını artır';
  }

  @override
  String get removeMember => 'Üyeyi çıkar';

  @override
  String removeMemberBody(String name) {
    return '$name evden çıkarılsın mı?';
  }

  @override
  String get cannotRemoveTitle => 'Önce ödeşilmeli';

  @override
  String cannotRemoveBody(String name, String amount) {
    return '$name kişisinin bakiyesi $amount. Bakiye sıfırlanmadan çıkarılamaz.';
  }

  @override
  String get leaveHousehold => 'Evden ayrıl';

  @override
  String get leave => 'Ayrıl';

  @override
  String leaveHouseholdBody(String household) {
    return '\"$household\" evinden ayrılmak istediğine emin misin?';
  }

  @override
  String get cannotLeaveTitle => 'Önce ödeşmelisin';

  @override
  String cannotLeaveBody(String amount) {
    return 'Bakiyen $amount. Evden ayrılmadan önce bakiyenin sıfır olması gerekiyor.';
  }

  @override
  String get inviteHousemates => 'Ev arkadaşlarını davet et';

  @override
  String get allSettled => 'Hesaplar denk, kimsenin kimseye borcu yok.';

  @override
  String youOweOne(String name, String amount) {
    return '$name $amount borçlusun';
  }

  @override
  String youOweTotal(String amount) {
    return 'Toplam $amount borçlusun';
  }

  @override
  String owesYouOne(String name, String amount) {
    return '$name sana $amount borçlu';
  }

  @override
  String theyOweYouTotal(String amount) {
    return 'Sana $amount borçlular';
  }

  @override
  String get statusOwe => 'Borçlusun';

  @override
  String get statusOwed => 'Alacaklısın';

  @override
  String get statusSettled => 'Ödeşmiş';

  @override
  String get whoOwesWhom => 'Kim kime borçlu';

  @override
  String transferLine(String from, String to) {
    return '$from → $to';
  }

  @override
  String get pay => 'Öde';

  @override
  String get remind => 'Hatırlat';

  @override
  String get reminderSent => 'Hatırlatma gönderildi.';

  @override
  String get pendingBills => 'Tutar bekleyen faturalar';

  @override
  String get enterAmount => 'Tutarı gir';

  @override
  String get recentPayments => 'Son ödemeler';

  @override
  String get disputePayment => 'Ödemeye itiraz et';

  @override
  String disputePaymentBody(String amount) {
    return '$amount tutarındaki ödeme kaydı silinsin mi? Bakiye buna göre güncellenir.';
  }

  @override
  String get recentActivity => 'Son etkinlikler';

  @override
  String get homeEmptyTitle => 'İlk gideri ekle';

  @override
  String get homeEmptyBody =>
      'Bir gider eklediğinde kimin kime borçlu olduğu burada görünür.';

  @override
  String get recordPayment => 'Ödeme kaydet';

  @override
  String get from => 'Kimden';

  @override
  String get to => 'Kime';

  @override
  String get partialPaymentHint => 'Tamamını ya da bir kısmını ödeyebilirsin.';

  @override
  String recipientIban(String name) {
    return '$name IBAN';
  }

  @override
  String get copyIban => 'IBAN\'ı kopyala';

  @override
  String get ibanCopied => 'IBAN kopyalandı';

  @override
  String noIbanYet(String name) {
    return '$name henüz IBAN eklememiş.';
  }

  @override
  String get markAsPaid => 'Ödeme yapıldı';

  @override
  String get paymentRecorded => 'Ödeme kaydedildi.';

  @override
  String get samePersonError => 'Kimden ve kime aynı kişi olamaz';

  @override
  String get paymentMustInvolveYou =>
      'Yalnızca kendi ödemelerini kaydedebilirsin';

  @override
  String get addExpense => 'Gider ekle';

  @override
  String get editExpense => 'Gideri düzenle';

  @override
  String get enterBillAmount => 'Fatura tutarını gir';

  @override
  String get description => 'Açıklama';

  @override
  String get amount => 'Tutar';

  @override
  String get paidBy => 'Ödeyen';

  @override
  String get category => 'Kategori';

  @override
  String get date => 'Tarih';

  @override
  String get split => 'Bölüşme';

  @override
  String get note => 'Not';

  @override
  String get noteOptional => 'Not (isteğe bağlı)';

  @override
  String get shares => 'Paylar';

  @override
  String get enterValidAmount => 'Geçerli bir tutar gir';

  @override
  String get fixSplitFirst => 'Bölüşme toplamı tutmuyor';

  @override
  String paidByOn(String name, String date) {
    return '$name ödedi · $date';
  }

  @override
  String yourShare(String amount) {
    return 'Payın $amount';
  }

  @override
  String get pendingAmount => 'Tutar bekleniyor';

  @override
  String splitTypeLabel(String type) {
    return 'Bölüşme: $type';
  }

  @override
  String get searchExpenses => 'Giderlerde ara';

  @override
  String get allCategories => 'Tüm kategoriler';

  @override
  String get everyone => 'Herkes';

  @override
  String get noExpensesTitle => 'Henüz gider yok';

  @override
  String get noExpensesBody =>
      'Kira, fatura veya market: ilk ortak gideri ekleyin.';

  @override
  String get noResultsTitle => 'Sonuç yok';

  @override
  String get noResultsBody => 'Bu filtrelerle eşleşen gider bulunamadı.';

  @override
  String get clearFilters => 'Filtreleri temizle';

  @override
  String get deleteExpense => 'Gideri sil';

  @override
  String deleteExpenseBody(String description) {
    return '\"$description\" kalıcı olarak silinsin mi?';
  }

  @override
  String get expenseNotFound => 'Gider bulunamadı';

  @override
  String get expenseNotFoundBody => 'Bu gider silinmiş olabilir.';

  @override
  String get categoryRent => 'Kira';

  @override
  String get categoryElectricity => 'Elektrik';

  @override
  String get categoryWater => 'Su';

  @override
  String get categoryGas => 'Doğalgaz';

  @override
  String get categoryInternet => 'İnternet';

  @override
  String get categoryGroceries => 'Market';

  @override
  String get categoryCleaning => 'Temizlik';

  @override
  String get categoryHomeGoods => 'Ev eşyası';

  @override
  String get categoryOther => 'Diğer';

  @override
  String get splitEqual => 'Eşit';

  @override
  String get splitExact => 'Tutar';

  @override
  String get splitPercent => 'Yüzde';

  @override
  String get splitShares => 'Pay';

  @override
  String get sharesSuffix => 'pay';

  @override
  String get splitNoParticipants => 'En az bir kişi seç';

  @override
  String get splitInvalidNumber => 'Geçersiz sayı var';

  @override
  String splitMissing(String amount) {
    return '$amount eksik';
  }

  @override
  String splitExcess(String amount) {
    return '$amount fazla';
  }

  @override
  String percentTotal(String percent) {
    return 'Toplam %$percent (100 olmalı)';
  }

  @override
  String get scanReceipt => 'Fiş tara';

  @override
  String get takePhoto => 'Fotoğraf çek';

  @override
  String get chooseFromGallery => 'Galeriden seç';

  @override
  String get receiptScanning => 'Fiş okunuyor…';

  @override
  String get receiptScanned => 'Fiş okundu, bilgileri kontrol et.';

  @override
  String get receiptScanFailed =>
      'Fiş okunamadı; fotoğraf eklendi, bilgileri elle girebilirsin.';

  @override
  String get receiptTooLarge => 'Fotoğraf çok büyük (en fazla 5 MB).';

  @override
  String get receiptAttached => 'Fiş fotoğrafı eklendi';

  @override
  String receiptItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kalem okundu',
      one: '1 kalem okundu',
    );
    return '$_temp0';
  }

  @override
  String get removeReceipt => 'Fişi kaldır';

  @override
  String get receipt => 'Fiş';

  @override
  String get receiptItems => 'Fiş kalemleri';

  @override
  String get shoppingList => 'Alışveriş';

  @override
  String get addShoppingItemHint => 'Ne lazım? ör. süt, deterjan';

  @override
  String get emptyShoppingTitle => 'Liste boş';

  @override
  String get emptyShoppingBody =>
      'Eve lazım olanları ekleyin; alan kişi işaretlesin, herkes anında görsün.';

  @override
  String get addFirstItem => 'İlk kalemi ekle';

  @override
  String addedBy(String name) {
    return '$name ekledi';
  }

  @override
  String get boughtItems => 'Alınanlar';

  @override
  String get boughtItemsHelp =>
      'Seçili kalemleri tek bir Market gideri olarak ekleyebilirsin.';

  @override
  String boughtBy(String name) {
    return '$name aldı';
  }

  @override
  String get markNotBought => 'Alınmadı olarak işaretle';

  @override
  String addAsExpense(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kalemi gider olarak ekle',
      one: '1 kalemi gider olarak ekle',
    );
    return '$_temp0';
  }

  @override
  String get groceriesDescription => 'Market alışverişi';

  @override
  String get chores => 'Ev işleri';

  @override
  String get addChore => 'Görev ekle';

  @override
  String get editChore => 'Görevi düzenle';

  @override
  String get deleteChore => 'Görevi sil';

  @override
  String deleteChoreBody(String name) {
    return '\"$name\" görevi silinsin mi?';
  }

  @override
  String get choreName => 'Görev adı';

  @override
  String get choreNameHint => 'ör. Çöpleri çıkar';

  @override
  String get emptyChoresTitle => 'Görev yok';

  @override
  String get emptyChoresBody =>
      'Bulaşık, çöp, temizlik… Sırayı belirleyin, kimin günü geldiğini uygulama hatırlatsın.';

  @override
  String whoseTurn(String name) {
    return 'Sıra: $name';
  }

  @override
  String choreDueToday(String date) {
    return 'Zamanı geldi ($date)';
  }

  @override
  String choreDueOn(String date) {
    return 'Sonraki: $date';
  }

  @override
  String get markDone => 'Tamamlandı';

  @override
  String choreDoneNext(String name) {
    return 'Harika! Sıra artık $name kişisinde.';
  }

  @override
  String get firstDueDate => 'İlk tarih';

  @override
  String get rotationOrder => 'Sıra';

  @override
  String get rotationHelp =>
      'Kişilere sırayla dokun; seçim sırası, görev sırası olur.';

  @override
  String get frequencyDaily => 'Her gün';

  @override
  String get frequencyWeekly => 'Haftalık';

  @override
  String get frequencyBiweekly => 'İki haftada bir';

  @override
  String get frequencyMonthly => 'Aylık';

  @override
  String get recurringExpenses => 'Tekrarlayan';

  @override
  String get addRecurring => 'Tekrarlayan gider ekle';

  @override
  String get editRecurring => 'Tekrarlayan gideri düzenle';

  @override
  String get deleteRecurring => 'Şablonu sil';

  @override
  String deleteRecurringBody(String description) {
    return '\"$description\" şablonu silinsin mi? Daha önce oluşan giderler kalır.';
  }

  @override
  String get emptyRecurringTitle => 'Tekrarlayan gider yok';

  @override
  String get emptyRecurringBody =>
      'Kira gibi sabit giderler her ay otomatik eklenir; faturalar için tutar girmeniz hatırlatılır.';

  @override
  String get recurringHint => 'ör. Kira, İnternet faturası';

  @override
  String get fixedAmount => 'Sabit tutar';

  @override
  String get fixedAmountHelp => 'Gider o gün otomatik oluşur.';

  @override
  String get variableAmountHelp =>
      'O gün \"tutar bekleniyor\" taslağı oluşur, ödeyen kişiye bildirim gider.';

  @override
  String get variableAmount => 'Değişken tutar';

  @override
  String get variableNoExact =>
      'Değişken tutarda \"Tutar\" bölüşmesi kullanılamaz';

  @override
  String get schedule => 'Zamanlama';

  @override
  String get dayOfMonth => 'Ayın günü';

  @override
  String get dayOfMonthHelp =>
      'O gün olmayan aylarda ayın son günü kullanılır.';

  @override
  String get dayOfWeek => 'Haftanın günü';

  @override
  String nextRun(String date) {
    return 'Sonraki: $date';
  }

  @override
  String recurringFreeUsage(int used, int limit) {
    return 'Ücretsiz planda $used/$limit şablon kullanılıyor.';
  }

  @override
  String get activity => 'Etkinlik';

  @override
  String get noActivityTitle => 'Henüz etkinlik yok';

  @override
  String get noActivityBody =>
      'Giderler, ödemeler ve tamamlanan görevler burada görünür.';

  @override
  String activityHouseholdCreated(String actor) {
    return '$actor evi oluşturdu';
  }

  @override
  String activityMemberJoined(String actor) {
    return '$actor eve katıldı';
  }

  @override
  String activityMemberLeft(String actor) {
    return '$actor evden ayrıldı';
  }

  @override
  String activityMemberRemoved(String actor, String member) {
    return '$actor, $member kişisini evden çıkardı';
  }

  @override
  String activityExpenseAdded(String actor, String description, String amount) {
    return '$actor gider ekledi: $description ($amount)';
  }

  @override
  String activityExpenseEdited(String actor, String description) {
    return '$actor gideri düzenledi: $description';
  }

  @override
  String activityExpenseDeleted(
    String actor,
    String description,
    String amount,
  ) {
    return '$actor gideri sildi: $description ($amount)';
  }

  @override
  String activitySettlementAdded(String from, String to, String amount) {
    return 'Ödeme: $from → $to ($amount)';
  }

  @override
  String activitySettlementDeleted(
    String actor,
    String from,
    String to,
    String amount,
  ) {
    return '$actor bir ödemeyi sildi: $from → $to ($amount)';
  }

  @override
  String activityRecurringCreated(String description, String amount) {
    return 'Tekrarlayan gider eklendi: $description ($amount)';
  }

  @override
  String activityBillPending(String description) {
    return '$description faturası oluştu, tutar bekleniyor';
  }

  @override
  String activityChoreDone(String actor, String chore, String next) {
    return '$actor tamamladı: $chore. Sıra: $next';
  }

  @override
  String activityShoppingConverted(String actor, int count) {
    return '$actor, $count alışveriş kalemini gidere dönüştürdü';
  }

  @override
  String get activityUnknown => 'Evde bir değişiklik oldu';

  @override
  String get editProfile => 'Profili düzenle';

  @override
  String get avatar => 'Avatar';

  @override
  String get ibanOptional => 'IBAN (isteğe bağlı)';

  @override
  String get ibanHelp =>
      'Ev arkadaşların sana ödeme yaparken IBAN\'ını tek dokunuşla kopyalayabilir.';

  @override
  String get ibanInvalid => 'Geçerli bir IBAN gir';

  @override
  String get preferences => 'Tercihler';

  @override
  String get language => 'Dil';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get systemDefault => 'Sistem';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get notifyNewExpense => 'Yeni giderler';

  @override
  String get notifyReminders => 'Ödemeler ve hatırlatmalar';

  @override
  String get notifyBills => 'Tutar bekleyen faturalar';

  @override
  String get notifyChores => 'Ev işi sırası';

  @override
  String get data => 'Veriler';

  @override
  String get reports => 'Raporlar';

  @override
  String get exportCsv => 'CSV olarak dışa aktar';

  @override
  String csvSubject(String household) {
    return '$household giderleri';
  }

  @override
  String get proFeature => 'Pro özelliği';

  @override
  String get privacyPolicy => 'Gizlilik politikası';

  @override
  String get termsOfUse => 'Kullanım koşulları';

  @override
  String get deleteAccount => 'Hesabı sil';

  @override
  String get deleteAccountBody =>
      'Hesabın ve profil bilgilerin kalıcı olarak silinir, evlerden çıkarılırsın. Geçmiş giderlerde adın \"Silinmiş kullanıcı\" olarak görünür. Bu işlem geri alınamaz.';

  @override
  String get goPro => 'EvKasa Pro\'ya geç';

  @override
  String get goProBody =>
      'Sınırsız ev ve şablon, ayda 200 fiş okuma, tüm raporlar.';

  @override
  String get proActive => 'Pro etkin';

  @override
  String get proActiveBody => 'Evdeki herkes Pro özelliklerinden yararlanıyor.';

  @override
  String proActiveFor(String household) {
    return '\"$household\" evinde herkes Pro.';
  }

  @override
  String get proBadge => 'Pro';

  @override
  String get proTitle => 'EvKasa Pro';

  @override
  String get proSubtitle =>
      'Bir kişi alır, evdeki herkes kullanır. Aboneliği de bölüşün!';

  @override
  String get proFreeForever => 'Gider ekleme her planda sınırsız ve ücretsiz.';

  @override
  String get proBenefitHouseholds => 'Sınırsız ev';

  @override
  String get proBenefitRecurring => 'Sınırsız tekrarlayan gider şablonu';

  @override
  String proBenefitReceipts(int count) {
    return 'Ayda $count fiş okuma';
  }

  @override
  String get proBenefitReports =>
      'Tüm geçmişte kategori raporları ve aylık özet';

  @override
  String get proBenefitCsv => 'CSV dışa aktarma';

  @override
  String get proBenefitShared => 'Evdeki herkes için geçerli';

  @override
  String get planMonthly => 'Aylık';

  @override
  String get planAnnual => 'Yıllık';

  @override
  String trialDays(int days) {
    return '$days gün ücretsiz dene';
  }

  @override
  String savePercent(int percent) {
    return '%$percent tasarruf';
  }

  @override
  String get startTrial => 'Ücretsiz denemeyi başlat';

  @override
  String get subscribe => 'Abone ol';

  @override
  String get restorePurchases => 'Satın alımları geri yükle';

  @override
  String get restoreSuccess => 'Pro aboneliğin geri yüklendi.';

  @override
  String get restoreNothing => 'Geri yüklenecek bir abonelik bulunamadı.';

  @override
  String get storeUnavailable => 'Şu an bağlanılamıyor, tekrar dene';

  @override
  String get proWelcome => 'Pro\'ya hoş geldin! 🎉';

  @override
  String get subscriptionTerms =>
      'Abonelik, iptal edilmedikçe dönem sonunda otomatik yenilenir. Mağaza hesabının ayarlarından istediğin zaman iptal edebilirsin.';

  @override
  String get previousMonth => 'Önceki ay';

  @override
  String get nextMonth => 'Sonraki ay';

  @override
  String get reportsFreeLimit =>
      'Ücretsiz planda bu ay görünür; geçmiş aylar Pro\'da.';

  @override
  String get householdTotal => 'Ev toplamı';

  @override
  String get myShareTotal => 'Senin payın';

  @override
  String get noExpensesThisMonth => 'Bu ay gider yok.';
}
