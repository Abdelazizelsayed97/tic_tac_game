import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tic_toc_game/features/tic_toc/ui/state_mangement/tasks_cubit/tasks_cubit.dart';
import 'package:tic_toc_game/utils/helpers/spacer.dart';
import 'package:tic_toc_game/utils/text_styles/text_styles.dart';

import '../../../../utils/consts.dart';
import '../state_mangement/game_cubit/game_cubit.dart';
import 'game_result_handler.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * .5,
      child: BlocListener<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is TaskCompleted) {
            print('state is TaskCompleted');
            DefaultTabController.of(context).animateTo(2);
            print('State is $state');
          }
        },
        child: Stack(
          children: [
            Center(
              child: BlocConsumer<GameCubit, GameState>(
                listener: (context, state) {
                  if (state is GameLoaded && state.isGameOver) {

                    ShowDialog.showGameResultDialog(context, state.winner);
                    if (state.winner == Consts.userMark) {
                      context.read<GameCubit>().restartGame();
                      context.read<TasksCubit>().completeTask();
                    }else if (state.winner == Consts.botMark){
                      DefaultTabController.of(context).animateTo(0);
                    }
                  }
                },
                builder: (context, state) {
                  if (state is GameLoaded) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAnimatedText(state.isUserTurn, state.winner),
                        verticalSpace(40),
                        _buildBoard(state.board, context),
                        verticalSpace(20),
                      ],
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedText(bool isUserTurn, String? winner) {
    return Text(
      isUserTurn ? 'Your Turn' : "Bot's Turn",
      style: Styles.normal(fontSize: 28, color: Colors.black),
    );
  }

  Widget _buildBoard(List<List<String?>> board, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (row) => _buildRow(row, board, context)),
    );
  }

  Widget _buildRow(int row, List<List<String?>> board, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (col) => _buildCell(row, col, board, context)),
    );
  }

  Widget _buildCell(int row, int col, List<List<String?>> board,
      BuildContext context) {
    final cellValue = board[row][col];
    return GestureDetector(
      onTap: () {
        setState(() {
          _rebuildUiEveryTap(col: col, row: row);
        });
      },
      child: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.solid),
        ),
        alignment: Alignment.center,
        child: Text(
          cellValue ?? '',
          style: Styles.bold(fontSize: 35, color: Colors.black),
        ),
      ),
    );
  }

  void _rebuildUiEveryTap({required int row, required int col}) {
    context.read<GameCubit>().userMove(row, col);
  }
}
