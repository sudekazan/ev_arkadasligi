# Elle yapılacak adımlar

Bu adımlar konsol erişimi, hesap veya ödeme gerektirdiği için kodla yapılamaz. Sırayla ilerle: her bölüm bir öncekinin çıktısını kullanır. Bitirdiğin maddeyi `[x]` yap.

Uygulama bu adımlar olmadan da `demo-evkasa` projesi ve Firebase Emulator ile tamamen çalışır (bkz. [README](../README.md)).

## 0. Yerel geliştirme ortamı

- [ ] **Java 21 veya üstü kur.** `firebase-tools` artık Java 17 ile emulator başlatmıyor. En kolayı `brew install openjdk@21`; ya da Android Studio'nun içindeki JDK'yı kullan:
  ```bash
  export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
  ```
- [ ] Emulator'ın ve testlerin çalıştığını doğrula (README'deki komutlar).

## 1. Uygulama adı

- [ ] Uygulama adı **Ödeşelim** olarak belirlendi ve kodda güncellendi. Adın App Store ve Google Play'de boşta olduğunu kontrol et. Yeniden değişirse `lib/l10n/app_*.arb` içindeki `appName`, `ios/Runner/Info.plist` içindeki `CFBundleDisplayName`, `android/app/src/main/AndroidManifest.xml` içindeki `android:label`, `hosting/public/*.html` ve `docs/STORE_LISTING.md` güncellenmeli. İstersen bunu bana yaptırabilirsin.

## 2. Firebase `dev` projesi

- [ ] [Firebase konsolunda](https://console.firebase.google.com) `odeselim-dev` gibi bir proje oluştur. Google Analytics'i aç.
- [ ] **Blaze (kullandıkça öde) planına geç.** Cloud Functions, zamanlanmış görevler ve gizli anahtarlar Blaze ister. Google Cloud'da düşük tutarlı bir **bütçe uyarısı** kur.
- [ ] **Authentication → Sign-in method:** E-posta/Şifre, Google ve Apple'ı etkinleştir (Apple için 5. bölüme bak).
- [ ] **Firestore:** üretim modunda, konum `europe-west1` olarak oluştur.
- [ ] **Storage:** varsayılan kovayı aynı bölgede oluştur.
- [ ] **Uygulamaları kaydet:**
  - Android: paket adı `com.sudekazan.evarkadasligi`. Debug SHA-1 ve SHA-256 değerlerini ekle (`cd android && ./gradlew signingReport`); sürüm anahtarı oluşunca (7. bölüm) onunkileri de ekle.
  - iOS: bundle ID `com.sudekazan.evarkadasligi`.
- [ ] `google-services.json` dosyasını `android/app/`, `GoogleService-Info.plist` dosyasını `ios/Runner/` altına koy. İkisi de git'e girmez (`.gitignore`'da).
- [ ] `env/dev.example.json` dosyasını `env/dev.json` olarak kopyala ve doldur (bu dosya da git'e girmez):

  | Alan | Nereden |
  | --- | --- |
  | `FIREBASE_PROJECT_ID` | Proje ayarları → Proje kimliği |
  | `FIREBASE_MESSAGING_SENDER_ID` | Proje ayarları → Cloud Messaging → Gönderen kimliği |
  | `FIREBASE_STORAGE_BUCKET` | Storage sayfasının üstündeki `gs://` adresi (`gs://` olmadan) |
  | `FIREBASE_ANDROID_API_KEY`, `FIREBASE_ANDROID_APP_ID` | `google-services.json` → `api_key.current_key`, `mobilesdk_app_id` |
  | `FIREBASE_IOS_API_KEY`, `FIREBASE_IOS_APP_ID`, `FIREBASE_IOS_CLIENT_ID` | `GoogleService-Info.plist` → `API_KEY`, `GOOGLE_APP_ID`, `CLIENT_ID` |
  | `REVENUECAT_*_KEY` | 8. bölüm |

- [ ] **iOS'ta Google girişi için URL şeması:** Xcode'da *Runner → Info → URL Types* altına `GoogleService-Info.plist` içindeki `REVERSED_CLIENT_ID` değerini ekle. Ya da bu değeri bana ver, ben ekleyeyim.
- [ ] `.firebaserc` dosyasına dev projesini ekle:
  ```bash
  firebase use --add
  ```
- [ ] Kuralları, indeksleri, fonksiyonları ve Hosting'i yükle:
  ```bash
  firebase deploy --only firestore,storage,functions,hosting
  ```
- [ ] **Analytics veri saklama süresi:** Analytics → Yönetici → Veri saklama → **14 ay**. Gizlilik politikası bu süreyi yazıyor; varsayılan 2 aydır.
- [ ] Uygulamayı gerçek projeyle çalıştır:
  ```bash
  flutter run --dart-define-from-file=env/dev.json
  ```

## 3. Bildirimler (FCM)

- [ ] [Apple Developer](https://developer.apple.com/account/resources/authkeys/list) → Keys bölümünde **Apple Push Notifications service (APNs)** anahtarı oluştur. `.p8` dosyasını, Key ID ve Team ID (`75W22TJ5MZ`) ile birlikte Firebase → Proje ayarları → Cloud Messaging → Apple uygulama yapılandırmasına yükle.
- [ ] Gerçek bir iPhone'da gider ekleyerek diğer üyeye bildirim geldiğini doğrula. Simülatör push almaz.

## 4. App Check

- [ ] Firebase → App Check:
  - Android'i **Play Integrity** ile kaydet (önce uygulama Play Console'da olmalı, 7. bölüm).
  - iOS'u **App Attest** ile kaydet; DeviceCheck yedeği için DeviceCheck anahtarını da yükle.
- [ ] Debug derlemelerde konsola yazılan **debug token**'ı App Check → Uygulamalar → Debug token'ları yönet bölümüne ekle; yoksa debug derlemede fiş okuma reddedilir.
- [ ] Bir hafta metrikleri izledikten sonra Storage ve Firestore için **zorunlu kıl**. `scanReceipt` zaten App Check istiyor.

## 5. Apple ile Giriş

Kodu ve `ios/Runner/Runner.entitlements` hazır. Gerekenler:

- [ ] Apple Developer → Identifiers → `com.sudekazan.evarkadasligi` için **Sign in with Apple** ve **Push Notifications** yeteneklerini aç. **App Attest** de açık olmalı.
- [ ] Xcode'da Runner hedefini açıp *Signing & Capabilities* sekmesinde hata olmadığını kontrol et; otomatik imzalama profili yeni yetenekleri içerecek şekilde yeniler.
- [ ] Firebase → Authentication → Apple sağlayıcısında Services ID, Team ID, Key ID ve özel anahtarı gir. Bu bilgiler yalnızca web ve Android'de Apple girişi için gerekir; iOS'ta yerel giriş bunlarsız çalışır.

## 6. Fiş okuma sağlayıcısı

- [ ] Sağlayıcıyı seç. Varsayılan **Gemini** (`gemini-2.5-flash`); OpenRouter da destekleniyor.
- [ ] Anahtarı al ([Google AI Studio](https://aistudio.google.com/apikey) veya OpenRouter) ve gizli anahtar olarak kaydet:
  ```bash
  firebase functions:secrets:set RECEIPT_API_KEY
  ```
- [ ] Varsayılanı değiştirmek istersen `functions/.env.<proje-id>` dosyasına `RECEIPT_PROVIDER=openrouter` ve `RECEIPT_MODEL=<model>` yaz. Bu dosyada sır yok, git'e girebilir; anahtar yalnızca secret olarak tutulur.
- [ ] Fonksiyonları yeniden yükle ve gerçek bir fişle dene:
  ```bash
  firebase deploy --only functions
  ```

## 7. Mağaza hesapları ve imzalama

- [ ] **Apple Developer Program** üyeliği (yıllık ücretli) ve App Store Connect'te `com.sudekazan.evarkadasligi` ile uygulama kaydı.
- [ ] **Google Play Console** geliştirici hesabı ve uygulama kaydı.
- [ ] **Android yükleme anahtarı:**
  ```bash
  keytool -genkey -v -keystore ~/odeselim-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
  ```
  `android/key.properties` dosyasını oluştur (git'e girmez):
  ```
  storeFile=/Users/sude/odeselim-upload.jks
  storePassword=...
  keyAlias=upload
  keyPassword=...
  ```
  Anahtarı ve şifreleri güvenli bir yere yedekle. Play App Signing'i aç ve SHA-1/SHA-256 değerlerini Firebase'e ekle.
- [ ] Mağaza kayıtlarını `docs/STORE_LISTING.md` dosyasındaki metinlerle doldur: açıklamalar, anahtar kelimeler, gizlilik etiketleri ve Veri güvenliği formu.
- [ ] Gizlilik ve koşul sayfalarındaki `[İLETİŞİM E-POSTASI]` / `[CONTACT EMAIL]` yer tutucularını gerçek destek adresiyle değiştir. Metinler bir şablon; yayından önce hukuki açıdan gözden geçirilmesi önerilir.
- [ ] Ekran görüntüleri: 6,9" iPhone ve Android telefon için TR ve EN.

## 8. Abonelik (RevenueCat)

- [ ] **Mağaza ürünleri:**
  - App Store Connect → Abonelikler: `odeselim_pro` grubu altında `odeselim_pro_monthly` ve `odeselim_pro_yearly`. Yıllık pakette 7 günlük ücretsiz deneme olsun.
  - Play Console → Abonelikler: aynı kimliklerle iki ürün; yıllıkta 7 günlük deneme teklifi.
  - Fiyat: Türkiye fiyat seviyesinden seç, yıllık ≈ aylık × 7. Uygulama fiyatı mağazadan okur.
- [ ] [RevenueCat](https://app.revenuecat.com)'te proje oluştur, iOS ve Android uygulamalarını bağla (App Store Connect API anahtarı ve Play servis hesabı gerekir).
- [ ] Entitlement kimliği tam olarak **`pro`** olmalı; iki ürünü de buna bağla.
- [ ] Varsayılan (*current*) offering'e **Monthly** ve **Annual** paketlerini ekle.
- [ ] Genel SDK anahtarlarını `env/dev.json` → `REVENUECAT_IOS_KEY` / `REVENUECAT_ANDROID_KEY` alanlarına yaz.
- [ ] **Webhook:**
  1. Uzun, rastgele bir gizli değer üret ve kaydet:
     ```bash
     firebase functions:secrets:set REVENUECAT_WEBHOOK_SECRET
     ```
  2. RevenueCat → Integrations → Webhooks: URL `https://europe-west1-<proje-id>.cloudfunctions.net/revenueCatWebhook`, Authorization başlığı `Bearer <gizli değer>`.
  3. Fonksiyonları yeniden yükle.
- [ ] Sandbox (iOS) ve lisanslı test hesabı (Android) ile satın alma, deneme, iptal ve geri yüklemeyi dene. `users/{uid}.proUntil` alanının dolduğunu kontrol et.

## 9. `prod` ortamı

- [ ] 2. bölümü `odeselim-prod` adlı ikinci bir projeyle tekrarla ve değerleri `env/prod.json` dosyasına yaz. `APP_ENV` değeri `prod`, `USE_EMULATOR` değeri `false` olmalı.
- [ ] `prod` için ayrı gizli anahtarlar (3, 4, 6 ve 8. bölümler) ve ayrı RevenueCat webhook'u tanımla.
- [ ] Sürüm derlemeleri:
  ```bash
  flutter build appbundle --dart-define-from-file=env/prod.json
  ```
  ```bash
  flutter build ipa --dart-define-from-file=env/prod.json
  ```
- [ ] Önce TestFlight ve Play dahili test kanalına yükle, gerçek cihazlarda deneyip sonra incelemeye gönder.

## Yayından önce son kontrol

- [ ] Gizlilik ve koşul sayfaları `https://<prod-proje>.web.app/privacy` ve `/terms` adreslerinde açılıyor; uygulamadaki Hesap sekmesinden ulaşılabiliyor.
- [ ] Hesap silme gerçek projede çalışıyor (Apple ve Google bunu zorunlu tutuyor).
- [ ] Crashlytics'te bir test çökmesi görünüyor; Analytics'te `expense_added` olayı geliyor.
- [ ] Bütçe uyarısı ve fiş okuma kotaları (ücretsiz 5, Pro 200) beklenen şekilde çalışıyor.
