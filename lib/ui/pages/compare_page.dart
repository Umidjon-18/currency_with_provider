import 'package:currency_with_provider/data/provider/compare_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/currency_model.dart';
import '../../utils/constants.dart';
import '../../utils/hive_utils.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/item_exchange.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({Key? key}) : super(key: key);

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> with HiveUtil {
  late CompareProvider compareProvider =CompareProvider();

  @override
  void dispose() {
    compareProvider.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompareProvider>(builder: (context, provider, child) {
      if (provider.state == ComparePageState.isInit) {
        Future.delayed(Duration.zero,(){
        provider.focuseChecker();
        provider.loadData();
  });
      }
      return Scaffold(
          backgroundColor: const Color(0xff1f2235),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  customAppBar(),
                  if (provider.state == ComparePageState.isDone)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      decoration: BoxDecoration(
                        color: const Color(0xff2d334d),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Exchange',
                                style: kTextStyle(size: 16, fontWeight: FontWeight.w600),
                              ),
                              IconButton(
                                onPressed: () {},
                                iconSize: 20,
                                icon: const Icon(
                                  Icons.settings,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                children: [
                                  itemExch(context, provider.editingControllerTop, provider.topCur,
                                      provider.topFocus, ((value) {
                                    if (value is CurrencyModel) {
                                      provider.topCur = value;
                                      provider.updatePage();
                                    }
                                  }), provider),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  itemExch(context, provider.editingControllerBottom, provider.bottomCur,
                                      provider.bottomFocus, ((value) {
                                    if (value is CurrencyModel) {
                                      provider.bottomCur = value;
                                      provider.updatePage();
                                    }
                                  }), provider),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  provider.exchanger();
                                  provider.updatePage();
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff2d334d),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white12),
                                  ),
                                  child: const Icon(
                                    Icons.currency_exchange,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  else if (provider.state == ComparePageState.isError)
                    Expanded(
                      child: Center(
                        child: Text(
                          'Error',
                          style: kTextStyle(size: 18),
                        ),
                      ),
                    )
                  else
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ));
    });
  }
}