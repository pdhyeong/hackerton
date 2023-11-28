class Meetting_List {
  final String meetingSession,
      cha,
      title,
      meettingTime,
      link,
      uniCd,
      uniNm,
      meetingDate;

  Meetting_List.fromJson(Map<String, dynamic> json)
      : meetingSession = json["MEETINGSESSION"],
        cha = json["CHA"],
        title = json["TITLE"],
        meettingTime = json["MEETTING_TIME"],
        meetingDate = json["MEETTING_DATE"],
        link = json["LINK_URL"],
        uniCd = json["UNIT_CD"],
        uniNm = json["UNIT_NM"];
}
