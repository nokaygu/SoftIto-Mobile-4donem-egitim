enum Kategori {
  hepsi('Tümü', 'H'),
  elektronik('Elektronik', 'E'),
  giyim('Giyim', 'G'),
  ayakkabi('Ayakkabı', 'A'),
  aksesuar('Aksesuar', 'AK');

  final String baslik;
  final String ikon;

  const Kategori(this.baslik, this.ikon);

  static Kategori? fromApi(String name) {
    switch (name.toLowerCase()) {
      case 'electronics':
        return elektronik;
      case 'jewelery':
        return aksesuar;
      case 'men\'s clothing':
        return giyim;
      case 'women\'s clothing':
        return giyim;
      default:
        return ayakkabi;
    }
  }
}
