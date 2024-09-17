import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_practical_1/modules/home/provider/home_provider.dart';
import 'package:flutter_practical_1/modules/productDetails/view/product_details.dart';
import 'package:provider/provider.dart';
import 'package:super_banners/super_banners.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return provider.isLoading
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          showFilterDialog(context);
                        },
                        child: const Text("Filter"))
                  ],
                ),
                body: Column(
                  children: [
                    SizedBox(
                        height: size.height * 0.07,
                        child: ListView.separated(
                          itemCount: provider.categoryList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var data = provider.categoryList[index];
                            return ChoiceChip(
                                selected: data.isSelected,
                                onSelected: (value) {
                                  data.isSelected = !data.isSelected;
                                  provider.filterList();
                                },
                                label: Text(
                                  data.name,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ));
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 5,
                            height: 5,
                          ),
                        )),
                    Expanded(
                        child: ListView.builder(
                      itemCount: provider.filterProductModel.length,
                      itemBuilder: (context, index) {
                        var data = provider.filterProductModel[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetails(product: data)));
                          },
                          child: Container(
                            height: size.height * 0.2,
                            width: size.width,
                            margin: const EdgeInsets.all(10),
                            child: Card(
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      Image.network(
                                        data.thumbnail ?? "",
                                        width: size.width * 0.2,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                data.title ?? "",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.67,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    data.brand ?? "",
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    data.price?.toString() ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  if (data.discountPercentage! > 0) ...[
                                    CornerBanner(
                                      bannerPosition:
                                          CornerBannerPosition.topLeft,
                                      bannerColor: Colors.red,
                                      elevation: 10,
                                      child: Text(
                                        "${data.discountPercentage?.toStringAsFixed(1) ?? "1"}%",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ))
                  ],
                ),
              );
      },
    );
  }

  void showFilterDialog(BuildContext context) {
    var size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return AlertDialog(
              content: SizedBox(
                width: size.width,
                height: size.height * 0.6,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.brandList.length,
                  itemBuilder: (context, index) {
                    var data = provider.brandList[index];
                    return CheckboxListTile(
                      title: Text(
                        data.name,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      value: data.isSelected,
                      onChanged: (value) {
                        data.isSelected = !data.isSelected;
                        provider.filterList();
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
