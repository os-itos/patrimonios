enum UserRole {
  admin,
  professor;

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'professor':
        return UserRole.professor;
      default:
        throw ArgumentError('Role invalida: $value');
    }
  }

  String get value {
    return name;
  }
}

class Usuario {
  final int id;
  final String nome;
  final String email;
  final UserRole role;
  final String? telefone;
  final String? matricula;
  final String? departamento;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.role,
    this.telefone,
    this.matricula,
    this.departamento,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isProfessor => role == UserRole.professor;

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: (json['id'] as num).toInt(),
      nome: json['nome']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: UserRole.fromString(
        json['role']?.toString() ?? '',
      ),
      telefone: json['telefone']?.toString(),
      matricula: json['matricula']?.toString(),
      departamento: json['departamento']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'role': role.value,
      'telefone': telefone,
      'matricula': matricula,
      'departamento': departamento,
    };
  }
}
