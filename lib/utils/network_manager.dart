import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:urban_toast/utils/global_refresher.dart';

/// Create a navigator key globally so NetworkManager can access BuildContext
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NetworkManager with ChangeNotifier {
  bool _isOnline = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool get isOnline => _isOnline;

  NetworkManager() {
    _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateStatus(results);
    });
    _initCheck();
  }

  Future<void> _initCheck() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final hasConnection = results.isNotEmpty && results.any((r) => r != ConnectivityResult.none);
    if (hasConnection != _isOnline) {
      _isOnline = hasConnection;
      notifyListeners();

      if (_isOnline) {
        _triggerGlobalRefresh();
      }
    }
  }

  // When back online, refresh all app data
  Future<void> _triggerGlobalRefresh() async {
    try {
      debugPrint("Reconnected — refreshing all data...");
      await Future.delayed(const Duration(seconds: 1));

      final ctx = navigatorKey.currentContext;
      if (ctx != null) {
        // Show syncing snackbar
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text("Refreshing data after reconnect..."),
            duration: Duration(seconds: 2),
          ),
        );

        await GlobalRefresher.refreshAll(ctx);

        debugPrint("Data refreshed after reconnection");
      } else {
        debugPrint("No valid context to refresh");
      }
    } catch (e) {
      debugPrint("Error refreshing after reconnect: $e");
    }
  }

  void disposeManager() {
    _subscription?.cancel();
  }
}


// Banner widget

class ConnectionBanner extends StatefulWidget {
  final bool isOnline;
  const ConnectionBanner({super.key, required this.isOnline});

  @override
  State<ConnectionBanner> createState() => _ConnectionBannerState();
}

class _ConnectionBannerState extends State<ConnectionBanner> {
  bool _visible = false;
  bool _isSyncing = false;

  @override
  void didUpdateWidget(ConnectionBanner oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isOnline != oldWidget.isOnline) {
      if (!widget.isOnline) {
        // Always show offline message
        setState(() {
          _visible = true;
          _isSyncing = false;
        });
      } else {
        // When back online: show syncing until refresh finishes
        setState(() {
          _visible = true;
          _isSyncing = true;
        });

        // Wait for data to refresh before hiding
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isSyncing = false;
            });
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) setState(() => _visible = false);
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: _visible ? 0 : -40,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: 28,
          color: widget.isOnline ? Colors.green : Colors.redAccent,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isOnline && _isSyncing)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              if (widget.isOnline && _isSyncing)
                const SizedBox(width: 6),
              Text(
                widget.isOnline
                    ? (_isSyncing
                        ? "Back Online — Refreshing..."
                        : "Back Online — Updated")
                    : "Viewing Offline Mode",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
