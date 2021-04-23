import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/products_data.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: "",
    price: 0,
    imageUrl: "",
    description: "",
  );

  var _init = true;
  var _initValues = {
    "title": "",
    "price": "",
    "description": "",
    "imageUrl": "",
  };
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_init) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(productId);
        _initValues = {
          "title": _editedProduct.title,
          "price": _editedProduct.price.toString(),
          "description": _editedProduct.description,
//        "imageUrl": _editedProduct.imageUrl,
          "imageUrl": "",
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct); //try Catch error handlers
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An ERROR Occurred!"),
            content: Text("Something Went Wrong!"),
            actions: [
              FlatButton(
                child: Text("OKAY"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } finally {
        Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Products",
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
            ),
          ],
        ),
        body: Form(
          key: _form,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter A Title";
                          }
                          return null;
                        },
                        initialValue: _initValues["title"],
                        decoration: InputDecoration(
                          labelText: "Title",
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: value,
                            id: _editedProduct.id,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter A Amount";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please Enter Valid Amount";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please Enter Amount Greater Than Zero(0)";
                          }
                          return null;
                        },
                        initialValue: _initValues["price"],
                        decoration: InputDecoration(
                          labelText: "Price",
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        focusNode: _priceFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            id: _editedProduct.id,
                            description: _editedProduct.description,
                            price: double.parse(value),
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter A Description";
                          }
                          if (value.length < 10) {
                            return "Description Should Be Atleast 10 Characters Long!";
                          }
                          return null;
                        },
                        initialValue: _initValues["description"],
                        decoration: InputDecoration(
                          labelText: "Description",
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            id: _editedProduct.id,
                            description: value,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.black12,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text(
                                    "Enter Image URL",
                                    textAlign: TextAlign.center,
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter A URL";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Image URL",
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  title: _editedProduct.title,
                                  id: _editedProduct.id,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value,
                                  isFavourite: _editedProduct.isFavourite,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        ));
  }
}
