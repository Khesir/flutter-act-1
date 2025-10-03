import 'package:flutter_application_1/domain/repository/player_repository.dart';
import 'package:flutter_application_1/domain/usecases/get_products.dart';
import 'package:flutter_application_1/domain/usecases/product_usecases.dart';
import 'package:flutter_application_1/view/managers/home_manager.dart';

// Dependency Injection
class DI {
  static PlayerRepository providePlayerRepository() =>
      InMemoryPlayerRepository();

  static GetProducts provideGetProducts() => GetProducts();

  static HomeManager provideHomeManager() => HomeManager(
    getPlayers: GetPlayers(providePlayerRepository()),
    addPlayer: AddPlayer(providePlayerRepository()),
    updatePlayer: UpdatePlayer(providePlayerRepository()),
    deletePlayer: DeletePlayer(providePlayerRepository()),
  );
}
