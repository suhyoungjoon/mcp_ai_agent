from reportlab.lib.pagesizes import letter, A4
from reportlab.pdfgen import canvas
from reportlab.lib.units import inch
from datetime import datetime

def generate_report(user_id: str, defects: list, equipment_logs: list, output_path: str = "report.pdf"):
    """
    점검 보고서 PDF 생성 함수
    
    Args:
        user_id: 사용자 ID
        defects: 육안 점검 하자 리스트
        equipment_logs: 장비 점검 로그 리스트
        output_path: 출력 파일 경로
    """
    c = canvas.Canvas(output_path, pagesize=A4)
    width, height = A4
    
    # 제목
    c.setFont("Helvetica-Bold", 20)
    c.drawString(50, height - 50, "인싸이트 아이 점검 보고서")
    
    # 날짜
    c.setFont("Helvetica", 12)
    c.drawString(50, height - 80, f"생성일: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    c.drawString(50, height - 100, f"사용자 ID: {user_id}")
    
    # 육안 점검 섹션
    y_pos = height - 140
    c.setFont("Helvetica-Bold", 14)
    c.drawString(50, y_pos, "육안 점검 결과")
    
    y_pos -= 30
    c.setFont("Helvetica", 10)
    for defect in defects:
        if y_pos < 100:
            c.showPage()
            y_pos = height - 50
        c.drawString(70, y_pos, f"위치: {defect.get('location', 'N/A')}")
        y_pos -= 20
        c.drawString(70, y_pos, f"카테고리: {defect.get('category', 'N/A')}")
        y_pos -= 20
        c.drawString(70, y_pos, f"설명: {defect.get('description', 'N/A')}")
        y_pos -= 30
    
    # 장비 점검 섹션
    if y_pos < 150:
        c.showPage()
        y_pos = height - 50
    
    c.setFont("Helvetica-Bold", 14)
    c.drawString(50, y_pos, "장비 점검 결과")
    
    y_pos -= 30
    c.setFont("Helvetica", 10)
    for log in equipment_logs:
        if y_pos < 100:
            c.showPage()
            y_pos = height - 50
        c.drawString(70, y_pos, f"타입: {log.get('type', 'N/A')}")
        y_pos -= 20
        c.drawString(70, y_pos, f"위치: {log.get('location', 'N/A')}")
        y_pos -= 20
        c.drawString(70, y_pos, f"결과: {log.get('status', 'N/A')}")
        y_pos -= 30
    
    c.save()
    return output_path

