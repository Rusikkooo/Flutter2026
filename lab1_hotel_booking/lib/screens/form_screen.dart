import 'package:flutter/material.dart';

import '../models/room_type.dart';
import '../models/stay.dart';
import '../routes.dart';
import '../utils/format.dart';

// NEW: снимок всех значений формы — для сравнения в PopScope (R30)
typedef _FormValues = ({
  String title,
  String place,
  String rooms,
  String description,
  RoomType? type,
  bool partner,
  DateTime? date,
  TimeOfDay? time,
});

// CHANGED: был StatelessWidget-заглушка
class FormScreen extends StatefulWidget {
  const FormScreen({super.key, required this.args});

  // R26: форма получает Stay? (null — новое предложение)
  final FormArgs args;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  // R33: ключ формы — один validate() на Save
  final _formKey = GlobalKey<FormState>();

  // R35: контроллеры и FocusNode — поля State, создаются один раз
  final _title = TextEditingController();
  final _place = TextEditingController();
  final _rooms = TextEditingController();
  final _description = TextEditingController();
  final _dateText = TextEditingController();
  final _timeText = TextEditingController();
  final _placeFocus = FocusNode();
  final _roomsFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  late final Stay _initial; // с чем форма открылась
  late final _FormValues _start; // снимок значений при открытии
  RoomType? _type;
  bool _partner = false;
  DateTime? _date;
  TimeOfDay? _time;
  bool _saving = false; // R17

  bool get _isNew => widget.args.stay == null;

  @override
  void initState() {
    super.initState();
    // R3: новое предложение начинается со Stay.empty()
    final s = widget.args.stay ?? Stay.empty();
    _initial = s;
    _title.text = s.title;
    _place.text = s.place;
    _rooms.text = '${s.rooms}';
    _description.text = s.description ?? '';
    _type = _isNew ? null : s.type;
    _partner = s.partner;
    if (!_isNew) {
      _date = DateUtils.dateOnly(s.checkIn);
      _time = TimeOfDay.fromDateTime(s.checkIn);
      _dateText.text = '${formatDate(s.checkIn)} ${s.checkIn.year}';
      _timeText.text = formatTime(s.checkIn);
    }
    _start = _values;
  }

  @override
  void dispose() {
    // R35: всё освобождаем
    _title.dispose();
    _place.dispose();
    _rooms.dispose();
    _description.dispose();
    _dateText.dispose();
    _timeText.dispose();
    _placeFocus.dispose();
    _roomsFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  // текущие значения формы одним record
  _FormValues get _values => (
    title: _title.text,
    place: _place.text,
    rooms: _rooms.text,
    description: _description.text,
    type: _type,
    partner: _partner,
    date: _date,
    time: _time,
  );

  // R30: форма «грязная», если хоть что-то отличается от начала
  bool get _dirty => _values != _start;

  // R36: дата через пикер; Cancel оставляет старое значение
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: _isNew ? DateUtils.dateOnly(now) : DateTime(2000),
      lastDate: DateTime(now.year + 3),
    );
    // R14: после await — mounted; null = нажали Cancel
    if (picked == null || !mounted) return;
    setState(() {
      _date = picked;
      _dateText.text = '${formatDate(picked)} ${picked.year}';
    });
  }

  // R36: время через пикер
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 14, minute: 0),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _time = picked;
      _timeText.text = formatTime(
        DateTime(0, 1, 1, picked.hour, picked.minute),
      );
    });
  }

  // R17: сохранение «на 1 секунду», без двойного сохранения
  Future<void> _save() async {
    if (_saving) return; // R17: второе нажатие ничего не делает
    // R33: один validate() — каждое поле проверяет себя само
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return; // R14

    final d = _date;
    final t = _time;
    if (d == null || t == null) return; // валидаторы уже проверили
    final description = _description.text.trim();

    // R36: дата и время собираются в один DateTime
    final stay = Stay(
      id: _isNew
          ? DateTime.now().microsecondsSinceEpoch.toString()
          : _initial.id,
      title: _title.text.trim(),
      type: _type ?? RoomType.standard,
      checkIn: DateTime(d.year, d.month, d.day, t.hour, t.minute),
      rooms: int.parse(_rooms.text.trim()),
      place: _place.text.trim(),
      guests: _initial.guests,
      partner: _partner,
      description: description.isEmpty ? null : description,
      favourite: _initial.favourite,
    );
    // R26: форма ВОЗВРАЩАЕТ Stay через pop
    Navigator.pop(context, stay);
  }

  // R30: вопрос перед выходом без сохранения
  Future<void> _askDiscard() async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep editing'),
          ), // TextButton
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Discard'),
          ), // FilledButton
        ],
      ), // AlertDialog
    );
    // R14: context.mounted после await
    if (discard == true && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    void unfocus(PointerDownEvent _) => FocusScope.of(context).unfocus();

    // R30: canPop = !_dirty; стрелка и жест Android ведут себя одинаково
    return PopScope<Stay>(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return; // ушли без вопроса (чистая форма или Save)
        _askDiscard();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isNew ? 'New stay' : 'Edit stay'),
        ), // AppBar
        body: Form(
          key: _formKey,
          // R33: ошибки появляются, как только начал вводить
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // перерисовать, чтобы canPop пересчитался (R30)
          onChanged: () => setState(() {}),
          // R37: форма прокручивается, клавиатура её не ломает
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // R34: название 3–60, счётчик
                TextFormField(
                  controller: _title,
                  maxLength: 60,
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onTapOutside: unfocus,
                  validator: (value) {
                    final v = (value ?? '').trim();
                    if (v.length < 3 || v.length > 60) {
                      return 'From 3 to 60 characters';
                    }
                    return null;
                  },
                ), // TextFormField
                const SizedBox(height: 12),

                // R34: тип номера обязателен
                DropdownButtonFormField<RoomType>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Room type'),
                  items: [
                    for (final t in RoomType.values)
                      DropdownMenuItem(
                        value: t,
                        child: Row(
                          children: [
                            Icon(t.icon),
                            const SizedBox(width: 12),
                            Text(t.label),
                          ],
                        ), // Row
                      ), // DropdownMenuItem
                  ],
                  onChanged: (v) => setState(() => _type = v),
                  validator: (v) => v == null ? 'Choose a room type' : null,
                ), // DropdownButtonFormField
                const SizedBox(height: 4),

                // mode: меняет смысл поля места
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Partner listing'),
                  subtitle: const Text('The place becomes a link'),
                  value: _partner,
                  onChanged: (v) => setState(() => _partner = v),
                ), // SwitchListTile
                // R34: место обязательно; при mode — ссылка с ://
                TextFormField(
                  controller: _place,
                  focusNode: _placeFocus,
                  decoration: InputDecoration(
                    labelText: _partner ? 'Partner link' : 'Address',
                  ), // InputDecoration
                  keyboardType: _partner
                      ? TextInputType.url
                      : TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _roomsFocus.requestFocus(),
                  onTapOutside: unfocus,
                  validator: (value) {
                    final v = (value ?? '').trim();
                    if (v.isEmpty) return 'Required';
                    if (_partner && !v.contains('://')) {
                      return 'A link must contain ://';
                    }
                    return null;
                  },
                ), // TextFormField
                const SizedBox(height: 12),

                // R36: дата и время — только чтение, открывают пикеры
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dateText,
                        readOnly: true,
                        onTap: _pickDate,
                        decoration: const InputDecoration(
                          labelText: 'Check-in date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ), // InputDecoration
                        validator: (_) => _date == null ? 'Pick a date' : null,
                      ), // TextFormField
                    ), // Expanded
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _timeText,
                        readOnly: true,
                        onTap: _pickTime,
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          suffixIcon: Icon(Icons.schedule),
                        ), // InputDecoration
                        // R34: для нового — только в будущем
                        validator: (_) {
                          final d = _date;
                          final t = _time;
                          if (t == null) return 'Pick a time';
                          if (_isNew && d != null) {
                            final at = DateTime(
                              d.year,
                              d.month,
                              d.day,
                              t.hour,
                              t.minute,
                            );
                            if (!at.isAfter(DateTime.now())) {
                              return 'Must be in the future';
                            }
                          }
                          return null;
                        },
                      ), // TextFormField
                    ), // Expanded
                  ],
                ), // Row
                const SizedBox(height: 12),

                // R34: 1–500 и не меньше уже забронированных
                TextFormField(
                  controller: _rooms,
                  focusNode: _roomsFocus,
                  decoration: const InputDecoration(labelText: 'Rooms'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _descriptionFocus.requestFocus(),
                  onTapOutside: unfocus,
                  validator: (value) {
                    final n = int.tryParse((value ?? '').trim());
                    if (n == null || n < 1 || n > 500) {
                      return 'A whole number from 1 to 500';
                    }
                    if (n < _initial.count) {
                      return 'At least ${_initial.count}: already booked';
                    }
                    return null;
                  },
                ), // TextFormField
                const SizedBox(height: 12),

                TextFormField(
                  controller: _description,
                  focusNode: _descriptionFocus,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                  ), // InputDecoration
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  onTapOutside: unfocus,
                ), // TextFormField
                const SizedBox(height: 24),

                // R17: во время сохранения кнопка выключена и крутится
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ) // SizedBox
                      : const Text('Save'),
                ), // FilledButton
              ],
            ), // Column
          ), // SingleChildScrollView
        ), // Form
      ), // Scaffold
    ); // PopScope
  }
}
