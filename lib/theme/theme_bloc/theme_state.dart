part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class LoadedThemeState extends ThemeState {
  final ThemeData themeData;
  final int? themeIndex;

  const LoadedThemeState({
    required this.themeData,
    required this.themeIndex,
  });

  @override
  List<Object> get props => [themeData];
}
