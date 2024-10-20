enum Browsers {
  adsBotGoogle('AdsBot-Google'),
  androidBrowser('Android Browser'),
  appleBot('Applebot'),
  baiduSpider('Baiduspider'),
  bingBot('bingbot'),
  blackberryBrowser('BlackBerry Browser'),
  browser('Browser'),
  bunjalloo('Bunjalloo'),
  camino('Camino'),
  chatGptUser('ChatGPT-User'),
  chrome('Chrome'),
  curl('curl'),
  edge('Edge'),
  facebookExternalHit('facebookexternalhit'),
  feedValidator('FeedValidator'),
  firefox('Firefox'),
  googleBot('Googlebot'),
  googleBotImage('Googlebot-Image'),
  googleBotVideo('Googlebot-Video'),
  gptBot('GPTBot'),
  headlessChrome('HeadlessChrome'),
  ieMobile('IEMobile'),
  iMessageBot('iMessageBot'),
  kindle('Kindle'),
  lynx('Lynx'),
  mastodon('Mastodon'),
  midori('Midori'),
  miuiBrowser('MiuiBrowser'),
  msie('MSIE'),
  msnbotMedia('msnbot-media'),
  netFront('NetFront'),
  nintendoBrowser('NintendoBrowser'),
  oaiSearchBot('OAI-Search-Bot'),
  oculusBrowser('OculusBrowser'),
  opera('Opera'),
  puffin('Puffin'),
  safari('Safari'),
  sailfishBrowser('SailfishBrowser'),
  samsungBrowser('SamsungBrowser'),
  silk('Silk'),
  slackBot('Slackbot'),
  telegramBot('TelegramBot'),
  tizenBrowser('TizenBrowser'),
  twitterBot('Twitterbot'),
  ucBrowser('UC Browser'),
  valveSteamTenfoot('Valve Steam Tenfoot'),
  vivaldi('Vivaldi'),
  wget('Wget'),
  wordpress('WordPress'),
  yandex('Yandex'),
  yandexBot('YandexBot');

  const Browsers(this.value);

  final String value;
}

enum Platforms {
  mac('Macintosh'),
  chrome('Chrome OS'),
  linux('Linux'),
  windows('Windows'),
  android('Android'),
  blackBerry('BlackBerry'),
  freeBSD('FreeBSD'),
  iPad('iPad'),
  iPhone('iPhone'),
  iPod('iPod'),
  kindle('Kindle'),
  kindleFire('Kindle Fire'),
  netBSD('NetBSD'),
  newNintend3DS('New Nintendo 3DS'),
  nintendo3DS('Nintendo 3DS'),
  nintendoDS('Nintendo DS'),
  nintendoSwitch('Nintendo Switch'),
  nintendoWii('Nintendo Wii'),
  nintendoWiiU('Nintendo WiiU'),
  openBSD('OpenBSD'),
  playBook('PlayBook'),
  playStation3('PlayStation 3'),
  playStation4('PlayStation 4'),
  playStation5('PlayStation 5'),
  playStationVita('PlayStation Vita'),
  sailfish('Sailfish'),
  symbian('Symbian'),
  tizen('Tizen'),
  windowsPhone('Windows Phone'),
  xbox('Xbox'),
  xboxOne('Xbox One');

  const Platforms(this.value);

  final String value;
}

class UserAgent {
  const UserAgent(this.name);

  final String name;

  Browsers get browser {
    return Browsers.values.firstWhere((browser) => name.contains(browser.value), orElse: () => Browsers.browser);
  }

  Platforms get platform {
    return Platforms.values.firstWhere((platform) => name.contains(platform.value), orElse: () => Platforms.mac);
  }
}
