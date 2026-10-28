# Ödeşelim

Ev arkadaşlarının kira, fatura ve market giderlerini adil bölüştüren Flutter + Firebase uygulaması. Ürün ve mimari kararları [PLAN.md](PLAN.md) dosyasında.

## Gereksinimler

- Flutter (kararlı kanal), Xcode ve/veya Android Studio
- Node.js 22 ve `firebase-tools`
- **Java 21+**: Firebase Emulator için gerekli. Android Studio'nun JDK'sı da olur:
  ```bash
  export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
  ```

## Yerelde çalıştırma (gerçek Firebase projesi gerekmez)

Uygulama `--dart-define` verilmeden açılırsa `demo-evkasa` demo projesine ve yerel emulator'lara bağlanır.

```bash
cd functions && npm install && npm run build && cd ..
```

```bash
firebase emulators:start --project demo-evkasa
```

```bash
flutter run
```

Emulator arayüzü: http://localhost:4000. Android emulator'ü bilgisayara `10.0.2.2` üzerinden bağlanır; gerçek telefon için `env/emulator.example.json` dosyasındaki `EMULATOR_HOST` alanına bilgisayarın yerel IP'sini yazıp `--dart-define-from-file` ile ver.

Gerçek projeyle çalıştırmak için [docs/MANUAL_STEPS.md](docs/MANUAL_STEPS.md) dosyasını izle, ardından:

```bash
flutter run --dart-define-from-file=env/dev.json
```

## Testler

GitHub'a her gönderimde aşağıdaki testlerin hepsi (entegrasyon testi hariç) GitHub Actions'ta otomatik çalışır: `.github/workflows/test.yml`. Sonuçlar reponun **Actions** sekmesinde.

Birim ve widget testleri (para çekirdeği T1–T10, gider ekleme, ödeme kaydetme):

```bash
flutter test
```

Cloud Functions birim testleri:

```bash
npm --prefix functions test
```

Firestore ve Storage güvenlik kuralları:

```bash
firebase emulators:exec --project demo-evkasa-rules --only firestore,storage "npm --prefix functions run test:rules"
```

Entegrasyon testi (ev oluştur → gider ekle → bakiye gör). Emulator'lar açıkken ve bir simülatör çalışırken:

```bash
flutter test integration_test -d <simülatör-kimliği>
```

## Proje yapısı

| Klasör | İçerik |
| --- | --- |
| `lib/core/money/` | Bölüşme, bakiye ve borç sadeleştirme (saf Dart, kuruş cinsinden `int`) |
| `lib/features/*/` | Özellik başına `data/`, `domain/`, `presentation/` |
| `lib/l10n/` | `tr` ve `en` çeviri dosyaları |
| `functions/` | TypeScript Cloud Functions ve testleri |
| `hosting/public/` | Gizlilik politikası ve kullanım koşulları |
| `docs/` | Elle yapılacak adımlar, mağaza metinleri |
| `tool/make_icons.py` | Uygulama simgesini ve açılış görselini çizer |

Simgeyi değiştirdikten sonra:

```bash
python3 tool/make_icons.py
```

```bash
dart run flutter_launcher_icons && dart run flutter_native_splash:create
```

`flutter_launcher_icons` iOS projesinde `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS` ayarını yanlışlıkla değiştiriyor; komuttan sonra `ios/Runner.xcodeproj/project.pbxproj` dosyasındaki bu değişikliği geri al.
