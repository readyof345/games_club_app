
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const GamesClubApp());

class AppColors {
  static const bg = Color(0xFF07101B);
  static const panel = Color(0xFF111C2A);
  static const top = Color(0xFF202B3E);
  static const cyan = Color(0xFF10C5D5);
  static const purple = Color(0xFF6A3D9B);
  static const text2 = Color(0xFF9BA7B7);
}

class GamesClubApp extends StatelessWidget {
  const GamesClubApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Games Club',
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.cyan, brightness: Brightness.dark),
      useMaterial3: true,
    ),
    home: const Gate(),
  );
}

class Gate extends StatefulWidget {
  const Gate({super.key});
  @override State<Gate> createState()=>_GateState();
}
class _GateState extends State<Gate>{
  bool? logged;
  @override void initState(){super.initState(); _load();}
  Future<void> _load() async {
    final p=await SharedPreferences.getInstance();
    setState(()=>logged=p.getBool('logged')??false);
  }
  @override Widget build(BuildContext c)=>logged==null?const Splash():logged! ? const Shell():const LoginPage();
}

class Splash extends StatelessWidget{
  const Splash({super.key});
  @override Widget build(BuildContext c)=>const Scaffold(
    body: Center(child: Column(mainAxisSize: MainAxisSize.min, children:[
      Icon(Icons.sports_esports,size:80,color:AppColors.cyan),
      SizedBox(height:15),Text('Games Club',style:TextStyle(fontSize:30,fontWeight:FontWeight.w800))
    ])
  );
}

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  @override State<LoginPage> createState()=>_LoginState();
}
class _LoginState extends State<LoginPage>{
  final name=TextEditingController();
  final email=TextEditingController();
  bool loading=false;
  Future<void> login() async {
    if(name.text.trim().isEmpty){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Enter your name')));return;}
    setState(()=>loading=true);
    final p=await SharedPreferences.getInstance();
    await p.setBool('logged',true);
    await p.setString('name',name.text.trim());
    await p.setString('email',email.text.trim());
    if(mounted) Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const Shell()));
  }
  @override Widget build(BuildContext c)=>Scaffold(
    body: SafeArea(child: Padding(
      padding:const EdgeInsets.all(28),
      child: Column(mainAxisAlignment:MainAxisAlignment.center,children:[
        const Icon(Icons.sports_esports,size:76,color:AppColors.cyan),
        const SizedBox(height:14),
        const Text('Games Club',style:TextStyle(fontSize:34,fontWeight:FontWeight.w900)),
        const SizedBox(height:7),
        const Text('Play • Compete • Connect',style:TextStyle(color:AppColors.text2)),
        const SizedBox(height:40),
        TextField(controller:name,decoration:const InputDecoration(labelText:'Your name',prefixIcon:Icon(Icons.person),border:OutlineInputBorder())),
        const SizedBox(height:14),
        TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'Email (optional)',prefixIcon:Icon(Icons.email),border:OutlineInputBorder())),
        const SizedBox(height:22),
        SizedBox(width:double.infinity,height:52,child:FilledButton(onPressed:loading?null:login,child:Text(loading?'Please wait...':'Continue'))),
      ])
    ))
  );
}

class Shell extends StatefulWidget{
  const Shell({super.key});
  @override State<Shell> createState()=>_ShellState();
}
class _ShellState extends State<Shell>{
  int index=0;
  final pages=const [HomePage(),MatchesPage(),NotificationsPage(),ProfilePage()];
  @override Widget build(BuildContext c)=>Scaffold(
    body: pages[index],
    bottomNavigationBar: NavigationBar(
      selectedIndex:index,
      onDestinationSelected:(i)=>setState(()=>index=i),
      destinations:const [
        NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Home'),
        NavigationDestination(icon:Icon(Icons.emoji_events_outlined),selectedIcon:Icon(Icons.emoji_events),label:'Matches'),
        NavigationDestination(icon:Icon(Icons.notifications_outlined),selectedIcon:Icon(Icons.notifications),label:'Alerts'),
        NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Profile'),
      ],
    ),
  );
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override State<HomePage> createState()=>_HomeState();
}
class _HomeState extends State<HomePage>{
  int banner=0;
  final banners=[
    ('FREE FIRE','Free matches are open today!',Icons.local_fire_department),
    ('TOURNAMENT','Join a friendly community match',Icons.emoji_events),
    ('GAMES CLUB','Play • Compete • Connect',Icons.sports_esports),
  ];
  @override Widget build(BuildContext c)=>Scaffold(
    body:SafeArea(child:SingleChildScrollView(
      padding:const EdgeInsets.only(bottom:20),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        _header(),
        const SizedBox(height:8),
        _banner(),
        const SizedBox(height:20),
        _support(),
        const SizedBox(height:28),
        const Padding(padding:EdgeInsets.symmetric(horizontal:28),child:Text('Games',style:TextStyle(fontSize:25,fontWeight:FontWeight.w800))),
        const SizedBox(height:14),
        _game('Free Fire Matches','FREE COMMUNITY MATCHES',Icons.local_fire_department),
        _game('Ludo King','FRIENDLY 1 VS 1',Icons.casino),
        _game('Coming Soon','MORE GAMES',Icons.grid_view),
      ])
    ))
  );
  Widget _header()=>Container(color:AppColors.top,padding:const EdgeInsets.fromLTRB(20,14,18,14),child:Row(children:[
    const Icon(Icons.sports_esports,color:AppColors.cyan,size:38),
    const SizedBox(width:10),const Expanded(child:Text('Games Club',style:TextStyle(fontSize:28,fontWeight:FontWeight.w900))),
    IconButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const NotificationsPage())),icon:const Icon(Icons.notifications,color:Colors.amber)),
  ]));
  Widget _banner(){final b=banners[banner];return Column(children:[
    Container(height:220,width:double.infinity,decoration:const BoxDecoration(gradient:LinearGradient(colors:[Color(0xFF17283A),Color(0xFF08111D)])),child:Stack(children:[
      Positioned(left:25,top:55,child:Icon(b.$3,size:105,color:Colors.orange)),
      Positioned(left:155,top:52,right:15,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(b.$1,style:const TextStyle(color:Color(0xFF8EEFFF),fontWeight:FontWeight.w800)),
        const SizedBox(height:7),Text(b.$2,style:const TextStyle(fontSize:28,fontWeight:FontWeight.w900)),
      ]))
    ])),
    const SizedBox(height:10),Row(mainAxisAlignment:MainAxisAlignment.center,children:List.generate(3,(i)=>GestureDetector(
      onTap:()=>setState(()=>banner=i),child:Container(width:i==banner?38:12,height:10,margin:const EdgeInsets.all(5),decoration:BoxDecoration(color:i==banner?AppColors.cyan:Colors.grey,borderRadius:BorderRadius.circular(20)))
    )))
  ]);}
  Widget _support()=>Container(margin:const EdgeInsets.symmetric(horizontal:26),padding:const EdgeInsets.all(18),decoration:BoxDecoration(
    gradient:const LinearGradient(colors:[Color(0xFF0B3153),Color(0xFF3A2757)]),borderRadius:BorderRadius.circular(25),
  ),child:Row(children:[
    const CircleAvatar(radius:31,backgroundColor:Color(0xFF174C78),child:Icon(Icons.support_agent,size:34)),
    const SizedBox(width:15),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text('Need any Help?',style:TextStyle(fontSize:20,fontWeight:FontWeight.w800)),Text('Customer Support',style:TextStyle(color:AppColors.text2))
    ])),
    OutlinedButton(onPressed:()=>showSupport(context),child:const Text('Contact'))
  ]));
  Widget _game(String title,String sub,IconData icon)=>Container(
    margin:const EdgeInsets.fromLTRB(26,0,26,15),height:145,padding:const EdgeInsets.all(18),
    decoration:BoxDecoration(color:AppColors.panel,borderRadius:BorderRadius.circular(22),border:Border.all(color:Colors.white10)),
    child:Row(children:[
      Container(width:88,height:108,decoration:BoxDecoration(color:Colors.white10,borderRadius:BorderRadius.circular(17)),child:Icon(icon,size:55,color:Colors.white)),
      const SizedBox(width:22),Column(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(title,style:const TextStyle(fontSize:21,fontWeight:FontWeight.w800)),const SizedBox(height:8),
        Text(sub,style:const TextStyle(fontSize:11,color:AppColors.text2,letterSpacing:1.5)),
      ])
    ])
  );
}

class MatchesPage extends StatefulWidget{
  const MatchesPage({super.key});
  @override State<MatchesPage> createState()=>_MatchesState();
}
class _MatchesState extends State<MatchesPage>{
  final matches=[
    ('Free Fire • Squad','Today • 8:00 PM','32/48',Icons.local_fire_department),
    ('Ludo • 1 vs 1','Tomorrow • 6:30 PM','1/2',Icons.casino),
    ('Free Fire • Duo','Saturday • 9:00 PM','18/24',Icons.local_fire_department),
  ];
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('Matches')),body:ListView(
    padding:const EdgeInsets.all(18),children:[
      const Text('Upcoming matches',style:TextStyle(fontSize:24,fontWeight:FontWeight.w800)),
      const SizedBox(height:14),
      ...matches.map((m)=>Card(
        color:AppColors.panel,child:Padding(padding:const EdgeInsets.all(18),child:Row(children:[
          CircleAvatar(radius:28,backgroundColor:AppColors.cyan.withOpacity(.15),child:Icon(m.$4,color:AppColors.cyan)),
          const SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text(m.$1,style:const TextStyle(fontWeight:FontWeight.w800,fontSize:17)),Text(m.$2,style:const TextStyle(color:AppColors.text2)),Text('Players: ${m.$3}',style:const TextStyle(color:AppColors.text2))
          ])),
          FilledButton(onPressed:()=>_join(m.$1),child:const Text('Join'))
        ])))
    ]));
  void _join(String title){showDialog(context:context,builder:(_)=>AlertDialog(
    title:const Text('Join match'),content:Text('You are joining $title. This demo uses no paid entry or cash rewards.'),
    actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cancel')),FilledButton(onPressed:(){Navigator.pop(context);ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Joined successfully!')));},child:const Text('Join'))]
  ));}
}

class NotificationsPage extends StatelessWidget{
  const NotificationsPage({super.key});
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('Notifications')),body:ListView(children:[
    ListTile(leading:const CircleAvatar(child:Icon(Icons.emoji_events)),title:const Text('New match available'),subtitle:const Text('A Free Fire community match is open.')),
    ListTile(leading:const CircleAvatar(child:Icon(Icons.campaign)),title:const Text('Welcome to Games Club'),subtitle:const Text('Have fun and play fairly.')),
    ListTile(leading:const CircleAvatar(child:Icon(Icons.info)),title:const Text('Safety reminder'),subtitle:const Text('Never share your password or verification codes.')),
  ]));
}

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});
  @override State<ProfilePage> createState()=>_ProfileState();
}
class _ProfileState extends State<ProfilePage>{
  String name='Player',email='';
  @override void initState(){super.initState();_load();}
  Future<void> _load()async{final p=await SharedPreferences.getInstance();setState((){name=p.getString('name')??'Player';email=p.getString('email')??'';});}
  Future<void> _logout()async{final p=await SharedPreferences.getInstance();await p.clear();if(mounted)Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const LoginPage()),(_)=>false);}
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('Profile')),body:ListView(padding:const EdgeInsets.all(22),children:[
    const CircleAvatar(radius:48,backgroundColor:AppColors.purple,child:Icon(Icons.person,size:55)),
    const SizedBox(height:14),Center(child:Text(name,style:const TextStyle(fontSize:25,fontWeight:FontWeight.w800))),if(email.isNotEmpty)Center(child:Text(email,style:const TextStyle(color:AppColors.text2))),
    const SizedBox(height:28),
    Card(color:AppColors.panel,child:Column(children:[
      const ListTile(leading:Icon(Icons.emoji_events),title:Text('Matches joined'),trailing:Text('0')),
      const Divider(height:1),const ListTile(leading:Icon(Icons.stars),title:Text('Community points'),trailing:Text('0')),
    ])),
    const SizedBox(height:14),
    ListTile(leading:const Icon(Icons.help_outline),title:const Text('Help & Support'),onTap:()=>showSupport(context)),
    ListTile(leading:const Icon(Icons.info_outline),title:const Text('About'),onTap:()=>showAbout(context)),
    const SizedBox(height:10),
    OutlinedButton.icon(onPressed:_logout,icon:const Icon(Icons.logout),label:const Text('Log out')),
  ]));
}

void showSupport(BuildContext c)=>showDialog(context:c,builder:(_)=>AlertDialog(
  title:const Text('Customer Support'),content:const Text('For a production app, connect this button to your support chat, email, or ticket system.'),
  actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('Close'))],
));
void showAbout(BuildContext c)=>showDialog(context:c,builder:(_)=>AlertDialog(
  title:const Text('Games Club'),content:const Text('A starter gaming community app. This version is designed for non-monetary matches and does not include betting, deposits, withdrawals, or cash prizes.'),
  actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('OK'))],
));
