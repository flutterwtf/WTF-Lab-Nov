import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/category.dart';
import '../../model/record.dart';
import '../search_record_page.dart';
import 'cubit/records_cubit.dart';
import 'dialogs/create_image_record_dialog.dart';
import 'dialogs/delete_records_dialog.dart';
import 'dialogs/send_records_dialog.dart';
import 'widgets/records_list_view.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  CategoryPage(this.category);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _messageFocus = FocusNode();
  final _textEditingController = TextEditingController();

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void deactivate() {
    context.read<RecordsCubit>().unselectAll(
          categoryId: widget.category.id,
        );
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: state is RecordsLoadInProcess
              ? AppBar(
                  title: Text(widget.category.name),
                )
              : state.records.map((e) => e.isSelected).contains(true)
                  ? state is RecordUpdateInProcess
                      ? AppBar(
                          title: Text('Edit mode'),
                          actions: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                context.read<RecordsCubit>().unselectAll(
                                      categoryId: widget.category.id,
                                    );
                                _textEditingController.clear();
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ],
                        )
                      : AppBar(
                          title: Text('Select'),
                          leading: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              context.read<RecordsCubit>().unselectAll(
                                    categoryId: widget.category.id,
                                  );
                            },
                          ),
                          actions: [
                            if (state.records
                                    .where(
                                      (element) => element.isSelected,
                                    )
                                    .length <
                                2)
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  context.read<RecordsCubit>().beginUpdate(
                                      state.records.firstWhere(
                                        (element) => element.isSelected,
                                      ),
                                      categoryId: widget.category.id);

                                  _textEditingController.text = state.records
                                      .firstWhere(
                                          (element) => element.isSelected)
                                      .message;
                                  _messageFocus.requestFocus();
                                },
                              ),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {
                                showSendRecordsDialog(
                                  context,
                                  category: widget.category,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.bookmark_outlined),
                              onPressed: () async {
                                await context
                                    .read<RecordsCubit>()
                                    .changeFavorite(
                                      state.records
                                          .where(
                                            (element) => element.isSelected,
                                          )
                                          .toList(),
                                      categoryId: widget.category.id,
                                    );
                                await context.read<RecordsCubit>().unselectAll(
                                      records: state.records,
                                      categoryId: widget.category.id,
                                    );
                              },
                            ),
                            Builder(
                              builder: (context) => IconButton(
                                icon: Icon(Icons.copy),
                                onPressed: () {
                                  context.read<RecordsCubit>().copyToClipboard(
                                      records: state.records
                                          .where(
                                            (element) => element.isSelected,
                                          )
                                          .toList());
                                  context.read<RecordsCubit>().unselectAll(
                                        categoryId: widget.category.id,
                                      );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied to clipboard'),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () {},
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDeleteRecordsDialog(
                                  context,
                                  category: widget.category,
                                );
                              },
                            )
                          ],
                        )
                  : AppBar(
                      title: Text(widget.category.name),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: SerachRecordPage(
                                context: context,
                                records: state.records,
                                category: widget.category,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
          body: Column(
            children: [
              if (state is RecordsLoadInProcess)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (!(state is RecordsLoadInProcess))
                Expanded(
                  child: RecordsListView(
                    records: state.records,
                    category: widget.category,
                  ),
                ),
              Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!(state is RecordUpdateInProcess))
                      IconButton(
                        icon: Icon(Icons.photo),
                        onPressed: () async {
                          await getImage();
                          if (_image == null) return;
                          showCreateImageRecordDialog(
                            context: context,
                            image: _image,
                            textEditingController: _textEditingController,
                            messageFocus: _messageFocus,
                            categoryId: widget.category.id,
                          );
                        },
                      ),
                    Expanded(
                      child: MessageTextFormField(
                        focusNode: _messageFocus,
                        controller: _textEditingController,
                      ),
                    ),
                    IconButton(
                      icon: state is RecordUpdateInProcess
                          ? Icon(Icons.check)
                          : Icon(Icons.send),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          final recordDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          final recordTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          final createDateTime = DateTime(
                            recordDate.year,
                            recordDate.month,
                            recordDate.day,
                            recordTime.hour,
                            recordTime.minute,
                          );
                          if (state is RecordUpdateInProcess) {
                            await context.read<RecordsCubit>().update(
                                  state.record.copyWith(
                                    message: _textEditingController.text.trim(),
                                    createDateTime: createDateTime,
                                  ),
                                  categoryId: widget.category.id,
                                );
                            context.read<RecordsCubit>().unselectAll(
                                  categoryId: widget.category.id,
                                );
                            _messageFocus.unfocus();
                          } else {
                            context.read<RecordsCubit>().add(
                                  Record(
                                    _textEditingController.text.trim(),
                                    categoryId: widget.category.id,
                                    createDateTime: createDateTime,
                                  ),
                                  categoryId: widget.category.id,
                                );
                          }
                          _textEditingController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MessageTextFormField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;

  const MessageTextFormField({Key key, this.focusNode, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Your record',
        ),
        minLines: 1,
        maxLines: 8,
        validator: (value) {
          if (value.trim().isEmpty) {
            return "Record can't be empty";
          }
          return null;
        },
        focusNode: focusNode,
        controller: controller,
      ),
    );
  }
}