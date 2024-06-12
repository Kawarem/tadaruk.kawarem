part of 'app_bloc.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

class ChangeNotificationsNumberState extends AppState {}

class ChangeNotificationsTimeState extends AppState {}

class ChangeMistakeRepetitionState extends AppState {}

class ChangeMistakeKindState extends AppState {}

class ValidateTextFormFieldState extends AppState {
  final bool validator;

  ValidateTextFormFieldState({required this.validator});
}

class ChangeSurahInAddMistakeScreenState extends AppState {
  final int versesNumber;

  ChangeSurahInAddMistakeScreenState({required this.versesNumber});
}

class ChangeDisplayTypeInHomeScreenState extends AppState {}

class AppBarCollapsedState extends AppState {
  final bool isCollapsed;

  AppBarCollapsedState({required this.isCollapsed});
}
