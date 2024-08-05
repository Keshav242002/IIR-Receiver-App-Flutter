import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:iir_receiver/Pages/service_list.dart';
import 'package:iir_receiver/components/AppBarContainer.dart';
import 'package:iir_receiver/components/my_drawer.dart';
import 'package:iir_receiver/components/my_visible_indicator.dart';
import '../models/event_model.dart';
import '../utils/constants.dart';
import '../utils/my_logo_alert.dart';
import 'package:intl/intl.dart';

class SelectEvent extends StatefulWidget {
  const SelectEvent({super.key});
  static const String id = 'select_event';

  @override
  State<SelectEvent> createState() => _SelectEventState();
}

class _SelectEventState extends State<SelectEvent> {

  bool isLoading = true;
  List<Detail> lstEvents = [];
  TextEditingController server = TextEditingController();

  @override
  void initState() {
    importEvents();
    super.initState();
  }

  void importEvents() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";

    String url = 'get_events.php';

    await dio.get(url,).then((value) {
      setState(() {
        isLoading = false;
        EventModel eventModel = EventModel.fromJson(value.data);
        if (eventModel.status) {
          lstEvents.addAll(eventModel.result.details);
        }
        else {
          myLogoAlert(
              context: context, message: eventModel.message, navigateEnabled: true, route: '');
        }
      });
    });
  }
  String showDate(String eventDate){
    DateTime now=DateTime.parse(eventDate);
    DateFormat formatter=DateFormat('dd-MMM-yy');
    String formatted=formatter.format(now);
    return formatted;
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Choose Event',style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: const AppBarContainer(

        ),
      ),
      drawer: const MyDrawer(),
      backgroundColor: kColorWhite,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              myVisibleIndicator(isVisible: isLoading),

              lstEvents.isNotEmpty ? Expanded(child: ListView.builder(
                itemCount: lstEvents.length,
                  itemBuilder: (BuildContext context,int index){
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Container(

                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),

                        decoration: BoxDecoration(
                          color: kColorGreen,
                          border: Border.all(color: kColorGreen),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          showDate(lstEvents[index].startDate),
                          style: const TextStyle(fontSize: 12, color: kColorWhite),
                        ),
                      ),
                      title: Text(lstEvents[index].eventName,style: kListNameStyle ,),

                      onTap:(){
                        glbEventId=lstEvents[index].id;
                        glbEventName=lstEvents[index].eventName;
                        Navigator.pushNamed(context, SelectService.id);
                      } ,
                    ),

                  );
                  })
              ) : const Text('Fetching Details.....')
            ],
          )
        ],
      ),
    );
  }
}
