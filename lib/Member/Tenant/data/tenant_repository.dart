
import '../domain/tenant_model.dart';

abstract class TenantRepository {
  Future<List<TenantModel>> getNominees();
}

class TenantRepositoryImpl implements TenantRepository {
  @override
  Future<List<TenantModel>> getNominees() async {
    // Replace with your API integration.
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      TenantModel(
        id: '201',
        name: 'Sona',
        relationship: '9090909090 | ruchi@gmail.com',
        mobile: '23 Nov 26',
        date: '24 Nov 26',
        isActive: true,
      ),
    ];
  }
}
