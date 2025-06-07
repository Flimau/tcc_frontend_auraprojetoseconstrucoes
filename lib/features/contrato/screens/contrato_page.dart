// lib/pages/contrato_page.dart

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:front_application/shared/services/contrato_service.dart';
import 'package:path_provider/path_provider.dart';

import 'pdf_viewer_page.dart';

class PdfContratoPage extends StatefulWidget {
  final int orcamentoId;

  const PdfContratoPage({Key? key, required this.orcamentoId})
    : super(key: key);

  @override
  _PdfContratoPageState createState() => _PdfContratoPageState();
}

class _PdfContratoPageState extends State<PdfContratoPage> {
  bool _isLoading = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _baixarEExibir();
  }

  Future<void> _baixarEExibir() async {
    try {
      Uint8List pdfBytes = await ContratoService().baixarContratoPdf(
        widget.orcamentoId,
      );

      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/contrato_${widget.orcamentoId}.pdf';
      File(filePath).writeAsBytesSync(pdfBytes);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PdfViewerPage(filePath: filePath)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = 'Erro ao baixar contrato:\n${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carregando Contrato...')),
      body: Center(
        child:
            _isLoading
                ? const CircularProgressIndicator()
                : Text(
                  _erro ?? 'Erro desconhecido.',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
      ),
    );
  }
}
