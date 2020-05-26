import 'package:dashed_container/dashed_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis/models/api_models/shipping.dart';
import 'package:pluis/ui/shared/dashed_divider.dart';
import 'package:pluis/ui/shared/ticket.dart';
import 'package:pluis/ui/single_ticket.dart';
import 'index.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key key, @required OrderBloc orderBloc})
      : _orderBloc = orderBloc,
        super(key: key);

  final OrderBloc _orderBloc;

  @override
  OrderScreenState createState() {
    return new OrderScreenState(_orderBloc);
  }
}

class OrderScreenState extends State<OrderScreen> {
  final OrderBloc _orderBloc;
  static const offsetVisibleThreshold = 50;
  String selectedFilter;

  OrderScreenState(this._orderBloc);

  @override
  void initState() {
    super.initState();
    _orderBloc.add(PreLoadOrderEvent());
  }

  List<DataColumn> getColumns() {
    var headers =
        TextStyle(fontWeight: FontWeight.w700, color: Colors.grey.shade700);
    var columns = <String>[
      "Estado",
      "Mensajero",
      "Comisión",
      "Fecha de creación",
      "Pagado",
      "Entregado",
      "Monto",
      "Acciones"
    ];
    return columns
        .map<DataColumn>((item) => DataColumn(
                label: Text(
              item,
              style: headers,
            )))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: BlocBuilder<OrderBloc, OrderState>(
        bloc: widget._orderBloc,
        builder: (
          BuildContext context,
          OrderState currentState,
        ) {
          if (currentState is UnOrderState) {
            _orderBloc.add(LoadOrderEvent());
            return Container(
                child: Center(
              child: CircularProgressIndicator(),
            ));
          } else if (currentState is ErrorOrderState) {
            return NoData();
          } else if (currentState is NoDataOrderState) {
            return NoData();
          } else if (currentState is InOrderState) {
            return FollowOrders(
              columns: getColumns(),
              rows: currentState.getDataRow(context),
              shippings: currentState.shipping,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class FollowOrders extends StatelessWidget {
  const FollowOrders({Key key, this.columns, this.rows, this.shippings})
      : super(key: key);
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final List<Shipping> shippings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Center(
              child: Text(
            "Seguimiento",
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
          Expanded(
              child: ListView.builder(
                  itemCount: shippings.length,
                  itemBuilder: (context, index) {
                    Ticket ticket =Ticket(shipping: shippings[index], index: index);
                    return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SingleTicket(ticket: ticket,))),
                        child: ticket
                            );
                  }))
        ],
      ),
    );
  }
}

class NoData extends StatelessWidget {
  const NoData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Seguimiento",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade700),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DashedDivider()),
              Image.asset(
                "assets/icons/Untitled-3.png",
                height: MediaQuery.of(context).size.width * .5,
                width: MediaQuery.of(context).size.width * .5,
              ),
              Text("No hay datos para mostrar",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),              
            ],
          ),
        ));
  }
}
