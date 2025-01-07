import 'package:collection/collection.dart';

enum Suit {
  club('C'),
  diamond('D'),
  heart('H'),
  spade('S');

  final String name;

  const Suit(this.name);

  bool get isRed => this == diamond || this == heart;

  bool get isBlack => !isRed;
}

enum CardRank {
  a(1, 'A'),
  two(2, '2'),
  three(3, '3'),
  four(4, '4'),
  five(5, '5'),
  six(6, '6'),
  seven(7, '7'),
  eight(8, '8'),
  nine(9, '9'),
  ten(10, 'T'),
  j(11, 'J'),
  q(12, 'Q'),
  k(13, 'K');

  final int value;
  final String name;

  const CardRank(this.value, this.name);

  factory CardRank.fromValue(int value) {
    assert(value >= 1, '沒有更小的值');
    assert(value <= 13, '沒有更大的值');
    return CardRank.values[value - 1];
  }
}

class SolitaireCard implements Comparable<SolitaireCard> {
  final CardRank rank;
  final Suit suit;
  final String asset;
  final bool isOpen;

  const SolitaireCard({
    required this.rank,
    required this.suit,
    required this.asset,
    required this.isOpen,
  });

  /// 判斷傳入的牌是否可以排在此牌下方
  bool isLegalStack(SolitaireCard card) {
    final acceptValue = rank.value - 1;

    if (suit.isRed == card.suit.isRed) {
      return false;
    }

    if (rank.value == 1) {
      return false;
    }

    if (card.rank.value != acceptValue) {
      return false;
    }

    return true;
  }

  /// 判斷傳入的牌是否可以收集在上方
  bool isLegalPush(SolitaireCard card) {
    final acceptValue = rank.value + 1;

    if (card.suit != suit) {
      return false;
    }
    if (card.rank.value != acceptValue) {
      return false;
    }
    return true;
  }

  SolitaireCard copyWith({
    CardRank? rank,
    Suit? suit,
    String? asset,
    bool? isOpen,
  }) {
    return SolitaireCard(
      rank: rank ?? this.rank,
      suit: suit ?? this.suit,
      asset: asset ?? this.asset,
      isOpen: isOpen ?? this.isOpen,
    );
  }

  @override
  int compareTo(SolitaireCard other) {
    return rankComparator.then(suitComparator)
        .call(this, other);
  }


  static Comparator<SolitaireCard> get suitComparator =>
          (a, b) => a.suit.index.compareTo(b.suit.index);

  static Comparator<SolitaireCard> get rankComparator =>
          (a, b) => a.rank.index.compareTo(b.rank.index);
}

final List<SolitaireCard> solitaireCardPrototype = [
  for (final suit in Suit.values)
    for (final rank in CardRank.values)
      SolitaireCard(
        rank: rank,
        suit: suit,
        asset: 'assets/images/solitaire/${rank.name}${suit.name}.png',
        isOpen: true,
      ),
];