-- 사용자 테이블 (권한 및 만료일 관리)
CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(50),
    role VARCHAR(20) CHECK (role IN ('resident', 'employee')), -- 입주자/직원 구분
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiry_date TIMESTAMP -- 입주자는 가입일 + 3일
);

-- 육안 하자 점검 테이블 (사진 URL 포함)
CREATE TABLE visual_defects (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(50),
    location VARCHAR(50), -- 거실, 안방
    category VARCHAR(50), -- 도배, 마루
    description TEXT, -- 찢김, 들뜸
    photo_near TEXT, -- 근거리 사진 경로
    photo_far TEXT, -- 원거리 사진 경로
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 장비 점검 로그 (공기질, 레벨기 등)
CREATE TABLE equipment_logs (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(50),
    type VARCHAR(20), -- 'air', 'level', 'thermal'
    location VARCHAR(50),
    -- 데이터 (JSON 형태로 유연하게 저장하거나 컬럼 분리)
    data_values JSONB, -- 예: {"radon": 150, "result": "확인요망"}
    measured_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

