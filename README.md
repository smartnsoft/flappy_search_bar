# flappy_search_bar

A SearchBar widget handling most of search cases.

## Usage

To use this plugin, add flappy_search_bar as a dependency in your pubspec.yaml file.

### Example

```
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SearchBar<Post>(
            onSearch: (String text) => _getALlPosts(text),
            suggestions: [
              Post("Suggestion 1 titre", "Suggestion 1 body"),
              Post("Suggestion 2 titre", "Suggestion 2 body")
            ],
            searchBarController: _searchBarController,
            minimumChars: 3,
            searchBarStyle: SearchBarStyle(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            debounceDuration: Duration(milliseconds: 400),
            loader: Text("loading"),
            onError: (Error error) => Text("ERREUR"),
            emptyWidget: Text("Contenu vide !"),
            hintText: "Test",
            cancellationText: Text("Annuler"),
            buildSuggestion: (Post post, int index) {
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
                enabled: false,
              );
            },
            onItemFound: (Post post, int index) {
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
              );
            },
            header: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  child: Text("Sort"),
                  onPressed: changeSort,
                ),
                RaisedButton(
                  child: Text("Rm Sort"),
                  onPressed: removeSort,
                ),
                RaisedButton(
                  child: Text("Filter"),
                  onPressed: filter,
                ),
                RaisedButton(
                  child: Text("Rm Filter"),
                  onPressed: removeFilter,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
```

### Try it

A sample app is available to let you try all the features ! :)

### Warning

If you want to use a SearchBarController in order to do some sorts or filters, PLEASE put your instance of SearchBarController in a StateFullWidget.

If not, it will not work properly.

If you don't use an instance of SearchBarController, you can keep everything in a StateLessWidget !

### Parameters

| Name  | Type | Usage | Required | Default Value |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| onSearch   | Future<List<T>> Function(String text) | Callback giving you the text to look for and asking for a Future  | yes  | - |
| onItemFound| Widget Function(T item, int index) | Callback letting you build the widget corresponding to each item| yes| - |
| suggestions  |  List<T> | Potential fist list of suggestions (when no request have been made)  | no| [] |
| searchBarController  |  SearchBarController | Enable you to sort and filter your list  | no | default controller |
| searchBarStyle  |  SearchBarStyle | Syle to customize SearchBar  | no | default values on bottom tab |
| buildSuggestions| Widget Function(T item, int index) | Callback called to let you build Suggestion item (if not provided, the suggestion will have the same layout as the basic item)  | no| null|
| minimumChars  |  int | Minimum number of chars to start querying  | no| 3 |
| onError  |  Function(Error error) | Callback called when an error occur runnning Future | no| null |
| debounceDuration  | Duration | Debounce's duration | no| Duration(milliseconds: 500) |
| loader  | Widget | Widget that appears when Future is running | no| CircularProgressIndicator() |
| emptyWidget  | Widget | Widget that appears when Future is returning an empty list | no| SizedBox.shrink() |
| icon  | Widget | Widget that appears on left of the SearchBar | no| Icon(Icons.search) |
| hintText  | String | Hint Text | no| "" |
| hintStyle  | TextStyle | Hint Text style| no| TextStyle(color: Color.fromRGBO(142, 142, 147, 1)) |
| iconActiveColor  | Color | Color of icon when active | no| Colors.black |
| textStyle  | TextSTyle | TextStyle of searched text | no| TextStyle(color: Colors.black) |
| cancellationText  | Text | Text shown on right of the SearchBar | no| Text("Cancel") |
| crossAxisCount  | int | Number of tiles on cross axis (Grid) | no| 2 |
| shrinkWrap  | bool | Wether list should be shrinked or not (take minimum space) | no| true |
| scrollDirection  | Axis | Set the scroll direction | no| Axis.vertical |
| mainAxisSpacing  | int | Set the spacing between each tiles on main axis | no| 10 |
| crossAxisSpacing  | int | Set the spacing between each tiles on cross axis | no| 10 |
| indexedScaledTileBuilder  | IndexedScaledTileBuilder | Builder letting you decide how much space each tile should take | no| (int index) => ScaledTile.count(1, index.isEven ? 2 : 1) |  
  
### SearchBar default SearchBarStyle

| Name  | Type | default Value |
| ------------- | ------------- | ------------- |
| backgroundColor  | Color  | Color.fromRGBO(142, 142, 147, .15)  |
| padding  | EdgeInsetsGeometry  | EdgeInsets.all(5.0)  |
| borderRadius  | BorderRadius  | BorderRadius.all(Radius.circular(5.0))})  |



