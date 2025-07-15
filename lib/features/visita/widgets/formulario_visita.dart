import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../shared/components/form_widgets.dart';
import '../../../shared/utils/formatters.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../controllers/visita_cadastro_controller.dart';

class FormularioVisita extends StatelessWidget {
  const FormularioVisita({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VisitaCadastroController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CardContainer(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Informações da Visita', style: AppTextStyles.headline),
              const SizedBox(height: 16),
              InputCampo(
                label: 'Data da Visita (DD/MM/AAAA)',
                icone: Icons.calendar_today,
                controller: controller.dataVisitaController,
                tipoTeclado: TextInputType.datetime,
                mascaras: [dataMask],
              ),
              const SizedBox(height: 12),
              InputCampoMultiline(
                label: 'Descrição Técnica',
                icone: Icons.description,
                controller: controller.descricaoController,
                maxLines: 4,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        CardContainer(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Endereço', style: AppTextStyles.headline),
              const SizedBox(height: 16),
              InputCampo(
                label: 'CEP',
                icone: Icons.map,
                controller: controller.cepController,
                focusNode: controller.cepFocus,
                tipoTeclado: TextInputType.number,
                mascaras: [cepMask],
              ),
              const SizedBox(height: 12),
              InputCampo(
                label: 'Rua',
                icone: Icons.location_on,
                controller: controller.ruaController,
              ),
              const SizedBox(height: 12),
              InputCampo(
                label: 'Número',
                icone: Icons.confirmation_number,
                controller: controller.numeroController,
                tipoTeclado: TextInputType.number,
              ),
              const SizedBox(height: 12),
              InputCampo(
                label: 'Complemento',
                icone: Icons.home,
                controller: controller.complementoController,
              ),
              const SizedBox(height: 12),
              InputCampo(
                label: 'Bairro',
                icone: Icons.map,
                controller: controller.bairroController,
              ),
              const SizedBox(height: 12),
              InputCampo(
                label: 'Cidade',
                icone: Icons.location_city,
                controller: controller.cidadeController,
              ),
              const SizedBox(height: 12),
              InputCampo(
                label: 'Estado',
                icone: Icons.flag,
                controller: controller.estadoController,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        CardContainer(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mídias da Visita', style: AppTextStyles.headline),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    controller.imagensServidor.map((url) {
                      final imagemUrl = '${AppConstants.baseUrl}/media$url';
                      return Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.subtitle.withOpacity(0.2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imagemUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, error, stackTrace) {
                                  return Container(
                                    color: AppColors.subtitle.withOpacity(0.1),
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: AppColors.subtitle,
                                        size: 32,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap:
                                  () => controller.removerImagemServidor(url),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.error.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),

              const SizedBox(height: 8),

              // === FOTOS NOVAS (LOCAIS)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    controller.imagensSelecionadas.map((file) {
                      return Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.subtitle.withOpacity(0.2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                file,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, error, stackTrace) {
                                  return Container(
                                    color: AppColors.subtitle.withOpacity(0.1),
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: AppColors.subtitle,
                                        size: 32,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => controller.removerImagemLocal(file),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.error.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),

              const SizedBox(height: 16),
              Center(
                child: BotaoPadrao(
                  texto: 'Adicionar Foto',
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );

                    if (pickedFile != null) {
                      controller.adicionarImagemLocal(File(pickedFile.path));
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
