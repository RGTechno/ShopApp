import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orders;

  rOrderItem(this.orders);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: _expanded ? min(widget.orders.products.length * 20.0 + 130, 280) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 10,
        child: Column(
          children: [
            ListTile(
              title: Text(
                "${widget.orders.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "OrbitronRegular",
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                DateFormat("dd/MM/yyyy: hh:mm").format(widget.orders.dateTime),
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "OrbitronRegular",
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                padding: EdgeInsets.all(10),
                height: _expanded ? min(widget.orders.products.length * 20.0 + 30, 180) : 0,
                child: ListView(
                  children: [
                    ...widget.orders.products
                        .map((prod) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prod.title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "OrbitronRegular",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${prod.quantity}x  ${prod.price}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "OrbitronRegular",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ))
                        .toList()
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
