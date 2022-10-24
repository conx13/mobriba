import 'package:intl/intl.dart';

const String id = '50105030076';
const List kont1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 1];
const List kont2 = [3, 4, 5, 6, 7, 8, 9, 1, 2, 3];
bool ok = false;
num tulem = 0;
int tul = 0;
String yy = '';
num sajand = 0;
String aasta = '';
String kuu = '';
String paev = '';
var now = new DateTime.now();
var formatter = new DateFormat('yyyyMMdd');
int tanaDate = 0;
int synniDate = 0;

void arvuta() {
  for (var i = 0; i < 10; i++) {
    tulem += kont1[i] * (int.parse((id[i])));
  }
  tulem = tulem % 11;
  if (tulem == 10) {
    print('vers2');
    tulem = 0;
    for (var i = 0; i < 10; i++) {
      tulem += kont2[i] * (int.parse((id[i])));
    }
    tulem = tulem % 11;
    if (tulem == 10) {
      tulem = 0;
    }
  }

  sajand = int.parse((id[0]));
  yy = id[1] + id[2];
  aasta = (((17 + (sajand + 1) / 2).floor()) * 100 + int.parse(yy)).toString();
  kuu = '${id[3]}${id[4]}';
  paev = '${id[5]}${id[6]}';

  synniDate = int.parse(aasta + kuu + paev);
  tanaDate = int.parse(formatter.format(now));
  print(((tanaDate - synniDate).toString()).substring(0, 2)); //Vanus

  print(tulem.toString() == id[10]); //kas ID on õige
}
