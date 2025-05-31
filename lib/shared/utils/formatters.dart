import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');
final cnpjMask = MaskTextInputFormatter(mask: '##.###.###/####-##');
final cepMask = MaskTextInputFormatter(mask: '#####-###');
final dataMask = MaskTextInputFormatter(mask: '##/##/####');
final telefoneMask = MaskTextInputFormatter(mask: '(##) #####-####');

