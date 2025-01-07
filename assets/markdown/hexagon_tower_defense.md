Hexagon Tower Defense
==

![https://firebasestorage.googleapis.com/v0/b/weiqiteach.appspot.com/o/projects%2FhexagonDefenseDemo.gif?alt=media&token=58a6a98e-d26a-4765-97ee-e8ad2f0c421f](https://firebasestorage.googleapis.com/v0/b/weiqiteach.appspot.com/o/projects%2FhexagonDefenseDemo.gif?alt=media&token=58a6a98e-d26a-4765-97ee-e8ad2f0c421f)

#### 遊戲說明
一開始時可以建造下方列表的建築物，其中障礙物會一開始免費贈送3個，其他建築物皆消耗相應的金幣來建造。蓋建築物可以任意蓋在主堡(綠色區塊)、敵人入口(紅色區塊)以外的任何地方，但有個限制就是不能夠完全堵死入口到主堡的路線。


#### feature

- **作弊模式**
  可以無視資源建造建築。
  
- **規劃路線**
  此機制使用BFS從主堡的位置擴散計算，將所有的frontier指向可以通往主堡的位置，計算整個盤面，每次蓋建築計算一次，因此可以讓每個敵人都使用烘焙好的路徑行走

演算法參考自
[https://www.redblobgames.com/pathfinding/tower-defense/](<https://www.redblobgames.com/pathfinding/tower-defense/>)