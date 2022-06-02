import 'package:flutter/material.dart';
import 'package:ukuya_assessment/data/models/comment_model.dart';
import 'package:ukuya_assessment/data/models/post_model.dart';
import 'package:ukuya_assessment/data/models/user_model.dart';
import 'package:ukuya_assessment/data/repositories/comment_repo.dart';

class PostPage extends StatelessWidget {
  PostPage({super.key, this.post, this.author});

  final PostModel? post;
  final UserModel? author;
  final CommentRepositories commentRepo = CommentRepositories();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ukuya Assessment'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  child: Icon(Icons.person_rounded),
                ),
                title: Text(
                  author!.name!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                subtitle: Text(
                  author!.email!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Text(
                post!.title!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                post!.body!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 30),
              const Divider(height: 20),
              Text(
                'Comments:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              FutureBuilder<List<CommentModel>>(
                future: commentRepo.fetchComment(postId: post!.id),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 20),
                      child: const CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    // Use [Column] with [List.generate]
                    // to dynamically generate the comments
                    return Column(
                      children: List.generate(snapshot.data!.length, (index) {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.person_rounded),
                                  ),
                                  title: Text(
                                    snapshot.data![index].name!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  subtitle: Text(
                                    snapshot.data![index].email!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  snapshot.data![index].body!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 20),
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
