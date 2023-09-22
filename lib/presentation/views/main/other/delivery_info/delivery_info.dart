import 'package:eshop/core/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../data/models/user/delivery_info_model.dart';
import '../../../../../domain/entities/user/delivery_info.dart';
import '../../../../blocs/delivery_info/delivery_info_add/delivery_info_add_cubit.dart';
import '../../../../blocs/delivery_info/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import '../../../../widgets/delivery_info_card.dart';
import '../../../../widgets/input_form_button.dart';
import '../../../../widgets/input_text_form_field.dart';
import '../../../../widgets/outline_label_card.dart';

class DeliveryInfoView extends StatefulWidget {
  const DeliveryInfoView({Key? key}) : super(key: key);

  @override
  State<DeliveryInfoView> createState() => _DeliveryInfoViewState();
}

class _DeliveryInfoViewState extends State<DeliveryInfoView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Delivery Details"),
        ),
        body: BlocBuilder<DeliveryInfoFetchCubit, DeliveryInfoFetchState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: (state is DeliveryInfoFetchLoading &&
                      state.deliveryInformation.isEmpty)
                  ? 5
                  : state.deliveryInformation.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemBuilder: (context, index) =>
                  (state is DeliveryInfoFetchLoading &&
                          state.deliveryInformation.isEmpty)
                      ? const DeliveryInfoCard()
                      : DeliveryInfoCard(
                          deliveryInformation: state.deliveryInformation[index],
                          // isSelected: true,
                        ),
            );
          },
        ),
        floatingActionButton: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  builder: (BuildContext context) {
                    return const DeliveryInfoForm();
                  },
                );
              },
              tooltip: 'Increment',
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeliveryInfoForm extends StatefulWidget {
  final DeliveryInfo? deliveryInfo;
  const DeliveryInfoForm({
    super.key,
    this.deliveryInfo,
  });

  @override
  State<DeliveryInfoForm> createState() => _DeliveryInfoFormState();
}

class _DeliveryInfoFormState extends State<DeliveryInfoForm> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController addressLineOne = TextEditingController();
  final TextEditingController addressLineTwo = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController zipCode = TextEditingController();
  final TextEditingController contactNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.deliveryInfo != null) {
      firstName.text = widget.deliveryInfo!.firstName;
      lastName.text = widget.deliveryInfo!.lastName;
      addressLineOne.text = widget.deliveryInfo!.addressLineOne;
      addressLineTwo.text = widget.deliveryInfo!.addressLineTwo;
      city.text = widget.deliveryInfo!.city;
      zipCode.text = widget.deliveryInfo!.zipCode;
      contactNumber.text = widget.deliveryInfo!.contactNumber;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeliveryInfoAddCubit, DeliveryInfoAddState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is DeliveryInfoAddLoading) {
          EasyLoading.show(status: 'Loading...');
        } else if (state is DeliveryInfoAddSuccess) {
          Navigator.of(context).pop();
          context
              .read<DeliveryInfoFetchCubit>()
              .addDeliveryInfo(state.deliveryInfo);
          EasyLoading.showSuccess("Delivery info successfully added!");
        } else if (state is DeliveryInfoAddFail) {
          EasyLoading.showError("Error");
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  const SizedBox(
                    height: 24,
                  ),
                  InputTextFormField(
                    controller: firstName,
                    hint: 'First name',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This field can\'t be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputTextFormField(
                    controller: lastName,
                    hint: 'Last name',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This field can\'t be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputTextFormField(
                    controller: addressLineOne,
                    hint: 'Address line one',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This field can\'t be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputTextFormField(
                    controller: addressLineTwo,
                    hint: 'Address line two',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This field can\'t be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputTextFormField(
                    controller: city,
                    hint: 'City',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This field can\'t be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputTextFormField(
                    controller: zipCode,
                    hint: 'Zip code',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This field can\'t be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InputTextFormField(
                    controller: contactNumber,
                    hint: 'Contact number',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This field can\'t be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  InputFormButton(
                    color: Colors.black87,
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.deliveryInfo == null) {
                          context
                              .read<DeliveryInfoAddCubit>()
                              .addDeliveryInfo(DeliveryInfoModel(
                                id: '',
                                firstName: firstName.text,
                                lastName: lastName.text,
                                addressLineOne: addressLineOne.text,
                                addressLineTwo: addressLineTwo.text,
                                city: city.text,
                                zipCode: zipCode.text,
                                contactNumber: contactNumber.text,
                              ));
                        }
                      }
                    },
                    titleText: widget.deliveryInfo == null ? 'Save' : 'Update',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InputFormButton(
                    color: Colors.black87,
                    onClick: () {
                      Navigator.of(context).pop();
                    },
                    titleText: 'Cancel',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
