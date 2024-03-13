/*
Created: 16/01/2023
Modified: 17/01/2023
Model: Microsoft
Database: MS SQL Server 2019
*/

CREATE DATABASE Warsztat
GO
USE Warsztat
GO
-- Create tables section -------------------------------------------------

-- Table klienci

CREATE TABLE [klienci]
(
 [idKlienta] Bigint IDENTITY (1,1) NOT NULL,
 [imie] Varchar(30) NULL,
 [nazwisko] Varchar(30) NOT NULL,
 [adres] Varchar(50) NOT NULL,
 [PESEL] Char(11) NOT NULL,
  CONSTRAINT [CHK_PoprawnyPESELKlient] CHECK (PESEL NOT LIKE '%[^0-9]%')
)
go

-- Add keys for table klienci

ALTER TABLE [klienci] ADD CONSTRAINT [PK_klienci] PRIMARY KEY ([idKlienta])
go

ALTER TABLE [klienci] ADD CONSTRAINT [PESEL_klienci] UNIQUE ([PESEL])
go

-- Table naprawiane_samochody

CREATE TABLE [naprawiane_samochody]
(
 [idSamochodu] Bigint IDENTITY (1,1) NOT NULL,
 [marka] Varchar(30) NOT NULL,
 [model] Varchar(50) NOT NULL,
 [rodzaj_silnika] Varchar(15) NOT NULL,
 [rejestracja] Varchar(15) NOT NULL,
 [wlasciciel] Bigint NOT NULL
)
go

-- Create indexes for table naprawiane_samochody

CREATE INDEX [IX_Wlasciciel] ON [naprawiane_samochody] ([wlasciciel])
go

CREATE INDEX [IX_Silnik] ON [naprawiane_samochody] ([rodzaj_silnika])
go

-- Add keys for table naprawiane_samochody

ALTER TABLE [naprawiane_samochody] ADD CONSTRAINT [PK_naprawiane_samochody] PRIMARY KEY ([idSamochodu])
go

ALTER TABLE [naprawiane_samochody] ADD CONSTRAINT [rejestracja] UNIQUE ([rejestracja])
go

-- Table naprawy

CREATE TABLE [naprawy]
(
 [idNaprawy] Bigint NOT NULL,
 [kwotaZaplaty] Decimal(19,3) NOT NULL,
 [dataOddania] Date DEFAULT GetDate() NOT NULL,
 [dataOdbioru] Date NULL,
 [kierownik] Bigint NOT NULL,
  CONSTRAINT [CHK_PoprawneDaty] CHECK (dataOddania <= dataOdbioru)
)
go

-- Create indexes for table naprawy

CREATE INDEX [IX_Kieruje] ON [naprawy] ([kierownik])
go

-- Add keys for table naprawy

ALTER TABLE [naprawy] ADD CONSTRAINT [PK_naprawy] PRIMARY KEY ([idNaprawy])
go

-- Table pracownicy

CREATE TABLE [pracownicy]
(
 [idPracownika] Bigint IDENTITY (1,1) NOT NULL,
 [imie] Varchar(30) NULL,
 [nazwisko] Varchar(30) NOT NULL,
 [adres] Varchar(50) NOT NULL,
 [PESEL] Char(11) NOT NULL,
 [dataZatrudnienia] Date NOT NULL,
  CONSTRAINT [CHK_PoprawnyPESELPracownik] CHECK (PESEL NOT LIKE '%[^0-9]%')
)
go

-- Add keys for table pracownicy

ALTER TABLE [pracownicy] ADD CONSTRAINT [PK_pracownicy] PRIMARY KEY ([idPracownika])
go

ALTER TABLE [pracownicy] ADD CONSTRAINT [PESEL_pracownicy] UNIQUE ([PESEL])
go

-- Table wykonana_praca

CREATE TABLE [wykonana_praca]
(
 [idPracy] Bigint IDENTITY (1,1) NOT NULL,
 [opis] Varchar(100) NULL,
 [czasWykonania] Int NULL,
 [koszt] Decimal(19,3) NOT NULL,
 [idNaprawy] Bigint NOT NULL,
 [nazwa] Varchar(50) NOT NULL
)
go

-- Create indexes for table wykonana_praca

CREATE INDEX [IX_Nazwa] ON [wykonana_praca] ([nazwa])
go

-- Add keys for table wykonana_praca

ALTER TABLE [wykonana_praca] ADD CONSTRAINT [PK_wykonana_praca] PRIMARY KEY ([idPracy],[idNaprawy])
go

-- Table wykonawcy_pracy

CREATE TABLE [wykonawcy_pracy]
(
 [idPracy] Bigint NOT NULL,
 [idNaprawy] Bigint NOT NULL,
 [idPracownika] Bigint NOT NULL
)
go

-- Add keys for table wykonawcy_pracy

ALTER TABLE [wykonawcy_pracy] ADD CONSTRAINT [PK_wykonawcy_pracy] PRIMARY KEY ([idPracy],[idNaprawy],[idPracownika])
go

-- Table nazwy_czynnosci

CREATE TABLE [nazwy_czynnosci]
(
 [nazwa] Varchar(50) NOT NULL
)
go

-- Add keys for table nazwy_czynnosci

ALTER TABLE [nazwy_czynnosci] ADD CONSTRAINT [PK_nazwy_czynnosci] PRIMARY KEY ([nazwa])
go

-- Table rodzaje_silnika

CREATE TABLE [rodzaje_silnika]
(
 [oznaczenie_silnika] Varchar(15) NOT NULL
)
go

-- Add keys for table rodzaje_silnika

ALTER TABLE [rodzaje_silnika] ADD CONSTRAINT [PK_rodzaje_silnika] PRIMARY KEY ([oznaczenie_silnika])
go

-- Create foreign keys (relationships) section ------------------------------------------------- 


ALTER TABLE [naprawiane_samochody] ADD CONSTRAINT [Oddaje] FOREIGN KEY ([wlasciciel]) REFERENCES 
[klienci] ([idKlienta]) ON UPDATE CASCADE ON DELETE NO ACTION
go



ALTER TABLE [naprawy] ADD CONSTRAINT [Wykonana_na] FOREIGN KEY ([idNaprawy]) REFERENCES 
[naprawiane_samochody] ([idSamochodu]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [wykonana_praca] ADD CONSTRAINT [Wchodzi_w_sklad] FOREIGN KEY ([idNaprawy]) REFERENCES 
[naprawy] ([idNaprawy]) ON UPDATE CASCADE ON DELETE NO ACTION
go



ALTER TABLE [naprawy] ADD CONSTRAINT [Kieruje] FOREIGN KEY ([kierownik]) REFERENCES 
[pracownicy] ([idPracownika]) ON UPDATE CASCADE ON DELETE NO ACTION
go



ALTER TABLE [wykonawcy_pracy] ADD CONSTRAINT [Charakteryzuje_prace] FOREIGN KEY ([idPracy], [idNaprawy]) REFERENCES 
[wykonana_praca] ([idPracy], [idNaprawy]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [wykonawcy_pracy] ADD CONSTRAINT [Charakteryzuje_wykonawce] FOREIGN KEY ([idPracownika]) REFERENCES 
[pracownicy] ([idPracownika]) ON UPDATE CASCADE ON DELETE NO ACTION
go



ALTER TABLE [wykonana_praca] ADD CONSTRAINT [Nazywa_prace] FOREIGN KEY ([nazwa]) REFERENCES 
[nazwy_czynnosci] ([nazwa]) ON UPDATE CASCADE ON DELETE NO ACTION
go



ALTER TABLE [naprawiane_samochody] ADD CONSTRAINT [Charakteryzuje_silnik] FOREIGN KEY ([rodzaj_silnika]) REFERENCES 
[rodzaje_silnika] ([oznaczenie_silnika]) ON UPDATE CASCADE ON DELETE NO ACTION
go

-- Insert Values into the database section ------------------------------------------------------------------------


INSERT INTO klienci(imie, nazwisko, adres, PESEL)
VALUES 
( 'Adrian', 'Tomala', 'Kraków, ul.Pomagierów 7', '02300908253'),
( 'Kamila', 'Starina', 'Kraków, ul.Prądnicka 20', '07896754022'),
( 'Tomasz', 'Andrzejczyk', 'Wrocław, ul.Matejeczna 32', '08765465489')


INSERT INTO rodzaje_silnika (oznaczenie_silnika)
VALUES
('VQ35DE'),
('CCWA'),
('X20XER')

INSERT INTO naprawiane_samochody (marka, model, rodzaj_silnika, rejestracja, wlasciciel)
VALUES
('Nissan', '350Z', 'VQ35DE', 'KR198XX', 1),
('Audi', 'Q5', 'CCWA', 'KRA4935Y', 2),
('Opel', 'Astra G Sedan', 'X20XER', 'DWR47A5', 3),
('Nissan', '350Z', 'VQ35DE', 'DWR50A2', 1)


INSERT INTO pracownicy (imie, nazwisko, adres, PESEL, dataZatrudnienia)
VALUES
('Norbert', 'Gierczak', 'Kraków, ul.Orkowa 31', '06972695671', '2023-01-17'),
('Karolina', 'Mikołajczyk', 'Kraków, ul.Bajeczna 40', '07657754972', '2022-12-10'),
('Tomasz', 'Zapała', 'Kraków, ul.Malarska 3', '76547887751', '2022-07-16')

GO
SET IDENTITY_INSERT naprawy ON
GO

INSERT INTO naprawy (idNaprawy, kwotaZaplaty, dataOddania, dataOdbioru, kierownik)
VALUES
(1, 15000, '2023-01-06', '2023-01-25', 3),
(2, 500, DEFAULT, '2023-03-20', 3),
(3, 1500, '2022-12-27', '2023-01-27', 2),
(4, 500, DEFAULT, '2023-03-20', 2)


INSERT INTO nazwy_czynnosci (nazwa)
VALUES
('Wymiana klocków hamulcowych'),
('Wymiana skrzyni biegów'),
('Diagnoza'),
('Wymiana zacisków hamulca')

INSERT INTO wykonana_praca (opis, czasWykonania, koszt, idNaprawy, nazwa)
VALUES
('Całkowite wymienienie skrzyni biegów', 17, 15000, 1, 'Wymiana skrzyni biegów'),
(null, 2, 500, 2, 'Diagnoza'),
('Wymiana klocków hamulocwych przy obu przednich kołach', 4, 850, 3, 'Wymiana klocków hamulcowych'),
('Wymiana zacisków hamulca przy obu przednich kołach', 2, 650, 3, 'Wymiana zacisków hamulca'),
(null, 2, 500, 4, 'Diagnoza')

INSERT INTO wykonawcy_pracy (idPracy,idNaprawy, idPracownika)
VALUES
(1, 1, 1),
(1, 1, 2),
(2, 2, 1),
(3, 3, 3),
(4, 3, 3),
(5, 4, 2)


--INSERTS THAT WILL THROW ERRORS
/*

--------Naruszenie poprawności dat
INSERT INTO naprawy (idNaprawy, kwotaZaplaty, dataOddania, dataOdbioru, kierownik)
VALUES
(5, 15000, '2023-01-06', '2022-01-25', 3),


--------Naruszenie poprawności PESEL
INSERT INTO klienci(imie, nazwisko, adres, PESEL)
VALUES 
( 'Mariusz', 'Tomala', 'Kraków, ul.Pomagierów 7', '0230090825A')

INSERT INTO pracownicy (imie, nazwisko, adres, PESEL, dataZatrudnienia)
VALUES
('Norbert', 'Gierczak', 'Kraków, ul.Orkowa 31', '0697269567B', '2023-01-17')

*/



