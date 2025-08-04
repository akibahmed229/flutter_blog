import 'dart:io';

import 'package:blog_app/core/common/cubits/app_wide_user/app_wide_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> selectedCategories = [];
  File? _image;

  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  void uploadBlogOnPressed() {
    if (_formKey.currentState!.validate() &&
        selectedCategories.isNotEmpty &&
        _image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      context.read<BlogBloc>().add(
        UploadBlogEvent(
          image: _image!,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          posterId: posterId,
          topics: selectedCategories,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: uploadBlogOnPressed,
            icon: Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.message);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              height: 250,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _image = null;
                                        });
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: AppPallete.borderColor,
                                        child: Icon(Icons.close),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                radius: Radius.circular(16),
                                padding: EdgeInsets.all(16),
                                color: AppPallete.borderColor,
                                strokeWidth: 2,
                                dashPattern: [8, 4],
                              ),
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open_rounded, size: 50),
                                    SizedBox(height: 16),
                                    Text(
                                      'Select Your Image',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            [
                              'Technology',
                              "Business",
                              'Programming',
                              "Entertainment",
                            ].map((category) {
                              return Padding(
                                padding: EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedCategories.contains(
                                        category,
                                      )) {
                                        selectedCategories.remove(category);
                                      } else {
                                        selectedCategories.add(category);
                                      }
                                    });
                                    print(
                                      "Selected Categories: $selectedCategories",
                                    );
                                  },
                                  child: Chip(
                                    color: selectedCategories.contains(category)
                                        ? const MaterialStatePropertyAll(
                                            AppPallete.gradient1,
                                          )
                                        : null,
                                    label: Text(category),
                                    side: !selectedCategories.contains(category)
                                        ? BorderSide(
                                            color: AppPallete.borderColor,
                                          )
                                        : null,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    SizedBox(height: 20),
                    BlogEditor(
                      controller: _titleController,
                      hintText: "Blog Title",
                    ),
                    SizedBox(height: 10),
                    BlogEditor(
                      controller: _contentController,
                      hintText: "Blog Content",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
