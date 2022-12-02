import 'dart:io';

// import 'package:esc_pos_printer/esc_pos_printer/enums';

// import './connect.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/models/order_model.dart';
import 'package:snacks_pro_app/utils/printer_connection.dart';
import 'package:snacks_pro_app/utils/printer_enums.dart';
import 'package:snacks_pro_app/utils/toast.dart';
// import "";

class AppPrinter {
  printNFETemplate(AppNetworkPrinter printer) {}
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

  printImageOrderTemplate(AppNetworkPrinter printer) async {
    // try {
    final ByteData data = await rootBundle.load('assets/icons/logo.png');
    final Uint8List bytes = data.buffer.asUint8List();

    print(bytes.length);
    final Image? image = decodeImage(bytes);

    if (image != null) {
      // printer.imageRaster(image);
      // printer.imageRaster(image, imageFn: PosImageFn.graphics);

      printer.image(image);
    }
  }

  printOrderTemplate(AppNetworkPrinter printer, List<Order> orders) async {
    // print("printing order...");
    // final ByteData data = await rootBundle.load('assets/icons/snacks.svg');
    // final Uint8List bytes = data.buffer.asUint8List();

    // final Image? image = decodeImage(bytes);

    // if (image != null) {
    //   printer.image(image);
    // }
    //   print("image null")
    printer.text('SNACKS',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true),
        linesAfter: 1);

    printer.text('889  Watson Lane', styles: PosStyles(align: PosAlign.center));
    printer.text('New Braunfels, TX',
        styles: const PosStyles(align: PosAlign.center));
    printer.text('Tel: 830-221-1234',
        styles: const PosStyles(align: PosAlign.center));
    // printer.text('Web: www.example.com',
    //     styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    printer.hr();
    printer.text('Pedidos',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    printer.hr();
    // printer.row([
    //   PosColumn(text: 'Qty', width: 1),
    //   PosColumn(text: 'Item', width: 7),
    //   PosColumn(
    //       text: 'Price', width: 2, styles: PosStyles(align: PosAlign.right)),
    //   PosColumn(
    //       text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
    // ]);

    orders.map((e) {
      printer.row([
        PosColumn(text: e.amount.toString(), width: 2),
        PosColumn(text: e.item.title, width: 10),
      ]);
      printer.row([
        PosColumn(text: e.observations, width: 12),
      ]);
    });

    // printer.row([
    //   PosColumn(text: '2', width: 1),
    //   PosColumn(text: 'ONION RINGS', width: 7),
    //   PosColumn(
    //       text: '0.99', width: 2, styles: PosStyles(align: PosAlign.right)),
    //   PosColumn(
    //       text: '1.98', width: 2, styles: PosStyles(align: PosAlign.right)),
    // ]);
    // printer.row([
    //   PosColumn(text: '1', width: 1),
    //   PosColumn(text: 'PIZZA', width: 7),
    //   PosColumn(
    //       text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
    //   PosColumn(
    //       text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
    // ]);
    // printer.row([
    //   PosColumn(text: '1', width: 1),
    //   PosColumn(text: 'SPRING ROLLS', width: 7),
    //   PosColumn(
    //       text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
    //   PosColumn(
    //       text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
    // ]);
    // printer.row([
    //   PosColumn(text: '3', width: 1),
    //   PosColumn(text: 'CRUNCHY STICKS', width: 7),
    //   PosColumn(
    //       text: '0.85', width: 2, styles: PosStyles(align: PosAlign.right)),
    //   PosColumn(
    //       text: '2.55', width: 2, styles: PosStyles(align: PosAlign.right)),
    // ]);
    printer.hr();

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

  printOrders(context, String ip, List<Order> orders) async {
    print("try connect...");
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = AppNetworkPrinter(paper, profile);
    try {
      await Socket.connect(ip, 9100)
          .then((value) => print(value.remoteAddress))
          .catchError((err) => print(err));
      // print(socket.socket);
      // printer.beep();

      var res = await printer.connect(ip,
          port: 9100, timeout: const Duration(seconds: 15));

      print("connected.");

      if (res == PosPrintResult.success) {
        // printImageOrderTemplate(printer);
        printOrderTemplate(printer, orders);
        printer.disconnect();
        print("disconnected");
      } else {
        var toast = AppToast();
        toast.showToast(
            context: context,
            content: "Não foi possível imprimir o pedido",
            type: ToastType.error);
      }
    } catch (e) {
      print(e);
      // printer.reset();
      print("error socket");
    }
  }
}
