import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

import '../../../utilities/constanst.dart';

import '../../../witgets/network_image_with_loader.dart';

class DetailImages extends StatefulWidget {
  const DetailImages({
    super.key,
    required this.data,
  });

  final List<dynamic> data;

  @override
  State<DetailImages> createState() => _DetailImagesState();
}

class _DetailImagesState extends State<DetailImages> {
  late PageController _controller;

  int _currentPage = 0;
  List<String> images = [];

  @override
  void initState() {
    setImgs();
    _controller =
        PageController(viewportFraction: 0.9, initialPage: _currentPage);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  setImgs() {
    //print("************Pintar Imagenes: 1************");
    //print(widget.data['media_gallery_entries']);
    widget.data.forEach((element) {
      images.add(pathMedia(element['file']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: crearSlider()

        /*AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              onPageChanged: (pageNum) {
                setState(() {
                  _currentPage = pageNum;
                });
              },
              itemCount: images.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: defaultPadding),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(defaultBorderRadious * 2),
                  ),
                  child: NetworkImageWithLoader(images[index]),
                ),
              ),
            ),
            if (images.length > 1)
              Positioned(
                height: 20,
                bottom: 24,
                right: MediaQuery.of(context).size.width * 0.15,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Row(
                    children: List.generate(
                      images.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                            right: index == (images.length - 1)
                                ? 0
                                : defaultPadding / 4),
                        child: CircleAvatar(
                          radius: 3,
                          backgroundColor: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withOpacity(index == _currentPage ? 1 : 0.2),
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),*/
        );
  }

  CarouselSlider crearSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        pauseAutoPlayOnTouch: true,
        enableInfiniteScroll: true,
        viewportFraction: 0.8,
      ),
      items: images.map((imagen) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: imagen != "assets/notFoundImg.png"
                  ? NetworkImageWithLoader(imagen)
                  : Image.asset(
                      imagen,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            );
          },
        );
      }).toList(),
    );
  }
}
