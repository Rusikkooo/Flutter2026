// R9: sealed class — ровно три варианта, других не бывает
sealed class Countdown {
  const Countdown();

  // R9: сам решает, какой из трёх вариантов сейчас
  factory Countdown.until(DateTime checkIn, {DateTime? now}) {
    final current = now ?? DateTime.now();

    if (checkIn.isAfter(current)) {
      return Upcoming(checkIn.difference(current));
    }

    final since = current.difference(checkIn);
    if (since < const Duration(hours: 24)) {
      return Started(since);
    }

    return const Ended();
  }
}

// заезд ещё впереди — сколько осталось
class Upcoming extends Countdown {
  const Upcoming(this.left);
  final Duration left;
}

// заезд уже начался (первые 24 часа) — сколько прошло
class Started extends Countdown {
  const Started(this.since);
  final Duration since;
}

// всё закончилось — данных не нужно
class Ended extends Countdown {
  const Ended();
}