-- stored Procedures
USE `amakalu`;
DROP PROCEDURE IF EXISTS `product_by_id_no`;

DELIMITER $$
CREATE PROCEDURE product_by_id_no(IN p_ProductID INT)
BEGIN
	SELECT * 
    FROM products
    WHERE ProductID = p_ProductID;
END$$

DELIMITER ;

CALL product_by_id_no(5)
	


