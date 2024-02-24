import 'package:flutter/material.dart';
import 'package:app/src/location_pages/location_home_page.dart';

class LocationDescription extends StatefulWidget {
  const LocationDescription({super.key});

  @override
  _LocationDescriptionState createState() => _LocationDescriptionState();
}

class _LocationDescriptionState extends State<LocationDescription> {
  late double initialPositionX;
  late double currentPositionX;

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
          if (initialPositionX - currentPositionX > 0) {
            // Dragged towards the right
            if (initialPositionX - currentPositionX > 100) {
              // Adjust the threshold for a more accurate swipe
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocationHome()),
              );
            }
          }
        },
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.only(left: 14, top: 36, right: 14, bottom: 16),
                color: const Color(0xFFB7C5AB),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/re_tuyenlam.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: 300,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'ĐÀ LẠT',
                          style: TextStyle(
                            color: Color(0xFF12372A),
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '50217',
                              style: TextStyle(
                                color: Color(0xFF12372A),
                                fontSize: 18,
                              ),
                            ),
                            Icon(
                              Icons.luggage,
                              color: Color(0xFF12372A),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Text(
                      'Về địa điểm',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'Đà Lạt là thủ phủ của tỉnh Lâm Đồng. Với độ cao 1.500 m trên mặt nước biển, tiết trời Đà Lạt mát lạnh, là nơi nghỉ dưỡng lý tưởng ở khu vực miền Nam. Từng một thời nổi tiếng với các điểm tham quan như Thung Lũng Tình Yêu, Hồ Than Thở, Đồi Thông Hai Mộ, Thác Voi',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      'Bạn nên thử',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'Bên cạnh các cảnh đẹp nên thơ hữu tình, Đà Lạt còn là một nơi vui chơi đầy ý nghĩa. Bạn có thể bắt đầu một buổi sáng bằng một tách cà phề tại Đồi chè Cầu Đất ngắm nhìn những đám mây trôi lửng lơ ngay tầm mắt. Và đến tối, cùng nắm tay nhau dạo xung quang hồ Hồ Xuân Hương cùng với cốc sữa đậu béo thơm, nhâm nhi những chiếc bánh tráng nướng trong lúc thả trôi tâm trí trên mặt hồ tĩnh lặng',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 2 - 50,
              // bottom: 0,
              child: Container(
                width: 5, // Adjust width as needed
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30), // Adjust the radius to round the corners
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
