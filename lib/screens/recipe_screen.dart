import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeScreen extends StatefulWidget {
  final String openUrl;
  const RecipeScreen({super.key, required this.openUrl});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String? finalUrl;
  WebViewController webcontroller = WebViewController();

  @override
  void initState() {
    super.initState();
    finalUrl = widget.openUrl;
    if (widget.openUrl.contains('http://')) {
      finalUrl = widget.openUrl.replaceAll("http://", "https://");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 30, right: 24, left: 24, bottom: 16),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff213A50), Color(0xff071930)],
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomLeft)),
            child: const Row(
              mainAxisAlignment:
                  kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "FoodRecipe ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "App",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: WebViewWidget(
                controller: webcontroller
                  ..loadRequest(Uri.parse(finalUrl.toString())),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
