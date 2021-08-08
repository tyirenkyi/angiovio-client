import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../utils.dart';
import '../widgets/DrugItem.dart';
import '../providers/drug.dart';
import '../providers/drug_provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _greeting = '';
  String _date = '';
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loadGreetingAndDate() {
    String date = getDate();
    String greeting = determineGreeting();
    setState(() {
      _greeting = greeting;
      _date = date;
    });
  }


  @override
  void initState() {
    loadGreetingAndDate();
    super.initState();
  }

  void _showDrugDetail(Drug drug) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10)
            )
        ),
        builder: (BuildContext ctx) {
          return _buildDrugDetailBottomSheet(drug);
        }
    );
  }

  Widget _buildDrugDetailBottomSheet(Drug drug) {
    double screenHeight = MediaQuery.of(context).size.height;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
      child: Container(
        height: screenHeight * 0.8,
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: BoxDecoration(
          color: Color.fromRGBO(33, 33, 33, 1)
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  drug.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.timer_rounded, color: Colors.white, size: 30,),
                  ),
                  Text(
                    'Every ${drug.interval} hours',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10),),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.medication, color: Colors.white, size: 30,),
                  ),
                  Text(
                    '${drug.dosage} mg',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 15),),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Mark As Taken',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(180, 45)
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              Text(
                'Metadata',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Text(
                'Added on ${Jiffy(drug.createdOn, 'EEE MMM dd yyyy hh:mm:ss').yMMMMd}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Taken',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey
                    ),
                  ),
                  Text(
                    '${drug.taken} dose(s)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Missed',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey
                    ),
                  ),
                  Text(
                    '${drug.missed} dose(s)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            _date,
            style: TextStyle(
              color: Colors.grey
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 5),),
          Text(
            _greeting,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          Text(
            '${_firebaseAuth.currentUser?.displayName}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 20)),
          Expanded(
            child: Consumer<DrugProvider>(
              builder: (context, drugProvider, _) {
                return ListView.builder(
                    itemCount: drugProvider.items.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                        value: drugProvider.items[index],
                        child: DrugItem(_showDrugDetail),
                      );
                    }
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
