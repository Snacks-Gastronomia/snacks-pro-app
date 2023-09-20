import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../core/app.text.dart';
import '../../../../services/items_service.dart';

import '../../repository/items_repository.dart';

class AddOrderManual extends StatefulWidget {
  const AddOrderManual({super.key});

  @override
  State<AddOrderManual> createState() => _AddOrderManualState();
}

class _AddOrderManualState extends State<AddOrderManual> {
  final Map<String, double> restaurantMenu = {
    'Hamburguer': 10.99,
    'Pizza': 12.99,
    'Sushi': 18.99,
    'Salada': 6.99,
    'Refrigerante': 2.99,
  };

  List<String> suggestions = [];

  final TextEditingController _controller = TextEditingController();

  void _updateSuggestions(String query) {
    setState(() {
      suggestions = restaurantMenu.keys
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Adicionar pedidos manual',
                style: AppTextStyles.bold(20),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {},
                child: const CircleAvatar(
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Hora do pedido",
            style: AppTextStyles.medium(14),
          ),
          DottedBorder(
            color: Colors.grey,
            strokeWidth: 1.5,
            dashPattern: const [7, 4],
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            child: TextFormField(
              maxLines: 1,
              maxLength: 30,
              decoration: InputDecoration(
                counterText: "",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(0),
                ),
                hintText: "Ex.: 22:03",
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Selecione os items",
            style: AppTextStyles.medium(14),
          ),
          DottedBorder(
            color: Colors.grey,
            strokeWidth: 1.5,
            dashPattern: const [7, 4],
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            child: TextFormField(
              maxLines: 1,
              maxLength: 30,
              decoration: InputDecoration(
                counterText: "",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(0),
                ),
                hintText: "Pesquise o nome do item",
              ),
              controller: _controller,
              onChanged: _updateSuggestions,
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: 150,
            child: _controller.text == ''
                ? Container()
                : ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      double price = restaurantMenu[suggestions[index]] ?? 0.0;
                      return ListTile(
                        title: Text(suggestions[index]),
                        trailing: Text('\$${price.toStringAsFixed(2)}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
