import 'package:expenses_tracking_app/core/services/local_auth_service.dart';
import 'package:expenses_tracking_app/data/repositories/user_repo.dart';

class LocalAuthRepository {
  final LocalAuthService localAuthService;
  final UserRepository userRepo;

  LocalAuthRepository(this.localAuthService, this.userRepo);

  Future<bool> authenticateIfEnabled() async {
    final enabled = await userRepo.isLocalAuthEnabled();
    if (!enabled) return true;

    final available = await localAuthService.canAuthenticate();
    if (!available) return true;

    return await localAuthService.authenticate();
  }
}
