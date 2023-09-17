import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

const textInputDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.white,
            width: 2
        )
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.pinkAccent,
            width: 2
        )
    ),
    fillColor: Vx.white,
    filled: true,
    hintText: "Enter Email Id",
    label: Text("Email Id")
);