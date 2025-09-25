/**
 * Tests for badge utilities
 */

import {
  calculateNewBadges,
  getBadgeConfig,
  calculatePoints,
  validateUserStats,
  formatBadgeAchievements,
  UserStats,
  BADGES
} from '../../src/utils/badges';

describe('Badge Utils', () => {
  describe('calculateNewBadges', () => {
    it('should award first cleanup badge', () => {
      const currentStats: UserStats = {
        points: 0,
        poundsCollected: 0,
        totalCleanups: 0,
        badges: []
      };

      const newStats: UserStats = {
        points: 50,
        poundsCollected: 5,
        totalCleanups: 1,
        badges: []
      };

      const newBadges = calculateNewBadges(currentStats, newStats);

      expect(newBadges).toContain('first_cleanup');
      expect(newBadges).toContain('5_lbs');
    });

    it('should not award already earned badges', () => {
      const currentStats: UserStats = {
        points: 50,
        poundsCollected: 5,
        totalCleanups: 1,
        badges: ['first_cleanup', '5_lbs']
      };

      const newStats: UserStats = {
        points: 100,
        poundsCollected: 10,
        totalCleanups: 2,
        badges: ['first_cleanup', '5_lbs']
      };

      const newBadges = calculateNewBadges(currentStats, newStats);

      expect(newBadges).not.toContain('first_cleanup');
      expect(newBadges).not.toContain('5_lbs');
      expect(newBadges).toContain('10_lbs');
    });

    it('should award multiple badges at once', () => {
      const currentStats: UserStats = {
        points: 0,
        poundsCollected: 0,
        totalCleanups: 0,
        badges: []
      };

      const newStats: UserStats = {
        points: 1500,
        poundsCollected: 100,
        totalCleanups: 15,
        badges: []
      };

      const newBadges = calculateNewBadges(currentStats, newStats);

      expect(newBadges).toContain('first_cleanup');
      expect(newBadges).toContain('5_lbs');
      expect(newBadges).toContain('10_lbs');
      expect(newBadges).toContain('25_lbs');
      expect(newBadges).toContain('50_lbs');
      expect(newBadges).toContain('100_lbs');
      expect(newBadges).toContain('10_cleanups');
      expect(newBadges).toContain('1000_points');
    });

    it('should handle streak badges', () => {
      const currentStats: UserStats = {
        points: 100,
        poundsCollected: 10,
        totalCleanups: 5,
        currentStreak: 5,
        badges: []
      };

      const newStats: UserStats = {
        points: 120,
        poundsCollected: 12,
        totalCleanups: 6,
        currentStreak: 30,
        badges: []
      };

      const newBadges = calculateNewBadges(currentStats, newStats);

      expect(newBadges).toContain('streak_7');
      expect(newBadges).toContain('streak_30');
    });

    it('should handle undefined currentStreak', () => {
      const currentStats: UserStats = {
        points: 100,
        poundsCollected: 10,
        totalCleanups: 5,
        badges: []
      };

      const newStats: UserStats = {
        points: 120,
        poundsCollected: 12,
        totalCleanups: 6,
        badges: []
      };

      const newBadges = calculateNewBadges(currentStats, newStats);

      // Should not crash and should not award streak badges
      expect(newBadges).not.toContain('streak_7');
      expect(newBadges).not.toContain('streak_30');
    });

    it('should handle empty current badges array', () => {
      const currentStats: UserStats = {
        points: 0,
        poundsCollected: 0,
        totalCleanups: 0,
        badges: []
      };

      const newStats: UserStats = {
        points: 60,
        poundsCollected: 6,
        totalCleanups: 1,
        badges: []
      };

      const newBadges = calculateNewBadges(currentStats, newStats);

      expect(newBadges.length).toBeGreaterThan(0);
      expect(newBadges).toContain('first_cleanup');
      expect(newBadges).toContain('5_lbs');
    });
  });

  describe('getBadgeConfig', () => {
    it('should return correct badge configuration', () => {
      const badge = getBadgeConfig('first_cleanup');

      expect(badge).not.toBeNull();
      expect(badge?.id).toBe('first_cleanup');
      expect(badge?.name).toBe('First Steps');
      expect(badge?.threshold).toBe(1);
      expect(badge?.metric).toBe('cleanups');
    });

    it('should return null for non-existent badge', () => {
      const badge = getBadgeConfig('non_existent_badge');

      expect(badge).toBeNull();
    });

    it('should return all available badges', () => {
      expect(BADGES.length).toBeGreaterThan(10);
      
      // Check for key badges
      const badgeIds = BADGES.map(b => b.id);
      expect(badgeIds).toContain('first_cleanup');
      expect(badgeIds).toContain('50_lbs');
      expect(badgeIds).toContain('100_lbs');
      expect(badgeIds).toContain('streak_7');
    });
  });

  describe('calculatePoints', () => {
    it('should calculate base points correctly', () => {
      const points = calculatePoints(5.5);

      expect(points).toBe(55); // 5.5 * 10, rounded
    });

    it('should apply location bonuses', () => {
      const beachPoints = calculatePoints(10, 'beach');
      const parkPoints = calculatePoints(10, 'park');
      const streetPoints = calculatePoints(10, 'street');

      expect(beachPoints).toBe(120); // 10 * 10 * 1.2
      expect(parkPoints).toBe(110); // 10 * 10 * 1.1
      expect(streetPoints).toBe(100); // 10 * 10 * 1.0
    });

    it('should handle bonus multiplier', () => {
      const points = calculatePoints(10, 'street', 2.0);

      expect(points).toBe(200); // 10 * 10 * 1.0 * 2.0
    });

    it('should handle undefined cleanup type', () => {
      const points = calculatePoints(10);

      expect(points).toBe(100); // Base rate
    });

    it('should round points to integer', () => {
      const points = calculatePoints(5.7);

      expect(points).toBe(57);
      expect(Number.isInteger(points)).toBe(true);
    });

    it('should handle zero pounds', () => {
      const points = calculatePoints(0);

      expect(points).toBe(0);
    });

    it('should handle fractional pounds correctly', () => {
      const points = calculatePoints(0.1, 'beach'); // Small amount with bonus

      expect(points).toBe(1); // 0.1 * 10 * 1.2 = 1.2, rounded to 1
    });
  });

  describe('validateUserStats', () => {
    it('should validate correct user stats', () => {
      const validStats: UserStats = {
        points: 100,
        poundsCollected: 25.5,
        totalCleanups: 10,
        badges: ['first_cleanup', '25_lbs']
      };

      expect(validateUserStats(validStats)).toBe(true);
    });

    it('should reject null or undefined', () => {
      expect(validateUserStats(null)).toBe(false);
      expect(validateUserStats(undefined)).toBe(false);
    });

    it('should reject non-object types', () => {
      expect(validateUserStats('string')).toBe(false);
      expect(validateUserStats(123)).toBe(false);
      expect(validateUserStats([])).toBe(false);
    });

    it('should reject missing required fields', () => {
      const incompleteStats = [
        { poundsCollected: 10, totalCleanups: 5, badges: [] }, // missing points
        { points: 100, totalCleanups: 5, badges: [] }, // missing poundsCollected
        { points: 100, poundsCollected: 10, badges: [] }, // missing totalCleanups
        { points: 100, poundsCollected: 10, totalCleanups: 5 } // missing badges
      ];

      incompleteStats.forEach(stats => {
        expect(validateUserStats(stats)).toBe(false);
      });
    });

    it('should reject invalid field types', () => {
      const invalidStats = [
        { points: '100', poundsCollected: 10, totalCleanups: 5, badges: [] },
        { points: 100, poundsCollected: '10', totalCleanups: 5, badges: [] },
        { points: 100, poundsCollected: 10, totalCleanups: '5', badges: [] },
        { points: 100, poundsCollected: 10, totalCleanups: 5, badges: 'badges' }
      ];

      invalidStats.forEach(stats => {
        expect(validateUserStats(stats)).toBe(false);
      });
    });

    it('should reject negative values', () => {
      const negativeStats = [
        { points: -100, poundsCollected: 10, totalCleanups: 5, badges: [] },
        { points: 100, poundsCollected: -10, totalCleanups: 5, badges: [] },
        { points: 100, poundsCollected: 10, totalCleanups: -5, badges: [] }
      ];

      negativeStats.forEach(stats => {
        expect(validateUserStats(stats)).toBe(false);
      });
    });

    it('should accept zero values', () => {
      const zeroStats: UserStats = {
        points: 0,
        poundsCollected: 0,
        totalCleanups: 0,
        badges: []
      };

      expect(validateUserStats(zeroStats)).toBe(true);
    });

    it('should handle optional currentStreak', () => {
      const statsWithStreak: UserStats = {
        points: 100,
        poundsCollected: 10,
        totalCleanups: 5,
        currentStreak: 7,
        badges: []
      };

      expect(validateUserStats(statsWithStreak)).toBe(true);
    });
  });

  describe('formatBadgeAchievements', () => {
    it('should format badge achievements correctly', () => {
      const badgeIds = ['first_cleanup', '5_lbs'];
      const achievements = formatBadgeAchievements(badgeIds);

      expect(achievements).toHaveLength(2);
      expect(achievements[0]).toContain('🎉');
      expect(achievements[0]).toContain('🌱');
      expect(achievements[0]).toContain('First Steps');
      expect(achievements[0]).toContain('Complete your first cleanup');
    });

    it('should handle empty badge list', () => {
      const achievements = formatBadgeAchievements([]);

      expect(achievements).toHaveLength(0);
    });

    it('should handle non-existent badges gracefully', () => {
      const badgeIds = ['non_existent_badge'];
      const achievements = formatBadgeAchievements(badgeIds);

      expect(achievements).toHaveLength(1);
      expect(achievements[0]).toContain('New badge earned: non_existent_badge');
    });

    it('should format multiple badges', () => {
      const badgeIds = ['first_cleanup', '5_lbs', '1000_points'];
      const achievements = formatBadgeAchievements(badgeIds);

      expect(achievements).toHaveLength(3);
      achievements.forEach(achievement => {
        expect(achievement).toContain('🎉');
      });
    });
  });
});