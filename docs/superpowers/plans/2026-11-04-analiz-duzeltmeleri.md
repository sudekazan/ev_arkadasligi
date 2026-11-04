# Analiz düzeltmeleri — uygulama planı

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Amaç:** 4 Kasım 2026 analiz raporundaki hata, güvenlik, gelir takibi ve revizyon maddelerini kapatmak. Yeni özellikler bu planda yok; onları Sude ile tek tek konuşacağız.

**Mimari:** Sunucu düzeltmeleri `functions/src/` ve `firestore.rules` içinde, saf yardımcı fonksiyonlar birim testli. Uygulama düzeltmeleri mevcut ekranlara küçük eklemeler; yeni metinler üç ARB dosyasına. RevenueCat'in REST API'si Pro durumunun tek doğru kaynağı olur.

**Teknoloji:** Flutter + Riverpod, Firebase (Auth, Firestore, Functions v2, Storage), TypeScript + vitest, RevenueCat REST API v1.

**Spec:** [Ödeşelim uygulama analizi](https://claude.ai/artifact/2pzNhQnSrWjpbUEzDJx4M4)

## Genel kurallar

- Para her zaman kuruş cinsinden `int`; `double` kullanılmaz (mağaza fiyatı bile önce kuruşa çevrilir).
- Kullanıcıya görünen her yeni metin `lib/l10n/app_tr.arb`, `app_en.arb`, `app_de.arb` dosyalarının üçüne de eklenir.
- Commit mesajı Türkçe, kısa, emir kipinde, öneksiz: `Evden ayrılan üyeyi ev işi sıralarından çıkar`.
- Her görevden sonra commit + push. `firebase deploy` öncesi her seferinde Sude'ye sorulur.
- Yerelde yalnızca `flutter analyze`, değişen test dosyası (`flutter test test/<dosya>`), `npm --prefix functions run lint` ve ilgili vitest dosyası çalışır. Tam test takımı ve kural testleri GitHub Actions'ta.
- Gizli dosyalara (`env/*.json`, `*.plist`, `google-services.json`, anahtarlar) dokunulmaz; içerikleri yazdırılmaz.
- Yeni paket eklenmez. Build numarası Sude'ye sorulmadan değişmez.

## Kararlar (4 Kasım 2026)

- Pro fiyatı **79,99 ₺ aylık, 549,99 ₺ yıllık**. App Store Connect'te Sude ayarlar; koda fiyat yazılmaz.
- Fiş okuma **OpenRouter** üzerinden kalır; gizlilik metni ve inceleme notu OpenRouter ile Google'ı açıkça yazar.
- Sunucu Pro durumunu RevenueCat'e sorar; Sude gizli bir API anahtarı oluşturur (`REVENUECAT_API_KEY`).
- Başarısız davet kodu denemesi saatte en çok 10 (Görev 6), okunamayan fiş günde en çok 20 (Görev 7).

## Dikkat edilecek durumlar

1. Ana sayfada silinmiş bir kullanıcıya "Öde"ye basılınca ödeme ekranı çökmeden o kişiyi seçili açmalı (Görev 2'nin widget testi).
2. Pro satın alındıktan hemen sonra 2. ev kurulabilmeli, webhook gelmemiş olsa bile (Görev 4'te `userIsProFresh`).
3. Tek kişilik bir ev işi sırasındaki kişi ayrılınca sıra boş kalmalı, uygulama ve hatırlatma çökmemeli (Görev 3'ün `['a']` testi).
4. RevenueCat API'si hata verirse webhook 500 dönmeli ki RevenueCat yeniden denesin; `proUntil` değişmemeli (Görev 4).
5. Bakiyesi olan biri hesabını silmek isteyince evler ve tutarlar listelenmeli, "Yine de sil" çalışmalı (Görev 5'in widget testi).

---

## Bölüm A — İncelemeye gönderilmeden önce

### Görev 1: Fiş sağlayıcısı, fiyat ve elle adımlar belgelere

**Dosyalar:**
- Değiştir: `hosting/public/privacy.html` ("Hizmet sağlayıcılar" altındaki yapay zekâ satırı)
- Değiştir: `docs/STORE_LISTING.md` ("EXTERNAL SERVICES USED" içindeki Cloud Functions satırı)
- Değiştir: `docs/MANUAL_STEPS.md` (8. bölümdeki fiyat satırı; yeni "Analiz sonrası elle adımlar" bölümü)

- [ ] **Adım 1:** Gizlilik metnindeki satırı şöyle yaz: fotoğraf sunucumuz aracılığıyla OpenRouter'a, oradan Google'ın Gemini modeline yalnızca okuma için gider; model eğitiminde kullanılmaz. "Saklama ve silme" bölümüne ekle: hesap silinince yüklenen fiş fotoğrafları ev arkadaşlarının giderleri bozulmasın diye evde kalır; ev boşalınca silinir.
- [ ] **Adım 2:** İnceleme notunda "relays receipt photos to Google's Gemini API" ifadesini "relays receipt photos through OpenRouter to Google's Gemini model (gemini-2.5-flash)" yap.
- [ ] **Adım 3:** `MANUAL_STEPS.md` fiyatını "aylık 79,99 ₺, yıllık 549,99 ₺ + 1 hafta deneme" yap. Yeni bölüme şu adımları ekle: App Store Connect fiyatları; Firebase Authentication'da Apple sağlayıcısı; prod App Check'te App Attest ve Xcode hata ayıklama anahtarı; prod APNs anahtarı; RevenueCat gizli API anahtarı (`firebase functions:secrets:set REVENUECAT_API_KEY --project odeselimapp`, dev için de); RevenueCat → Firebase entegrasyonu; sandbox satın almadan sonra `proUntil` kontrolü; ekran kaydını TestFlight sürümüyle çekmek.
- [ ] **Adım 4:** Doğrula: `grep -n "OpenRouter" hosting/public/privacy.html docs/STORE_LISTING.md` iki dosyada da sonuç verir; `grep -n "29,99" docs/MANUAL_STEPS.md` sonuç vermez.
- [ ] **Adım 5:** Commit: `Fiş sağlayıcısını ve yeni fiyatları belgelere yaz`. Hosting deploy için Sude'ye sor (`firebase deploy --only hosting --project odeselimapp`).

---

## Bölüm B — Kullanıcı hataları ve güvenlik (sunucu)

### Görev 2: Silinmiş üyeyle bakiye kapatma

**Dosyalar:**
- Değiştir: `firestore.rules` (settlements create; expenses update)
- Değiştir: `lib/features/household/data/household_repository.dart` (yeni provider)
- Değiştir: `lib/features/balances/presentation/settle_screen.dart:91` (`activeMembersProvider` yerine yeni provider)
- Test: `functions/test/rules/firestore.rules.test.ts`, `test/features/settle_screen_test.dart`

**Arayüzler:**
- Üretir: `final settleCandidatesProvider = Provider<List<Member>>` — aktif üyeler + `deleted == true` olup `netBalancesProvider` içinde bakiyesi 0 olmayan üyeler.

- [ ] **Adım 1: Kural testlerini yaz** (`describe("deleted members")`):
  - `settlement to a deleted member succeeds` — `members/gone` `{deleted: true}`, `gone` `memberIds` içinde değil; alice'ten gone'a ödeme `assertSucceeds`.
  - `settlement to a departed (not deleted) member fails` — `{active: false}` → `assertFails`.
  - `editing an old expense that keeps a deleted participant succeeds` — shares `{alice, gone}` olan gideri yalnızca açıklama değiştirerek güncelle → `assertSucceeds`.
  - `adding a deleted member to a new expense fails` → `assertFails`.
- [ ] **Adım 2:** Kurallarda `function isDeletedMember(hid, uid) { return get(/databases/$(database)/documents/households/$(hid)/members/$(uid)).data.get('deleted', false) == true; }` ekle. Settlement'ta `fromUid`/`toUid` için `in memberIds || isDeletedMember(...)`. Gider güncellemede `shares.keys()` yeni anahtarlar için `memberIds`, eski anahtarlar için `resource.data.shares.keys()` kabul edilsin (`toSet().difference(...)`); `paidBy` ya üye ya da `resource.data.paidBy`.
- [ ] **Adım 3: Widget testini yaz** — `deleted member with a balance can be picked as recipient`: `SettleScreen(toUid: 'gone')`, `gone` silinmiş ve alacaklı; ekran hatasız açılır, alıcıda `l.deletedUser` görünür.
- [ ] **Adım 4:** `settleCandidatesProvider`'ı yaz ve `settle_screen.dart`'ta kullan; silinmiş üyenin adı `l.deletedUser`.
- [ ] **Adım 5:** `flutter analyze`, `flutter test test/features/settle_screen_test.dart`, `npm --prefix functions run lint` geçer.
- [ ] **Adım 6:** Commit: `Silinmiş üyeyle bakiye kapatmaya izin ver`.

### Görev 3: Ayrılan üyeyi ev işi sıralarından çıkar

**Dosyalar:**
- Değiştir: `functions/src/chores.ts` (saf fonksiyon)
- Değiştir: `functions/src/household.ts` (`detachMember` işlemi)
- Test: `functions/test/unit/chores.test.ts` (yeni)

**Arayüzler:**
- Üretir: `export function dropFromRotation(rotation: string[], currentIndex: number, uid: string): { rotation: string[]; currentIndex: number }`

- [ ] **Adım 1: Testleri yaz** — `(['a','b','c'], 1, 'b')` → `{['a','c'], 1}`; `(['a','b','c'], 2, 'a')` → `{['b','c'], 1}`; `(['a','b','c'], 0, 'c')` → `{['a','b'], 0}`; `(['a','b','c'], 2, 'c')` → `{['a','b'], 0}`; `(['a'], 0, 'a')` → `{[], 0}`; `uid` yoksa girdi aynen döner.
- [ ] **Adım 2:** `npm --prefix functions test -- test/unit/chores.test.ts` — FAIL.
- [ ] **Adım 3:** `dropFromRotation`'ı yaz. `detachMember` işleminde, yazmalardan önce `tx.get(hRef.collection("chores").where("rotation", "array-contains", uid))` oku ve her belgeyi sonuçla güncelle.
- [ ] **Adım 4:** Test PASS, `npm --prefix functions run lint` geçer.
- [ ] **Adım 5:** Commit: `Evden ayrılan üyeyi ev işi sıralarından çıkar`.

### Görev 4: Pro durumunu RevenueCat'ten doğrula

**Dosyalar:**
- Oluştur: `functions/src/revenuecat.ts`
- Değiştir: `functions/src/billing.ts` (webhook + yeni `syncPro`), `functions/src/household.ts` (`createHousehold`, `assertCanJoinAnother`), `functions/src/receipts.ts`, `functions/src/index.ts`
- Değiştir: `lib/features/pro/data/pro_service.dart` (satın alma/geri yüklemeden sonra `syncPro`)
- Test: `functions/test/unit/revenuecat.test.ts` (yeni); `functions/test/unit/billing.test.ts` silinir

**Arayüzler:**
- Üretir: `export const revenueCatApiKey = defineSecret("REVENUECAT_API_KEY")`
- Üretir: `export function proUntilFromSubscriber(body: unknown, now = Date.now()): Date | null` — `subscriber.entitlements.pro.expires_date`: tarih → `Date`; `null` → `now + 100 yıl`; `pro` yok → `null`.
- Üretir: `export function uidsFromEvent(event: RevenueCatEvent): string[]` — `app_user_id`, `transferred_from[]`, `transferred_to[]`; tekrarsız, `$RCAnonymousID` olmadan.
- Üretir: `export async function syncUserPro(uid: string): Promise<Date | null>` — `GET https://api.revenuecat.com/v1/subscribers/{uid}`, `Authorization: Bearer <key>`; 2xx değilse fırlatır; kullanıcı belgesi varsa `proUntil` yazar ve evlerini `recomputeHouseholdPro` ile günceller.
- Üretir: `export async function userIsProFresh(uid: string): Promise<boolean>` — Firestore'da Pro değilse `syncUserPro` ile tekrar sorar.
- Üretir: `export async function deleteSubscriber(uid: string): Promise<void>` — `DELETE` aynı adres; 404 hata sayılmaz.
- Üretir: callable `syncPro` → `{ proUntil: string | null }`.

- [ ] **Adım 1: Testleri yaz** — aktif entitlement → `new Date(expires_date)`; `expires_date: null` → `now + 50 yıldan` büyük; `pro` yok → `null`; `TRANSFER {transferred_from:['old'], transferred_to:['new']}` → `['old','new']`; anonim kimlik süzülür; `INITIAL_PURCHASE` → `[app_user_id]`.
- [ ] **Adım 2:** Testler FAIL.
- [ ] **Adım 3:** `revenuecat.ts`'i yaz. Webhook her olayda `uidsFromEvent` ile bulduğu herkes için `syncUserPro` çağırsın; hata olursa `500` dönsün. `proUntilFor` ve `GRANTING` kalkar. `createHousehold`, `assertCanJoinAnother` ve fiş kotası `userIsProFresh` kullansın; bu fonksiyonların `secrets` listesine `revenueCatApiKey` eklenir.
- [ ] **Adım 4:** `ProService.purchase` ve `restore` Pro aktif döndüğünde `syncPro`'yu çağırsın; hata yalnızca `reportError` ile kaydedilir.
- [ ] **Adım 5:** Testler PASS, lint ve `flutter analyze` geçer.
- [ ] **Adım 6:** Commit: `Pro durumunu RevenueCat'ten doğrula`. Deploy, Sude anahtarı kaydettikten sonra ve onayıyla.

### Görev 5: Hesap silmede bakiye uyarısı ve RevenueCat kaydı

**Dosyalar:**
- Değiştir: `functions/src/account.ts`
- Değiştir: `lib/features/settings/data/account_repository.dart`, `lib/features/settings/presentation/account_screen.dart:58-70`
- Değiştir: üç ARB dosyası
- Test: `functions/test/unit/account.test.ts` (yeni), `test/features/account_delete_test.dart` (yeni)

**Arayüzler:**
- Üretir: `export function blockingBalances(rows: { name: string; currency: string; balanceMinor: number }[]): typeof rows` — bakiyesi 0 olmayanlar.
- Üretir: `deleteAccount({ force?: boolean })` → bakiye varsa ve `force` yoksa `HttpsError("failed-precondition", "balance-not-zero", { households })`.
- Üretir: `Future<void> AccountRepository.deleteAccount({bool force = false})`.
- Yeni ARB anahtarları: `deleteAccountBalanceTitle`, `deleteAccountBalanceBody`, `deleteAnyway`.

- [ ] **Adım 1: Testleri yaz** — `blockingBalances` yalnızca sıfır olmayanları döndürür. Widget testi `shows households with a balance before deleting`: depo ilk çağrıda `AppException(balanceNotZero, details: {households: [{name: 'Moda', balanceMinor: -25000, currency: 'TRY'}]})` fırlatır; diyalogda "Moda" görünür; "Yine de sil" `force: true` ile ikinci çağrıyı yapar.
- [ ] **Adım 2:** Testler FAIL.
- [ ] **Adım 3:** `deleteAccount` her ev için `balanceOf` ile bakiyeyi hesaplasın; silmeden sonra `deleteSubscriber` çağrılsın (hata yalnızca loglanır). Ekran diyaloğu ve metinler üç dilde.
- [ ] **Adım 4:** Testler PASS, lint ve analyze geçer.
- [ ] **Adım 5:** Commit: `Hesap silmeden önce açık bakiyeleri göster`.

### Görev 6: Davet kodu deneme sınırı ve katılım bildirimi

**Dosyalar:**
- Değiştir: `functions/src/dates.ts`, `functions/src/common.ts`, `functions/src/household.ts` (`joinHousehold`), `functions/src/notify.ts`, `lib/core/firebase/app_error.dart`
- Test: `functions/test/unit/dates.test.ts`

**Arayüzler:**
- Üretir: `export function hourKey(date: Date): string` → UTC `"2026-11-04T09"`.
- Üretir: `export const JOIN_FAILURES_PER_HOUR = 10`.
- Üretir: `MESSAGES.memberJoined` — tr `${actor} eve katıldı`, en `${actor} joined the household`, de `${actor} ist dem Haushalt beigetreten`.

- [ ] **Adım 1: Test** — `hourKey(new Date(Date.UTC(2026, 10, 4, 9, 59)))` → `"2026-11-04T09"`.
- [ ] **Adım 2:** FAIL, sonra yaz. `joinHousehold` önce `usage/{uid}.joinFailures.{hourKey}` sayısına baksın; sınırdaysa `resource-exhausted` / `too-many-attempts`. Kod bulunamazsa sayaç bir artsın. Başarılı katılımdan sonra yöneticilere (`adminIds`, katılan hariç) `notifyUsers(..., "newExpense", "memberJoined", ...)`.
- [ ] **Adım 3:** `app_error.dart`'ta `'too-many-attempts'` → `AppErrorCode.tooManyRequests` (mevcut metin kullanılır).
- [ ] **Adım 4:** Test PASS, lint ve analyze geçer.
- [ ] **Adım 5:** Commit: `Davet kodu denemelerini sınırla ve katılımı yöneticiye bildir`.

### Görev 7: Okunamayan fiş sınırı

**Dosyalar:**
- Değiştir: `functions/src/receipts.ts`, `functions/src/common.ts`, `lib/core/firebase/app_error.dart`, üç ARB dosyası, fiş hatası gösterilen yer (`expense_edit_screen.dart:205-220`)
- Test: `functions/test/unit/receipts.test.ts` (yeni)

**Arayüzler:**
- Üretir: `export const FAILED_SCANS_PER_DAY = 20`.
- Üretir: `export function scanDecision(p: { used: number; limit: number; failures: number }): "ok" | "receipt-quota" | "receipt-failures"`.
- Yeni `AppErrorCode.receiptFailures` ve ARB anahtarı `errorReceiptFailures`.

- [ ] **Adım 1: Test** — `{used: 5, limit: 5, failures: 0}` → `"receipt-quota"`; `{used: 1, limit: 5, failures: 20}` → `"receipt-failures"`; `{used: 1, limit: 5, failures: 19}` → `"ok"`.
- [ ] **Adım 2:** FAIL, sonra yaz. İşlem içinde `receiptFailures.{dayKey}` okunur; hata yolunda kota iadesiyle birlikte bir artırılır.
- [ ] **Adım 3:** Test PASS, lint ve analyze geçer.
- [ ] **Adım 4:** Commit: `Okunamayan fiş denemelerini günlük sınırla`.

### Görev 8: Kurallarda boyut sınırları

**Dosyalar:**
- Değiştir: `firestore.rules` (`shoppingItems`, `members` kendi güncellemesi)
- Test: `functions/test/rules/firestore.rules.test.ts`

- [ ] **Adım 1: Testler** — 101 karakterlik alışveriş maddesi adı `assertFails`; normal madde `assertSucceeds`; 35 karakterlik IBAN `assertFails`; 17 karakterlik emoji alanı `assertFails`.
- [ ] **Adım 2:** Kurallar: alışveriş maddesinde `name` 1–100, `quantity` `null` ya da en çok 40, oluştururken `addedBy == me()`, alanlar yalnızca `name, quantity, addedBy, done, doneBy, doneAt, createdAt`. Üyede `iban` `null` ya da en çok 34, `avatarEmoji` en çok 16.
- [ ] **Adım 3:** `npm --prefix functions run lint` geçer; kural testleri CI'da.
- [ ] **Adım 4:** Commit: `Alışveriş ve profil alanlarına uzunluk sınırı koy`.

**Deploy noktası:** Görev 2–8 bitince Sude'ye sor: `firebase deploy --only functions,firestore:rules --project odeselimapp` (Görev 4'ün anahtarı kayıtlı olmalı).

---

## Bölüm C — Uygulama

### Görev 9: Para birimini ilk giderden sonra kilitle

**Dosyalar:** `lib/features/household/presentation/house_settings_screen.dart:40-82`, üç ARB dosyası (`currencyLockedHint`), test `test/features/house_settings_test.dart` (yeni)

- [ ] **Adım 1: Test** — `currency is locked once the household has an expense`: bir gider varken düzenleme diyaloğunu aç; para birimi alanının `onChanged`'i `null`, ipucu metni görünür. Gider yokken alan değiştirilebilir.
- [ ] **Adım 2:** FAIL, sonra `expensesProvider` boş değilse alanı kapat ve ipucunu göster.
- [ ] **Adım 3:** Test PASS, analyze geçer.
- [ ] **Adım 4:** Commit: `İlk giderden sonra para birimini kilitle`.

### Görev 10: E-posta doğrulama

**Dosyalar:** `lib/features/auth/data/auth_repository.dart`, `lib/features/settings/presentation/account_screen.dart`, üç ARB dosyası (`verifyEmailTitle`, `verifyEmailBody`, `resendVerification`, `verificationSent`)

**Arayüzler:**
- Üretir: `bool get needsEmailVerification` (şifreyle giriş yapmış ve doğrulamamış), `Future<void> resendVerification()`.

- [ ] **Adım 1:** Kayıttan sonra `sendEmailVerification()` çağrılsın (hata `reportError`). Hesap ekranında doğrulanmamışsa uyarı satırı ve "Tekrar gönder".
- [ ] **Adım 2:** Analyze geçer. Bu akış Firebase Auth'a bağlı, otomatik test yok; TestFlight'ta denenecekler listesine eklenir.
- [ ] **Adım 3:** Commit: `Kayıttan sonra doğrulama e-postası gönder`.

### Görev 11: Release derlemesinde demo ayarını engelle

**Dosyalar:** `lib/main.dart`

- [ ] **Adım 1:** `bootstrapFirebase()` öncesine: `kReleaseMode && FirebaseEnv.isDemo` ise `StateError('Release build is missing --dart-define-from-file=env/prod.json')`.
- [ ] **Adım 2:** Analyze geçer.
- [ ] **Adım 3:** Commit: `Prod ayarı olmadan release derlemesini durdur`.

### Görev 12: Yıllık indirim yüzdesini fiyatlardan hesapla

**Dosyalar:** oluştur `lib/features/pro/domain/savings.dart`; değiştir `lib/features/pro/presentation/pro_screen.dart:231`; test `test/features/pro_savings_test.dart` (yeni)

**Arayüzler:**
- Üretir: `int savingsPercent({required int monthlyMinor, required int annualMinor})` — `((monthly × 12 − annual) × 100) ~/ (monthly × 12)`, negatifse 0.

- [ ] **Adım 1: Test** — `(2999, 19999)` → 44; `(7999, 54999)` → 42; `(1000, 12000)` → 0; `(1000, 13000)` → 0.
- [ ] **Adım 2:** FAIL, sonra yaz. Ekran fiyatları `(price × 100).round()` ile kuruşa çevirir; yüzde 0 ise etiket gösterilmez.
- [ ] **Adım 3:** Test PASS, analyze geçer.
- [ ] **Adım 4:** Commit: `Yıllık indirim yüzdesini mağaza fiyatından hesapla`.

### Görev 13: Tüm çağrılabilir fonksiyonlarda App Check

**Önkoşul:** Sude prod App Check'te App Attest'i ve Xcode hata ayıklama anahtarını kaydettiğini onaylar.

**Dosyalar:** `functions/src/common.ts` (`export const CALLABLE = { region: REGION, enforceAppCheck: process.env.FUNCTIONS_EMULATOR !== "true" }`), tüm `onCall` kullanan dosyalar.

- [ ] **Adım 1:** Her `onCall` seçeneği `CALLABLE`'ı kullansın (gizli anahtar isteyenler `{ ...CALLABLE, secrets: [...] }`).
- [ ] **Adım 2:** `grep -n "onCall({ region: REGION" functions/src/*.ts` sonuç vermez; lint geçer.
- [ ] **Adım 3:** Commit: `Tüm sunucu çağrılarında App Check iste`. Deploy Sude'nin onayıyla.

**Son:** Uygulama tarafındaki değişiklikler (Görev 2, 4, 5, 9–12) yeni bir derlemeyle yayına çıkar. Build numarasını artırmadan önce Sude'ye sor.

---

## Bu planın dışında (Sude ile ayrıca konuşulacak)

- **Yeni görünüm:** beğenilen palet; Calistoga ve Inter için paket ya da font dosyası kararı.
- **Davet bağlantısı ve QR:** Associated Domains ve App Links kurulumu gerekiyor.
- **Android lansmanı:** Play Console, Play abonelik ürünleri, RevenueCat Android, imza parmak izleri.
- **Yeni özellikler:** aylık özet bildirimi, seyahat grupları, uygulamasız ev arkadaşı, ev kasası, fiş kalemlerini kişilere atama, ana ekran widget'ı, Siri ile gider ekleme — her biri için önce birlikte tasarım.
