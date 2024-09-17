import 'package:flutter/material.dart';
import 'package:flutter_practical_1/modules/home/provider/home_provider.dart';
import 'package:flutter_practical_1/modules/home/views/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}




/* void main() {
  List<int> array = [10, 5, 2, 79, 23, 12, 10, 6, 7, 2, 0];

  sortAndRemoveDuplicate(array);
}

sortAndRemoveDuplicate(List<int> array) {
  List<int> array1 = [];

  /// used to remove duplicate value
  for (var val in array) {
    if (!array1.contains(val)) {
      array1.add(val);
    }
  }

  /// used to sort array without in-built functioan
  bool isSwapped = false;
  do {
    isSwapped = false;
    for (int i = 0; i < array1.length - 1; i++) {
      /// it just compare value next to first position
      if (array1[i] > array1[i + 1]) {
        /// if it find greater value from first position then it will swap value with first position
        int temp = array1[i];
        array1[i] = array1[i + 1];
        array1[i + 1] = temp;
        isSwapped = true;
      }
    }
  } while (isSwapped);

  print("arrray ==> $array1");
}
 */