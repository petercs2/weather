import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

import '../weather_tab/weather_tab_logic.dart';

class GetFailedSet extends GetView<WeatherTabLogic> {
  const GetFailedSet({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final c = controller.webViewController;
        if (c != null) {
          if (await c.canGoBack()) {
            c.goBack();
            return false;
          }
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              // url: WebUri.uri(Uri.parse("https://m.myq.cc/csCenter")),
              url: WebUri.uri(Uri.parse(controller.ufpdrn.value)),
            ),
            initialSettings: InAppWebViewSettings(
              cacheEnabled: false
            ),
            onWebViewCreated: (c) {
              controller.webViewController = c;
              // if(controller.webViewController != null){
              //   InAppWebViewController.clearAllCache();
              //   controller.webViewController?.reload();
              // }
              // c.addJavaScriptHandler(
              //   handlerName: 'openWhatsApp',
              //   callback: (args) {
              //     // args[0]  - 电话号码，args[1]  - 消息内容
              //     _openWhatsApp(args[0], args.length > 1 ? args[1] : '');
              //   },
              // );
              // c.addJavaScriptHandler(
              //   handlerName: 'openEmail',
              //   callback: (args) {
              //     // args[0] - 邮箱地址，args[1] - 主题，args[2]  - 正文
              //     _openEmail(args[0], args.length > 1 ? args[1] : '',
              //         args.length > 2 ? args[2] : '');
              //   },
              // );
            },
            shouldOverrideUrlLoading: (controller1, navigationAction) async {
              final uri = navigationAction.request.url;
              if (uri == null) return NavigationActionPolicy.ALLOW;
              if (uri.toString().startsWith('https://wa.me/') ||
                  uri.toString().startsWith('whatsapp://')) {
                await _openWhatsApp(
                    uri.pathSegments.last, uri.queryParameters['text'] ?? '');
                return NavigationActionPolicy.CANCEL;
              }

              if (uri.scheme == 'mailto') {
                await launch(uri.toString());
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
          ),
        ),
      ),
    );
  }

  Future<void> _openWhatsApp(String phone, String text) async {
    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(text)}';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        await launch(
            'https://web.whatsapp.com/send?phone=$phone&text=${Uri.encodeComponent(text)}');
      }
    } catch (e) {
      print('Could not launch WhatsApp: $e');
    }
  }
}
