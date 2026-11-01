enum Kategori {
  hepsi,
  elektronik,
  taki,
  erkekGiyim,
  kadinGiyim;

  static Kategori kategoriGetir(String isim) => switch (isim) {
    'electronics' => Kategori.elektronik,
    'jewelery' => Kategori.taki,
    "men's clothing" => Kategori.erkekGiyim,
    "women's clothing" => Kategori.kadinGiyim,
    _ => Kategori.hepsi,
  };
}
