import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  EditProductScreen({Key? key}) : super(key: key);
  static const routeName = 'edit_product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0.0, imageUrl: '');
  final _form = GlobalKey<FormState>();

  var init = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    _form.currentState?.save();
    _isLoading = true;
    if (_editedProduct.id.length <= 1) {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        return showDialog<Null>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('there is a problem !!'),
                content: Text('somthing went wrong please try later'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }).then((value) {
        setState(() {
        _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } else {
      Provider.of<Products>(context, listen: false)
          .editProduct(_editedProduct.id, _editedProduct);
      print('in edited' + _editedProduct.title);
    }
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!(_imageUrlController.text.startsWith('assets') ||
              _imageUrlController.text.startsWith('asset')) ||
          !(_imageUrlController.text.endsWith('jpg') ||
              _imageUrlController.text.endsWith('png') ||
              _imageUrlController.text.endsWith('jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  Map<String, String> _initialValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void didChangeDependencies() {
    if (init) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final productId = ModalRoute.of(context)!.settings.arguments as String;
        if (productId.length > 0) {
          _editedProduct =
              Provider.of<Products>(context, listen: false).findById(productId);
          _initialValues = {
            'title': _editedProduct.title,
            'price': _editedProduct.price.toString(),
            'description': _editedProduct.description,
          };
          _imageUrlController.text = _editedProduct.imageUrl;
        }
      }
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: ListView(
                children: [
                  // TITLE TEXT FIELD
                  TextFormField(
                    initialValue: _initialValues['title'],
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value.toString(),
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          isFavourite: _editedProduct.isFavourite);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please provide a value';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                  ),
                  //PRICE TEXT FIELD
                  TextFormField(
                    initialValue: _initialValues['price'],
                    decoration: InputDecoration(
                      labelText: 'Price',
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: double.parse(value.toString()),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          isFavourite: _editedProduct.isFavourite);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please provide a value';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Enter a valid Number';
                      }
                      return null;
                    },
                  ),
                  // DESCRIPTION TEXT FIELD
                  TextFormField(
                    initialValue: _initialValues['decription'],
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value.toString(),
                          imageUrl: _editedProduct.imageUrl,
                          isFavourite: _editedProduct.isFavourite);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please provide a value';
                      }
                      if (value.length < 10) {
                        return 'description must be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                  //IMAGE AND URL FIELD
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // IMAGE PREVIEW CONTAINER
                      Container(
                        margin: EdgeInsets.only(right: 5.0, top: 8.0),
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: Colors.grey)),
                        child: _imageUrlController.text.isEmpty
                            ? Text('Enter a Url')
                            : Image.asset(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                      ),
                      //IMAGE URL TEXT FIELD
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'ImageUrl',
                          ),
                          controller: _imageUrlController,
                          textInputAction: TextInputAction.done,
                          focusNode: _imageUrlFocusNode,
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value.toString(),
                                isFavourite: _editedProduct.isFavourite);
                          },
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please provide a value';
                            }
                            if (!(value.startsWith('assets') ||
                                value.startsWith('asset'))) {
                              return 'please enter a valid URL !!';
                            }
                            if (!(value.endsWith('jpg') ||
                                value.endsWith('png') ||
                                value.endsWith('jpeg'))) {
                              return 'please enter a valid image!!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
