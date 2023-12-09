import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

  const CartState(this.dishes);

  @override
  List<Object?> get props => [dishes];
}

class CartInitial extends CartState {
  CartInitial(List<DishQuantity> dishes) : super(dishes);
}

class CartLoaded extends CartState {
  CartLoaded(List<DishQuantity> dishes) : super(dishes);
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial([]));

  void resetCart(){
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

    emit(CartLoaded(updatedDishes));
  }

  void removeFromCart(Dish dish) {
    final List<DishQuantity> updatedDishes = List.from(state.dishes);

    for (var dishQuantity in updatedDishes) {
      if (dishQuantity.dish == dish) {
        if (dishQuantity.quantity > 1) {
          dishQuantity = DishQuantity(dish, dishQuantity.quantity - 1);
        } else {
          updatedDishes.remove(dishQuantity);
        }
        break;
      }
    }

    emit(CartLoaded(updatedDishes));
  }
}
