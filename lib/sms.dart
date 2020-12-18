import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:notification_app/massage.dart';



class sms extends StatefulWidget {

  final String reloadLabel = 'Reload!';
  final String fireLabel = 'Submit';
  final Color floatingButtonColor = Colors.red;
  final IconData reloadIcon = Icons.perm_identity_rounded;
  final IconData fireIcon = Icons.perm_identity_rounded;

  @override
  _MyHomePageState createState() => new _MyHomePageState(
    floatingButtonLabel: this.fireLabel,
    icon: this.fireIcon,
    floatingButtonColor: this.floatingButtonColor,
  );
}

class _MyHomePageState extends State<sms> {
  List<Contact> _contacts = new List<Contact>();
  List<CustomContact> _uiCustomContacts = List<CustomContact>();
  List<CustomContact> _allContacts = List<CustomContact>();
  bool _isLoading = false;
  bool _isSelectedContactsView = false;
  String floatingButtonLabel;
  Color floatingButtonColor;
  IconData icon;

  TextEditingController controller = new TextEditingController();

  _MyHomePageState({
    this.floatingButtonLabel,
    this.icon,
    this.floatingButtonColor,
  });

  @override
  void initState() {
    super.initState();
    refreshContacts();
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Contacts"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.navigate_next_rounded,
              color: Colors.white,
              size: 40.0,
            ),
            onPressed: () {
              List<Contact> mylist = [];
              for(int i=0; i< _uiCustomContacts.length ; i++){
                mylist .add(_uiCustomContacts[i].contact);
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => massage(contact: mylist)));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                    },
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: !_isLoading
                ? Container(
              child: ListView.builder(
                itemCount: _uiCustomContacts?.length,
                itemBuilder: (BuildContext context, int index) {
                  CustomContact _contact = _uiCustomContacts[index];
                  var _phonesList = _contact.contact.phones.toList();

                  return _buildListTile(_contact, _phonesList);
                },
              ),
            )
                : Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton.extended(
        backgroundColor: floatingButtonColor,
        onPressed: _onSubmit,
        icon: Icon(icon),
        label: Text(floatingButtonLabel),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _onSubmit() {
    setState(() {
      if (!_isSelectedContactsView) {
        _uiCustomContacts =
            _allContacts.where((contact) => contact.isChecked == true).toList();
        _isSelectedContactsView = true;
        _restateFloatingButton(
          widget.reloadLabel,
          Icons.perm_identity_rounded,
          Colors.green,
        );
      } else {
        _uiCustomContacts = _allContacts;
        _isSelectedContactsView = false;
        _restateFloatingButton(
          widget.fireLabel,
          Icons.perm_identity_rounded,
          Colors.red,
        );
      }
    });
  }

  ListTile _buildListTile(CustomContact c, List<Item> list) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
            (c.contact.displayName[0] +
                c.contact.displayName[1].toUpperCase()),
            style: TextStyle(color: Colors.white)),
      ),
      title: Text(c.contact.displayName ?? ""),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''),
      trailing: Checkbox(
          activeColor: Colors.green,
          value: c.isChecked,
          onChanged: (bool value) {
            setState(() {
              c.isChecked = value;
            });
          }),
    );
  }

  void _restateFloatingButton(String label, IconData icon, Color color) {
    floatingButtonLabel = label;
    icon = icon;
    floatingButtonColor = color;
  }

  refreshContacts() async {
    setState(() {
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts();
    _populateContacts(contacts);
  }

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    _allContacts =
        _contacts.map((contact) => CustomContact(contact: contact)).toList();
    setState(() {
      _uiCustomContacts = _allContacts;
      _isLoading = false;
    });
  }

  onSearchTextChanged(String text) async {
    // _uiCustomContacts.clear();
    if (text.isEmpty) {
      _uiCustomContacts = _allContacts;
      setState(() {
      });
      return;
    }

    _uiCustomContacts =
        _allContacts.where((contact) => contact.contact.displayName.toLowerCase().contains(text.toLowerCase()) ).toList();
    setState(() {

    });
  }


// Future<bool> getContactsPermission() =>
//     SimplePermissions.requestPermission(Permission.ReadContacts);
}

class CustomContact {
  final Contact contact;
  bool isChecked;

  CustomContact({
    this.contact,
    this.isChecked = false,
  });
}

