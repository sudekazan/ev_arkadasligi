import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'EvKasa'**
  String get appName;

  /// No description provided for @tabHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfa'**
  String get tabHome;

  /// No description provided for @tabExpenses.
  ///
  /// In tr, this message translates to:
  /// **'Giderler'**
  String get tabExpenses;

  /// No description provided for @tabHouse.
  ///
  /// In tr, this message translates to:
  /// **'Ev'**
  String get tabHouse;

  /// No description provided for @tabAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get tabAccount;

  /// No description provided for @add.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get add;

  /// No description provided for @back.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get clear;

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @copy.
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In tr, this message translates to:
  /// **'Kopyalandı'**
  String get copied;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get edit;

  /// No description provided for @next.
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get next;

  /// No description provided for @ok.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get ok;

  /// No description provided for @or.
  ///
  /// In tr, this message translates to:
  /// **'veya'**
  String get or;

  /// No description provided for @remove.
  ///
  /// In tr, this message translates to:
  /// **'Çıkar'**
  String get remove;

  /// No description provided for @retry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get retry;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @share.
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get share;

  /// No description provided for @skip.
  ///
  /// In tr, this message translates to:
  /// **'Geç'**
  String get skip;

  /// No description provided for @seeAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get seeAll;

  /// No description provided for @requiredField.
  ///
  /// In tr, this message translates to:
  /// **'Bu alan zorunlu'**
  String get requiredField;

  /// No description provided for @you.
  ///
  /// In tr, this message translates to:
  /// **'Sen'**
  String get you;

  /// No description provided for @youSuffix.
  ///
  /// In tr, this message translates to:
  /// **'{name} (sen)'**
  String youSuffix(String name);

  /// No description provided for @unknownMember.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmeyen üye'**
  String get unknownMember;

  /// No description provided for @deletedUser.
  ///
  /// In tr, this message translates to:
  /// **'Silinmiş kullanıcı'**
  String get deletedUser;

  /// No description provided for @admin.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici'**
  String get admin;

  /// No description provided for @errorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Şu an bağlanılamıyor, tekrar dene.'**
  String get errorNetwork;

  /// No description provided for @errorPermission.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için yetkin yok.'**
  String get errorPermission;

  /// No description provided for @errorNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Aradığın kayıt bulunamadı.'**
  String get errorNotFound;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In tr, this message translates to:
  /// **'E-posta veya şifre hatalı.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailInUse.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta ile zaten bir hesap var.'**
  String get errorEmailInUse;

  /// No description provided for @errorWeakPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az 6 karakter olmalı.'**
  String get errorWeakPassword;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta adresi gir.'**
  String get errorInvalidEmail;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla deneme yapıldı, biraz sonra tekrar dene.'**
  String get errorTooManyRequests;

  /// No description provided for @errorCancelled.
  ///
  /// In tr, this message translates to:
  /// **'İşlem iptal edildi.'**
  String get errorCancelled;

  /// No description provided for @errorRequiresRecentLogin.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik için çıkış yapıp tekrar giriş yapmalısın.'**
  String get errorRequiresRecentLogin;

  /// No description provided for @errorHouseholdLimit.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz planda tek eve üye olabilirsin. Daha fazlası için Pro\'ya geç.'**
  String get errorHouseholdLimit;

  /// No description provided for @errorHouseholdFull.
  ///
  /// In tr, this message translates to:
  /// **'Bu ev dolu (en fazla 12 üye).'**
  String get errorHouseholdFull;

  /// No description provided for @errorInviteInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Davet kodu geçersiz. Kodu kontrol et.'**
  String get errorInviteInvalid;

  /// No description provided for @errorBalanceNotZero.
  ///
  /// In tr, this message translates to:
  /// **'Bakiye sıfır değil. Önce ödeşmeniz gerekiyor.'**
  String get errorBalanceNotZero;

  /// No description provided for @errorReceiptQuota.
  ///
  /// In tr, this message translates to:
  /// **'Bu ayki fiş okuma hakkın doldu.'**
  String get errorReceiptQuota;

  /// No description provided for @errorReceiptUnreadable.
  ///
  /// In tr, this message translates to:
  /// **'Fiş okunamadı.'**
  String get errorReceiptUnreadable;

  /// No description provided for @errorReminderAlreadySent.
  ///
  /// In tr, this message translates to:
  /// **'Bugün bu kişiye zaten hatırlatma gönderdin.'**
  String get errorReminderAlreadySent;

  /// No description provided for @errorNothingOwed.
  ///
  /// In tr, this message translates to:
  /// **'Bu kişinin borcu yok.'**
  String get errorNothingOwed;

  /// No description provided for @errorUnknown.
  ///
  /// In tr, this message translates to:
  /// **'Bir şeyler ters gitti, tekrar dene.'**
  String get errorUnknown;

  /// No description provided for @welcomeTitle1.
  ///
  /// In tr, this message translates to:
  /// **'Giderleri tek yerde topla'**
  String get welcomeTitle1;

  /// No description provided for @welcomeBody1.
  ///
  /// In tr, this message translates to:
  /// **'Kira, faturalar ve market alışverişini ekle; kim ne ödedi hep belli olsun.'**
  String get welcomeBody1;

  /// No description provided for @welcomeTitle2.
  ///
  /// In tr, this message translates to:
  /// **'Kuruşu kuruşuna adil'**
  String get welcomeTitle2;

  /// No description provided for @welcomeBody2.
  ///
  /// In tr, this message translates to:
  /// **'Eşit, tutar, yüzde veya oda büyüklüğüne göre bölüş; borçlar en az transferle sadeleşsin.'**
  String get welcomeBody2;

  /// No description provided for @welcomeTitle3.
  ///
  /// In tr, this message translates to:
  /// **'Ev işleri de burada'**
  String get welcomeTitle3;

  /// No description provided for @welcomeBody3.
  ///
  /// In tr, this message translates to:
  /// **'Ortak alışveriş listesi ve \"sıra kimde\" takibi. Gider eklemek her zaman ücretsiz ve sınırsız.'**
  String get welcomeBody3;

  /// No description provided for @getStarted.
  ///
  /// In tr, this message translates to:
  /// **'Başla'**
  String get getStarted;

  /// No description provided for @pageIndicator.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa {current} / {total}'**
  String pageIndicator(int current, int total);

  /// No description provided for @authSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Ev arkadaşlarınla masrafları adilce bölüş.'**
  String get authSubtitle;

  /// No description provided for @signIn.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get signIn;

  /// No description provided for @register.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt ol'**
  String get register;

  /// No description provided for @signOut.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get signOut;

  /// No description provided for @yourName.
  ///
  /// In tr, this message translates to:
  /// **'Adın'**
  String get yourName;

  /// No description provided for @email.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get email;

  /// No description provided for @password.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get password;

  /// No description provided for @showPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi göster'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi gizle'**
  String get hidePassword;

  /// No description provided for @forgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi unuttum'**
  String get forgotPassword;

  /// No description provided for @enterEmailFirst.
  ///
  /// In tr, this message translates to:
  /// **'Önce e-posta adresini yaz.'**
  String get enterEmailFirst;

  /// No description provided for @passwordResetSent.
  ///
  /// In tr, this message translates to:
  /// **'Şifre sıfırlama bağlantısı e-postana gönderildi.'**
  String get passwordResetSent;

  /// No description provided for @continueWithGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile devam et'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In tr, this message translates to:
  /// **'Apple ile devam et'**
  String get continueWithApple;

  /// No description provided for @onboardingTitle.
  ///
  /// In tr, this message translates to:
  /// **'Evini kur'**
  String get onboardingTitle;

  /// No description provided for @onboardingBody.
  ///
  /// In tr, this message translates to:
  /// **'Yeni bir ev oluştur ya da ev arkadaşının paylaştığı 6 haneli kodla katıl.'**
  String get onboardingBody;

  /// No description provided for @createHousehold.
  ///
  /// In tr, this message translates to:
  /// **'Ev oluştur'**
  String get createHousehold;

  /// No description provided for @joinWithCode.
  ///
  /// In tr, this message translates to:
  /// **'Kodla katıl'**
  String get joinWithCode;

  /// No description provided for @join.
  ///
  /// In tr, this message translates to:
  /// **'Katıl'**
  String get join;

  /// No description provided for @householdName.
  ///
  /// In tr, this message translates to:
  /// **'Ev adı'**
  String get householdName;

  /// No description provided for @householdNameHint.
  ///
  /// In tr, this message translates to:
  /// **'ör. Moda\'daki ev'**
  String get householdNameHint;

  /// No description provided for @currency.
  ///
  /// In tr, this message translates to:
  /// **'Para birimi'**
  String get currency;

  /// No description provided for @inviteCode.
  ///
  /// In tr, this message translates to:
  /// **'Davet kodu'**
  String get inviteCode;

  /// No description provided for @inviteCodeLength.
  ///
  /// In tr, this message translates to:
  /// **'Kod 6 karakter olmalı'**
  String get inviteCodeLength;

  /// No description provided for @inviteCodeSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Davet kodu: {code}'**
  String inviteCodeSemantics(String code);

  /// No description provided for @inviteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Evin hazır!'**
  String get inviteTitle;

  /// No description provided for @inviteBody.
  ///
  /// In tr, this message translates to:
  /// **'Ev arkadaşlarını davet et: bu kodu paylaş, uygulamada \"Kodla katıl\" ile girsinler.'**
  String get inviteBody;

  /// No description provided for @inviteShareText.
  ///
  /// In tr, this message translates to:
  /// **'EvKasa\'da evimize katıl! Uygulamayı aç, \"Kodla katıl\"a dokun ve şu kodu gir: {code}'**
  String inviteShareText(String code);

  /// No description provided for @continueToHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfaya geç'**
  String get continueToHome;

  /// No description provided for @regenerateCode.
  ///
  /// In tr, this message translates to:
  /// **'Kodu yenile'**
  String get regenerateCode;

  /// No description provided for @regenerateCodeBody.
  ///
  /// In tr, this message translates to:
  /// **'Eski kod çalışmayı bırakır. Yeni kodu ev arkadaşlarınla tekrar paylaşman gerekir.'**
  String get regenerateCodeBody;

  /// No description provided for @addHousehold.
  ///
  /// In tr, this message translates to:
  /// **'Başka bir ev ekle'**
  String get addHousehold;

  /// No description provided for @myHouseholds.
  ///
  /// In tr, this message translates to:
  /// **'Evlerim'**
  String get myHouseholds;

  /// No description provided for @switchHousehold.
  ///
  /// In tr, this message translates to:
  /// **'Ev değiştir'**
  String get switchHousehold;

  /// No description provided for @houseSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ev ayarları'**
  String get houseSettings;

  /// No description provided for @editHousehold.
  ///
  /// In tr, this message translates to:
  /// **'Evi düzenle'**
  String get editHousehold;

  /// No description provided for @membersCount.
  ///
  /// In tr, this message translates to:
  /// **'Üyeler ({count}/{max})'**
  String membersCount(int count, int max);

  /// No description provided for @rentWeightHelp.
  ///
  /// In tr, this message translates to:
  /// **'Kira payı: kira giderleri bu ağırlıklara göre bölünür (ör. büyük oda 3, küçük oda 2).'**
  String get rentWeightHelp;

  /// No description provided for @rentWeightValue.
  ///
  /// In tr, this message translates to:
  /// **'Kira payı: {weight}'**
  String rentWeightValue(int weight);

  /// No description provided for @decreaseRentWeight.
  ///
  /// In tr, this message translates to:
  /// **'{name} için kira payını azalt'**
  String decreaseRentWeight(String name);

  /// No description provided for @increaseRentWeight.
  ///
  /// In tr, this message translates to:
  /// **'{name} için kira payını artır'**
  String increaseRentWeight(String name);

  /// No description provided for @removeMember.
  ///
  /// In tr, this message translates to:
  /// **'Üyeyi çıkar'**
  String get removeMember;

  /// No description provided for @removeMemberBody.
  ///
  /// In tr, this message translates to:
  /// **'{name} evden çıkarılsın mı?'**
  String removeMemberBody(String name);

  /// No description provided for @cannotRemoveTitle.
  ///
  /// In tr, this message translates to:
  /// **'Önce ödeşilmeli'**
  String get cannotRemoveTitle;

  /// No description provided for @cannotRemoveBody.
  ///
  /// In tr, this message translates to:
  /// **'{name} kişisinin bakiyesi {amount}. Bakiye sıfırlanmadan çıkarılamaz.'**
  String cannotRemoveBody(String name, String amount);

  /// No description provided for @leaveHousehold.
  ///
  /// In tr, this message translates to:
  /// **'Evden ayrıl'**
  String get leaveHousehold;

  /// No description provided for @leave.
  ///
  /// In tr, this message translates to:
  /// **'Ayrıl'**
  String get leave;

  /// No description provided for @leaveHouseholdBody.
  ///
  /// In tr, this message translates to:
  /// **'\"{household}\" evinden ayrılmak istediğine emin misin?'**
  String leaveHouseholdBody(String household);

  /// No description provided for @cannotLeaveTitle.
  ///
  /// In tr, this message translates to:
  /// **'Önce ödeşmelisin'**
  String get cannotLeaveTitle;

  /// No description provided for @cannotLeaveBody.
  ///
  /// In tr, this message translates to:
  /// **'Bakiyen {amount}. Evden ayrılmadan önce bakiyenin sıfır olması gerekiyor.'**
  String cannotLeaveBody(String amount);

  /// No description provided for @inviteHousemates.
  ///
  /// In tr, this message translates to:
  /// **'Ev arkadaşlarını davet et'**
  String get inviteHousemates;

  /// No description provided for @allSettled.
  ///
  /// In tr, this message translates to:
  /// **'Hesaplar denk, kimsenin kimseye borcu yok.'**
  String get allSettled;

  /// No description provided for @youOweOne.
  ///
  /// In tr, this message translates to:
  /// **'{name} {amount} borçlusun'**
  String youOweOne(String name, String amount);

  /// No description provided for @youOweTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam {amount} borçlusun'**
  String youOweTotal(String amount);

  /// No description provided for @owesYouOne.
  ///
  /// In tr, this message translates to:
  /// **'{name} sana {amount} borçlu'**
  String owesYouOne(String name, String amount);

  /// No description provided for @theyOweYouTotal.
  ///
  /// In tr, this message translates to:
  /// **'Sana {amount} borçlular'**
  String theyOweYouTotal(String amount);

  /// No description provided for @statusOwe.
  ///
  /// In tr, this message translates to:
  /// **'Borçlusun'**
  String get statusOwe;

  /// No description provided for @statusOwed.
  ///
  /// In tr, this message translates to:
  /// **'Alacaklısın'**
  String get statusOwed;

  /// No description provided for @statusSettled.
  ///
  /// In tr, this message translates to:
  /// **'Ödeşmiş'**
  String get statusSettled;

  /// No description provided for @whoOwesWhom.
  ///
  /// In tr, this message translates to:
  /// **'Kim kime borçlu'**
  String get whoOwesWhom;

  /// No description provided for @transferLine.
  ///
  /// In tr, this message translates to:
  /// **'{from} → {to}'**
  String transferLine(String from, String to);

  /// No description provided for @pay.
  ///
  /// In tr, this message translates to:
  /// **'Öde'**
  String get pay;

  /// No description provided for @remind.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlat'**
  String get remind;

  /// No description provided for @reminderSent.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatma gönderildi.'**
  String get reminderSent;

  /// No description provided for @pendingBills.
  ///
  /// In tr, this message translates to:
  /// **'Tutar bekleyen faturalar'**
  String get pendingBills;

  /// No description provided for @enterAmount.
  ///
  /// In tr, this message translates to:
  /// **'Tutarı gir'**
  String get enterAmount;

  /// No description provided for @recentPayments.
  ///
  /// In tr, this message translates to:
  /// **'Son ödemeler'**
  String get recentPayments;

  /// No description provided for @disputePayment.
  ///
  /// In tr, this message translates to:
  /// **'Ödemeye itiraz et'**
  String get disputePayment;

  /// No description provided for @disputePaymentBody.
  ///
  /// In tr, this message translates to:
  /// **'{amount} tutarındaki ödeme kaydı silinsin mi? Bakiye buna göre güncellenir.'**
  String disputePaymentBody(String amount);

  /// No description provided for @recentActivity.
  ///
  /// In tr, this message translates to:
  /// **'Son etkinlikler'**
  String get recentActivity;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlk gideri ekle'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir gider eklediğinde kimin kime borçlu olduğu burada görünür.'**
  String get homeEmptyBody;

  /// No description provided for @recordPayment.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme kaydet'**
  String get recordPayment;

  /// No description provided for @from.
  ///
  /// In tr, this message translates to:
  /// **'Kimden'**
  String get from;

  /// No description provided for @to.
  ///
  /// In tr, this message translates to:
  /// **'Kime'**
  String get to;

  /// No description provided for @partialPaymentHint.
  ///
  /// In tr, this message translates to:
  /// **'Tamamını ya da bir kısmını ödeyebilirsin.'**
  String get partialPaymentHint;

  /// No description provided for @recipientIban.
  ///
  /// In tr, this message translates to:
  /// **'{name} IBAN'**
  String recipientIban(String name);

  /// No description provided for @copyIban.
  ///
  /// In tr, this message translates to:
  /// **'IBAN\'ı kopyala'**
  String get copyIban;

  /// No description provided for @ibanCopied.
  ///
  /// In tr, this message translates to:
  /// **'IBAN kopyalandı'**
  String get ibanCopied;

  /// No description provided for @noIbanYet.
  ///
  /// In tr, this message translates to:
  /// **'{name} henüz IBAN eklememiş.'**
  String noIbanYet(String name);

  /// No description provided for @markAsPaid.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme yapıldı'**
  String get markAsPaid;

  /// No description provided for @paymentRecorded.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme kaydedildi.'**
  String get paymentRecorded;

  /// No description provided for @samePersonError.
  ///
  /// In tr, this message translates to:
  /// **'Kimden ve kime aynı kişi olamaz'**
  String get samePersonError;

  /// No description provided for @paymentMustInvolveYou.
  ///
  /// In tr, this message translates to:
  /// **'Yalnızca kendi ödemelerini kaydedebilirsin'**
  String get paymentMustInvolveYou;

  /// No description provided for @addExpense.
  ///
  /// In tr, this message translates to:
  /// **'Gider ekle'**
  String get addExpense;

  /// No description provided for @editExpense.
  ///
  /// In tr, this message translates to:
  /// **'Gideri düzenle'**
  String get editExpense;

  /// No description provided for @enterBillAmount.
  ///
  /// In tr, this message translates to:
  /// **'Fatura tutarını gir'**
  String get enterBillAmount;

  /// No description provided for @description.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get description;

  /// No description provided for @amount.
  ///
  /// In tr, this message translates to:
  /// **'Tutar'**
  String get amount;

  /// No description provided for @paidBy.
  ///
  /// In tr, this message translates to:
  /// **'Ödeyen'**
  String get paidBy;

  /// No description provided for @category.
  ///
  /// In tr, this message translates to:
  /// **'Kategori'**
  String get category;

  /// No description provided for @date.
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get date;

  /// No description provided for @split.
  ///
  /// In tr, this message translates to:
  /// **'Bölüşme'**
  String get split;

  /// No description provided for @note.
  ///
  /// In tr, this message translates to:
  /// **'Not'**
  String get note;

  /// No description provided for @noteOptional.
  ///
  /// In tr, this message translates to:
  /// **'Not (isteğe bağlı)'**
  String get noteOptional;

  /// No description provided for @shares.
  ///
  /// In tr, this message translates to:
  /// **'Paylar'**
  String get shares;

  /// No description provided for @enterValidAmount.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir tutar gir'**
  String get enterValidAmount;

  /// No description provided for @fixSplitFirst.
  ///
  /// In tr, this message translates to:
  /// **'Bölüşme toplamı tutmuyor'**
  String get fixSplitFirst;

  /// No description provided for @paidByOn.
  ///
  /// In tr, this message translates to:
  /// **'{name} ödedi · {date}'**
  String paidByOn(String name, String date);

  /// No description provided for @yourShare.
  ///
  /// In tr, this message translates to:
  /// **'Payın {amount}'**
  String yourShare(String amount);

  /// No description provided for @pendingAmount.
  ///
  /// In tr, this message translates to:
  /// **'Tutar bekleniyor'**
  String get pendingAmount;

  /// No description provided for @splitTypeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bölüşme: {type}'**
  String splitTypeLabel(String type);

  /// No description provided for @searchExpenses.
  ///
  /// In tr, this message translates to:
  /// **'Giderlerde ara'**
  String get searchExpenses;

  /// No description provided for @allCategories.
  ///
  /// In tr, this message translates to:
  /// **'Tüm kategoriler'**
  String get allCategories;

  /// No description provided for @everyone.
  ///
  /// In tr, this message translates to:
  /// **'Herkes'**
  String get everyone;

  /// No description provided for @noExpensesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz gider yok'**
  String get noExpensesTitle;

  /// No description provided for @noExpensesBody.
  ///
  /// In tr, this message translates to:
  /// **'Kira, fatura veya market: ilk ortak gideri ekleyin.'**
  String get noExpensesBody;

  /// No description provided for @noResultsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç yok'**
  String get noResultsTitle;

  /// No description provided for @noResultsBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu filtrelerle eşleşen gider bulunamadı.'**
  String get noResultsBody;

  /// No description provided for @clearFilters.
  ///
  /// In tr, this message translates to:
  /// **'Filtreleri temizle'**
  String get clearFilters;

  /// No description provided for @deleteExpense.
  ///
  /// In tr, this message translates to:
  /// **'Gideri sil'**
  String get deleteExpense;

  /// No description provided for @deleteExpenseBody.
  ///
  /// In tr, this message translates to:
  /// **'\"{description}\" kalıcı olarak silinsin mi?'**
  String deleteExpenseBody(String description);

  /// No description provided for @expenseNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Gider bulunamadı'**
  String get expenseNotFound;

  /// No description provided for @expenseNotFoundBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu gider silinmiş olabilir.'**
  String get expenseNotFoundBody;

  /// No description provided for @categoryRent.
  ///
  /// In tr, this message translates to:
  /// **'Kira'**
  String get categoryRent;

  /// No description provided for @categoryElectricity.
  ///
  /// In tr, this message translates to:
  /// **'Elektrik'**
  String get categoryElectricity;

  /// No description provided for @categoryWater.
  ///
  /// In tr, this message translates to:
  /// **'Su'**
  String get categoryWater;

  /// No description provided for @categoryGas.
  ///
  /// In tr, this message translates to:
  /// **'Doğalgaz'**
  String get categoryGas;

  /// No description provided for @categoryInternet.
  ///
  /// In tr, this message translates to:
  /// **'İnternet'**
  String get categoryInternet;

  /// No description provided for @categoryGroceries.
  ///
  /// In tr, this message translates to:
  /// **'Market'**
  String get categoryGroceries;

  /// No description provided for @categoryCleaning.
  ///
  /// In tr, this message translates to:
  /// **'Temizlik'**
  String get categoryCleaning;

  /// No description provided for @categoryHomeGoods.
  ///
  /// In tr, this message translates to:
  /// **'Ev eşyası'**
  String get categoryHomeGoods;

  /// No description provided for @categoryOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get categoryOther;

  /// No description provided for @splitEqual.
  ///
  /// In tr, this message translates to:
  /// **'Eşit'**
  String get splitEqual;

  /// No description provided for @splitExact.
  ///
  /// In tr, this message translates to:
  /// **'Tutar'**
  String get splitExact;

  /// No description provided for @splitPercent.
  ///
  /// In tr, this message translates to:
  /// **'Yüzde'**
  String get splitPercent;

  /// No description provided for @splitShares.
  ///
  /// In tr, this message translates to:
  /// **'Pay'**
  String get splitShares;

  /// No description provided for @sharesSuffix.
  ///
  /// In tr, this message translates to:
  /// **'pay'**
  String get sharesSuffix;

  /// No description provided for @splitNoParticipants.
  ///
  /// In tr, this message translates to:
  /// **'En az bir kişi seç'**
  String get splitNoParticipants;

  /// No description provided for @splitInvalidNumber.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz sayı var'**
  String get splitInvalidNumber;

  /// No description provided for @splitMissing.
  ///
  /// In tr, this message translates to:
  /// **'{amount} eksik'**
  String splitMissing(String amount);

  /// No description provided for @splitExcess.
  ///
  /// In tr, this message translates to:
  /// **'{amount} fazla'**
  String splitExcess(String amount);

  /// No description provided for @percentTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam %{percent} (100 olmalı)'**
  String percentTotal(String percent);

  /// No description provided for @scanReceipt.
  ///
  /// In tr, this message translates to:
  /// **'Fiş tara'**
  String get scanReceipt;

  /// No description provided for @takePhoto.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf çek'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden seç'**
  String get chooseFromGallery;

  /// No description provided for @receiptScanning.
  ///
  /// In tr, this message translates to:
  /// **'Fiş okunuyor…'**
  String get receiptScanning;

  /// No description provided for @receiptScanned.
  ///
  /// In tr, this message translates to:
  /// **'Fiş okundu, bilgileri kontrol et.'**
  String get receiptScanned;

  /// No description provided for @receiptScanFailed.
  ///
  /// In tr, this message translates to:
  /// **'Fiş okunamadı; fotoğraf eklendi, bilgileri elle girebilirsin.'**
  String get receiptScanFailed;

  /// No description provided for @receiptTooLarge.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf çok büyük (en fazla 5 MB).'**
  String get receiptTooLarge;

  /// No description provided for @receiptAttached.
  ///
  /// In tr, this message translates to:
  /// **'Fiş fotoğrafı eklendi'**
  String get receiptAttached;

  /// No description provided for @receiptItemCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{1 kalem okundu} other{{count} kalem okundu}}'**
  String receiptItemCount(int count);

  /// No description provided for @removeReceipt.
  ///
  /// In tr, this message translates to:
  /// **'Fişi kaldır'**
  String get removeReceipt;

  /// No description provided for @receipt.
  ///
  /// In tr, this message translates to:
  /// **'Fiş'**
  String get receipt;

  /// No description provided for @receiptItems.
  ///
  /// In tr, this message translates to:
  /// **'Fiş kalemleri'**
  String get receiptItems;

  /// No description provided for @shoppingList.
  ///
  /// In tr, this message translates to:
  /// **'Alışveriş'**
  String get shoppingList;

  /// No description provided for @addShoppingItemHint.
  ///
  /// In tr, this message translates to:
  /// **'Ne lazım? ör. süt, deterjan'**
  String get addShoppingItemHint;

  /// No description provided for @emptyShoppingTitle.
  ///
  /// In tr, this message translates to:
  /// **'Liste boş'**
  String get emptyShoppingTitle;

  /// No description provided for @emptyShoppingBody.
  ///
  /// In tr, this message translates to:
  /// **'Eve lazım olanları ekleyin; alan kişi işaretlesin, herkes anında görsün.'**
  String get emptyShoppingBody;

  /// No description provided for @addFirstItem.
  ///
  /// In tr, this message translates to:
  /// **'İlk kalemi ekle'**
  String get addFirstItem;

  /// No description provided for @addedBy.
  ///
  /// In tr, this message translates to:
  /// **'{name} ekledi'**
  String addedBy(String name);

  /// No description provided for @boughtItems.
  ///
  /// In tr, this message translates to:
  /// **'Alınanlar'**
  String get boughtItems;

  /// No description provided for @boughtItemsHelp.
  ///
  /// In tr, this message translates to:
  /// **'Seçili kalemleri tek bir Market gideri olarak ekleyebilirsin.'**
  String get boughtItemsHelp;

  /// No description provided for @boughtBy.
  ///
  /// In tr, this message translates to:
  /// **'{name} aldı'**
  String boughtBy(String name);

  /// No description provided for @markNotBought.
  ///
  /// In tr, this message translates to:
  /// **'Alınmadı olarak işaretle'**
  String get markNotBought;

  /// No description provided for @addAsExpense.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{1 kalemi gider olarak ekle} other{{count} kalemi gider olarak ekle}}'**
  String addAsExpense(int count);

  /// No description provided for @groceriesDescription.
  ///
  /// In tr, this message translates to:
  /// **'Market alışverişi'**
  String get groceriesDescription;

  /// No description provided for @chores.
  ///
  /// In tr, this message translates to:
  /// **'Ev işleri'**
  String get chores;

  /// No description provided for @addChore.
  ///
  /// In tr, this message translates to:
  /// **'Görev ekle'**
  String get addChore;

  /// No description provided for @editChore.
  ///
  /// In tr, this message translates to:
  /// **'Görevi düzenle'**
  String get editChore;

  /// No description provided for @deleteChore.
  ///
  /// In tr, this message translates to:
  /// **'Görevi sil'**
  String get deleteChore;

  /// No description provided for @deleteChoreBody.
  ///
  /// In tr, this message translates to:
  /// **'\"{name}\" görevi silinsin mi?'**
  String deleteChoreBody(String name);

  /// No description provided for @choreName.
  ///
  /// In tr, this message translates to:
  /// **'Görev adı'**
  String get choreName;

  /// No description provided for @choreNameHint.
  ///
  /// In tr, this message translates to:
  /// **'ör. Çöpleri çıkar'**
  String get choreNameHint;

  /// No description provided for @emptyChoresTitle.
  ///
  /// In tr, this message translates to:
  /// **'Görev yok'**
  String get emptyChoresTitle;

  /// No description provided for @emptyChoresBody.
  ///
  /// In tr, this message translates to:
  /// **'Bulaşık, çöp, temizlik… Sırayı belirleyin, kimin günü geldiğini uygulama hatırlatsın.'**
  String get emptyChoresBody;

  /// No description provided for @whoseTurn.
  ///
  /// In tr, this message translates to:
  /// **'Sıra: {name}'**
  String whoseTurn(String name);

  /// No description provided for @choreDueToday.
  ///
  /// In tr, this message translates to:
  /// **'Zamanı geldi ({date})'**
  String choreDueToday(String date);

  /// No description provided for @choreDueOn.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki: {date}'**
  String choreDueOn(String date);

  /// No description provided for @markDone.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get markDone;

  /// No description provided for @choreDoneNext.
  ///
  /// In tr, this message translates to:
  /// **'Harika! Sıra artık {name} kişisinde.'**
  String choreDoneNext(String name);

  /// No description provided for @firstDueDate.
  ///
  /// In tr, this message translates to:
  /// **'İlk tarih'**
  String get firstDueDate;

  /// No description provided for @rotationOrder.
  ///
  /// In tr, this message translates to:
  /// **'Sıra'**
  String get rotationOrder;

  /// No description provided for @rotationHelp.
  ///
  /// In tr, this message translates to:
  /// **'Kişilere sırayla dokun; seçim sırası, görev sırası olur.'**
  String get rotationHelp;

  /// No description provided for @frequencyDaily.
  ///
  /// In tr, this message translates to:
  /// **'Her gün'**
  String get frequencyDaily;

  /// No description provided for @frequencyWeekly.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık'**
  String get frequencyWeekly;

  /// No description provided for @frequencyBiweekly.
  ///
  /// In tr, this message translates to:
  /// **'İki haftada bir'**
  String get frequencyBiweekly;

  /// No description provided for @frequencyMonthly.
  ///
  /// In tr, this message translates to:
  /// **'Aylık'**
  String get frequencyMonthly;

  /// No description provided for @recurringExpenses.
  ///
  /// In tr, this message translates to:
  /// **'Tekrarlayan'**
  String get recurringExpenses;

  /// No description provided for @addRecurring.
  ///
  /// In tr, this message translates to:
  /// **'Tekrarlayan gider ekle'**
  String get addRecurring;

  /// No description provided for @editRecurring.
  ///
  /// In tr, this message translates to:
  /// **'Tekrarlayan gideri düzenle'**
  String get editRecurring;

  /// No description provided for @deleteRecurring.
  ///
  /// In tr, this message translates to:
  /// **'Şablonu sil'**
  String get deleteRecurring;

  /// No description provided for @deleteRecurringBody.
  ///
  /// In tr, this message translates to:
  /// **'\"{description}\" şablonu silinsin mi? Daha önce oluşan giderler kalır.'**
  String deleteRecurringBody(String description);

  /// No description provided for @emptyRecurringTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tekrarlayan gider yok'**
  String get emptyRecurringTitle;

  /// No description provided for @emptyRecurringBody.
  ///
  /// In tr, this message translates to:
  /// **'Kira gibi sabit giderler her ay otomatik eklenir; faturalar için tutar girmeniz hatırlatılır.'**
  String get emptyRecurringBody;

  /// No description provided for @recurringHint.
  ///
  /// In tr, this message translates to:
  /// **'ör. Kira, İnternet faturası'**
  String get recurringHint;

  /// No description provided for @fixedAmount.
  ///
  /// In tr, this message translates to:
  /// **'Sabit tutar'**
  String get fixedAmount;

  /// No description provided for @fixedAmountHelp.
  ///
  /// In tr, this message translates to:
  /// **'Gider o gün otomatik oluşur.'**
  String get fixedAmountHelp;

  /// No description provided for @variableAmountHelp.
  ///
  /// In tr, this message translates to:
  /// **'O gün \"tutar bekleniyor\" taslağı oluşur, ödeyen kişiye bildirim gider.'**
  String get variableAmountHelp;

  /// No description provided for @variableAmount.
  ///
  /// In tr, this message translates to:
  /// **'Değişken tutar'**
  String get variableAmount;

  /// No description provided for @variableNoExact.
  ///
  /// In tr, this message translates to:
  /// **'Değişken tutarda \"Tutar\" bölüşmesi kullanılamaz'**
  String get variableNoExact;

  /// No description provided for @schedule.
  ///
  /// In tr, this message translates to:
  /// **'Zamanlama'**
  String get schedule;

  /// No description provided for @dayOfMonth.
  ///
  /// In tr, this message translates to:
  /// **'Ayın günü'**
  String get dayOfMonth;

  /// No description provided for @dayOfMonthHelp.
  ///
  /// In tr, this message translates to:
  /// **'O gün olmayan aylarda ayın son günü kullanılır.'**
  String get dayOfMonthHelp;

  /// No description provided for @dayOfWeek.
  ///
  /// In tr, this message translates to:
  /// **'Haftanın günü'**
  String get dayOfWeek;

  /// No description provided for @nextRun.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki: {date}'**
  String nextRun(String date);

  /// No description provided for @recurringFreeUsage.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz planda {used}/{limit} şablon kullanılıyor.'**
  String recurringFreeUsage(int used, int limit);

  /// No description provided for @activity.
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik'**
  String get activity;

  /// No description provided for @noActivityTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz etkinlik yok'**
  String get noActivityTitle;

  /// No description provided for @noActivityBody.
  ///
  /// In tr, this message translates to:
  /// **'Giderler, ödemeler ve tamamlanan görevler burada görünür.'**
  String get noActivityBody;

  /// No description provided for @activityHouseholdCreated.
  ///
  /// In tr, this message translates to:
  /// **'{actor} evi oluşturdu'**
  String activityHouseholdCreated(String actor);

  /// No description provided for @activityMemberJoined.
  ///
  /// In tr, this message translates to:
  /// **'{actor} eve katıldı'**
  String activityMemberJoined(String actor);

  /// No description provided for @activityMemberLeft.
  ///
  /// In tr, this message translates to:
  /// **'{actor} evden ayrıldı'**
  String activityMemberLeft(String actor);

  /// No description provided for @activityMemberRemoved.
  ///
  /// In tr, this message translates to:
  /// **'{actor}, {member} kişisini evden çıkardı'**
  String activityMemberRemoved(String actor, String member);

  /// No description provided for @activityExpenseAdded.
  ///
  /// In tr, this message translates to:
  /// **'{actor} gider ekledi: {description} ({amount})'**
  String activityExpenseAdded(String actor, String description, String amount);

  /// No description provided for @activityExpenseEdited.
  ///
  /// In tr, this message translates to:
  /// **'{actor} gideri düzenledi: {description}'**
  String activityExpenseEdited(String actor, String description);

  /// No description provided for @activityExpenseDeleted.
  ///
  /// In tr, this message translates to:
  /// **'{actor} gideri sildi: {description} ({amount})'**
  String activityExpenseDeleted(
    String actor,
    String description,
    String amount,
  );

  /// No description provided for @activitySettlementAdded.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme: {from} → {to} ({amount})'**
  String activitySettlementAdded(String from, String to, String amount);

  /// No description provided for @activitySettlementDeleted.
  ///
  /// In tr, this message translates to:
  /// **'{actor} bir ödemeyi sildi: {from} → {to} ({amount})'**
  String activitySettlementDeleted(
    String actor,
    String from,
    String to,
    String amount,
  );

  /// No description provided for @activityRecurringCreated.
  ///
  /// In tr, this message translates to:
  /// **'Tekrarlayan gider eklendi: {description} ({amount})'**
  String activityRecurringCreated(String description, String amount);

  /// No description provided for @activityBillPending.
  ///
  /// In tr, this message translates to:
  /// **'{description} faturası oluştu, tutar bekleniyor'**
  String activityBillPending(String description);

  /// No description provided for @activityChoreDone.
  ///
  /// In tr, this message translates to:
  /// **'{actor} tamamladı: {chore}. Sıra: {next}'**
  String activityChoreDone(String actor, String chore, String next);

  /// No description provided for @activityShoppingConverted.
  ///
  /// In tr, this message translates to:
  /// **'{actor}, {count} alışveriş kalemini gidere dönüştürdü'**
  String activityShoppingConverted(String actor, int count);

  /// No description provided for @activityUnknown.
  ///
  /// In tr, this message translates to:
  /// **'Evde bir değişiklik oldu'**
  String get activityUnknown;

  /// No description provided for @editProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profili düzenle'**
  String get editProfile;

  /// No description provided for @avatar.
  ///
  /// In tr, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @ibanOptional.
  ///
  /// In tr, this message translates to:
  /// **'IBAN (isteğe bağlı)'**
  String get ibanOptional;

  /// No description provided for @ibanHelp.
  ///
  /// In tr, this message translates to:
  /// **'Ev arkadaşların sana ödeme yaparken IBAN\'ını tek dokunuşla kopyalayabilir.'**
  String get ibanHelp;

  /// No description provided for @ibanInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir IBAN gir'**
  String get ibanInvalid;

  /// No description provided for @preferences.
  ///
  /// In tr, this message translates to:
  /// **'Tercihler'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get themeDark;

  /// No description provided for @systemDefault.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get systemDefault;

  /// No description provided for @notifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notifications;

  /// No description provided for @notifyNewExpense.
  ///
  /// In tr, this message translates to:
  /// **'Yeni giderler'**
  String get notifyNewExpense;

  /// No description provided for @notifyReminders.
  ///
  /// In tr, this message translates to:
  /// **'Ödemeler ve hatırlatmalar'**
  String get notifyReminders;

  /// No description provided for @notifyBills.
  ///
  /// In tr, this message translates to:
  /// **'Tutar bekleyen faturalar'**
  String get notifyBills;

  /// No description provided for @notifyChores.
  ///
  /// In tr, this message translates to:
  /// **'Ev işi sırası'**
  String get notifyChores;

  /// No description provided for @data.
  ///
  /// In tr, this message translates to:
  /// **'Veriler'**
  String get data;

  /// No description provided for @reports.
  ///
  /// In tr, this message translates to:
  /// **'Raporlar'**
  String get reports;

  /// No description provided for @exportCsv.
  ///
  /// In tr, this message translates to:
  /// **'CSV olarak dışa aktar'**
  String get exportCsv;

  /// No description provided for @csvSubject.
  ///
  /// In tr, this message translates to:
  /// **'{household} giderleri'**
  String csvSubject(String household);

  /// No description provided for @proFeature.
  ///
  /// In tr, this message translates to:
  /// **'Pro özelliği'**
  String get proFeature;

  /// No description provided for @privacyPolicy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik politikası'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım koşulları'**
  String get termsOfUse;

  /// No description provided for @deleteAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabı sil'**
  String get deleteAccount;

  /// No description provided for @deleteAccountBody.
  ///
  /// In tr, this message translates to:
  /// **'Hesabın ve profil bilgilerin kalıcı olarak silinir, evlerden çıkarılırsın. Geçmiş giderlerde adın \"Silinmiş kullanıcı\" olarak görünür. Bu işlem geri alınamaz.'**
  String get deleteAccountBody;

  /// No description provided for @goPro.
  ///
  /// In tr, this message translates to:
  /// **'EvKasa Pro\'ya geç'**
  String get goPro;

  /// No description provided for @goProBody.
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız ev ve şablon, ayda 200 fiş okuma, tüm raporlar.'**
  String get goProBody;

  /// No description provided for @proActive.
  ///
  /// In tr, this message translates to:
  /// **'Pro etkin'**
  String get proActive;

  /// No description provided for @proActiveBody.
  ///
  /// In tr, this message translates to:
  /// **'Evdeki herkes Pro özelliklerinden yararlanıyor.'**
  String get proActiveBody;

  /// No description provided for @proActiveFor.
  ///
  /// In tr, this message translates to:
  /// **'\"{household}\" evinde herkes Pro.'**
  String proActiveFor(String household);

  /// No description provided for @proBadge.
  ///
  /// In tr, this message translates to:
  /// **'Pro'**
  String get proBadge;

  /// No description provided for @proTitle.
  ///
  /// In tr, this message translates to:
  /// **'EvKasa Pro'**
  String get proTitle;

  /// No description provided for @proSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bir kişi alır, evdeki herkes kullanır. Aboneliği de bölüşün!'**
  String get proSubtitle;

  /// No description provided for @proFreeForever.
  ///
  /// In tr, this message translates to:
  /// **'Gider ekleme her planda sınırsız ve ücretsiz.'**
  String get proFreeForever;

  /// No description provided for @proBenefitHouseholds.
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız ev'**
  String get proBenefitHouseholds;

  /// No description provided for @proBenefitRecurring.
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız tekrarlayan gider şablonu'**
  String get proBenefitRecurring;

  /// No description provided for @proBenefitReceipts.
  ///
  /// In tr, this message translates to:
  /// **'Ayda {count} fiş okuma'**
  String proBenefitReceipts(int count);

  /// No description provided for @proBenefitReports.
  ///
  /// In tr, this message translates to:
  /// **'Tüm geçmişte kategori raporları ve aylık özet'**
  String get proBenefitReports;

  /// No description provided for @proBenefitCsv.
  ///
  /// In tr, this message translates to:
  /// **'CSV dışa aktarma'**
  String get proBenefitCsv;

  /// No description provided for @proBenefitShared.
  ///
  /// In tr, this message translates to:
  /// **'Evdeki herkes için geçerli'**
  String get proBenefitShared;

  /// No description provided for @planMonthly.
  ///
  /// In tr, this message translates to:
  /// **'Aylık'**
  String get planMonthly;

  /// No description provided for @planAnnual.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık'**
  String get planAnnual;

  /// No description provided for @trialDays.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün ücretsiz dene'**
  String trialDays(int days);

  /// No description provided for @savePercent.
  ///
  /// In tr, this message translates to:
  /// **'%{percent} tasarruf'**
  String savePercent(int percent);

  /// No description provided for @startTrial.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz denemeyi başlat'**
  String get startTrial;

  /// No description provided for @subscribe.
  ///
  /// In tr, this message translates to:
  /// **'Abone ol'**
  String get subscribe;

  /// No description provided for @restorePurchases.
  ///
  /// In tr, this message translates to:
  /// **'Satın alımları geri yükle'**
  String get restorePurchases;

  /// No description provided for @restoreSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Pro aboneliğin geri yüklendi.'**
  String get restoreSuccess;

  /// No description provided for @restoreNothing.
  ///
  /// In tr, this message translates to:
  /// **'Geri yüklenecek bir abonelik bulunamadı.'**
  String get restoreNothing;

  /// No description provided for @storeUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Şu an bağlanılamıyor, tekrar dene'**
  String get storeUnavailable;

  /// No description provided for @proWelcome.
  ///
  /// In tr, this message translates to:
  /// **'Pro\'ya hoş geldin! 🎉'**
  String get proWelcome;

  /// No description provided for @subscriptionTerms.
  ///
  /// In tr, this message translates to:
  /// **'Abonelik, iptal edilmedikçe dönem sonunda otomatik yenilenir. Mağaza hesabının ayarlarından istediğin zaman iptal edebilirsin.'**
  String get subscriptionTerms;

  /// No description provided for @previousMonth.
  ///
  /// In tr, this message translates to:
  /// **'Önceki ay'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki ay'**
  String get nextMonth;

  /// No description provided for @reportsFreeLimit.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz planda bu ay görünür; geçmiş aylar Pro\'da.'**
  String get reportsFreeLimit;

  /// No description provided for @householdTotal.
  ///
  /// In tr, this message translates to:
  /// **'Ev toplamı'**
  String get householdTotal;

  /// No description provided for @myShareTotal.
  ///
  /// In tr, this message translates to:
  /// **'Senin payın'**
  String get myShareTotal;

  /// No description provided for @noExpensesThisMonth.
  ///
  /// In tr, this message translates to:
  /// **'Bu ay gider yok.'**
  String get noExpensesThisMonth;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
