import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/authentication.dart';
import 'package:movie_app/services/moviedb.dart';
import 'package:movie_app/ui/more_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> _movieList = List();

  bool _isLoading;
  bool _isEmailVerified = false;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();

    _isLoading = false;

    _checkEmailVerification();
    _getPopularMovies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          _showMovieList(),
          _bottomBar(),
          _showCircularProgress()
        ],
      ),
    );
  }

  Widget _showMovieList() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
          childAspectRatio: (itemWidth / itemHeight)),
      itemCount: _movieList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Image.network(
            _movieList[index].image,
            fit: BoxFit.fill,
          ),
        );
      },
    );
  }

  Widget _bottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.black54),
        child: new BottomNavigationBar(
          currentIndex: _tabIndex,
          onTap: (index) => _incrementTab(index),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.theaters, color: Colors.amber[400]),
                title: Text('Popular Movies')),
            BottomNavigationBarItem(
                icon: Icon(Icons.flash_on, color: Colors.amber[400]),
                title: Text('Upcoming Movies')),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu, color: Colors.amber[400]),
                title: Text('More'))
          ],
        ),
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _incrementTab(index) {
    setState(() {
      switch (index) {
        case 0:
          _isLoading = true;
          _getPopularMovies();
          _showCircularProgress();
          break;
        case 1:
          _isLoading = true;
          _getUpcomingMovies();
          _showCircularProgress();
          break;
        case 2:
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MorePage()));
          break;
        default:
      }

      _tabIndex = index;
    });
  }

  void _getPopularMovies() async {
    var movieList = await Movies().popularMovies();
    movieList.movies.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    setState(() {
      _movieList = movieList.movies;

      if (_isLoading) {
        _isLoading = false;
        _showCircularProgress();
      }
    });
  }

  void _getUpcomingMovies() async {
    var movieList = await Movies().upcomingMovies();
    movieList.movies.sort((a, b) =>
        DateTime.parse(a.releaseDate).compareTo(DateTime.parse(b.releaseDate)));
    setState(() {
      _movieList = movieList.movies;

      if (_isLoading) {
        _isLoading = false;
        _showCircularProgress();
      }
    });
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
