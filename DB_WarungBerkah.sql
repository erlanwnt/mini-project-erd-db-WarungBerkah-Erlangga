CREATE DATABASE WarungBerkah;
GO
USE WarungBerkah;
GO

DROP TABLE IF EXISTS Rincian_Faktur;
DROP TABLE IF EXISTS Faktur;
DROP TABLE IF EXISTS Barang;
DROP TABLE IF EXISTS Distributor;

-- 1. Buat Tabel Distributor
CREATE TABLE Distributor (
    ID_Distributor VARCHAR(10) PRIMARY KEY,
    Nama_Supplier VARCHAR(100) NOT NULL,
    Tahun_Mulai_Kontrak INT,
    Jalan VARCHAR(100), 
    Kota VARCHAR(50),  
    Nomor_Kontak VARCHAR(50), 
    Detail_Cabang VARCHAR(MAX) 
);

-- 2. Buat Tabel Barang
CREATE TABLE Barang (
    ID_Barang VARCHAR(10) PRIMARY KEY,
    Nama_Barang VARCHAR(100) NOT NULL,
    Harga_Beli DECIMAL(18, 2),
    Harga_Jual DECIMAL(18, 2),
    Stok INT,
    -- Fitur Otomatis Margin 
    Margin AS (Harga_Jual - Harga_Beli)
);

-- 3. Buat Tabel Faktur
CREATE TABLE Faktur (
    No_Faktur VARCHAR(20) PRIMARY KEY,
    ID_Distributor VARCHAR(10) FOREIGN KEY REFERENCES Distributor(ID_Distributor),
    Tanggal_Pesan DATE,
    Tanggal_Terima DATE,
    
    Lama_Proses_Hari AS (DATEDIFF(day, Tanggal_Pesan, Tanggal_Terima))
);

-- 4. Buat Tabel Rincian Faktur
CREATE TABLE Rincian_Faktur (
    ID_Rincian INT IDENTITY(1,1) PRIMARY KEY,
    No_Faktur VARCHAR(20) FOREIGN KEY REFERENCES Faktur(No_Faktur),
    ID_Barang VARCHAR(10) FOREIGN KEY REFERENCES Barang(ID_Barang),
    Jumlah INT,
    Harga_Beli_Satuan DECIMAL(18, 2),
    -- Subtotal
    Subtotal AS (Jumlah * Harga_Beli_Satuan)
);

-- 5. Input Data Contoh
INSERT INTO Distributor (ID_Distributor, Nama_Supplier, Detail_Cabang, Jalan, Kota, Nomor_Kontak, Tahun_Mulai_Kontrak)
VALUES 
('D001', 'PT. Sumber Makmur', 'Sukabumi, Solo, Cirebon', 'Jl. Industri No. 1', 'Jakarta', '0812345678', 2018),
('D002', 'PT. Snack Jaya', 'Depok, Bekasi', 'Jl. Raya Snack No. 5', 'Bekasi', '0899876543', 2020);

INSERT INTO Barang (ID_Barang, Nama_Barang, Harga_Beli, Harga_Jual, Stok)
VALUES 
('B001', 'Beras Premium', 10000, 12000, 100),
('B002', 'Minyak Goreng', 14000, 16500, 50),
('B003', 'Sabun Mandi', 3000, 4500, 200),
('B004', 'Keripik Kentang', 8000, 11000, 80);

INSERT INTO Faktur (No_Faktur, ID_Distributor, Tanggal_Pesan, Tanggal_Terima)
VALUES 
('F001', 'D001', '2026-01-10', '2026-01-15'),
('F002', 'D001', '2026-02-15', '2026-02-17'),
('F003', 'D002', '2026-03-01', '2026-03-02');

INSERT INTO Rincian_Faktur (No_Faktur, ID_Barang, Jumlah, Harga_Beli_Satuan)
VALUES 
('F001', 'B001', 10, 10000),
('F001', 'B002', 5, 14000),
('F002', 'B003', 20, 3000),
('F003', 'B004', 15, 8000);

-- Hasil Akhir
SELECT * FROM Faktur;
SELECT * FROM Barang;
