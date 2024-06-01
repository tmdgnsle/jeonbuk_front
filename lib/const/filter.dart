import 'package:flutter/material.dart';

const Map<String, String> discountStoreFilter = {
  '전체': 'all',
  '여가/레저': 'LEISURE',
  '잡화': 'GOODS',
  '생활': 'LIFE',
  '교육': 'EDUCATION',
  '서비스업': 'SERVICES',
  '기타': 'ETC',
};

const List<Color> discountStoreFilterColor = [
  Color(0xFF323232),
  Color(0xFFEB4F3D),
  Color(0xFF2BB673),
  Color(0xFF3F7ACE),
  Color(0xFF53C0D8),
  Color(0xFFD971DB),
  Color(0xFF848484),
];

const List<IconData> discountStoreFilterIcon = [
  Icons.weekend,
  Icons.home_repair_service,
  Icons.movie_creation,
  Icons.school,
  Icons.face,
  Icons.workspaces,
];

const Map<String, String> restaurantFilter = {
  '전체': 'all',
  '모범음식점': 'MODEL',
  '아이조아': 'CHILD_LIKE',
  '아동급식': 'CHILD_MEAL',
  '착한가격': 'GOOD_PRICE',
};

const List<Color> restaurantFilterColor = [
  Color(0xFF323232),
  Color(0xFF007036),
  Color(0xFFFF9D26),
  Color(0xFF5A65BE),
  Color(0xFF223C80),
];

const List<IconData> restaurantFilterIcon = [
  Icons.local_dining,
  Icons.child_care,
  Icons.credit_card,
  Icons.thumb_up_alt,
];

const Map<String, String> mysafeHomeFilter = {
  '전체': 'all',
  '비상벨': 'WarningBell',
  'CCTV': 'CCTV',
  '가로등': 'StreetLamp'
};

const List<Color> safeFilterColor = [
  Color(0xFF323232),
  Color(0xFFFF0000),
  Color(0xFF696969),
  Color(0xFFFF9D26),
];

const List<IconData> mysafeHomeIcon = [
  Icons.notification_important,
  Icons.videocam,
  Icons.wb_incandescent,
];

const Map<String, String> bookmarkFilter = {
  '전체': 'ALL',
  '음식점': 'RESTAURANT',
  '할인매장': 'DISCOUNT_STORE',
  '축제': 'FESTIVAL',
  '동네 마실': 'TOWN_STROLL'
};

const List<Color> bookmarkFilterColor = [
  Color(0xFF323232),
  Color(0xFFEB4F3D),
  Color(0xFFFFB21E),
  Color(0xFF014594),
  Color(0xFF63AA42),
];

const List<IconData> bookmarkFilterIcon = [
  Icons.restaurant,
  Icons.shopping_bag,
  Icons.festival,
  Icons.directions_walk
];
