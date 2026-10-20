import 'countdown.dart';
import 'room_type.dart';
class Stay{
  // R1: immutable — все поля final, конструктор const
  const Stay({
    required this.id,
    required this.title,
    required this.type,
    required this.checkIn,
    required this.rooms,
    required this.place,
    List<String> guests = const [],
    this.partner = false,
    this.description,
    this.favourite = false,
  }): _guests = guests;

  // R3: значения по умолчанию для нового предложения
  Stay.empty():
    id = '',
    title = '',
    type = RoomType.standard,
    checkIn = DateTime.now().add(const Duration(days: 1)),
    rooms = 10,
    place = '',
    _guests = const [],
    partner = false,
    description = null,
    favourite = false;
  
  final String id;
  final String title;
  final RoomType type;
  final DateTime checkIn;
  final int rooms; // лимит
  final String place; // адрес, а при partner = true — ссылка
  final List<String> _guests;
  final bool partner; // mode
  final String? description; // R6: необязательный текст
  final bool favourite;

  // R1: список гостей снаружи только для чтения
  List<String> get guests => List.unmodifiable(_guests);

  // R4: вычисляемые значения — геттеры, не поля
  int get count => _guests.length;
  int get free => rooms - count;
  bool get isFull => free <= 0;
  bool get isPast => checkIn.isBefore(DateTime.now());
  bool contains(String name) => _guests.contains(name);

  // R5: record из двух чисел
  ({int taken, int free}) get places => (taken: count, free: free);

  Stay copyWith({
    String? title,
    RoomType? type,
    DateTime? checkIn,
    int? rooms,
    String? place,
    List<String>? guests,
    bool? partner,
    String? description,
    bool? favourite,
  }){
    return Stay(
      id: id,
      title: title ?? this.title,
      type: type ?? this.type,
      checkIn: checkIn ?? this.checkIn,
      rooms: rooms ?? this.rooms,
      place: place ?? this.place,
      guests: guests ?? _guests,
      partner: partner ?? this.partner,
      description: description ?? this.description,
      favourite: favourite ?? this.favourite,
    );
  }
  // забронировать и отменить — тоже через копию
  Stay book(String name) => copyWith(guests: [..._guests, name]);
  Stay cancel(String name) => copyWith(guests: _guests.where((g) => g != name).toList());
}