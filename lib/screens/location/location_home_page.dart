import 'package:app/screens/location/location_description.dart';
import 'package:flutter/material.dart';

class LocationHome extends StatefulWidget {
  const LocationHome({super.key});

  @override
  _LocationHomeState createState() => _LocationHomeState();
}

class ImageData {
  final String imageUrl;
  final String title;
  final double rating;

  ImageData({
    required this.imageUrl,
    required this.title,
    required this.rating,
  });
}

class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function() onPressed;

  const CategoryButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: isSelected ? const Color(0xFF436850) : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  final String title;
  final List<ImageData> dataList;
  final String variant;
  // variant: large, small

  const SectionWidget({
    super.key,
    required this.title,
    required this.dataList,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const Text(
              'Xem tất cả',
              style: TextStyle(
                color: Color(0xFF436850),
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
            height: variant == 'large' ? 240 : 120,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return ImageItem(data: dataList[index], variant: variant);
                })),
        const SizedBox(height: 10),
      ],
    );
  }
}

class ImageItem extends StatelessWidget {
  final ImageData data;
  final String variant;
  // variant: large, small

  const ImageItem({super.key, required this.data, required this.variant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(data.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      width: variant == 'large' ? 200 : 180,
      height: variant == 'large' ? 240 : 220,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        variant == 'large'
                            ? Icons.star
                            : Icons.show_chart_rounded,
                        color: variant == 'large'
                            ? Colors.yellow
                            : Colors.blueAccent,
                        size: 16,
                      ),
                      Text(
                        variant == 'large'
                            ? data.rating.toString()
                            : 'Hot trend',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationHomeState extends State<LocationHome> {
  int _selectedIndex = 1;
  late double initialPositionX;
  late double currentPositionX;

  final List<ImageData> _popularFood = [
    ImageData(
        imageUrl: 'assets/images/food_banhcan.png',
        title: 'Bánh Căn',
        rating: 4.5),
    ImageData(
        imageUrl: 'assets/images/food_banhmi.png',
        title: 'Bánh mì xíu mại',
        rating: 4.0),
    ImageData(
        imageUrl: 'assets/images/food_maudich.png',
        title: 'Quán nướng Mậu Dịch',
        rating: 5.0),
    ImageData(
        imageUrl: 'assets/images/food_banhuot.png',
        title: 'Bánh ướt lòng gà',
        rating: 4.8),
    ImageData(
        imageUrl: 'assets/images/food_tuimo.png',
        title: 'Nhà hàng Túi Mơ',
        rating: 4.3),
  ];

  final List<ImageData> _recommendedFood = [
    ImageData(
        imageUrl: 'assets/images/food_maudich.png',
        title: 'Quán nướng Mậu Dịch',
        rating: 4.5),
    ImageData(
        imageUrl: 'assets/images/food_tuimo.png',
        title: 'Nhà hàng Túi Mơ',
        rating: 3.5),
    ImageData(
        imageUrl: 'assets/images/food_banhcan.png',
        title: 'Bánh Căn',
        rating: 3.5)
  ];

  final List<ImageData> _popularHome = [
    ImageData(
        imageUrl: 'assets/images/home_chaibo.png',
        title: 'Chái Bơ',
        rating: 5.0),
    ImageData(
        imageUrl: 'assets/images/home_lakehouse.png',
        title: 'Khách sạn Lakehouse',
        rating: 4.7),
    ImageData(
        imageUrl: 'assets/images/home_lalaland.png',
        title: 'Homestay Lalaland',
        rating: 5.0),
    ImageData(
        imageUrl: 'assets/images/home_lanha.png',
        title: 'Homestay Là Nhà',
        rating: 4.8),
    ImageData(
        imageUrl: 'assets/images/home_pines.png',
        title: 'Khách sạn Pines',
        rating: 4.6),
  ];

  final List<ImageData> _recommendedHome = [
    ImageData(
        imageUrl: 'assets/images/home_lanha.png',
        title: 'Homestay Là Nhà',
        rating: 4.8),
    ImageData(
        imageUrl: 'assets/images/home_chaibo.png',
        title: 'Chái Bơ',
        rating: 5.0),
    ImageData(
        imageUrl: 'assets/images/home_lalaland.png',
        title: 'Homestay Lalaland',
        rating: 5.0),
  ];

  final List<ImageData> _popularRecreation = [
    ImageData(
        imageUrl: 'assets/images/re_datanla.png',
        title: 'Thác Datanla',
        rating: 4.1),
    ImageData(
        imageUrl: 'assets/images/re_prenn.png',
        title: 'Thác Prenn',
        rating: 4.5),
    ImageData(
        imageUrl: 'assets/images/re_tuyenlam.png',
        title: 'Hồ Tuyền Lâm',
        rating: 4.0),
    ImageData(
        imageUrl: 'assets/images/re_xuanhuong.png',
        title: 'Hồ Xuân Hương',
        rating: 4.6),
  ];

  final List<ImageData> _recommendedRecreation = [
    ImageData(
        imageUrl: 'assets/images/re_tuyenlam.png',
        title: 'Hồ Tuyền Lâm',
        rating: 4.0),
    ImageData(
        imageUrl: 'assets/images/re_datanla.png',
        title: 'Thác Datanla',
        rating: 4.1),
    ImageData(
        imageUrl: 'assets/images/re_xuanhuong.png',
        title: 'Hồ Xuân Hương',
        rating: 4.6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragStart: (details) {
          initialPositionX = details.localPosition.dx;
        },
        onHorizontalDragUpdate: (details) {
          currentPositionX = details.localPosition.dx;
        },
        onHorizontalDragEnd: (details) {
          if (currentPositionX - initialPositionX != 0) {
            // Dragged towards the right
            if (currentPositionX - initialPositionX > 100) {
              Navigator.pushNamed(context, '/local-description');
            }
            if (initialPositionX - currentPositionX > 100) {
              Navigator.pushNamed(context, '/');
            }
          }
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  left: 14, top: 32, right: 14, bottom: 16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Thám hiểm',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color(0xFF436850),
                          ),
                          SizedBox(width: 2), // Adjust spacing as needed
                          Text(
                            'Lâm Đồng',
                            style: TextStyle(
                              color: Color(0xFF606060),
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF436850),
                            ),
                            onPressed: null,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Lâm Đồng',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 50,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1EFFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration.collapsed(
                                hintText: 'Tìm kiếm',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                          Icon(Icons.filter_list),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      CategoryButton(
                          label: 'Ăn uống',
                          isSelected: _selectedIndex == 1,
                          onPressed: () => _onButtonPressed(1)),
                      CategoryButton(
                          label: 'Vui chơi',
                          isSelected: _selectedIndex == 2,
                          onPressed: () => _onButtonPressed(2)),
                      CategoryButton(
                          label: 'Khách sạn',
                          isSelected: _selectedIndex == 3,
                          onPressed: () => _onButtonPressed(3)),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return SectionWidget(
                          variant: index == 0 ? 'large' : 'small',
                          title: _getSectionTitle(index),
                          dataList: _selectedIndex == 1
                              ? index == 0
                                  ? _popularFood
                                  : _recommendedFood
                              : _selectedIndex == 2
                                  ? index == 0
                                      ? _popularRecreation
                                      : _recommendedRecreation
                                  : index == 0
                                      ? _popularHome
                                      : _recommendedHome,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height / 2 - 50,
              // bottom: 0,
              child: Container(
                width: 5, // Adjust width as needed
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFB7C5AB),
                  borderRadius: BorderRadius.circular(
                      30), // Adjust the radius to round the corners
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSectionTitle(int index) {
    switch (index) {
      case 0:
        return 'Phổ biến';
      case 1:
        return 'Đề xuất';
      default:
        return 'Phổ biến';
    }
  }

  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
