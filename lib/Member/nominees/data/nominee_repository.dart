
import '../domain/nominee_model.dart';

abstract class NomineeRepository {
  Future<List<NomineeModel>> getNominees();
}

class NomineeRepositoryImpl implements NomineeRepository {
  @override
  Future<List<NomineeModel>> getNominees() async {
    // Replace with your API integration.
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      NomineeModel(
        id: '1',
        name: 'prasad',
        relationship: 'Son',
        mobile: '9029634544',
        date: '24 Nov 26',
        isActive: true,
      ),
    ];
  }
}
