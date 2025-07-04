import 'dart:io';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final _artistController = TextEditingController();
  final _songNameController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedAudio;
  File? selectedImage;
  final _formKey = GlobalKey<FormState>();

  void selectAudio() async {
    final pickedAudio = await pickAudio();

    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    _artistController.dispose();
    _songNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref
                    .read(homeViewmodelProvider.notifier)
                    .uploadSong(
                      song: selectedAudio!,
                      thumbnail: selectedImage!,
                      songName: _songNameController.text,
                      artist: _artistController.text,
                      color: selectedColor,
                    );
              } else {
                showSnackBar(context, 'Missing fields!');
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: selectImage,
                  child:
                      selectedImage != null
                          ? SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          : DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              color: Pallete.borderColor,
                              radius: const Radius.circular(10),
                              dashPattern: [10, 5],
                              strokeWidth: 1,
                              strokeCap: StrokeCap.round,
                              padding: EdgeInsets.all(16),
                            ),
                            child: const SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.folder_open, size: 40),
                                  SizedBox(height: 15),
                                  Text(
                                    'Select the thumbnail for your song',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                ),
                const SizedBox(height: 40),
                selectedAudio != null
                    ? AudioWave(path: selectedAudio!.path)
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OutlinedButton(
                          onPressed: selectAudio,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.music_note, size: 20),
                              const Text(
                                'Select the audio file for your song',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                const SizedBox(height: 20),
                CustomField(
                  hintText: "Artist",
                  labelText: "Artist",
                  controller: _artistController,
                ),
                const SizedBox(height: 20),
                CustomField(
                  hintText: "Song name",
                  labelText: "Song name",
                  controller: _songNameController,
                ),
                const SizedBox(height: 20),
                ColorPicker(
                  color: selectedColor,
                  pickersEnabled: const <ColorPickerType, bool>{
                    ColorPickerType.wheel: true,
                  },
                  onColorChanged: (Color color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  heading: const Text('Select color'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
