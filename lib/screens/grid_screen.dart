import 'package:flutter/material.dart';

class GridScreen extends StatefulWidget {
  const GridScreen({super.key});

  @override
  State<GridScreen> createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  int m = 0, n = 0;

  List<List<String>> grid = [];

  String searchText = '';

  /// this controller for rows
  TextEditingController mController = TextEditingController();
  ///this controller for columns
  TextEditingController nController = TextEditingController();
  ///for search flag
  bool isSearch = false;

  ///for highlight the grids
  int selectedI = -1;
  int selectedJ = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: isSearch
            ? TextField(
          decoration: const InputDecoration(hintText: "Search..."),
          onChanged: (value) {
            setState(() {
              selectedI = -1;
              selectedJ = -1;
              for (int i = 0; i < grid.length; i++) {
                for (int j = 0; j < grid[i].length; j++) {
                  if (grid[i][j] == value) {
                    selectedI = i;
                    selectedJ = j;
                    return;
                  }
                }
              }
            });
          },
        )
            : const Text("Grid Screen"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearch = !isSearch;
                });
              },
              icon: Icon(isSearch?Icons.close : Icons.search))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: mController,
              decoration: const InputDecoration(hintText: "Please Input m (rows)"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  m = int.tryParse(mController.text) ?? 0;
                  n = 0;
                  nController.clear();
                  grid.clear();
                  for (int i = 0; i < m; i++) {
                    grid.add([]);
                  }
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nController,
              decoration: const InputDecoration(hintText: "Please Input n (Columns)"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  n = int.tryParse(nController.text) ?? 0;
                  for (int i = 0; i < grid.length; i++) {
                    List<String> s = [];
                    for (int iN = 0; iN < n; iN++) {
                      s.add("-");
                    }
                    grid[i] = s;
                  }
                });
              },
            ),
          ),
          if (m != 0 && n != 0) ...[
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: n,
                ),
                itemCount: m * n,
                itemBuilder: (context, index) {

                  int i = index ~/ n;
                  int j = index % n;

                  return InkWell(
                    onTap: () {
                      TextEditingController alphabetController = TextEditingController();

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: TextField(controller: alphabetController, decoration: const InputDecoration(hintText: "Enter Alphabet")),
                          actions: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Close"),
                            ),
                            MaterialButton(
                              onPressed: () {
                                setState(() {
                                  grid[i][j] = alphabetController.text;
                                });
                                Navigator.pop(context);
                              },
                              color: Colors.green,
                              textColor: Colors.white,
                              child: const Text("Done"),
                            )
                          ],
                        ),
                      );
                    },

                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(border: Border.all(color: Colors.black87), color: (selectedI == i || selectedJ == j) ? Colors.red.shade200 : Colors.white),
                      alignment: Alignment.center,
                      child: Text(
                        grid[i][j],
                      ),
                    ),
                  );
                },

              ),

            ),
          ],
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: (){
              m=0;
              n=0;
              grid = [];
              searchText="";
              isSearch = false;
              selectedI = -1;
              selectedJ = -1;
              mController.clear();
              nController.clear();
              isSearch=false;
              setState(() {

              });
            }, child: const Text("Reset")),
          )
        ],

      ),

    );
  }
}
