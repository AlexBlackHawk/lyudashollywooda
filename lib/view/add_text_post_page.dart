import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../new_post_bloc/new_post_bloc.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

class AddNewPostPage extends StatefulWidget {
  const AddNewPostPage({super.key, required this.userInfo, required this.userId});

  final Map<String, dynamic> userInfo;
  final String userId;

  @override
  State<AddNewPostPage> createState() => _AddNewPostPageState();
}

class _AddNewPostPageState extends State<AddNewPostPage> {

  late FocusNode titleFocusNode;
  late FocusNode descriptionFocusNode;

  final Map<String, String> categories = <String, String>{
    "Сімʼя": "assets/chip_images/img.png",
    "Стиль": "assets/chip_images/img_5.png",
    "Заробіток": "assets/chip_images/img_1.png",
    "Правильне харчування": "assets/chip_images/img_3.png",
    "Розвиток дітей": "assets/chip_images/img_4.png",
    "Спорт і схуднення": "assets/chip_images/img_2.png",
  };

  @override
  void initState() {
    super.initState();

    titleFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewPostBloc, NewPostState>(
      listenWhen: (previous, current) => previous.creationStatus != current.creationStatus,
      listener: (context, state) {
        if (state.creationStatus == CreationStatus.failure) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.all(10),
              content: Text("Сталася помилка"),
              actions: [
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  child: Text(
                    textScaler: TextScaler.linear(1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    "Закрити",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.black,
                      // fontSize: MediaQuery.textScalerOf(context).scale(12)
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (state.creationStatus == CreationStatus.success) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state.creationStatus == CreationStatus.inProgress,
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              scrolledUnderElevation: 0.0,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                textScaler: TextScaler.linear(1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                "Додати допис",
                style: TextStyle(
                  fontFamily: "Inter",
                  color: Color(0xFF212121),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  // fontSize: MediaQuery.textScalerOf(context).scale(16),
                ),
              ),
              leading: Container(
                width: MediaQuery.of(context).size.height * 0.0591,
                height: MediaQuery.of(context).size.height * 0.0591,
                margin: const EdgeInsets.only(
                  left: 10,
                  // right: 10
                ),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF0F0F0),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            body: Container(
              margin: EdgeInsets.only(
                top: 10,
                bottom: MediaQuery.of(context).size.height * 0.12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    width: double.infinity,
                    height: (state.picturePath == "") ? MediaQuery.of(context).size.height * 0.6 : MediaQuery.of(context).size.height * 0.698,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            HapticFeedback.lightImpact();
                            final XFile? pickedFile = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null && context.mounted) {
                              context.read<NewPostBloc>().add(NewPostPictureChanged(picturePath: pickedFile.path));
                            }
                          },
                          child: (state.picturePath == "") ? Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xFFD9D9D9),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.height * 0.08,
                                  height: MediaQuery.of(context).size.height * 0.08,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFD9D9D9)
                                    )
                                  ),
                                  child: const Icon(
                                    Icons.insert_photo_outlined,
                                    size: 40,
                                  ),
                                ),
                                Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Додати зображення",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    color: Color(0xFF7B7B7B),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                  ),
                                )
                              ],
                            ),
                          ) : SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.21,
                            child: Image.file(File(state.picturePath), fit: BoxFit.fill,),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                          focusNode: titleFocusNode,
                          onTapOutside: (value) {
                            HapticFeedback.lightImpact();
                            titleFocusNode.unfocus();
                          },
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            context.read<NewPostBloc>().add(NewPostTitleChanged(title: value));
                          },
                          decoration: InputDecoration(
                            hintText: "Додайте заголовок",
                            hintStyle: TextStyle(
                              fontFamily: "Inter",
                              color: Color(0xFF7B7B7B),
                              fontSize: 14,
                              // fontSize: MediaQuery.textScalerOf(context).scale(14),
                              fontWeight: FontWeight.w400,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFD9D9D9),
                              ),
                              borderRadius: BorderRadius.circular(12)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(12)
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: TextField(
                            onTap: () {
                              HapticFeedback.lightImpact();
                            },
                            focusNode: descriptionFocusNode,
                            onTapOutside: (value) {
                              HapticFeedback.lightImpact();
                              descriptionFocusNode.unfocus();
                            },
                            keyboardType: TextInputType.multiline,
                            onChanged: (value) {
                              context.read<NewPostBloc>().add(NewPostContentChanged(content: value));
                            },
                            expands: true,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              hintText: "Додайте опис",
                              hintStyle: TextStyle(
                                fontFamily: "Inter",
                                color: Color(0xFF7B7B7B),
                                fontSize: 14,
                                // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                fontWeight: FontWeight.w400,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFD9D9D9),
                                ),
                                borderRadius: BorderRadius.circular(12)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(12)
                              ),
                            ),
                          )
                        ),
                        CategoryChips(),
                        // Wrap(
                        //   spacing: 10,
                        //   children: [
                        //     FilterChip(
                        //       selectedColor: Colors.white,
                        //       showCheckmark: false,
                        //       backgroundColor: Colors.white,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20),
                        //         side: BorderSide(color: state.postCategories.contains("Сімʼя") ? Colors.black : const Color(0xFFD9D9D9)),
                        //       ),
                        //       avatar: const CircleAvatar(
                        //         backgroundColor: Colors.transparent,
                        //         backgroundImage: AssetImage("assets/chip_images/img.png"),
                        //       ),
                        //       label: const Text(
                        //         textScaler: TextScaler.linear(1),
                        //         "Сімʼя",
                        //         overflow: TextOverflow.ellipsis,
                        //       ),
                        //       selected: state.postCategories.contains("Сімʼя"),
                        //       onSelected: (newState) {
                        //         if (newState) {
                        //           context.read<NewPostBloc>().add(const NewPostCategoryAdded(postCategory: "Сімʼя"));
                        //         }
                        //         else {
                        //           context.read<NewPostBloc>().add(const NewPostCategoryRemoved(postCategory: "Сімʼя"));
                        //         }
                        //       },
                        //     ),
                        //     FilterChip(
                        //       selectedColor: Colors.white,
                        //       showCheckmark: false,
                        //       backgroundColor: Colors.white,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20),
                        //         side: BorderSide(color: state.postCategories.contains("Стиль") ? Colors.black : const Color(0xFFD9D9D9)),
                        //       ),
                        //       avatar: const CircleAvatar(
                        //         backgroundColor: Colors.transparent,
                        //         backgroundImage: AssetImage("assets/chip_images/img_5.png"),
                        //       ),
                        //       label: const Text(
                        //         textScaler: TextScaler.linear(1),
                        //         overflow: TextOverflow.ellipsis,
                        //         "Стиль"
                        //       ),
                        //       selected: state.postCategories.contains("Стиль"),
                        //       onSelected: (newState) {
                        //         if (newState) {
                        //           context.read<NewPostBloc>().add(const NewPostCategoryAdded(postCategory: "Стиль"));
                        //         }
                        //         else {
                        //           context.read<NewPostBloc>().add(const NewPostCategoryRemoved(postCategory: "Стиль"));
                        //         }
                        //       },
                        //     ),
                        //     FilterChip(
                        //       selectedColor: Colors.white,
                        //       showCheckmark: false,
                        //       backgroundColor: Colors.white,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20),
                        //         side: BorderSide(color: state.postCategories.contains("Заробіток") ? Colors.black : const Color(0xFFD9D9D9)),
                        //       ),
                        //       avatar: const CircleAvatar(
                        //         backgroundColor: Colors.transparent,
                        //         backgroundImage: AssetImage("assets/chip_images/img_1.png"),
                        //       ),
                        //       label: const Text(
                        //           textScaler: TextScaler.linear(1),
                        //         overflow: TextOverflow.ellipsis,
                        //         "Заробіток"
                        //       ),
                        //       selected: state.postCategories.contains("Заробіток"),
                        //       onSelected: (newState) {
                        //         if (newState) {
                        //           context.read<NewPostBloc>().add(const NewPostCategoryAdded(postCategory: "Заробіток"));
                        //         }
                        //         else {
                        //           context.read<NewPostBloc>().add(const NewPostCategoryRemoved(postCategory: "Заробіток"));
                        //         }
                        //       },
                        //     ),
                        //     FilterChip(
                        //       selectedColor: Colors.white,
                        //       showCheckmark: false,
                        //       backgroundColor: Colors.white,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20),
                        //         side: BorderSide(color: state.postCategories.contains("Правильне харчування") ? Colors.black : const Color(0xFFD9D9D9)),
                        //       ),
                        //       avatar: const CircleAvatar(
                        //         backgroundColor: Colors.transparent,
                        //         backgroundImage: AssetImage("assets/chip_images/img_3.png"),
                        //       ),
                        //       label: const Text(
                        //           textScaler: TextScaler.linear(1),
                        //         overflow: TextOverflow.ellipsis,
                        //         "Правильне харчування"
                        //       ),
                        //       selected: state.postCategories.contains("Правильне харчування"),
                        //       onSelected: (newState) {
                        //         if (newState) {
                        //           context.read<NewPostBloc>().add(const NewPostCategoryAdded(postCategory: "Правильне харчування"));
                        //         }
                        //         else {
                        //           context.read<NewPostBloc>().add(const NewPostCategoryRemoved(postCategory: "Правильне харчування"));
                        //         }
                        //       },
                        //     ),
                        //     FilterChip(
                        //       selectedColor: Colors.white,
                        //       showCheckmark: false,
                        //       backgroundColor: Colors.white,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20),
                        //         side: BorderSide(color: state.postCategories.contains("Розвиток дітей") ? Colors.black : const Color(0xFFD9D9D9)),
                        //       ),
                        //       avatar: const CircleAvatar(
                        //         backgroundColor: Colors.transparent,
                        //         backgroundImage: AssetImage("assets/chip_images/img_4.png"),
                        //       ),
                        //       label: const Text(
                        //           textScaler: TextScaler.linear(1),
                        //         overflow: TextOverflow.ellipsis,
                        //         "Розвиток дітей"
                        //       ),
                        //       selected: state.postCategories.contains("Розвиток дітей"),
                        //       onSelected: (newState) {
                        //         if (newState) {
                        //           context.read<NewPostBloc>().add(const NewPostCategoryAdded(postCategory: "Розвиток дітей"));
                        //         }
                        //         else {
                        //           context.read<NewPostBloc>().add(const NewPostCategoryRemoved(postCategory: "Розвиток дітей"));
                        //         }
                        //       },
                        //     ),
                        //     FilterChip(
                        //       selectedColor: Colors.white,
                        //       showCheckmark: false,
                        //       backgroundColor: Colors.white,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20),
                        //         side: BorderSide(color: state.postCategories.contains("Спорт і схуднення") ? Colors.black : const Color(0xFFD9D9D9)),
                        //       ),
                        //       avatar: const CircleAvatar(
                        //         backgroundColor: Colors.transparent,
                        //         backgroundImage: AssetImage("assets/chip_images/img_2.png"),
                        //       ),
                        //       label: const Text(
                        //           textScaler: TextScaler.linear(1),
                        //         overflow: TextOverflow.ellipsis,
                        //         "Спорт і схуднення"
                        //       ),
                        //       selected: state.postCategories.contains("Спорт і схуднення"),
                        //       onSelected: (newState) {
                        //         if (newState) {
                        //           context.read<NewPostBloc>().add(const NewPostCategoryAdded(postCategory: "Спорт і схуднення"));
                        //         }
                        //         else {
                        //           context.read<NewPostBloc>().add(const NewPostCategoryRemoved(postCategory: "Спорт і схуднення"));
                        //         }
                        //       },
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      // bottom: MediaQuery.of(context).size.height * 0.12,
                    ),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.065,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        backgroundColor: const Color(0xFF212121),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: (state.title != "" && state.content != "" && state.picturePath != "" && state.postCategories.isNotEmpty) ? () {
                        HapticFeedback.lightImpact();
                        titleFocusNode.unfocus();
                        descriptionFocusNode.unfocus();
                        context.read<NewPostBloc>().add(const NewPostCreated());
                        // if (state.picturePath != "" && state.title != "" && state.content != "" && state.postCategory != "") {
                        //   context.read<NewPostBloc>().add(const CreatePost());
                        // }
                        // else {
                        //   ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                        //     SnackBar(
                        //       backgroundColor: Colors.black,
                        //       elevation: 7,
                        //       content: const Center(child: Text(textAlign: TextAlign.center, 'Введіть всі необхідні дані для створення поста', style: TextStyle(color: Colors.white, fontFamily: "Inter", fontWeight: FontWeight.w400, fontSize: 12),)),
                        //       duration: const Duration(seconds: 5),
                        //       width: MediaQuery.of(context).size.width * 0.7,
                        //       behavior: SnackBarBehavior.floating,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(30.0),
                        //       ),
                        //     ),
                        //   );
                        // }
                      } : null,
                      child: Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        "Поширити",
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14)
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CategoryChips extends StatelessWidget {
  CategoryChips({super.key});

  final Map<String, String> categories = <String, String>{
    "Сімʼя": "assets/chip_images/img.png",
    "Стиль": "assets/chip_images/img_5.png",
    "Заробіток": "assets/chip_images/img_1.png",
    "Правильне харчування": "assets/chip_images/img_3.png",
    "Розвиток дітей": "assets/chip_images/img_4.png",
    "Спорт і схуднення": "assets/chip_images/img_2.png",
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewPostBloc, NewPostState>(
      builder: (context, state) {
        return Wrap(
          spacing: 10,
          children: categories.keys.map((categoryName) {
            return FilterChip(
              selectedColor: Colors.white,
              showCheckmark: false,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: state.postCategories.contains(categoryName) ? Colors.black : const Color(0xFFD9D9D9)),
              ),
              avatar: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(categories[categoryName]!),
              ),
              label: Text(
                textScaler: TextScaler.linear(1),
                categoryName,
                overflow: TextOverflow.ellipsis,
              ),
              selected: state.postCategories.contains(categoryName),
              onSelected: (newState) {
                if (newState) {
                  context.read<NewPostBloc>().add(NewPostCategoryAdded(postCategory: categoryName));
                }
                else {
                  context.read<NewPostBloc>().add(NewPostCategoryRemoved(postCategory: categoryName));
                }
              },
            );
          }).toList(),
        );
      },
    );
  }
}