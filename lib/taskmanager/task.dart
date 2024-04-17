class Task {
  late String title;
  late String description;
  late String statue;
  late DateTime duedate = DateTime.now();
  late DateTime reminder = DateTime.now();
  String? company;
  late String priority;

  Task(
      {required this.title,
      required this.description,
      required this.duedate,
      required this.reminder,
      required this.priority});
}
