import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hungry_iubian/models/dish.dart';

abstract class MenuState extends Equatable {
  final List<Dish> dishes;

  const MenuState(this.dishes);

  @override
  List<Object?> get props => [dishes];
}

class MenuInitial extends MenuState {
  MenuInitial(List<Dish> dishes) : super(dishes);
}

class MenuLoaded extends MenuState {
  MenuLoaded(List<Dish> dishes) : super(dishes);
}

Future<List<Dish>> getDishes() async {
  try {
    final response = await Dio().get(
      'http://localhost:3000/userDishes',
    );
    List<Dish> dishes = [];
    for (var res in response.data) {
      dishes.add(Dish.fromJson(res));
    }
    return dishes;
  } catch (error) {
    print('Error: $error');
    return [];
  }
}

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuInitial([])) {
    loadMenues();
  }

  void loadMenues() async {
    try {
      final dishes = await getDishes();
      emit(MenuLoaded(dishes));
    } catch (error) {
      // Handle error if needed
      print('Error loading menus: $error');
    }
  }
}

