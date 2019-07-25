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
            minimumChars: 3,
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
          ),
        ),
      ),
    );
  }
```

### Parameters

| Name  | Type | Usage | Required | Default Value |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| onSearch   | Future<List<T>> Function(String text) | Callback giving you the text to look for and asking for a Future  | yes  | - |
| onItemFound| Widget Function(T item, int index) | Callback letting you build the widget corresponding to each item| yes| - |
| suggestions  |  List<T> | Potential fist list of suggestions (when no request have been made)  | no| [] |
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





