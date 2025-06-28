import 'package:multi_view_calendar/src/data/calendar_view_type.dart';

class StringUtils {
  static MeetingPlatform detectMeetingPlatform(String input) {
    input = input.toLowerCase();

    if (input.contains('meet.google.com')) {
      return MeetingPlatform.googleMeet;
    } else if (input.contains('teams.microsoft.com')) {
      return MeetingPlatform.teams;
    } else if (input.contains('zoom.us') || input.contains('zoom.com')) {
      return MeetingPlatform.zoom;
    } else if (input.contains('skype.com')) {
      return MeetingPlatform.skype;
    }
    return MeetingPlatform.other;
  }
}
