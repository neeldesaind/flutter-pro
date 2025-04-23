import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';
import 'about_us_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController sipInvestmentController = TextEditingController();
  TextEditingController sipRateController = TextEditingController();
  TextEditingController sipTimeController = TextEditingController();

  TextEditingController lumpsumInvestmentController = TextEditingController();
  TextEditingController lumpsumRateController = TextEditingController();
  TextEditingController lumpsumTimeController = TextEditingController();

  double? sipMaturityAmount;
  double? sipTotalInvestedAmount;
  double? sipTotalAmount;

  double? lumpsumMaturityAmount;
  double? lumpsumTotalInvestedAmount;
  double? lumpsumTotalAmount;

  String selectedDrawerItem = 'Homepage';

  bool isSipInputValid = false;
  bool isLumpsumInputValid = false;

  String? validateRate(String? value) {
    if (value != null && double.tryParse(value) != null) {
      double rate = double.parse(value);
      if (rate > 100) {
        return 'Rate cannot be more than 100%';
      }
    }
    return null;
  }

  String? validateInvestment(String? value) {
    if (value != null && double.tryParse(value) != null) {
      double investment = double.parse(value);
      if (investment > 100000) {
        return 'Investment cannot be more than ₹1,00,000';
      }
      if (investment < 0) {
        return 'Investment cannot be negative';
      }
    }
    return null;
  }

  String? validateLumpsumInvestment(String? value) {
    if (value != null && double.tryParse(value) != null) {
      double investment = double.parse(value);
      if (investment > 100000000) {
        return 'Investment cannot be more than ₹10 Crores';
      }
      if (investment < 0) {
        return 'Investment cannot be negative';
      }
    }
    return null;
  }

  bool validateSipInputs() {
    if (validateInvestment(sipInvestmentController.text) != null ||
        validateRate(sipRateController.text) != null) {
      return false;
    }
    return true;
  }

  bool validateLumpsumInputs() {
    if (validateLumpsumInvestment(lumpsumInvestmentController.text) != null ||
        validateRate(lumpsumRateController.text) != null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "SIP & Lumpsum Calculator",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.greenAccent,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIP & Lumpsum Calculator',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Developed by TechPrenuer',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Homepage'),
                selected: selectedDrawerItem == 'Homepage',
                onTap: () {
                  setState(() {
                    selectedDrawerItem = 'Homepage';
                  });
                  Navigator.pop(context);
                },
                tileColor: selectedDrawerItem == 'Homepage' ? Colors.grey[300] : null,
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('About Us'),
                onTap: () {
                  setState(() {
                    selectedDrawerItem = 'About Us';
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share the App'),
                selected: selectedDrawerItem == 'Share the App',
                onTap: () {
                  setState(() {
                    selectedDrawerItem = 'Share the App';
                  });
                  Share.share('Check out this amazing SIP & Lumpsum Calculator app on Google Play Store: https://play.google.com/store/apps/details?id=com.techprenuer.sipcalc.sipcalc').catchError((error) {
                    print("Share error: $error");
                  });

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                indicatorColor: Colors.red,
                tabs: [
                  Tab(text: 'SIP'),
                  Tab(text: 'Lumpsum'),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: TabBarView(
                  children: [
                    _buildSIPCalculator(),
                    _buildLumpsumCalculator(),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '© Developed by :TechPrenuer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSIPCalculator() {
    return SingleChildScrollView(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: _buildInputFormField(
                  controller: sipInvestmentController,
                  labelText: 'Monthly SIP Amount (INR)',
                  prefixIcon: Icons.currency_rupee_outlined,
                  validator: validateInvestment,
                  maxDigits: 6,
                  required: true,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 20),
              _buildInputFormField(
                controller: sipRateController,
                labelText: 'Expected Gain Interest (%)',
                prefixIcon: Icons.percent_outlined,
                validator: validateRate,
                maxDigits: 3,
                required: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              _buildInputFormField(
                controller: sipTimeController,
                labelText: 'Enter Time Period (in years)',
                prefixIcon: Icons.calendar_today_outlined,
                keyboardType: TextInputType.number,
                maxDigits: 2,
                required: true,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isSipInputValid = validateSipInputs();
                      if (isSipInputValid) {
                        double investment = double.parse(sipInvestmentController.text);
                        double rate = double.parse(sipRateController.text);
                        double time = double.parse(sipTimeController.text);
                        double monthlyRate = rate / 12 / 100;
                        int months = time.toInt() * 12;
                        sipMaturityAmount = investment *
                            ((pow(1 + monthlyRate, months) - 1) * (1 + monthlyRate) / monthlyRate);
                        sipTotalInvestedAmount = investment * months;
                        sipTotalAmount = sipTotalInvestedAmount! + sipMaturityAmount!;
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                  child: Text('Calculate'),
                ),
              ),
              SizedBox(height: 20),
              if (isSipInputValid)
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'SIP Details',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        _buildOutputRow('Monthly SIP Amount:', _getDisplayAmount(double.parse(sipInvestmentController.text))),
                        _buildOutputRow('Expected Gain Interest:', '${sipRateController.text}%'),
                        _buildOutputRow('Time Period:', '${sipTimeController.text} years'),
                        SizedBox(height: 20),
                        _buildOutputRow('Maturity Amount:', _getDisplayAmount(sipMaturityAmount!)),
                        _buildOutputRow('Total Invested Amount:', _getDisplayAmount(sipTotalInvestedAmount!)),
                        _buildOutputRow('Total Amount:', _getDisplayAmount(sipTotalAmount!)),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (isSipInputValid) {
                              double investment = double.parse(sipInvestmentController.text);
                              double rate = double.parse(sipRateController.text);
                              double time = double.parse(sipTimeController.text);
                              double monthlyRate = rate / 12 / 100;
                              int months = time.toInt() * 12;
                              String message = '''
                              SIP Calculations \n
Monthly SIP Amount: ${_getDisplayAmount(investment)}\n
Expected Gain Interest: ${rate.toStringAsFixed(2)}%\n
Time Period: ${time.toStringAsFixed(2)} years\n
Maturity Amount: ${_getDisplayAmount(sipMaturityAmount!)}\n
Total Invested Amount: ${_getDisplayAmount(sipTotalInvestedAmount!)}\n
Total Amount: ${_getDisplayAmount(sipTotalAmount!)} \n

Download Amazing App from play store: https://play.google.com/store/apps/details?id=com.techprenuer.sipcalc.sipcalc
''';

                              Share.share(message.trim()).catchError((error) {
                                print("Share error: $error");
                              });
                            } else {
                              // Handle invalid input
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.green),
                            ),
                          ),
                          icon: Icon(Icons.share),
                          label: Text(
                            'Share Details',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildLumpsumCalculator() {
    return SingleChildScrollView(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: _buildInputFormField(
                  controller: lumpsumInvestmentController,
                  labelText: 'Lumpsum Investment (INR)',
                  prefixIcon: Icons.currency_rupee_outlined,
                  validator: validateLumpsumInvestment,
                  maxDigits: 9,
                  required: true,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 20),
              _buildInputFormField(
                controller: lumpsumRateController,
                labelText: 'Expected Gain Interest (%)',
                prefixIcon: Icons.percent_outlined,
                validator: validateRate,
                maxDigits: 3,
                required: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              _buildInputFormField(
                controller: lumpsumTimeController,
                labelText: 'Investment Period (in years)',
                prefixIcon: Icons.calendar_today_outlined,
                keyboardType: TextInputType.number,
                maxDigits: 2,
                required: true,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLumpsumInputValid = validateLumpsumInputs();
                      if (isLumpsumInputValid) {
                        double investment = double.parse(lumpsumInvestmentController.text);
                        double rate = double.parse(lumpsumRateController.text);
                        double time = double.parse(lumpsumTimeController.text);
                        lumpsumMaturityAmount = investment * pow(1 + rate / 100, time);
                        lumpsumTotalInvestedAmount = investment;
                        lumpsumTotalAmount = lumpsumMaturityAmount;
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                  child: Text('Calculate'),
                ),
              ),
              SizedBox(height: 20),
              if (isLumpsumInputValid)
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Lumpsum Details',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        _buildOutputRow('Lumpsum Investment:', _getDisplayAmount(double.parse(lumpsumInvestmentController.text))),
                        _buildOutputRow('Expected Gain Interest:', '${lumpsumRateController.text}%'),
                        _buildOutputRow('Investment Period:', '${lumpsumTimeController.text} years'),
                        SizedBox(height: 20),
                        _buildOutputRow('Total Invested Amount:', _getDisplayAmount(lumpsumTotalInvestedAmount!)),
                        _buildOutputRow('Total Amount:', _getDisplayAmount(lumpsumTotalAmount!)),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (isLumpsumInputValid) {
                              double investment = double.parse(lumpsumInvestmentController.text);
                              double rate = double.parse(lumpsumRateController.text);
                              double time = double.parse(lumpsumTimeController.text);
                              String message = '''
                              Lumpsum Investment Details\n
Lumpsum Investment: ${_getDisplayAmount(investment)}
Expected Gain Interest: ${rate.toStringAsFixed(2)}%
Investment Period: ${time.toStringAsFixed(2)} years
Total Invested Amount: ${_getDisplayAmount(lumpsumTotalInvestedAmount!)}\n
Total Amount: ${_getDisplayAmount(lumpsumTotalAmount!)} \n
Download Amazing App from play store: https://play.google.com/store/apps/details?id=com.techprenuer.sipcalc.sipcalc
''';
                              Share.share(message.trim()).catchError((error) {
                                print("Share error: $error");
                              });
                            } else {
                              // Handle invalid input
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.green),
                            ),
                          ),
                          icon: Icon(Icons.share),
                          label: Text(
                            'Share Details',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildInputFormField({
    required TextEditingController controller,
    required String labelText,
    IconData? prefixIcon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxDigits = 10,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType == TextInputType.number ? TextInputType.numberWithOptions(decimal: true) : keyboardType,
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return validator != null ? validator(value) : null;
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(maxDigits)],
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildOutputRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Table(
        columnWidths: {0: IntrinsicColumnWidth(), 1: FlexColumnWidth(1)},
        children: [
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  label,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDisplayAmount(double amount) {
    if (amount >= 100000000) {
      return '${(amount / 10000000).toStringAsFixed(2)} Crore';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(2)} Lakhs';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)}K';
    } else {
      return amount.toStringAsFixed(2);
    }
  }
}