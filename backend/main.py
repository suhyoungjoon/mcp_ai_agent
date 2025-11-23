from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime, timedelta
import random  # DB 대용 (실제론 SQL 연결 필요)

app = FastAPI(title="Insight Eye Server")

# CORS 설정 (Flutter 앱과 통신을 위해)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- 데이터 모델 ---
class LoginRequest(BaseModel):
    user_id: str
    role: str  # 'resident' or 'employee'

class EquipmentData(BaseModel):
    user_id: str
    type: str  # 'level', 'air'
    location: str
    val1: float  # 레벨기:좌측, 공기질:라돈
    val2: float  # 레벨기:우측, 공기질:TVOC

# --- 1. 권한 및 3일 제한 체크 ---
@app.post("/login")
def login(req: LoginRequest):
    # 실제 구현 시: DB에서 user_id 조회 후 created_at 비교
    # 여기서는 가상 로직: 입주자는 항상 2일 남았다고 가정
    if req.role == 'resident':
        # 3일 제한 로직 예시
        # if (now - created_at).days > 3: return {"allow": False, "msg": "만료됨"}
        return {
            "allow": True,
            "msg": "입주를 환영합니다! 점검 기간이 3일 남았습니다.",
            "days_left": 3
        }
    else:
        return {"allow": True, "msg": "직원 모드로 접속합니다."}

# --- 2. 장비 데이터 분석 및 저장 ---
@app.post("/analyze_equipment")
def analyze_equipment(data: EquipmentData):
    result = "정상"
    msg = ""

    # 레벨기(수평) 분석: 차이가 3mm 이상이면 불량
    if data.type == 'level':
        diff = abs(data.val1 - data.val2)
        if diff >= 3.0:
            result = "확인요망"
            msg = f"좌우 차이 {diff}mm (기준 초과)"
        else:
            msg = f"좌우 차이 {diff}mm (정상)"

    # 공기질(라돈) 분석: 148 Bq/m³ 이상이면 불량
    elif data.type == 'air':
        if data.val1 > 148.0:
            result = "확인요망"
            msg = f"라돈 수치({data.val1}) 권고 기준 초과!"
        else:
            msg = "공기질 안전 수치 내"

    # TODO: DB 저장 로직 (INSERT INTO equipment_logs ...)

    return {"status": result, "message": msg}

@app.get("/")
def root():
    return {"message": "Insight Eye Server is running"}

# 실행 명령: uvicorn main:app --reload

