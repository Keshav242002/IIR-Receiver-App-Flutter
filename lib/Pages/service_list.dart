import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:iir_receiver/components/AppBarContainer.dart';
import 'package:iir_receiver/components/my_visible_indicator.dart';
import 'package:iir_receiver/models/get_service_model.dart' as svc;
import '../../utils/constants.dart';
import '../../utils/my_logo_alert.dart';
import 'Barcode_Scan.dart';



class SelectService extends StatefulWidget {
  const SelectService({super.key});
  static const String id = 'select_service';

  @override
  State<SelectService> createState() => _SelectEventState();
}

class _SelectEventState extends State<SelectService> {

  bool isLoading = true;
  List<svc.Detail> lstServices = [];
  TextEditingController server = TextEditingController();

  @override
  void initState() {
    importServices();
    super.initState();
  }

  void importServices() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";


    String url = 'event_services.php/$glbEventId';

    await dio.get(url,).then((value) {
      setState(() {
        isLoading = false;
        print(value.data);
        if (value.data["status"]){
          svc.ServiceModel serviceModel = svc.ServiceModel.fromJson(value.data);
          lstServices.addAll(serviceModel.result.details);

        }


        else {
          myLogoAlert(
              context: context, message: value.data["message"], navigateEnabled: true, route: '');
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Select Services',style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: const AppBarContainer(

        ),
      ),

      backgroundColor: kColorWhite,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              myVisibleIndicator(isVisible: isLoading),

              lstServices.isNotEmpty ? Expanded(child: ListView.builder(
                  itemCount: lstServices.length,
                  itemBuilder: (BuildContext context,int index){
                    return Card(
                      elevation: 5,
                      child: ListTile(

                        title: Text(lstServices[index].serviceName,style: kListNameStyle ,),

                        onTap:(){
                          glbServiceId=lstServices[index].serviceId;
                          glbServiceName=lstServices[index].serviceName;
                          Navigator.pushNamed(context,BarcodeScannerPage.id);
                        } ,
                      ),

                    );
                  })   ) : const Text('Fetching Details.....')
            ],
          )
        ],
      ),
    );
  }
}
