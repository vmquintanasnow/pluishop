import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pluis/models/api_models/shipping.dart';

@immutable
abstract class OrderState extends Equatable {
  OrderState();

  /// Copy object for use in action
  OrderState copyWith();
}

/// UnInitialized
class UnOrderState extends OrderState {
  @override
  String toString() => 'UnOrderState';

  @override
  OrderState copyWith() {
    return UnOrderState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// Initialized
class InOrderState extends OrderState {
  List<Shipping> shipping;
  InOrderState({this.shipping});
  @override
  String toString() => 'InOrderState';

  @override
  OrderState copyWith() {
    return InOrderState(shipping: shipping);
  }

  @override
  // TODO: implement props
  List<Object> get props => [shipping];

  List<DataRow> getDataRow(BuildContext context) {
    return shipping.map<DataRow>((item) {
      return DataRow(cells: <DataCell>[
        DataCell(Text(item.status), onTap: () => onTap(item, context)),
        DataCell(
            Text(item.messenger_name == ""
                ? "POR DEFINIR"
                : item.messenger_name),
            onTap: () => onTap(item, context)),
        DataCell(Text("POR DEFINIR"), onTap: () => onTap(item, context)),
        DataCell(Text("POR DEFINIR"), onTap: () => onTap(item, context)),
        DataCell(Text(item.is_payed ? "Si" : "No"),
            onTap: () => onTap(item, context)),
        DataCell(Text(item.delivered_at ? "Si" : "No"),
            onTap: () => onTap(item, context)),
        DataCell(Text(item.amount_cuc.toStringAsFixed(2)),
            onTap: () => onTap(item, context)),
        DataCell(Text("Cell"), onTap: () => onTap(item, context))
      ]);
    }).toList();
  }

  onTap(Shipping item, BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Detalles"),
            content: ListView(
              children: item.carts.map<Widget>((item) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: CachedNetworkImage(
                      imageUrl: item.image,
                      height: 70,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                            height: 70,
                            constraints: BoxConstraints(minWidth: 70),
                            child: Center(
                                child:
                                    Image.asset("assets/images/no_image.png")),
                          ),
                      placeholder: (context, url) => Container(
                            height: 70,
                            constraints: BoxConstraints(minWidth: 70),
                            child: Center(
                              child: CircularProgressIndicator(),
                              heightFactor: 0.5,
                              widthFactor: 1,
                            ),
                          )),
                  title: Text(
                    item.name,
                    style: TextStyle(fontSize: 13),
                  ),
                  subtitle: Text(item.size),
                  trailing: Column(
                    children: <Widget>[
                      Text(
                        "${item.price_cuc.toStringAsFixed(2)}CUC",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "${item.price_cup.toStringAsFixed(2)}CUP",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "${item.price_usd.toStringAsFixed(2)}USD",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Salir"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

/// On Error
class ErrorOrderState extends OrderState {
  final String errorMessage;

  ErrorOrderState(this.errorMessage);

  @override
  String toString() => 'ErrorOrderState';

  @override
  OrderState copyWith() {
    return ErrorOrderState(this.errorMessage);
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// No Data
class NoDataOrderState extends OrderState {
  @override
  String toString() => 'NoDataOrderState';

  @override
  OrderState copyWith() {
    return this;
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
