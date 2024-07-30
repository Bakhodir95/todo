import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/controllers/course_controller.dart';
import 'package:todo/controllers/favorute_course_controller.dart';
import 'package:todo/models/course.dart';
import 'package:todo/utils/app_consts.dart';
import 'package:todo/views/screens/course_screen.dart';
import 'package:todo/views/widgets/search_view_delegate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  Function() mainSetState;
  HomePage({super.key, required this.mainSetState});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Course> filterData = [];

  FavoriteCourseController favoruteCourseController = FavoriteCourseController();
  CourseController courseController = CourseController();

  onFavoruite(Course course) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userId = sharedPreferences.getString("localId")!;
    if (!course.isLike) {
      await favoruteCourseController.addFavoriteCourse(course, userId);
    } else {
      favoruteCourseController.deleteFavorite(course, userId);
    }
    course.isLike = !course.isLike;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: Text(AppLocalizations.of(context)!.homepage),
            centerTitle: true,
            actions: [
              DropdownButton(
                value: AppConsts.lenguage,
                items: const [
                  DropdownMenuItem(
                    value: "uz",
                    child: Text("uz"),
                  ),
                  DropdownMenuItem(
                    value: "en",
                    child: Text("en"),
                  )
                ],
                onChanged: (value) {
                  AppConsts.lenguage = value!;
                  setState(() {
                    widget.mainSetState();
                  });
                },
              ),
              IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.replay_outlined))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/todo');
                },
                child: Card(
                  color: Colors.amber,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width / 2 - 40,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.todos,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/note');
                },
                child: Card(
                  color: Colors.amber,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width / 2 - 40,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.notes,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
          const Gap(5),
          Text(
            AppLocalizations.of(context)!.course,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          Expanded(
              child: FutureBuilder(
            future: courseController.getCourse(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Image.asset("assets/gifs/loading.gif");
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text("Malumot yo'q"),
                );
              }
              List<Course> courses = snapshot.data!;
              if (filterData.isNotEmpty) {
                courses = filterData;
              }
              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        Course? result = await showSearch(
                          context: context,
                          delegate: SearchViewDelegate(courses),
                        );
                        if (result != null) filterData.add(result);
                        setState(() {});
                      },
                      icon: const Icon(Icons.search),
                    ),
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Card(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CourseScreen(
                                            course: courses[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                          child: FadeInImage(
                                            height: 170,
                                            width: double.infinity,
                                            placeholder: const AssetImage('assets/gifs/loading2.gif'),
                                            image: NetworkImage(
                                              courses[index].imageUrl,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const Gap(10),
                                        Row(
                                          children: [
                                            Text(
                                              courses[index].title,
                                              style: const TextStyle(fontSize: 20),
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.bookmark_add_outlined),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                onFavoruite(courses[index]);
                                              },
                                              icon: courses[index].isLike
                                                  ? const Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                    )
                                                  : const Icon(Icons.favorite_border),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(20)
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
