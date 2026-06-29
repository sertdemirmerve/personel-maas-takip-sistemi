# Veritabanı Şeması (ERD)

```mermaid
erDiagram
  tbl_Bolumler ||--o{ tbl_Personeller : "calisir"
  tbl_Kategoriler ||--o{ tbl_Personeller : "cinsiyet_id"
  tbl_Kategoriler ||--o{ tbl_Personeller : "unvan_id"
  tbl_Kategoriler ||--o{ tbl_Kullanicilar : "yetki_id"
  tbl_Personeller ||--o{ tbl_Maaslar : "alir"

  tbl_Bolumler {
    int Bolum_ID PK
    string Bolum_Adi
    string Bolum_Tel
    string Yonetici_ID
  }
  tbl_Kategoriler {
    int K_ID PK
    string Cinsiyet
    string Unvan
    string Ilce_Adi
    string Il_Adi
    string Ay_Adi
  }
  tbl_Personeller {
    int Pers_ID PK
    string Pers_Adi
    string Pers_Soyadi
    int Bolum_ID FK
    int Cinsiyet_ID FK
    int Unvan_ID FK
    money Pers_Maas
  }
  tbl_Kullanicilar {
    int Kullanici_ID PK
    string Kullanici_Adi
    string Kullanici_Sifre
    int Yetki_ID FK
  }
  tbl_Maaslar {
    int Maas_ID PK
    int Pers_ID FK
    money Maas_Tutari
    money Maas_Komisyonu
    date Maas_Tarihi
  }
```

## İlişkiler

| Tablo | İlişki | Açıklama |
|---|---|---|
| `tbl_Personeller` → `tbl_Bolumler` | many-to-one | Her personel bir bölüme bağlıdır |
| `tbl_Personeller` → `tbl_Kategoriler` (Cinsiyet_ID) | many-to-one | Cinsiyet bilgisi lookup tablosundan gelir |
| `tbl_Personeller` → `tbl_Kategoriler` (Unvan_ID) | many-to-one | Unvan bilgisi aynı lookup tablosundan gelir |
| `tbl_Maaslar` → `tbl_Personeller` | many-to-one | Her maaş kaydı bir personele aittir |
| `tbl_Kullanicilar` → `tbl_Kategoriler` (Yetki_ID) | many-to-one | Kullanıcı yetkisi lookup tablosundan gelir |

`tbl_Kategoriler`, üç farklı amaç için (cinsiyet, unvan, yetki türü)
aynı tabloya farklı foreign key'lerle referans verilen ortak bir
lookup tablosudur.

