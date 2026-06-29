# Personel Maaşları Takip Programı (PMTP)

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=flat&logo=microsoft-sql-server&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-4479A1?style=flat)

## Proje Özeti

Bir işletmenin personel, bölüm, maaş ve kullanıcı yetki bilgilerini
yönetmek için tasarlanmış ilişkisel veritabanı. Personel bilgileri,
aylık maaş/komisyon kayıtları ve sisteme giriş yetkileri arasındaki
ilişkileri foreign key kısıtlarıyla yönetir.

Bu script, ders kapsamında hazırlanan orijinal tasarımın üzerine,
**çalışma zamanı hatalarının tamamı giderilerek** yeniden yazılmıştır.

---

## Veritabanı Şeması

5 tablo, foreign key ilişkileriyle birbirine bağlı:

- `tbl_Bolumler` — şirket bölümleri
- `tbl_Kategoriler` — cinsiyet, unvan gibi sabit liste değerleri (lookup table)
- `tbl_Personeller` — personel bilgileri (bölüm, cinsiyet, unvan referanslarıyla)
- `tbl_Maaslar` — personele bağlı aylık maaş/komisyon kayıtları
- `tbl_Kullanicilar` — sisteme giriş yetkisi olan kullanıcılar

`Pers_Isim` (ad+soyad) ve `Maas_Toplam` (maaş+komisyon) alanları
computed column olarak tanımlanmıştır — veri tekrarı yerine
otomatik hesaplanır.

---

## Düzeltilen Hatalar

Orijinal script'te tespit edilen ve bu sürümde giderilen sorunlar:

| # | Sorun | Çözüm |
|---|---|---|
| 1 | Dosya sonunda bağlamsız, hiçbir `CREATE TABLE`'a ait olmayan kod parçası (`[K_ID] ASC) WITH (...)`) — çalıştırıldığında sözdizimi hatası veriyordu | Kalıntı kod tamamen kaldırıldı |
| 2 | `tbl_Maaslar`'a sadece 6 personel varken Pers_ID = 25, 28, 29, 30, 32, 33, 34 ile veri eklenmiş — foreign key ihlali | Maaş kayıtları gerçek personel ID'leriyle (1-6) yeniden yazıldı |
| 3 | Aynı foreign key constraint ve aynı computed column'lar iki kez tanımlanmış — "already exists" hatası | Tekrarlar kaldırıldı, her nesne tek seferde tanımlandı |
| 4 | `K_ID`, `Bolum_ID`, `Kullanici_ID` `IDENTITY` değildi ama INSERT'lerde değer verilmiyordu — NOT NULL ihlali | Üç alan da `IDENTITY(1,1)` olarak yeniden tanımlandı |
| 5 | Foreign key'ler veri girişinden önce ekleniyordu; tutarsız veri sessizce kabul ediliyordu | FK'ler veri girişinden **sonra** eklenecek şekilde sıralandı — `WITH CHECK` doğrulaması devrede |

Mantık, SQLite üzerinde eşdeğer şema ile test edilmiş; tüm INSERT,
JOIN ve foreign key doğrulamaları hatasız çalışmaktadır
(`sql/test/sqlite_logic_test.sql` dosyasına bakın).

---

## Klasör Yapısı

```
personel-maas-takip/
├── sql/
│   ├── pmtp_database_script.sql   (ana script — SQL Server)
│   └── test/
│       └── sqlite_logic_test.sql  (mantık doğrulama testi)
├── docs/
│   └── erd.md                     (şema diyagramı)
└── README.md
```

---

## Kurulum

SQL Server Management Studio (SSMS) açın:

```sql
-- pmtp_database_script.sql dosyasının tamamını çalıştırın
```

Script sıfırdan çalıştırılabilir: önceki `db_PMTP` veritabanı varsa
siler, yeniden oluşturur, tabloları kurar, referans verilerini ve
örnek personel/maaş kayıtlarını ekler, son olarak foreign key
ilişkilerini kurar.

**Not:** `CREATE DATABASE` bloğundaki dosya yolları (`C:\db_PMTP.mdf`)
kendi ortamınıza göre güncellenmelidir.

---

## Doğrulama

Script'in sonundaki sorgular şunları kontrol eder:

- Tüm tabloların içeriği (`SELECT * FROM ...`)
- Personel + maaş + bölüm bilgisini birleştiren JOIN sorgusu
- Computed column'ların (`Pers_Isim`, `Maas_Toplam`, `Maas_Yili`) doğru hesaplandığı

---

## Kullanılan Teknolojiler

| Teknoloji | Kullanım Amacı |
|---|---|
| SQL Server / T-SQL | Veritabanı, tablo tasarımı, ilişkiler |
| Computed Columns | Türetilmiş alanların otomatik hesaplanması |
| Foreign Key Constraints | Referans bütünlüğü |
| SQLite (test) | Script mantığının bağımsız doğrulanması |

---

*Bu proje bir üniversite dersi kapsamında hazırlanan orijinal
tasarımın üzerine, çalışma zamanı hataları giderilerek ve foreign
key bütünlüğü sağlanarak yeniden düzenlenmiştir. Portfolyo amacıyla yeniden oluşturulmuştur.*
