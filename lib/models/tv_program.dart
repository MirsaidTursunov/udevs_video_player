class TvProgram {

  TvProgram({
    required this.scheduledTime,
    required this.programTitle,
  });
  String scheduledTime;
  String programTitle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['scheduledTime'] = scheduledTime;
    map['programTitle'] = programTitle;
    return map;
  }

  @override
  String toString() => 'TvProgram{scheduledTime: $scheduledTime, programTitle: $programTitle}';
}
