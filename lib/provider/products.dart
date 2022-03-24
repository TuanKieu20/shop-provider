import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_provider/models/http_exception.dart';

import 'package:shop_provider/provider/product.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// ignore: library_prefixes
import 'package:path/path.dart' as Path;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  String? _authToken;
  String? _userId;
  List<Product> _listDataFilter = [];
  // List<dynamic>? _imageUrls;

  // Products(this.authToken, this._items);
  void updates(String? token, List<Product> list, String? userId) {
    _authToken = token;
    _items = list;
    _userId = userId;
    notifyListeners();
  }

  // List updateList(List<Product> list) {
  //   _items = list;
  //   return _items;
  // }

  List<Product> get items {
    return [..._items];
  }

  // List<Product> get allProducts {
  //   return _listDataFilter;
  // }

  set setItems(List<Product> list) {
    _listDataFilter = list;
  }

  List<Product> get listDataFilter {
    return _listDataFilter;
  }

  List<Product> get favoritesItems {
    return _items.where((pro) => pro.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((pro) => pro.id == id);
  }

// lấy dữ liệu từ firebase

  Future<void> fetchData(String category, [bool filterByUser = true]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : ' ';
    var url =
        'https://shop-21e6b-default-rtdb.firebaseio.com/$category.json?auth=$_authToken&$filterString';
    var uri = Uri.parse(url);
    try {
      final response = await http.get(uri);
      final extratedData = json.decode(response.body);
      if (extratedData == null) {
        return;
      }
      extratedData as Map<String, dynamic>;
      uri = Uri.parse(
          'https://shop-21e6b-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken');
      final favoriteResponse = await http.get(uri);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extratedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              price: prodData['price'],
              images: prodData['urls'] == null
                  ? []
                  : prodData['urls'] as List<dynamic>,
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

// thêm mới 1 sản phẩm
  Future<void> addProduct(Product product, String category) async {
    final url = Uri.parse(
        'https://shop-21e6b-default-rtdb.firebaseio.com/$category.json?auth=$_authToken');

    try {
      await uploadFile();

      final response = await http.post(
        url,
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': _userId,
          'urls': imageUrls.isEmpty ? [].toList() : imageUrls.toList(),
        }),
      );
      final newProduct = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        images: imageUrls,
      );
      _items.add(newProduct);
      cleanImages();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

// cập nhật sản phẩm thông qua id
  Future<void> updateProduct(
      String id, Product newProduct, String category) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shop-21e6b-default-rtdb.firebaseio.com/$category/$id.json?auth=$_authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'creatorId': _userId,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      // ignore: avoid_print
      print("...");
    }
  }

// xóa sản phẩm
  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shop-21e6b-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeWhere((prod) => prod.id == id);

    final response = await http.delete(url);
    notifyListeners();
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product.");
    }
    existingProduct = null;
  }

  Future<void> getAllDataOfCategories() async {
    List<Product> products = [];

    // products = await _returnData('productsMen');
    await fetchData('productsMen', false);
    for (var product in _items) {
      products.add(product);
    }
    await fetchData('productsWoman', false);
    for (var product in _items) {
      products.add(product);
    }
    await fetchData('products', false);
    for (var product in _items) {
      products.add(product);
    }
    await fetchData('productsSale', false);
    for (var product in _items) {
      products.add(product);
    }

    _items = products;
    notifyListeners();
  }

  void filterProduct(String value) {
    _listDataFilter = [];
    notifyListeners();
    for (var e in _items) {
      if (e.title.contains(value)) {
        print(e.title);
        _listDataFilter.add(e);
      }
    }
    notifyListeners();
  }
// picker

//  file ảnh
  List<File> _images = [];
  List<String> imageUrls = [];
  final picker = ImagePicker();
  firebase_storage.Reference? ref;

  List<File> get images {
    return [..._images];
  }

  Future<void> _retriveLosData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      _images.add(File(response.file!.path));
      notifyListeners();
    } else {
      log(response.file.toString());
    }
  }

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    _images.add(File(pickedFile!.path));

    // ignore: unnecessary_null_comparison
    if (pickedFile.path == null) {
      _retriveLosData();
    }
    notifyListeners();
  }

  Future uploadFile() async {
    for (var img in _images) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$_userId/${Path.basename(img.path)}');
      await ref!.putFile(img).whenComplete(() async {
        await ref!.getDownloadURL().then((value) {
          imageUrls.add(value);
        });
      });
    }
  }

  void cleanImages() {
    _images = [];
    notifyListeners();
  }

  void cleanItems() {
    _items = [];
    notifyListeners();
  }
}
