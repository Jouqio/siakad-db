-- =====================================================
-- DATABASE SIAKAD (Sistem Informasi Akademik)
-- File siap import ke phpMyAdmin
-- =====================================================

-- Buat database
CREATE DATABASE IF NOT EXISTS siakad 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_general_ci;

USE siakad;

-- =====================================================
-- 1. TABEL MAHASISWA
-- =====================================================
DROP TABLE IF EXISTS mahasiswa;
CREATE TABLE mahasiswa (
    nim VARCHAR(10) PRIMARY KEY,
    nama_lengkap VARCHAR(100) NOT NULL,
    jenis_kelamin ENUM('Laki-laki', 'Perempuan') NOT NULL,
    tanggal_lahir DATE NOT NULL,
    tempat_lahir VARCHAR(50),
    alamat TEXT,
    no_telepon VARCHAR(15),
    email VARCHAR(50),
    jurusan VARCHAR(50),
    angkatan YEAR,
    status ENUM('Aktif', 'Cuti', 'Lulus', 'Drop Out') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO mahasiswa VALUES
('2021001', 'Budi Santoso', 'Laki-laki', '2003-05-12', 'Jakarta', 'Jl. Merdeka No. 10', '081234567890', 'budi@email.com', 'Teknik Informatika', 2021, 'Aktif'),
('2021002', 'Siti Nurhaliza', 'Perempuan', '2003-08-20', 'Bandung', 'Jl. Asia Afrika No. 5', '081234567891', 'siti@email.com', 'Sistem Informasi', 2021, 'Aktif'),
('2022003', 'Ahmad Fauzi', 'Laki-laki', '2004-01-15', 'Surabaya', 'Jl. Diponegoro No. 22', '081234567892', 'ahmad@email.com', 'Teknik Informatika', 2022, 'Aktif'),
('2022004', 'Dewi Lestari', 'Perempuan', '2004-03-10', 'Yogyakarta', 'Jl. Malioboro No. 8', '081234567893', 'dewi@email.com', 'Manajemen Informatika', 2022, 'Aktif'),
('2023005', 'Rizky Pratama', 'Laki-laki', '2005-07-25', 'Medan', 'Jl. Gatot Subroto No. 17', '081234567894', 'rizky@email.com', 'Sistem Informasi', 2023, 'Aktif'),
('2023006', 'Putri Ayu', 'Perempuan', '2005-11-30', 'Semarang', 'Jl. Pandanaran No. 3', '081234567895', 'putri@email.com', 'Teknik Informatika', 2023, 'Cuti');

-- =====================================================
-- 2. TABEL DOSEN
-- =====================================================
DROP TABLE IF EXISTS dosen;
CREATE TABLE dosen (
    nip VARCHAR(10) PRIMARY KEY,
    nama_dosen VARCHAR(100) NOT NULL,
    jenis_kelamin ENUM('Laki-laki', 'Perempuan'),
    email VARCHAR(50),
    no_telepon VARCHAR(15),
    pendidikan_terakhir VARCHAR(10),
    bidang_keahlian VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO dosen VALUES
('D001', 'Dr. Hendra Wijaya, M.Kom', 'Laki-laki', 'hendra@kampus.ac.id', '081298765432', 'S3', 'Kecerdasan Buatan'),
('D002', 'Prof. Sri Mulyani, M.T', 'Perempuan', 'sri@kampus.ac.id', '081298765433', 'S3', 'Rekayasa Perangkat Lunak'),
('D003', 'Ir. Bambang Sutrisno, M.Kom', 'Laki-laki', 'bambang@kampus.ac.id', '081298765434', 'S2', 'Jaringan Komputer'),
('D004', 'Dr. Rina Marlina, M.Si', 'Perempuan', 'rina@kampus.ac.id', '081298765435', 'S3', 'Basis Data'),
('D005', 'Yusuf Hamdani, M.Kom', 'Laki-laki', 'yusuf@kampus.ac.id', '081298765436', 'S2', 'Pemrograman Web');

-- =====================================================
-- 3. TABEL MATA KULIAH
-- =====================================================
DROP TABLE IF EXISTS mata_kuliah;
CREATE TABLE mata_kuliah (
    kode_mk VARCHAR(10) PRIMARY KEY,
    nama_mk VARCHAR(100) NOT NULL,
    sks INT NOT NULL,
    semester INT,
    nip_dosen VARCHAR(10),
    FOREIGN KEY (nip_dosen) REFERENCES dosen(nip)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO mata_kuliah VALUES
('MK001', 'Algoritma dan Pemrograman', 3, 1, 'D001'),
('MK002', 'Basis Data', 3, 3, 'D004'),
('MK003', 'Pemrograman Web', 3, 4, 'D005'),
('MK004', 'Jaringan Komputer', 3, 5, 'D003'),
('MK005', 'Rekayasa Perangkat Lunak', 3, 5, 'D002'),
('MK006', 'Kecerdasan Buatan', 3, 6, 'D001');

-- =====================================================
-- 4. TABEL KRS (Kartu Rencana Studi)
-- =====================================================
DROP TABLE IF EXISTS krs;
CREATE TABLE krs (
    id_krs INT AUTO_INCREMENT PRIMARY KEY,
    nim VARCHAR(10),
    kode_mk VARCHAR(10),
    semester_ambil INT,
    tahun_ajaran VARCHAR(10),
    nilai_huruf CHAR(2),
    nilai_angka DECIMAL(4,2),
    FOREIGN KEY (nim) REFERENCES mahasiswa(nim)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (kode_mk) REFERENCES mata_kuliah(kode_mk)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO krs (nim, kode_mk, semester_ambil, tahun_ajaran, nilai_huruf, nilai_angka) VALUES
('2021001', 'MK001', 1, '2021/2022', 'A', 4.00),
('2021001', 'MK002', 3, '2022/2023', 'A-', 3.75),
('2021002', 'MK001', 1, '2021/2022', 'B+', 3.30),
('2022003', 'MK003', 4, '2023/2024', 'A', 4.00),
('2022004', 'MK002', 3, '2023/2024', 'B', 3.00),
('2023005', 'MK001', 1, '2023/2024', 'A-', 3.75);

-- =====================================================
-- 5. TABEL JADWAL KULIAH
-- =====================================================
DROP TABLE IF EXISTS jadwal_kuliah;
CREATE TABLE jadwal_kuliah (
    id_jadwal INT AUTO_INCREMENT PRIMARY KEY,
    kode_mk VARCHAR(10),
    hari ENUM('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'),
    jam_mulai TIME,
    jam_selesai TIME,
    ruangan VARCHAR(20),
    FOREIGN KEY (kode_mk) REFERENCES mata_kuliah(kode_mk)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO jadwal_kuliah (kode_mk, hari, jam_mulai, jam_selesai, ruangan) VALUES
('MK001', 'Senin', '08:00:00', '10:30:00', 'Ruang A101'),
('MK002', 'Selasa', '10:30:00', '13:00:00', 'Ruang B202'),
('MK003', 'Rabu', '13:00:00', '15:30:00', 'Lab Komputer 1'),
('MK004', 'Kamis', '08:00:00', '10:30:00', 'Lab Jaringan'),
('MK005', 'Jumat', '08:00:00', '10:30:00', 'Ruang C303'),
('MK006', 'Sabtu', '09:00:00', '11:30:00', 'Ruang A102');

-- =====================================================
-- 6. TABEL PEMBAYARAN UKT
-- =====================================================
DROP TABLE IF EXISTS pembayaran_ukt;
CREATE TABLE pembayaran_ukt (
    id_pembayaran INT AUTO_INCREMENT PRIMARY KEY,
    nim VARCHAR(10),
    semester INT,
    tahun_ajaran VARCHAR(10),
    jumlah_bayar DECIMAL(10,2),
    tanggal_bayar DATE,
    metode_pembayaran ENUM('Transfer Bank', 'Virtual Account', 'Tunai'),
    status ENUM('Lunas', 'Belum Lunas') DEFAULT 'Belum Lunas',
    FOREIGN KEY (nim) REFERENCES mahasiswa(nim)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO pembayaran_ukt (nim, semester, tahun_ajaran, jumlah_bayar, tanggal_bayar, metode_pembayaran, status) VALUES
('2021001', 1, '2021/2022', 3500000.00, '2021-08-15', 'Transfer Bank', 'Lunas'),
('2021001', 3, '2022/2023', 3500000.00, '2022-08-10', 'Virtual Account', 'Lunas'),
('2021002', 1, '2021/2022', 3500000.00, '2021-08-20', 'Transfer Bank', 'Lunas'),
('2022003', 4, '2023/2024', 4000000.00, '2023-08-12', 'Virtual Account', 'Lunas'),
('2022004', 3, '2023/2024', 3800000.00, NULL, NULL, 'Belum Lunas'),
('2023005', 1, '2023/2024', 4000000.00, '2023-08-25', 'Tunai', 'Lunas');

-- =====================================================
-- SELESAI - Database SIAKAD siap digunakan
-- =====================================================