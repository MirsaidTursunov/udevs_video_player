class TvProgram {
  String scheduledTime;
  String programTitle;
  bool isAvailable;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['scheduledTime'] = scheduledTime;
    map['programTitle'] = programTitle;
    map['isAvailable'] = isAvailable;
    return map;
  }

  @override
  String toString() {
    return 'TvProgram{scheduledTime: $scheduledTime, programTitle: $programTitle}';
  }

  TvProgram({
    required this.scheduledTime,
    required this.programTitle,
    required this.isAvailable,
  });
}
