import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog_entities.dart';
import 'package:flutter/material.dart';

class BlogViewer extends StatelessWidget {
  static route(BlogEntities blog) =>
      MaterialPageRoute(builder: (context) => BlogViewer(blog: blog));

  final BlogEntities blog;

  const BlogViewer({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),
                Text(
                  "By @${(blog.posterName)?.toUpperCase()}",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),

                const SizedBox(height: 5),
                Text(
                  "${formatDateByMMMYYYY(blog.updatedAt)}. ${calculateReadingTime(blog.content)} min",
                  style: TextStyle(
                    color: AppPallete.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: Image.network(blog.imageUrl),
                ),

                const SizedBox(height: 20),
                Text(blog.content, style: TextStyle(fontSize: 16, height: 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
