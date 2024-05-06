import 'package:flutter/material.dart';

const Map<String, String> discountStoreFilter = {
  '여가/레저': 'LEISURE',
  '서비스업': 'SERVICES',
  '잡화': 'GOODS',
  '식품/음료': 'FOOD_BEVERAGE',
  '도소매/문구': 'RETAIL ',
  '교육': 'EDUCATION',
  '생활': 'LIFE',
  '기타': 'ETC',
};

const Map<String, String> restaurantFilter = {
  '착한가격업소': 'GOOD_PRICE',
  '아이조아카드': 'CHILD_LIKE',
  '아동급식카드': 'CHILD_MEAL',
  '모범음식점': 'MODEL',
  '문화누리카드': 'CULTURE_NURI ',
};

const Map<String, String> mysafeHomeFilter = {
  '비상벨': 'WarningBell',
  'CCTV': 'CCTV',
  '가로등': 'StreetLamp'
};

const Map<String, String> bookmarkFilter = {
  '음식점': 'RESTAURANT',
  '할인매장': 'DISCOUNT_STORE',
  '축제': 'FESTIVAL',
  '동네 마실': 'TOWN_STROLL'
};

const List<IconData> mysafeHomeIcon = [
  Icons.notification_important,
  Icons.videocam,
  Icons.wb_incandescent,
];

const List<Color> filterColor = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.black
];
