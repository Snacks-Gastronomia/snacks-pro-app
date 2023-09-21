import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

import '../../../../core/app.text.dart';
import '../../../../models/item_model.dart';

class AddOrderManual extends StatefulWidget {
  const AddOrderManual({super.key});

  @override
  State<AddOrderManual> createState() => _AddOrderManualState();
}

class _AddOrderManualState extends State<AddOrderManual> {
  List<String> restaurantMenu = [];
  List<Item> suggestions = [];

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return StreamBuilder<QuerySnapshot>(
          stream: state.menu,
          builder: (context, snapshot) {
            final List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];
            for (int i = 0; i < docs.length; i++) {
              var itemData = docs[i].data();
              var item = Item.fromJson(jsonEncode(itemData));
              restaurantMenu.add(item.title);
            }
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
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
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return restaurantMenu.where((String item) {
                          return item
                              .contains(textEditingValue.text.toLowerCase());
                        }).toList();
                      },
                      onSelected: (String item) {
                        print('$item selecionado');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 200,
                  )
                ],
              ),
            );
          });
    });
  }
}
