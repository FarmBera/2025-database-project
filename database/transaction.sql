USE pjtdb;

/* =====================================================================
   Varsity-Jacket  ┃  Transaction & Procedure Demo (txn_demo.sql)
   시나리오: ❶공동구매 열기 → ❷학생들 주문 & 일부 결제 → 
            ❸판매 집계 조회 → ❹특정 학생 주문 취소
   ===================================================================== */

/***********************************************************************
트랜잭션 #1  ┃  “새 공동구매를 등록”        (INSERT 1)
필요성: 학과 대표가 조사된 과잠 정보를 기반으로 주문서를 개설
***********************************************************************/
START TRANSACTION;

INSERT INTO GroupOrders (
       order_id, title, deadline,
       order_statuses_status_code, Students_organizer_id,
       create_at, vendor
) VALUES
       (601, '2025 Fall Varsity Jacket', '2025-10-15 23:59:59',
        'OPEN', 1001, NOW(), 'Varsity Co.');

COMMIT;


/***********************************************************************
트랜잭션 #2  ┃  “조사된 과잠에 대한 학생 주문 + 일부 즉시 결제”
필요성: 여러 학생이 설문을 통해 확정된 재킷들을 구매
포함 SQL: INSERT 3, UPDATE 1   (DML 포함)
***********************************************************************/
START TRANSACTION;

-- ① 학생 1001 : Black M(90) 재킷 1벌 주문 → 즉시 카드결제
INSERT INTO order_items VALUES
  (10, 1, 79000.00, 1001, 1, 'PENDING', 601);
INSERT INTO payments VALUES
  (10, 1, 79000.00, NOW(), 2, 10);      -- 2=CREDIT
UPDATE order_items
   SET item_statuses_status_code = 'PAID'
 WHERE item_id = 10;

-- ② 학생 1002 : RoyalBlue L(100) 재킷 2벌 주문 → 나중에 현금결제 예정
INSERT INTO order_items VALUES
  (11, 2, 83000.00, 1002, 2, 'PENDING', 601);

COMMIT;


/***********************************************************************
트랜잭션 #3  ┃  “디자인별 매출 요약 조회”  (★읽기 전용★)
필요성: 관리자 대시보드에서 실시간 통계; 데이터 변경 없음
포함 SQL: GROUP BY + 집계함수 SUM
***********************************************************************/
START TRANSACTION READ ONLY;

SELECT
       pd.design_name         AS design,
       COUNT(*)               AS order_cnt,
       SUM(oi.quantity)       AS total_qty,
       SUM(oi.quantity * oi.unit_price) AS total_sales
FROM   order_items oi
JOIN   jackets       j  ON j.jacket_id  = oi.jackets_jacket_id
JOIN   patch_designs pd ON pd.design_id = j.patch_designs_design_id
WHERE  oi.GroupOrders_order_id = 601
GROUP  BY pd.design_name
ORDER  BY total_sales DESC;

COMMIT;


/***********************************************************************
트랜잭션 #4  ┃  “학생 1002 주문 취소 & 그룹주문 상태 갱신”
필요성: 마감 전 학생이 주문을 철회하는 현실적 상황
포함 SQL: DELETE 1, UPDATE 2
***********************************************************************/
START TRANSACTION;

-- ① (예: 환불 필요 없어 결제 레코드 없음)  아이템 상태 ‘CANCELLED’
UPDATE order_items
   SET item_statuses_status_code = 'CANCELLED'
 WHERE item_id = 11;

-- ② 모든 아이템이 결제/취소로 확정되면 주문서 상태 ‘CLOSED’
UPDATE GroupOrders
   SET order_statuses_status_code = 'CLOSED'
 WHERE order_id = 601
   AND NOT EXISTS (
         SELECT 1 FROM order_items
         WHERE  GroupOrders_order_id = 601
           AND  item_statuses_status_code = 'PENDING'
       );

COMMIT;


/***********************************************************************
프로시저  ┃  get_grouporder_summary(p_order_id)
필요성: 교수·학생 누구나 해당 공동구매 요약을 앱에서 조회
***********************************************************************/
DROP PROCEDURE IF EXISTS get_grouporder_summary;
DELIMITER $$
CREATE PROCEDURE get_grouporder_summary (IN p_order_id INT)
BEGIN
    SELECT
        go.title,
        s.name                     AS organizer,
        go.vendor,
        go.deadline,
        go.order_statuses_status_code AS order_status,
        COUNT(oi.item_id)          AS total_items,
        SUM(oi.quantity * oi.unit_price) AS total_amount
    FROM   GroupOrders   go
    JOIN   Students      s  ON s.student_id = go.Students_organizer_id
    LEFT JOIN order_items oi ON oi.GroupOrders_order_id = go.order_id
    WHERE  go.order_id = p_order_id
    GROUP  BY go.order_id;
END$$
DELIMITER ;

/***********************************************************************
검증용 SELECT  (캡처 제출용)
***********************************************************************/
-- ① 트랜잭션 #2 결과: 주문·결제 상태
SELECT item_id, item_statuses_status_code
FROM   order_items
WHERE  item_id IN (10,11);

-- ② 트랜잭션 #3 집계결과는 실행 시 출력됨

-- ③ 트랜잭션 #4 결과: 주문서·아이템 상태
SELECT order_id, order_statuses_status_code
FROM   GroupOrders
WHERE  order_id = 601;

SELECT item_id, item_statuses_status_code
FROM   order_items
WHERE  GroupOrders_order_id = 601;

-- ④ 프로시저 호출 예시
CALL get_grouporder_summary(601);
