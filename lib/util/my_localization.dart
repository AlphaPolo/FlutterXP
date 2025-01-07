import 'package:flutter/material.dart';
import 'package:flutter_xp/helper/platform_logic.dart';
import 'package:flutter_xp/main.dart';

class S {
  late final Locale locale;
  late final String language;
  // bool _isChinese() => locale.languageCode.toLowerCase() == 'zh';
  bool _isChinese() => language.toLowerCase().startsWith('zh');

  S.of(BuildContext context) {
    language = PlatformLogic.instance.getLocaleLanguage(context);
    // locale = Localizations.localeOf(context);
  }

  S() : this.of(navigatorKey.currentContext!);

  String get readmeContent {
    if(_isChinese()) {
      return _readmeChinese;
    }
    else {
      return _readmeEnglish;
    }
  }

  String get myProjects {
    if(_isChinese()) {
      return '我的作品集';
    }
    else {
      return 'My Portfolio';
    }
  }
}


const String _readmeChinese = '''
## Flutter XP 模擬頁面

### 已知問題

1. **Internet Explorer 上方的視窗或事件失效**

   在使用 `flutter_inappwebview` 插件時，遇到在 Internet Explorer 上方的視窗或事件失效的問題。
   
   (這也是導致在拉伸網頁視窗大小時會很奇怪的原因)
   
   詳細信息可以參考 [GitHub Issue #1035](https://github.com/pichillilorenzo/flutter_inappwebview/issues/1035)。

2. **快捷鍵（如 F1、F2）字體顯示問題**

   當`MenuEntry`使用快捷鍵（如 F1、F2）時，出現字體無法顯示的問題。錯誤信息如下：

   ```
   Could not find a set of Noto fonts to display all missing characters.
   Please add a font asset for the missing characters.
   See: https://flutter.dev/docs/cookbook/design/fonts
   ```

   這意味著缺少適當的字體資產來顯示所有缺失的字符。

### Inspiration

項目參考自 [ShizukuIchi's winXP](https://github.com/ShizukuIchi/winXP) ，請查看他的 GitHub 頁面了解更多信息。
''';

const String _readmeEnglish = '''
## Flutter XP Simulation Page

### Known Issues

1. **Windows or Events Above Internet Explorer Not Working**

   When using the `flutter_inappwebview` plugin, there are issues where windows or events above Internet Explorer do not function properly. 
   
   (This is also the reason why resizing the web page window behaves strangely.) 
   
   For detailed information, please refer to [GitHub Issue #1035](https://github.com/pichillilorenzo/flutter_inappwebview/issues/1035).

2. **Font Display Issues with Shortcut Keys (e.g., F1, F2)**

   When `MenuEntry` uses shortcut keys (such as F1, F2), there are font display issues. The error message is as follows:

   ```
   Could not find a set of Noto fonts to display all missing characters.
   Please add a font asset for the missing characters.
   See: https://flutter.dev/docs/cookbook/design/fonts
   ```

   This means that the necessary font assets to display all missing characters are missing.

### Inspiration

The project is inspired by [ShizukuIchi's winXP](https://github.com/ShizukuIchi/winXP). Please check his GitHub page for more information.
''';

//可以參考 [Flutter 官方文檔](https://flutter.dev/docs/cookbook/design/fonts) 添加必要的字體資源。