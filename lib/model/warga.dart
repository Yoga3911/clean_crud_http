import 'dart:convert';

List<Warga> wargaFromJson(String str) =>
    List<Warga>.from(json.decode(str).map((x) => Warga.fromJson(x)));

String wargaToJson(List<Warga> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Warga {
  Warga({
    required this.id,
    required this.nama,
    required this.umur,
  });

  final String id;
  final String nama;
  final String umur;

  factory Warga.fromJson(Map<String, dynamic> json) => Warga(
        id: json["id"],
        nama: json["nama"],
        umur: json["umur"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "umur": umur,
      };
}
