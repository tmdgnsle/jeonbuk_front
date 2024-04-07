import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeonbuk_front/components/discount_store_list.dart';
import 'package:jeonbuk_front/cubit/discount_store_cubit.dart';
import 'package:jeonbuk_front/model/discount_store_result.dart';

class DiscountStoreScreen extends StatefulWidget {
  const DiscountStoreScreen({super.key});

  @override
  State<DiscountStoreScreen> createState() => _DiscountStoreScreenState();
}

class _DiscountStoreScreenState extends State<DiscountStoreScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - 200 <=
          scrollController.offset) {
        context.read<DiscountStoreCubit>().loadDiscountStoreList();
      }
    });
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _error(String errMessage) {
    return Center(
      child: Text(errMessage),
    );
  }

  Widget _discountStoreListWidget(List<DiscountStore> discountStore) {
    return ListView.separated(
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index == discountStore.length) {
            return _loading();
          }
          return DiscountStoreList(discountStore: discountStore[index]);
        },
        separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
            ),
        itemCount: discountStore.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(onPressed: (){}, icon: Icon(Icons.map)),
        ],
      ),
      body: BlocBuilder<DiscountStoreCubit, DiscountStoreCubitState>(
        builder: (context, state) {
          if (state is ErrorDiscountStoreCubitState) {
            return _error(state.errorMessage);
          }
          if(state is LoadedDiscountStoreCubitState || state is LoadingDiscountStoreCubitState){
            return _discountStoreListWidget(state.discountStoreResult.discountStoreList);
          }
          return Container();
        },
      ),
    );
  }
}
