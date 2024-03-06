import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const WeViewDemo(),
    );
  }
}

class WeViewDemo extends StatefulWidget {
  const WeViewDemo({Key? key}) : super(key: key);

  @override
  State<WeViewDemo> createState() => _WeViewDemoState();
}

class _WeViewDemoState extends State<WeViewDemo>
    with WidgetsBindingObserver {
  WebViewController _controller = WebViewController();
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer
    checkConnectivity();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://api.whatsapp.com/send?&text=Qurinom%20Solutions%20|%20Speedy%20Management%20|%20Designing%20Solution%20throug%20https://qurinomsolutions.com')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://qurinomsolutions.com/'));

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkConnectivity(); // Check connectivity when app resumes
    }
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () async {
      final messagere = ScaffoldMessenger.of(context);
      if (await _controller.canGoBack ()
    ){
    await _controller.goBack();

    }else{
    messagere.showSnackBar(SnackBar(content: Text('No Back History Found')));
    return;
      }
  },
    icon: Icon(Icons.arrow_back_ios),
              ),
              IconButton(
                onPressed: () async {
                  final messagere = ScaffoldMessenger.of(context);
                  if (await _controller.canGoForward()
                  ){
                    await _controller.goForward();

                  }else{
                    messagere.showSnackBar(SnackBar(content: Text('No Back History Found')));
                    return;
                  }
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ],
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: _isOnline ? _buildWebView() : _buildNoInternetView(),
    );
  }

  Widget _buildWebView() {
    return WebViewWidget(
    controller: _controller,
    );
  }

  Widget _buildNoInternetView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/NoInternet.gif',
            height: 300,
          ),
          const SizedBox(height: 20),
          Text(
            'No internet connection.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.amber,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              checkConnectivity();
              if (_isOnline && _controller != null) {
                _controller.reload();
              }
            },
            child: Text(
              'Try Again',
              style: TextStyle(
                fontSize: 15,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
