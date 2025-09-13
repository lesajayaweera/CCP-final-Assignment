import 'package:flutter/material.dart';
import 'package:sport_ignite/widget/leaderboard/EnhancedStatsChip.dart';

List<Widget> buildStatsChips(String sport, Map<String, dynamic> stats) {
    List<Widget> chips = [];

    switch (sport.toLowerCase()) {
      case 'basketball':
        if (stats['Points'] != null) {
          chips.add(
            buildEnhancedStatChip(
              icon: Icons.sports_basketball_rounded,
              label: '${stats['Points']}',
              sublabel: 'Points',
              color: Color(0xFF10B981),
            ),
          );
          chips.add(SizedBox(width: 8));
        }
        if (stats['Assists'] != null) {
          chips.add(
            buildEnhancedStatChip(
              icon: Icons.handshake_rounded,
              label: '${stats['Assists']}',
              sublabel: 'Assists',
              color: Color(0xFF3B82F6),
            ),
          );
          chips.add(SizedBox(width: 8));
        }
        if (stats['Rebounds'] != null) {
          chips.add(
            buildEnhancedStatChip(
              icon: Icons.all_inclusive_rounded,
              label: '${stats['Rebounds']}',
              sublabel: 'Rebounds',
              color: Color(0xFF8B5CF6),
            ),
          );
          chips.add(SizedBox(width: 8));
        }
        break;

      case 'cricket':
        if (stats['Runs'] != null) {
          chips.add(
            buildEnhancedStatChip(
              icon: Icons.sports_cricket_rounded,
              label: '${stats['Runs']}',
              sublabel: 'Runs',
              color: Color(0xFF10B981),
            ),
          );
          chips.add(SizedBox(width: 8));
        }
        if (stats['BattingAverage'] != null) {
          chips.add(
            buildEnhancedStatChip(
              icon: Icons.trending_up_rounded,
              label: '${stats['BattingAverage'].toStringAsFixed(1)}',
              sublabel: 'Average',
              color: Color(0xFF3B82F6),
            ),
          );
          chips.add(SizedBox(width: 8));
        }
        if (stats['StrikeRate'] != null) {
          chips.add(
            buildEnhancedStatChip(
              icon: Icons.speed_rounded,
              label: '${stats['StrikeRate'].toStringAsFixed(1)}',
              sublabel: 'Strike Rate',
              color: Color(0xFF8B5CF6),
            ),
          );
          chips.add(SizedBox(width: 8));
        }
        break;

      case 'football':
        if (stats['Goals'] != null) {
          chips.add(
            buildEnhancedStatChip(
              icon: Icons.sports_soccer_rounded,
              label: '${stats['Goals']}',
              sublabel: 'Goals',
              color: Color(0xFF10B981),
            ),
          );
          chips.add(SizedBox(width: 8));
        }
        if (stats['Assists'] != null) {
          chips.add(
            buildEnhancedStatChip(
              icon: Icons.handshake_rounded,
              label: '${stats['Assists']}',
              sublabel: 'Assists',
              color: Color(0xFF3B82F6),
            ),
          );
          chips.add(SizedBox(width: 8));
        }
        if (stats['PassAccuracy'] != null) {
          chips.add(
            buildEnhancedStatChip(
              icon: Icons.assistant_rounded,
              label: '${stats['PassAccuracy'].toStringAsFixed(1)}%',
              sublabel: 'Pass Acc.',
              color: Color(0xFF8B5CF6),
            ),
          );
          chips.add(SizedBox(width: 8));
        }
        break;
    }

    // Remove the last SizedBox if exists
    if (chips.isNotEmpty) {
      chips.removeLast();
    }

    return chips;
  }