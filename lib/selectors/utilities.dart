import 'package:flutter/material.dart';

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

Future<void> displayPickImageDialog(
    BuildContext context, OnPickImageCallback onPick) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController maxWidthController = TextEditingController();
      TextEditingController maxHeightController = TextEditingController();
      TextEditingController qualityController = TextEditingController();

      return AlertDialog(
        title: const Text('Add optional parameters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: maxWidthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: 'Enter maxWidth if desired'),
            ),
            TextField(
              controller: maxHeightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: 'Enter maxHeight if desired'),
            ),
            TextField(
              controller: qualityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter quality if desired'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('PICK'),
            onPressed: () {
              final double? width = maxWidthController.text.isNotEmpty
                  ? double.parse(maxWidthController.text)
                  : null;
              final double? height = maxHeightController.text.isNotEmpty
                  ? double.parse(maxHeightController.text)
                  : null;
              final int? quality = qualityController.text.isNotEmpty
                  ? int.parse(qualityController.text)
                  : null;
              onPick(width, height, quality);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
