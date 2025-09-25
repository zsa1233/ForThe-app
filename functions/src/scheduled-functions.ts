/**
 * Scheduled maintenance and analytics functions
 */

import { onSchedule } from 'firebase-functions/v2/scheduler';
import { getFirestore, Timestamp, FieldValue } from 'firebase-admin/firestore';
import { logger } from 'firebase-functions';

const db = getFirestore();

/**
 * Cleans up old verification logs (runs daily)
 */
export const cleanupOldLogs = onSchedule(
  {
    schedule: '0 2 * * *', // Daily at 2 AM
    timeZone: 'America/Los_Angeles',
    region: 'us-central1'
  },
  async () => {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - 30); // Keep logs for 30 days

    try {
      const oldLogsQuery = db
        .collection('verification_logs')
        .where('timestamp', '<', Timestamp.fromDate(cutoffDate))
        .limit(500); // Process in batches

      const snapshot = await oldLogsQuery.get();
      
      if (snapshot.empty) {
        logger.info('No old logs to clean up');
        return;
      }

      const batch = db.batch();
      snapshot.docs.forEach(doc => {
        batch.delete(doc.ref);
      });

      await batch.commit();
      
      logger.info(`Cleaned up ${snapshot.docs.length} old verification logs`);

    } catch (error) {
      logger.error('Error cleaning up old logs:', error);
    }
  }
);

/**
 * Updates leaderboards (runs every hour)
 */
export const updateLeaderboards = onSchedule(
  {
    schedule: '0 * * * *', // Every hour
    timeZone: 'America/Los_Angeles',
    region: 'us-central1'
  },
  async () => {
    try {
      // Get top users by points
      const topUsersSnapshot = await db
        .collection('users')
        .orderBy('points', 'desc')
        .limit(100)
        .get();

      const leaderboardData = topUsersSnapshot.docs.map((doc, index) => {
        const data = doc.data();
        return {
          userId: doc.id,
          rank: index + 1,
          displayName: data.displayName || 'Anonymous',
          points: data.points || 0,
          totalCleanups: data.totalCleanups || 0,
          poundsCollected: data.poundsCollected || 0,
          badges: data.badges || []
        };
      });

      // Update global leaderboard
      await db.collection('leaderboards').doc('global').set({
        users: leaderboardData,
        lastUpdated: FieldValue.serverTimestamp(),
        generatedAt: Timestamp.now()
      });

      // Generate city-specific leaderboards
      const cities = ['new_york', 'san_francisco', 'chicago', 'miami']; // Configure as needed
      
      for (const city of cities) {
        const cityUsersSnapshot = await db
          .collection('users')
          .where('city', '==', city)
          .orderBy('points', 'desc')
          .limit(50)
          .get();

        if (!cityUsersSnapshot.empty) {
          const cityLeaderboard = cityUsersSnapshot.docs.map((doc, index) => {
            const data = doc.data();
            return {
              userId: doc.id,
              rank: index + 1,
              displayName: data.displayName || 'Anonymous',
              points: data.points || 0,
              totalCleanups: data.totalCleanups || 0,
              poundsCollected: data.poundsCollected || 0
            };
          });

          await db.collection('leaderboards').doc(city).set({
            users: cityLeaderboard,
            lastUpdated: FieldValue.serverTimestamp(),
            cityName: city.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase())
          });
        }
      }

      logger.info(`Updated leaderboards for global and ${cities.length} cities`);

    } catch (error) {
      logger.error('Error updating leaderboards:', error);
    }
  }
);

/**
 * Generates daily analytics (runs daily)
 */
export const generateAnalytics = onSchedule(
  {
    schedule: '0 3 * * *', // Daily at 3 AM
    timeZone: 'America/Los_Angeles',
    region: 'us-central1'
  },
  async () => {
    const today = new Date();
    const yesterday = new Date(today.getTime() - 24 * 60 * 60 * 1000);
    const weekAgo = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
    const monthAgo = new Date(today.getTime() - 30 * 24 * 60 * 60 * 1000);

    try {
      // Get submission counts for different time periods
      const [
        dailySubmissions,
        weeklySubmissions,
        monthlySubmissions,
        dailyApproved,
        weeklyApproved,
        monthlyApproved
      ] = await Promise.all([
        // Daily stats
        db.collection('cleanup_submissions')
          .where('createdAt', '>=', Timestamp.fromDate(yesterday))
          .count().get(),
        
        // Weekly stats
        db.collection('cleanup_submissions')
          .where('createdAt', '>=', Timestamp.fromDate(weekAgo))
          .count().get(),
        
        // Monthly stats
        db.collection('cleanup_submissions')
          .where('createdAt', '>=', Timestamp.fromDate(monthAgo))
          .count().get(),

        // Approved submissions
        db.collection('cleanup_submissions')
          .where('createdAt', '>=', Timestamp.fromDate(yesterday))
          .where('status', '==', 'approved')
          .count().get(),

        db.collection('cleanup_submissions')
          .where('createdAt', '>=', Timestamp.fromDate(weekAgo))
          .where('status', '==', 'approved')
          .count().get(),

        db.collection('cleanup_submissions')
          .where('createdAt', '>=', Timestamp.fromDate(monthAgo))
          .where('status', '==', 'approved')
          .count().get()
      ]);

      // Get user growth stats
      const [newUsersDaily, newUsersWeekly, newUsersMonthly] = await Promise.all([
        db.collection('users')
          .where('createdAt', '>=', Timestamp.fromDate(yesterday))
          .count().get(),
        
        db.collection('users')
          .where('createdAt', '>=', Timestamp.fromDate(weekAgo))
          .count().get(),

        db.collection('users')
          .where('createdAt', '>=', Timestamp.fromDate(monthAgo))
          .count().get()
      ]);

      // Calculate total environmental impact
      const approvedSubmissionsSnapshot = await db
        .collection('cleanup_submissions')
        .where('status', '==', 'approved')
        .where('createdAt', '>=', Timestamp.fromDate(monthAgo))
        .get();

      let totalPoundsCollected = 0;
      approvedSubmissionsSnapshot.docs.forEach(doc => {
        const data = doc.data();
        if (typeof data.reportedPounds === 'number') {
          totalPoundsCollected += data.reportedPounds;
        }
      });

      const analyticsData = {
        date: Timestamp.fromDate(yesterday),
        submissions: {
          daily: dailySubmissions.data().count,
          weekly: weeklySubmissions.data().count,
          monthly: monthlySubmissions.data().count
        },
        approved: {
          daily: dailyApproved.data().count,
          weekly: weeklyApproved.data().count,
          monthly: monthlyApproved.data().count
        },
        approvalRates: {
          daily: dailySubmissions.data().count > 0 
            ? (dailyApproved.data().count / dailySubmissions.data().count) * 100 
            : 0,
          weekly: weeklySubmissions.data().count > 0 
            ? (weeklyApproved.data().count / weeklySubmissions.data().count) * 100 
            : 0,
          monthly: monthlySubmissions.data().count > 0 
            ? (monthlyApproved.data().count / monthlySubmissions.data().count) * 100 
            : 0
        },
        users: {
          newDaily: newUsersDaily.data().count,
          newWeekly: newUsersWeekly.data().count,
          newMonthly: newUsersMonthly.data().count
        },
        environmentalImpact: {
          totalPoundsCollectedLastMonth: totalPoundsCollected,
          estimatedCarbonSaved: totalPoundsCollected * 0.5, // Rough estimate
          approximateItems: Math.round(totalPoundsCollected * 8) // Rough estimate of items per pound
        },
        generatedAt: FieldValue.serverTimestamp()
      };

      // Store analytics
      await db.collection('analytics')
        .doc(`daily_${yesterday.getFullYear()}_${yesterday.getMonth() + 1}_${yesterday.getDate()}`)
        .set(analyticsData);

      // Update summary document
      await db.collection('analytics').doc('summary').set({
        ...analyticsData,
        type: 'latest'
      });

      logger.info('Generated daily analytics', {
        dailySubmissions: dailySubmissions.data().count,
        weeklySubmissions: weeklySubmissions.data().count,
        totalPoundsCollected
      });

    } catch (error) {
      logger.error('Error generating analytics:', error);
    }
  }
);