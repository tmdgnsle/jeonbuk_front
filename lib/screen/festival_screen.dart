import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/components/festival_custom_list_box.dart';
import 'package:jeonbuk_front/cubit/festival_list_cubit.dart';
import 'package:jeonbuk_front/model/festival.dart';
import 'package:jeonbuk_front/screen/festival_detail_screen.dart';

class FestivalScreen extends StatefulWidget {
  const FestivalScreen({Key? key}) : super(key: key);

  @override
  State<FestivalScreen> createState() => _FestivalScreenState();
}

class _FestivalScreenState extends State<FestivalScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - 200 <=
          scrollController.offset) {
        context.read<FestivalListCubit>().loadFestivalList();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }


  Widget _error(String errMessage) {
    return Center(
      child: Text(errMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<FestivalListCubit, FestivalListCubitState>(
        builder: (context, state) {
          if (state is ErrorFestivalListCubitState) {
            return _error(state.errorMessage);
          }
          if (state is LoadedFestivalListCubitState ||
              state is LoadingFestivalListCubitState) {
            List<Festival> stores = state.festivalListResult.festivalList;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemBuilder: (context, index) => FestivalCustomListBox(
                        festival: stores[index],
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => FestivalListCubit(),
                                  child: FestivalDetailScreen(
                                    festival: stores[index],
                                  ),
                                ),
                              ));
                        },
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: stores.length,
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: AppNavigationBar(),
    );
  }
}
