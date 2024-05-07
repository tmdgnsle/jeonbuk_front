import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/cubit/safe_home_cubit.dart';
import 'package:jeonbuk_front/screen/add_safe_screen.dart';

class SafeHomeScreen extends StatefulWidget {
  const SafeHomeScreen({super.key});

  @override
  State<SafeHomeScreen> createState() => _SafeHomeScreenState();
}

class _SafeHomeScreenState extends State<SafeHomeScreen> {
  Widget _error(String errMessage) {
    return Center(
      child: Text(errMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('안심귀가'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddSafeScreen()));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: BlocBuilder<SafeHomeCubit, SafeHomeCubitState>(
        builder: (context, state) {
          if (state is ErrorSafeHomeCubitState) {
            return _error(state.errorMessage);
          }
          if (state is LoadedSafeHomeCubitState ||
              state is LoadingSafeHomeCubitState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListView.separated(
                      itemBuilder: (context, index) {},
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 16,
                          ),
                      itemCount: state.safeHomeListResult.safehomeList.length),
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
