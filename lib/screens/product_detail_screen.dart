import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/cart.dart';
import 'package:shop_provider/provider/products.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);
  static const routeName = "/product-detail";

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    var currentPage = 0;
    final CarouselController _controller = CarouselController();
    // if (loadedProduct.images!.length == 1) {
    //   print('1');
    // } else {
    //   print('Else:${loadedProduct.images![0]}');
    // }
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color(0xFFE7E3F5),
        // appBar: AppBar(
        //   title: Text(loadedProduct.title),
        // ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: <Widget>[
                  (loadedProduct.images!.length == 1)
                      ? SizedBox(
                          width: double.infinity,
                          height: size.height * 0.3,
                          child: Hero(
                            tag: loadedProduct.id,
                            child: Image.network(
                              loadedProduct.imageUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      : CarouselSlider.builder(
                          itemCount: loadedProduct.images!.length,
                          carouselController: _controller,
                          itemBuilder: (ctx, index, i) {
                            return Container(
                                width: size.width,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        loadedProduct.images![index]),
                                    fit: BoxFit.fill,
                                  ),
                                ));
                          },
                          options: CarouselOptions(
                              height: size.height * 0.4,
                              viewportFraction: 1,
                              autoPlay: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentPage = index;
                                });
                              }),
                        ),
                  Positioned(
                    bottom: 10,
                    left: size.width / 2 - 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          loadedProduct.images!.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () {
                            _controller.animateToPage(entry.key);
                          },
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        currentPage == entry.key ? 0.9 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: SizedBox(
                        // color: Colors.red,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon:
                                    const Icon(Icons.arrow_back_ios, size: 30)),
                            Icon(
                                loadedProduct.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 30),
                          ],
                        )),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  // height: 100,
                  // color: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'THE PRODUCT',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            loadedProduct.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '\$${loadedProduct.price.toString()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      RatingBarIndicator(
                        rating: 0,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star_border,
                          color: Colors.grey,
                        ),
                        itemCount: 4,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  )),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    Container(
                      width: size.width,
                      // height: 150,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 3),
                      color: const Color(0xFFD0D0D0),
                      child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: loadedProduct.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black,
                              ),
                            ),
                            const TextSpan(text: '\n'),
                            TextSpan(
                              text: loadedProduct.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            )
                          ])),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Size',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(children: const <Widget>[
                      ButtonSize(text: 'S'),
                      ButtonSize(text: 'M'),
                      ButtonSize(text: 'L'),
                      ButtonSize(text: 'XL'),
                      ButtonSize(text: 'XXL'),
                    ])
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: () {
            Provider.of<Cart>(context, listen: false).addItem(
                loadedProduct.id,
                loadedProduct.title,
                loadedProduct.price,
                loadedProduct.imageUrl);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  "Added item to cart",
                ),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .removeSingleItem(loadedProduct.id);
                  },
                ),
              ),
            );
          },
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.black,
              ),
              child: const Text(
                'ADD TO CART',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }
}

class ButtonSize extends StatefulWidget {
  const ButtonSize({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<ButtonSize> createState() => _ButtonSizeState();
}

class _ButtonSizeState extends State<ButtonSize> {
  bool check = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          check = !check;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(right: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: check == true ? Colors.black : Colors.white,
          border: Border.all(
            // color: Colors.red,

            width: 2,
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: check == true ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

// SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(
//               width: double.infinity,
//               height: 300,
//               child: Image.network(
//                 loadedProduct.imageUrl,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "\$${loadedProduct.price}",
//               style: const TextStyle(
//                 fontSize: 20,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               loadedProduct.description,
//               softWrap: true,
//             ),
//           ],
//         ),
//       ),
