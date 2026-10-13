class DailyReward {
  const DailyReward({
    required this.day,
    required this.id,
    required this.kind,
  });

  final int day;
  final String id;
  final String kind;
}

const dailyRewards = [
  DailyReward(day: 1, id: 'hint_token', kind: 'hint_token'),
  DailyReward(day: 3, id: 'pack_placeholder', kind: 'puzzle_pack_entitlement'),
  DailyReward(day: 7, id: 'badge_week', kind: 'badge'),
];

class RewardClaimRecord {
  const RewardClaimRecord({
    required this.rewardId,
    required this.claimedOnUtcDay,
  });

  final String rewardId;
  final DateTime claimedOnUtcDay;
}

/// Idempotent: same reward id cannot be granted twice.
List<DailyReward> claimableRewards({
  required int streakCurrent,
  required Set<String> alreadyClaimedIds,
}) {
  return dailyRewards
      .where(
        (r) => streakCurrent >= r.day && !alreadyClaimedIds.contains(r.id),
      )
      .toList();
}
