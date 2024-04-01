// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class ArchivosView extends StatelessWidget {
  const ArchivosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Adjuntar archivos',
            ),
          ),
          body: const Center(
            child: Text(
              "Opciones para subir archivos",
              style: TextStyle(fontSize: 20),
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Semantics(
                label: 'image_picker_example_from_gallery',
                child: FloatingActionButton(
                  onPressed: () {
                    print("aqui");
                    
                  },
                  heroTag: 'image0',
                  tooltip: 'Elija una imagen de la galería.',
                  child: const Icon(Icons.photo),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  onPressed: () {},
                  heroTag: 'multipleMedia',
                  tooltip: 'Elija varios medios de la galería.',
                  child: const Icon(Icons.photo_library),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  onPressed: () {},
                  heroTag: 'media',
                  tooltip: 'Elija medios únicos de la galería',
                  child: const Icon(Icons.photo_library),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  onPressed: () {},
                  heroTag: 'image1',
                  tooltip: 'Elija varias imágenes de la galería',
                  child: const Icon(Icons.photo_library),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  onPressed: () {},
                  heroTag: 'image2',
                  tooltip: 'Toma una foto',
                  child: const Icon(Icons.camera_alt),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
