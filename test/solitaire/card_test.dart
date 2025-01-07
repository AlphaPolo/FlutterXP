

import 'package:flutter_xp/components/solitaire/solitaire_model.dart';

void main() {
    final cK = solitaireCardPrototype[12];

    /// 梅花Q
    final cQ = solitaireCardPrototype[11];
    
    /// 梅花J
    final cJ = solitaireCardPrototype[10];

  
    /// 方塊K 
    final dK = solitaireCardPrototype[25];
  
    /// 方塊Q 
    final dQ = solitaireCardPrototype[24];
  
  /// 方塊J
    final dJ = solitaireCardPrototype[23];


    print(cK.isLegalStack(cQ)); // false ck>cq
    print(cK.isLegalStack(cJ)); // false ck>cj
    print(cK.isLegalStack(dQ)); // true  ck>dq
    print(dK.isLegalStack(dQ)); // false dk>dq
    print(dK.isLegalStack(dJ)); // false dk>dj
    print(dQ.isLegalStack(dJ)); // false dq>dj
    print(dQ.isLegalStack(cK)); // false dq>ck
    print(dQ.isLegalStack(dK)); // false dq>dk
    print(dK.isLegalStack(cQ)); // true  dk>cq
    print(dQ.isLegalStack(cJ)); // true  dq>cj
    print('----------------');
    print(cK.isLegalPush(cQ)); // false  ck>cq
    print(cK.isLegalPush(cJ)); // false  ck>cj
    print(cK.isLegalPush(dQ)); // false  ck>dq
    print(dK.isLegalPush(dQ)); // false  dk>dq
    print(dK.isLegalPush(dJ)); // false  dk>dj
    print(dQ.isLegalPush(dJ)); // false  dq>dj
    print(dQ.isLegalPush(cK)); // false  dq>ck
    print(dQ.isLegalPush(dK)); // true   dq>dk
    print(dK.isLegalPush(cQ)); // false  dk>cq
    print(dQ.isLegalPush(cJ)); // false  dq>cj
  

}