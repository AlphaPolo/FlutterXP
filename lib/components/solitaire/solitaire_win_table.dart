import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../util/my_print.dart';
import 'falling_bounce_card.dart';
import 'solitaire.dart';
import 'solitaire_constant.dart';
import 'solitaire_model.dart';

class SolitaireWinTable extends StatefulWidget {
  const SolitaireWinTable({
    super.key,
    required this.cards,
  });

  final List<List<SolitaireCard>> cards;

  @override
  State<SolitaireWinTable> createState() => _SolitaireWinTableState();
}

class _SolitaireWinTableState extends State<SolitaireWinTable> {

  // List<List<SolitaireCard>> cards = cardPrototype
  //     .sorted(SolitaireCard.suitComparator.then(SolitaireCard.rankComparator))
  //     .slices(13)
  //     .toList();

  late List<List<SolitaireCard>> cards = [
    ...widget.cards.map((deck) => [...deck]),
  ];

  late final Map<SolitaireCard, GlobalKey> map = {
    for(final card in cards.expand((deck) => deck))
      card: GlobalKey(),
  };

  final GlobalKey tableKey = GlobalKey();

  (SolitaireCard, Rect)? currentFallingCard;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //     popNextCard();
    // });

    Future.delayed(1000.ms).then((_) => popNextCard());


  }

  void popNextCard() {
    final next = nextCard();
    myPrint('next: ${next?.rank}, ${next?.suit}');
    if(next == null) {
      setState(() {
        currentFallingCard = null;
      });
      return;
    }
    findInitialRect(next);
  }

  SolitaireCard? nextCard() {
    return maxBy(
      cards.map((deck) => deck.lastOrNull).whereNotNull(),
          (card) => card,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color.fromRGBO(0, 128, 1, 1),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            key: tableKey,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 130,
                    child: buildTopRow(),
                  ),
                ],
              ),
              if (currentFallingCard case (final card, final rect))
                FallingBounceCard(
                  key: map[card],
                  initialRect: rect,
                  onLeave: () => popNextCard(),
                  tableSize: constraints.biggest,
                  child: CardWidget(card: card),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget buildTopRow() {
    const decoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(3)),
      border: Border.fromBorderSide(
        BorderSide(width: 1, color: Colors.green),
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const RedrawCard(),

        /// 發牌顯示位置
        SizedBox(
          width: SolitaireConstant.cardSize.width,
          height: SolitaireConstant.cardSize.height,
        ),

        /// 留空位置
        SizedBox(
          width: SolitaireConstant.cardSize.width,
          height: SolitaireConstant.cardSize.height,
        ),

        /// 四格收集區
        for (int i = 0; i < 4; i++)
          buildSuitDeck(decoration, i),
      ],
    );
  }

  Widget buildSuitDeck(BoxDecoration decoration, int i) {
    final card = cards[i].lastOrNull;

    if(card == null) {
      return Container(
        width: SolitaireConstant.cardSize.width,
        height: SolitaireConstant.cardSize.height,
        decoration: decoration,
      );
    }
    final key = map[card]!;

    return IgnorePointer(
      key: key,
      child: CardWidget(
        card: card,
      ),
    );
  }

  void findInitialRect(SolitaireCard card) {

    final stackRenderBox = tableKey.currentContext?.findRenderObject() as RenderBox?;
    final cardRenderBox = map[card]?.currentContext?.findRenderObject() as RenderBox?;

    myPrint('cardRenderBox: $cardRenderBox');
    if (stackRenderBox == null || cardRenderBox == null) {
      return;
    }

    // 取得 CardWidget 的 global offset 並轉換為相對於 Stack 的 offset
    final globalOffset = cardRenderBox.localToGlobal(Offset.zero);
    final localOffset = stackRenderBox.globalToLocal(globalOffset);

    myPrint(localOffset);

    setState(() {
      cards = [
        ...cards.map((deck) => deck.whereNot((c) => c == card)
            .toList()),
      ];
      currentFallingCard = (card, localOffset & SolitaireConstant.cardSize);

      // cards.firstWhereOrNull((deck) => deck.contains(card))?.remove(card);
    });
  }

}