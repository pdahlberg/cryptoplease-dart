import 'package:flutter/material.dart' hide Notification;

import '../../../../core/presentation/page_fade_wrapper.dart';
import '../../../../features/activities/widgets/pending_activities_list.dart';
import '../../../../features/activities/widgets/transaction_list.dart';
import '../../../../l10n/l10n.dart';
import '../../../../ui/app_bar.dart';
import '../../../../ui/navigation_bar/navigation_bar.dart';
import '../../../../ui/tab_bar.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final insets = EdgeInsets.only(
      top: _padding,
      bottom: MediaQuery.of(context).padding.bottom,
    );

    return PageFadeWrapper(
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          children: [
            CpAppBar(
              title: Text(context.l10n.activitiesTitle.toUpperCase()),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CpTabBar(
                tabs: [
                  Tab(text: 'Pending'),
                  Tab(text: 'Transactions'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _Wrapper(
                    child: PendingActivitiesList(padding: insets),
                  ),
                  _Wrapper(
                    child: TransactionList(padding: insets),
                  ),
                ],
              ),
            ),
            const SizedBox(height: cpNavigationBarheight),
          ],
        ),
      ),
    );
  }
}

const double _padding = 40;

class _Wrapper extends StatelessWidget {
  const _Wrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          const FadeGradient(
            height: _padding,
            direction: FadeGradientDirection.topDown,
          ),
        ],
      );
}
