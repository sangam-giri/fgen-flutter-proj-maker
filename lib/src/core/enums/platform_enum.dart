enum PlatformEnum {
  android(key: 'android'),
  iOS(key: 'ios'),
  macOS(key: 'mac'),
  linux(key: 'linux'),
  windows(key: 'windows');

  const PlatformEnum({required this.key});
  final String key;
}
