import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class GameScreen extends StatefulWidget {
  final int port;
  final String directoryIndex;
  final String documentRoot;
  final bool shared;

  const GameScreen({
    super.key,
    this.port = 8080,
    this.directoryIndex = 'index.html',
    this.documentRoot = './',
    this.shared = false,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final InAppLocalhostServer localhostServer;
  @override
  void initState() {
    super.initState();
    localhostServer = InAppLocalhostServer(
      port: widget.port,
      directoryIndex: widget.directoryIndex,
      documentRoot: widget.documentRoot,
      shared: widget.shared,
    );
    localhostServer.start();
  }

  @override
  void dispose() {
    localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("http://localhost:${widget.port}/${widget.directoryIndex}"),
        ),
      ),
    );
  }
}
