import '../models/room_type.dart';
import '../models/stay.dart';

DateTime _day(int days, int hour) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + days, hour);
}

List<Stay> seedStays() => [
  // ОБЯЗАТЕЛЬНОЕ 1: название ровно 60 символов
  Stay(
    id: 's1',
    title: 'Family Suite with Mountain View, Terrace and Breakfast Medeu',
    type: RoomType.family,
    checkIn: _day(11, 15),
    rooms: 6,
    place: 'Medeu, Almaty',
    guests: ['Aigerim', 'Daniyar'],
    description: 'Two bedrooms, kids stay free.',
  ),
  // ОБЯЗАТЕЛЬНОЕ 2: достиг лимита (3 номера, 3 гостя)
  Stay(
    id: 's2',
    title: 'Bosphorus Boutique Twin',
    type: RoomType.standard,
    checkIn: _day(18, 14),
    rooms: 3,
    place: 'Karakoy, Istanbul',
    guests: ['Aruzhan', 'Timur', 'Madina'],
    description: 'Rooftop breakfast with a view of the Bosphorus.',
    favourite: true,
  ),
  // ОБЯЗАТЕЛЬНОЕ 3: прошедшее
  Stay(
    id: 's3',
    title: 'Capsule Dorm Bed, Old Square',
    type: RoomType.dorm,
    checkIn: _day(-5, 13),
    rooms: 20,
    place: 'Old Square, Shymkent',
    guests: ['Nursultan', 'Dana', 'Yerlan'],
    description: 'Lockers and a shared kitchen.',
  ),
  // ОБЯЗАТЕЛЬНОЕ 4: mode включён — место это ссылка
  Stay(
    id: 's4',
    title: 'Ski Chalet Single, Shymbulak',
    type: RoomType.single,
    checkIn: _day(46, 16),
    rooms: 8,
    place: 'https://example.com/shymbulak-chalet',
    partner: true,
    guests: ['Alibek'],
    description: 'Ski pass is sold at the reception.',
  ),
  // ОБЯЗАТЕЛЬНОЕ 5: без описания (и осталось 1 место)
  Stay(
    id: 's5',
    title: 'Business Single near Expo',
    type: RoomType.single,
    checkIn: _day(2, 12),
    rooms: 4,
    place: 'Mangilik El 55, Astana',
    guests: ['Askar', 'Saule', 'Dana'],
  ),
  Stay(
    id: 's6',
    title: 'Deluxe Lake View Room, Rixos Borovoe',
    type: RoomType.deluxe,
    checkIn: _day(4, 14),
    rooms: 10,
    place: 'Burabay, Akmola region',
    guests: ['Aigerim', 'Daniyar', 'Madina', 'Timur', 'Saule', 'Askar', 'Dana'],
    description: 'Breakfast included. Balcony facing Lake Borovoe.',
    favourite: true,
  ),
  Stay(
    id: 's7',
    title: 'Presidential Suite, Caspian Riviera',
    type: RoomType.suite,
    checkIn: _day(17, 14),
    rooms: 2,
    place: 'Aktau, Mangystau',
    guests: ['Askar'],
    description: 'Private beach and a butler on request.',
  ),
  Stay(
    id: 's8',
    title: 'Old Town Double, Bukhara Gate',
    type: RoomType.standard,
    checkIn: _day(22, 14),
    rooms: 15,
    place: 'Bukhara, Uzbekistan',
    guests: ['Yerlan', 'Aruzhan'],
    description: 'A restored caravanserai in the old town.',
  ),
  Stay(
    id: 's9',
    title: 'Green Bazaar Hostel, 6-bed Room',
    type: RoomType.dorm,
    checkIn: _day(1, 13),
    rooms: 30,
    place: 'Zhibek Zholy 53, Almaty',
    guests: ['Timur', 'Dana', 'Alibek', 'Nursultan'],
    description: 'Ten minutes on foot to the Green Bazaar.',
  ),
  Stay(
    id: 's10',
    title: 'Riverside Standard, Ural Embankment',
    type: RoomType.standard,
    checkIn: _day(9, 14),
    rooms: 25,
    place: 'Dostyk 2, Uralsk',
  ),
  // mode включён — место это ссылка
  Stay(
    id: 's11',
    title: 'Kolsai Lakes Family Cabin',
    type: RoomType.family,
    checkIn: _day(30, 15),
    rooms: 5,
    place: 'https://example.com/kolsai-lakes-cabin',
    partner: true,
    guests: ['Saule', 'Askar'],
    description: 'Wood stove, no Wi-Fi, a lake view from every window.',
  ),
  Stay(
    id: 's12',
    title: 'Deluxe Sea View, Batumi Boulevard',
    type: RoomType.deluxe,
    checkIn: _day(-12, 14),
    rooms: 8,
    place: 'Batumi, Georgia',
    guests: ['Madina', 'Yerlan'],
    description: 'Ten floors up, facing the Black Sea.',
  ),
];
