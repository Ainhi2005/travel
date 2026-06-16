import '../../domain/entities/tour_entity.dart';

class TourModel extends TourEntity {
  TourModel({
    required super.id,
    required super.slug,
    required super.tenTour,
    required super.moTa,
    required super.gia,
    required super.thoiGianDi,
    required super.lichTrinh,
    required super.giaBaoGom,
    required super.hinhAnh,
    required super.danhMuc,
    required super.diaDiem,
    required super.soSao,
    required super.soLuotDanhGia,
    super.urlGoc,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      tenTour: json['ten_tour'] ?? '',
      moTa: MoTa(
        tongQuan: json['mo_ta']?['tong_quan'] ?? '',
        diemNoiBat: List<String>.from(json['mo_ta']?['diem_noi_bat'] ?? []),
      ),
      gia: Gia(
        nguoiLon: json['gia']?['nguoi_lon'] ?? 0,
        treEm: json['gia']?['tre_em'] ?? 0,
        donViTienTe: json['gia']?['don_vi_tien_te'] ?? 'VND',
      ),
      thoiGianDi: ThoiGianDi(
        loaiTour: json['thoi_gian_di']?['loai_tour'] ?? '',
        gioBatDau: json['thoi_gian_di']?['gio_bat_dau'] ?? '',
        gioKetThuc: json['thoi_gian_di']?['gio_ket_thuc'] ?? '',
        xuatPhat: json['thoi_gian_di']?['xuat_phat'] ?? '',
      ),
      lichTrinh: json['lich_trinh'] != null ? List<dynamic>.from(json['lich_trinh']) : [],
      giaBaoGom: List<String>.from(json['gia_bao_gom'] ?? []),
      hinhAnh: List<String>.from(json['hinh_anh'] ?? []),
      danhMuc: json['danh_muc'] ?? '',
      diaDiem: json['dia_diem'] ?? '',
      soSao: (json['so_sao'] as num?)?.toDouble() ?? 0.0,
      soLuotDanhGia: json['so_luot_danh_gia'] ?? 0,
      urlGoc: json['url_goc'],
    );
  }
}
