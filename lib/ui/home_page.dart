import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_management/enum/status.dart';
import 'package:market_management/helpers/grocery_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GroceryHelper dbHelper = GroceryHelper();
  List<GroceryItem> groceryList = [];
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode priceFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDbList();
  }

  Future<void> _loadDbList() async {
    final list = await dbHelper.getAllGroceryItems();
    setState(() {
      groceryList = list;
    });
  }

  List<String> groceryTypes = [
    'grocery',
    'protein',
    'drinks',
    'vegetable',
    'cleaning',
  ];

  String typeSelected = 'grocery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Grocery List'),
        elevation: 10,
        shadowColor: Colors.black45,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controllerName.clear();
          controllerPrice.clear();
          showModalBottomSheet(
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            builder: (context) {
              return _inputBottomSheet(context, -1, status: Status.newItem);
            },
          );
        },
        backgroundColor: Colors.greenAccent,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: groceryList.length,
        itemBuilder: (context, index) {
          return groceryListItems(context, index);
        },
      ),
    );
  }

  /* ---------------- */
  /* ---------------- */
  /* ---------------- */
  /* ---------------- */

  Widget groceryListItems(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          useSafeArea: true,
          context: context,
          builder: (context) {
            return _showBottomSheet(context, index);
          },
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(5, 7, 5, 3),
        child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  setState(() {
                    if (groceryList[index].isSelected == 1) {
                      groceryList[index].isSelected = 0;
                    } else
                      groceryList[index].isSelected = 1;
                  });
                },
                backgroundColor: groceryList[index].isSelected == 0
                    ? Colors.greenAccent
                    : const Color.fromARGB(255, 226, 226, 226),
                icon: Icons.check,
                label: groceryList[index].isSelected == 0
                    ? "Bought"
                    : "Unbought",
                autoClose: true,
                borderRadius: BorderRadius.circular(8),
                flex: 3,
              ),
            ],
          ),
          child: Card(
            margin: EdgeInsets.all(0),
            color: groceryList[index].isSelected == 1
                ? Colors.greenAccent
                : Colors.white,
            child: Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: groceryList[index].isSelected == 0
                          ? Colors.white
                          : const Color.fromARGB(255, 238, 238, 238),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: groceryList[index].img != null
                            ? FileImage(File(groceryList[index].img!))
                            : AssetImage(
                                'assets/images/${groceryList[index].type}.png',
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          groceryList[index].name,
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    double.parse(groceryList[index].value) >
                                        double.parse(
                                          groceryList[index].oldValue,
                                        )
                                    ? Colors.redAccent
                                    : Colors.greenAccent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "R\$ ${groceryList[index].value}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            groceryList[index].oldValue.isNotEmpty
                                ? Row(
                                    children: [
                                      Text(
                                        double.parse(groceryList[index].value) >
                                                double.parse(
                                                  groceryList[index].oldValue,
                                                )
                                            ? '>'
                                            : '<',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 3),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              !(double.parse(
                                                    groceryList[index].value,
                                                  ) >
                                                  double.parse(
                                                    groceryList[index].oldValue,
                                                  ))
                                              ? Colors.redAccent
                                              : Colors.greenAccent,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          "R\$ ${groceryList[index].oldValue}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* ---------------- */
  /* ---------------- */
  /* ---------------- */
  /* ---------------- */

  Widget _showBottomSheet(BuildContext context, int index) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 60),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(),
                  onPressed: () {
                    controllerName.text = groceryList[index].name;
                    showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return _inputBottomSheet(
                          context,
                          index,
                          status: Status.editName,
                        );
                      },
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 7),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(1, 1),
                              color: Colors.black12,
                              blurRadius: 3,
                            ),
                          ],
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.edit, size: 30),
                      ),
                      Text(
                        'Edit\nName',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: ButtonStyle(),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return _inputBottomSheet(
                          context,
                          index,
                          status: Status.editPrice,
                        );
                      },
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 7),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(1, 1),
                              color: Colors.black12,
                              blurRadius: 3,
                            ),
                          ],
                          color: Colors.yellowAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.attach_money, size: 30),
                      ),
                      Text(
                        'Edit\nPrice',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: ButtonStyle(),
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return _photoOptions(context, index);
                      },
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 7),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(1, 1),
                              color: Colors.black12,
                              blurRadius: 3,
                            ),
                          ],
                          color: groceryList[index].isSelected == 0
                              ? Colors.greenAccent
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.camera_alt, size: 30),
                      ),
                      Text(
                        "Edit\nIcon/Photo",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: ButtonStyle(),
                  onPressed: () {
                    Navigator.pop(context);
                    dbHelper.deleteGroceryItem(groceryList[index].id!);
                    dbHelper.getAllGroceryItems().then((list) {
                      setState(() {
                        groceryList = list;
                      });
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 7),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(1, 1),
                              color: Colors.black12,
                              blurRadius: 3,
                            ),
                          ],
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.delete, size: 30),
                      ),
                      Text(
                        'Delete',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /* ---------------- */
  /* ---------------- */
  /* ---------------- */
  /* ---------------- */

  Widget _photoOptions(BuildContext context, int index) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 60),
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              StatefulBuilder(
                builder: (context, setStateModal) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var type in groceryTypes)
                          GestureDetector(
                            onTap: () {
                              setStateModal(() {
                                typeSelected = type;
                              });

                              print(typeSelected);
                            },
                            child: Container(
                              height: 70,
                              width: 70,
                              padding: EdgeInsets.all(0),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  if (typeSelected == type)
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                ],
                                color: typeSelected == type
                                    ? Colors.greenAccent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                "assets/images/$type.png",
                                alignment: AlignmentGeometry.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      groceryList[index].img = null;
                      groceryList[index].type = typeSelected;
                    });
                    dbHelper.updateGroceryItem(groceryList[index]);
                  },
                  child: Text("Pick Icon", style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    ImagePicker imagePicker = ImagePicker();
                    imagePicker.pickImage(source: ImageSource.camera).then((
                      file,
                    ) {
                      groceryList[index].img = file?.path;
                      dbHelper.updateGroceryItem(groceryList[index]);
                      dbHelper.getAllGroceryItems().then((list) {
                        setState(() {
                          groceryList = list;
                        });
                      });
                      print(file?.path);
                    });
                  },
                  child: Text("Camera", style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    ImagePicker imagePicker = ImagePicker();
                    imagePicker.pickImage(source: ImageSource.gallery).then((
                      file,
                    ) {
                      groceryList[index].img = file?.path;
                      dbHelper.updateGroceryItem(groceryList[index]);
                      dbHelper.getAllGroceryItems().then((list) {
                        setState(() {
                          groceryList = list;
                        });
                      });
                      print(file?.path);
                    });
                  },
                  child: Text("Gallery", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /* ---------------- */
  /* ---------------- */
  /* ---------------- */
  /* ---------------- */

  Widget _inputBottomSheet(
    BuildContext context,
    int index, {
    required Status status,
  }) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Padding(
          padding: EdgeInsetsGeometry.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setStateModal) {
              return Container(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 60),
                child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    status == Status.newItem
                        ? Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  spacing: 5,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    for (var type in groceryTypes)
                                      GestureDetector(
                                        onTap: () {
                                          setStateModal(() {
                                            typeSelected = type;
                                          });

                                          print(typeSelected);
                                        },
                                        child: Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 70,
                                            padding: EdgeInsets.all(0),
                                            margin: EdgeInsets.only(bottom: 10),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                if (typeSelected == type)
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 8,
                                                    offset: Offset(0, 3),
                                                  ),
                                              ],
                                              color: typeSelected == type
                                                  ? Colors.greenAccent
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Image.asset(
                                              "assets/images/$type.png",
                                              alignment:
                                                  AlignmentGeometry.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              TextField(
                                focusNode: nameFocus,
                                controller: controllerName,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Name",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),

                    TextField(
                      controller:
                          status == Status.newItem || status == Status.editPrice
                          ? controllerPrice
                          : controllerName,
                      focusNode:
                          status == Status.newItem || status == Status.editPrice
                          ? priceFocus
                          : nameFocus,
                      inputFormatters:
                          status == Status.newItem || status == Status.editPrice
                          ? [CurrencyTextInputFormatter.simpleCurrency()]
                          : [],
                      keyboardType:
                          status == Status.newItem || status == Status.editPrice
                          ? TextInputType.number
                          : TextInputType.text,
                      decoration: InputDecoration(
                        labelText:
                            status == Status.newItem ||
                                status == Status.editPrice
                            ? "Price"
                            : "Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (status == Status.editPrice) {
                          if (controllerPrice.text.isEmpty) {
                            priceFocus.requestFocus();
                          }
                          String text = controllerPrice.text.substring(1);
                          if (text.contains(",")) {
                            text = text.replaceAll(",", "");
                          }
                          print(text);
                          groceryList[index].oldValue =
                              groceryList[index].value;
                          groceryList[index].value = double.tryParse(
                            text,
                          )!.toStringAsFixed(2);

                          dbHelper.updateGroceryItem(groceryList[index]);
                          dbHelper.getAllGroceryItems().then((list) {
                            setState(() {
                              groceryList = list;
                            });
                          });
                          print(text);
                          controllerPrice.clear();
                        } else if (status == Status.editName) {
                          if (controllerName.text.isEmpty) {
                            nameFocus.requestFocus();
                          }
                          String text = controllerName.text;
                          groceryList[index].name = text;

                          dbHelper.updateGroceryItem(groceryList[index]);
                          dbHelper.getAllGroceryItems().then((list) {
                            setState(() {
                              groceryList = list;
                            });
                          });
                          print(text);
                          controllerName.clear();
                        } else {
                          if (controllerName.text.isEmpty) {
                            nameFocus.requestFocus();
                          } else {
                            if (controllerPrice.text.isEmpty) {
                              priceFocus.requestFocus();
                            }
                          }
                          String nameText = controllerName.text;
                          String priceText = controllerPrice.text.substring(1);
                          if (priceText.contains(",")) {
                            priceText = priceText.replaceAll(",", "");
                          }
                          print(priceText);
                          final valueParsed = double.tryParse(
                            priceText,
                          )!.toStringAsFixed(2);

                          GroceryItem newItem = GroceryItem(
                            name: nameText,
                            value: valueParsed,
                            type: typeSelected,
                          );

                          dbHelper.saveGroceryItem(newItem);
                          dbHelper.getAllGroceryItems().then((list) {
                            setState(() {
                              groceryList = list;
                              print(list);
                            });
                          });
                          controllerName.clear();
                          controllerPrice.clear();
                        }
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text("Submit", textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
