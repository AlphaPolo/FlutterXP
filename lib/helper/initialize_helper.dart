abstract class PlatformInit {
  Future<void> init();
}

PlatformInit createStrategyInit() => throw UnsupportedError(
  'Cannot create a client without dart:html or dart:io',
);