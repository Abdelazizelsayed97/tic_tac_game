import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/use_case/game_use_case.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  late GameUseCase _gameUseCase;

  GameCubit({required String userMark}) : super(GameInitial()) {
    _gameUseCase = GameUseCase(userMark: userMark);
    emit(GameLoaded(
      board: _gameUseCase.board,
      isUserTurn: _gameUseCase.isUserTurn,
      isGameOver: _gameUseCase.isGameOver,
      winner: _gameUseCase.winner,
    ),

    );
  }

  void restartGame() {
    _gameUseCase.restartGame();
    emit(
      GameLoaded(
        board: _gameUseCase.board,
        isUserTurn: _gameUseCase.isUserTurn,
        isGameOver: _gameUseCase.isGameOver,
        winner: _gameUseCase.winner,
      ),
    );
  }

  void userMove(int row, int col) {
    _gameUseCase.userMove(row, col);
    emit(
      GameLoaded(
        board: _gameUseCase.board,
        isUserTurn: _gameUseCase.isUserTurn,
        isGameOver: _gameUseCase.isGameOver,
        winner: _gameUseCase.winner,
      ),
    );
  }
}
