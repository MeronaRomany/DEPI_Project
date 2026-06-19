import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/notification_cubit.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: Text("Notifications")),
      body: Column(
        spacing: 5,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment:Alignment.centerLeft ,
                child: Text("Near You",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
          ),
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationSuccess) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: state.namePlaces.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 60,
                          width: double.infinity,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.grey[200],
                          ),
                          child: Row(
                            children: [
                              Text(state.namePlaces[index]),
                              Spacer(),
                              IconButton(onPressed: (){}, icon: Icon(Icons.location_on,size: 20,))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              }

              if (state is NotificationFail) {
                return Center(
                  child: Text(
                    state.messageError,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              return Center(child: Text("No notifications yet"));
            },
          ),
        ],
      )
    );
  }
}
