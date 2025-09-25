/**
 * Badge system utilities for user achievements
 */

export interface BadgeConfig {
  id: string;
  name: string;
  description: string;
  threshold: number;
  metric: 'pounds' | 'cleanups' | 'points' | 'streak';
  icon?: string;
}

/**
 * Available badges configuration
 */
export const BADGES: BadgeConfig[] = [
  {
    id: 'first_cleanup',
    name: 'First Steps',
    description: 'Complete your first cleanup',
    threshold: 1,
    metric: 'cleanups',
    icon: '🌱'
  },
  {
    id: '5_lbs',
    name: 'Getting Started',
    description: 'Collect 5 pounds of trash',
    threshold: 5,
    metric: 'pounds',
    icon: '💪'
  },
  {
    id: '10_lbs',
    name: 'Making Progress',
    description: 'Collect 10 pounds of trash',
    threshold: 10,
    metric: 'pounds',
    icon: '🏃'
  },
  {
    id: '25_lbs',
    name: 'Dedicated Cleaner',
    description: 'Collect 25 pounds of trash',
    threshold: 25,
    metric: 'pounds',
    icon: '⭐'
  },
  {
    id: '50_lbs',
    name: 'Cleanup Champion',
    description: 'Collect 50 pounds of trash',
    threshold: 50,
    metric: 'pounds',
    icon: '🏆'
  },
  {
    id: '100_lbs',
    name: 'Environmental Hero',
    description: 'Collect 100 pounds of trash',
    threshold: 100,
    metric: 'pounds',
    icon: '🦸'
  },
  {
    id: '500_lbs',
    name: 'Legend',
    description: 'Collect 500 pounds of trash',
    threshold: 500,
    metric: 'pounds',
    icon: '👑'
  },
  {
    id: '10_cleanups',
    name: 'Regular Cleaner',
    description: 'Complete 10 cleanups',
    threshold: 10,
    metric: 'cleanups',
    icon: '🔥'
  },
  {
    id: '25_cleanups',
    name: 'Cleanup Veteran',
    description: 'Complete 25 cleanups',
    threshold: 25,
    metric: 'cleanups',
    icon: '🎖️'
  },
  {
    id: '50_cleanups',
    name: 'Cleanup Master',
    description: 'Complete 50 cleanups',
    threshold: 50,
    metric: 'cleanups',
    icon: '🥇'
  },
  {
    id: '1000_points',
    name: 'Point Collector',
    description: 'Earn 1,000 points',
    threshold: 1000,
    metric: 'points',
    icon: '💎'
  },
  {
    id: '5000_points',
    name: 'Point Master',
    description: 'Earn 5,000 points',
    threshold: 5000,
    metric: 'points',
    icon: '💰'
  },
  {
    id: 'streak_7',
    name: 'Week Warrior',
    description: 'Clean for 7 consecutive days',
    threshold: 7,
    metric: 'streak',
    icon: '📅'
  },
  {
    id: 'streak_30',
    name: 'Month Champion',
    description: 'Clean for 30 consecutive days',
    threshold: 30,
    metric: 'streak',
    icon: '📊'
  }
];

/**
 * User stats interface
 */
export interface UserStats {
  points: number;
  poundsCollected: number;
  totalCleanups: number;
  currentStreak?: number;
  badges: string[];
}

/**
 * Calculates newly earned badges based on updated stats
 * @param currentStats Current user statistics
 * @param newStats Updated statistics after cleanup
 * @returns Array of newly earned badge IDs
 */
export function calculateNewBadges(currentStats: UserStats, newStats: UserStats): string[] {
  const newBadges: string[] = [];
  const currentBadgeIds = new Set(currentStats.badges || []);

  for (const badge of BADGES) {
    // Skip if badge already earned
    if (currentBadgeIds.has(badge.id)) {
      continue;
    }

    // Check if badge threshold is met
    let metricValue = 0;
    switch (badge.metric) {
      case 'pounds':
        metricValue = newStats.poundsCollected;
        break;
      case 'cleanups':
        metricValue = newStats.totalCleanups;
        break;
      case 'points':
        metricValue = newStats.points;
        break;
      case 'streak':
        metricValue = newStats.currentStreak || 0;
        break;
    }

    if (metricValue >= badge.threshold) {
      newBadges.push(badge.id);
    }
  }

  return newBadges;
}

/**
 * Gets badge configuration by ID
 * @param badgeId Badge identifier
 * @returns Badge configuration or null
 */
export function getBadgeConfig(badgeId: string): BadgeConfig | null {
  return BADGES.find(badge => badge.id === badgeId) || null;
}

/**
 * Calculates points earned from a cleanup
 * @param poundsCollected Pounds of trash collected
 * @param cleanupType Type of cleanup location
 * @param bonusMultiplier Optional bonus multiplier
 * @returns Points earned
 */
export function calculatePoints(
  poundsCollected: number,
  cleanupType?: string,
  bonusMultiplier = 1
): number {
  const basePoints = Math.round(poundsCollected * 10);
  
  // Location-based bonuses
  let locationBonus = 1;
  switch (cleanupType?.toLowerCase()) {
    case 'beach':
    case 'waterway':
      locationBonus = 1.2; // 20% bonus for water cleanups
      break;
    case 'park':
    case 'trail':
      locationBonus = 1.1; // 10% bonus for recreation areas
      break;
    case 'street':
    case 'urban':
      locationBonus = 1.0; // Base rate for urban areas
      break;
    default:
      locationBonus = 1.0;
  }

  return Math.round(basePoints * locationBonus * bonusMultiplier);
}

/**
 * Validates user stats structure
 * @param stats Stats object to validate
 * @returns True if stats are valid
 */
export function validateUserStats(stats: any): stats is UserStats {
  return (
    typeof stats === 'object' &&
    stats !== null &&
    typeof stats.points === 'number' &&
    typeof stats.poundsCollected === 'number' &&
    typeof stats.totalCleanups === 'number' &&
    Array.isArray(stats.badges) &&
    stats.points >= 0 &&
    stats.poundsCollected >= 0 &&
    stats.totalCleanups >= 0
  );
}

/**
 * Formats badge achievements for notifications
 * @param newBadgeIds Array of newly earned badge IDs
 * @returns Formatted achievement messages
 */
export function formatBadgeAchievements(newBadgeIds: string[]): string[] {
  return newBadgeIds.map(badgeId => {
    const badge = getBadgeConfig(badgeId);
    if (!badge) return `New badge earned: ${badgeId}`;
    
    return `🎉 ${badge.icon} ${badge.name}: ${badge.description}`;
  });
}