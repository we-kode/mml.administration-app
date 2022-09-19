import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/login.dart';
import 'package:provider/provider.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/models/user.dart';

/// Login screen where user can pass his login information and get logged in to
/// the administration application.
class LoginScreen extends StatelessWidget {
  /// Initializes the instance.
  const LoginScreen({Key? key}) : super(key: key);

  /// Builds the screen with the login form.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<LoginViewModel>(
        create: (context) => LoginViewModel(),
        builder: (context, _) {
          var vm = Provider.of<LoginViewModel>(context, listen: false);
          return FutureBuilder(
            future: vm.init(context),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // Redirect the user to the change password view, if the user is
              // logged in on startup and hence the user id is set.
              var user = snapshot.data as User;
              if (user.id != null) {
                Future.microtask(
                  () async {
                    await vm.afterLogin(user);
                  },
                );
                return Container();
              }

              return Center(
                child: Form(
                  key: vm.formKey,
                  child: SizedBox(
                    width: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo_admin.png',
                          width: 256,
                          height: 256,
                        ),
                        verticalSpacer,
                        verticalSpacer,
                        verticalSpacer,
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
                        verticalSpacer,
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
                        verticalSpacer,
                        ExpansionTile(
                          leading: const Icon(Icons.extension),
                          initiallyExpanded: vm.showAdvanced,
                          maintainState: true,
                          title: Text(vm.locales.advanced),
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: vm.clientIdLabel,
                                icon: const Icon(Icons.credit_score),
                              ),
                              onSaved: (String? clientId) {
                                vm.clientId = clientId;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: vm.validateClientId,
                              onChanged: (String? clientId) {
                                vm.clientId = clientId;
                              },
                            ),
                            verticalSpacer,
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: vm.serverNameLabel,
                                icon: const Icon(Icons.storage),
                              ),
                              onSaved: (String? serverName) {
                                vm.serverName = serverName;
                              },
                              validator: vm.validateServerName,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (String? serverName) {
                                vm.serverName = serverName;
                              },
                            ),
                            verticalSpacer,
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: vm.appKeyLabel,
                                icon: const Icon(Icons.vpn_key_outlined),
                              ),
                              onSaved: (String? appKey) {
                                vm.appKey = appKey;
                              },
                              validator: vm.validateAppKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (String? appKey) {
                                vm.appKey = appKey;
                              },
                            ),
                            verticalSpacer,
                          ],
                        ),
                        verticalSpacer,
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: vm.login,
                            child: Text(vm.locales.login),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
