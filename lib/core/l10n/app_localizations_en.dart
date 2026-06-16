// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Sesan Travel';

  @override
  String get all => 'All';

  @override
  String get featured => 'Featured';

  @override
  String get popularTours => 'Popular Tours';

  @override
  String get viewAll => 'View All';

  @override
  String tabUnderDevelopment(int index) {
    return 'Screen for tab $index is under development';
  }

  @override
  String get home => 'Home';

  @override
  String get tours => 'Tours';

  @override
  String get profile => 'Profile';

  @override
  String get discover => 'DISCOVER';

  @override
  String get amazingThings => 'AMAZING THINGS';

  @override
  String get heroSubtitle => 'Your journey, our memory';

  @override
  String get whereToGo => 'Where do you want to go?';

  @override
  String get dailyTours => 'Daily Tours';

  @override
  String get packageTours => 'Package Tours';

  @override
  String get privateTours => 'Private Tours';

  @override
  String get seeMore => 'See More';

  @override
  String get searchTours => 'Search tours...';

  @override
  String get explore => 'Explore';

  @override
  String get noToursFound => 'No tours found.';

  @override
  String errorOccurred(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get allTours => 'All Tours';
}
