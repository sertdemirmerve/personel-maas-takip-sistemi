-- ============================================================
-- PERSONEL MAAŞLARI TAKİP PROGRAMI (PMTP)
-- Veritabanı Oluşturma ve Veri Girişi Scripti
-- Araç: SQL Server 2022 Express / SSMS
-- ============================================================
-- Bu script sıfırdan çalıştırılabilir: veritabanını, tabloları,
-- ilişkileri ve örnek verileri eksiksiz oluşturur.
-- ============================================================

USE master
GO

-- ============================================================
-- 1. VERİTABANI OLUŞTURMA
-- ============================================================

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'db_PMTP')
BEGIN
    ALTER DATABASE db_PMTP SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE db_PMTP;
END
GO

CREATE DATABASE db_PMTP
ON PRIMARY
(NAME = 'db_PMTP', FILENAME = 'C:\db_PMTP.mdf', SIZE = 5120KB, FILEGROWTH = 1024KB)
LOG ON
(NAME = 'db_PMTP_log', FILENAME = 'C:\db_PMTP_log.ldf', SIZE = 1024KB, FILEGROWTH = 1024KB)
GO

ALTER DATABASE db_PMTP SET COMPATIBILITY_LEVEL = 150
GO

USE db_PMTP
GO

-- ============================================================
-- 2. TABLOLARI OLUŞTURMA
-- ============================================================
-- Not: Bolum_ID, K_ID ve Kullanici_ID IDENTITY olarak tanımlandı.
-- Orijinal tasarımda bu alanlar IDENTITY değildi ve INSERT
-- sırasında değer verilmiyordu; bu NOT NULL ihlaline yol açıyordu.

-- --- tbl_Bolumler ---
CREATE TABLE dbo.tbl_Bolumler (
    Bolum_ID     INT IDENTITY(1,1) NOT NULL,
    Bolum_Adi    NVARCHAR(50) NULL,
    Bolum_Tel    NVARCHAR(50) NULL,
    Yonetici_ID  NVARCHAR(50) NULL,
    CONSTRAINT PK_tbl_Bolumler PRIMARY KEY CLUSTERED (Bolum_ID ASC)
);
GO

-- --- tbl_Kategoriler ---
-- Cinsiyet, unvan ve diğer sabit liste değerlerini tutan ortak
-- referans tablosu (lookup table).
CREATE TABLE dbo.tbl_Kategoriler (
    K_ID         INT IDENTITY(1,1) NOT NULL,
    Cinsiyet     NVARCHAR(50) NULL,
    Unvan        NVARCHAR(50) NULL,
    Ilce_Adi     NVARCHAR(50) NULL,
    Il_Adi       NVARCHAR(50) NULL,
    Ulke         NVARCHAR(50) NULL,
    Ay_Adi       NVARCHAR(50) NULL,
    Kitap_Turu   NVARCHAR(50) NULL,
    Yetki_Turu   NVARCHAR(50) NULL,
    CONSTRAINT PK_tbl_Kategoriler PRIMARY KEY CLUSTERED (K_ID ASC)
);
GO

-- --- tbl_Kullanicilar ---
CREATE TABLE dbo.tbl_Kullanicilar (
    Kullanici_ID     INT IDENTITY(1,1) NOT NULL,
    Kullanici_Adi    NVARCHAR(50) NULL,
    Kullanici_Sifre  NVARCHAR(50) NULL,
    Yetki_ID         INT NULL,
    CONSTRAINT PK_tbl_Kullanicilar PRIMARY KEY CLUSTERED (Kullanici_ID ASC)
);
GO

-- --- tbl_Personeller ---
CREATE TABLE dbo.tbl_Personeller (
    Pers_ID               INT IDENTITY(1,1) NOT NULL,
    Pers_Adi              NVARCHAR(50) NULL,
    Pers_Soyadi           NVARCHAR(50) NULL,
    Pers_DTarihi          DATE NULL,
    Pers_Giris_Tarihi     DATE NULL,
    Pers_Cikis_Tarihi     DATE NULL,
    Pers_Adresi           NVARCHAR(100) NULL,
    Pers_Ilcesi           NVARCHAR(50) NULL,
    Pers_Ili              NVARCHAR(50) NULL,
    Pers_Il_Kodu          NVARCHAR(10) NULL,
    Pers_Tel              NVARCHAR(50) NULL,
    Pers_Cep              NVARCHAR(50) NULL,
    Pers_Email            NVARCHAR(50) NULL,
    Bolum_ID              INT NULL,
    Cinsiyet_ID           INT NULL,
    Unvan_ID              INT NULL,
    Pers_Maas             MONEY NULL,
    Pers_Komisyon_Yuzdesi MONEY NULL,
    Pers_Foto             VARBINARY(MAX) NULL,
    Pers_SGK_No           NVARCHAR(10) NULL,
    Pers_TC_No            NVARCHAR(11) NULL,
    Pers_CV               NVARCHAR(50) NULL,
    Pers_CV_File          NVARCHAR(50) NULL,
    Pers_CV_Web           NVARCHAR(50) NULL,
    Pers_Aktif_Mi         BIT NULL,
    Kaydeden              NVARCHAR(50) NULL,
    Kayit_Tarihi          DATE NULL,
    Son_Kaydeden          NVARCHAR(50) NULL,
    Son_Kayit_Tarihi      DATE NOT NULL,
    Pers_Isim AS (Pers_Adi + ' ' + Pers_Soyadi),
    CONSTRAINT PK_tbl_Personeller PRIMARY KEY CLUSTERED (Pers_ID ASC)
);
GO

-- --- tbl_Maaslar ---
CREATE TABLE dbo.tbl_Maaslar (
    Maas_ID         INT IDENTITY(1,1) NOT NULL,
    Pers_ID         INT NULL,
    Maas_Tutari     MONEY NULL,
    Maas_Komisyonu  MONEY NULL,
    Maas_Tarihi     DATE NULL,
    Ay_ID           INT NULL,
    Maas_Toplam AS (ISNULL(Maas_Tutari, 0) + ISNULL(Maas_Komisyonu, 0)),
    Maas_Yili   AS (DATEPART(YEAR, Maas_Tarihi)),
    CONSTRAINT PK_tbl_Maaslar PRIMARY KEY CLUSTERED (Maas_ID ASC)
);
GO

-- ============================================================
-- 3. REFERANS VERİLERİNİ GİRME (önce lookup tabloları)
-- ============================================================
-- tbl_Kategoriler önce doldurulur, çünkü Personeller tablosu
-- Cinsiyet_ID ve Unvan_ID ile buraya referans verir.

INSERT INTO dbo.tbl_Kategoriler (Cinsiyet, Unvan, Ilce_Adi, Il_Adi, Ulke, Ay_Adi, Kitap_Turu, Yetki_Turu)
VALUES
    ('KADIN', 'YBS', 'BEYKOZ',      'İSTANBUL', 'TÜRKİYE', 'TEMMUZ',  'X', 'XX'),  -- K_ID 1
    ('ERKEK', 'YBS', 'BEYOĞLU',     'İSTANBUL', 'TÜRKİYE', 'OCAK',    'X', 'XX'),  -- K_ID 2
    ('KADIN', 'VTS', 'AVCILAR',     'İSTANBUL', 'TÜRKİYE', 'ŞUBAT',   'X', 'XX'),  -- K_ID 3
    ('ERKEK', 'YBS', 'MALTEPE',     'İSTANBUL', 'TÜRKİYE', 'MART',    'X', 'XX'),  -- K_ID 4
    ('KADIN', 'VTS', 'ESENYURT',    'İSTANBUL', 'TÜRKİYE', 'NİSAN',   'X', 'XX'),  -- K_ID 5
    ('KADIN', 'YBS', 'GÜNGÖREN',    'İSTANBUL', 'TÜRKİYE', 'MAYIS',   'X', 'XX'),  -- K_ID 6
    ('ERKEK', 'VTS', 'TUZLA',       'İSTANBUL', 'TÜRKİYE', 'HAZİRAN', 'X', 'XX'),  -- K_ID 7
    ('ERKEK', 'YBS', 'PENDİK',      'İSTANBUL', 'TÜRKİYE', 'AĞUSTOS', 'X', 'XX'),  -- K_ID 8
    ('ERKEK', 'VTS', 'ŞİŞHANE',     'İSTANBUL', 'TÜRKİYE', 'EYLÜL',   'X', 'XX'),  -- K_ID 9
    ('KADIN', 'YBS', 'TAKSİM',      'İSTANBUL', 'TÜRKİYE', 'EKİM',    'X', 'XX'),  -- K_ID 10
    ('KADIN', 'VTS', 'MECİDİYEKÖY', 'İSTANBUL', 'TÜRKİYE', 'KASIM',   'X', 'XX'),  -- K_ID 11
    ('ERKEK', 'YBS', 'AVCILAR',     'İSTANBUL', 'TÜRKİYE', 'ARALIK',  'X', 'XX');  -- K_ID 12
GO

INSERT INTO dbo.tbl_Bolumler (Bolum_Adi, Bolum_Tel, Yonetici_ID)
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
GO

-- ============================================================
-- 4. PERSONEL VERİLERİNİ GİRME
-- ============================================================
-- Cinsiyet_ID: 1=KADIN, 2=ERKEK (tbl_Kategoriler K_ID 1 ve 2)
-- Unvan_ID:    1=YBS,   3=VTS   (tbl_Kategoriler K_ID 1 ve 3)
-- Bolum_ID:    1=SİBER GÜVENLİK (tüm personel bu bölümde)

INSERT INTO dbo.tbl_Personeller
    (Pers_Adi, Pers_Soyadi, Pers_DTarihi, Pers_Giris_Tarihi, Pers_Cikis_Tarihi,
     Pers_Adresi, Pers_Ilcesi, Pers_Ili, Pers_Il_Kodu, Pers_Tel, Pers_Cep, Pers_Email,
     Bolum_ID, Cinsiyet_ID, Unvan_ID, Pers_Maas, Pers_Komisyon_Yuzdesi,
     Pers_SGK_No, Pers_TC_No, Pers_CV, Pers_CV_File, Pers_CV_Web, Pers_Aktif_Mi,
     Kaydeden, Kayit_Tarihi, Son_Kaydeden, Son_Kayit_Tarihi)
VALUES
    ('YAVUZ', 'SERTDEMİR', '1977-01-02', '2013-01-05', '2023-02-01',
     'YILDIZTEPE MAHALLESİ', 'BAĞCILAR', 'İSTANBUL', '34', '11233344', '98766321', 'sdemiryavuz@gmail.com',
     1, 2, 1, 40000, 10,
     '1234567', '85547477120', 'X', 'XX', 'XXX', 0,
     'ASLI ARSLAN', '2010-01-01', 'ASLI ARSLAN', '2023-01-05'),

    ('DİLAN', 'YALÇIN', '2004-08-01', '2021-01-05', '2024-02-01',
     'SANCAKTEPE MAHALLESİ', 'TAKSİM', 'İSTANBUL', '34', '11233345', '98766322', 'yalcindilan@gmail.com',
     1, 1, 1, 40000, 10,
     '1234567', '85547477130', 'X', 'XX', 'XXX', 1,
     'ASLI ARSLAN', '2022-01-01', 'ASLI ARSLAN', '2024-01-05'),

    ('ZEYNEP', 'BOZKURT', '2003-05-01', '2020-01-05', '2023-02-01',
     'SANCAKTEPE MAHALLESİ', 'SULTANGAZİ', 'İSTANBUL', '34', '11233346', '98766323', 'bozkurtzeynep@gmail.com',
     1, 1, 1, 60000, 10,
     '1234567', '85547477260', 'X', 'XX', 'XXX', 1,
     'ASLI ARSLAN', '2021-01-01', 'ASLI ARSLAN', '2022-01-05'),

    ('MELTEM', 'BAYRAM', '2002-09-01', '2019-01-05', '2022-02-01',
     'YÜZÜNCÜ YIL MAHALLESİ', 'FATİH', 'İSTANBUL', '34', '11233377', '98766378', 'meltembayram@gmail.com',
     1, 1, 1, 55000, 10,
     '1234567', '85547477140', 'X', 'XX', 'XXX', 1,
     'ASLI ARSLAN', '2019-01-01', 'ASLI ARSLAN', '2022-01-05'),

    ('MERVE', 'SERTDEMİR', '2004-07-09', '2021-01-09', '2024-02-01',
     'ŞEHİTLER CADDESİ', 'SARIYER', 'İSTANBUL', '34', '11233337', '98766337', 'sertdemirmervee@gmail.com',
     1, 1, 1, 40000, 10,
     '1234537', '85547477370', 'X', 'XX', 'XXX', 1,
     'ASLI ARSLAN', '2021-01-01', 'ASLI ARSLAN', '2024-01-05'),

    ('ESMA', 'İNAN', '2003-01-04', '2020-01-09', '2023-02-01',
     'ATATÜRK CADDESİ', 'BAKIRKÖY', 'İSTANBUL', '34', '11233342', '98766342', 'esmainan@gmail.com',
     1, 1, 1, 50000, 10,
     '1234537', '85547474200', 'X', 'XX', 'XXX', 1,
     'ASLI ARSLAN', '2021-01-01', 'ASLI ARSLAN', '2024-01-05');
GO

-- ============================================================
-- 5. KULLANICI VERİLERİNİ GİRME
-- ============================================================
-- Yetki_ID: tbl_Kategoriler.K_ID'ye referans verir (Yetki_Turu kolonu)

INSERT INTO dbo.tbl_Kullanicilar (Kullanici_Adi, Kullanici_Sifre, Yetki_ID)
VALUES
    ('MERVE',  '14586322', 2),
    ('YAVUZ',  '14586337', 1),
    ('DİLAN',  '14586345', 3),
    ('MELTEM', '14586377', 4),
    ('ZEYNEP', '14586741', 6),
    ('ESMA',   '14586742', 7);
GO

-- ============================================================
-- 6. MAAŞ VERİLERİNİ GİRME
-- ============================================================
-- Pers_ID değerleri gerçek personel kayıtlarına karşılık gelir
-- (1=YAVUZ, 2=DİLAN, 3=ZEYNEP, 4=MELTEM, 5=MERVE, 6=ESMA).
-- Orijinal scriptte bu alanlara 25-34 gibi var olmayan ID'ler
-- verilmişti; bu, foreign key ihlaline yol açıyordu.

INSERT INTO dbo.tbl_Maaslar (Pers_ID, Maas_Tarihi, Maas_Tutari, Maas_Komisyonu, Ay_ID)
VALUES
    (1, '2024-01-05', 40000, 10, 1),
    (2, '2024-07-05', 60000, 10, 7),
    (3, '2024-05-05', 40000, 10, 5),
    (4, '2024-08-05', 60000, 10, 8),
    (5, '2024-11-05', 55000, 10, 11),
    (6, '2024-06-05', 40000, 10, 6),
    (1, '2024-09-05', 50000, 10, 9);
GO

-- ============================================================
-- 7. FOREIGN KEY İLİŞKİLERİNİ KURMA
-- ============================================================
-- Veriler girildikten SONRA FK eklenir; böylece "WITH CHECK"
-- doğrulaması mevcut veriyle çalışır ve tutarsızlık varsa
-- hemen ortaya çıkar (sessizce atlanmaz).

ALTER TABLE dbo.tbl_Personeller
    ADD CONSTRAINT FK_Personeller_Bolumler
    FOREIGN KEY (Bolum_ID) REFERENCES dbo.tbl_Bolumler (Bolum_ID);
GO

ALTER TABLE dbo.tbl_Personeller
    ADD CONSTRAINT FK_Personeller_Kategoriler_Cinsiyet
    FOREIGN KEY (Cinsiyet_ID) REFERENCES dbo.tbl_Kategoriler (K_ID);
GO

ALTER TABLE dbo.tbl_Personeller
    ADD CONSTRAINT FK_Personeller_Kategoriler_Unvan
    FOREIGN KEY (Unvan_ID) REFERENCES dbo.tbl_Kategoriler (K_ID);
GO

ALTER TABLE dbo.tbl_Maaslar
    ADD CONSTRAINT FK_Maaslar_Personeller
    FOREIGN KEY (Pers_ID) REFERENCES dbo.tbl_Personeller (Pers_ID);
GO

ALTER TABLE dbo.tbl_Kullanicilar
    ADD CONSTRAINT FK_Kullanicilar_Kategoriler
    FOREIGN KEY (Yetki_ID) REFERENCES dbo.tbl_Kategoriler (K_ID);
GO

-- ============================================================
-- 8. DOĞRULAMA SORGULARI
-- ============================================================

SELECT * FROM dbo.tbl_Bolumler;
SELECT * FROM dbo.tbl_Kategoriler;
SELECT * FROM dbo.tbl_Kullanicilar;
SELECT * FROM dbo.tbl_Personeller;
SELECT * FROM dbo.tbl_Maaslar;

-- Personel ismi ve hesaplanan toplam maaşı birlikte göster
SELECT
    p.Pers_ID,
    p.Pers_Isim,
    b.Bolum_Adi,
    m.Maas_Tarihi,
    m.Maas_Tutari,
    m.Maas_Komisyonu,
    m.Maas_Toplam,
    m.Maas_Yili
FROM dbo.tbl_Personeller p
JOIN dbo.tbl_Maaslar m   ON p.Pers_ID = m.Pers_ID
JOIN dbo.tbl_Bolumler b  ON p.Bolum_ID = b.Bolum_ID
ORDER BY m.Maas_Tarihi;
GO

