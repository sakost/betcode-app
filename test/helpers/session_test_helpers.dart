import 'package:betcode_app/generated/betcode/v1/agent.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

/// Creates a test [SessionSummary] with sensible defaults.
///
/// Shared across session_card_test and sessions_screen_test.
SessionSummary makeTestSession({
  String id = 'sess-1',
  String name = '',
  String model = 'opus',
  String status = 'idle',
  int messageCount = 5,
  double totalCostUsd = 0.0123,
  String lastMessagePreview = 'Hello world',
  int? updatedAtSeconds,
}) {
  final session = SessionSummary(
    id: id,
    name: name,
    model: model,
    status: status,
    messageCount: messageCount,
    totalCostUsd: totalCostUsd,
    lastMessagePreview: lastMessagePreview,
  );
  if (updatedAtSeconds != null) {
    session.updatedAt = Timestamp(seconds: Int64(updatedAtSeconds));
  }
  return session;
}
