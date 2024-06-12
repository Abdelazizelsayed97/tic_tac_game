import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/text_styles/text_styles.dart';
import '../state_mangement/game_cubit/game_cubit.dart';

class ShowDialog {
  static void showGameResultDialog(BuildContext? context, String? winner) {
    _handleGameResultDialog(context!, winner);
  }

  static showErrorDialog() {}
}

// void showErrorDialog(BuildContext context, String) {}

void _handleGameResultDialog(
  BuildContext context,
  String? winner,
) {
  final gameCubit = context.read<GameCubit>();

  final userMark = (gameCubit.state as GameLoaded).board.first.first;

  final GameResultDialogConfig config = _getDialogConfig(userMark!, winner);
  void _handleButtonClick(BuildContext context) {
    if (config.message == GameResultDialogMessage.userWins) {
      Navigator.of(context).pop();
    }
    if (config.message == GameResultDialogMessage.botWins) {
      Navigator.of(context).pop();
    }
    if (config.message == GameResultDialogMessage.equal) {
      Navigator.of(context).pop();
      gameCubit.restartGame();
    }
  }

  String buttonString() {
    String result = '';
    if (config.message == GameResultDialogMessage.userWins) {
      result = "Complete";
    }
    if (config.message == GameResultDialogMessage.botWins) {
      result = "Failed";
    }
    if (config.message == GameResultDialogMessage.equal) {
      result = "retry";
    }
    return result ?? '';
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          gameCubit.restartGame();
          return true;
        },
        child: AlertDialog(
          content: Text(
            config.message,
            style: Styles.normal(fontSize: 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _handleButtonClick(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(config.buttonColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: Text(buttonString()),
            ),
          ],
        ),
      );
    },
  );
}

class GameResultDialogConfig {
  final String message;

  final Color buttonColor;

  GameResultDialogConfig({
    required this.message,
    required this.buttonColor,
  });
}

GameResultDialogConfig _getDialogConfig(String userMark, String? winner) {
  if (winner == userMark) {
    return GameResultDialogConfig(
      message: GameResultDialogMessage.userWins,
      buttonColor: Colors.green,
    );
  } else if (winner != null) {
    return GameResultDialogConfig(
      message: GameResultDialogMessage.botWins,
      buttonColor: Colors.red,
    );
  } else {
    return GameResultDialogConfig(
      message: GameResultDialogMessage.equal,
      buttonColor: Colors.blue,
    );
  }
}

class GameResultDialogMessage {
  static const String userWins = 'Congratulations! You Win!';
  static const String botWins = 'Bot Wins! Better luck next time.';
  static const String equal = "It's a Draw!";
}
