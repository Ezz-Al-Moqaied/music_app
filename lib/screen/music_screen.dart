import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:music_app/model/menuItem.dart';
import 'package:piano/piano.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final _flutterMidi = FlutterMidi();

  final List<String> _valueMusic = [
    'assets/sf2/grand.sf2',
    'assets/sf2/guitars.sf2',
    'assets/sf2/flute.sf2',
  ];

  int indexMusic = 0;

  @override
  void initState() {
    if (!kIsWeb) {
      load(_valueMusic[indexMusic]);
    } else {
      _flutterMidi.prepare(sf2: null);
    }
    super.initState();
  }

  void load(String asset) async {
    print('Loading File...');
    _flutterMidi.unmute();
    ByteData _byte = await rootBundle.load(asset);
    _flutterMidi.prepare(sf2: _byte);
  }

  void _play(int midi) {
    if (kIsWeb) {
      print(true);
    } else {
      _flutterMidi.playMidiNote(midi: midi);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi instruments"),
        centerTitle: true,
        leading: const Icon(Icons.call_outlined),
        actions: [
          PopupMenuButton<MenuItems>(
            onSelected: (value) {
              if (value == MenuItems.grand) {
                indexMusic = 0;
                initState();
              } else if (value == MenuItems.guitars) {
                indexMusic = 1;
                initState();
              } else {
                indexMusic = 2;
                initState();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: MenuItems.grand,
                  child: Text(
                    "grand",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: indexMusic == 0
                            ? FontWeight.bold
                            : FontWeight.normal),
                  )),
              PopupMenuItem(
                  value: MenuItems.guitars,
                  child: Text(
                    "guitars",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: indexMusic == 1
                            ? FontWeight.bold
                            : FontWeight.normal),
                  )),
              PopupMenuItem(
                  value: MenuItems.flute,
                  child: Text(
                    "flute",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: indexMusic == 2
                            ? FontWeight.bold
                            : FontWeight.normal),
                  )),
            ],
          )
        ],
      ),
      body: Center(
        child: InteractivePiano(
          highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
          naturalColor: Colors.white,
          accidentalColor: Colors.black,
          keyWidth: 60,
          noteRange: NoteRange.forClefs([
            Clef.Treble,
          ]),
          onNotePositionTapped: (position) {
            _play(position.pitch);
          },
        ),
      ),
    );
  }
}
