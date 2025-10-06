import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

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
  Timer? _timer;

  @override
  void didUpdateWidget(ConnectionBanner oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isOnline != oldWidget.isOnline) {
      // When offline, show always
      if (!widget.isOnline) {
        setState(() => _visible = true);
      } else {
        // When back online, show for 3 seconds then fade out
        setState(() => _visible = true);
        _timer?.cancel();
        _timer = Timer(const Duration(seconds: 3), () {
          if (mounted) setState(() => _visible = false);
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
          child: Text(
            widget.isOnline ? "Back Online" : "Viewing Offline Mode",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}