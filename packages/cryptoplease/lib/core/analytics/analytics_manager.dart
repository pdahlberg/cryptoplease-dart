import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AnalyticsManager {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get analyticsObserver =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  void swapTransactionCreated({
    required String from,
    required String to,
    required int amount,
  }) =>
      _analytics.logEvent(
        name: 'swapTransactionCreated',
        parameters: {
          'from': from,
          'to': to,
          'amount': amount,
        },
      );

  // User creates shareable link.
  void linksCreated() => _analytics.logEvent(name: 'linksCreated');

  // User pressed on the first shareable link.
  void firstLinkReceived() => _analytics.logEvent(name: 'firstLinkReceived');

  // User pressed on the second shareable link.
  void secondLinkReceived() => _analytics.logEvent(name: 'secondLinkReceived');

  // User creates shareable link.
  void tipLinkCreated() => _analytics.logEvent(name: 'linkCreated');

  // User pressed on the tip link.
  void tipLinkReceived() => _analytics.logEvent(name: 'tipLinkReceived');
}
