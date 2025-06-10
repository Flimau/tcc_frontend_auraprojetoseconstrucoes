import 'dart:io' as io;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

class PdfUtils {
  static Future<void> abrirOuSalvarPdf(
    Uint8List bytes,
    String nomeArquivo,
  ) async {
    if (kIsWeb) {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor =
          html.AnchorElement(href: url)
            ..setAttribute("download", nomeArquivo)
            ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // Requisição de permissão (Android)
      if (await Permission.storage.request().isGranted) {
        final dir = await getApplicationDocumentsDirectory();
        final file = io.File('${dir.path}/$nomeArquivo');
        await file.writeAsBytes(bytes);
        await OpenFile.open(file.path);
      } else {
        throw PlatformException(
          code: "PERMISSION_DENIED",
          message: "Permissão negada para salvar PDF",
        );
      }
    }
  }
}
