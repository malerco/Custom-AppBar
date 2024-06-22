import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final double _expandedHeight = 150.0;
  double _scrollPosition = 0.0;
  var _isScrolling = false;
  var _isInit = false;
  late AnimationController _animationController;
  late Animation<double> _storyAnimation;
  late Animation<double> _secondaryAvatarOffsetAnimation;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    _scrollController.addListener(_handleScrollEnd);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _storyAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    _titleAnimation =
        Tween<double>(begin: 50, end: 0).animate(_animationController);

    _secondaryAvatarOffsetAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScrollEnd);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification) {
            _handleScrollEnd();
          }
          return true;
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                  },
                ),
              ],
              expandedHeight: _expandedHeight,
              collapsedHeight: 70,
              floating: false,
              pinned: true,
              backgroundColor: Color.fromRGBO(81, 125, 162, 1),
              flexibleSpace: FlexibleSpaceBar(
                title: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _storyAnimation,
                          builder: (context, child) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                ),
                                SizedBox(height: 2,),
                                1 - _getTextOpacity() > 0 ?
                                Opacity(
                                    opacity: 1 - _getTextOpacity(),
                                    child: Text('Contact name', style: TextStyle(fontSize: 8, color: Colors.white),)
                                ) : SizedBox.shrink()
                              ],
                            );
                          },
                        ),

                        SizedBox(
                          width: 10,
                        ),
                        AnimatedBuilder(
                          animation: _storyAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 0.99,
                              child: Opacity(
                                opacity: 1 - _getAppBarScrollParam(),
                                child: Text('1 Story',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    Positioned(
                      left: 5,
                      top: 0,
                      bottom: 0,
                      child: AnimatedBuilder(
                        animation: _secondaryAvatarOffsetAnimation,
                        builder: (context, child) {

                          return Transform.translate(
                            offset: Offset(-50 * (1 - _secondaryAvatarOffsetAnimation.value), 0),
                            child: Opacity(
                              opacity: _secondaryAvatarOffsetAnimation.value <= 0.5 ? 1 - _secondaryAvatarOffsetAnimation.value : 0,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                      ),

                                      Positioned(
                                          bottom: 0,
                                          right: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle
                                            ),
                                              child: Icon(Icons.add, color: Colors.white, size: 8,)))
                                    ]
                                  ),
                                  if (1 - _getTextOpacity() > 0) ...[
                                    SizedBox(height: 2,),
                                    Opacity(
                                        opacity: 1 - _getTextOpacity(),
                                        child: Text('Your story', style: TextStyle(fontSize: 8, color: Colors.white),))
                                  ]
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                background: Stack(
                  children: [
                    Positioned(
                      left: 55,
                      top: 2 +
                          _titleAnimation
                              .value,
                      child: AnimatedBuilder(
                        animation: _titleAnimation,
                        builder: (context, child) {
                          return Opacity(
                              opacity: _getAppBarScrollParam(),
                              child: Text('App Title',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)));
                        },
                      ),
                    ),


                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 12, // Высота отступа
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text('Item #$index'),
                  ),
                ),
                childCount: 50,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(81, 125, 162, 1),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




  double _getAppBarScrollParam() {
    if (_scrollController.hasClients) {
      if (_scrollController.position.pixels <= 100) {
        var param = _scrollController.position.pixels / 100;
        return 1 - param;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  double _getTextOpacity(){
    if (_scrollController.hasClients) {
      if (_scrollController.position.pixels < 10) {
        return _scrollController.position.pixels / 10;
      } else {
        return 1;
      }
    }else{
      return 1;
    }
  }

  void _handleScrollEnd() {

    _animationController.value = _scrollController.position.pixels / 100;

    if (!_isInit) {
      _isInit = true;
      _scrollController.position.isScrollingNotifier.addListener(() {
        if (!_scrollController.position.isScrollingNotifier.value) {
          // Прокрутка завершилась (пользователь отпустил палец)
          _scrollPosition = _scrollController.position.pixels;

          if (_scrollPosition < 150) {
            if (!_isScrolling) {

              if (_scrollPosition < 30) {
                _isScrolling = true;


                _scrollController
                    .animateTo(
                  0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                )
                    .then(
                      (value) {
                    _isScrolling = false;
                  },
                );
              } else {

                _isScrolling = true;
                _scrollController
                    .animateTo(
                  95,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                )
                    .then(
                      (value) {
                    _isScrolling = false;
                  },
                );
              }
            }
          }
        }
      });
    }
  }
}
