/*───────────────────────────────
(4) 인덱스 & 뷰
───────────────────────────────*/
-- 학생별 주문 항목 검색이 잦다고 가정한 보조 인덱스
CREATE INDEX idx_order_items_student ON order_items (student_id);

-- 주문별 총액을 빠르게 조회하기 위한 집계 뷰
CREATE VIEW v_order_totals AS
SELECT oi.order_id, SUM(oi.quantity * oi.unit_price) AS total_amount, COUNT(*) AS item_cnt
FROM order_items oi
GROUP BY
    oi.order_id;