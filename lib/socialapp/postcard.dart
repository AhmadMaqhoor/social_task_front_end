// import 'package:flutter/material.dart';
// import 'package:isd_project/socialapp/commentspage.dart';
// import 'package:isd_project/socialapp/comment.dart';
// import 'package:isd_project/socialapp/addcomment.dart';

// class PostCard extends StatefulWidget {
//   const PostCard({super.key, required username, required userProfileImage, required postImage});

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         children: [
//           // here is the profilepic and username and edit
//           Container(
//             padding: EdgeInsets.symmetric(
//               vertical: 4,
//               horizontal: 16,
//             ).copyWith(right: 0),
//             child: Row(
//               children: <Widget>[
//                 CircleAvatar(
//                   radius: 16,
//                   backgroundImage: NetworkImage(
//                       'https://wallpapercave.com/wp/wp5132508.jpg'),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       left: 8,
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           'username',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => Dialog(
//                           child: ListView(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 16,
//                             ),
//                             shrinkWrap: true,
//                             children: [
//                               'Delete',
//                             ]
//                                 .map((e) => InkWell(
//                                       onTap: () {},
//                                       child: Container(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 12, horizontal: 16),
//                                         child: Text(e),
//                                       ),
//                                     ))
//                                 .toList(),
//                           ),
//                         ),
//                       );
//                     },
//                     icon: Icon(Icons.more_vert)),
//               ],
//             ),
//           ),
//           // image is here
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.35,
//             width: double.infinity,
//             child: Image.network(
//               'https://tse4.mm.bing.net/th?id=OIP._WmBMCw24x8BxSH-Wy9w1wHaFj&pid=Api&P=0&h=220',
//               fit: BoxFit.cover,
//             ),
//           ),

//           // likes and comments
//           Row(
//             children: [
//               IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
//               IconButton(
//                   onPressed: () {
//                     // Navigate to the AddCommentDialog
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AddCommentDialog(
//                           onCommentAdded: (comment) {
//                             // Handle adding the comment here
//                             print('New comment added: $comment');
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.comment)),
//               IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
//               Expanded(
//                   child: Align(
//                 alignment: Alignment.bottomRight,
//                 child: IconButton(
//                     onPressed: () {}, icon: const Icon(Icons.bookmark)),
//               ))
//             ],
//           ),
//           // description and nb of comments
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 DefaultTextStyle(
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleSmall!
//                         .copyWith(fontWeight: FontWeight.w800),
//                     child: Text(
//                       '1234 likes',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     )),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.only(
//                     top: 8,
//                   ),
//                   child: RichText(
//                     text: const TextSpan(
//                         style: TextStyle(color: Colors.black),
//                         children: [
//                           TextSpan(
//                             text: 'username',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           TextSpan(
//                             text: '  the description will be placed here',
//                           ),
//                         ]),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return CommentsPage(
//                           List.generate(
//                             10,
//                             (index) => Comment(
//                               username: 'User ${index + 1}',
//                               comment: 'This is a sample comment ${index + 1}',
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: Text(
//                       'show all 272 comments',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 5),
//                   child: Text(
//                     'here is the date',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
