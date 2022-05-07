import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/login.dart';
import 'package:provider/provider.dart';
import 'package:mml_admin/components/horizontal_spacer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<LoginViewModel>(
        create: (context) => LoginViewModel(),
        builder: (context, _) {
          var vm = Provider.of<LoginViewModel>(context, listen: false);
          return FutureBuilder(
            future: vm.init(context),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator()
                );
              }
              return Form(
                key: vm.formKey,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 400,
                      minHeight: 250,
                      maxWidth: 400,
                      maxHeight: 500
                    ),
                    child: Column(
                      children: [
                        // TODO: Design logo and title
                        Text(vm.locales.login),
                        spacer,
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: vm.locales.username,
                            icon: const Icon(Icons.person),
                          ),
                          onSaved: (String? username) {
                            vm.username = username!;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: vm.validateUsername,
                        ),
                        spacer,
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: vm.locales.password,
                            icon: const Icon(Icons.lock),
                          ),
                          onSaved: (String? password) {
                            vm.password = password!;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: vm.validatePassword,
                        ),
                        spacer,
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: vm.clientIdLabel,
                            icon: const Icon(Icons.credit_score),
                          ),
                          onSaved: (String? clientId) {
                            vm.clientId = clientId;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: vm.validateClientId,
                          onChanged: (String? clientId) {
                            vm.clientId = clientId;
                          },
                        ),
                        spacer,
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: vm.serverNameLabel,
                            icon: const Icon(Icons.storage),
                          ),
                          onSaved: (String? serverName) {
                            vm.serverName = serverName;
                          },
                          validator: vm.validateServerName,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (String? serverName) {
                            vm.serverName = serverName;
                          },
                        ),
                        spacer,
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: vm.appKeyLabel,
                            icon: const Icon(Icons.vpn_key_outlined),
                          ),
                          onSaved: (String? appKey) {
                            vm.appKey = appKey;
                          },
                          validator: vm.validateAppKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (String? appKey) {
                            vm.appKey = appKey;
                          },
                        ),
                        spacer,
                        spacer,
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            child: Text(vm.locales.login),
                            onPressed: vm.login
                          )
                        )
                      ]
                    )
                  )
                )
              );
            }
          );
        }
      )
    );
  }
}
