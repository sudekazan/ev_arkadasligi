# Ev Masrafı Bölüşme Uygulaması – Flutter Proje Planı

26 Ekim 2026 · Sude

Bu plan, ev arkadaşlarının ortak giderlerini bölüştüren bir Flutter uygulamasını yapay zekânın sıfırdan, faz faz kurması için yazıldı. "Nasıl kullanılır" dışındaki tüm bölümler doğrudan yapay zekâya hitap ediyor.

## Nasıl kullanılır

1. Bu dosyayı boş bir proje klasörüne `PLAN.md` adıyla koy.
2. Claude Code'u o klasörde aç ve son bölümdeki "ilk mesaj"ı gönder.
3. Claude her fazın sonunda durup ne yaptığını özetleyecek. Uygulamayı telefonda dene, onay verince sonraki faza geçsin.
4. "Açık kararlar" bölümündeki maddeleri karar verdikçe bu dosyada güncelle.

## Alınan kararlar (26 Ekim 2026)

- **Çalışma düzeni:** Fazlar arasında onay için durulmaz; her özellikten sonra commit + `main`'e push. Sude'nin elle yapacağı adımlar (Firebase konsolu, `flutterfire configure`, mağazalar, RevenueCat, API anahtarları) en sona, `docs/MANUAL_STEPS.md` dosyasında toplanır.
- **Firebase:** Gerçek proje kurulana kadar `demo-evkasa` demo projesi ve Firebase Emulator kullanılır.
- **Paket kimliği:** `com.sudekazan.evarkadasligi` (Android ve iOS).
- **Depo herkese açık:** Firebase istemci yapılandırma dosyaları (`google-services.json`, `GoogleService-Info.plist`, gerçek `firebase_options`) depoya girmez.
- **Ev sayısı limiti:** Kullanıcının kendi aboneliğine bakar (`users.proUntil`); evin Pro olması kullanıcıya ek ev hakkı vermez.

## Rol ve çalışma kuralları

Sen bu projenin kıdemli Flutter ve Firebase geliştiricisisin. Projeyi aşağıdaki fazlara göre sırayla kur. Proje sahibi Sude, Flutter ve Firebase'i bilen ama tek başına çalışan bir geliştirici.

1. **Faz faz ilerle.** Bir fazı bitirince dur. Ne yaptığını, nasıl test edileceğini ve bir sonraki fazı kısaca özetle, onay bekle.
2. **Her fazın sonunda proje derlenmeli ve testler geçmeli.** `flutter analyze` uyarısız olmalı, `flutter test` yeşil olmalı.
3. **Planı izle, sapma gerekirse sor.** Planda olmayan bir paket, servis veya mimari karar gerekirse önce gerekçesiyle öner.
4. **Güvenli varsayımlar yap ve yaz.** Küçük belirsizliklerde makul olanı seç, faz özetinde "Varsayımlar" başlığıyla belirt.
5. **Gizli anahtar yok.** API anahtarları ve sunucu sırları asla uygulama koduna veya depoya girmez; Cloud Functions ortam değişkenlerinde tutulur.
6. **Para her zaman tam sayı.** Tutarlar kuruş cinsinden `int` olarak saklanır ve hesaplanır; `double` kullanılmaz.
7. **Tüm metinler çeviri dosyasından gelir.** Kodda sabit Türkçe veya İngilizce kullanıcı metni olmaz.
8. **Commit düzeni.** Her anlamlı adımda küçük, açıklayıcı commit at (örnek: `feat(expenses): eşit bölüşme`).

## Ürün özeti

Uygulama, aynı evde yaşayanların kira, fatura ve market giderlerini adil bölüşmesini, kimin kime ne kadar borçlu olduğunu tek bakışta görmesini ve evin ortak işlerini düzenlemesini sağlar. Uygulamanın adı **Ödeşelim** (çalışma adı EvKasa idi).

- **Sorun:** Ev arkadaşları giderleri WhatsApp mesajları ve not defteriyle takip ediyor; oda büyüklüğüne göre kira, her ay tekrar eden faturalar ve "sıra kimde" tartışmaları bu yöntemle yönetilemiyor.
- **Hedef kullanıcı:** 2–6 kişilik evlerde yaşayan üniversite öğrencileri ve genç çalışanlar; ilk pazar Türkiye, ikinci dil İngilizce.
- **Temel değer:** "Ev" merkezli çalışır; genel grup harcama uygulamalarından farkı tekrarlayan giderler, oda bazlı pay, alışveriş listesi ve ev işi sırasının tek yerde olmasıdır.

**Rakip notu (Splitwise):** Ücretsiz sürüm günlük gider sayısını sınırlıyor ve reklam gösteriyor; fiş tarama yalnızca Pro'da. ABD App Store'da Pro aylık 4,99 $, yıllık 39,99 $ ([Dolio, 12 Ağustos 2026](https://dolio.org/compare/splitwise-free-plan-limits)). Bu yüzden bizim ücretsiz sürümümüzde **gider ekleme asla sınırlanmaz**; bu, pazarlamada ana mesaj olacak.

## Teknoloji yığını

Flutter (güncel kararlı sürüm) ve Firebase kullanılır; paketler `flutter pub add` ile pub.dev'deki güncel kararlı sürümlerinden eklenir. Platformlar: Android ve iOS.

| Alan | Seçim | Not |
| --- | --- | --- |
| Durum yönetimi | `flutter_riverpod` | Test edilebilir, bağımlılık yönetimi kolay |
| Yönlendirme | `go_router` | Davet bağlantıları için yol tabanlı |
| Modeller | `freezed` + `json_serializable` | Değişmez veri sınıfları, Firestore dönüşümü |
| Kimlik | `firebase_auth` | E-posta, Google; iOS'ta Apple ile Giriş zorunlu |
| Veritabanı | `cloud_firestore` | Çevrimdışı önbellek açık |
| Dosyalar | `firebase_storage` | Fiş fotoğrafları |
| Sunucu kodu | Cloud Functions (TypeScript, Node) | Tekrarlayan giderler, fiş okuma, bildirimler |
| Bildirim | `firebase_messaging` | Yeni gider, borç hatırlatma, ev işi sırası |
| Ölçüm | `firebase_analytics`, `firebase_crashlytics` | İlk günden açık |
| Kötüye kullanım koruması | `firebase_app_check` | Özellikle fiş okuma fonksiyonu için |
| Abonelik | `purchases_flutter` (RevenueCat) | Pro yetkisi |
| Çeviri | Flutter `gen-l10n` (ARB dosyaları) | `tr` ve `en` |
| Para biçimi | `intl` | `NumberFormat.currency`, varsayılan TRY |
| Diğer | `image_picker`, `share_plus` | Fiş fotoğrafı, davet paylaşımı |

**Fiş okuma:** Görsel destekli bir yapay zekâ modeli, yalnızca `scanReceipt` Cloud Function'ı üzerinden çağrılır. Model adı ve anahtarı ortam değişkenindedir; hangi sağlayıcı (Gemini veya OpenRouter) açık kararlarda.

**Davet:** Firebase Dynamic Links kapatıldığı için kullanılmaz. MVP'de 6 karakterli davet kodu ve bu kodu içeren paylaşım metni yeterli.

## Özellikler ve kabul kriterleri

MVP dokuz modülden oluşur. Her modül, altındaki kriterlerin hepsi sağlanınca bitmiş sayılır.

### 1. Hesap ve ev

- E-posta, Google ve (iOS'ta) Apple ile kayıt ve giriş yapılabilir; profilde ad, emoji avatar ve isteğe bağlı IBAN bulunur.
- Kullanıcı ev oluşturur (ad, para birimi; varsayılan TRY). Oluşturan kişi yöneticidir.
- Ev, 6 karakterli bir davet koduna sahiptir; kod paylaşılabilir, yönetici yenileyebilir. Kodu giren kullanıcı eve katılır.
- Bir üye, bakiyesi sıfırsa evden ayrılabilir; sıfır değilse uyarı alır. Yönetici üye çıkarabilir.
- Ücretsiz kullanıcı 1 eve üye olabilir; Pro ile sınırsız.

### 2. Giderler

- Gider alanları: açıklama, tutar, ödeyen kişi, tarih, kategori, katılımcılar, bölüşme tipi, not, isteğe bağlı fiş fotoğrafı.
- Kategoriler: Kira, Elektrik, Su, Doğalgaz, İnternet, Market, Temizlik, Ev eşyası, Diğer.
- Gideri ekleyen kişi veya yönetici düzenleyip silebilir; değişiklik etkinlik akışına düşer.
- Liste aya göre gruplanır; kategori ve kişiye göre filtrelenir, açıklamada aranabilir.
- Gider ekleme hiçbir planda sınırlanmaz.

### 3. Bölüşme tipleri

- **Eşit:** seçili katılımcılar arasında.
- **Tutar:** her kişiye tutar girilir; toplam gider tutarına eşit olmalıdır, değilse kaydetme kapalıdır ve fark gösterilir.
- **Yüzde:** toplam %100 olmalıdır.
- **Pay (ağırlık):** örneğin büyük oda 3, küçük oda 2. Evde üye başına varsayılan "kira payı" tanımlanabilir ve Kira kategorisinde otomatik uygulanır.

### 4. Bakiye ve ödeşme

- Ana ekranda kullanıcının net durumu görünür: "Ayşe'ye 250,00 ₺ borçlusun" veya "Sana 120,00 ₺ borçlular".
- Borçlar sadeleştirilmiş olarak gösterilir (en az sayıda transfer).
- "Ödeme yapıldı" kaydı tam veya kısmi tutarla eklenir; alacaklı onaylamadan da bakiyeye işler, ancak alacaklı itiraz edip silebilir.
- Alacaklının IBAN'ı varsa tek dokunuşla kopyalanır.
- "Hatırlat" butonu borçluya bildirim gönderir (kişi başı günde en fazla 1).

### 5. Tekrarlayan giderler

- Şablon alanları: gider alanları + sıklık (aylık veya haftalık) + gün + sabit veya değişken tutar.
- Sabit tutarlı şablon (kira) o gün otomatik gider oluşturur.
- Değişken tutarlı şablon (fatura) "tutar bekleniyor" taslak oluşturur ve ödeyen kişiye bildirim gider; tutar girilince gerçek gidere döner.
- Ücretsiz planda 3 şablon, Pro'da sınırsız.

### 6. Fiş okuma

- Kullanıcı fişin fotoğrafını çeker veya galeriden seçer; fotoğraf Storage'a yüklenir ve `scanReceipt` çağrılır.
- Dönen toplam tutar, tarih, mağaza adı ve kalemler gider formunu doldurur; kullanıcı kontrol edip kaydeder.
- Okuma başarısız olursa form boş açılır ve fotoğraf gidere eklenmiş kalır.
- Ücretsiz planda ayda 5 okuma, Pro'da ayda 200 (adil kullanım). Sayı sunucuda tutulur.

### 7. Ortak alışveriş listesi

- Ev üyeleri listeye kalem ekler, siler ve "alındı" işaretler; değişiklikler gerçek zamanlı görünür.
- Alınan kalemler seçilip "Gider olarak ekle" ile Market kategorisinde gider formuna aktarılır.

### 8. Ev işleri

- Görev alanları: ad, sıklık (günlük, haftalık, iki haftada bir), sıra listesi (üyeler).
- "Sıra kimde" her görevde görünür; "Tamamlandı" sırayı bir sonraki kişiye geçirir ve kayda düşer.
- Bitiş gününde sıradaki kişiye bildirim gider.

### 9. Etkinlik akışı ve ayarlar

- Evdeki her olay (gider eklendi, düzenlendi, ödeme yapıldı, görev tamamlandı) zaman sıralı akışta görünür.
- Ayarlar: dil (TR/EN), tema (açık/koyu/sistem), bildirim tercihleri, hesap silme (mağaza zorunluluğu), Pro'da CSV dışa aktarma.

## Firestore veri modeli

Tüm ev verisi `households/{hid}` altındaki alt koleksiyonlarda durur; böylece güvenlik kuralı tek bir "üye mi?" kontrolüne iner. Tutarlar `...Minor` alanlarında kuruş olarak `int` tutulur.

```
users/{uid}
  displayName, avatarEmoji, iban?, locale, householdIds[], fcmTokens[], createdAt,
  proUntil? (Timestamp, yalnızca sunucu yazar)

households/{hid}
  name, currency ("TRY"), createdBy, adminIds[], memberIds[], inviteCode,
  proUntil? (Timestamp), createdAt

  members/{uid}        displayName, avatarEmoji, rentWeight (int, varsayılan 1), joinedAt, active
  expenses/{eid}       description, amountMinor, paidBy, date, category,
                       splitType ("equal" | "exact" | "percent" | "shares"),
                       splitInput {uid: number}   // kullanıcının girdiği ham değer
                       shares {uid: int}          // hesaplanmış kesin pay, toplamı = amountMinor
                       status ("final" | "pendingAmount"), recurringId?, receiptPath?,
                       receiptItems? [{name, amountMinor}], note, createdBy, createdAt, updatedAt
  settlements/{sid}    fromUid, toUid, amountMinor, date, note, createdBy, createdAt
  recurring/{rid}      gider şablonu alanları + frequency ("monthly" | "weekly"),
                       dayOfMonth? / dayOfWeek?, fixedAmount (bool), nextRunAt, active
  shoppingItems/{id}   name, quantity?, addedBy, done, doneBy?, doneAt?, createdAt
  chores/{id}          name, frequency ("daily" | "weekly" | "biweekly"), rotation [uid],
                       currentIndex, nextDueAt
  choreLogs/{id}       choreId, doneBy, doneAt
  activity/{id}        type, actorUid, refId, params {}, createdAt

inviteCodes/{code}     householdId, createdAt        // yalnızca Cloud Function okur
usage/{uid}            receiptScans {"2026-10": 3}   // yalnızca Cloud Function yazar
```

- `shares` her gider kaydedilirken istemcide hesaplanır ve saklanır. Bakiye hesabı yalnızca `shares`, `paidBy` ve `settlements` kullanır; `splitInput` sadece düzenleme ekranını yeniden doldurmak içindir.
- `status == "pendingAmount"` olan giderler bakiyeye katılmaz.
- Silme yumuşak değil, gerçek silmedir; silme olayı `activity`'ye açıklama ve tutarla yazılır.
- İndeksler: `expenses` için `date desc`; `expenses` için `category + date desc`; `activity` için `createdAt desc`.

## Bölüşme, yuvarlama ve bakiye algoritması

Bütün hesaplar `lib/core/money/` altında, Flutter'a bağımlı olmayan saf Dart fonksiyonları olarak yazılır ve aşağıdaki test senaryolarının tamamı birim testi olarak eklenir. Bu bölüm uygulamanın kalbidir; bir kuruş bile kaybolmamalıdır.

**Kurallar**

1. Katılımcılar her hesapta `uid`'ye göre alfabetik sıralanır; tüm eşitlik bozmaları bu sıraya göre yapılır.
2. **Eşit, yüzde ve pay** tiplerinde "en büyük kalan" yöntemi kullanılır: her kişinin ham payı hesaplanır, aşağı yuvarlanır, kalan kuruşlar kesirli kısmı en büyük olanlardan başlayarak birer birer dağıtılır.
3. Yüzdeler ondalık sayı değil, yüzde yüzlük tam sayı (baz puan) olarak tutulur: %33,33 → `3333`; toplam `10000` olmalıdır. Ara hesaplar tam sayı veya kesirli sayı (`BigInt`/rasyonel) ile yapılır, `double` kullanılmaz.
4. **Tutar** tipinde payların toplamı gider tutarına eşit değilse kayıt reddedilir ve fark gösterilir.
5. **Net bakiye:** kişi için `net = ödediği giderler − payları + yaptığı ödemeler − aldığı ödemeler`. Evdeki tüm netlerin toplamı her zaman 0'dır; bu bir test koşuludur.
6. **Sadeleştirme:** en büyük borçlu, en büyük alacaklıya ikisinden küçük olan tutarı öder; bakiyeler sıfırlanana kadar tekrarlanır. Eşitlikte kural 1 geçerlidir.

**Test senaryoları** (A, B, C alfabetik `uid` sırasıdır)

| # | Girdi | Beklenen sonuç |
| --- | --- | --- |
| T1 | 100,00 ₺ eşit; A, B, C | A 33,34 · B 33,33 · C 33,33 |
| T2 | 15.000,00 ₺ kira, pay; A 3, B 2, C 2 | A 6.428,57 · B 4.285,72 · C 4.285,71 |
| T3 | 250,00 ₺ yüzde; A %50, B %30, C %20 | A 125,00 · B 75,00 · C 50,00 |
| T4 | 100,01 ₺ yüzde; A %33,33, B %33,33, C %33,34 | A 33,33 · B 33,33 · C 33,35 |
| T5 | 300,00 ₺ tutar; A 100,00, B 150,00, C 40,00 | Geçersiz: "10,00 ₺ eksik" |
| T6 | A 900,00 öder (eşit, A B C); B 300,00 öder (eşit, A B C) | Net: A +500,00 · B −100,00 · C −400,00. Transferler: C → A 400,00; B → A 100,00 |
| T7 | T6 + C, A'ya 400,00 ödeme kaydeder | Net: A +100,00 · B −100,00 · C 0,00. Transfer: B → A 100,00 |
| T8 | B 50,00 öder (tutar, tamamı A); C 50,00 öder (tutar, tamamı B) | Net: A −50,00 · B 0,00 · C +50,00. Tek transfer: A → C 50,00 |
| T9 | T6 + "tutar bekleniyor" durumunda bir fatura | T6 ile aynı sonuç |
| T10 | Herhangi bir rastgele 200 giderlik ev (özellik testi) | Her giderde payların toplamı = tutar; netlerin toplamı = 0 |

## Ekranlar ve akışlar

Uygulama 4 sekmeli bir alt menüyle çalışır: **Ana sayfa, Giderler, Ev, Hesap.** Ana sayfa ve Giderler'de "Gider ekle" yüzen butonu bulunur.

**İlk açılış akışı:** Karşılama (3 kaydırılabilir tanıtım) → Giriş/Kayıt → evi yoksa "Ev oluştur" veya "Kodla katıl" → ev oluşturulduysa davet kodu paylaşım ekranı → Ana sayfa. İlk gider eklendikten sonra kapatılabilir Pro tanıtımı bir kez gösterilir.

| Ekran | Yol | İçerik |
| --- | --- | --- |
| Karşılama | `/welcome` | 3 tanıtım kartı, Başla butonu |
| Giriş / Kayıt | `/auth` | E-posta, Google, Apple |
| Ev oluştur / Katıl | `/onboarding/household` | Ev adı ve para birimi veya 6 haneli kod |
| Ana sayfa | `/home` | Net bakiye kartı, sadeleştirilmiş borçlar (Öde, Hatırlat), bekleyen faturalar, son 5 etkinlik |
| Giderler | `/expenses` | Aya göre gruplu liste, filtre, arama |
| Gider ekle / düzenle | `/expenses/edit/:id?` | Tutar (büyük sayı klavyesi), açıklama, ödeyen, kategori, tarih, katılımcılar, bölüşme tipi, fiş butonu |
| Gider detayı | `/expenses/:id` | Paylar, fiş fotoğrafı, kalemler, düzenle/sil |
| Ödeme kaydet | `/settle` | Kimden, kime, tutar (önerilen tutar dolu), IBAN kopyala |
| Ev | `/house` | Sekmeler: Alışveriş listesi, Ev işleri, Tekrarlayan giderler |
| Ev ayarları | `/house/settings` | Üyeler ve kira payları, davet kodu, evden ayrıl |
| Etkinlik | `/activity` | Tüm olaylar, zaman sıralı |
| Hesap | `/account` | Profil, IBAN, dil, tema, bildirimler, Pro, hesap silme |
| Pro | `/pro` | Avantajlar, aylık ve yıllık paket, geri yükle |

**Tasarım:** Material 3, tek bir ana renk (öneri: yeşil tonu, "para ve denge"), koyu tema desteği. Borçlu tutarlar kırmızı, alacaklar yeşil; renk tek başına anlam taşımaz, yanında "borçlusun" / "alacaklısın" metni bulunur. Boş durumların her biri bir açıklama ve tek bir eylem butonu içerir.

## Güvenlik kuralları ve Cloud Functions

Ev üyeliğini değiştiren, para limiti sayılan veya dış servise giden her işlem Cloud Function'da yapılır; istemci yalnızca üyesi olduğu evin verisine erişir. Kurallar Firebase Emulator ile test edilir.

**Firestore kuralları**

- `users/{uid}`: yalnızca sahibi okur ve yazar. Diğer üyelerin adı ve avatarı `members` alt koleksiyonundan okunur.
- `households/{hid}`: `memberIds` içindeki kullanıcı okur. `name` ve `currency` alanlarını yalnızca yönetici günceller; `memberIds`, `adminIds`, `inviteCode` ve `proUntil` istemciden değiştirilemez.
- Alt koleksiyonlar: yalnızca ev üyeleri okur ve yazar.
- `expenses`: oluştururken `createdBy == auth.uid`, `paidBy` ve `shares` anahtarları üye olmalı, `amountMinor` pozitif tam sayı olmalı. Düzenleme ve silme: oluşturan veya yönetici.
- `settlements`: silme yalnızca `fromUid`, `toUid` veya yönetici tarafından.
- `inviteCodes` ve `usage`: istemciye tamamen kapalı.
- `members/{uid}`: üye kendi `displayName` ve `avatarEmoji` alanını, yönetici herkesin `rentWeight` alanını günceller.
- Storage `receipts/{hid}/{dosya}`: yalnızca ev üyeleri; dosya en fazla 5 MB ve görsel türü.

**Cloud Functions** (bölge `europe-west1`, saat dilimi `Europe/Istanbul`)

| Fonksiyon | Tür | Görevi |
| --- | --- | --- |
| `joinHousehold(code)` | Callable | Kodu doğrular, kullanıcıyı `memberIds` ve `members`'a ekler, etkinlik yazar |
| `leaveHousehold(hid)` / `removeMember(hid, uid)` | Callable | Sunucuda bakiyeyi hesaplar; sıfır değilse reddeder |
| `regenerateInviteCode(hid)` | Callable | Yalnızca yönetici; eski kodu siler |
| `scanReceipt(hid, path)` | Callable | App Check zorunlu; üyelik ve aylık kota kontrolü; modeli çağırır; `{merchant, date, totalMinor, items[]}` JSON'unu şemaya göre doğrular |
| `runRecurring` | Zamanlanmış, her gün 03:00 | Vadesi gelen şablonlardan gider veya "tutar bekleniyor" taslak oluşturur, `nextRunAt`'i ilerletir (31'i olmayan aylarda ayın son günü) |
| `choreReminders` | Zamanlanmış, her gün 09:00 | Sırası gelen kişiye bildirim gönderir |
| `onExpenseWritten` / `onSettlementWritten` | Firestore tetikleyici | Etkinlik kaydı ve diğer üyelere bildirim |
| `sendReminder(hid, toUid)` | Callable | Borç hatırlatma; aynı kişiye günde en fazla 1 |
| `revenueCatWebhook` | HTTP | Gizli başlıkla doğrular; `users` ve ilgili evlerin `proUntil` alanını günceller |
| `deleteAccount` | Callable | Kullanıcıyı evlerden çıkarır; geçmiş giderlerde adı "Silinmiş kullanıcı" olur; Auth hesabını siler |

## Gelir modeli

Freemium ve RevenueCat aboneliği kullanılır; uygulamada reklam yoktur. Pro **ev başına** çalışır: bir üye Pro alınca o üyenin evlerindeki herkes Pro özelliklerinden yararlanır. Bu, "aboneliği de bölüşün" mesajıyla satışı kolaylaştırır.

| Özellik | Ücretsiz | Pro |
| --- | --- | --- |
| Gider ekleme, bölüşme tipleri, bakiye | Sınırsız | Sınırsız |
| Alışveriş listesi ve ev işleri | Var | Var |
| Ev sayısı | 1 | Sınırsız |
| Tekrarlayan gider şablonu | 3 | Sınırsız |
| Fiş okuma | Ayda 5 | Ayda 200 |
| Kategori raporları ve aylık özet | Son 1 ay | Tüm geçmiş |
| CSV dışa aktarma | Yok | Var |

- **Paketler:** aylık ve yıllık (yıllık ≈ aylığın 7 katı, "%40 tasarruf" etiketi ve 7 günlük deneme). Fiyatlar mağaza panelinden ülkeye göre belirlenir; uygulama fiyatı asla sabit yazmaz, RevenueCat'ten okur.
- **Pro yetkisi:** istemci RevenueCat'in entitlement durumunu, sunucu ise `proUntil` alanlarını kullanır. Kota kontrolleri (fiş okuma) yalnızca sunucuda yapılır.
- **Pro ekranının gösterildiği anlar:** ilk gider kaydedildikten sonra bir kez (kapatılabilir), bir sınıra takılınca (2. ev, 4. şablon, 6. fiş), Hesap sekmesinden.
- **Hata mesajları:** paketler yüklenemezse kullanıcıya yalnızca "Şu an bağlanılamıyor, tekrar dene" gösterilir; teknik ayrıntı yalnızca hata ayıklama modunda loglanır.
- **Analitik olayları:** `paywall_viewed` (kaynak ekranla), `purchase_completed`, `receipt_scanned`, `limit_reached`, `household_created`, `member_joined`, `expense_added`.

## Proje yapısı, kod standartları ve testler

Kod özellik bazlı klasörlenir; her özellik kendi veri, alan ve arayüz katmanını taşır.

```
lib/
  main.dart
  app/            router.dart, theme.dart, app.dart
  core/
    money/        money.dart, split_calculator.dart, balance_calculator.dart, debt_simplifier.dart
    firebase/     provider'lar, ortak hata dönüşümü
    widgets/      ortak bileşenler (boş durum, tutar alanı, avatar)
  features/
    auth/  household/  expenses/  balances/  recurring/
    receipts/  shopping/  chores/  activity/  settings/  pro/
      her biri:   data/ (repository), domain/ (modeller), presentation/ (ekranlar, widget'lar)
  l10n/           app_tr.arb, app_en.arb
functions/        TypeScript Cloud Functions + testleri
firestore.rules, storage.rules, firestore.indexes.json
test/             birim ve widget testleri
integration_test/ temel akış testleri
```

- `flutter_lints` (veya `very_good_analysis`) açık; `flutter analyze` uyarısız.
- Firestore'a erişim yalnızca repository sınıflarından; ekranlar doğrudan Firestore çağırmaz.
- Hatalar kullanıcıya çevrilmiş, anlaşılır mesajla gösterilir; teknik ayrıntı Crashlytics'e gider.
- Her ekran açık ve koyu temada, küçük (360 dp) ve büyük ekranda, büyük yazı boyutunda düzgün görünür.
- **Testler:** `core/money` için %100 kapsama ve T1–T10; Firestore kuralları için emulator testleri; Cloud Functions için birim testleri; gider ekleme ve ödeme kaydetme için birer widget testi; "ev oluştur → gider ekle → bakiye gör" entegrasyon testi.
- Geliştirme `dev`, yayın `prod` adlı iki ayrı Firebase projesine bağlanır (flavor veya `--dart-define`).

## Geliştirme fazları

Dokuz faz var; her fazın sonunda uygulama çalışır durumdadır ve Claude onay bekler. "Sude" adımları, konsol erişimi gerektirdiği için proje sahibinin elle yapacağı işlerdir; Claude bunları adım adım tarif eder.

0. **Kurulum.** Flutter projesi, klasör yapısı, tema, router, `tr`/`en` çeviri altyapısı, lint, Firebase Emulator yapılandırması, boş `functions/` projesi. *Sude:* `dev` Firebase projesini oluşturup `flutterfire configure` çalıştırır.
1. **Hesap ve ev.** Karşılama, giriş (e-posta + Google; Apple, iOS hazır olunca), ev oluşturma, `joinHousehold`, davet kodu paylaşımı, ev ayarları, Firestore kurallarının ilk sürümü ve testleri.
2. **Para çekirdeği.** `core/money` (bölüşme, bakiye, sadeleştirme) ve T1–T10 testleri. Arayüz yok; yalnızca saf Dart ve testler.
3. **Giderler ve bakiye.** Gider ekle/düzenle/sil, dört bölüşme tipi, kira payları, gider listesi ve filtreler, Ana sayfa bakiye kartı, ödeme kaydetme, IBAN kopyalama.
4. **Tekrarlayan giderler ve bildirimler.** Şablonlar, `runRecurring`, FCM kurulumu, `onExpenseWritten`, `sendReminder`, bildirim tercihleri.
5. **Alışveriş, ev işleri, etkinlik.** Ev sekmesi, gerçek zamanlı liste, "gider olarak ekle", ev işi sırası, `choreReminders`, etkinlik akışı.
6. **Fiş okuma.** Fotoğraf yükleme, `scanReceipt`, kota, App Check, formu doldurma, hata durumu. *Sude:* yapay zekâ sağlayıcısının anahtarını Functions ortam değişkenine girer.
7. **Pro ve analitik.** RevenueCat entegrasyonu, Pro ekranı, sınırlar, `revenueCatWebhook`, Analytics olayları, Crashlytics. *Sude:* mağazalarda abonelik ürünlerini ve RevenueCat paketlerini oluşturur.
8. **Cila ve yayına hazırlık.** Boş durumlar, erişilebilirlik, koyu tema kontrolü, hesap silme, gizlilik politikası ve kullanım koşulları sayfaları (Firebase Hosting), uygulama simgesi ve açılış ekranı, mağaza açıklaması ve anahtar kelime önerileri (TR ve EN), `prod` ortamı. *Sude:* `prod` Firebase projesi ve mağaza kayıtları.

## Açık kararlar

Bunlar planda öneriyle doldurulmuş ama henüz kesinleşmemiş konular. Claude, ilgili faza gelene kadar önerilen değeri kullanır; karar değişirse bu tablo güncellenir.

| Konu | Önerilen | Ne zaman gerekli |
| --- | --- | --- |
| Uygulama adı | Ödeşelim (27 Ekim 2026'da seçildi; mağazada müsaitliği kontrol edilmeli) | Faz 8 |
| Fiş okuma sağlayıcısı | Gemini (Firebase ile aynı faturalandırma) veya Tarif Defteri'ndeki gibi OpenRouter | Faz 6 |
| Pro fiyatı (TRY) | Mağazanın Türkiye fiyat seviyelerinden; yıllık ≈ aylık × 7 | Faz 7 |
| Ana renk ve logo | Yeşil tonu, sade bir ev + bozuk para simgesi | Faz 0 (renk), Faz 8 (logo) |
| Ev başına üye sınırı | 12 üye (kötüye kullanımı önlemek için) | Faz 1 |
| Çoklu para birimi | MVP'de ev başına tek para birimi | Yayından sonra |
| Kalem bazlı fiş bölüşme | MVP'de yok; kalemler yalnızca gösterilir | Yayından sonra |
