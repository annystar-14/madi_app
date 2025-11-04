import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AssistantWebView extends StatefulWidget {
  const AssistantWebView({Key? key}) : super(key: key);

  @override
  State<AssistantWebView> createState() => _AssistantWebViewState();
}

class _AssistantWebViewState extends State<AssistantWebView> {
  InAppLocalhostServer? localhostServer;
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    localhostServer = InAppLocalhostServer(documentRoot: 'assets/web');
    localhostServer!.start();
  }

  @override
  void dispose() {
    localhostServer?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri('http://localhost:8080/assistant_3d.html'),
          ),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              transparentBackground: true,
              javaScriptEnabled: true,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
            ),
          ),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
        ),
      ),
    );
  }
}
