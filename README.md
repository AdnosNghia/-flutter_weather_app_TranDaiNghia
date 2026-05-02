# Flutter Weather App

Ứng dụng thời tiết sử dụng Flutter và OpenWeatherMap API.
Lab 4 - Trần Đại Nghĩa

## Mô tả dự án

App hiển thị thông tin thời tiết theo thời gian thực, hỗ trợ dự báo 5 ngày, tìm kiếm thành phố, lưu cache offline và tùy chỉnh cài đặt.

### Tính năng chính

- Thời tiết hiện tại: nhiệt độ, độ ẩm, gió, áp suất, tầm nhìn, bình minh/hoàng hôn
- Tự động lấy vị trí GPS
- Tìm kiếm thành phố, lưu lịch sử tìm kiếm và thành phố yêu thích (tối đa 5)
- Dự báo theo giờ và theo ngày (5 ngày)
- Hỗ trợ ngoại tuyến: lưu cache, hiển thị dữ liệu cũ khi mất mạng, cảnh báo dữ liệu lỗi thời
- Cài đặt: đơn vị nhiệt độ (°C/°F), tốc độ gió (m/s, km/h, mph), định dạng giờ (12h/24h)
- Lựa chọn ngôn ngữ: Tiếng Việt / English
- Gradient nền thay đổi theo điều kiện thời tiết và thời gian trong ngày

## Thiết lập API

1. Đăng ký tài khoản miễn phí tại [OpenWeatherMap](https://openweathermap.org/api)
2. Lấy API Key từ trang [API Keys](https://home.openweathermap.org/api_keys)
3. Copy file `.env.example` thành `.env`
4. Mở file `.env` và thay `your_api_key_here` bằng API Key của bạn:
```
OPENWEATHER_API_KEY=your_actual_api_key
```

**QUAN TRỌNG: File `.env` chứa khóa API và đã được thêm vào `.gitignore`. Nên theo yêu cầu em hk có up lên đây**

## Ảnh chụp màn hình

- Màn hình thời tiết
  <img width="867" height="1888" alt="image" src="https://github.com/user-attachments/assets/9ef0b98e-7389-4030-8eb5-14b83c28258a" />

- Dự báo theo giờ và theo ngày
<img width="867" height="1888" alt="image" src="https://github.com/user-attachments/assets/bffa038c-e9cb-4025-ad3f-9f6b4e217ea4" />

- Thông tin chi tiết
<img width="867" height="1888" alt="image" src="https://github.com/user-attachments/assets/36a1184a-ca5f-47e9-9817-5c65609019d7" />

- Màn hình cài đặt
<img width="867" height="1888" alt="image" src="https://github.com/user-attachments/assets/d194edec-fb57-4c85-acd3-2ed85921b39f" />

- Chuyển đổi ngôn ngữ 
<img width="867" height="1888" alt="image" src="https://github.com/user-attachments/assets/01953ced-b213-4c74-ab27-9f46664a929a" />

- Tìm kiếm thành phố(gồm lịch sử và thành phố yêu thích)
<img width="867" height="1888" alt="image" src="https://github.com/user-attachments/assets/d4ec640d-a3fc-40a1-a4ae-e4cbdf2b6684" />


## Cách chạy dự án

Yêu cầu:
- Flutter SDK >= 3.10.4
- Android Studio/VS Code
- Thiết bị Android (thật hoặc giả lập)

```bash
# clone repo
git clone https://github.com/adnosnghia/flutter_weather_app_trandainghia.git
cd flutter_weather_app_trandainghia

# cài dependencies
flutter pub get

# tạo file .env (xem mục Thiết lập API)
cp .env.example .env

# chạy app
flutter run
```

## Cấu trúc dự án

```
lib/
├── main.dart
├── config/
│   └── api_config.dart
├── models/
│   ├── weather_model.dart
│   └── forecast_model.dart
├── providers/
│   ├── weather_provider.dart
│   └── settings_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── forecast_screen.dart
│   └── settings_screen.dart
├── services/
│   ├── weather_service.dart
│   ├── location_service.dart
│   ├── storage_service.dart
│   └── connectivity_service.dart
├── utils/
│   ├── constants.dart
│   └── weather_utils.dart
└── widgets/
    ├── current_weather_card.dart
    ├── hourly_forecast_list.dart
    ├── daily_forecast_card.dart
    ├── weather_detail_item.dart
    ├── loading_shimmer.dart
    └── weather_error_widget.dart
```

## Công nghệ sử dụng

- Flutter - framework UI
- Provider - quản lý state
- http - gọi REST API
- geolocator - lấy vị trí GPS
- geocoding - chuyển tọa độ thành tên thành phố
- shared_preferences - lưu trữ cục bộ (cache, cài đặt)
- cached_network_image - cache icon thời tiết
- flutter_dotenv - quản lý biến môi trường (.env)
- connectivity_plus - kiểm tra trạng thái kết nối mạng
- intl - format ngày giờ đa ngôn ngữ

## Hạn chế đã biết

- API miễn phí giới hạn 60 request/phút
- Dự báo chỉ có mỗi 3 giờ (giới hạn của gói free)
- Tên thành phố Việt Nam đôi khi hiển thị không dấu (do API trả về)
- Cần bật GPS để lấy vị trí, chưa có fallback bằng IP
- Lưu offline chỉ lưu 1 thành phố gần nhất

## Cải tiến trong tương lai

- Thêm widget thời tiết cho màn hình chính Android
- Hỗ trợ thông báo đẩy khi thời tiết thay đổi
- Thêm biểu đồ nhiệt độ theo tuần
- Cache nhiều thành phố cùng lúc
- Dark mode / Light mode
- Tích hợp bản đồ thời tiết

## License

Sinh viên: Trần Đại Nghĩa
