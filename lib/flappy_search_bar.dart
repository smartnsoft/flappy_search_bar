library flappy_search_bar;

import 'dart:async';

import 'package:flutter/material.dart';

class SearchBar<T> extends StatefulWidget {
  final Future<List<T>> Function(String text) onSearch;
  final List<T> suggestions;
  final Widget Function(T item, int index) buildSuggestion;
  final int minimumChars;
  final Widget Function(T item, int index) onItemFound;
  final Widget Function(Error error) onError;
  final Duration debounceDuration;
  final Widget loader;
  final Widget emptyWidget;
  final Widget icon;
  final String hintText;
  final TextStyle hintStyle;
  final Color iconActiveColor;
  final TextStyle textStyle;
  final Text cancellationText;

  const SearchBar({
    Key key,
    @required this.onSearch,
    @required this.onItemFound,
    this.minimumChars = 3,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.loader = const CircularProgressIndicator(),
    this.onError,
    this.emptyWidget = const SizedBox.shrink(),
    this.icon = const Icon(Icons.search),
    this.hintText = "",
    this.hintStyle = const TextStyle(color: Color.fromRGBO(142, 142, 147, 1)),
    this.iconActiveColor = Colors.black,
    this.textStyle = const TextStyle(color: Colors.black),
    this.cancellationText = const Text("Cancel"),
    this.suggestions = const [],
    this.buildSuggestion,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState<T>();
}

class _SearchBarState<T> extends State<SearchBar<T>> with TickerProviderStateMixin {
  List<T> _items = [];
  bool _loading = false;
  Widget _error;
  final _searchQueryController = TextEditingController();
  Timer _debounce;
  bool _animate = false;

  @override
  void initState() {
    super.initState();
  }

  _onTextChanged(String newText) async {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }

    _debounce = Timer(widget.debounceDuration, () async {
      if (newText.length >= widget.minimumChars) {
        setState(() {
          _loading = true;
          _error = null;
          _animate = true;
        });
        if (widget.onSearch != null) {
          try {
            final posts = await widget.onSearch(newText);
            setState(() {
              _items = posts;
              _loading = false;
            });
          } catch (error) {
            setState(() {
              _error = widget.onError != null ? widget.onError(error) : Text("error");
            });
          }
        }
      } else {
        setState(() {
          _items.clear();
          _error = null;
          _loading = false;
          _animate = false;
        });
      }
    });
  }

  void _cancel() {
    setState(() {
      _searchQueryController.clear();
      _items.clear();
      _error = null;
      _loading = false;
      _animate = false;
    });
  }

  Widget _buildListView(List<T> items, Widget Function(T item, int index) builder) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return builder(items[index], index);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_error != null) {
      return Center(
        child: _error,
      );
    } else if (_loading) {
      return Center(
        child: widget.loader,
      );
    } else if (_searchQueryController.text.length < widget.minimumChars) {
      return _buildListView(widget.suggestions, widget.buildSuggestion ?? widget.onItemFound);
    } else if (_items.isNotEmpty) {
      return _buildListView(_items, widget.onItemFound);
    } else {
      return Center(
        child: widget.emptyWidget,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthMax = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: _animate ? widthMax * .8 : widthMax,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Color.fromRGBO(142, 142, 147, .15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Theme(
                      child: TextField(
                        controller: _searchQueryController,
                        onChanged: _onTextChanged,
                        style: widget.textStyle,
                        decoration: InputDecoration(
                          icon: widget.icon,
                          border: InputBorder.none,
                          hintText: widget.hintText,
                          hintStyle: widget.hintStyle,
                        ),
                      ),
                      data: Theme.of(context).copyWith(
                        primaryColor: widget.iconActiveColor,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _animate ? 1.0 : 0,
                curve: Curves.easeIn,
                duration: Duration(milliseconds: _animate ? 1000 : 0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: _animate ? MediaQuery.of(context).size.width * .2 : 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: _cancel,
                      child: widget.cancellationText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildContent(context),
        ),
      ],
    );
  }
}
