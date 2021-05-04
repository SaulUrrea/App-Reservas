import 'package:app_reservas/models/users.dart';
import 'package:app_reservas/pages/emprendedor.dart';
import 'package:app_reservas/pages/publicacion.dart';
import 'package:app_reservas/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

class Perfil extends StatefulWidget {
  final String username;
  Perfil({Key key, @required this.username}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final myLogic = Mylogic();
  String url = '';
  String nombreUser;
  String correo;
  String _imei;
  String uid;
  File _image;
  final picker = ImagePicker();

  Future getImage() async{

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print('image $_image');
        
        
      }     
    });
  }

  Future uploadPic(BuildContext context) async{
      String fileName = basename(_image.path);
       StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
       StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
       StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
       setState(() {
          print("Profile Picture uploaded");
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
       });
    }

  Future<void> getCorreo() async {
    _imei =
        await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    await Firestore.instance
        .collection('dispositivos')
        .document(_imei)
        .get()
        .then((DocumentSnapshot document) {
      setState(() {
        correo = document['id_usuario'];
      });
    });
    myLogic.getUser(correo: correo);
  }

  @override
  void initState() {
    super.initState();
    getCorreo();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((val) {
      uid = val.uid;
    });
    return correo != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamed(context, 'login');
                    })
              ],
              title: Center(
                  child: Text(
                '        Mi perfil',
                style: TextStyle(color: Colors.black, fontSize: 20),
              )),
            ),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg.png"),
                      fit: BoxFit.cover)),
              child: Center(
                  child: ValueListenableBuilder(
                      valueListenable: myLogic.usuario,
                      builder: (context, usuario, _) {
                        return usuario != null
                            ? ListView.builder(
                                itemCount: usuario.length,
                                itemBuilder: (_, index) => Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                              padding: EdgeInsets.only(
                
                                                left: 200
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.save,
                                                  size: 40.0,
                                                ),
                                                onPressed: () {
                                                  uploadPic(context);
                                                  Firestore.instance
                                                  .collection('usuarios')
                                                  .document(uid)
                                                  .updateData({'url': _image.toString()})
                                                  .then((value) => print("Imagen actualizada"))
                                                  .catchError((error) =>
                                                      print("Failed to update image: $error"));
                                                },
                                              ),
                                            ),
                                     Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                           
                                            
                                            Align(
                                              alignment: Alignment.topRight,
                                              
                                              child: CircleAvatar(
                                                
                                                  backgroundColor: Colors.black26,
                                                
                                                  radius: 90,
                                                  child: ClipOval( 
                                                    
                                                    child:new SizedBox(
                                                      width:180,
                                                      height:180,
                                                     
                                                      child: (_image!=null)?Image.file(
                                                        _image,
                                                        fit: BoxFit.fill,
                                                      ):Image.network("https://pm1.narvii.com/6810/24eb654157df51fc42d1b50e203d8aaf75250e8cv2_00.jpg",
                                                      fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  )
                                                ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 120.0,
                                               
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.add,
                                                  size: 40.0,
                                                  
                                                ),
                                                onPressed: () {
                                                  getImage();
                                                },
                                              ),
                                            ),
                                            
                                            
                                          ],
                                          
                                        ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ListTile(
                                      title: Text(
                                        '${usuario[index].nombre}',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 25),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.black45,
                                    ),
                                    ListTile(
                                      title: Text(
                                          'Correo electronico: ${usuario[index].correo}'),
                                    ),
                                    Divider(
                                      color: Colors.black45,
                                    ),
                                    ListTile(
                                      title: Text(
                                          'Fecha de nacimiento: ${usuario[index].fecha}'),
                                    ),
                                    Divider(
                                      color: Colors.black45,
                                    ),
                                    _crearBoton(
                                        usuario[index].emprendedor, context),
                                  ],
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              );
                      })),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
  }


  Widget _crearBoton(bool validacion, context) {
    final Widget cliente = RaisedButton(
        shape: StadiumBorder(),
        child: Text('Conviértete en un emprendedor',
            style: TextStyle(color: Colors.black, fontSize: 16)),
        color: Colors.greenAccent,
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => Formulario(
                        usuario: widget.username,
                      )),
              (Route<dynamic> route) => false);
        });

    final Widget emprendedor = RaisedButton(
        shape: StadiumBorder(),
        child: Text('Crea una publicación',
            style: TextStyle(color: Colors.black, fontSize: 16)),
        color: Colors.greenAccent,
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => PublicacionPage(
                        usuario: widget.username,
                      )),
              (Route<dynamic> route) => false);
        });

    if (validacion == true) {
      return emprendedor;
    } else {
      return cliente;
    }
  }
}
