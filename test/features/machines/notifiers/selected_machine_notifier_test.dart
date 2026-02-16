import 'package:betcode_app/core/storage/secure_storage.dart';
import 'package:betcode_app/core/storage/storage_providers.dart';
import 'package:betcode_app/features/machines/notifiers/machines_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockSecureStorageService extends Mock implements SecureStorageService {}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockSecureStorageService mockStorage;
  late ProviderContainer container;

  setUp(() {
    mockStorage = MockSecureStorageService();
    container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(mockStorage)],
    );
  });

  tearDown(() => container.dispose());

  group('SelectedMachineNotifier', () {
    test('initial state is null', () {
      final state = container.read(selectedMachineIdProvider);
      expect(state, isNull);
    });

    test('initialize loads machine ID from storage', () async {
      when(
        () => mockStorage.readSelectedMachineId(),
      ).thenAnswer((_) async => 'mach-42');

      await container.read(selectedMachineIdProvider.notifier).initialize();

      expect(container.read(selectedMachineIdProvider), 'mach-42');
    });

    test('initialize sets null when storage is empty', () async {
      when(
        () => mockStorage.readSelectedMachineId(),
      ).thenAnswer((_) async => null);

      await container.read(selectedMachineIdProvider.notifier).initialize();

      expect(container.read(selectedMachineIdProvider), isNull);
    });

    test('select persists to storage', () async {
      when(
        () => mockStorage.writeSelectedMachineId('mach-99'),
      ).thenAnswer((_) async {});

      await container
          .read(selectedMachineIdProvider.notifier)
          .select('mach-99');

      verify(() => mockStorage.writeSelectedMachineId('mach-99')).called(1);
    });

    test('select updates state', () async {
      when(
        () => mockStorage.writeSelectedMachineId(any()),
      ).thenAnswer((_) async {});

      await container
          .read(selectedMachineIdProvider.notifier)
          .select('mach-99');

      expect(container.read(selectedMachineIdProvider), 'mach-99');
    });

    test('clear deletes from storage', () async {
      when(
        () => mockStorage.deleteSelectedMachineId(),
      ).thenAnswer((_) async {});

      await container.read(selectedMachineIdProvider.notifier).clear();

      verify(() => mockStorage.deleteSelectedMachineId()).called(1);
    });

    test('clear sets state to null', () async {
      when(
        () => mockStorage.writeSelectedMachineId(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockStorage.deleteSelectedMachineId(),
      ).thenAnswer((_) async {});

      // First select, then clear
      await container.read(selectedMachineIdProvider.notifier).select('mach-1');
      expect(container.read(selectedMachineIdProvider), 'mach-1');

      await container.read(selectedMachineIdProvider.notifier).clear();
      expect(container.read(selectedMachineIdProvider), isNull);
    });
  });
}
