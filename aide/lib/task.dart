class Task{
  // Class properties
  // Underscore makes them private

  String _key;
  String _name;
  bool _completed = false;

  // Default constructor
  // this syntax means that it will accept a value and set it to this.name

  Task(this._name);

  // Getter and setter for name
  getKey() => this._key;
  getName() => this._name;
  setName(name) => this._name = _name;

  // Getter and setter for completed

  isCompleted() => this._completed;
  setCompleted(completed) => this._completed = completed;
}