abstract class EntitlementRepository {
  Future<bool> hasPremium();
  Future<void> cacheVerifiedPremium(bool value);
}

/// Never unlock premium from a mutable local boolean alone.
class OfflineEntitlementRepository implements EntitlementRepository {
  const OfflineEntitlementRepository();

  @override
  Future<bool> hasPremium() async => false;

  @override
  Future<void> cacheVerifiedPremium(bool value) async {}
}

abstract class StoreService {
  Future<void> restorePurchases();
  Future<void> purchasePremium();
  Stream<bool> get purchaseUpdates;
}

class DisabledStoreService implements StoreService {
  const DisabledStoreService();

  @override
  Future<void> restorePurchases() async {}

  @override
  Future<void> purchasePremium() async {
    throw UnsupportedError('Monetization is disabled');
  }

  @override
  Stream<bool> get purchaseUpdates => const Stream.empty();
}

class FakeStoreService implements StoreService {
  FakeStoreService({this.restoredPremium = false});

  final bool restoredPremium;
  bool _premium = false;

  @override
  Future<void> restorePurchases() async {
    _premium = restoredPremium;
  }

  @override
  Future<void> purchasePremium() async {
    _premium = true;
  }

  @override
  Stream<bool> get purchaseUpdates async* {
    yield _premium;
  }
}
