# 인싸이트 아이 (Insight Eye) 프로젝트

입주자 점검 및 직원 장비 점검을 위한 모바일 앱 및 백엔드 서버 프로젝트입니다.

## 프로젝트 구조

```
insight_eye_project/
├── backend/              # Python FastAPI 서버
│   ├── main.py          # 핵심 로직 & API 서버
│   ├── report_generator.py  # PDF 생성 모듈
│   └── requirements.txt # 필요 라이브러리
├── frontend/            # Flutter 앱
│   ├── lib/
│   │   ├── main.dart    # 앱 시작점
│   │   ├── api_service.dart  # 서버 통신
│   │   └── screens/
│   │       ├── login_screen.dart      # 로그인 & 권한분기
│   │       ├── resident_home.dart     # 입주자: 육안점검
│   │       └── employee_home.dart     # 직원: 장비점검
│   └── pubspec.yaml     # 앱 설정
└── database/            # 데이터베이스
    └── schema.sql       # DB 테이블 생성 쿼리
```

## 주요 기능

1. **입주자 모드**
   - 3일 제한 점검 기간
   - 육안 점검 및 사진 촬영

2. **직원 모드**
   - 공기질 측정 (라돈, TVOC)
   - 레벨기 측정 (수평 점검)
   - 자동 판정 기능 (라돈 148 Bq/m³ 이상, 수평 차이 3mm 이상 기준)

## 실행 방법

### 1. Backend 실행

```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
```

서버는 `http://127.0.0.1:8000`에서 실행됩니다.

### 2. Frontend 실행

```bash
cd frontend
flutter pub get
flutter run
```

### 3. 데이터베이스 설정 (선택사항)

PostgreSQL을 사용하는 경우:

```bash
psql -U postgres -d insight_eye
\i database/schema.sql
```

## API 엔드포인트

- `POST /login` - 로그인 및 권한 확인
- `POST /analyze_equipment` - 장비 데이터 분석 및 저장
- `GET /` - 서버 상태 확인

## 기술 스택

- **Backend**: Python, FastAPI, Uvicorn
- **Frontend**: Flutter, Dart
- **Database**: PostgreSQL (선택사항)

## 개발 참고사항

- 현재는 메모리 기반으로 동작하며, 실제 DB 연결은 TODO로 남겨두었습니다.
- Flutter 앱에서 서버에 접속하려면 `api_service.dart`의 `baseUrl`을 실제 서버 주소로 변경해야 합니다.
- Android 에뮬레이터에서 로컬 서버 접속 시 `127.0.0.1` 대신 `10.0.2.2`를 사용해야 합니다.

