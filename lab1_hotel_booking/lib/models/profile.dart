// R1: immutable — поля final, конструктор const
class Profile {
  const Profile({required this.name, required this.group});

  // R3: пустой профиль по умолчанию
  const Profile.empty() : name = '', group = '';

  final String name;
  final String group;
  bool get isEmpty => name.trim().isEmpty;
  // R1: копия с изменениями
  Profile copyWith({String? name, String? group}) {
    return Profile(name: name ?? this.name, group: group ?? this.group);
  }
}
