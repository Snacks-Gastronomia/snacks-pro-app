import 'package:flutter/material.dart';

enum AppStatus { initial, loading, loaded, editing, error }

enum OrderStatus {
  waiting_payment,
  ready_to_start,
  order_in_progress,
  done,
  waiting_delivery,
  in_delivery,
  delivered,
  invalid
}

enum AppPermission { employee, cashier, waiter, radm, sadm }

extension ParseToStringFromDisplay on String {
  AppPermission get stringLabelToEnum {
    switch (this) {
      case "Caixa":
        return AppPermission.cashier;
      case "Garçom":
        return AppPermission.waiter;
      case "Funcionário do restaurante":
        return AppPermission.employee;
      case "Snacks administrador":
        return AppPermission.sadm;
      case "Restaurante administrador":
        return AppPermission.radm;
      default:
        return AppPermission.employee;
    }
  }

  AppPermission get stringToEnum {
    switch (this) {
      case "cashier":
        return AppPermission.cashier;
      case "waiter":
        return AppPermission.waiter;
      case "sadm":
        return AppPermission.sadm;
      case "radm":
        return AppPermission.radm;
      default:
        return AppPermission.employee;
    }
  }
}

extension ParseToStringName on AppPermission {
  String get displayEnum {
    switch (this) {
      case AppPermission.cashier:
        return "Caixa";
      case AppPermission.waiter:
        return "Garçom";
      case AppPermission.employee:
        return "Funcionário do restaurante";
      case AppPermission.sadm:
        return "Snacks administrador";
      case AppPermission.radm:
        return "Restaurante administrador";
      default:
        return "Status inválido";
    }
  }
}

extension ParseToString on OrderStatus {
  String get displayEnum {
    switch (this) {
      case OrderStatus.waiting_payment:
        return "Aguardando pagamento";
      case OrderStatus.ready_to_start:
        return "Pedido pronto para começar";
      case OrderStatus.order_in_progress:
        return "Pedido em andamento";
      case OrderStatus.done:
        return "Pedido pronto";
      case OrderStatus.waiting_delivery:
        return "Aguardando motoboy";
      case OrderStatus.in_delivery:
        return "Pedido à caminho";
      default:
        return "Status inválido";
    }
  }

  Color get getColor {
    switch (this) {
      case OrderStatus.waiting_payment:
        return Colors.black;
      case OrderStatus.order_in_progress:
        return Colors.blue.shade400;
      case OrderStatus.done:
        return Colors.green.shade400;
      case OrderStatus.in_delivery:
        return Colors.green.shade700;

      default:
        return Colors.black;
    }
  }
}
