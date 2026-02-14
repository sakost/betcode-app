import 'package:flutter_test/flutter_test.dart';

import 'package:betcode_app/shared/utils/time_utils.dart';

void main() {
  group('relativeTime', () {
    test('returns "just now" for less than 1 minute ago', () {
      final now = DateTime.now();
      expect(relativeTime(now), 'just now');
      expect(relativeTime(now.subtract(const Duration(seconds: 30))), 'just now');
      expect(relativeTime(now.subtract(const Duration(seconds: 59))), 'just now');
    });

    test('returns "1m ago" for exactly 1 minute ago', () {
      final dateTime = DateTime.now().subtract(const Duration(minutes: 1));
      expect(relativeTime(dateTime), '1m ago');
    });

    test('returns "Xm ago" for minutes', () {
      final dateTime = DateTime.now().subtract(const Duration(minutes: 30));
      expect(relativeTime(dateTime), '30m ago');
    });

    test('returns "59m ago" at the boundary before hours', () {
      final dateTime = DateTime.now().subtract(const Duration(minutes: 59));
      expect(relativeTime(dateTime), '59m ago');
    });

    test('returns "1h ago" for exactly 1 hour ago', () {
      final dateTime = DateTime.now().subtract(const Duration(hours: 1));
      expect(relativeTime(dateTime), '1h ago');
    });

    test('returns "Xh ago" for hours', () {
      final dateTime = DateTime.now().subtract(const Duration(hours: 12));
      expect(relativeTime(dateTime), '12h ago');
    });

    test('returns "23h ago" at the boundary before days', () {
      final dateTime = DateTime.now().subtract(const Duration(hours: 23));
      expect(relativeTime(dateTime), '23h ago');
    });

    test('returns "1d ago" for exactly 1 day ago', () {
      final dateTime = DateTime.now().subtract(const Duration(days: 1));
      expect(relativeTime(dateTime), '1d ago');
    });

    test('returns "Xd ago" for days within a week', () {
      final dateTime = DateTime.now().subtract(const Duration(days: 5));
      expect(relativeTime(dateTime), '5d ago');
    });

    test('returns "6d ago" at the boundary before date format', () {
      final dateTime = DateTime.now().subtract(const Duration(days: 6));
      expect(relativeTime(dateTime), '6d ago');
    });

    test('returns date format for 7+ days ago', () {
      final dateTime = DateTime(2024, 3, 15, 10, 30);
      expect(relativeTime(dateTime), '3/15/2024');
    });

    test('returns date format for old dates', () {
      final dateTime = DateTime(2023, 12, 1);
      expect(relativeTime(dateTime), '12/1/2023');
    });
  });
}
