import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user_info.dart';
import '../../utils.dart';

class UpdateProfileScreen extends StatelessWidget {
  final UserInfo? userInfo;
  const UpdateProfileScreen({Key? key, this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageBytes = base64FromDataUri(userInfo!.imageUrl);
    final tFullName = userInfo!.fullName;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.edit)),
        title: Text("Edit Profile", style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.memory(
                          imageBytes,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.blue),
                      child: const Icon(Icons.camera, color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text("tFullName"), prefixIcon: Icon(Icons.account_circle)),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text("tEmail"), prefixIcon: Icon(Icons.eighteen_mp)),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text("tPhoneNo"), prefixIcon: Icon(Icons.phone)),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: const Text("tPassword"),
                        prefixIcon: const Icon(Icons.fingerprint),
                        suffixIcon:
                        IconButton(icon: const Icon(Icons.remove_red_eye_outlined), onPressed: () {}),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.to(() => const UpdateProfileScreen()),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("tEditProfile", style: TextStyle(color: Colors.black45)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // -- Created Date and Delete Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text.rich(
                          TextSpan(
                            text: "tJoined",
                            style: TextStyle(fontSize: 12),
                            children: [
                              TextSpan(
                                  text: "tJoinedAt",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.withOpacity(0.1),
                              elevation: 0,
                              foregroundColor: Colors.red,
                              shape: const StadiumBorder(),
                              side: BorderSide.none),
                          child: const Text("tDelete"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}