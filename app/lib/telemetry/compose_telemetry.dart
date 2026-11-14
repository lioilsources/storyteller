import 'package:ol1n_telemetry/ol1n_telemetry.dart';

import 'telemetry_dictionary.dart';

/// The `compose` flow (docs/telemetry.md): from "Vyprávět z …" on the globe
/// to "Vyprávím →" on the osnova. It spans five screens, so its state lives
/// here rather than in any one of them. Measuring only: nothing in the app
/// reads it (plan §4.9).
class ComposeTelemetry {
  ComposeTelemetry._();

  static TelemetryFlow? _flow;
  static String _step = 'cast';
  static int _cast = 0;

  static Map<String, Object> _props() => {'step': _step, 'cast': _cast};

  /// A country was picked: a new story begins. One still open was dropped.
  static void start(String? regionCode) {
    end('cancel');
    _step = 'cast';
    _cast = 0;
    _flow = Telemetry.flow('compose', {'region': telemetryRegion(regionCode)}, _props);
  }

  /// The parent moved on to [step]; [cast] once the cast is settled.
  static void reached(String step, {int? cast}) {
    if (_flow == null) return;
    _step = step;
    if (cast != null) _cast = cast.clamp(0, 6);
  }

  /// `ok` at "Vyprávím →", `cancel` at "Znovu" or when a new country
  /// replaces the story.
  static void end(String result) {
    final f = _flow;
    _flow = null;
    if (f != null && !f.ended) f.end(result, _props());
  }
}
