import 'package:equatable/equatable.dart';

class PaymentType extends Equatable {
  String id;
  String confirmationTicket;

  PaymentType({this.id, this.confirmationTicket});

  @override
  // TODO: implement props
  List<Object> get props => [id, confirmationTicket];
}
