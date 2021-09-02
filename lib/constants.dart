
import 'dart:ui';

import 'package:flutter/material.dart';

const String FETCH_CHORD_NOTES_BY_FRAME_URL = 'http://18.189.175.253:82/fetch_chord_dots_by_frame';
const String HELLO_WORLD_URL = 'http://18.189.175.253:82/test';

const String NUM_NOTES_JSON_KEY = 'numOfNotes';
const String X_JSON_KEY = 'x';
const String Y_JSON_KEY = 'y';
const String NOTES_COORDINAES_JSON_KEY = 'notes_coordinates';
const double SIZE_NOTE = 17;
const Color COLOR_NOTE = const Color(0xFF80ffd4);
const BoxShape NOTE_SHAPE = BoxShape.circle;

/*
From the server:
cd ~/flaskServer
sudo flask run -p 80 --host=0.0.0.0
*/