import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//   contactList ()async{
//     // Get all contacts
//     final contacts = await FastContacts.allContacts;
//
// // Get first contact's image (thumbnail)
//     final thumbnail = await FastContacts.getContactImage(contacts[0].id);
//
// // Get first contact's image (full size)
//     final imageThubnail = await FastContacts.getContactImage(contacts[0].id, size: ContactImageSize.fullSize);
//   }

Future<List<Contact>>getContacts()async{
  bool isGranted=await Permission.contacts.status.isGranted;
  if(!isGranted){
    isGranted=await Permission.contacts.request().isGranted;
  }
  if(isGranted){
    return     await FastContacts.allContacts;
  }
  return [];

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact List"),
        centerTitle: true,
      ),


      body: Container(
        height: double.infinity,
        child: FutureBuilder(
          future: getContacts(),
            builder: (ctx, AsyncSnapshot snapshot){
           if(snapshot.data==null){
             return const Center(
               child: CircularProgressIndicator(),
             );
           }
           return ListView.builder(
             itemCount: snapshot.data.length ,
               itemBuilder: (context,index){
               Contact contact=snapshot.data[index];
                 return Column(
                   children: [
                     ListTile(
                       leading: const CircleAvatar(
                         radius: 20,
                         child: Icon(Icons.person),
                       ),
                       title: Text(contact.displayName),
                       subtitle: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(contact.phones[0]),



                           // Text(contact.emails[0]),
                         ],
                       ),
                     ),
                     const Divider(
                       thickness: 1,
                       color: Colors.black,
                     )
                   ],
                 );
               });
            }
        ),
      )
    );
  }
}
