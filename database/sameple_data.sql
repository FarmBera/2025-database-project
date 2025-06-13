/* =====================================================================
   Varsity-Jacket 샘플 데이터 삽입 스크립트  (sample_data.sql, fixed)
   ===================================================================== */

/*----------------------------------------------------------------------
0.  코드 테이블 값  — 이미 있으면 무시
----------------------------------------------------------------------*/
INSERT IGNORE INTO order_statuses (status_code)
VALUES ('OPEN'), ('CLOSED'), ('CANCELLED');

INSERT IGNORE INTO item_statuses (status_code)
VALUES ('PENDING'), ('PAID'), ('DELIVERED'), ('CANCELLED');

INSERT IGNORE INTO payment_methods (method_code)
VALUES (1), (2), (3);   -- 1:CASH 2:CREDIT 3:TRANSFER

/*----------------------------------------------------------------------
1.  마스터 데이터 (Students, 옵션)  — 값이 있으면 PK 충돌 나므로 번호 바꾸거나 생략
----------------------------------------------------------------------*/
INSERT IGNORE INTO Students (student_id, department, name, email, phone) VALUES
  (1001, 'Computer Eng', '홍길동',  'hong@univ.ac.kr', '010-1111-2222'),
  (1002, 'Design',       '김서연', 'kim@univ.ac.kr',  '010-3333-4444'),
  (1003, 'Economics' , '이로훈', 'rohung@univ.ac.kr', '010-5555-6666'),
  (1004, 'Clinical Pathology Department', '이시연', 'siyeoun@univ.ac.kr','010-7777,8888'),
  (1005, 'dentistry','김소훈', 'sohun@univ.ac.kr','010-5543-7842'),
  (1006, 'electrical electronics', '손지현', 'Jihyun@univ.ac.kr','010-3472-8543'),
  (1007, 'Child Education','김시은', 'sieun@univ.ac.kr','010-7845-4689'),
  (1008, 'Law','최솔음','Soleum@univ.ac.kr','010-2349-7845'),
  (1009, 'Philosophy','나천재','geius@univ.ac.kr','010-8356-7842'),
  (1010, 'Public Health' ,'이소은','soeun@univ.ac.kr','010-7821-1549');
  

INSERT IGNORE INTO jacket_colors (color_id, color_name)
VALUES (1, 'Black'), (2, 'RoyalBlue');

INSERT IGNORE INTO jacket_sizes (size_id, size_label)
VALUES (1, '90'), (2, '100');

INSERT IGNORE INTO patch_designs (design_id, design_name)
VALUES (1, 'Sleeve Patch'), (2, 'Back Patch');

INSERT IGNORE INTO jackets (
    jacket_id, base_price, jacket_colors_color_id,
    jacket_sizes_size_id, patch_designs_design_id
) VALUES
  (1, 79000, 1, 1, 1),
  (2, 83000, 2, 2, 2);

/*----------------------------------------------------------------------
2.  공동주문 헤더  — PK(501)가 이미 있으면 번호를 바꾸거나 생략
----------------------------------------------------------------------*/
INSERT IGNORE INTO GroupOrders (
    order_id, title, deadline,
    order_statuses_status_code, Students_organizer_id, create_at, vendor
) VALUES
  (501, '2025 Spring Jackets', '2025-06-30 23:59:59',
   'OPEN', 1001, NOW(), 'Varsity Co.');

/*----------------------------------------------------------------------
3.  주문 아이템
----------------------------------------------------------------------*/
INSERT IGNORE INTO order_items (
    item_id, quantity, unit_price,
    Students_student_id, jackets_jacket_id,
    item_statuses_status_code, GroupOrders_order_id
) VALUES
  (1, 2, 85000, 1001, 1, 'PENDING', 501),
  (2, 1, 83000, 1002, 2, 'PENDING', 501);

/*----------------------------------------------------------------------
4.  결제
----------------------------------------------------------------------*/
-- 컬럼 목록 앞의 S 제거, 금액 소수점 둘째자리 맞추기
INSERT IGNORE INTO payments (
    payment_id, installment_no, amount, paid_at,
    payment_methods_method_code, order_items_item_id
) VALUES
  (1, 1, 170000.00, NOW(), 2, 1);

/*----------------------------------------------------------------------
5.  확인용 SELECT
----------------------------------------------------------------------*/
SELECT * FROM vw_order_summary;
