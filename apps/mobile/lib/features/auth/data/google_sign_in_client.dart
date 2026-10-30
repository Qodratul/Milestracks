import 'package:google_sign_in/google_sign_in.dart';
import 'package:milestracks/core/config/app_config.dart';

abstract interface class GoogleSignInClient {
  Future<String?> acquireIdToken();
  Future<void> signOut();
}

class PlatformGoogleSignInClient implements GoogleSignInClient {
  Future<void>? _initializing;

  Future<void> _initialize() =>
      _initializing ??= GoogleSignIn.instance.initialize(
        clientId: _emptyToNull(AppConfig.googleClientId),
        serverClientId: _emptyToNull(AppConfig.googleServerClientId),
      );

  @override
  Future<String?> acquireIdToken() async {
    await _initialize();
    final google = GoogleSignIn.instance;
    if (!google.supportsAuthenticate()) {
      throw UnsupportedError('googleSignInNotConfigured');
    }
    try {
      final account = await google.authenticate();
      return account.authentication.idToken;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      if (error.code == GoogleSignInExceptionCode.clientConfigurationError ||
          error.code == GoogleSignInExceptionCode.providerConfigurationError) {
        throw UnsupportedError('googleSignInNotConfigured');
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _initialize();
    await GoogleSignIn.instance.signOut();
  }

  String? _emptyToNull(String value) => value.isEmpty ? null : value;
}
