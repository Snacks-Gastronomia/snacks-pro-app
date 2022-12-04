import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';

class AddBankAccountScreen extends StatefulWidget {
  const AddBankAccountScreen({Key? key}) : super(key: key);

  @override
  State<AddBankAccountScreen> createState() => _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends State<AddBankAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: ElevatedButton(
            onPressed: () =>
                BlocProvider.of<FinanceCubit>(context).saveBankData(context),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.black,
                fixedSize: const Size(double.maxFinite, 59)),
            child: Text(
              'Salvar',
              style: AppTextStyles.regular(16, color: Colors.white),
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(41, 41)),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.black,
                      size: 19,
                    )),
                SvgPicture.asset(
                  "assets/icons/snacks_logo.svg",
                  height: 30,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          final bank_data = context.read<FinanceCubit>().state.bankInfo;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Dados bancários',
                  style: AppTextStyles.semiBold(30),
                ),
                const SizedBox(
                  height: 50,
                ),
                //text 8391A1
                TextFormField(
                  style:
                      AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                  onChanged:
                      BlocProvider.of<FinanceCubit>(context).changeBankOwner,
                  controller: TextEditingController(text: bank_data.owner),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    fillColor: const Color(0xffF7F8F9),
                    filled: true,
                    hintStyle: AppTextStyles.medium(16,
                        color: const Color(0xff8391A1).withOpacity(0.5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1)),
                    hintText: 'Nome do titular',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<String>(
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        fillColor: const Color(0xffF7F8F9),
                        filled: true,
                        hintStyle: AppTextStyles.medium(16,
                            color: const Color(0xff8391A1).withOpacity(0.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1)),
                        hintText: 'Banco',
                      ),
                    ),
                    compareFn: (i, s) => i.compareTo(s) == 0,
                    popupProps: PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                      showSearchBox: true,
                      listViewProps:
                          const ListViewProps(physics: BouncingScrollPhysics()),
                      modalBottomSheetProps: const ModalBottomSheetProps(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25)))),
                      itemBuilder: _customPopupItemBuilderExample2,
                      containerBuilder: (context, popupWidget) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: popupWidget,
                      ),
                      searchFieldProps: TextFieldProps(
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          fillColor: const Color(0xffF7F8F9),
                          filled: true,
                          hintStyle: AppTextStyles.medium(16,
                              color: const Color(0xff8391A1).withOpacity(0.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1)),
                          suffixIcon: const Icon(Icons.search_rounded),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1)),
                          hintText: 'Nome ou código do banco...',
                        ),
                      ),
                      emptyBuilder: (context, searchEntry) => Center(
                        child: Text(
                          "$searchEntry não foi encontrado!",
                          style: AppTextStyles.regular(14,
                              color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                    onChanged: (value) => context
                        .read<FinanceCubit>()
                        .changeBankName(value ?? ""),
                    selectedItem:
                        bank_data.bank.isEmpty ? null : bank_data.bank,
                    asyncItems: (text) =>
                        context.read<FinanceCubit>().fetchBanks()),
                // const SizedBox(
                //   height: 10,
                // ),
                // TextFormField(
                //   style:
                //       AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                //   onChanged:
                //       BlocProvider.of<FinanceCubit>(context).changeBankName,
                //   textInputAction: TextInputAction.next,
                //   controller: TextEditingController(text: bank_data.bank),
                //   decoration: InputDecoration(
                //     fillColor: const Color(0xffF7F8F9),
                //     filled: true,
                //     hintStyle: AppTextStyles.medium(16,
                //         color: const Color(0xff8391A1).withOpacity(0.5)),
                //     enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(8),
                //         borderSide: const BorderSide(
                //             color: Color(0xffE8ECF4), width: 1)),
                //     border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(8),
                //         borderSide: const BorderSide(
                //             color: Color(0xffE8ECF4), width: 1)),
                //     hintText: 'Banco',
                //   ),
                // ),

                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style:
                      AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                  onChanged:
                      BlocProvider.of<FinanceCubit>(context).changeBankAgency,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: bank_data.agency),
                  decoration: InputDecoration(
                    fillColor: const Color(0xffF7F8F9),
                    filled: true,
                    hintStyle: AppTextStyles.medium(16,
                        color: const Color(0xff8391A1).withOpacity(0.5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1)),
                    hintText: 'Agência',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style:
                      AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                  onChanged:
                      BlocProvider.of<FinanceCubit>(context).changeBankAccount,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: TextEditingController(text: bank_data.account),
                  decoration: InputDecoration(
                    fillColor: const Color(0xffF7F8F9),
                    filled: true,
                    hintStyle: AppTextStyles.medium(16,
                        color: const Color(0xff8391A1).withOpacity(0.5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1)),
                    hintText: 'Conta corrente',
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

Widget _customPopupItemBuilderExample2(
  BuildContext context,
  dynamic item,
  bool isSelected,
) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
    child: ListTile(
      selected: isSelected,
      title: Text(item ?? ''),
      // leading: CircleAvatar(
      //     // this does not work - throws 404 error
      //     // backgroundImage: NetworkImage(item.avatar ?? ''),
      //     ),
    ),
  );
}
