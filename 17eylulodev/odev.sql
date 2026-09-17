--öğrenci ile ders  arasında çoka çok ilişkisi olduğu için araya köprü gerek
--farklı bölümlerde ortak dersler olabilr diye onu da çoka çok çalışabilcek şekilde köprü ekledim
CREATE TABLE IF NOT EXISTS bolumler (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    bolum_kodu TEXT UNIQUE NOT NULL,
    bolum_adi TEXT UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS ogrenciler (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ogrenci_no TEXT UNIQUE NOT NULL,
    ad_soyad TEXT NOT NULL,
    bolum_id INTEGER NOT NULL,

    FOREIGN KEY (bolum_id) REFERENCES bolumler(id)
);


CREATE TABLE IF NOT EXISTS dersler (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ders_kodu TEXT UNIQUE NOT NULL,
    ders_adi TEXT NOT NULL,
    kredi INTEGER NOT NULL
);


CREATE TABLE IF NOT EXISTS bolum_ders (
    bolum_id INTEGER NOT NULL,
    ders_id INTEGER NOT NULL,

    PRIMARY KEY (bolum_id, ders_id),
    FOREIGN KEY (bolum_id) REFERENCES bolumler(id) ON DELETE CASCADE,
    FOREIGN KEY (ders_id) REFERENCES dersler(id) ON DELETE CASCADE
);



CREATE TABLE IF NOT EXISTS kayitlar (
    ogrenci_id INTEGER NOT NULL,
    ders_id INTEGER NOT NULL,
    final_notu INTEGER,

    PRIMARY KEY (ogrenci_id, ders_id),
    FOREIGN KEY (ogrenci_id) REFERENCES ogrenciler(id) ON DELETE CASCADE,
    FOREIGN KEY (ders_id) REFERENCES dersler(id) ON DELETE CASCADE
);
