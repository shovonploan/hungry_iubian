import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hungry_iubian/models/discount.dart';
import 'package:hungry_iubian/models/dish.dart';

class DishQuantity {
  final Dish dish;
  final int quantity;

  const DishQuantity(this.dish, this.quantity);
  Map<String, dynamic> toJson() {
    return {
      'dishId': dish.dishId,
      'quantity': quantity,
    };
  }
}

abstract class CartState extends Equatable {
  final List<DishQuantity> dishes;
  final Discount? discount;

  const CartState(this.dishes, this.discount);

  @override
  List<Object?> get props => [dishes];
}

class CartInitial extends CartState {
  CartInitial(List<DishQuantity> dishes) : super(dishes, null);
}

class CartLoaded extends CartState {
  CartLoaded(List<DishQuantity> dishes, Discount? discount)
      : super(dishes, discount);
}

Future<Discount?> getDiscount(String discountCode) async {
  try {
    final response =
        await Dio().get('http://localhost:3000/getDiscount', data: {
      'code': discountCode,
    });
    if (response.data != []) {
      return Discount.fromJson(response.data[0]);
    }
    return null;
  } catch (error) {
    print('Error: $error');
    return null;
  }
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial([]));

  void resetCart() {
    emit(CartInitial([]));
  }

  void addToCart(Dish dish) {
    final List<DishQuantity> updatedDishes = List.from(state.dishes);

    int existingIndex =
        updatedDishes.indexWhere((dishQuantity) => dishQuantity.dish == dish);
    bool dishExists = existingIndex != -1;

    if (dishExists) {
      updatedDishes[existingIndex] =
          DishQuantity(dish, updatedDishes[existingIndex].quantity + 1);
    } else {
      updatedDishes.add(DishQuantity(dish, 1));
    }

    emit(CartLoaded(updatedDishes, state.discount));
  }

  void removeFromCart(Dish dish) {
    final List<DishQuantity> updatedDishes = List.from(state.dishes);

    for (var dishQuantity in updatedDishes) {
      if (dishQuantity.dish.dishId == dish.dishId) {
        updatedDishes.remove(dishQuantity);
        break;
      }
    }

    emit(CartLoaded(updatedDishes, state.discount));
  }

  void addDiscount(String discountCode) async {
    var dis = await getDiscount(discountCode);
    emit(CartLoaded(state.dishes, dis));
  }

  void removeDiscount() {
    emit(CartLoaded(state.dishes, null));
  }
}
