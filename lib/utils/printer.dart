import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/models/order_model.dart';
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

  printOrderTemplate(NetworkPrinter printer, List<OrderModel> orders,
      bool isDelivery, String destination) async {
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
      'SNACKS - PEDIDOS',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    printer.emptyLines(2);
    printer.hr();
    printer.emptyLines(1);

    for (var e in orders) {
      printer.row([
        PosColumn(text: e.amount.toString(), width: 1),
        PosColumn(
            text: '${e.item.title} - ${e.option_selected["title"]}', width: 11),
      ]);
      printer.row([
        PosColumn(text: e.observations, width: 12),
      ]);
      String extras = "";

      if (e.extras.isEmpty) {
        extras = "Nenhum";
      } else {
        e.extras.map((e) {});
        for (var i = 0; i < e.extras.length; i++) {
          extras += e.extras[i]["title"];
          if (i < e.extras.length - 1) {
            extras += ", ";
          }
        }
      }

      printer.row([
        PosColumn(text: "Adicionais", width: 3),
        PosColumn(text: extras, width: 9),
      ]);
    }
    printer.emptyLines(1);
    printer.hr();
    printer.emptyLines(1);
    if (isDelivery) {
      printer.text(
        'Endereço para entrega: $destination',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );
    } else {
      printer.text(
        'Mesa $destination',
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

  printOrders(context, String ip, List<OrderModel> orders, bool isDelivery,
      String destination) async {
    print("try connect...");
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    try {
      // await Socket.connect(ip, 9100)
      //     .then((value) => print(value.remoteAddress))
      //     .catchError((err) => print(err));
      // print(socket.socket);

      var res = await printer.connect(ip,
          port: 9100, timeout: const Duration(seconds: 15));

      print("connected.");

      if (res == PosPrintResult.success) {
        // printImageOrderTemplate(printer);
        printOrderTemplate(printer, orders, isDelivery, destination);
        // printer.beep();
        // printer.
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
