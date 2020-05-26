import 'dart:ui';

import 'package:dashed_container/dashed_container.dart';
import 'package:flutter/material.dart';
import 'package:pluis/models/api_models/shipping.dart';

import 'package:pluis/resources/utils.dart';

import '../single_ticket.dart';

class Ticket extends StatefulWidget {
  final Shipping shipping;
  final int index;
  Ticket({Key key, this.shipping, this.index}) : super(key: key);

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  Color fontColor;

  @override
  Widget build(BuildContext context) {
    fontColor = Colors.grey.shade800;
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipShadowPath(
              clipper: TicketLeft(),
              child: Container(
                height: 90,
                width: 50,
                color: Colors.white,
                child: Center(
                  child: Hero(
                      tag: "barcode${widget.index}",
                      child: Container(
                          padding: const EdgeInsets.only(left: 15, right: 12),
                          height: 75,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Image.asset(
                              "assets/icons/barcode.png",
                              color: fontColor,
                            ),
                          ))),
                ),
              ),
              shadow: Shadow(
                  blurRadius: 0.0,
                  offset: Offset(-0.4, 0),
                  color: Colors.black),
            ),
            DashedContainer(
              child: Container(
                height: 80,
              ),
              dashColor: Colors.grey.shade600,
              blankLength: 4,
              dashedLength: 2.1,
              strokeWidth: 2,
            ),
            ClipShadowPath(
              clipper: TicketRight(),
              child: ticketInfo(),
              shadow: Shadow(
                  blurRadius: 0.0, offset: Offset(0.4, 0), color: Colors.black),
            ),
          ],
        ));
  }

  Widget ticketInfo() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: 90,
        width: 220,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  capitalize(widget.shipping.status.toLowerCase()),
                  style: TextStyle(
                      fontSize: 20,
                      color: fontColor,
                      fontWeight: FontWeight.w300),
                ),
                Spacer(),
                Text(
                  "ID:",
                  style: TextStyle(
                    fontSize: 12,
                    color: fontColor,
                  ),
                ),
                Text(
                  "${widget.shipping.id}",
                  style: TextStyle(
                      fontSize: 12,
                      color: fontColor,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Entregado:",
                  style: TextStyle(
                      fontSize: 12,
                      color: fontColor,
                      fontWeight: FontWeight.w300),
                ),
                Spacer(flex: 1),
                Text(
                  widget.shipping.delivered_at ? "Si" : "No",
                  style: TextStyle(
                    fontSize: 12,
                    color: fontColor,
                  ),
                ),
                Spacer(flex: 3),
                Icon(
                  Icons.compare_arrows,
                  size: 15,
                  color: fontColor,
                ),
                Spacer(flex: 3),
                Text(
                  "Pagado:",
                  style: TextStyle(
                      fontSize: 12,
                      color: fontColor,
                      fontWeight: FontWeight.w300),
                ),
                Spacer(flex: 1),
                Text(
                  widget.shipping.is_payed ? "Si" : "No",
                  style: TextStyle(
                    fontSize: 12,
                    color: fontColor,
                  ),
                )
              ],
            ),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  capitalize(widget.shipping.payment_way.name.toLowerCase()),
                  style: TextStyle(
                      fontSize: 12,
                      color: fontColor,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "${widget.shipping.amount_cuc} CUC",
                  style: TextStyle(
                      fontSize: 12,
                      color: fontColor,
                      fontWeight: FontWeight.w300),
                ),
                Spacer(),
                Text(
                  "${widget.shipping.amount_cup} CUP",
                  style: TextStyle(
                      fontSize: 12,
                      color: fontColor,
                      fontWeight: FontWeight.w300),
                ),
                Spacer(),
                Text(
                  "${widget.shipping.amount_usd} USD",
                  style: TextStyle(
                      fontSize: 12,
                      color: fontColor,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
          ],
        ));
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height - 6);
    path.quadraticBezierTo(
        size.width - 6, size.height - 6, size.width - 6, size.height);
    path.lineTo(6, size.height);
    path.quadraticBezierTo(6, size.height - 6, 0, size.height - 6);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TicketClipperInverse extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(6, 0);
    path.lineTo(size.width - 6, 0);
    path.quadraticBezierTo(size.width - 6, 6, size.width, 6);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 6);
    path.quadraticBezierTo(6, 6, 6, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TicketLeft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(5, 0);
    path.lineTo(size.width - 5, 0);
    path.quadraticBezierTo(size.width - 4.5, 5, size.width, 5);
    path.lineTo(size.width, size.height - 5);
    path.quadraticBezierTo(
        size.width - 4.5, size.height - 5, size.width - 5, size.height);
    path.lineTo(5, size.height);
    path.quadraticBezierTo(3.8, size.height - 3.8, 0, size.height - 5);
    path.lineTo(0, (size.height / 2) + 10);
    path.quadraticBezierTo(10, (size.height / 2) + 7.5, 10, size.height / 2);
    path.quadraticBezierTo(
        10, (size.height / 2) - 7.5, 0, (size.height / 2) - 10);
    path.lineTo(0, 5);
    path.quadraticBezierTo(3.8, 3.8, 5, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TicketRight extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(5, 0);
    path.lineTo(size.width - 5, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 5);
    path.lineTo(size.width, size.height - 5);
    path.quadraticBezierTo(
        size.width, size.height, size.width - 5, size.height);
    path.lineTo(5, size.height);
    path.quadraticBezierTo(4.5, size.height - 5, 0, size.height - 5);
    path.lineTo(0, 5);
    path.quadraticBezierTo(4.5, 5, 5, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  ClipShadowShadowPainter({@required this.shadow, @required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  ClipShadowPath({
    @required this.shadow,
    @required this.clipper,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClipShadowShadowPainter(
        clipper: this.clipper,
        shadow: this.shadow,
      ),
      child: ClipPath(child: child, clipper: this.clipper),
    );
  }
}
