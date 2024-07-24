import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tezda_assignment/config/colors.dart';
import 'package:tezda_assignment/provider/favourite_provider.dart';
import 'package:tezda_assignment/services/api/api_service.dart';
import 'package:tezda_assignment/model/product_model.dart';
import 'package:tezda_assignment/screens/favourite_screen.dart';
import 'package:tezda_assignment/screens/product_detail_screen.dart';
import 'package:tezda_assignment/screens/profile_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<ProductModel>> _productsFuture;
  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: appbarColor,
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.heart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favoriteProducts: _products
                        .where((product) =>
                            favoriteProvider.isFavorite(product.id.toString()))
                        .toList(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.person_circle,
              size: 26.sp,
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ProfileScreen(),
              //   ),
              // );
            },
          ),
          SizedBox(width: 10.w)
        ],
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          } else {
            _products = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(10.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 0.67,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                ProductModel product = _products[index];
                final isFavorite =
                    favoriteProvider.isFavorite(product.id.toString());
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Card(
                    surfaceTintColor: Colors.transparent,
                    color: Colors.white,
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.r),
                            topRight: Radius.circular(15.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 4.w, left: 4.w, top: 3.h),
                            child: Container(
                              color: Colors.white,
                              height: 190.h,
                              width: double.infinity,
                              child: Image.network(
                                product.image,
                                //fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 0.h),
                          child: Text(
                            product.title,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 2.h, left: 9.w, right: 8.w, bottom: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${product.price}',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  color: isFavorite ? Colors.red : null,
                                ),
                                onPressed: () {
                                  favoriteProvider
                                      .toggleFavorite(product.id.toString());
                                },
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
        },
      ),
    );
  }
}
