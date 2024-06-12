import 'dart:async';
import 'dart:math';

import '../../../../utils/consts.dart';

class GameUseCase {
  final String userMark;
  List<List<String?>> _board;
  bool _isUserTurn;
  bool _isGameOver;
  String? _winner;

  GameUseCase({required this.userMark})
      : _board = List.generate(3, (_) => List.generate(3, (_) => null)),
        _isUserTurn = true,
        _isGameOver = false,
        _winner = null;

  List<List<String?>> get board => _board;
  bool get isUserTurn => _isUserTurn;
  bool get isGameOver => _isGameOver;
  String? get winner => _winner;

  void restartGame() {
    _board = List.generate(3, (_) => List.generate(3, (_) => null));
    _isGameOver = false;
    _winner = null;

    _isUserTurn = Random().nextBool();
  }

  void userMove(int row, int col) {
    if (!_isGameOver && _board[row][col] == null && _isUserTurn) {
      _board[row][col] = userMark;
      _isUserTurn = false;
      _checkGameStatus();
      if (!_isGameOver) {
        _botMove();
      }
    }
  }

  void _botMove() {
    if (!_isGameOver && !_isUserTurn) {
      Timer(const Duration(milliseconds: 800), () {
        final bestMove = _findBestMoveWithAlphaBeta();
        _board[bestMove[0]][bestMove[1]] = getBotMark(userMark);
        _isUserTurn = true;
        _checkGameStatus();
      });
    }
  }

  List<int> _findBestMoveWithAlphaBeta() {
    int bestScore = -1000;
    List<int> bestMove = [-1, -1];
    int alpha = -1000;
    int beta = 1000;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == null) {
          _board[i][j] = Consts.userMark;
          int score = _minimaxWithAlphaBeta(_board, 0, false, alpha, beta);
          _board[i][j] = null;

          if (score > bestScore) {
            bestScore = score;
            bestMove = [i, j];
          }
        }
      }
    }

    return bestMove;
  }

  int _minimaxWithAlphaBeta(List<List<String?>> board, int depth,
      bool isMaximizer, int alpha, int beta) {
    String? winner = _getWinner();
    if (winner == Consts.userMark) {
      return 10 - depth;
    } else if (winner == Consts.botMark) {
      return depth - 10;
    }

    if (_isBoardFull()) {
      return 0;
    }

    if (isMaximizer) {
      int maxScore = -1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == null) {
            board[i][j] = Consts.userMark;
            int score = _minimaxWithAlphaBeta(
                board, depth + 1, false, alpha, beta);
            board[i][j] = null;
            maxScore = max(maxScore, score);
            alpha = max(alpha, score);
            if (beta <= alpha) {
              return maxScore;
            }
          }
        }
      }
      return maxScore;
    } else {
      int minScore = 1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == null) {
            board[i][j] = userMark;
            int score = _minimaxWithAlphaBeta(
                board, depth + 1, true, alpha, beta);
            board[i][j] = null;
            minScore = min(minScore, score);
            beta = min(beta, score);
            if (beta <= alpha) {
              return minScore;
            }
          }
        }
      }
      return minScore;
    }
  }

  String getBotMark(String userMark) {
    return userMark == Consts.botMark? Consts.userMark : Consts.botMark;
  }

  void _checkGameStatus() {
    _winner = _getWinner();
    if (_winner != null || _isBoardFull()) {
      _isGameOver = true;
    }
  }

  String? _getWinner() {
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] != null &&
          _board[i][0] == _board[i][1] &&
          _board[i][0] == _board[i][2]) {
        return _board[i][0];
      }

      if (_board[0][i] != null &&
          _board[0][i] == _board[1][i] &&
          _board[0][i] == _board[2][i]) {
        return _board[0][i];
      }
    }

    if (_board[0][0] != null &&
        _board[0][0] == _board[1][1] &&
        _board[0][0] == _board[2][2]) {
      return _board[0][0];
    }

    if (_board[0][2] != null &&
        _board[0][2] == _board[1][1] &&
        _board[0][2] == _board[2][0]) {
      return _board[0][2];
    }

    return null;
  }

  bool _isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == null) {
          return false;
        }
      }
    }
    return true;
  }
}
