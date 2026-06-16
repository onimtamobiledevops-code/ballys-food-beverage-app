import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _controller = VideoPlayerController.asset('assets/video/splashscreen.mp4');

    await _controller.initialize();

    await _controller.setLooping(false);
    await _controller.setVolume(0.0);
    await _controller.play();

    _controller.addListener(_onVideoProgress);

    if (mounted) setState(() {});
  }

  void _onVideoProgress() {
    if (_controller.value.position >= _controller.value.duration &&
        !_hasNavigated) {
      _navigate();
    }
  }

  void _navigate() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoProgress);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _navigate, // Tap anywhere to skip
        child: SizedBox.expand(
          child: _controller.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}