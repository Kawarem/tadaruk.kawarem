part of 'sql_cubit.dart';

@immutable
sealed class SqlState {}

final class SqlInitial extends SqlState {}

final class CreateDatabaseState extends SqlState {}

final class GetDatabaseState extends SqlState {}

final class InsertDatabaseState extends SqlState {}

final class UpdateDatabaseState extends SqlState {}

final class DeleteDatabaseState extends SqlState {}
