import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canAuthenticate() async {
    return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
  }

  Future<bool> authenticate() async {
    try {
      final isAuthenticated = await _auth.authenticate(
        localizedReason: 'Authenticate to access your finance data',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      return isAuthenticated;
    } catch (e) {
      return false;
    }
  }
}
