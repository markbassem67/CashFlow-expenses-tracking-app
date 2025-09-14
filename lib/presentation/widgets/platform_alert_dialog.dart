import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AppDialogs {
  static Future<void> showPlatformAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    String okText = "OK",
    VoidCallback? onOkPressed,
    VoidCallback? onCancelPressed,
  }) {
    return showPlatformDialog(
      context: context,
      builder: (dialogContext) => PlatformAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          PlatformDialogAction(
            child: Text(okText, style: const TextStyle(color: Colors.green)),
            onPressed: () {
              Navigator.of(
                dialogContext,
              ).pop(false); 
              if (onOkPressed != null) onOkPressed();
            },
          ),
        ],
      ),
    );
  }
}
