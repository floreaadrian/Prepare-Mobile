import 'package:exam/Models/bike.dart';
import 'package:exam/Repository/loaned_repo.dart';
import 'package:exam/Repository/user_online_repo.dart';

class UserController {
  UserOnlineRepo onlineRepo = new UserOnlineRepo();
  LoanedRepo loanedRepo = new LoanedRepo();

  Future<List<Bike>> getAvalibleBikes() async {
    return onlineRepo.getAvalibleBikes();
  }

  Future<String> loanBike(Bike bike) async {
    String response = await onlineRepo.loanBike(bike.id);
    if (response == "") {
      await loanedRepo.add(bike);
    }
    return response;
  }

  Future<String> returnBike(int id) async {
    String response = await onlineRepo.returnBike(id);
    return response;
  }

  Future<List<Bike>> historyLoaned() async {
    return loanedRepo.history();
  }
}
