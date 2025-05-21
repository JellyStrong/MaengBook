# maengBook

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 장인영 - 2025.01.08

## 구현 필요 및 에러 사항 ##

# help(1) deviceInfo.dart 파일 HiveType 내용 변경시 재빌드 하여 *.g.dart 갱신 필요
- flutter packages pub run build_runner build

# help(2)

# 앱
- hover 기능이 없는 터치기반 플랫폼은 디폴트 아이콘 보여 주기
- hive 이용 하여 접속 플랫폼 정보 조회 하고 저장
- 윈도우 컨트롤 버튼 영역을 누른 후 이동 하여 위치 조정 가능케
- 윈도우 컨트롤 버튼 '최소화','최대화' 개발 필요
- 색상 테마 또는 사진(시간 변화에 따른 이미지 변환) 적용

# 계산기
- 계산 우선 순위 적용 안됌 (괄호 > 덧셈,나눗셈 > 더하기,빼기)
- 부동 소수점 정밀도 오류 / 근시 값으로 보여 주기 때문에 계산에 오차 발생함
- Clean, AllClean 추가 기능 분리

# 사진 (개발 예정)

- 접속 플랫폼의 화면 사이즈와 사진 사이즈를 비교하여 최적의 크기로 사진 띄어 주기


