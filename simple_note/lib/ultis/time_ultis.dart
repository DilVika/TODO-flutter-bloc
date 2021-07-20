DateTime readTimeStamp(int timestamp) {
  return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}

String writeTimeStamp(DateTime datetime) {
  return datetime.millisecondsSinceEpoch.toString();
}
