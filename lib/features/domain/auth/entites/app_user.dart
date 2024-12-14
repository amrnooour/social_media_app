class AppUser {
  String uid;
  String name;
  String email;

 AppUser({required this.uid,required this.email,required this.name});

 Map<String,dynamic> toJson(){
  return {
    "uid" :uid,
    "name" :name,
    "email":email
    };
 }

 factory AppUser.fromJson(Map<String,dynamic> json){
  return AppUser(
    uid: json["uid"],
     email: json["email"],
      name: json["name"]);
 }
}