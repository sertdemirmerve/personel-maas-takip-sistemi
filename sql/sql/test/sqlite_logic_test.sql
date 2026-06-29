PRAGMA foreign_keys = ON;

-- ============================================================
-- TABLOLAR (T-SQL şemasının SQLite eşdeğeri)
-- ============================================================

CREATE TABLE tbl_Bolumler (
    Bolum_ID     INTEGER PRIMARY KEY AUTOINCREMENT,
    Bolum_Adi    TEXT,
    Bolum_Tel    TEXT,
    Yonetici_ID  TEXT
);

CREATE TABLE tbl_Kategoriler (
    K_ID         INTEGER PRIMARY KEY AUTOINCREMENT,
    Cinsiyet     TEXT,
    Unvan        TEXT,
    Ilce_Adi     TEXT,
    Il_Adi       TEXT,
    Ulke         TEXT,
    Ay_Adi       TEXT,
    Kitap_Turu   TEXT,
    Yetki_Turu   TEXT
);

CREATE TABLE tbl_Kullanicilar (
    Kullanici_ID     INTEGER PRIMARY KEY AUTOINCREMENT,
    Kullanici_Adi    TEXT,
    Kullanici_Sifre  TEXT,
    Yetki_ID         INTEGER
);

CREATE TABLE tbl_Personeller (
    Pers_ID               INTEGER PRIMARY KEY AUTOINCREMENT,
    Pers_Adi              TEXT,
    Pers_Soyadi           TEXT,
    Pers_DTarihi          TEXT,
    Pers_Giris_Tarihi     TEXT,
    Pers_Cikis_Tarihi     TEXT,
    Pers_Adresi           TEXT,
    Pers_Ilcesi           TEXT,
    Pers_Ili              TEXT,
    Pers_Il_Kodu          TEXT,
    Pers_Tel              TEXT,
    Pers_Cep              TEXT,
    Pers_Email            TEXT,
    Bolum_ID              INTEGER,
    Cinsiyet_ID           INTEGER,
    Unvan_ID              INTEGER,
    Pers_Maas             REAL,
    Pers_Komisyon_Yuzdesi REAL,
    Pers_SGK_No           TEXT,
    Pers_TC_No            TEXT,
    Pers_CV               TEXT,
    Pers_CV_File          TEXT,
    Pers_CV_Web           TEXT,
    Pers_Aktif_Mi         INTEGER,
    Kaydeden              TEXT,
    Kayit_Tarihi          TEXT,
    Son_Kaydeden          TEXT,
    Son_Kayit_Tarihi      TEXT NOT NULL
);

CREATE TABLE tbl_Maaslar (
    Maas_ID         INTEGER PRIMARY KEY AUTOINCREMENT,
    Pers_ID         INTEGER,
    Maas_Tutari     REAL,
    Maas_Komisyonu  REAL,
    Maas_Tarihi     TEXT,
    Ay_ID           INTEGER
);

-- ============================================================
-- VERİLER
-- ============================================================

INSERT INTO tbl_Kategoriler (Cinsiyet, Unvan, Ilce_Adi, Il_Adi, Ulke, Ay_Adi, Kitap_Turu, Yetki_Turu)
VALUES
    ('KADIN', 'YBS', 'BEYKOZ',      'İSTANBUL', 'TÜRKİYE', 'TEMMUZ',  'X', 'XX'),
    ('ERKEK', 'YBS', 'BEYOĞLU',     'İSTANBUL', 'TÜRKİYE', 'OCAK',    'X', 'XX'),
    ('KADIN', 'VTS', 'AVCILAR',     'İSTANBUL', 'TÜRKİYE', 'ŞUBAT',   'X', 'XX'),
    ('ERKEK', 'YBS', 'MALTEPE',     'İSTANBUL', 'TÜRKİYE', 'MART',    'X', 'XX'),
    ('KADIN', 'VTS', 'ESENYURT',    'İSTANBUL', 'TÜRKİYE', 'NİSAN',   'X', 'XX'),
    ('KADIN', 'YBS', 'GÜNGÖREN',    'İSTANBUL', 'TÜRKİYE', 'MAYIS',   'X', 'XX'),
    ('ERKEK', 'VTS', 'TUZLA',       'İSTANBUL', 'TÜRKİYE', 'HAZİRAN', 'X', 'XX'),
    ('ERKEK', 'YBS', 'PENDİK',      'İSTANBUL', 'TÜRKİYE', 'AĞUSTOS', 'X', 'XX'),
    ('ERKEK', 'VTS', 'ŞİŞHANE',     'İSTANBUL', 'TÜRKİYE', 'EYLÜL',   'X', 'XX'),
    ('KADIN', 'YBS', 'TAKSİM',      'İSTANBUL', 'TÜRKİYE', 'EKİM',    'X', 'XX'),
    ('KADIN', 'VTS', 'MECİDİYEKÖY', 'İSTANBUL', 'TÜRKİYE', 'KASIM',   'X', 'XX'),
    ('ERKEK', 'YBS', 'AVCILAR',     'İSTANBUL', 'TÜRKİYE', 'ARALIK',  'X', 'XX');

INSERT INTO tbl_Bolumler (Bolum_Adi, Bolum_Tel, Yonetici_ID)
VALUES
    ('SİBER GÜVENLİK', '02123456701', '3'),
    ('İNSAN KAYNAKLARI', '02123456702', '5'),
    ('MUHASEBE', '02123456703', '1'),
    ('BİLGİ İŞLEM', '02123456704', '2'),
    ('PAZARLAMA', '02123456705', '4'),
    ('ÜRETİM', '02123456706', '6'),
    ('LOJİSTİK', '02123456707', '7'),
    ('HUKUK', '02123456708', '8'),
    ('SATIN ALMA', '02123456709', '9'),
    ('AR-GE', '02123456710', '10'),
    ('KALİTE KONTROL', '02123456711', '11'),
    ('YÖNETİM', '02123456712', '12');

INSERT INTO tbl_Personeller
    (Pers_Adi, Pers_Soyadi, Pers_DTarihi, Pers_Giris_Tarihi, Pers_Cikis_Tarihi,
     Pers_Adresi, Pers_Ilcesi, Pers_Ili, Pers_Il_Kodu, Pers_Tel, Pers_Cep, Pers_Email,
     Bolum_ID, Cinsiyet_ID, Unvan_ID, Pers_Maas, Pers_Komisyon_Yuzdesi,
     Pers_SGK_No, Pers_TC_No, Pers_CV, Pers_CV_File, Pers_CV_Web, Pers_Aktif_Mi,
     Kaydeden, Kayit_Tarihi, Son_Kaydeden, Son_Kayit_Tarihi)
VALUES
    ('YAVUZ', 'SERTDEMİR', '1977-01-02', '2013-01-05', '2023-02-01',
     'YILDIZTEPE MAHALLESİ', 'BAĞCILAR', 'İSTANBUL', '34', '11233344', '98766321', 'sdemiryavuz@gmail.com',
     1, 2, 1, 40000, 10, '1234567', '85547477120', 'X', 'XX', 'XXX', 0,
     'ASLI ARSLAN', '2010-01-01', 'ASLI ARSLAN', '2023-01-05'),
    ('DİLAN', 'YALÇIN', '2004-08-01', '2021-01-05', '2024-02-01',
     'SANCAKTEPE MAHALLESİ', 'TAKSİM', 'İSTANBUL', '34', '11233345', '98766322', 'yalcindilan@gmail.com',
     1, 1, 1, 40000, 10, '1234567', '85547477130', 'X', 'XX', 'XXX', 1,
     'ASLI ARSLAN', '2022-01-01', 'ASLI ARSLAN', '2024-01-05'),
    ('ZEYNEP', 'BOZKURT', '2003-05-01', '2020-01-05', '2023-02-01',
     'SANCAKTEPE MAHALLESİ', 'SULTANGAZİ', 'İSTANBUL', '34', '11233346', '98766323', 'bozkurtzeynep@gmail.com',
     1, 1, 1, 60000, 10, '1234567', '85547477260', 'X', 'XX', 'XXX', 1,
     'ASLI ARSLAN', '2021-01-01', 'ASLI ARSLAN', '2022-01-05'),
    ('MELTEM', 'BAYRAM', '2002-09-01', '2019-01-05', '2022-02-01',
     'YÜZÜNCÜ YIL MAHALLESİ', 'FATİH', 'İSTANBUL', '34', '11233377', '98766378', 'meltembayram@gmail.com',
     1, 1, 1, 55000, 10, '1234567', '85547477140', 'X', 'XX', 'XXX', 1,
     'ASLI ARSLAN', '2019-01-01', 'ASLI ARSLAN', '2022-01-05'),
    ('MERVE', 'SERTDEMİR', '2004-07-09', '2021-01-09', '2024-02-01',
     'ŞEHİTLER CADDESİ', 'SARIYER', 'İSTANBUL', '34', '11233337', '98766337', 'sertdemirmervee@gmail.com',
     1, 1, 1, 40000, 10, '1234537', '85547477370', 'X', 'XX', 'XXX', 1,
     'ASLI ARSLAN', '2021-01-01', 'ASLI ARSLAN', '2024-01-05'),
    ('ESMA', 'İNAN', '2003-01-04', '2020-01-09', '2023-02-01',
     'ATATÜRK CADDESİ', 'BAKIRKÖY', 'İSTANBUL', '34', '11233342', '98766342', 'esmainan@gmail.com',
     1, 1, 1, 50000, 10, '1234537', '85547474200', 'X', 'XX', 'XXX', 1,
     'ASLI ARSLAN', '2021-01-01', 'ASLI ARSLAN', '2024-01-05');

INSERT INTO tbl_Kullanicilar (Kullanici_Adi, Kullanici_Sifre, Yetki_ID)
VALUES
    ('MERVE',  '14586322', 2),
    ('YAVUZ',  '14586337', 1),
    ('DİLAN',  '14586345', 3),
    ('MELTEM', '14586377', 4),
    ('ZEYNEP', '14586741', 6),
    ('ESMA',   '14586742', 7);

INSERT INTO tbl_Maaslar (Pers_ID, Maas_Tarihi, Maas_Tutari, Maas_Komisyonu, Ay_ID)
VALUES
    (1, '2024-01-05', 40000, 10, 1),
    (2, '2024-07-05', 60000, 10, 7),
    (3, '2024-05-05', 40000, 10, 5),
    (4, '2024-08-05', 60000, 10, 8),
    (5, '2024-11-05', 55000, 10, 11),
    (6, '2024-06-05', 40000, 10, 6),
    (1, '2024-09-05', 50000, 10, 9);

-- ============================================================
-- DOĞRULAMA SORGULARI
-- ============================================================

SELECT '--- tbl_Bolumler ---' AS baslik;
SELECT * FROM tbl_Bolumler;

SELECT '--- tbl_Kategoriler ---' AS baslik;
SELECT * FROM tbl_Kategoriler;

SELECT '--- tbl_Kullanicilar ---' AS baslik;
SELECT * FROM tbl_Kullanicilar;

SELECT '--- tbl_Personeller (Pers_Isim hesaplanmış) ---' AS baslik;
SELECT Pers_ID, (Pers_Adi || ' ' || Pers_Soyadi) AS Pers_Isim, Bolum_ID, Cinsiyet_ID, Unvan_ID, Pers_Maas
FROM tbl_Personeller;

SELECT '--- tbl_Maaslar (Maas_Toplam hesaplanmış) ---' AS baslik;
SELECT Maas_ID, Pers_ID, Maas_Tutari, Maas_Komisyonu, (Maas_Tutari + Maas_Komisyonu) AS Maas_Toplam, Ay_ID
FROM tbl_Maaslar;

SELECT '--- JOIN: Personel + Maaş + Bölüm ---' AS baslik;
SELECT
    p.Pers_ID,
    (p.Pers_Adi || ' ' || p.Pers_Soyadi) AS Pers_Isim,
    b.Bolum_Adi,
    m.Maas_Tarihi,
    m.Maas_Tutari,
    m.Maas_Komisyonu,
    (m.Maas_Tutari + m.Maas_Komisyonu) AS Maas_Toplam
FROM tbl_Personeller p
JOIN tbl_Maaslar m  ON p.Pers_ID = m.Pers_ID
JOIN tbl_Bolumler b ON p.Bolum_ID = b.Bolum_ID
ORDER BY m.Maas_Tarihi;

SELECT '--- FK ihlali kontrolü: yetim Maas_ID var mı? (0 olmalı) ---' AS baslik;
SELECT COUNT(*) AS yetim_kayit_sayisi
FROM tbl_Maaslar m
WHERE NOT EXISTS (SELECT 1 FROM tbl_Personeller p WHERE p.Pers_ID = m.Pers_ID);

