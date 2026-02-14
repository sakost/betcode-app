import 'package:flutter/material.dart';

abstract final class AppColors {
  // Connection status
  static const Color online = Color(0xFF4CAF50);
  static const Color offline = Color(0xFFE53935);
  static const Color connecting = Color(0xFFFFC107);
  static const Color reconnecting = Color(0xFFFF9800);

  // Agent status
  static const Color agentThinking = Color(0xFFFFC107);    // Amber
  static const Color agentExecuting = Color(0xFF2196F3);   // Blue
  static const Color agentIdle = Color(0xFF9E9E9E);
  static const Color agentError = Color(0xFFE53935);
  static const Color agentWaiting = Color(0xFF9C27B0);

  // Pipeline / CI
  static const Color scheduled = Color(0xFF009688);

  // Sync status
  static const Color syncPending = Color(0xFFFFC107);
  static const Color syncSending = Color(0xFF2196F3);
  static const Color syncSent = Color(0xFF4CAF50);
  static const Color syncFailed = Color(0xFFE53935);
}
