import 'package:badges/badges.dart' as badge;
import 'package:catalog_app_provider/model/cart_model.dart';
import 'package:catalog_app_provider/provider/cart_provider.dart';
import 'package:catalog_app_provider/screens/cart_screen.dart';
import 'package:catalog_app_provider/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

DBHelper? dbHelper = DBHelper();

List<String> productName = [
  'Mango',
  'Orange',
  'Grapes',
  'Banana',
  'Chery',
  'Peach',
  'Mixed Fruit Basket',
];
List<String> productUnit = [
  'KG',
  'Dozen',
  'KG',
  'Dozen',
  'KG',
  'KG',
  'KG',
];
List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
List<String> productImage = [
  'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
  'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
  'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
  'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
  'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
  'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
  'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
];

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product list"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CartScreen()));
            },
            child: Center(
              child: badge.Badge(
                badgeContent:
                    Consumer<CartProvider>(builder: (context, value, child) {
                  return Text(
                    value.getCounter().toString(),
                    style: const TextStyle(color: Colors.white),
                  );
                }),
                badgeAnimation: const badge.BadgeAnimation.slide(
                    animationDuration: Duration(milliseconds: 300)),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 25,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: productName.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image(
                                height: 100,
                                width: 100,
                                image: NetworkImage(
                                    productImage[index].toString()),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productName[index].toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      productUnit[index].toString() +
                                          r" $" +
                                          productPrice[index].toString(),
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          print(index);
                                          print(index);
                                          print(productName[index].toString());
                                          print(productPrice[index].toString());
                                          print('1');
                                          print(productUnit[index].toString());
                                          print(productImage[index].toString());
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text("item add to cart"),
                                            ),
                                          );

                                          dbHelper!
                                              .insert(
                                            Cart(
                                              id: index,
                                              productId: index.toString(),
                                              productName:
                                                  productName[index].toString(),
                                              initialPrice: productPrice[index],
                                              productPrice: productPrice[index],
                                              quantity: 1,
                                              unitTag:
                                                  productUnit[index].toString(),
                                              imageUrl: productImage[index]
                                                  .toString(),
                                            ),
                                          )
                                              .then((value) {
                                            print("Cart is added ");
                                            cart.addTotalPrice(double.parse(
                                                productPrice[index]
                                                    .toString()));
                                            cart.addCounter();
                                          }).onError((error, stackTrace) {
                                            // print(error.toString());
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: const Center(
                                            child: Text(
                                              "Add to Cart",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
