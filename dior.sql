-- --------------------------------------------------------
-- Sunucu:                       127.0.0.1
-- Sunucu sürümü:                10.4.32-MariaDB - mariadb.org binary distribution
-- Sunucu İşletim Sistemi:       Win64
-- HeidiSQL Sürüm:               12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- dior için veritabanı yapısı dökülüyor
CREATE DATABASE IF NOT EXISTS `dior` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `dior`;

-- tablo yapısı dökülüyor dior.siparisler
CREATE TABLE IF NOT EXISTS `siparisler` (
  `siparisID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) DEFAULT NULL,
  `SiparisTarihi` datetime NOT NULL DEFAULT current_timestamp(),
  `Durum` varchar(50) DEFAULT 'Beklemede',
  `ToplamFiyat` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`siparisID`),
  KEY `userID` (`userID`),
  CONSTRAINT `siparisler_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- dior.siparisler: ~4 rows (yaklaşık) tablosu için veriler indiriliyor
INSERT INTO `siparisler` (`siparisID`, `userID`, `SiparisTarihi`, `Durum`, `ToplamFiyat`) VALUES
	(1, 1, '2025-05-19 16:14:20', 'Beklemede', 200.00),
	(2, 2, '2025-05-23 15:09:43', 'hazırlanıyor', 7150.00),
	(3, 3, '2025-05-23 15:38:58', 'Beklemede', 12650.00),
	(4, 1, '2025-05-23 16:09:03', 'Beklemede', 5500.00);

-- tablo yapısı dökülüyor dior.siparis_detaylari
CREATE TABLE IF NOT EXISTS `siparis_detaylari` (
  `detayID` int(11) NOT NULL AUTO_INCREMENT,
  `siparisID` int(11) DEFAULT NULL,
  `urunID` int(11) DEFAULT NULL,
  `adet` int(11) NOT NULL,
  `fiyat` decimal(10,2) NOT NULL,
  PRIMARY KEY (`detayID`),
  KEY `siparisID` (`siparisID`),
  KEY `urunID` (`urunID`),
  CONSTRAINT `siparis_detaylari_ibfk_1` FOREIGN KEY (`siparisID`) REFERENCES `siparisler` (`siparisID`),
  CONSTRAINT `siparis_detaylari_ibfk_2` FOREIGN KEY (`urunID`) REFERENCES `urunler` (`urunID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- dior.siparis_detaylari: ~5 rows (yaklaşık) tablosu için veriler indiriliyor
INSERT INTO `siparis_detaylari` (`detayID`, `siparisID`, `urunID`, `adet`, `fiyat`) VALUES
	(1, 1, 1, 2, 100.00),
	(2, 2, 1, 2, 1375.00),
	(3, 2, 2, 2, 2200.00),
	(4, 3, 1, 6, 1375.00),
	(5, 3, 2, 2, 2200.00),
	(6, 4, 1, 4, 1375.00);

-- tablo yapısı dökülüyor dior.urunler
CREATE TABLE IF NOT EXISTS `urunler` (
  `urunID` int(11) NOT NULL AUTO_INCREMENT,
  `kategori` varchar(100) DEFAULT NULL,
  `urunAdi` varchar(255) NOT NULL,
  `fiyat` decimal(10,2) NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `adet` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`urunID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- dior.urunler: ~3 rows (yaklaşık) tablosu için veriler indiriliyor
INSERT INTO `urunler` (`urunID`, `kategori`, `urunAdi`, `fiyat`, `foto`, `adet`) VALUES
	(1, 'Allık', 'rosy glow', 1375.00, 'allık.jpg', 188),
	(2, 'Fondoten', 'dior skin glow', 2200.00, 'resim1.jpg', 0);

-- tablo yapısı dökülüyor dior.users
CREATE TABLE IF NOT EXISTS `users` (
  `userID` int(11) NOT NULL AUTO_INCREMENT,
  `isim` varchar(100) DEFAULT NULL,
  `soyisim` varchar(100) DEFAULT NULL,
  `mail` varchar(255) NOT NULL,
  `sifre` varchar(100) DEFAULT NULL,
  `kayitTarihi` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`userID`),
  UNIQUE KEY `mail` (`mail`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- dior.users: ~2 rows (yaklaşık) tablosu için veriler indiriliyor
INSERT INTO `users` (`userID`, `isim`, `soyisim`, `mail`, `sifre`, `kayitTarihi`) VALUES
	(1, 'Merve', 'Demirbas', 'merve@gmail.com', 'merve123', '2025-05-19 16:10:59'),
	(2, 'Beyza', 'beyza', 'beyza@gmail.com', 'beyza123', '2025-05-19 16:12:17'),
	(3, 'sudenur', 'kırbaş', 'sude123@gmail.com', 'sude111', '2025-05-20 16:09:53');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
