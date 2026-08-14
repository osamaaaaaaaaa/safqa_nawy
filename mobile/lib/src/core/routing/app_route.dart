enum AppRoute {
  home('/'),
  contracts('/contracts'),
  newContract('/contracts/new'),
  wallet('/wallet');

  const AppRoute(this.path);

  final String path;
}
