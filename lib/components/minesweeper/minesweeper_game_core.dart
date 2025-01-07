import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_xp/helper/analytics_helper.dart';

import '../../util/my_print.dart';

/// mine represents an unrevealed mine,
/// empty represents an unrevealed empty square,
/// blank represents a revealed blank square that has no adjacent mines (i.e., above, below, left, right, and all 4 diagonals),
/// digit ('1' to '8') represents how many mines are adjacent to this revealed square, and
/// x represents a revealed mine.
enum MinesweeperCellState {
  /// mine represents an unrevealed mine
  mine,
  /// empty represents an unrevealed empty square
  empty,
  /// blank represents a revealed blank square that has no adjacent mines (i.e., above, below, left, right, and all 4 diagonals)
  blank,
  /// x represents a revealed mine
  x,
  /// digit ('1' to '8') represents how many mines are adjacent to this revealed square
  digit1,
  digit2,
  digit3,
  digit4,
  digit5,
  digit6,
  digit7,
  digit8;

  // bool get isDigit => name.startsWith('digit');

  bool get isDigit {
    return switch (this) {
      digit1 || digit2 || digit3 || digit4 || digit5 || digit6 || digit7 || digit8 => true,
      _ => false,
    };
  }

  String get value {
    assert(isDigit);
    if(!isDigit) throw Error();
    return name[name.length-1];
  }

  int get intValue {
    assert(isDigit);
    if(!isDigit) throw Error();
    return int.parse(name[name.length-1]);
  }

  static MinesweeperCellState neighborMinesToState(int mines) {
    assert(mines > 0 && mines <= 8);
    if(mines == 0) return MinesweeperCellState.blank;
    if(mines > 8) throw ArgumentError();
    return MinesweeperCellState.values.byName('digit$mines');
  }
}

class MinesweeperGameCore {

  MinesweeperGameCore({
    this.onWin,
    this.onLose,
  });

  VoidCallback? onLose;
  VoidCallback? onWin;

  bool analytics = false;
  Map<Point<int>, double>? analyticsMap;

  int col = 9;
  int row = 9;
  int mine = 10;


  List<List<MinesweeperCellState>>? boardState;

  Set<Point<int>> flagMap = {};

  bool get isNotHasBoardState => boardState == null;

  // bool get isGameOver {
  //   if(isNotHasBoardState) return false;
  //   return boardState!.expand((row) => row).any((state) => state == MinesweeperCellState.x);
  // }

  bool isGameOver = false;
  bool isGameWin = false;

  void setBoardSizeAndMines(int col, int row, int mine) {
    reset();
    this.col = col;
    this.row = row;
    this.mine = mine;
  }

  void init(int startX, int startY, int seed) {
    assert(col > 1 && row > 1 && col * row > 1);
    assert(mine < col * row);
    assert(startX >= 0 && startX < col && startY >= 0 && startY < row);

    final random = Random(seed);
    /// prevent dead in begin

    final boardState = this.boardState = List.generate(
      row,
      (y) => List.filled(col, MinesweeperCellState.empty),
    );

    final coordinates = Iterable.generate(col * row, (index) {
      final y = index ~/ col;
      final x = index % col;
      if(y == startY && x == startX) return null;
      return Point<int>(x, y);
    }).whereNotNull().toList();

    coordinates.shuffle(random);
    coordinates.take(mine).forEach((element) {
      boardState[element.y][element.x] = MinesweeperCellState.mine;
    });

    interactivePoint(Point<int>(startX, startY));
  }

  void debugPrintBoard() {
    if(!kDebugMode) return;
    final boardState = this.boardState;
    if(boardState == null) return;
    final state = boardState.map((row) {
      return row.map((state) {
        if(state.isDigit) {
          return state.name[state.name.length-1];
        }
        return state.name[0];
      }).join(', ');
    }).join('\n');

    myPrint(state);
  }

  void interactivePoint(Point<int> click) {
    assert(boardState != null);
    if(flagMap.contains(click)) return;
    boardState = _updateBoard(boardState!, click);
    refreshAnalytics();
    debugPrintBoard();
  }

  void toggleFlag(Point<int> click) {
    if(flagMap.contains(click)) {
      flagMap.remove(click);
    }
    else {
      flagMap.add(click);
    }
  }

  void toggleAnalytics() {
    analytics ^= true;
    refreshAnalytics();
  }

  void setAnalytics(bool value) {
    analytics = value;
    refreshAnalytics();
  }

  void refreshAnalytics() {
    if(analytics && boardState != null) {
      analyticsMap = analyticsBoardMines();
    }
    else {
      analyticsMap = null;
    }
  }

  void reset() {
    flagMap.clear();
    boardState = null;
    isGameOver = false;
    isGameWin = false;
    analyticsMap = null;
  }

  List<List<MinesweeperCellState>> _updateBoard(List<List<MinesweeperCellState>> board, Point<int> click) {

    final row = board.length;
    final col = board[0].length;
    final Point<int> start = click;


    if(board[start.y][start.x] == MinesweeperCellState.mine) {
      board[start.y][start.x] = MinesweeperCellState.x;
      isGameOver = true;
      onLose?.call();
      return board;
    }


    bool isValid(Point<int> position) {
      if(position.y < 0 || position.y >= row) return false;
      if(position.x < 0 || position.x >= col) return false;
      return true;
    }

    // List<Point<int>> getNeighbors(Point<int> position) {
    //   return [
    //     /// up
    //     position + const Point(0, -1),
    //     /// right
    //     position + const Point(1, 0),
    //     /// down
    //     position + const Point(0, 1),
    //     /// left
    //     position + const Point(-1, 0),
    //   ];
    // }


    bool isMine(Point<int> position) {
      if (board[position.y][position.x] case MinesweeperCellState.mine || MinesweeperCellState.x) {
        return true;
      }
      else {
        return false;
      }
    }

    int findMine(Point<int> position) {
      return getEightNeighbors(position).where(isValid).where(isMine).length;
    }


    // bfs
    List<Point<int>> queue = [start];


    while(queue.isNotEmpty) {
      List<Point<int>> newQueue = [];
      for(final point in queue) {
        if(!isValid(point)) continue;
        switch(board[point.y][point.x]) {
          case final state when state.isDigit:
            continue;
          case MinesweeperCellState.blank:
            continue;

          case MinesweeperCellState.empty:
            final mineCount = findMine(point);
            if(mineCount > 0) {
              board[point.y][point.x] = MinesweeperCellState.neighborMinesToState(mineCount);
            }
            else {
              board[point.y][point.x] = MinesweeperCellState.blank;
              flagMap.remove(point);
              newQueue.addAll(getEightNeighbors(point));
            }

          default:
            myPrint('error case: ${board[point.y][point.x].name}, at $point');
            continue;
        }
      }

      queue = newQueue;
    }

    if(board.expand((row) => row).none((state) => state == MinesweeperCellState.empty)) {
      isGameWin = true;
      flagMap.clear();
      flagMap = {
        for(int y=0; y<row; y++)
          for(int x=0; x<col; x++)
            if(board[y][x] == MinesweeperCellState.mine)
              Point<int>(x, y)
      };
      onWin?.call();
    }


    return board;
  }

  void revealAroundCell(Point<int> newPoint) {
    final boardState = this.boardState;
    if(boardState?[newPoint.y][newPoint.x] case final state? when state.isDigit) {
      boardState!;
      final row = boardState.length;
      final col = boardState[0].length;
      final mines = int.parse(state.value);

      bool isValid(Point<int> position) {
        if(position.y < 0 || position.y >= row) return false;
        if(position.x < 0 || position.x >= col) return false;
        return true;
      }

      bool isEmptyOrMine(Point<int> point) {
        final state = boardState[point.y][point.x];
        return state == MinesweeperCellState.empty || state == MinesweeperCellState.mine;
      }

      final map = getEightNeighbors(newPoint)
          .where(isValid)
          .where(isEmptyOrMine)
          .groupListsBy(flagMap.contains);

      myPrint(map);

      /// 當旗子數量等於數字顯示的數量時，
      /// 打開周圍的格子
      if(map[false] case [...final cells] when map[true]?.length == mines) {
        cells.forEach(interactivePoint);
      }

    }
  }

  List<Point<int>> getEightNeighbors(Point<int> position) {
    return [
      /// top
      position + const Point(0, -1),
      /// topRight
      position + const Point(1, -1),
      /// right
      position + const Point(1, 0),
      /// bottomRight
      position + const Point(1, 1),
      /// bottom
      position + const Point(0, 1),
      /// bottomLeft
      position + const Point(-1, 1),
      /// left
      position + const Point(-1, 0),
      /// topLeft
      position + const Point(-1, -1),
    ];
  }

  // b, b, 1, m, m, 1, b, b, b
  // b, 1, 2, 3, 2, 1, b, b, b
  // b, 1, m, 1, b, b, 1, 2, 2
  // b, 1, 1, 1, b, b, 1, m, m
  // b, b, b, b, b, b, 1, 2, 2
  // 1, 1, 1, b, b, b, b, b, b
  // e, m, 1, 1, 1, 1, 1, 1, 1
  // e, e, e, e, m, e, e, m, e
  // e, e, e, m, m, e, e, e, e

  Map<Point<int>, double> analyticsBoardMines() {
    final map = <Point<int>, double>{};
    final boardState = this.boardState!;

    final row = boardState.length;
    final col = boardState[0].length;

    /// 周圍尚未標示出狀態的數字
    final unSolveDigitPositions = <(Point<int>, int)>{};

    int totalMines = 0;

    for(int y=0; y<row; y++) {
      for(int x=0; x<col; x++) {
        final state = boardState[y][x];
        if(state case MinesweeperCellState.empty || MinesweeperCellState.mine || MinesweeperCellState.x) {
          if(state != MinesweeperCellState.empty) totalMines++;
          map[Point<int>(x, y)] = -1;
        }
        else if(state.isDigit) {
          unSolveDigitPositions.add((Point<int>(x, y), state.intValue));
        }
      }
    }

    myPrint(map);

    for(int j=0; j<2; j++) {
      for(int i=0; i<5 && unSolveDigitPositions.isNotEmpty; i++) {
        // myPrint(i);
        analyticsUnSolvePositions(unSolveDigitPositions, map);
      }

      advanceAnalytics(unSolveDigitPositions, map);
    }


    // advanceAnalytics();


    /// leftMines mine
    int leftMines = totalMines - map.values.where((element) => element == 100.0).length;
    int leftCells = map.values.where((element) => element == -1).length;
    map.updateAll((key, value) {
      if(value != -1) return value;
      if(leftMines == 0) return 0;
      return value;
      // return (1 / leftCells) * 100;
    });

    // myPrint(map.entries.map((e) => '${e.key}: ${e.value}').join('\n'));
    // myPrint(unSolveDigitPositions);

    return map;
  }

  void advanceAnalytics(Set<(Point<int>, int)> unSolveDigitPositions, Map<Point<int>, double> map) {



    Iterable<Point<int>> getPositionNeighborCells(Point<int> position) {
      return getEightNeighbors(position)
        .where(map.containsKey);
    }

    (Set<Point<int>>, int) getPositionLeftMineCells((Point<int>, int) unSolveDigitPosition) {
      final (position, mines) = unSolveDigitPosition;
      return getPositionNeighborCells(position)
          .fold<(Set<Point<int>>, int)>(
        ({}, mines),
            (previousValue, element) {
          var (leftPositions, newMines) = previousValue;
          switch(map[element]!) {
            case 100.0: newMines-=1;
            case 0.0: break;
            default: leftPositions.add(element);
          }
          return (leftPositions, newMines);
        },
      );
    }

    bool isProbablyOverlay(Point<int> a, Point<int> b) {
      return (a.x - b.x).abs() <= 2 && (a.y - b.y).abs() <= 2;
    }

    bool isOverlay(
      Point<int> a,
      Point<int> b, {
      Set<Point<int>>? neighborsFromA,
      Set<Point<int>>? neighborsFromB,
    }) {
      if(!isProbablyOverlay(a, b)) return false;

      switch((neighborsFromA, neighborsFromB)) {
        case (final target?, null):
          return getEightNeighbors(b).any(target.contains);
        case (null, final target?):
          return getEightNeighbors(a).any(target.contains);
        case _:
          neighborsFromA ??= getEightNeighbors(a).toSet();
          return getEightNeighbors(b).any(neighborsFromA.contains);
      }
    }

    bool isDirty = true;


    /// 先創建所有未解完數字格子的鄰居狀態
    final data = {
      for(final unSolveDigitPosition in unSolveDigitPositions)
        unSolveDigitPosition.$1: getPositionLeftMineCells(unSolveDigitPosition),
    };

    while(isDirty) {

      isDirty = false;

      for (final unSolveDigitPosition in unSolveDigitPositions) {
        final (position, _) = unSolveDigitPosition;
        final (neighbors, _) = data[unSolveDigitPosition.$1]!;

        final intersectPositions = unSolveDigitPositions
            .whereNot((element) => element == unSolveDigitPosition)
            .where((element) =>
            isOverlay(position, element.$1, neighborsFromA: data[position]!.$1, neighborsFromB: data[element.$1]!.$1));

        for (final neighbor in intersectPositions) {
          final (combineA, minesA) = data[unSolveDigitPosition.$1]!;
          final (combineB, minesB) = data[neighbor.$1]!;

          if(minesA == 0 || minesB == 0) continue;

          final alb = combineA.difference(combineB);
          final diff = minesA - minesB;
          if (diff == alb.length) {
            final bla = combineB.difference(combineA);
            for (final position in alb) {
              map[position] = 100.0;
            }

            for (final position in bla) {
              map[position] = 0.0;
            }

            if (alb.isNotEmpty || bla.isNotEmpty) {
              isDirty = true;
              combineA.removeAll(alb);
              combineB.removeAll(bla);
              data[unSolveDigitPosition.$1] = (combineA, minesA - alb.length);
            }
          }
          else if (combineA.containsAll(combineB)) {
            final newMines = minesA - minesB;
            myPrint('before: \n${data[unSolveDigitPosition.$1]}\n${data[neighbor.$1]}');

            if(newMines == 0) {
              for(final position in alb) {
                map[position] = 0.0;
              }
              combineA.clear();
              data[unSolveDigitPosition.$1] = (combineA, 0);
            }
            else if(newMines > 0 && combineA.isNotEmpty && combineB.isNotEmpty){
              isDirty = true;
              combineA.removeAll(combineB);
              data[unSolveDigitPosition.$1] = (combineA, newMines);
            }


            myPrint('after: \n${data[unSolveDigitPosition.$1]}\n${data[neighbor.$1]}');



          }
        }
      }

      unSolveDigitPositions.removeWhere((element) => data[element.$1]!.$1.isEmpty);
    }
  }

  void analyticsUnSolvePositions(
      Set<(Point<int>, int)> unSolveDigitPositions,
      Map<Point<int>, double> map,
  ) {
    final markNeedRemove = <(Point<int>, int)>[];

    for(final record in unSolveDigitPositions) {
      final (position, mines) = record;

      final neighbors = getEightNeighbors(position)
          .where(map.containsKey)
          .toList();

      final group = neighbors.groupListsBy((position) => map[position]!);


      if(neighbors.length == mines) {
        /// 如果周圍可用的格子數跟自己的數字相等代表全部100%是地雷
        for (final neighbor in neighbors) {
          map[neighbor] = 100.0;
        }
        markNeedRemove.add(record);
        continue;
      }

      if(group[100.0]?.length == mines) {
        /// 判斷周圍100.0的格子是否跟自己的數字相等
        /// 代表除了地雷其他都是安全的區域

        final excludeMinesNeighbors = group.entries
            .where((element) => element.key != 100.0)
            .expand((element) => element.value);

        for(final neighbor in excludeMinesNeighbors) {
          map[neighbor] = 0.0;
        }
        markNeedRemove.add(record);
        continue;
      }

      if(neighbors.length - (group[0.0]?.length ?? 0) == mines) {
        /// 如果周圍可用的格子數與確定為0.0的格子數相減
        /// 跟自己的數字相等代表除了0%的格子外全部100%是地雷
        final excludeSafeNeighbors = group.entries
            .where((element) => element.key != 0.0)
            .expand((element) => element.value);
        for (final neighbor in excludeSafeNeighbors) {
          map[neighbor] = 100.0;
        }
        markNeedRemove.add(record);
        continue;
      }

      if([...?group[100.0], ...?group[0.0]].length == neighbors.length) {
        /// 如果周圍格子完全確定是地雷或是安全區域的話
        /// 將這個格子去除再計算的必要
        markNeedRemove.add(record);
        continue;
      }

      final leftMines = mines - (group[100.0]?.length ?? 0);
      final leftNeighbors = group.entries
          .whereNot((element) => element.key == 100.0)
          .whereNot((element) => element.key == 0.0)
          .expand((element) => element.value)
          .toList();

      final leftUnknownCellsLength = leftNeighbors.length;

      if(leftNeighbors.isEmpty || leftMines == 0) {
        markNeedRemove.add(record);
        continue;
      }

      for(final position in leftNeighbors) {
        map[position] = (leftMines / leftUnknownCellsLength) * 100;
      }

    }

    unSolveDigitPositions.removeAll(markNeedRemove);
  }


}