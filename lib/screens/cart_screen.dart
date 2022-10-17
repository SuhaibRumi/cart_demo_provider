import 'package:badges/badges.dart';
import 'package:catalog_app_provider/model/cart_model.dart';
import 'package:catalog_app_provider/provider/cart_provider.dart';
import 'package:catalog_app_provider/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

var cart = Cart;

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(" My Product "),
        centerTitle: true,
        actions: [
          Center(
            child: Badge(
              badgeContent:
                  Consumer<CartProvider>(builder: (context, value, child) {
                return Text(
                  value.getCounter().toString(),
                  style: const TextStyle(color: Colors.white),
                );
              }),
              animationDuration: const Duration(milliseconds: 300),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 25,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Image(
                              image: AssetImage('images/empty_cart.png')),
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                              child: Text('Explore Your Product',
                                  style:
                                      Theme.of(context).textTheme.headline6)),
                        ],
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Image(
                                            height: 100,
                                            width: 100,
                                            image: NetworkImage(snapshot
                                                .data![index].imageUrl
                                                .toString()),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot.data![index]
                                                          .productName
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        dbHelper!.delete(
                                                            snapshot
                                                                .data![index]
                                                                .id!);
                                                        cart.removeCounter();
                                                        cart.removeTotalPrice(
                                                            double.parse(
                                                          snapshot.data![index]
                                                              .productPrice
                                                              .toString(),
                                                        ));
                                                      },
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  snapshot.data![index].unitTag
                                                          .toString() +
                                                      r" $" +
                                                      snapshot.data![index]
                                                          .productPrice
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      height: 40,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              int quantity =
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .quantity!;

                                                              int price = snapshot
                                                                  .data![index]
                                                                  .initialPrice!;
                                                              quantity--;
                                                              int? newPrice =
                                                                  price *
                                                                      quantity;
                                                              if (quantity >
                                                                  0) {
                                                                dbHelper!
                                                                    .update(Cart(
                                                                        id: snapshot
                                                                            .data![
                                                                                index]
                                                                            .id!,
                                                                        productId: snapshot
                                                                            .data![
                                                                                index]
                                                                            .id!
                                                                            .toString(),
                                                                        productName: snapshot
                                                                            .data![
                                                                                index]
                                                                            .productName!
                                                                            .toString(),
                                                                        productPrice:
                                                                            newPrice,
                                                                        initialPrice: snapshot
                                                                            .data![
                                                                                index]
                                                                            .initialPrice!,
                                                                        quantity:
                                                                            quantity,
                                                                        unitTag: snapshot
                                                                            .data![
                                                                                index]
                                                                            .unitTag!
                                                                            .toString(),
                                                                        imageUrl: snapshot
                                                                            .data![
                                                                                index]
                                                                            .imageUrl!
                                                                            .toString()))
                                                                    .then(
                                                                        (value) {
                                                                  newPrice = 0;
                                                                  quantity = 0;
                                                                  cart.removeTotalPrice(double.parse(snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice!
                                                                      .toString()));
                                                                }).onError((error,
                                                                        stackTrace) {
                                                                  print(error
                                                                      .toString());
                                                                });
                                                              }
                                                            },
                                                            child: const Icon(
                                                                Icons
                                                                    .remove_circle,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Text(
                                                              snapshot
                                                                  .data![index]
                                                                  .quantity
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white)),
                                                          InkWell(
                                                            onTap: () {
                                                              int quantity =
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .quantity!;

                                                              int price = snapshot
                                                                  .data![index]
                                                                  .initialPrice!;
                                                              quantity++;
                                                              int? newPrice =
                                                                  price *
                                                                      quantity;

                                                              dbHelper!
                                                                  .update(Cart(
                                                                      id: snapshot
                                                                          .data![
                                                                              index]
                                                                          .id!,
                                                                      productId:
                                                                          snapshot.data![index].id!
                                                                              .toString(),
                                                                      productName: snapshot
                                                                          .data![
                                                                              index]
                                                                          .productName!
                                                                          .toString(),
                                                                      productPrice:
                                                                          newPrice,
                                                                      initialPrice: snapshot
                                                                          .data![
                                                                              index]
                                                                          .initialPrice!,
                                                                      quantity:
                                                                          quantity,
                                                                      unitTag: snapshot
                                                                          .data![
                                                                              index]
                                                                          .unitTag!
                                                                          .toString(),
                                                                      imageUrl: snapshot
                                                                          .data![
                                                                              index]
                                                                          .imageUrl!
                                                                          .toString()))
                                                                  .then(
                                                                      (value) {
                                                                newPrice = 0;
                                                                quantity = 0;
                                                                cart.addTotalPrice(
                                                                    double.parse(snapshot
                                                                        .data![
                                                                            index]
                                                                        .initialPrice!
                                                                        .toString()));
                                                              }).onError((error,
                                                                      stackTrace) {
                                                                print(error
                                                                    .toString());
                                                              });
                                                            },
                                                            child: const Icon(
                                                                Icons
                                                                    .add_circle,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
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
                      );
                    }
                  }

                  return const Text("");
                }),
            Consumer<CartProvider>(
              builder: (context, value, child) {
                return Visibility(
                  visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"
                      ? false
                      : true,
                  child: Column(
                    children: [
                      ReuseableWidget(
                        title: "Sub Total",
                        value: r"$" + value.getTotalPrice().toStringAsFixed(2),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class ReuseableWidget extends StatelessWidget {
  final String title;
  final String value;
  const ReuseableWidget({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
