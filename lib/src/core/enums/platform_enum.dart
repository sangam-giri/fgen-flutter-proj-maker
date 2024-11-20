enum PlatformEnum {
  android(key: 'android'),
  ios(key: 'ios'),
  mac(key: 'mac'),
  linux(key: 'linux'),
  windows(key: 'windows');

  const PlatformEnum({required this.key});
  final String key;
}
