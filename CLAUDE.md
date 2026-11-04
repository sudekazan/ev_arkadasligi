# Ödeşelim (ev_arkadasligi)
Ev arkadaşlarının kira, fatura ve market giderlerini adil bölüştüren uygulama. Paket kimliği `com.sudekazan.evarkadasligi`.
- Ürün, veri modeli, bölüşme algoritması ve mimari kararlar: PLAN.md. Otomatik yüklenmez; ilgili bölümü gerektiğinde oku.
- Elle yapılacak adımlar: docs/MANUAL_STEPS.md. Mağaza metinleri: docs/STORE_LISTING.md.

# Teknoloji
- Flutter + Riverpod, go_router, freezed + json_serializable.
- Firebase: Auth, Firestore, Storage, Functions, Messaging, Analytics, Crashlytics, App Check.
- Sunucu: `functions/` (TypeScript). Premium: RevenueCat (Pro).
- Dil: gen-l10n, `lib/l10n/app_tr.arb`, `app_en.arb`, `app_de.arb`.
- Yapı: `lib/core/money/` saf Dart para çekirdeği; `lib/features/*/` özellik başına `data/`, `domain/`, `presentation/`.

# Ortam
- `--dart-define` olmadan `demo-evkasa` demo projesine ve yerel emülatörlere bağlanır.
- Gerçek projeyle: `flutter run --dart-define-from-file=env/dev.json`. Prod Firebase projesi: `odeselimapp`.

# Komutlar
```bash
flutter test
npm --prefix functions test
firebase emulators:exec --project demo-evkasa-rules --only firestore,storage "npm --prefix functions run test:rules"
dart run build_runner build --delete-conflicting-outputs   # freezed modeli değişince
```
GitHub'a her gönderimde testler Actions'ta çalışır (`.github/workflows/test.yml`).

# Kurallar
- Para her zaman kuruş cinsinden `int`; `double` kullanma.
- Kullanıcı metni yalnızca ARB dosyalarından gelir; yeni metni üç dile de ekle.
- Depo herkese açık: `google-services.json`, `GoogleService-Info.plist`, gerçek `firebase_options`, `env/*.json` depoya girmez.
- Simge değiştirdikten sonra `flutter_launcher_icons` iOS'ta `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS` ayarını bozuyor; `project.pbxproj` dosyasındaki bu değişikliği geri al.
- Commit mesajları Türkçe, kısa ve anlaşılır olsun. Başına `fix:`, `feat:`, `düzeltme:` gibi ön ek konmaz. Örnek: `Harcama bölme ekranını sadeleştir`

# Son kararlar
- 2026-10-26: Gider ekleme hiçbir planda sınırlanmaz (pazarlamanın ana mesajı).
- 2026-10-26: Ev sayısı limiti kullanıcının kendi aboneliğine bakar (`users.proUntil`); evin Pro olması ek ev hakkı vermez.
- 2026-10-31: Fiş yapay zekâya gitmeden önce bir kez izin isteniyor (App Store 5.1.2).
- 2026-10-31: Almanca eklendi. iOS'ta şimdilik yalnızca iPhone.
- 2026-11-03: App Review notları Guideline 2.1 yanıtı için genişletildi (`docs/`).
- 2026-11-04: Pro fiyatı aylık 79,99 ₺, yıllık 549,99 ₺ (mağaza panelinden; koda yazılmaz).
- 2026-11-04: Fiş okuma OpenRouter üzerinden Gemini ile kalıyor; gizlilik metni ve inceleme notu bunu açıkça yazar.
- 2026-11-04: Sunucu Pro durumunu RevenueCat REST API'sine sorar (`REVENUECAT_API_KEY`); webhook yalnızca tetikleyicidir.
