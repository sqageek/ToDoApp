class Task{
  // Class properties
  // Underscore makes them private

  String _key;
  String _name;
  String _notes;
  DateTime _dateTime;
  bool _completed = false;

  // Default constructor
  // this syntax means that it will accept a value and set it to this.name

  Task(this._name);

  // Getter and setter for key
  getKey() => this._key;

  // Getter and setter for name
  getName() => this._name;
  setName(name) => this._name = _name;

  // Getter and setter for notes
  getNotes() => this._notes;
  setNotes(notes) => this._notes = _notes;

  // Getter and setter for datetime
  getDateTime() => this._dateTime;
  setDateTime(dateTime) => this._dateTime = _dateTime;

  // Getter and setter for completed
  isCompleted() => this._completed;
  setCompleted(completed) => this._completed = completed;
}