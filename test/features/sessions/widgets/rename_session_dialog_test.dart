import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/features/sessions/widgets/rename_session_dialog.dart';

Widget _app({required String currentName, required ValueSetter<String?> onResult}) {
  return MaterialApp(
    home: Builder(
      builder: (context) => Scaffold(
        body: ElevatedButton(
          onPressed: () async {
            final result = await RenameSessionDialog.show(
              context,
              currentName: currentName,
            );
            onResult(result);
          },
          child: const Text('Open'),
        ),
      ),
    ),
  );
}

void main() {
  group('RenameSessionDialog', () {
    testWidgets('pre-fills text field with current name', (t) async {
      await t.pumpWidget(_app(currentName: 'My Session', onResult: (_) {}));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();

      expect(find.text('My Session'), findsOneWidget);
    });

    testWidgets('text field is empty when current name is empty', (t) async {
      await t.pumpWidget(_app(currentName: '', onResult: (_) {}));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();

      final field = t.widget<TextFormField>(find.byType(TextFormField));
      expect(field.controller!.text, '');
    });

    testWidgets('Rename button is disabled when field is empty', (t) async {
      await t.pumpWidget(_app(currentName: '', onResult: (_) {}));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();

      final renameButton = t.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Rename'),
      );
      expect(renameButton.onPressed, isNull);
    });

    testWidgets('Rename button is enabled when field has text', (t) async {
      await t.pumpWidget(_app(currentName: 'Test', onResult: (_) {}));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();

      final renameButton = t.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Rename'),
      );
      expect(renameButton.onPressed, isNotNull);
    });

    testWidgets('Rename button becomes disabled after clearing text', (t) async {
      await t.pumpWidget(_app(currentName: 'Test', onResult: (_) {}));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();

      // Clear the text field
      await t.enterText(find.byType(TextFormField), '');
      await t.pump();

      final renameButton = t.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Rename'),
      );
      expect(renameButton.onPressed, isNull);
    });

    testWidgets('Cancel returns null', (t) async {
      String? result = 'not-set';
      await t.pumpWidget(_app(currentName: 'Test', onResult: (r) => result = r));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();

      await t.tap(find.text('Cancel'));
      await t.pumpAndSettle();

      expect(result, isNull);
    });

    testWidgets('Rename returns trimmed text', (t) async {
      String? result;
      await t.pumpWidget(_app(currentName: '', onResult: (r) => result = r));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();

      await t.enterText(find.byType(TextFormField), '  My New Name  ');
      await t.pump();

      await t.tap(find.text('Rename'));
      await t.pumpAndSettle();

      expect(result, 'My New Name');
    });

    testWidgets('shows dialog title', (t) async {
      await t.pumpWidget(_app(currentName: '', onResult: (_) {}));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();

      expect(find.text('Rename Session'), findsOneWidget);
    });
  });
}
