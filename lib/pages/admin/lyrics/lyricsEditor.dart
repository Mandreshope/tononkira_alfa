import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tononkira_alfa/bloc/lyricsBloc.dart';
import 'package:tononkira_alfa/models/lyrics.dart';
import 'package:zefyr/zefyr.dart';

class LyricsEditorPage extends StatefulWidget {
  final Function add;
  final Function update;
  final LyricsModel lyrics;
  final int index;

  LyricsEditorPage({Key key, this.lyrics, this.add, this.update, this.index}) : super(key: key);

  @override
  _LyricsEditorPageState createState() => _LyricsEditorPageState();
}

class _LyricsEditorPageState extends State<LyricsEditorPage> {

  ZefyrController _editorController;

  TextEditingController _titleController;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  NotusDocument _content;

  @override
  void initState() {
    super.initState();

    _content = _loadContent();
    _titleController = _loadTitle();
    _editorController = ZefyrController(_content);
    _focusNode = FocusNode();
  }

  NotusDocument _loadContent() {
    // If in edit mode then load the provided document
    return widget.lyrics != null ? NotusDocument.fromJson(jsonDecode(widget.lyrics.content)) : NotusDocument();
  }

  TextEditingController _loadTitle() {
    // If in edit mode then load the provided title
    return widget.lyrics != null
        ? TextEditingController(text: widget.lyrics.title)
        : TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // To make the editor height responsive
    double editorHeight = screenHeight * 0.65;

    final editor = ZefyrField(
      height: editorHeight, // set the editor's height
      controller: _editorController,
      focusNode: _focusNode,
      autofocus: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      physics: ClampingScrollPhysics(),
    );

    final titleField = TextField(
      controller: _titleController,
      decoration: InputDecoration(
        hintText: 'Lohanteny tononkira',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );

    final form = Padding(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            titleField,
            SizedBox(
              height: 10,
            ),
            editor
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back), 
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Fampidirana tononkira"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _save(),
          ),
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () => _clear(),
          ),
        ],
      ),
      body: ZefyrScaffold(child: form),
    );

  }

  Future<void> _save() async {
    if(_editorController.document.toPlainText().trim() != "" && _titleController.text.trim() != ""){
      final NotusDocument doc =  _editorController.document;

      final String title = _titleController.text;

      final LyricsModel lyrics = LyricsModel(title: title, content: jsonEncode(doc), date: DateTime.now());

      // Check if we need to add new or edit old one
      if (widget.lyrics == null) {
        bool confirmed = await _buildLoadingDialog();
        widget.add(lyrics);
        if(confirmed is bool && confirmed) {
          Navigator.pop(context);
        }
      } else {
        bool confirmed = await _buildLoadingDialog();
        lyrics.id = widget.lyrics.id;
        widget.update(lyrics, widget.index);
        if(confirmed is bool && confirmed) {
          Navigator.pop(context);
        }
      }
    }
  }

  void _clear() async {
    bool confirmed = await _getConfirmationDialog(context);
    if (confirmed) {
      _editorController.replaceText(
          0, _editorController.document.length - 1, '');
    }
  }

  Future<bool> _buildLoadingDialog() {
    return showDialog(context: context,
      barrierDismissible: false,
      builder: (context) {
        final lyricsBloc = Provider.of<LyricsBloc>(context);
        if(lyricsBloc.loading == LoadingState.progress){
          return AlertDialog(
            content: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 10,),
                Expanded(
                  child: Text('Eo ampamarana...'),
                )
              ],
            ), 
          );
        }else {
          return AlertDialog(
            title: Text('Fampafantarina'),
            content: Row(
              children: <Widget>[
                Expanded(
                  child: Text('Tontosa !!!'),
                )
              ],
            ), 
            actions: <Widget>[
              FlatButton(
                child: Text('HIALA'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
            ],
          );
        }
      }
    );
  }

  Future<bool> _getConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hamafiso ?'),
          content: Row(
            children: <Widget>[
              Expanded(
                child: Text('Ho fafana avokoa ve izay voasoratra ?'),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('TSIA'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('ENY'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}