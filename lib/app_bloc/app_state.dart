part of 'app_bloc.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

class ChangeNotificationsNumberState extends AppState {}

class ChangeNotificationsTimeState extends AppState {}
