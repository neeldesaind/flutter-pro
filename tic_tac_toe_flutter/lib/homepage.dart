import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(TicTacToeGame());
}

class TicTacToeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // Set app's background color to white
      ),
      home: TicTacToeBoard(),
      debugShowCheckedModeBanner: true,
    );
  }
}

class TicTacToeBoard extends StatefulWidget {
  @override
  _TicTacToeBoardState createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  List<List<String>> _board = List.generate(3, (_) => List.generate(3, (_) => ''));
  String? _playerXName;
  String? _playerOName;
  String _currentPlayer = 'X';
  String _winner = '';
  int filledBoxes = 0;
  bool _namesEntered = false;
  int _playerXWins = 0;
  int _playerOWins = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _startGame(context);
    });
  }

  void _handleTap(int row, int col) {
    if (_namesEntered && _board[row][col] == '' && _winner == '') {
      setState(() {
        _board[row][col] = _currentPlayer;
        filledBoxes++;
        _checkWinner();
        if (_winner == '' && filledBoxes < 9) {
          _togglePlayer();
        }
      });
    }
  }

  void _checkWinner() {
    // Checking rows
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == _board[i][1] &&
          _board[i][0] == _board[i][2] &&
          _board[i][0] != '') {
        _showWinDialog(_board[i][0]);
        return;
      }
    }

    // Checking columns
    for (int i = 0; i < 3; i++) {
      if (_board[0][i] == _board[1][i] &&
          _board[0][i] == _board[2][i] &&
          _board[0][i] != '') {
        _showWinDialog(_board[0][i]);
        return;
      }
    }

    // Checking diagonals
    if (_board[0][0] == _board[1][1] &&
        _board[0][0] == _board[2][2] &&
        _board[0][0] != '') {
      _showWinDialog(_board[0][0]);
      return;
    }
    if (_board[0][2] == _board[1][1] &&
        _board[0][2] == _board[2][0] &&
        _board[0][2] != '') {
      _showWinDialog(_board[0][2]);
      return;
    }

    // Check for draw
    if (filledBoxes == 9 && _winner == '') {
      _showDrawDialog();
    }
  }

  void _showWinDialog(String winner) {
    setState(() {
      _winner = winner;
      if (_winner == 'X') {
        _playerXWins++;
      } else {
        _playerOWins++;
      }
    });
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent tapping elsewhere to dismiss
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Disable back button during win dialog
          child: AlertDialog(
            title: Text('Game Over'),
            content: Text('Winner: ${winner == 'X' ? _playerXName : _playerOName}'),
            actions: [
              TextButton(
                child: Text('Play Again'),
                onPressed: () {
                  _initializeBoard(); // Reset the game state
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent tapping elsewhere to dismiss
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Disable back button during draw dialog
          child: AlertDialog(
            title: Text('Game Over'),
            content: Text('It\'s a draw!'),
            actions: [
              TextButton(
                child: Text('Play Again'),
                onPressed: () {
                  _initializeBoard(); // Reset the game state
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _togglePlayer() {
    _currentPlayer = (_currentPlayer == 'X') ? 'O' : 'X';
  }

  Widget _buildSquare(int row, int col) {
    return GestureDetector(
      onTap: () => _handleTap(row, col),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
        ),
        child: Center(
          child: Text(
            _board[row][col],
            style: TextStyle(
              fontSize: 40,
              color: _board[row][col] == 'O' ? Colors.red : Colors.blue, // Change color here
            ),
          ),
        ),
      ),
    );
  }

  void _initializeBoard() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ''));
      _currentPlayer = 'X';
      _winner = '';
      filledBoxes = 0;
      _namesEntered = true; // Allow playing again immediately
    });
  }

  void _startGame(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent tapping elsewhere to dismiss
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Disable back button during name entry
          child: AlertDialog(
            title: Text('Enter Player Names'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _playerXName = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Player X Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Set border radius here
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _playerOName = value;
                    });
                  },

                  decoration: InputDecoration(
                    labelText: 'Player O Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Set border radius here
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Start Game'),
                onPressed: () {
                  if (_playerXName != null &&
                      _playerOName != null &&
                      _playerXName!.isNotEmpty &&
                      _playerOName!.isNotEmpty) {
                    setState(() {
                      _namesEntered = true;
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter both player names.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWinningCountsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              'Winning Counts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Table(
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Text(
                          'Player',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          'Wins',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Text(_playerXName ?? 'Player X'),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Text(_playerXWins.toString()),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Text(_playerOName ?? 'Player O'),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Text(_playerOWins.toString()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _confirmExit();
        return false; // Prevent popping the route immediately
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tic Tac Toe',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black87,
          actions: [
            // Add action for About icon
            IconButton(
              icon: Icon(Icons.info_outline), // Use an appropriate icon for About
              color: Colors.white,
              onPressed: () {
                // Show About dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('About'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('images/developer_image.jpg'),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Neel Desai', // Replace with actual name
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Email: neel.desai1653@gmail.com',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Contact: +91 81600 26509',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.white,
              onPressed: () {
                _confirmExit(); // Prompt for confirmation before exiting
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int row = 0; row < 3; row++)
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int col = 0; col < 3; col++)
                              Flexible(
                                child: _buildSquare(row, col),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              _buildWinningCountsCard(), // Display winning counts card
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '© Developed by :TechPrenuer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white, // Set footer text color to white
              ),
            ),
          ),
          color: Colors.black, // Set footer background color to black
        ),
      ),
    );
  }

  void _confirmExit() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent tapping elsewhere to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit Game'),
          content: Text('Do you want to exit the game?'),
          actions: [
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop(); // Exit the app
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
