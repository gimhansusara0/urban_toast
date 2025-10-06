import 'package:flutter/material.dart';
import 'package:urban_toast/utils/global_refresher.dart';

class GlobalRefreshWrapper extends StatefulWidget {
  final Widget child;

  const GlobalRefreshWrapper({super.key, required this.child});

  @override
  State<GlobalRefreshWrapper> createState() => _GlobalRefreshWrapperState();
}

class _GlobalRefreshWrapperState extends State<GlobalRefreshWrapper> {
  bool _refreshing = false;

  Future<void> _handleRefresh() async {
    setState(() => _refreshing = true);
    await GlobalRefresher.refreshAll(context);
    setState(() => _refreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _handleRefresh,
          color: Theme.of(context).primaryColor,
          displacement: 40,
          edgeOffset: 60,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: widget.child,
          ),
        ),

        // Optional overlay
        if (_refreshing)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
