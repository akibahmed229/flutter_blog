import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog_entities.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final BlogEntities blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewer.route(blog));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(16).copyWith(bottom: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.topics
                        .map(
                          (topic) => Padding(
                            padding: EdgeInsets.all(6),
                            child: Chip(label: Text(topic)),
                          ),
                        )
                        .toList(),
                  ),
                ),

                Text(
                  blog.title,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            Text('${calculateReadingTime(blog.content)} min'),
          ],
        ),
      ),
    );
  }
}
