import 'dart:io';

class CalleyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Allow mock-api host SSL certificate mismatch
        if (host.contains('mock-api.calleyacd.com') || host.contains('calley')) {
          return true;
        }
        return false;
      };
  }
}

