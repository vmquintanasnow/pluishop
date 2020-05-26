import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pluis/ui/shared/app_scaffold.dart';
import 'package:pluis/ui/shared/dashed_divider.dart';

import 'shared/ticket.dart';

class SingleTicket extends StatefulWidget {
  SingleTicket({Key key, this.ticket}) : super(key: key);
  Ticket ticket;

  @override
  _SingleTicketState createState() => _SingleTicketState();
}

class _SingleTicketState extends State<SingleTicket> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Detalle de compra",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade700),
                )),
            Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DashedDivider()),
            ),
            widget.ticket,
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Artículos: ${widget.ticket.shipping.carts.length}",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade700),
                )),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ListView.builder(
                    itemCount: widget.ticket.shipping.carts.length,
                    itemBuilder: (context, index) {
                      var result = widget.ticket.shipping.carts[index];
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CachedNetworkImage(
                                  imageUrl: result.image,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        height: 50,
                                        width: 50,
                                        constraints:
                                            BoxConstraints(minWidth: 70),
                                        child: Center(
                                            child: Image.asset(
                                                "assets/images/no_image.png")),
                                      ),
                                  placeholder: (context, url) => Container(
                                        height: 50,
                                        width: 50,
                                        constraints:
                                            BoxConstraints(minWidth: 70),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                          heightFactor: 0.5,
                                          widthFactor: 1,
                                        ),
                                      )),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width / 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      result.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text("Cantidad: ${result.quantity}"),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "USD: ${_calculatePrice(result.price_usd, result.quantity).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      "CUP: ${_calculatePrice(result.price_cup, result.quantity).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      "CUC: ${_calculatePrice(result.price_cuc, result.quantity).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  double _calculatePrice(double price, int quantity) {
    var fullPrice = quantity * price;
    var coupon = widget.ticket.shipping.coupon.amount.toDouble() / 100;
    return fullPrice * (1-coupon);
  }
}
