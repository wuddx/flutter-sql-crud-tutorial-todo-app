//-|---------------- Todo Table ---------------------|
//-|-------|----------|--------------------|---------|
//-|  id   |   text   |   datetime         |  done   |
//-|-------|----------|--------------------|---------|
//-|   1   |   run5k  |  2025-03-23 17:00  |   false |
//-|-------|----------|--------------------|---------|
//-|   2   |   dinner |  2025-03-23 20:00  |   false |
//-|-------|----------|--------------------|---------|

class Todomodel {
  int? id;
  String text;
  String datetime;
  bool done;

  Todomodel({
    this.id,
    required this.text,
    required this.datetime,
    required this.done,
  });

  //for Insert SQL
  Map<String, Object?> toMap() => {
        'id': id,
        'text': text,
        'datetime': datetime,
        'done': done ? 1 : 0,
      };

  // for Read SQL
  factory Todomodel.fromMap(Map<String, Object?> map) => Todomodel(
      id: map['id'] as int?,
      text: map['text'] as String,
      datetime: map['datetime'] as String,
      done: map['done'] == 1);
}
