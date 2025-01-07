import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xp/components/solitaire/solitaire_constant.dart';
import 'package:flutter_xp/helper/analytics_helper.dart';
import 'package:flutter_xp/main.dart';
import 'package:flutter_xp/util/my_print.dart';

import 'solitaire_model.dart';

class SolitaireProvider extends ChangeNotifier {
  // 儲存遊戲歷史的堆疊
  Queue<SolitaireGameState> _history = Queue<SolitaireGameState>();

  List<SolitaireCard> _cards = [];
  List<List<SolitaireCard>> _piles = [];
  List<List<SolitaireCard>> _remainCards = [];
  List<List<SolitaireCard>> _suitDecks = [];

  int _currentIndex = -1;

  bool _isWin = false;

  int? _seed;

  bool get isWin => _isWin;
  int? get seed => _seed;

  List<SolitaireCard>? getRemainCardsAt() {
    if (_currentIndex < 0) {
      return null;
    }
    return _remainCards[_currentIndex];
  }

  List<SolitaireCard> getRunningRemainCards() {
    if(_currentIndex < 0) {
      return [];
    }
    return _remainCards.sublist(0, _currentIndex)
      .expand((element) => element)
      .toList();
  }

  bool get isLastRemainCardIndex => _currentIndex == _remainCards.length -1;

  List<SolitaireCard> getPileAt(int index) {
    return _piles[index];
  }

  List<SolitaireCard> getSuitDeckAt(int index) {
    return _suitDecks[index];
  }

  SolitaireProvider() {
    reset();
    _precache();
  }

  void _precache() {
    for(final card in solitaireCardPrototype) {
      precacheImage(AssetImage(card.asset), navigatorKey.currentContext!);
    }
  }

  void reset([int? seed]) {
    _isWin = false;
    _clearHistory();
    _initialAllCards(seed);
    _initialPiles();
    _initialSuitDecks();
    _calcRemainCard();
    notifyListeners();
  }

  void redraw() {
    _calcRemainCard();
  }

  void _clearHistory() {
    _history = Queue();
  }

  void _initialAllCards(int? seed) {
    _currentIndex = -1;
    _cards = [
      for (final suit in Suit.values)
        for (final rank in CardRank.values)
          SolitaireCard(
            rank: rank,
            suit: suit,
            asset: 'assets/images/solitaire/${rank.name}${suit.name}.png',
            isOpen: true,
          ),
    ];
    _seed = seed ?? Random().nextInt(1000000);
    myPrint('seed: $_seed');
    _cards.shuffle(Random(_seed));
    // _cards.shuffle(Random(321888));
    // 322613
    // 57022
  }

  void _initialPiles() {
    _piles = [
      for (int i = 0; i < 7; i++)
        [
          for (int j = 0; j <= i; j++) _getLastCard(j == i),
        ],
    ];
  }

  void _initialSuitDecks() {
    _suitDecks = List.generate(4, (index) => []);
  }

  void _calcRemainCard() {
    _remainCards = _cards.slices(3).toList();
    // _remainCards = [
    //   for (int i=0; i<8; i++)
    //   [
    //     for(int j=0 ;j<3 ;j++)
    //     _cards.removeLast(),
    //   ],
    // ];
  }

  SolitaireCard _getLastCard(bool isLast) {
    SolitaireCard card = _cards.removeLast();
    if (!isLast) {
      card = card.copyWith(
        isOpen: false,
      );
    }
    return card;
  }

  void pushCardsOfPile(int pushIndex, List<SolitaireCard> cards) {
    assert(cards.isNotEmpty, '不可沒移動卡片呼叫此function');
    final card = cards.first;
    saveState();
    /// SuitDeck to Pile
    if(listIndexFrom(_suitDecks, card) case final index when index > -1) {
      _removeCardFrom(_suitDecks, index, cards);
      _piles[pushIndex] = [..._piles[pushIndex], ...cards];
    }
    /// RemainCard to Pile
    else if (listIndexFrom(_remainCards, card) case final index when index > -1) {
      _removeCardFrom(_remainCards, index, cards);
      _piles[pushIndex] = [..._piles[pushIndex], ...cards];
      _cards = _cards.whereNot((c) => c == card).toList();
    } 
    /// Pile to Pile
    else if (listIndexFrom(_piles, card) case final index when index > -1) {
      _removeCardFrom(_piles, index, cards);
      _piles[pushIndex] = [..._piles[pushIndex], ...cards];
      _checkNeedOpenCard(index);
    }
    else {
      myPrint('Solitaire Error: 請檢查 pushCardsOfPile');
    }

    notifyListeners();
  }

  void pushCardOfDeck(int pushIndex, SolitaireCard card) {
     
    saveState();
    /// SuitDeck to SuitDeck
    if(listIndexFrom(_suitDecks, card) case final index when index > -1) {
      _removeCardFrom(_suitDecks, index, [card]);
      _suitDecks[pushIndex] = [..._suitDecks[pushIndex], card];
    }
    /// RemainCards to SuitDeck
    else if (listIndexFrom(_remainCards, card) case final index when index > -1) {
      _removeCardFrom(_remainCards, index, [card]);
      _suitDecks[pushIndex] = [..._suitDecks[pushIndex], card];
      _cards = _cards.whereNot((c) => c == card).toList();
    } 
    /// Pile to SuitDeck
    else if (listIndexFrom(_piles, card) case final index when index > -1) {
      _removeCardFrom(_piles, index, [card]);
      _suitDecks[pushIndex] = [..._suitDecks[pushIndex], card];
      _checkNeedOpenCard(index);
    }
    else {
      myPrint('Solitaire Error: 請檢查 pushCardOfDeck');
    }
    _checkWin();
    notifyListeners();
  }

  void _removeCardFrom(List<List<SolitaireCard>> deck, int index, List<SolitaireCard> cards) {
    assert(cards.isNotEmpty, '要移除的卡片不可為空');
    deck[index] = deck[index]
      .whereNot((element) => cards.contains(element))
      .toList();
  }

  void _checkNeedOpenCard(int pileIndex) {
    if (_piles[pileIndex].lastOrNull case SolitaireCard(isOpen: false)) {
      final openCard = _piles[pileIndex].removeLast().copyWith(
            isOpen: true,
          );
      _piles[pileIndex].add(openCard);
    }
  }

  int listIndexFrom(List<List<SolitaireCard>> decks, SolitaireCard target) {
    return decks.indexWhere((deck) => deck.contains(target));
  }

  List<SolitaireCard>? getCardsFromPile(
      List<SolitaireCard> pile, SolitaireCard middle) {
    assert(pile.contains(middle), 'pile根本沒有${middle.rank}這張牌');

    final under = pile.splitBefore((element) => element == middle).last;

    SolitaireCard current = under.first;
    for (final next in under.skip(1)) {
      // print("1234: ${next.rank}");
      if (!current.isLegalStack(next)) {
        return null;
      }

      current = next;
    }

    return under;
  }

  void nextRemainIndex() {
    saveState();
    _currentIndex++;
    // print(currentIndex);
    if (_currentIndex >= _remainCards.length) {
      _currentIndex = -1;
      redraw();
    }
    notifyListeners();
  }

  void cheat() {

    _clearHistory();
    _currentIndex = -1;
    _cards = [];
    _remainCards = [];
    _piles = [
      for(int i=0; i<7; i++) [],
    ];
    _suitDecks = [
      for (final suit in Suit.values)
        [
          for (final rank in CardRank.values)
            SolitaireCard(
              rank: rank,
              suit: suit,
              asset: 'assets/images/solitaire/${rank.name}${suit.name}.png',
              isOpen: true,
            ),
        ]
    ];

    _checkWin(isCheat: true);
    notifyListeners();
  }
  
  void _checkWin({bool isCheat = false}) {

    final sum = _suitDecks.map((e) => e.length).sum;
    myPrint('current suitDeck sum: $sum');
    /// 52 is win
    if(sum == 52) {
      myPrint('isWin');
      _isWin = true;
      _clearHistory();

      if(!isCheat) AnalyticsHelper.logSolitaireWin('$seed');
    }

  }

  // 初始化，或是任何狀態變更時都要呼叫
  void saveState() {
    final state = SolitaireGameState(
      cards: [..._cards],
      piles: _piles.map((pile) => [...pile]).toList(),
      remainCards: _remainCards.map((deck) => [...deck]).toList(),
      suitDecks: _suitDecks.map((deck) => [...deck]).toList(),
      currentIndex: _currentIndex,
    );
    _history.add(state);

    if(SolitaireConstant.recordMaxSteps != -1) {
      while (_history.length > SolitaireConstant.recordMaxSteps) {
        _history.removeFirst();
      }
    }
  }

  // Undo 功能
  void undo() {
    if (_history.isNotEmpty) {
      final lastState = _history.removeLast();
      _restoreState(lastState);
      notifyListeners();
    }
  }

  // 從儲存的狀態中恢復
  void _restoreState(SolitaireGameState state) {
    _cards = state.cards;
    _piles = state.piles;
    _remainCards = state.remainCards;
    _suitDecks = state.suitDecks;
    _currentIndex = state.currentIndex;
  }

}


// 儲存遊戲狀態的資料結構
class SolitaireGameState {
  final List<SolitaireCard> cards;
  final List<List<SolitaireCard>> piles;
  final List<List<SolitaireCard>> remainCards;
  final List<List<SolitaireCard>> suitDecks;
  final int currentIndex;

  SolitaireGameState({
    required this.cards,
    required this.piles,
    required this.remainCards,
    required this.suitDecks,
    required this.currentIndex,
  });
}