String formatarDataParaIso(String dataBr) {
  final partes = dataBr.split('/');
  if (partes.length != 3) return '';
  final dia = partes[0];
  final mes = partes[1];
  final ano = partes[2];
  return '$ano-$mes-$dia';
}

String formatarDataParaBr(String dataIso) {
  final partes = dataIso.split('-');
  if (partes.length != 3) return '';
  final ano = partes[0];
  final mes = partes[1];
  final dia = partes[2];
  return '$dia/$mes/$ano';
}

String formatarDataParaBrComHora(String dataIso) {
  final partes = dataIso.split(' ');
  if (partes.length != 2) return '';
  final data = partes[0].split('-');
  final hora = partes[1].split(':');
  if (data.length != 3 || hora.length != 3) return '';
  final ano = data[0];
  final mes = data[1];
  final dia = data[2];
  final horas = hora[0];
  final minutos = hora[1];
  return '$dia/$mes/$ano $horas:$minutos';
}
