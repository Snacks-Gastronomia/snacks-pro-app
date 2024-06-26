import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/models/order_model.dart';
import 'package:snacks_pro_app/models/order_response.dart';
import 'package:snacks_pro_app/utils/toast.dart';
// import "";

class AppPrinter {
  printNFETemplate(NetworkPrinter printer) {}
  Future<Image> resizeImg(String path) async {
    String imageUrl = 'http://example.co.in/images/$path.png';
    // http.Response response = await http.get(path);
    // Uint8List bytes = response.bodyBytes;
    final ByteData data = await rootBundle.load('assets/icons/logo.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final Image? imgs = decodeImage(bytes);
    final Image ig = copyResize(imgs!, height: 150, width: 120);
    return ig;
  }

  printImageOrderTemplate(NetworkPrinter printer) async {
    // try {
    final ByteData data = await rootBundle.load('assets/icons/snacks.png');
    final Uint8List bytes = data.buffer.asUint8List();

    final Image? image = decodeImage(bytes);

    print("imprimindo");

    if (image != null) {
      // printer.imageRaster(image);
      // printer.imageRaster(image, imageFn: PosImageFn.graphics);

      printer.image(image);
    }
  }

  printOrderTemplate(
      {required NetworkPrinter printer,
      required List<ItemResponse> orders,
      required bool isDelivery,
      required String deliveryValue,
      required String orderDestination,
      required String method,
      required String total,
      required String orderCode,
      required String phone_number,
      required String customer_name}) async {
    // print("printing order...");
    // final ByteData data = await rootBundle.load('assets/icons/snacks.png');
    // final Uint8List bytes = data.buffer.asUint8List();

    // final Image? image = decodeImage(bytes);

    // printer.imageRaster(image!);
    // printer.imageRaster(image, imageFn: PosImageFn.graphics);

    // if (image != null) {
    //   printer.image(image);
    // }
    //   print("image null")
    // printer.text('SNACKS - PEDIDOS',
    //     styles: const PosStyles(
    //         align: PosAlign.center,
    //         height: PosTextSize.size2,
    //         width: PosTextSize.size2,
    //         bold: true),
    //     linesAfter: 1);

    // printer.text('889  Watson Lane', styles: PosStyles(align: PosAlign.center));
    // printer.text('New Braunfels, TX',
    //     styles: const PosStyles(align: PosAlign.center));
    // printer.text('Tel: 830-221-1234',
    //     styles: const PosStyles(align: PosAlign.center));
    // printer.text('Web: www.example.com',
    //     styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    // printer.hr();
    printer.text(
      'SNACKS - PEDIDO #$orderCode',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    printer.text(
      customer_name,
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size3,
        width: PosTextSize.size3,
      ),
    );
    printer.text(
      phone_number,
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size3,
        width: PosTextSize.size3,
      ),
    );
    printer.emptyLines(1);
    printer.hr();
    printer.emptyLines(1);

    for (var e in orders) {
      printer.row([
        PosColumn(text: e.amount.toString(), width: 1),
        PosColumn(
            text: '${e.item.title} - ${e.optionSelected.title}', width: 10),
        PosColumn(text: '${e.optionSelected.value}', width: 1),
      ]);
      printer.row([
        PosColumn(text: e.observations ?? "", width: 12),
      ]);
      printer.row([
        PosColumn(text: "Adicionais", width: 12),
      ]);
      if (e.extras!.isEmpty) {
        printer.row([
          PosColumn(text: "- Nenhum", width: 12),
        ]);
      } else {
        for (var i = 0; i < e.extras!.length; i++) {
          var extra = '+ ${e.extras![i]["title"]}';
          printer.row([
            PosColumn(text: extra, width: 12),
          ]);
        }
      }
    }
    printer.emptyLines(1);
    printer.hr();
    if (isDelivery) {
      printer.row([
        PosColumn(text: "Entrega", width: 10),
        PosColumn(text: '+$deliveryValue', width: 2),
      ]);
    }
    printer.row([
      PosColumn(text: "Pagamento", width: 10),
      PosColumn(text: method, width: 2),
    ]);
    printer.row([
      PosColumn(text: "Total", width: 10),
      PosColumn(text: total, width: 2),
    ]);
    printer.hr();
    printer.emptyLines(1);
    if (isDelivery) {
      printer.text(
        'Endereço para entrega: $orderDestination',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
        ),
      );
    } else {
      printer.text(
        'Mesa $orderDestination',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );
    }
    printer.emptyLines(1);
    // printer.row([
    //   PosColumn(
    //       text: 'TOTAL',
    //       width: 6,
    //       styles: const PosStyles(
    //         height: PosTextSize.size2,
    //         width: PosTextSize.size2,
    //       )),
    //   PosColumn(
    //       text: '\$10.97',
    //       width: 6,
    //       styles: const PosStyles(
    //         align: PosAlign.right,
    //         height: PosTextSize.size2,
    //         width: PosTextSize.size2,
    //       )),
    // ]);

    // printer.hr(ch: '=', linesAfter: 1);

    // printer.row([
    //   PosColumn(
    //       text: 'Cash',
    //       width: 8,
    //       styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    //   PosColumn(
    //       text: '\$15.00',
    //       width: 4,
    //       styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    // ]);
    // printer.row([
    //   PosColumn(
    //       text: 'Change',
    //       width: 8,
    //       styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    //   PosColumn(
    //       text: '\$4.03',
    //       width: 4,
    //       styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    // ]);

    printer.feed(2);
    // printer.text('Thank you!',
    //     styles: PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    printer.text(timestamp,
        styles: const PosStyles(align: PosAlign.center), linesAfter: 2);

    printer.feed(1);
    printer.cut();
  }

  printOrders(
      context,
      String ip,
      List<ItemResponse> orders,
      String deliveryValue,
      bool isDelivery,
      String destination,
      String total,
      String code,
      String method,
      String customer,
      String phone_number) async {
    print("try connect...");
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    //printer.setGlobalCodeTable("CP1252");

    var toast = AppToast();
    print(deliveryValue);
    try {
      var res = await printer.connect(ip,
          port: 9100, timeout: const Duration(seconds: 15));

      print("connected.");

      if (res == PosPrintResult.success) {
        printer.beep();
        printOrderTemplate(
            printer: printer,
            orders: orders,
            isDelivery: isDelivery,
            deliveryValue: deliveryValue,
            orderDestination: destination,
            method: method,
            phone_number: phone_number,
            total: total,
            orderCode: code,
            customer_name: customer);

        printer.disconnect();
      } else {
        toast.showToast(
            context: context,
            content: "Não foi possível imprimir o pedido",
            type: ToastType.error);
      }
    } catch (e) {
      toast.showToast(
          context: context,
          content: "Não foi possível imprimir o pedido: $e",
          type: ToastType.error);
      // printer.reset();
      print("error socket");
    }
  }
}
