class CodigoPostal {
  final String zip_code_full_wiew_id;
  final String codigo_postal;
  final String nombre_ciudad;
  final String nombre_estado;

  CodigoPostal(
      {required this.zip_code_full_wiew_id,
      required this.codigo_postal,
      required this.nombre_ciudad,
      required this.nombre_estado});

  factory CodigoPostal.fromJson(Map<String, dynamic> json) => CodigoPostal(
      zip_code_full_wiew_id: json['zip_code_full_wiew_id'],
      codigo_postal: json['codigo_postal'],
      nombre_ciudad: json['nombre_ciudad'],
      nombre_estado: json['nombre_estado']);
  Map<String, dynamic> toJson() => {
        "zip_code_full_wiew_id": zip_code_full_wiew_id,
        "codigo_postal": codigo_postal,
        "nombre_ciudad": nombre_ciudad,
        "nombre_estado": nombre_estado
      };

  @override
  String toString() {
    return "$codigo_postal - $nombre_ciudad - $nombre_estado";
    //return "CodigoPostal(zip_code_full_wiew_id: $zip_code_full_wiew_id, codigo_postal: $codigo_postal, nombre_ciudad: $nombre_ciudad, nombre_estado: $nombre_estado))";
  }
}
