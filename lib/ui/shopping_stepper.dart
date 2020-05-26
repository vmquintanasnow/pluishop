import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis/bloc/shopping_cart.dart/index.dart';
import 'package:pluis/models/api_models/coupon.dart';
import 'package:pluis/models/api_models/payment.dart';
import 'package:pluis/models/shop_iw.dart';

import 'shared/address_ticket.dart';
import 'shared/dashed_divider.dart';
import 'shared/shopping_cart.dart';

class ShoppingStepper extends StatefulWidget {
  ShoppingStepper({Key key, this.bonuses, this.payment}) : super(key: key);
  List<Coupon> bonuses;
  List<Payment> payment;

  @override
  _ShoppingStepperState createState() => _ShoppingStepperState();
}

class _ShoppingStepperState extends State<ShoppingStepper> {
  int currentStep;
  GlobalKey<FormState> formKeyAddress = GlobalKey();
  GlobalKey<FormState> formKeyPayment = GlobalKey();
  bool autovalidateAdress = false;
  bool autovalidatePayment = false;

  bool isActive(int index) {
    return currentStep == index;
  }

  @override
  void initState() {
    currentStep = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
        controlsBuilder: (context,
            {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          return Row(
            children: <Widget>[
              if (currentStep > 0)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: OutlineButton(
                      onPressed: () {
                        setState(() {
                          if (currentStep != 0) currentStep--;
                        });
                      },
                      borderSide: BorderSide(
                        width: 0.2,
                        color: Colors.black,
                      ),
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
              Expanded(
                flex: 3,
                child: FlatButton(
                  onPressed: () {
                    if (currentStep == 0) {
                      if (ShoppingCartInfo.of(context).products.length > 0)
                        setState(() {
                          currentStep++;
                        });
                    } else if (currentStep == 1) {
                      setState(() {
                        autovalidateAdress = true;
                      });
                      if (formKeyAddress.currentState.validate()) {
                        formKeyAddress.currentState.save();
                        setState(() {
                          currentStep++;
                        });
                      }
                    } else {
                      setState(() {
                        autovalidatePayment = true;
                      });
                      if (formKeyPayment.currentState == null ||
                          formKeyPayment.currentState.validate()) {
                        formKeyPayment.currentState.save();
                        ShoppingCartBloc()
                            .add(ProcessShoppingCartEvent(context: context));
                        
                      }
                    }
                  },
                  color: Colors.black,
                  child: Text(
                    "CONTINUAR",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
        currentStep: currentStep,
        type: StepperType.horizontal,
        steps: <Step>[
          Step(
              title: Icon(Icons.shopping_cart),
              isActive: isActive(0),
              content: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 224,
                  child: ShoppingCartUI(bonuses: widget.bonuses))),
          Step(
              title: Icon(Icons.info),
              isActive: isActive(1),
              content: AddressTicket(
                  formKey: formKeyAddress, autoValidate: autovalidateAdress)),
          Step(
              title: Icon(Icons.check),
              isActive: isActive(2),
              content: PaymmentMethod(
                  formKey: formKeyPayment,
                  autovalidate: autovalidatePayment,
                  payments: widget.payment,
                  context: context)),
        ]);
  }
}

class PaymmentMethod extends StatefulWidget {
  PaymmentMethod(
      {Key key, this.formKey, this.autovalidate, this.context, this.payments})
      : super(key: key);
  final GlobalKey<FormState> formKey;
  final bool autovalidate;
  BuildContext context;
  List<Payment> payments;
  @override
  _PaymmentMethodState createState() => _PaymmentMethodState();
}

class _PaymmentMethodState extends State<PaymmentMethod> {
  Payment payment;
  double cuc = 0, cup = 0, usd = 0;

  calculate() {
    var products = ShoppingCartInfo.of(widget.context).products;
    double bonus = ShoppingCartInfo.of(widget.context).coupon.amount / 100;
    if (products.length > 0) {
      products.forEach((item) {
        cuc += item.product.priceCuc * item.amount;
        cup += item.product.priceCup * item.amount;
        usd += item.product.priceUsd * item.amount;
      });
    }
    cuc -= bonus * cuc;
    cup -= bonus * cup;
    usd -= bonus * usd;
  }

  @override
  void initState() {
    calculate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration:
              BoxDecoration(border: Border.all(width: 0.5, color: Colors.grey)),
          child: Column(
            children: <Widget>[
              Text(
                "INFORMACIÓN DE PAGO",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                "Seleccione el tipo de pago que va a utilizar",
                style: TextStyle(fontSize: 10),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: DashedDivider()),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: DropdownButtonFormField<Payment>(
                    validator: (value) {
                      if (value == null) {
                        return "Debe seleccionar una forma de pago";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                    value: payment,
                    hint: Text("Seleccione forma de pago",
                        style: TextStyle(fontSize: 13, color: Colors.black)),
                    onChanged: (Payment newValue) {
                      if (newValue.name.trim() != "transferencia") {
                        ShoppingCartInfo.of(context)
                            .payment
                            .confirmationTicket = "";
                      }
                      ShoppingCartInfo.of(context).payment.id =
                          newValue.getId();
                      ShoppingCartInfo.update(context);
                      setState(() {
                        payment = newValue;
                      });
                    },
                    items: widget.payments
                        .map<DropdownMenuItem<Payment>>((Payment value) {
                      return DropdownMenuItem<Payment>(
                        value: value,
                        child: Text(value.name,
                            style:
                                TextStyle(fontSize: 13, color: Colors.black)),
                      );
                    }).toList(),
                  )),
              if (payment != null && payment.name.trim() == "transferencia")
                paymentData(),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: DashedDivider()),
              Container(
                width: MediaQuery.of(context).size.width * .75,
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total:",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "${cuc.toStringAsFixed(2)} CUC",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${usd.toStringAsFixed(2)} USD",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${cup.toStringAsFixed(2)} CUP",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget paymentData() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "Cuenta: ${payment.accountNumber}",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Text(
            "No confirmación: ${payment.confirmationPhone}",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          constraints: BoxConstraints(minHeight: 30),
          width: MediaQuery.of(context).size.width * .75,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          padding: const EdgeInsets.only(left: 10),
          decoration:
              BoxDecoration(border: Border.all(width: 0.5, color: Colors.grey)),
          child: TextFormField(
            style: TextStyle(fontSize: 12, color: Colors.grey),
            decoration: InputDecoration(
                hintText: "Número de transacción",
                contentPadding: EdgeInsets.only(top: 8),
                border: InputBorder.none),
            validator: (value) {
              if (value.isEmpty) {
                return "Campo obligatorio";
              }
              return null;
            },
            autovalidate: widget.autovalidate,
            keyboardType: TextInputType.text,
            onSaved: (value) {
              ShoppingCartInfo.of(context).payment.confirmationTicket = value;
              ShoppingCartInfo.update(context);
            },
          ),
        ),
      ],
    );
  }
}
