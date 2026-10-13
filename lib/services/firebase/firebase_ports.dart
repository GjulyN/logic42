/// Optional backend ports. Implementations must not be required for offlineDemo.
abstract class AuthPort {
  Future<String?> currentUserId();
  Future<String> ensureAnonymousUser();
}

class LocalAuthAdapter implements AuthPort {
  String? _id = 'offline-local-user';

  @override
  Future<String?> currentUserId() async => _id;

  @override
  Future<String> ensureAnonymousUser() async {
    _id ??= 'offline-local-user';
    return _id!;
  }
}

abstract class CloudSavePort {
  Future<void> upsertProgress(Map<String, Object?> record);
  Future<Map<String, Object?>?> fetchProgress(String puzzleId);
}

class NoOpCloudSave implements CloudSavePort {
  @override
  Future<void> upsertProgress(Map<String, Object?> record) async {}

  @override
  Future<Map<String, Object?>?> fetchProgress(String puzzleId) async => null;
}

abstract class CrashPort {
  Future<void> recordError(Object error, StackTrace stack);
}

class NoOpCrash implements CrashPort {
  const NoOpCrash();

  @override
  Future<void> recordError(Object error, StackTrace stack) async {}
}
