part of 'game_cubit.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {}

class GameLoaded extends GameState {
  final List<List<String?>> board;
  final bool isUserTurn;
  final bool isGameOver;
  final String? winner;

  const GameLoaded({
    required this.board,
    required this.isUserTurn,
    required this.isGameOver,
    required this.winner,
  });

  @override
  List<Object?> get props => [board, isUserTurn, isGameOver, winner];
}
