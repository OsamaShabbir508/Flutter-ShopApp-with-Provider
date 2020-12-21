import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_aftereid/providers/ProductsProviders.dart';
import '../Moels/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/eidtProduct';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  final _priceFocusNode = FocusNode();
  final _description = FocusNode();
  final imageUrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var addNewProduct = Product(
      id: null, title: null, price: null, description: null, imageUrl: null);
  void textEditingConyro() {
    setState(() {
      print(imageUrl.text);
    });
  }

  var isInit = true;
  var _loadingIndicator = false;
  String idd;
  var initValue = {
    'id': '',
    'title': '',
    'price': '',
    'description': '',
  };

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isInit) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        final producut = Provider.of<ProductsProvider>(context).findById(id);
        initValue['title'] = producut.title;
        initValue['price'] = producut.price.toString();
        initValue['description'] = producut.description;
        //initValue['id'] = id;
        idd = id;
        //  print(initValue['id'].toString() + '//');
        imageUrl.text = producut.imageUrl;
      }
    }
    isInit = false;

    super.didChangeDependencies();
  }

  Future<void> saveForm(BuildContext context) async {
    final isvalidate = _formKey.currentState.validate();

    if (isvalidate != true) {
      return;
    }
    print(addNewProduct.title);
    print(addNewProduct.price.toString());
    print(addNewProduct.description);
    print(addNewProduct.imageUrl);
    _formKey.currentState.save();

    final prod = Provider.of<ProductsProvider>(context, listen: false);
    try {
      if (idd == null) {
        addNewProduct = Product(
            id: DateTime.now().toIso8601String(),
            title: addNewProduct.title,
            price: addNewProduct.price,
            description: addNewProduct.description,
            imageUrl: addNewProduct.imageUrl);
        setState(() {
          _loadingIndicator = true;
        });
        await prod.add(addNewProduct);
      } else {
        setState(() {
          _loadingIndicator = true;
        });
        print('Edit k else');
        addNewProduct = Product(
            id: idd,
            title: addNewProduct.title,
            price: addNewProduct.price,
            description: addNewProduct.description,
            imageUrl: addNewProduct.imageUrl);
        print(idd);
        //print();
        await prod.update(idd, addNewProduct);
      }
    } catch (error) {
      print('edit screen k cath main');
      print(error.toString());
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.grey[200],
          title: Text('SomeThing Went Wrong'),
          content: Text('it Might Be a Network issue'),
          semanticLabel: 'It Might Be a Network Issue',
          actions: <Widget>[
            RaisedButton(
                child: Text('Ok'),
                color: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      );
    } finally {
      setState(() {
        _loadingIndicator = false;
      });
      Navigator.of(context).pop();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        centerTitle: true,
      ),
      body: _loadingIndicator
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
                valueColor: AlwaysStoppedAnimation(Colors.red),
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    width: 30,
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      initialValue: initValue['title'],
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          filled: true,
                          hintText: 'Title',

                          // contentPadding: EdgeInsets.all(10),
                          // helperText: 'Title',
                          icon: Icon(Icons.title),
                          fillColor: Colors.grey[100],
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.blue))),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Title Cant Be Null';
                        }
                      },
                      onSaved: (value) {
                        addNewProduct = Product(
                            id: null,
                            title: value,
                            price: addNewProduct.price,
                            description: addNewProduct.description,
                            imageUrl: addNewProduct.imageUrl);
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      initialValue: initValue['price'],
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_description);
                      },
                      decoration: InputDecoration(
                          filled: true,
                          errorStyle: TextStyle(color: Colors.red),
                          hintText: 'Price',
                          // contentPadding: EdgeInsets.all(10),
                          // helperText: 'Title',
                          icon: Icon(Icons.attach_money),
                          prefixIcon: Icon(Icons.attach_money),
                          fillColor: Colors.grey[100],
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.blue))),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Price Cant be zero';
                        } else if (double.parse(value) < 0) {
                          return 'Price cant be less than zero';
                        }
                      },
                      onSaved: (value) {
                        addNewProduct = Product(
                            id: null,
                            title: addNewProduct.title,
                            price: double.parse(value),
                            description: addNewProduct.description,
                            imageUrl: addNewProduct.imageUrl);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                        initialValue: initValue['description'],
                        keyboardType: TextInputType.multiline,
                        focusNode: _description,
                        maxLines: 3,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            filled: true,
                            hintText: 'Description',
                            // contentPadding: EdgeInsets.all(10),
                            // helperText: 'Title',
                            icon: Icon(Icons.description),
                            prefixIcon: Icon(Icons.description),
                            fillColor: Colors.grey[100],
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.blue))),
                        validator: (String value) {
                          if (value.length < 7) {
                            return 'Description is very small';
                          }
                        },
                        onSaved: (value) {
                          addNewProduct = Product(
                              id: null,
                              title: addNewProduct.title,
                              price: addNewProduct.price,
                              description: value,
                              imageUrl: addNewProduct.imageUrl);
                        }),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(27),
                            color: Colors.grey[200]),
                        child: imageUrl.text.isEmpty
                            ? Text('Enter a Url')
                            : FittedBox(
                                child: Image.network(imageUrl.text),
                                fit: BoxFit.cover,
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                            //  initialValue: imageUrl.text,
                            keyboardType: TextInputType.url,
                            maxLines: 3,
                            controller: imageUrl,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                filled: true,
                                errorStyle: TextStyle(color: Colors.red),
                                hintText: 'Url',

                                // contentPadding: EdgeInsets.all(10),
                                // helperText: 'Title',

                                prefixIcon: Icon(Icons.http),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.done,
                                    color: Colors.blue,
                                  ),
                                  onPressed: textEditingConyro,
                                ),
                                fillColor: Colors.grey[100],
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide:
                                        BorderSide(color: Colors.blue))),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Url is null';
                              }
                            },
                            onSaved: (value) {
                              addNewProduct = Product(
                                  id: null,
                                  title: addNewProduct.title,
                                  price: addNewProduct.price,
                                  description: addNewProduct.description,
                                  imageUrl: value);
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: Colors.blue,
                          onPressed: () {
                            saveForm(context);
                          },
                          child: Container(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.save,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )))
                ],
              )),
    );
  }
}
