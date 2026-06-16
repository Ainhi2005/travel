class TourEntity {
  final String id;
  final String slug;
  final String tenTour;
  final MoTa moTa;
  final Gia gia;
  final ThoiGianDi thoiGianDi;
  final List<dynamic> lichTrinh; 
  final List<String> giaBaoGom;
  final List<String> hinhAnh;
  final String danhMuc;
  final String diaDiem;
  final double soSao;
  final int soLuotDanhGia;
  final String? urlGoc;

  TourEntity({
    required this.id,
    required this.slug,
    required this.tenTour,
    required this.moTa,
    required this.gia,
    required this.thoiGianDi,
    required this.lichTrinh,
    required this.giaBaoGom,
    required this.hinhAnh,
    required this.danhMuc,
    required this.diaDiem,
    required this.soSao,
    required this.soLuotDanhGia,
    this.urlGoc,
  });
}

class MoTa {
  final String tongQuan;
  final List<String> diemNoiBat;

  MoTa({
    required this.tongQuan,
    required this.diemNoiBat,
  });
}

class Gia {
  final num nguoiLon;
  final num treEm;
  final String donViTienTe;

  Gia({
    required this.nguoiLon,
    required this.treEm,
    required this.donViTienTe,
  });
}

class ThoiGianDi {
  final String loaiTour;
  final String gioBatDau;
  final String gioKetThuc;
  final String xuatPhat;

  ThoiGianDi({
    required this.loaiTour,
    required this.gioBatDau,
    required this.gioKetThuc,
    required this.xuatPhat,
  });
}
