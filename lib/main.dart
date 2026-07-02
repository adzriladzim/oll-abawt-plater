import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/movie_bloc.dart';
import 'screens/movie_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(MovieService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color(0xFFF8F9FD),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const MovieList(),
      ),
    );
  }
}

