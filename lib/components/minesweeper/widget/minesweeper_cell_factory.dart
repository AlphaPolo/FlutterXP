import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../r.g.dart';
import '../constant/minesweeper_constant.dart';
import '../minesweeper_game_core.dart';
import '../minesweeper_game_screen.dart';

const _curves = Curves.elasticOut;

class MinesweeperCellFactory extends StatelessWidget {

  const MinesweeperCellFactory({
    super.key,
    required this.state,
    required this.viewModel,
    required this.position,
    this.isPressed = false,
  });


  final MinesweeperCellState state;
  final MinesweeperViewModel viewModel;
  final Point<int> position;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    return cellBuilder();
  }


  Widget cellBuilder() {
    switch (state) {
      case MinesweeperCellState.x:
        return const _MineExploreCell();
      case MinesweeperCellState.empty when viewModel.isGameOver && viewModel.hasFlag(position):

        /// 遊戲結束時結算
        /// 此情形是指有插旗子但該位置卻沒有地雷的情況
        /// 也就是玩家以為該位置有地雷但實際上是猜錯的
        return const _HasFlagButNotHasMineCell();
      case MinesweeperCellState.mine when viewModel.isGameOver && !viewModel.hasFlag(position):

        /// 遊戲結束時結算
        /// 此情形是指沒插旗子但該位置卻有地雷的情況
        /// 也就是玩家以為該位置沒有地雷但實際上是猜錯的
        return const _HasMineButNotHasFlagCell();

      case MinesweeperCellState.empty:
      case MinesweeperCellState.mine:
        if (viewModel.hasFlag(position)) {
          return const _FlagCell();
        } else {
          if(isPressed) {
            return const _BlankCell();
          }
          else {
            return const _EmptyCell();
          }

        }

      case MinesweeperCellState.blank:
        return const _BlankCell();
      case final cellState when cellState.isDigit:
        final value = cellState.value;
        return _DigitCell(digit: value);

      default:
        return const _DefaultCell();
    }
  }

}

class _DefaultCell extends StatelessWidget {
  const _DefaultCell({super.key});


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 300.ms,
      curve: _curves,
      decoration: MinesweeperConstant.defaultDecoration,
    );
  }
}


class _MineExploreCell extends StatelessWidget {
  const _MineExploreCell({super.key});


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 300.ms,
      curve: _curves,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(253, 0, 1, 1.0),
      ),
      child: Center(
        child: Image(
          image: R.image.mine_death(),
          width: MinesweeperConstant.iconSize,
          height: MinesweeperConstant.iconSize,
        ),
        // child: Icon(CupertinoIcons.staroflife_fill, color: Colors.black, size: MinesweeperConstant.iconSize),
      ),
    );
  }
}

class _HasFlagButNotHasMineCell extends StatelessWidget {
  const _HasFlagButNotHasMineCell({super.key});


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 300.ms,
      curve: _curves,
      decoration: MinesweeperConstant.defaultDecoration,
      child: Image(
        image: R.image.misflagged(),
        width: MinesweeperConstant.iconSize,
        height: MinesweeperConstant.iconSize,
      ),
      // child: const Stack(
      //   fit: StackFit.expand,
      //   children: [
      //     Center(child: Icon(CupertinoIcons.staroflife_fill, color: Colors.black, size: MinesweeperConstant.iconSize)),
      //     Center(child: Icon(Icons.close, color: Colors.red, size: MinesweeperConstant.iconSize)),
      //   ],
      // ),
    );
  }
}


class _HasMineButNotHasFlagCell extends StatelessWidget {
  const _HasMineButNotHasFlagCell({super.key});


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 300.ms,
      curve: _curves,
      decoration: MinesweeperConstant.defaultDecoration,
      // child: const Icon(CupertinoIcons.staroflife_fill, color: Colors.black, size: MinesweeperConstant.iconSize),
      child: Image(
        image: R.image.mine_ceil(),
        width: MinesweeperConstant.iconSize,
        height: MinesweeperConstant.iconSize,
      ),
    );
  }
}


class _FlagCell extends StatelessWidget {
  const _FlagCell({super.key});


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 300.ms,
      curve: _curves,
      decoration: MinesweeperConstant.defaultDecoration,
      child: const Center(child: Icon(Icons.flag, color: Colors.red, size: MinesweeperConstant.iconSize)),
    );
  }
}

class _EmptyCell extends StatelessWidget {
  const _EmptyCell({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 300.ms,
      curve: _curves,
      decoration: MinesweeperConstant.defaultDecoration,
    );
  }
}

class _BlankCell extends StatelessWidget {
  const _BlankCell({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 300.ms,
      curve: _curves,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(197, 197, 197, 1.0),
        border: Border(
          left: BorderSide(width: 1.2, color: Color.fromRGBO(128, 128, 128, 1)),
          top: BorderSide(width: 1.2, color: Color.fromRGBO(128, 128, 128, 1)),
        ),
      ),
    );
  }
}

class _DigitCell extends StatelessWidget {
  const _DigitCell({super.key, required this.digit});
  final String digit;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 300.ms,
      curve: _curves,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(197, 197, 197, 1.0),
        border: Border(
          left: BorderSide(width: 1.2, color: Color.fromRGBO(128, 128, 128, 1)),
          top: BorderSide(width: 1.2, color: Color.fromRGBO(128, 128, 128, 1)),
        ),
      ),
      child: Center(
        child: switchText(digit),
        // child: Text(
        //   digit,
        //   style: TextStyle(
        //     fontSize: 12,
        //     fontWeight: FontWeight.w900,
        //     color: switchTextColor(digit),
        //     fontFeatures: const [FontFeature.oldstyleFigures()],
        //   ),
        // ),
      ),
    );
  }


  Color? switchTextColor(String value) {
    return switch(value) {
      '1' => const Color.fromRGBO(0, 1, 247, 1.0),
      '2' => const Color.fromRGBO(1, 126, 2, 1.0),
      '3' => const Color.fromRGBO(250, 1, 1, 1.0),
      '4' => const Color.fromRGBO(1, 1, 128, 1.0),
      '5' => const Color.fromRGBO(128, 2, 1, 1.0),
      '6' => const Color.fromRGBO(0, 127, 128, 1.0),
      '7' => const Color.fromRGBO(0, 0, 1, 1.0),
      '8' => const Color.fromRGBO(127, 127, 128, 1.0),
      _ => null,
    };
  }

  Widget? switchText(String value) {
    return switch(value) {
      '1' => Image(image: R.image.open1()),
      '2' => Image(image: R.image.open2()),
      '3' => Image(image: R.image.open3()),
      '4' => Image(image: R.image.open4()),
      '5' => Image(image: R.image.open5()),
      '6' => Image(image: R.image.open6()),
      '7' => Image(image: R.image.open7()),
      '8' => Image(image: R.image.open8()),
      _ => null,
    };
  }
}
