/*====================================================================
(7) 별도 프로시저 1개
====================================================================*/
DELIMITER //

CREATE PROCEDURE sp_register_payment
(
    IN p_item_id      INT,
    IN p_amount       DECIMAL(10,2),
    IN p_method_code  VARCHAR(20)
)
BEGIN
    /* 결제와 상태 변경을 캡슐화하여
       애플리케이션이 트랜잭션을 직접 다루지 않아도 되게 함 */
    START TRANSACTION;
        INSERT INTO payments (item_id, installment_no, amount, method_code)
        VALUES (p_item_id, 1, p_amount, p_method_code);

        UPDATE order_items
        SET    status_code = 'PAID'
        WHERE  item_id = p_item_id;
    COMMIT;
END
//

DELIMITER ;
