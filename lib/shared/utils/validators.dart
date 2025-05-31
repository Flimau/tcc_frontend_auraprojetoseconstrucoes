String? validarObrigatorio(String? value, {String campo = 'Campo'}) {
  if (value == null || value.trim().isEmpty) {
    return '$campo obrigatório';
  }
  return null;
}

String? validarCpf(String? value) {
  if (value == null || value.trim().isEmpty) return 'Informe o CPF';
  final regex = RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$');
  if (!regex.hasMatch(value)) return 'CPF inválido';
  return null;
}

String? validarCnpj(String? value) {
  if (value == null || value.trim().isEmpty) return 'Informe o CNPJ';
  final regex = RegExp(r'^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$');
  if (!regex.hasMatch(value)) return 'CNPJ inválido';
  return null;
}

String? validarCep(String? value) {
  if (value == null || value.trim().isEmpty) return 'Informe o CEP';
  final regex = RegExp(r'^\d{5}-\d{3}$');
  if (!regex.hasMatch(value)) return 'CEP inválido';
  return null;
}

String? validarEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Informe o e-mail';
  if (!value.contains('@') || !value.contains('.')) return 'E-mail inválido';
  return null;
}

String? validarData(String? value) {
  if (value == null || value.trim().isEmpty) return 'Informe a data';
  final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
  if (!regex.hasMatch(value)) return 'Data inválida (dd/mm/aaaa)';
  return null;
}
