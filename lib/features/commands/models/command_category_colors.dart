import 'package:betcode_app/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Maps command category labels to semantic colors for badges.
abstract final class CommandCategoryColors {
  static Color colorForCategory(String category) {
    return switch (category) {
      'Service' => AppColors.agentExecuting,
      'Claude' => AppColors.agentThinking,
      'Plugin' => AppColors.commandPlugin,
      'Skill' => AppColors.commandSkill,
      'MCP' => AppColors.commandMcp,
      'App' => AppColors.agentIdle,
      'Agent' => AppColors.agentWaiting,
      _ => AppColors.agentIdle,
    };
  }
}
