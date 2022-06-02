import 'package:flutter/material.dart';
import 'package:ukuya_assessment/app/view/post_page.dart';
import 'package:ukuya_assessment/data/models/post_model.dart';
import 'package:ukuya_assessment/data/models/user_model.dart';
import 'package:ukuya_assessment/data/repositories/post_repo.dart';
import 'package:ukuya_assessment/data/repositories/user_repo.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Initialize [TextEditingController] for search function
  TextEditingController textController = TextEditingController();
  // Initialize [PostRepositories] for [postList]
  PostRepositories postRepo = PostRepositories();
  // Initialize [UserRepositories] for [userList]
  UserRepositories userRepo = UserRepositories();
  // Variables to use with search function
  List<UserModel> userList = [];
  List<PostModel> postList = [];
  List<PostModel> searchResult = [];

  /// Method to search for posts
  ///
  /// Requires [String] parameter for it to work
  Future<void> onSearchTextChanged(String text) async {
    searchResult.clear();

    // Rebuild widget only when empty
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    // Simple search with non sensitive case.
    //
    // Can use [string_similarity] package for better search function
    for (final post in postList) {
      if (post.title!.toLowerCase().contains(text) ||
          post.body!.toLowerCase().contains(text)) {
        searchResult.add(post);
      }
    }

    // Rebuild widget
    setState(() {});
  }

  // Workaround to call Future in [initState]
  Future<void> callDuringStart() async {
    // Fetch the list during app start
    postList = await postRepo.fetchPost();
    userList = await userRepo.fetchUser();
    // Rebuild widget after complete
    setState(() {});
  }

  @override
  void initState() {
    // Call the Future without Future mark
    callDuringStart();
    super.initState();
  }

  @override
  void dispose() {
    // Should properly dispose the controller
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ukuya Assessment'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Button
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'Search Post',
                      border: InputBorder.none,
                    ),
                    // Every [onChanged], run [onSearchTextChanged] method
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      // Reset [textController] and [onSearchTextChanged]
                      textController.clear();
                      onSearchTextChanged('');
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              // Simple check for search
              child: searchResult.isNotEmpty || textController.text.isNotEmpty
                  // Search Result view
                  ? ListView.builder(
                      itemCount: searchResult.length,
                      itemBuilder: (c, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<Widget>(
                                  builder: (_) => PostPage(
                                    post: searchResult[index],
                                    author:
                                        userList[postList[index].userId! - 1],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      leading: const CircleAvatar(
                                        child: Icon(Icons.person_rounded),
                                      ),
                                      title: Text(
                                        userList[postList[index].userId! - 1]
                                            .name!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      subtitle: Text(
                                        userList[postList[index].userId! - 1]
                                            .email!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                    Text(
                                      searchResult[index].title!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      searchResult[index].body!,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  // Default view
                  : ListView.builder(
                      itemCount: postList.length,
                      itemBuilder: (c, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<Widget>(
                                  builder: (_) => PostPage(
                                    post: postList[index],
                                    author:
                                        userList[postList[index].userId! - 1],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      leading: const CircleAvatar(
                                        child: Icon(Icons.person_rounded),
                                      ),
                                      title: Text(
                                        userList[postList[index].userId! - 1]
                                            .name!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      subtitle: Text(
                                        userList[postList[index].userId! - 1]
                                            .email!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                    Text(
                                      postList[index].title!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      postList[index].body!,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
