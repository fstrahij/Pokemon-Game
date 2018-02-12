-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 12, 2018 at 04:19 PM
-- Server version: 10.1.13-MariaDB
-- PHP Version: 5.5.37

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bdprolog`
--

-- --------------------------------------------------------

--
-- Table structure for table `pokemoni`
--

CREATE TABLE `pokemoni` (
  `ID` int(11) NOT NULL,
  `pozicija` varchar(25) DEFAULT NULL,
  `kol_pok_lopti` int(11) DEFAULT NULL,
  `dzep` varchar(10) DEFAULT NULL,
  `pikachuHp` int(11) DEFAULT NULL,
  `charmanderHp` int(11) DEFAULT NULL,
  `squirtleHp` int(11) DEFAULT NULL,
  `bulbasaurHp` int(11) DEFAULT NULL,
  `poliwagHp` int(11) DEFAULT NULL,
  `pikachuE` int(11) DEFAULT NULL,
  `charmanderE` int(11) DEFAULT NULL,
  `squirtleE` int(11) DEFAULT NULL,
  `bulbasaurE` int(11) DEFAULT NULL,
  `br_napada` int(11) DEFAULT NULL,
  `damage` int(11) DEFAULT NULL,
  `inventar` varchar(200) DEFAULT NULL,
  `pikachu` varchar(10) DEFAULT NULL,
  `charmander` varchar(15) DEFAULT NULL,
  `squirtle` varchar(10) DEFAULT NULL,
  `bulbasaur` varchar(10) DEFAULT NULL,
  `vatreni_svijet` varchar(15) DEFAULT NULL,
  `vodeni_svijet` varchar(15) DEFAULT NULL,
  `kuca` varchar(5) DEFAULT NULL,
  `pokedex` varchar(10) DEFAULT NULL,
  `retracted` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pokemoni`
--

INSERT INTO `pokemoni` (`ID`, `pozicija`, `kol_pok_lopti`, `dzep`, `pikachuHp`, `charmanderHp`, `squirtleHp`, `bulbasaurHp`, `poliwagHp`, `pikachuE`, `charmanderE`, `squirtleE`, `bulbasaurE`, `br_napada`, `damage`, `inventar`, `pikachu`, `charmander`, `squirtle`, `bulbasaur`, `vatreni_svijet`, `vodeni_svijet`, `kuca`, `pokedex`, `retracted`) VALUES
(1, 'vodeni_svijet', 0, 'pokedex', 35, 39, 44, 45, 40, 0, 0, 0, 0, 0, 0, '[squirtle]', '0', '0', 'squirtle', '0', '0', '0', 'kuca', 'pokedex', '[squirtle,kuca,pokedex]');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `pokemoni`
--
ALTER TABLE `pokemoni`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `pokemoni`
--
ALTER TABLE `pokemoni`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
