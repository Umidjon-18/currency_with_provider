import 'package:flutter/material.dart';

import '../../utils/constants.dart';

Widget customAppBar() {
  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: '',
                          style: kTextStyle(size: 16),
                          children: [
                            TextSpan(
                              text: 'Currency App',
                              style: kTextStyle(
                                  size: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white12),
                          ),
                          child: const Icon(
                            Icons.more_vert,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  );
}
