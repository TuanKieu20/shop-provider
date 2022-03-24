import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/product.dart';
import 'package:shop_provider/provider/products.dart';

enum Category { popular, men, woman, sale }

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Category? _category = Category.popular;
  String? _categoryString;

// khai báo sản phẩm mới
  var _editedProduct = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
    images: [],
  );

// khởi tạo giá trị ban đầu cho sản phẩm
  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'images': [],
  };
  var _isInit = true;
  var _isLoading = false;
  bool check = false;

  @override
  void initState() {
//lắng nghe sự thay đổi của textField imageUrl

    _imageUrlController.addListener(updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
// nếu id khác null thì vào cập nhật sản phẩm, gán giá trị ban đầu vào textField
      if (productId != '') {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
          'images': _editedProduct.images!.toList(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(updateImageURL);
    _imageUrlController.dispose();
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrlNode.dispose();
    check = false;
    super.dispose();
  }

  void updateImageURL() {
    if (!_imageUrlNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https'))
          // (!_imageUrlController.text.endsWith('.png') &&
          // !_imageUrlController.text.endsWith('.jpg') &&
          // !_imageUrlController.text.endsWith('.jpeg'))
          ) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    switch (_category) {
      case Category.popular:
        _categoryString = 'products';
        break;
      case Category.men:
        _categoryString = 'productsMen';
        break;
      case Category.woman:
        _categoryString = 'productsWoman';
        break;
      case Category.sale:
        _categoryString = 'productsSale';
        break;
      default:
    }
//cập nhật sản phẩm
    if (_editedProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct, _categoryString!);
      Provider.of<Products>(context, listen: false).cleanImages();
    } else {
// thêm mới sản phẩm
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct, _categoryString!);
        Provider.of<Products>(context, listen: false).cleanImages();
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("An error occurred!"),
            content: const Text("Something went wrong."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("Okay"),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<bool?> showWarning(BuildContext context) async => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Bạn chắc chắn muốn hủy không ?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Không'),
              ),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Có'))
            ],
          ));

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white10,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                (check == true)
                    ? Navigator.of(context).maybePop()
                    : Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            title: const Text(
              'Edit Product',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: _saveForm,
                  icon: const Icon(
                    Icons.save,
                    color: Colors.black,
                  ))
            ]),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _form,
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValue['title'].toString(),
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value!,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          isFavorite: _editedProduct.isFavorite,
                          images: _editedProduct.images,
                        );
                      },
                      onChanged: (_) {
                        setState(() {
                          check = true;
                        });
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'].toString(),
                      decoration: const InputDecoration(
                        labelText: 'price',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: double.parse(value!),
                          isFavorite: _editedProduct.isFavorite,
                          id: _editedProduct.id,
                          images: _editedProduct.images,
                        );
                      },
                      onChanged: (_) {
                        setState(() {
                          check = true;
                        });
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['description'].toString(),
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      focusNode: _descriptionNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageUrlNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: value!,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          isFavorite: _editedProduct.isFavorite,
                          id: _editedProduct.id,
                          images: _editedProduct.images,
                        );
                      },
                      onChanged: (_) {
                        setState(() {
                          check = true;
                        });
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: const Text('Category popular'),
                            leading: Radio<Category>(
                              value: Category.popular,
                              groupValue: _category,
                              onChanged: (value) {
                                setState(() {
                                  _category = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Category men'),
                            leading: Radio<Category>(
                              value: Category.men,
                              groupValue: _category,
                              onChanged: (value) {
                                setState(() {
                                  _category = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: const Text('Category woman'),
                            leading: Radio<Category>(
                              value: Category.woman,
                              groupValue: _category,
                              onChanged: (value) {
                                setState(() {
                                  _category = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Category sale'),
                            leading: Radio<Category>(
                              value: Category.sale,
                              groupValue: _category,
                              onChanged: (value) {
                                setState(() {
                                  _category = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          )),
                          child: Container(
                            alignment: Alignment.center,
                            child: _imageUrlController.text.isEmpty
                                ? const Text('Enter a URL')
                                : Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              // if (!value.endsWith('.png') &&
                              //     !value.endsWith('.jpg') &&
                              //     !value.endsWith('.jpeg')) {
                              //   return 'Please enter a valid image URL.';
                              // }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                imageUrl: value!,
                                price: _editedProduct.price,
                                isFavorite: _editedProduct.isFavorite,
                                images: _editedProduct.images,
                              );
                            },
                            onChanged: (_) {
                              setState(() {
                                check = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 150,
                      child: Consumer<Products>(
                        builder: (ctx, product, ch) {
                          return ListView.builder(
                            itemCount: (productId != '')
                                ? _editedProduct.images!.length + 1
                                : product.images.length + 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Container(
                                      width: 100,
                                      alignment: Alignment.center,
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        child: InkWell(
                                          onTap: () {
                                            Provider.of<Products>(ctx,
                                                    listen: false)
                                                .chooseImage();
                                            // picker.chooseImage();
                                          },
                                          child: const SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Icon(Icons.add),
                                          ),
                                        ),
                                      ),
                                    )
                                  : (productId != '')
                                      ? Container(
                                          width: 100,
                                          // color: Colors.red,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 12),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 2),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                _editedProduct
                                                    .images![index - 1],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 100,
                                          // color: Colors.red,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 12),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 2),
                                            image: DecorationImage(
                                              image: FileImage(
                                                product.images[index - 1],
                                              ),
                                            ),
                                          ),
                                        );
                            },
                          );
                        },
                      ),
                    ),
                    if (productId != '')
                      SizedBox(
                        height: 150,
                        child: Consumer<Products>(
                          builder: (ctx, product, ch) {
                            return ListView.builder(
                              itemCount: product.images.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 100,
                                  // color: Colors.red,

                                  margin: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    image: DecorationImage(
                                      image: FileImage(
                                        product.images[index],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                  ],
                ),
              ),
      ),
    );
  }
}
