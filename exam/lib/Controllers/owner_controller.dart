import 'package:exam/Models/bike.dart';
import 'package:exam/Repository/owner_repository.dart';

class OwnerController {
  OwnerRepository ownerRepository = new OwnerRepository();

  Future<List<Bike>> getAll() {
    return ownerRepository.getAll();
  }

  Future<Bike> addBike(Bike bike) {
    return ownerRepository.addBike(bike);
  }

  Future<String> deleteBike(Bike bike) {
    return ownerRepository.deleteBike(bike.id);
  }
}
