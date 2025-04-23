import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:slider_button/slider_button.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: GithubScoutApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = true; // Set dark mode to true

  void toggleTheme() {
    isDarkMode = !isDarkMode; // Not used, but kept for future implementation
    notifyListeners();
  }
}

class GithubScoutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'GitHub Scout',
          theme: ThemeData.dark(), // Force dark theme
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the GitHub logo
            ClipOval(
              child: Image.asset(
                'assets/images/github_logo.png',  // Replace with your logo
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            // Welcome text
            Text(
              "Welcome to GitHub Scout!",
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Slider button
            Center(
              child: SliderButton(
                action: () async {
                  // Navigate to the main page when the slider is slid
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GithubScoutHomePage()),
                  );
                  return true; // Allows dismissing the widget
                },
                label: Text(
                  "Let's Scout!",
                  style: TextStyle(
                    color: Color(0xff4a4a4a),
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                // Display app icon instead of text in the slider
                icon: Image.asset(
                  'assets/images/github_logo.png',  // Path to your app icon
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GithubScoutHomePage extends StatefulWidget {
  @override
  _GithubScoutHomePageState createState() => _GithubScoutHomePageState();
}

class _GithubScoutHomePageState extends State<GithubScoutHomePage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Map<String, dynamic>? _userData;
  bool _loading = false;
  String _errorMessage = '';
  Timer? _typingTimer;
  String _typingText = 'Search for a profile...';
  bool _isEditable = false; // Track if the TextField is editable
  final Duration _debounceDuration = Duration(milliseconds: 500); // 500 ms

  Future<void> fetchGithubUser(String username) async {
    if (username.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a username';
        _userData = null;
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    final url = 'https://api.github.com/users/$username';

    // Use your actual GitHub token here (replace this string)
    final String githubToken = ''; // Replace with your actual token
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'token $githubToken', // Include the token in headers
          'Accept': 'application/vnd.github.v3+json', // Optional: specify the API version
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          _userData = json.decode(response.body);
          _loading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'User not found!';
          _userData = null;
          _loading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'An error occurred: ${response.reasonPhrase}';
          _userData = null;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _userData = null;
        _loading = false;
      });
    }
  }

  void startTypingAnimation() {
    _controller.clear();
    int index = 0;

    _focusNode.unfocus(); // Unfocus to disable input
    _isEditable = false; // Disable editing during animation
    _typingTimer?.cancel(); // Cancel any existing timer
    _typingTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (index < _typingText.length) {
        _controller.text += _typingText[index];
        index++;
      } else {
        timer.cancel();
        startBackspaceAnimation();
      }
    });
  }

  void startBackspaceAnimation() {
    int index = _controller.text.length;

    _typingTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (index > 0) {
        _controller.text = _controller.text.substring(0, index - 1);
        index--;
      } else {
        timer.cancel();
        _isEditable = true; // Allow editing after the animation
        _focusNode.requestFocus(); // Request focus back to allow user input
        setState(() {}); // Update UI to reflect editable state
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTypingAnimation();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  Widget _buildErrorMessage(String message) {
    return Text(
      message,
      style: TextStyle(color: Colors.red),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Scout'),
      ),
      body: SingleChildScrollView( // Wrap the body in a SingleChildScrollView
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 20),
            _loading
                ? Center(child: CircularProgressIndicator())
                : _userData != null
                ? _buildUserData(context)
                : _errorMessage.isNotEmpty
                ? _buildErrorMessage(_errorMessage)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: _isEditable,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search GitHub Username',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          // Cancel the previous timer if it exists
          _typingTimer?.cancel();

          if (value.isNotEmpty) {
            _typingTimer = Timer(_debounceDuration, () {
              fetchGithubUser(value); // Call the function after the debounce duration
            });
          } else {
            // If the search field is empty, you can clear the user data and error message
            setState(() {
              _userData = null;
              _errorMessage = '';
            });
          }
        },
      ),
    );
  }

  Widget _buildUserData(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Picture Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: ClipOval(
                      child: Image.network(
                        _userData!['avatar_url'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _userData!['name'] ?? 'Not Available',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    '@${_userData!['login']}',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(height: 5), // Add spacing for the bio
                  Text(
                    _userData!['bio'] ?? 'Not Available',
                    style: TextStyle(color: Colors.grey),
                    maxLines: 3, // Limit the bio display to 2 lines
                    overflow: TextOverflow.ellipsis, // Show ellipsis if the text is too long
                    textAlign: TextAlign.center, // Center-align the bio
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Stats Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoItem('Followers', _userData!['followers'].toString()),
                  _buildInfoItem('Following', _userData!['following'].toString()),
                  _buildInfoItem('Repos', _userData!['public_repos'].toString()),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Details Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem('Company', _userData!['company']),
                  _buildDetailItem('Email', _userData!['email']),
                  _buildDetailItem('Location', _userData!['location']),
                  SizedBox(height: 10),
                  _buildDetailItem('Blog', _userData!['blog']),
                  _buildDetailItem('Twitter', _userData!['twitter_username']),
                  _buildDetailItem('Hireable', _userData!['hireable'] != null ? 'Yes' : 'No'),
                  _buildDetailItem('Account Created', _userData!['created_at']),
                  _buildDetailItem('Last Updated', _userData!['updated_at']),
                  _buildDetailItem('Account ID', _userData!['id'].toString()),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Exit Button
          InkWell(
            onTap: () {
              // Close the app when the button is pressed
              SystemNavigator.pop();
            },
            borderRadius: BorderRadius.circular(30), // Round corners
            child: OutlinedButton(
              onPressed: null, // Prevent direct press on button
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white, width: 2), // White border
              ),
              child: Text(
                "Exit",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),


          // Copyright Notice
          SizedBox(height: 20),
          Text(
            '© 2024 Build By Neel Desai',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }




  Widget _buildInfoItem(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String title, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value ?? 'Not Available', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
