
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final MaskTextInputFormatter maskCPF = MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });

final MaskTextInputFormatter maskCNPJ = MaskTextInputFormatter(mask: '##.###.###/####-##', filter: { "#": RegExp(r'[0-9]') });

final MaskTextInputFormatter maskPhone = MaskTextInputFormatter(mask: '(##) # ####-####', filter: { "#": RegExp(r'[0-9]') });

final MaskTextInputFormatter cepFormatter = MaskTextInputFormatter(mask: '#####-###', filter: { "#": RegExp(r'[0-9]') });