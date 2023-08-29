import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';

class SearchByBarcodeScreen extends StatelessWidget {
  const SearchByBarcodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   BlocConsumer<OrdersHomeCubit,OrdersHomeStates>(
      listener: (ctx,state){},
      builder: (ctx,state){
        return Container();
      },
    );
  }
}
