import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_practical_1/modules/home/model/product_model.dart';

class ProductDetails extends StatefulWidget {
  Products product;
  ProductDetails({required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(
          widget.product.title ?? "",
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Image.network(widget.product.thumbnail ?? "",
              width: size.width, height: size.height * 0.35),
          Text(
            widget.product.description ?? "",
            style: const TextStyle(color: Colors.black),
          ),
          ListView.builder(
            itemCount: widget.product.reviews?.length ?? 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var data = widget.product.reviews![index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            data.reviewerName ?? "",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " on ${DateFormat('d MMMM yyyy').format(DateTime.parse(data.date!))}",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${data.rating} stars",
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data.comment ?? "",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
