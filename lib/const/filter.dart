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
  '모범음식점': 'MODEL',
  '아이조아': 'CHILD_LIKE',
  '아동급식': 'CHILD_MEAL',
  '착한가격': 'GOOD_PRICE',
};

const List<Color> restaurantFilterColor = [
  Color(0xFF007036),
  Color(0xFFFF9D26),
  Color(0xFF5A65BE),
  Color(0xFF223C80),
];

const Map<String, String> mysafeHomeFilter = {
  '비상벨': 'WARNING_BELL',
  'CCTV': 'CCTV',
  '가로등': 'STREET_LAMP'
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

const List<Color> safeFilterColor = [
  Color(0xFFFF0000),
  Color(0xFF696969),
  Color(0xFFFF9D26),
];
