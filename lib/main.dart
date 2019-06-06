import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}
class RandomWordsState extends State<RandomWords> {
    final List<WordPair> _suggestions = <WordPair>[];
    final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    final Set<WordPair> _saved= new Set<WordPair>();
    Widget _buildSuggestions() {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i){
          if(i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
    }
    Widget _buildRow(WordPair pair) {
      final bool alreadySaved = _saved.contains(pair);
      return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.thumb_up: Icons.thumbs_up_down,
          color: alreadySaved ? Colors.black : null,
        ),
        onTap: () {
          setState(() {
            if(alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      );
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
       appBar: AppBar(
          title : Text('Startup Name Generator'),
         actions: <Widget>[
           new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
         ],
      ),
      body: _buildSuggestions(),
      );
    }
    void _pushSaved(){
      Navigator.of(context).push(
        new MaterialPageRoute<void>(
          builder: (BuildContext context) {
            final Iterable<ListTile> tiles = _saved.map(
                  (WordPair pair) {
                return new ListTile(
                  title: new Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
            );
            final List<Widget> divided = ListTile
                .divideTiles(
              context: context,
              tiles: tiles,
            )
                .toList();

            return new Scaffold(         // Add 6 lines from here...
              appBar: new AppBar(
                title: const Text('Saved Suggestions'),
              ),
              body: new ListView(children: divided),
            );
          },
        ),
      );
    }

}
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}