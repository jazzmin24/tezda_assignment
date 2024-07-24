import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tezda_assignment/config/colors.dart';
import 'package:tezda_assignment/model/product_model.dart';

class FavoritesScreen extends StatelessWidget {
  final List<ProductModel> favoriteProducts;

  FavoritesScreen({required this.favoriteProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: const Text('Favorite Products'),
        titleSpacing: 0,
      ),
      body: favoriteProducts.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  'No favorite products',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(10.w),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                ProductModel product = favoriteProducts[index];
                return Card(
                  surfaceTintColor: Colors.transparent,
                  color: Colors.white,
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        child: Container(
                          width: 130.w,
                          height: 120.h,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              product.image,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                '\$${product.price}',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(CupertinoIcons.heart_fill),
                        color: Colors.red,
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
