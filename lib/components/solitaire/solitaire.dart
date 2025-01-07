import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xp/components/solitaire/solitaire_constant.dart';
import 'package:flutter_xp/components/solitaire/solitaire_provider.dart';
import 'package:flutter_xp/model/activity/solitaire_content.dart';
import 'package:flutter_xp/util/my_print.dart';
import 'package:provider/provider.dart';

import '../../constant/window_constant.dart';
import '../../model/activity/window_activity.dart';
import 'solitaire_model.dart';
import 'solitaire_win_table.dart';

class SolitaireScreen extends StatefulWidget {
  const SolitaireScreen({super.key});

  static WindowActivity createActivity() {
    return WindowActivity(
      activityId: WindowConstant.idGenerator.nextId().toString(),
      title: 'Solitaire',
      iconAsset: 'assets/images/icon_solitaire_32.png',
      content: const SolitaireScreen(),
      resizeable: false,
      rect: WindowConstant.defaultOffset & const Size(760, 600),
      // sizeStrategy: WindowSizeStrategy.wrapContent,
      menuGetter: getSolitaireMenu,
    );
  }


  @override
  State<SolitaireScreen> createState() => _SolitaireScreenState();
}

class _SolitaireScreenState extends State<SolitaireScreen> {

  final SolitaireProvider viewModel = SolitaireProvider();

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activity = context.read<WindowActivity>();
      activity.customAction = onCustomAction;
      activity.title.value = 'Solitaire #${viewModel.seed}';
    });

    super.initState();
  }

  void onCustomAction(action) {
    switch(action) {
      case 'NewGame':
        viewModel.reset();
        context.read<WindowActivity>().title.value = 'Solitaire #${viewModel.seed}';
      case 'Undo':
        viewModel.undo();
      case 'Cheat':
        viewModel.cheat();
      case 'Specify':
        showInputSeedDialog();
    }
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Selector<SolitaireProvider, bool>(
        selector: (context, provider) => provider.isWin,
        builder: (context, isWin, _) {
          myPrint('rebuild SolitaireScreen');
          if(isWin) {
            return buildWin();
          }
          else {
            return buildGameTable();
          }
        },
      ),
    );
  }

  Widget buildGameTable() {
    return Stack(
      children: [
        Container(
          color: const Color(0xFFC0C0C0),
          child: Column(
            children: [
              Container(
                color: const Color.fromRGBO(0, 128, 1, 1),
                height: 130,
                child: buildTopRow(),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  color: const Color.fromRGBO(0, 128, 1, 1),
                  child: buildBottomRow(),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: Builder(builder: (context) {
            return IconButton.filledTonal(
              onPressed: () {
                viewModel.undo();
              },
              icon: const Icon(Icons.undo, color: Colors.black),
            );
          }),
        ),
      ],
    );
  }

  Widget buildPile(int index) {
    return Selector<SolitaireProvider, List<SolitaireCard>>(
      selector: (context, provider) => provider.getPileAt(index),
      shouldRebuild: (pre, next) => pre != next,
      builder: (context, pile, _) {
        myPrint(pile);
        final length = pile.length;
        final indexOfFirstCardOfOpen = pile.indexWhere((card) => card.isOpen);
        const notOpenOffset = 6.0;
        const isOpenOffset = 25.0;
        double getOffsetOfY(int index) {
          if (index < indexOfFirstCardOfOpen) {
            return index * notOpenOffset;
          }
          return indexOfFirstCardOfOpen * notOpenOffset +
              (index - indexOfFirstCardOfOpen) * isOpenOffset;
        }

        return SizedBox(
          width: SolitaireConstant.cardSize.width,
          height: double.infinity,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              for (int i = 0; i < length; i++)
                Positioned(
                  // top: i * 25,
                  top: getOffsetOfY(i),
                  child: CardWidget(
                    key: ObjectKey(pile[i]),
                    card: pile[i],
                    pile: pile,
                  ),
                ),
              Positioned.fill(
                child: DragTarget<List<SolitaireCard>>(
                  onWillAcceptWithDetails: (data) {
                    if (data.data.isEmpty) {
                      return false;
                    }
                    final headCard = data.data.first;
                    final lastCard = pile.lastOrNull;
                    if (lastCard == null) {
                      return headCard.rank == CardRank.k;
                    }
                    return lastCard.isLegalStack(headCard);
                  },
                  onAcceptWithDetails: (details) {
                    context
                        .read<SolitaireProvider>()
                        .pushCardsOfPile(index, details.data);
                  },
                  builder: (context, candidateData, rejectedData) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      },
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
        Selector<SolitaireProvider, bool>(
          selector: (context, provider) => provider.isLastRemainCardIndex,
          builder: (context, isLast, child) {
            if (isLast) {
              child = Container(
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                width: SolitaireConstant.cardSize.width,
                height: SolitaireConstant.cardSize.height,
                decoration: decoration,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(
                        width: 8,
                        color: Color.fromARGB(255, 40, 255, 51),
                      ),
                    ),
                  ),
                ),
              );
            }
            return InkWell(
              onTap: () {
                context.read<SolitaireProvider>().nextRemainIndex();
              },
              child: child,
            );
          },
          child: const BackCard(),
        ),

        /// 發牌顯示位置
        buildRemainCards(),

        /// 留空位置
        SizedBox(
          width: SolitaireConstant.cardSize.width,
          height: SolitaireConstant.cardSize.height,
          // color: Colors.black,
        ),

        /// 四格收集區
        for (int i = 0; i < 4; i++)
          buildSuitDeck(decoration, i),
      ],
    );
  }

  Widget buildSuitDeck(BoxDecoration decoration, int index) {
    return Selector<SolitaireProvider, List<SolitaireCard>>(
      selector: (context, provider) => provider.getSuitDeckAt(index),
      shouldRebuild: (pre, next) => pre != next,
      builder: (context, suitDeck, _) {
        return DragTarget<List<SolitaireCard>>(
          onWillAcceptWithDetails: (data) {
            if (data.data.isEmpty) {
              return false;
            }
            if (data.data.length > 1) {
              return false;
            }
            final card = data.data.first;
            final lastCard = suitDeck.lastOrNull;
            if (lastCard == null) {
              return card.rank == CardRank.a;
            }
            return lastCard.isLegalPush(card);
          },
          onAcceptWithDetails: (details) {
            context
                .read<SolitaireProvider>()
                // .pushCardOfPile(index, details.data);
                .pushCardOfDeck(index, details.data.first);
          },
          builder: (context, candidateData, rejectedData) {

            final card = suitDeck.lastOrNull;
            Widget? child;
            if (card != null) {
              child = CardWidget(card: card);
            }
            return Container(
              width: SolitaireConstant.cardSize.width,
              height: SolitaireConstant.cardSize.height,
              decoration: decoration,
              child: child,
            );
          },
        );
      },
    );
  }

  Widget buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (int i = 0; i < 7; i++) buildPile(i)],
    );
  }

  Widget buildRemainCards() {
    return Selector<SolitaireProvider, (List<SolitaireCard>?, List<SolitaireCard>)>(
      selector: (context, provider) =>
          (provider.getRemainCardsAt(), provider.getRunningRemainCards()),
      builder: (context, record, _) {
        final (remainCards, runningCards) = record;
        if (remainCards == null || remainCards.isEmpty) {
          final runningLastCard = runningCards.lastOrNull;

          return Stack(
            children: [
              SizedBox(
                width: SolitaireConstant.cardSize.width,
                height: SolitaireConstant.cardSize.height,
              ),
              if (runningLastCard != null) CardWidget(card: runningLastCard),
            ],
          );
        }

        final length = remainCards.length;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            for (int i = 0; i < length - 1; i++)
              Positioned(
                left: (i - (length - 1)) * -15,
                child: IgnorePointer(
                  child: CardWidget(card: remainCards[i]),
                ),
              ),
            CardWidget(card: remainCards.last),
          ],
        );
      },
    );
  }

  Widget buildWin() {
    return Builder(
      builder: (context) {
        return SolitaireWinTable(
          cards: [
            context.read<SolitaireProvider>().getSuitDeckAt(0),
            context.read<SolitaireProvider>().getSuitDeckAt(1),
            context.read<SolitaireProvider>().getSuitDeckAt(2),
            context.read<SolitaireProvider>().getSuitDeckAt(3),
          ],
        );
      }
    );
  }

  Future<void> showInputSeedDialog() async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      builder: (context) {
        return Dialog(
          child: ListenableProvider(
            create: (BuildContext context) => TextEditingController(),
            builder: (context, _) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('For Debug'),
                    const SizedBox(height: 8.0),
                    const Text('請輸入牌局'),
                    const SizedBox(height: 16.0),
                    Stack(
                      children: [
                        const Opacity(
                          opacity: 0,
                          child: IgnorePointer(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              child: Text('000000'),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(
                                6,
                                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              ),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: context.read<TextEditingController>(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(context.read<TextEditingController>().text);
                      },
                      child: const Text('送出'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if(!mounted) {
      return;
    }

    if(result == null) {
      return;
    }

    final seed = int.tryParse(result);

    if(seed == null) {
      return;
    }


    viewModel.reset(seed);
    context.read<WindowActivity>().title.value = 'Solitaire #${viewModel.seed}';

  }
}

class CardWidget extends StatelessWidget {
  final List<SolitaireCard>? pile;
  final SolitaireCard card;
  // final List<SolitaireCard>? Function() pileGetter;

  const CardWidget({
    super.key,
    required this.card,
    this.pile,
    // required this.pileGetter,
  });

  @override
  Widget build(BuildContext context) {
    // print("${card.rank}, ${pile?.map((e) => e.rank)}",);

    if (!card.isOpen) {
      return const BackCard();
    }

    return Draggable<List<SolitaireCard>>(
      data: pile == null
          ? [card]
          : context.read<SolitaireProvider>().getCardsFromPile(pile!, card),
      childWhenDragging: FadeTransition(
        opacity: const AlwaysStoppedAnimation(0.85),
        child: buildCard(card),
      ),
      feedback: pile == null ? buildCard(card) :  buildColumnCard(context, pile!),
      child: buildCard(card),
    );
  }

  Widget buildColumnCard(BuildContext context, List<SolitaireCard> cards) {
    final children = context.read<SolitaireProvider>()
        .getCardsFromPile(cards, card);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: SolitaireConstant.cardSize.width,
          height: SolitaireConstant.cardSize.height,
        ),
        ...?children?.mapIndexed((index, card) {
          return Positioned(
            top: index * 25,
            child: buildCard(card),
          );
        }).toList(),
      ],
    );
  }

  Widget buildCard(SolitaireCard card) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        border: Border.fromBorderSide(
          // BorderSide(width: 0.5, color: Colors.black),
          BorderSide(width: 0.3, color: Color(0xAA333333)),
        ),
        color: Colors.blueAccent,
        boxShadow: [
          BoxShadow(
            color: Color(0xAA333333),
            spreadRadius: 0.5,
            blurRadius: 0.5,
            // offset: Offset(1, 1),
          ),
        ],
      ),


      // decoration: const BoxDecoration(
      //   borderRadius: BorderRadius.all(Radius.circular(3)),
      //   border: Border.fromBorderSide(
      //     BorderSide(width: 0.5, color: Colors.black),
      //   ),
      // ),
      width: SolitaireConstant.cardSize.width,
      height: SolitaireConstant.cardSize.height,
      child: Image.asset(card.asset),
    );
  }
}

class BackCard extends StatelessWidget {
  const BackCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        border: Border.fromBorderSide(
          // BorderSide(width: 0.5, color: Colors.black),
          BorderSide(width: 0.3, color: Color(0xAA333333)),
        ),
        color: Colors.blueAccent,
        boxShadow: [
          BoxShadow(
            color: Color(0xAA333333),
            spreadRadius: 0.5,
            blurRadius: 0.5,
            // offset: Offset(1, 1),
          ),
        ],
        image: DecorationImage(
          image: AssetImage('assets/images/solitaire/beach.png'),
          fit: BoxFit.cover,
        ),
      ),
      width: SolitaireConstant.cardSize.width,
      height: SolitaireConstant.cardSize.height,
    );
  }
}


class RedrawCard extends StatelessWidget {
  const RedrawCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      width: SolitaireConstant.cardSize.width,
      height: SolitaireConstant.cardSize.height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        border: Border.fromBorderSide(
          BorderSide(width: 1, color: Colors.green),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(
              width: 8,
              color: Color.fromARGB(255, 40, 255, 51),
            ),
          ),
        ),
      ),
    );
  }
}





////不成順序的pile 移動後後牌無法移動
////成順序pile 從中間拉後 上列牌無法移動(偵測錯誤)