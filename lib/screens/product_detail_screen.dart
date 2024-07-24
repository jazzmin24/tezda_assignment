import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tezda_assignment/config/colors.dart';
import 'package:tezda_assignment/model/product_model.dart';
import 'package:tezda_assignment/provider/favourite_provider.dart';
import 'package:tezda_assignment/widgets/text_widget.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final bool isFavorite = favoriteProvider.isFavorite(product.id.toString());

    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenHeight * 0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2.0,
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(30.w),
                  child: Image.network(
                    product.image,
                 
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: product.title,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 16.h),
                        TextWidget(
                          text: '\$${product.price}',
                          fontSize: 20.sp,
                          color: Colors.green,
                        ),
                        SizedBox(height: 16.h),
                        TextWidget(
                          text: product.description,
                          fontSize: 16.sp,
                        ),
                        SizedBox(height: 16.h),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Category: ',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: product.category,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Rating: ',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${product.rating.rate} (${product.rating.count} reviews)',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 20.h,
            left: 15.w,
            child: IconButton(
              icon: Icon(CupertinoIcons.back, color: Colors.black, size: 30.sp),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 20.h,
            right: 15.w,
            child: IconButton(
              icon: Icon(
                isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                color: isFavorite ? Colors.red : null,
                size: 30.sp,
              ),
              onPressed: () {
                favoriteProvider.toggleFavorite(product.id.toString());
              },
            ),
          ),
        ],
      ),
    );
  }
}
