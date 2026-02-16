import 'package:flutter/material.dart';

/// Semantic color constants used across the app for status indicators.
abstract final class AppColors {
  // -- Connection status -----------------------------------------------------

  /// Green - device is connected to the relay.
  static const Color online = Color(0xFF4CAF50);

  /// Red - device is disconnected.
  static const Color offline = Color(0xFFE53935);

  /// Amber - initial connection in progress.
  static const Color connecting = Color(0xFFFFC107);

  /// Orange - reconnecting after a drop.
  static const Color reconnecting = Color(0xFFFF9800);

  // -- Agent status ----------------------------------------------------------

  /// Amber - the agent is thinking.
  static const Color agentThinking = Color(0xFFFFC107);

  /// Blue - the agent is executing a tool.
  static const Color agentExecuting = Color(0xFF2196F3);

  /// Grey - the agent is idle.
  static const Color agentIdle = Color(0xFF9E9E9E);

  /// Red - the agent encountered an error.
  static const Color agentError = Color(0xFFE53935);

  /// Purple - the agent is waiting for user input.
  static const Color agentWaiting = Color(0xFF9C27B0);

  // -- Command categories -----------------------------------------------------

  /// Purple - plugin command category.
  static const Color commandPlugin = Color(0xFF9C27B0);

  /// Cyan - skill command category.
  static const Color commandSkill = Color(0xFF00BCD4);

  /// Deep orange - MCP command category.
  static const Color commandMcp = Color(0xFFFF5722);

  // -- Pipeline / CI ---------------------------------------------------------

  /// Teal - a scheduled pipeline.
  static const Color scheduled = Color(0xFF009688);

  // -- Sync status -----------------------------------------------------------

  /// Amber - sync item is pending dispatch.
  static const Color syncPending = Color(0xFFFFC107);

  /// Blue - sync item is currently being sent.
  static const Color syncSending = Color(0xFF2196F3);

  /// Green - sync item was sent successfully.
  static const Color syncSent = Color(0xFF4CAF50);

  /// Red - sync item failed permanently.
  static const Color syncFailed = Color(0xFFE53935);
}
