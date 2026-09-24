import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('en'));
  }

  bool get isBangla => locale.languageCode == 'bn';

  String text(String key) =>
      _values[locale.languageCode]?[key] ?? _values['en']![key] ?? key;

  String savedProfiles(int count) =>
      isBangla ? '$countটি সংরক্ষিত প্রোফাইল' : '$count saved profiles';

  String viewingProfile(String name) =>
      isBangla ? 'প্রোফাইল দেখা হচ্ছে: $name' : 'Viewing Profile: $name';

  String monthAccent(String month, String season) =>
      isBangla ? '$month অ্যাকসেন্ট • $season' : '$month Accent • $season';

  String ageOld(int years, int months) =>
      isBangla ? '$years বছর $months মাস বয়স' : '${years}y ${months}m old';

  String birthdayIn(int days) =>
      isBangla ? '🎂 $days দিনের মধ্যে' : '🎂 in $days days';

  String get birthdayToday =>
      isBangla ? '🎂 আজ জন্মদিন!' : '🎂 Birthday Today!';

  String bornOn(String day) => isBangla ? '$day জন্ম' : 'Born on $day';

  String comingUpOn(String date) =>
      isBangla ? '$date তারিখে আসছে' : 'Coming up on $date';

  String inYear(int year) => isBangla ? '$year সালে' : 'In Year $year';

  String birthdayWillBe(String day) =>
      isBangla ? 'জন্মদিন $day তারিখে হবে' : 'Birthday will be on a $day';

  String ageYears(int age) => isBangla ? '$age বছর বয়স' : '$age yrs old';

  String plusYears(int years) => isBangla ? '+$years বছর' : '+$years Yrs';

  String number(String value) {
    if (!isBangla) return value;
    const english = '0123456789';
    const bangla = '০১২৩৪৫৬৭৮৯';
    return value.split('').map((digit) {
      final index = english.indexOf(digit);
      return index == -1 ? digit : bangla[index];
    }).join();
  }

  static const _values = <String, Map<String, String>>{
    'en': {
      'appTitle': 'Age Calculator',
      'calculator': 'Calculator',
      'difference': 'Difference',
      'familyFriends': 'Friends & Family',
      'switchLight': 'Switch to Light Mode',
      'switchDark': 'Switch to Dark Mode',
      'viewingProfile': 'Viewing Profile',
      'dateOfBirth': 'DATE OF BIRTH',
      'tapToSelect': 'Tap to select or change date',
      'calculateAge': 'Calculate Age',
      'dateDifferenceUtility': 'Date Difference Utility',
      'computeDuration': 'Compute duration and business days between dates',
      'startDate': 'START DATE',
      'endDate': 'END DATE',
      'includeEndDay': 'Include end day (+1 day)',
      'totalDuration': 'TOTAL DURATION',
      'years': 'Years',
      'months': 'Months',
      'days': 'Days',
      'workingDays': 'Working Days',
      'weekendDays': 'Weekend Days',
      'monFri': 'Mon - Fri',
      'satSun': 'Sat & Sun',
      'totalCalendarDays': 'Total Calendar Days',
      'familyFriendsTitle': 'Family & Friends',
      'add': 'Add',
      'all': 'All',
      'family': 'Family',
      'friend': 'Friend',
      'partner': 'Partner',
      'colleague': 'Colleague',
      'noProfiles': 'No Profiles Added Yet',
      'saveBirthdays':
          'Save your friends and family birthdays to check their exact age with 1-tap and get reminders!',
      'addFirstProfile': 'Add First Profile',
      'openCalculator': 'Open in Calculator',
      'edit': 'Edit',
      'delete': 'Delete',
      'pleaseEnterName': 'Please enter a name',
      'editProfile': 'Edit Profile',
      'addFamilyFriend': 'Add Family or Friend',
      'fullName': 'Full Name',
      'change': 'Change',
      'relationship': 'RELATIONSHIP',
      'avatarAccent': 'AVATAR ACCENT',
      'offlineReminder': 'Offline Birthday Reminder',
      'birthdayNotification': 'Send notification when birthday arrives',
      'saveChanges': 'Save Changes',
      'addProfile': 'Add Profile',
      'language': 'Language',
      'english': 'English',
      'bangla': 'বাংলা',
      'exactAge': 'Exact Age',
      'lifetimeBreakdown': 'LIFETIME BREAKDOWN',
      'weeks': 'Weeks',
      'hours': 'Hours',
      'minutes': 'Minutes',
      'seconds': 'Seconds',
      'nextBirthday': 'Next Birthday Countdown',
      'happyBirthday': '🎉 Happy Birthday! Enjoy your special day!',
      'yearCycle': 'Year Cycle Progress',
      'realTimeTicker': 'Real-Time Life Ticker',
      'pauseTicker': 'Pause Ticker',
      'resumeTicker': 'Resume Ticker',
      'existenceTicker': 'Your existence ticking in live precision:',
      'live': 'LIVE',
      'paused': 'PAUSED',
      'milestones': 'Life Milestones & Infographics',
      'heartbeats': 'Heartbeats',
      'breathsTaken': 'Breaths Taken',
      'heartRateAverage': '~80 bpm avg',
      'breathRateAverage': '~16 bpm avg',
      'hoursSleeping': 'Hours Spent Sleeping',
      'healthyRest': 'Based on ~8 hours of healthy rest per day',
      'astrologicalProfile': 'ASTROLOGICAL PROFILE',
      'westernSign': 'Western Sign',
      'chineseSign': 'Chinese Sign',
      'lunarCycle': 'Lunar cycle',
      'timeTravel': 'Time Travel & Future Age',
      'timeTravelHint':
          'Slide into the future to see your age and birthday milestone:',
      'plusYears': '+{years} Yrs',
    },
    'bn': {
      'appTitle': 'বয়স গণনাকারী',
      'calculator': 'গণনাকারী',
      'difference': 'পার্থক্য',
      'familyFriends': 'বন্ধু ও পরিবার',
      'switchLight': 'লাইট মোড চালু করুন',
      'switchDark': 'ডার্ক মোড চালু করুন',
      'viewingProfile': 'প্রোফাইল দেখা হচ্ছে',
      'dateOfBirth': 'জন্ম তারিখ',
      'tapToSelect': 'তারিখ নির্বাচন বা পরিবর্তন করতে চাপুন',
      'calculateAge': 'বয়স গণনা করুন',
      'dateDifferenceUtility': 'তারিখের পার্থক্য',
      'computeDuration': 'তারিখের ব্যবধান ও কর্মদিবস গণনা করুন',
      'startDate': 'শুরুর তারিখ',
      'endDate': 'শেষ তারিখ',
      'includeEndDay': 'শেষ দিন অন্তর্ভুক্ত করুন (+১ দিন)',
      'totalDuration': 'মোট সময়কাল',
      'years': 'বছর',
      'months': 'মাস',
      'days': 'দিন',
      'workingDays': 'কর্মদিবস',
      'weekendDays': 'সাপ্তাহিক ছুটির দিন',
      'monFri': 'সোম - শুক্র',
      'satSun': 'শনি ও রবি',
      'totalCalendarDays': 'মোট ক্যালেন্ডার দিন',
      'familyFriendsTitle': 'বন্ধু ও পরিবার',
      'add': 'যোগ করুন',
      'all': 'সব',
      'family': 'পরিবার',
      'friend': 'বন্ধু',
      'partner': 'সঙ্গী',
      'colleague': 'সহকর্মী',
      'noProfiles': 'এখনও কোনো প্রোফাইল যোগ করা হয়নি',
      'saveBirthdays':
          'বন্ধু ও পরিবারের জন্মদিন সংরক্ষণ করুন, এক ট্যাপে বয়স দেখুন এবং রিমাইন্ডার পান!',
      'addFirstProfile': 'প্রথম প্রোফাইল যোগ করুন',
      'openCalculator': 'গণনাকারীতে খুলুন',
      'edit': 'সম্পাদনা',
      'delete': 'মুছুন',
      'pleaseEnterName': 'একটি নাম লিখুন',
      'editProfile': 'প্রোফাইল সম্পাদনা',
      'addFamilyFriend': 'পরিবার বা বন্ধু যোগ করুন',
      'fullName': 'পুরো নাম',
      'change': 'পরিবর্তন করুন',
      'relationship': 'সম্পর্ক',
      'avatarAccent': 'অ্যাভাটার রঙ',
      'offlineReminder': 'অফলাইন জন্মদিন রিমাইন্ডার',
      'birthdayNotification': 'জন্মদিনে নোটিফিকেশন পাঠান',
      'saveChanges': 'পরিবর্তন সংরক্ষণ করুন',
      'addProfile': 'প্রোফাইল যোগ করুন',
      'language': 'ভাষা',
      'english': 'English',
      'bangla': 'বাংলা',
      'exactAge': 'সঠিক বয়স',
      'lifetimeBreakdown': 'জীবনকালের হিসাব',
      'weeks': 'সপ্তাহ',
      'hours': 'ঘণ্টা',
      'minutes': 'মিনিট',
      'seconds': 'সেকেন্ড',
      'nextBirthday': 'পরবর্তী জন্মদিনের কাউন্টডাউন',
      'happyBirthday': '🎉 শুভ জন্মদিন! আপনার বিশেষ দিনটি উপভোগ করুন!',
      'yearCycle': 'বছরের অগ্রগতি',
      'realTimeTicker': 'রিয়েল-টাইম জীবন ঘড়ি',
      'pauseTicker': 'ঘড়ি থামান',
      'resumeTicker': 'ঘড়ি চালু করুন',
      'existenceTicker': 'আপনার জীবন নির্ভুল সময়ে চলছে:',
      'live': 'চলছে',
      'paused': 'স্থির',
      'milestones': 'জীবনের মাইলফলক ও তথ্যচিত্র',
      'heartbeats': 'হৃদস্পন্দন',
      'breathsTaken': 'শ্বাস গ্রহণ',
      'heartRateAverage': 'গড়ে ~৮০ bpm',
      'breathRateAverage': 'গড়ে ~১৬ bpm',
      'hoursSleeping': 'ঘুমানোর সময়',
      'healthyRest': 'প্রতিদিন স্বাস্থ্যকর ~৮ ঘণ্টা বিশ্রামের ভিত্তিতে',
      'astrologicalProfile': 'জ্যোতিষ প্রোফাইল',
      'westernSign': 'পশ্চিমা রাশি',
      'chineseSign': 'চীনা রাশি',
      'lunarCycle': 'চন্দ্রচক্র',
      'timeTravel': 'সময় ভ্রমণ ও ভবিষ্যৎ বয়স',
      'timeTravelHint': 'ভবিষ্যতে আপনার বয়স ও জন্মদিন দেখতে স্লাইড করুন:',
      'plusYears': '+{years} বছর',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'bn'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
