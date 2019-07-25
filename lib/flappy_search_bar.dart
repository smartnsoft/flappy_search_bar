library flappy_search_bar;

import 'dart:async';

import 'package:flutter/material.dart';

import 'search_bar_style.dart';

mixin _ControllerListener<T> on State<SearchBar<T>> {
  void onSort() {}

  void onFiltered(List<T> items) {}
}

class SearchBarController<T> {
  final List<T> list = [];
  _ControllerListener _controllerListener;

  void setListener(_ControllerListener _controllerListener) {
    this._controllerListener = _controllerListener;
  }

  void setList(List<T> items) {
    list.clear();
    list.addAll(items);
  }

  void clear() {
    list.clear();
  }

  void sortList(int Function(T a, T b) sorting) {
    list.sort(sorting);
    _controllerListener?.onSort();
  }

  void filterList(bool Function(T item) filter) {
    _controllerListener?.onFiltered(list.where(filter).toList());
  }
}

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
  final Widget placeHolder;
  final Widget icon;
  final Widget header;
  final String hintText;
  final TextStyle hintStyle;
  final Color iconActiveColor;
  final TextStyle textStyle;
  final Text cancellationText;
  SearchBarController searchBarController;
  final SearchBarStyle searchBarStyle;

  SearchBar({
    Key key,
    @required this.onSearch,
    @required this.onItemFound,
    this.searchBarController,
    this.minimumChars = 3,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.loader = const CircularProgressIndicator(),
    this.onError,
    this.emptyWidget = const SizedBox.shrink(),
    this.header,
    this.placeHolder,
    this.icon = const Icon(Icons.search),
    this.hintText = "",
    this.hintStyle = const TextStyle(color: Color.fromRGBO(142, 142, 147, 1)),
    this.iconActiveColor = Colors.black,
    this.textStyle = const TextStyle(color: Colors.black),
    this.cancellationText = const Text("Cancel"),
    this.suggestions = const [],
    this.buildSuggestion,
    this.searchBarStyle = const SearchBarStyle(),
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState<T>();
}

class _SearchBarState<T> extends State<SearchBar<T>> with TickerProviderStateMixin, _ControllerListener<T> {
  bool _loading = false;
  Widget _error;
  final _searchQueryController = TextEditingController();
  Timer _debounce;
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    if (widget.searchBarController == null) {
      widget.searchBarController = SearchBarController<T>();
    }

    widget.searchBarController.setListener(this);
  }

  @override
  void onSort() {
    setState(() {});
  }

  @override
  void onFiltered(List<T> items) {
    setState(() {
      widget.searchBarController.setList(items);
    });
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
              widget.searchBarController.setList(posts);
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
          widget.searchBarController.clear();
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
      widget.searchBarController.clear();
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
      return _error;
    } else if (_loading) {
      return widget.loader;
    } else if (_searchQueryController.text.length < widget.minimumChars) {
      if (widget.placeHolder != null) return widget.placeHolder;
      return _buildListView(widget.suggestions, widget.buildSuggestion ?? widget.onItemFound);
    } else if (widget.searchBarController.list.isNotEmpty) {
      return _buildListView(widget.searchBarController.list, widget.onItemFound);
    } else {
      return widget.emptyWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthMax = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                    borderRadius: widget.searchBarStyle.borderRadius,
                    color: widget.searchBarStyle.backgroundColor,
                  ),
                  child: Padding(
                    padding: widget.searchBarStyle.padding,
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
        widget.header ?? Container(),
        Expanded(
          child: _buildContent(context),
        ),
      ],
    );
  }
}
