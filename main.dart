

void main() {
//task 1 for printing Hello I'm "ZagEng"
  print('Hello I\'m "ZagEng"');

//task 2 for calculate formula
  double distance = 25;
  double speed = 40;

  //calculate time in hours
  double timeInHours = distance / speed;

  //calculate time in minutes , seconds and hours
  int hours = timeInHours.toInt();
  int minutes = ((timeInHours - hours) * 60).toInt();
  int seconds = ((timeInHours * 3600) % 60).toInt();

  // print result
  print('Time taken: $hours hours, $minutes minutes, $seconds seconds');

  //task 3 for counting from 10:0 
  int x = 10;

  print(x); // 10
  x -= 1;

  print(x); // 9
  x -= 1;

  print(x); // 8
  x -= 1;

  print(x); // 7
  x -= 1;

  print(x); // 6
  x -= 1;

  print(x); // 5
  x -= 1;

  print(x); // 4
  x -= 1;

  print(x); // 3
  x -= 1;

  print(x); // 2
  x -= 1;

  print(x); // 1
  x -= 1;

  print(x); // 0
}
