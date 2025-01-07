Minesweeper
==

![https://firebasestorage.googleapis.com/v0/b/weiqiteach.appspot.com/o/projects%2FminesweeperDemo.gif?alt=media&token=95c6351b-c855-4e2b-bf48-7363ffbc1f7e](https://firebasestorage.googleapis.com/v0/b/weiqiteach.appspot.com/o/projects%2FminesweeperDemo.gif?alt=media&token=95c6351b-c855-4e2b-bf48-7363ffbc1f7e)

### 踩地雷

#### 遊戲說明
遊戲開始時，玩家可看到一堆整齊排列的空白方塊，方塊數可由玩家自行選擇。如果玩家點開方塊後沒有地雷，會有一個數字顯現其上，這個數字代表著鄰近方塊有多少顆地雷（數字至多為8），玩家須運用邏輯來推斷哪些方塊含或不含地雷。


#### feature

- **左右鍵組合鍵的邏輯**
  當按住左鍵與右鍵時會改變周圍格子的狀態，並且在數字格子放開時，如果周圍的旗幟數量與數字一致的話可以自動開啟周圍尚未被開啟的格子，但如果未揭露的格子有地雷依舊會遊戲失敗(代表玩家猜錯了地雷位置)。

- **盤面分析**
  簡易的盤面分析系統，使用的是盤面的資訊推測哪邊有地雷與安全區塊。


[揭露演算法參考連結](<https://leetcode.com/problems/minesweeper/description/>)